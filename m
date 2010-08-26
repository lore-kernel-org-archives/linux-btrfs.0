From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor creat/delete files performance
Date: Thu, 26 Aug 2010 19:15:39 -0400
Message-ID: <20100826231539.GB14190@think>
References: <4C6BB21E.3000809@cn.fujitsu.com>
 <20100818120941.GM5854@think>
 <4C6C7C46.2000202@cn.fujitsu.com>
 <20100819005743.GH5854@think>
 <4C763CFB.6010600@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yan Zheng <zheng.yan@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C763CFB.6010600@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 26, 2010 at 06:07:55PM +0800, Miao Xie wrote:
> On Wed, 18 Aug 2010 20:57:43 -0400, Chris Mason wrote:
> >Since the files are empty, and we aren't doing enough files to trigger
> >IO, it is really benchmarking the cost of the btree insertions/removals
> >in comparison with ext4.  I do expect this to be higher because btrfs is
> >indexing the directories twice (once by name and once by sequence number
> >for faster backups).
> >
> >On my machine:
> >
> >Btrfs defaults:
> >
> >Create files:
> >	Total files: 50000
> >	Total time: 0.916680
> >	Average time: 0.000018
> >Delete files:
> >	Total files: 50000
> >	Total time: 1.329892
> >	Average time: 0.000027
> >
> >Ext4:
> >
> >creat_unlink 50000
> >Create files:
> >	Total files: 50000
> >	Total time: 0.718190
> >	Average time: 0.000014
> >Delete files:
> >	Total files: 50000
> >	Total time: 0.308815
> >	Average time: 0.000006
> >
> >We're definitely slower than ext4, but as Ric's benchmarks show things
> >tend to tilt in our favor once IO is actually done.
> >
> >There are two big things that would help fix this performance gap:
> >Switching the extent buffer rbtree into a radix tree (esp a lockless
> >radix tree), and delaying insertion of the inode so that we can do more
> >in btree operations in bulk.
> >
> >The radix tree is a much easier and more contained project.
> 
> The type of the radix tree's key is "unsigned long", but the type of the
> extent buffer's key is "u64". That is we can't use the radix tree instead of
> rbtree on the 32-bits boxs. So we can't switching the extent buffer rbtree
> into a radix tree.

Right, but the key is just the byte number offset from 0.  The extent
buffers are backed by pages, and the pages are allocated off the
metadata inode's address space, which is backed by a radix tree.

You can try using the (bytes offset >> PAGE_CACHE_SHIFT).  The problem
you might hit is the radix tree is tuned pretty hard now for the page
cache.

Another option is to attach the extent buffers to page->private, and use
the page cache's radix tree (remove the rbtree completely).  For
blocksize > pagesize, we could only put the first page in each block
into the page cache, and just tie the rest of the off the extent buffer.

But, if you get the 4K metadata block size part working, I can cram in
the larger block sizes pretty easily now.

-chris

