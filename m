From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] initial version of reference cache
Date: Fri, 25 Jul 2008 23:38:37 +0000
Message-ID: <1217029117.7572.84.camel@think.oraclecorp.com>
References: <21782573.1217014155193.JavaMail.oracle@acsmt304.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <21782573.1217014155193.JavaMail.oracle@acsmt304.oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-07-25 at 14:29 -0500, Yan Zheng wrote:
> Hello,
> 
> This is the initial version of leaf reference cache. The cache stores leaf node's extent references in memory, this can improve the performance of snapshot dropping. Outlines of this patch are (1) allocate struct dirty_root when starting transaction (2) put reference cache in struct dirty_root (3) cache extent references when tree leaves are cow'ed (4) when dropping snapshot, use cached references directly to avoid reading tree leaf. 
> 
> I only can access a notebook currenly, so benchmarking isn't enough. I appreciate any help and comment.
> 

I have modified this locally to always cache leaves, even when they
don't have file extents in them.  That way, walk_down_tree will find the
cache and won't have to read the leaf (that doesn't have any extents).

So far, it is working very well.  I did a run with fs_mark to create 58
million files and had very steady numbers.  The unmount took 4 seconds.
It used to take over an hour.

One question, why not use the block number (byte number) as the key to
the rbtree instead of the key?

-chris


