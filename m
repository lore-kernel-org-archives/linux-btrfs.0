Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42661 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbeIHBsq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 21:48:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id y4-v6so7546705pgp.9
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 14:06:02 -0700 (PDT)
Date: Fri, 7 Sep 2018 14:06:01 -0700
From: Omar Sandoval <osandov@osandov.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/11] btrfs: dev-replace: avoid useless lock on error
 handling path
Message-ID: <20180907210601.GH29245@vader>
References: <cover.1536331604.git.dsterba@suse.com>
 <41a1cc8519061dde7a7cbf2139f672d433a5cfbd.1536331604.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <41a1cc8519061dde7a7cbf2139f672d433a5cfbd.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 07, 2018 at 04:55:11PM +0200, David Sterba wrote:
> The exit sequence in btrfs_dev_replace_start does not allow to simply
> add a label to the right place so the error handling after starting
> transaction failure jumps there. Currently there's a lock that pairs
> with the unlock in the section, which is unnecessary and only raises
> questions.  Add a variable to track the locking status and avoid the
> extra locking.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/dev-replace.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 8b512dddf727..0a49843b2ee6 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -400,6 +400,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
>  	int ret;
>  	struct btrfs_device *tgt_device = NULL;
>  	struct btrfs_device *src_device = NULL;
> +	bool need_unlock;
>  
>  	ret = btrfs_find_device_by_devspec(fs_info, srcdevid,
>  					    srcdev_name, &src_device);
> @@ -424,6 +425,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
>  		return PTR_ERR(trans);
>  	}
>  
> +	need_unlock = true;
>  	btrfs_dev_replace_write_lock(dev_replace);
>  	switch (dev_replace->replace_state) {
>  	case BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED:
> @@ -462,6 +464,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
>  	atomic64_set(&dev_replace->num_write_errors, 0);
>  	atomic64_set(&dev_replace->num_uncorrectable_read_errors, 0);
>  	btrfs_dev_replace_write_unlock(dev_replace);
> +	need_unlock = false;
>  
>  	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device);
>  	if (ret)
> @@ -473,7 +476,6 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
>  	trans = btrfs_start_transaction(root, 0);
>  	if (IS_ERR(trans)) {
>  		ret = PTR_ERR(trans);
> -		btrfs_dev_replace_write_lock(dev_replace);
>  		goto leave;
>  	}
>  
> @@ -497,7 +499,8 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
>  leave:
>  	dev_replace->srcdev = NULL;
>  	dev_replace->tgtdev = NULL;
> -	btrfs_dev_replace_write_unlock(dev_replace);
> +	if (need_unlock)
> +		btrfs_dev_replace_write_unlock(dev_replace);
>  	btrfs_destroy_dev_replace_tgtdev(tgt_device);
>  	return ret;
>  }
> -- 
> 2.18.0
> 
