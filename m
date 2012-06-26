Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:55763 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757943Ab2FZQRs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 12:17:48 -0400
Date: Tue, 26 Jun 2012 18:17:39 +0200
From: David Sterba <dave@jikos.cz>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>
Subject: Re: [PATCH 1/2] Btrfs: restore restriper state on all mounts
Message-ID: <20120626161739.GT28144@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1340389453-21439-1-git-send-email-idryomov@gmail.com>
 <1340389453-21439-2-git-send-email-idryomov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340389453-21439-2-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 22, 2012 at 09:24:12PM +0300, Ilya Dryomov wrote:
> Fix a bug that triggered asserts in btrfs_balance() in both normal and
> resume modes -- restriper state was not properly restored on read-only
> mounts.  This factors out resuming code from btrfs_restore_balance(),
> which is now also called earlier in the mount sequence to avoid the
> problem of some early writes getting the old profile.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 77872da..dae7cd6 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2492,9 +2497,6 @@ retry_root_backup:
>  			err = btrfs_orphan_cleanup(fs_info->tree_root);
>  		up_read(&fs_info->cleanup_work_sem);
>  
> -		if (!err)
> -			err = btrfs_recover_balance(fs_info->tree_root);
> -
>  		if (err) {
>  			close_ctree(tree_root);
>  			return err;
> @@ -2518,6 +2520,9 @@ fail_cleaner:
>  fail_block_groups:
>  	btrfs_free_block_groups(fs_info);
>  
> +fail_balance_ctl:
> +	kfree(fs_info->balance_ctl);

I think you need to set fs_info->balance_ctl to NULL, otherwise this
could lead to double free from free_fs_info. I was looking along the
call paths and didn't see free_fs_info called on the mount failure path:

vfs->mount
  btrfs_mount
    btrfs_fill_super
      open_ctree
        (recover balance fails, frees ctl)

error is propagated back to vfs, no other fs callback is done (like
kill_super which does call free_fs_info).

The only exit path that is not going through free_fs_info is after error
from btrfs_fill_super, and this can fail from various reasons.

Either I'm missing something, or we leak a btrfs_fs_info every time a
mount fails ...


Back to your patch, apart from the balance_ctl pointer reset, both are
ok and given the number of bug reports [useless padding text here]

  this should go to 3.5-rc.


david
