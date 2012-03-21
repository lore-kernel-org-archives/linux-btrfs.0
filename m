From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [RFC PATCH 0/5] apply rwlock for extent state
Date: Wed, 21 Mar 2012 10:52:18 +0800
Message-ID: <4F694262.6050409@cn.fujitsu.com>
References: <1331802737-29454-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, Arne Jansen <sensille@gmx.net>,
	David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1331802737-29454-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Any comments?

On 03/15/2012 05:12 PM, Liu Bo wrote:
> This patchset is against one of project ideas, RBtree lock contention:
> "Btrfs uses a number of rbtrees to index in-memory data structures.
> Some of these are dominated by reads, and the lock contention from searching
> them is showing up in profiles.  We need to look into an RCU and sequence
> counter combination to allow lockless reads."
> 
> The goal is to use RCU, but we take it as a long term one, and instead we use
> rwlock until we find a mature rcu structure for lockless read.
> 
> So what we need to do is to make the code RCU friendly, and the idea mainly
> comes from Chris Mason:
> Quoted:
> "I think the extent_state code can be much more RCU friendly if we separate
> the operations on the tree from operations on the individual state.
> In general, we can gain a lot of performance if we are able to reduce
> the write locks taken at endio time.  Especially for reads, these are
> critical."
> 
> If we read a 10M file with pagecache,
> $ dd if=/mnt/btrfs/foobar of=/dev/null bs=1M
> 
> without this patchset,
>         lock for read : lock for write ~= 2:1
> with this patchset,
>         lock for read : lock for write ~= 200:1
> 
> I've run through xfstests, and no bugs jump out by then.
> MORE TESTS ARE WELCOME!
> 
> 
> Liu Bo (5):
>   Btrfs: use radix tree for checksum
>   Btrfs: merge adjacent states as much as possible
>   Btrfs: use large extent range for read and its endio
>   Btrfs: apply rwlock for extent state
>   Btrfs: avoid splitting state when truncating pagecache
> 
>  fs/btrfs/extent_io.c        |  768 +++++++++++++++++++++++++++++++++----------
>  fs/btrfs/extent_io.h        |    5 +-
>  fs/btrfs/free-space-cache.c |    5 +
>  fs/btrfs/inode.c            |   22 +-
>  4 files changed, 614 insertions(+), 186 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

