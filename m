Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:37395 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbcDHWF5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 18:05:57 -0400
Date: Sat, 9 Apr 2016 01:05:48 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 10/13] btrfs: introduce helper functions to perform hot
 replace
Message-ID: <20160408220548.GA28387@jeknote.loshitsa1.net>
References: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
 <1459560651-14809-11-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459560651-14809-11-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 02, 2016 at 09:30:48AM +0800, Anand Jain wrote:
> Hot replace / auto replace is important volume manager feature
> and is critical to the data center operations, so that the degraded
> volume can be brought back to a healthy state at the earliest and
> without manual intervention.
> 
> This modifies the existing replace code to suite the need of auto
> replace, in the long run I hope both the codes to be merged.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
> ---
>  fs/btrfs/dev-replace.c | 43 +++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/dev-replace.h |  1 +
>  2 files changed, 44 insertions(+)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 2b926867d136..ceab4c51db32 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -957,3 +957,46 @@ void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)
>  				     &fs_info->fs_state));
>  	}
>  }
> +
> +int btrfs_auto_replace_start(struct btrfs_root *root,
> +				struct btrfs_device *src_device)
> +{
> +	int ret;
> +	char *tgt_path;
> +	char *src_path;
> +	struct btrfs_fs_info *fs_info = root->fs_info;
> +
> +	if (fs_info->sb->s_flags & MS_RDONLY)
> +		return -EROFS;
> +
> +	btrfs_dev_replace_lock(&fs_info->dev_replace, 0);
> +	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
> +		btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
> +		return -EBUSY;
> +	}
> +	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
> +
> +	if (btrfs_get_spare_device(&tgt_path)) {
> +		btrfs_err(root->fs_info,
> +			"No spare device found/configured in the kernel");
> +		return -EINVAL;
> +	}
> +
> +	rcu_read_lock();
> +	src_path = kstrdup(rcu_str_deref(src_device->name), GFP_ATOMIC);
> +	rcu_read_unlock();
> +	if (!src_path) {
> +		kfree(tgt_path);
> +		return -ENOMEM;
> +	}
> +	ret = btrfs_dev_replace_start(root, tgt_path,
> +					src_device->devid, src_path,
> +		BTRFS_IOCTL_DEV_REPLACE_CONT_READING_FROM_SRCDEV_MODE_AVOID);
> +	if (ret)
> +		btrfs_put_spare_device(tgt_path);
> +
> +	kfree(tgt_path);
> +	kfree(src_path);
> +
> +	return 0;
> +}

Without of fs_info->mutually_exclusive_operation_running flag set in
btrfs_auto_replace_start(), device add/remove/balance etc. can be
started in parralel with autoreplace. Should this scenarios be permitted?

> diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
> index e922b42d91df..b918b9d6e5df 100644
> --- a/fs/btrfs/dev-replace.h
> +++ b/fs/btrfs/dev-replace.h
> @@ -46,4 +46,5 @@ static inline void btrfs_dev_replace_stats_inc(atomic64_t *stat_value)
>  {
>  	atomic64_inc(stat_value);
>  }
> +int btrfs_auto_replace_start(struct btrfs_root *root, struct btrfs_device *src_device);
>  #endif
> -- 
> 2.7.0

-- 
Yauhen Kharuzhy
