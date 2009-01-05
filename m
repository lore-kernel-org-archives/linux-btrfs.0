From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs filesystem freeze
Date: Mon, 05 Jan 2009 10:44:38 -0500
Message-ID: <1231170278.4290.85.camel@think.oraclecorp.com>
References: <551034715@web.de>  <494EE585.5090209@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: devzero@web.de, linux-btrfs@vger.kernel.org
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <494EE585.5090209@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-12-22 at 08:55 +0800, Yan Zheng wrote:
> devzero@web.de wrote:
> > thank you.
> > 
> > i tried your patch and did another test run.
> > 
> > first, it looked better as i could do much more snapshots than before, but then it froze again.
> > 
> > i don`t really have a clue if your patch enhanced anything, as my test setup isn`t exactly  reproducable for now and i did not check for exact "testing lab conditions".
> > 
> > after /btrfs froze again, i tried to unmount by forcibly unloading btrfs module. 
> > 
> > after reloading the module and trying to mount again, it failed with the following  kernel message:
> > 
> I hope the new patch can solve the problem.
> 
> Yan Zheng 
> 
> ---
> diff -urp 1/fs/btrfs/inode.c 2/fs/btrfs/inode.c
> --- 1/fs/btrfs/inode.c	2008-12-18 08:09:16.062111805 +0800
> +++ 2/fs/btrfs/inode.c	2008-12-22 08:47:06.000000000 +0800
> @@ -2891,7 +2891,7 @@ void btrfs_delete_inode(struct inode *in
>  	btrfs_wait_ordered_range(inode, 0, (u64)-1);
>  
>  	btrfs_i_size_write(inode, 0);
> -	trans = btrfs_start_transaction(root, 1);
> +	trans = btrfs_join_transaction(root, 1);

Which call to iput is causing problems?  We're going to run into
starvation problems if file deletes use join.

-chris


