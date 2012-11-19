Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ye0-f174.google.com ([209.85.213.174]:34224 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab2KSQ7e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Nov 2012 11:59:34 -0500
Received: by mail-ye0-f174.google.com with SMTP id m12so904582yen.19
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2012 08:59:33 -0800 (PST)
Date: Mon, 19 Nov 2012 14:59:20 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: btrfs crash - Null dereference - 3.7.0-rc5-00068-gc5e35d6
Message-ID: <20121119165920.GA12996@joana>
References: <20121119025540.GA3858@joana>
 <20121119103221.GA8810@gmail.com>
 <20121119130752.GA3457@joana>
 <20121119152751.GB8810@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121119152751.GB8810@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

* Liu Bo <bo.li.liu@oracle.com> [2012-11-19 23:27:53 +0800]:

> On Mon, Nov 19, 2012 at 11:07:52AM -0200, Gustavo Padovan wrote:
> > > can you please run
> > > 'gdb fs/btrfs/btrfs.ko' and 'list *block_rsv_release_bytes+0x21' to
> > > check which one is NULL pointer?
> > 
> > 
> > (gdb) list *block_rsv_release_bytes+0x21
> > 0xffffffff811a83c1 is in block_rsv_release_bytes
> > (fs/btrfs/extent-tree.c:4065).
> > 4060	
> > 4061	static void block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
> > 4062					    struct btrfs_block_rsv *block_rsv,
> > 4063					    struct btrfs_block_rsv *dest, u64
> > num_bytes)
> > 4064	{
> > 4065		struct btrfs_space_info *space_info = block_rsv->space_info;
> > 4066	
> > 4067		spin_lock(&block_rsv->lock);
> > 4068		if (num_bytes == (u64)-1)
> > 4069			num_bytes = block_rsv->size;
> > (gdb) 
> > 
> > Seems block_rsv is NULL here and looking to btrfs_block_rsv_release() it can
> > only be NULL at this point if global_rsv->full is true otherwise the crash
> > would happen there. I didn't go any further than this.
> > 
> > 	Gustavo
> 
> Can you check if the following commit is in your tree?
> 
> commit 321f0e70225abc792d74902a2bc4a60164265fd4
> Author: Miao Xie <miaox@cn.fujitsu.com>
> 
>     Btrfs: fix wrong orphan count of the fs/file tree
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 878116d..a6824bd 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2228,7 +2228,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
>                         insert = 1;
>  #endif
>                 insert = 1;
> -               atomic_dec(&root->orphan_inodes);
> +               atomic_inc(&root->orphan_inodes);
>         }
>  
>         if (!test_and_set_bit(BTRFS_INODE_ORPHAN_META_RESERVED,

Yes, it is. I'm using linus tree from last week, head at c5e35d6.

	Gustavo
