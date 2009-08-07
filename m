From: "Oliver Mattos" <oliver.mattos08@imperial.ac.uk>
Subject: Re: binmaps: any useful?
Date: Fri, 7 Aug 2009 17:44:15 +0100
Message-ID: <4453A524390F46E6A738629C45E7551E@home.omattos.com>
References: <771E82FC-F0AD-440F-99BD-8B528C30DE25@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
To: "Victor Grishchenko" <victor.grishchenko@gmail.com>,
	<linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <771E82FC-F0AD-440F-99BD-8B528C30DE25@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Seems like this could be useful for searching for free space chunks as well.

If you're looking for a chunk of free space aligned on a chunksize boundary 
(which btrfs prefers if I'm not mistaken), then searching this tree would be 
much faster than searching a bitmap, particularly when what you're looking 
for is rare or large.  (ie. when there is only one suitable free space on 
the disk, an algorithm that searches this tree will find it way faster than 
a bitmap, both in terms of CPU time and amount of the tree that needs to be 
read.

Has any profiling been done regarding how much time is currently spent 
allocating extents?  I assume having a better algorithm for this allows a 
more "ideal" place to be found rather than just the first match, which 
should increase read performance and reduce fragmentation as well.



----- Original Message ----- 
From: "Victor Grishchenko" <victor.grishchenko@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Sent: Friday, August 07, 2009 12:46 PM
Subject: binmaps: any useful?


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

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

