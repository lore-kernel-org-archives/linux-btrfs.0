Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39950 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726900AbeINWIr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 18:08:47 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 907C8ADA8
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 16:53:27 +0000 (UTC)
Date: Fri, 14 Sep 2018 18:53:27 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/11] btrfs: dev-replace: avoid useless lock on error
 handling path
Message-ID: <20180914165327.GW5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
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
> 
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

There's a merge conflict with Jeff's patch
https://patchwork.kernel.org/patch/10591003/ that adds some dev-replace
state change, so the lock must be here. I'll update my patch to

@@ -474,6 +477,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
        trans = btrfs_start_transaction(root, 0);
        if (IS_ERR(trans)) {
                ret = PTR_ERR(trans);
+               need_unlock = true;
                btrfs_dev_replace_write_lock(dev_replace);
                dev_replace->replace_state =
                        BTRFS_IOCTL_DEV_REPLACE_STATE_NEVER_STARTED;
---
