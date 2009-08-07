From: Victor Grishchenko <victor.grishchenko@gmail.com>
Subject: binmaps: any useful?
Date: Fri, 7 Aug 2009 13:46:00 +0200
Message-ID: <771E82FC-F0AD-440F-99BD-8B528C30DE25@gmail.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I spotted the recent Btrfs changes related to free space
tracking and I am interested whether one datastracture I
came up with might be of any help. It is named a "binmap",
basically a hybrid of a bitmap and a binary tree. It is
useful for holding well-aggregatable bitmaps with long
extents of zeros or ones.

More on binmaps.

A ``binmap'' is a binary tree consisting of (say) 32-bit
cells, each made of two 16-bit halves. Each half is either a
bitmap of layer L or an index pointing to a cell at layer
L-1.  ``Layer'' of a bitmap means that every bit stands for
an aligned 2**L-long base bit range (i.e. range in a virtual
plain bitmap storing the same data). Layer 0 is the base
layer. If a two-bitmap cell looks like
     11001111 00110000 11111100 00000000
then it is immediately aggregated to a L+1 layer half
     10110100 1110 0000
Thus, long ranges of zeros or ones stay well aggregated into
logarithmic bins. E.g. considering the file system, if in
some area the space is taken consistently in multiplies of
4MB (aligned), a binmap for that area will not be more
detailed than 1 bit for 4MB, plus another bit of overhead.

In the worst case of 1010101010... binmap, the overhead,
compared to a plain bitmap, is 100%. Obviously, a red-black
tree is much worse off in such a case, at least 32 to 2 even
without the overhead. So, a binmap combines logarithmical
access time of a tree and space efficiency of a bitmap.

Note on memory layout. A binmap is naturally hosted in a
plain integer vector, up to 2**16 cells. To adapt to paged
storage and also to extend the maximum size of a tree, a
binmap might be chunked, i.e. subtrees might be hosted at
different vectors/chunks. By sacrificing one bit of an
offset-carrying half, we point either at a child cell or to
another vector/chunk, where the child cell is a root. Thus,
we extend the datastructure to 2**30 cells at most.

Note on possibilities. There is an interesting possibility
of doing bitwise operations with binmaps. The computational
complexity is O(N+M) where N and M are sizes of respective
binmaps. It is also possible to associate a k-bit integer
with every range by employing k binmaps; arithmetic
operations on such sets are also possible. Probably, things
become too complex at this point.

Note on prior art. The Mondrian memory protection system
used somewhat similar approach of three-layer bitmaps plus
misc stunts. The current btrfs approach, as I see, tapes
together red-black trees and bitmaps.

-- 

     Victor Grishchenko
     post-doc, TU Delft
-- 

		V

