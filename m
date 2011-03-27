From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: Re: [PATCH V5 2/2] btrfs: implement delayed inode items operation
Date: Sun, 27 Mar 2011 20:09:10 +0900
Message-ID: <20110327200910.021b545b.kitayama@cl.bb4u.ne.jp>
References: <4D8B2DEB.1000001@cn.fujitsu.com>
	<20110327143055.ae2d3c68.kitayama@cl.bb4u.ne.jp>
	<4D8EE070.6000700@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>, David Sterba <dave@jikos.cz>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D8EE070.6000700@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

On Sun, 27 Mar 2011 15:00:00 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> I got it. It is because the allocation flag of the metadata's page cache, which is stored in
> the btree inode's i_mapping, was set to be GFP_HIGHUSER_MOVABLE. So if we allocate pages for
> btree's page cache, this lockdep warning will be triggered.
> 
> I think even without my patch, this lockdep warning can also be triggered, btrfs_evict_inode()
> do the similar operations like what I do in the btrfs_destroy_inode(). 
>   Task1					Kswap0 task
>   open()
>     ...
>     btrfs_search_slot()
>       ...
>       btrfs_cow_block()
> 	...
> 	alloc_page()
> 	  wait for reclaiming
> 					shrink_slab()
> 					  ...
> 					  shrink_icache_memory()
> 					    ...
> 					    btrfs_evict_inode()
> 					      ...
> 					      btrfs_search_slot()
> 
> If the path is locked by task1, the deadlock happens.

Ok. balance_pgdat() calls shrink_slab() with GFP_KERNEL so it's still possible for the kswapd0 
to call prune_icache(), no? I still see the lockdep warning even with your patch that clears
__GFP_FS in open_ctree().

itaru

