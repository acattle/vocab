
from libcpp.vector cimport vector
from libcpp.set cimport set as cset
from libcpp.string cimport string
from libcpp.unordered_map cimport unordered_map
from libc.stdint cimport uint32_t
from libcpp cimport bool

cimport numpy as np

ctypedef unordered_map[string, uint32_t] vocab_ngram_t
ctypedef vector[vocab_ngram_t] vocab_t
ctypedef cset[string] stopwords_t

# wrapper for the C++ Vocab class
cdef extern from "cvocab.cc":
    cdef cppclass Vocab:
        Vocab(vocab_t, stopwords_t) except +
        Vocab() except +
        void group_ngrams(vector[string] &, vector[string] &, bool)
        void accumulate(vector[string] &)
        void update(uint32_t, uint32_t, uint32_t)
        void save(bool keep_unigram_stopwords)
        uint32_t get_word2id(string)
        string get_id2word(size_t)
        uint32_t get_id2count(size_t)
        uint32_t size()
        void add_ngram(string, size_t)


cdef class Vocabulary:
    cdef Vocab *_vocabptr
    cdef np.ndarray _table
    cdef object _stopwords
    cdef object _tokenizer
    cdef object _lookup_table
    cdef readonly np.ndarray counts
    cdef bool is_stopword

