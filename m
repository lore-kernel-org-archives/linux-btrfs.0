From: Chris Mason <chris.mason@oracle.com>
Subject: Re: the idea for improving the performance of b-tree search
Date: Wed, 13 Oct 2010 07:24:45 -0400
Message-ID: <20101013112445.GP22691@think>
References: <4CB57548.7000304@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CB57548.7000304@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 13, 2010 at 05:00:56PM +0800, Miao Xie wrote:
> Hi, Chris
> 
> When I investigated the performance problem of file creation/deletion, I found
> btrfs spends lots of time in the b-tree search, so I consider whether we can use
> the latest search result in the same transaction or not.
> 
> My idea follows:
> we can add mask or time stamp into b-tree's node and leaf, then we know whether
> the node/leaf is COWed by the other task. If not, we check if the node/leaf of
> the latest search result contains the key that we want to search. By this way,
> we can reuse the latest search result in the same transaction and reduce the CPU
> time spent in the b-tree search.
> 
> Chris, how do you think about it?

Do your results show which btree searches are happening most often?  My
impression is that we are usually searching for inodes, and I see 3
different optimizations that are likely to help:

1) cache the block number of the leaf where the inode lives in the
inode, or perhaps the whole path down from the root.

2) Do delayed insertion.  Each time we create a file we do a
number of btree insertions.  One for the inode+name backrefs,
one for any xattrs, two for the directory entries, one for the directory
inode update.

The directory name index is especially CPU intensive because it goes in
hash order, which will mean a lot of btree balances.

Batching these insertions, even in groups of 4 or 8 will make a big
difference.

3) Do delayed inode deletion.  See above, but change the word insert
with delete ;)

-chris
