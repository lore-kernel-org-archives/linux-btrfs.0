Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:63188 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab3JGPZU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 11:25:20 -0400
Message-ID: <5252D25F.3000800@giantdisaster.de>
Date: Mon, 07 Oct 2013 17:25:19 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>,
        =?UTF-8?B?T25kxZllaiBLdW5j?= <kunc88@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: init device stats for new devices
References: <CAOEw3RbDhA9_VhkuiewMWCXg5z4jqM9hR_=Uvq61a2A-w0vZxA@mail.gmail.com> <20130930215802.GB10831@lenny.home.zabbo.net>
In-Reply-To: <20130930215802.GB10831@lenny.home.zabbo.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 30 Sep 2013 14:58:02 -0700, Zach Brown wrote:
>> I discovered one minor bug in BTRFS filesystem.
> 
> You sure did.
> 
>> ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on /dev/sde failed: No such device
>>
>> But this is not true ... all specified devices exist and are members
>> of btrfs filesystem. In dmesg I see this:
>> ...
>> [973077.099118] btrfs: get dev_stats failed, not yet valid
>> ....
>>
>> What makes device statistics valid ? I tried doing full filesystem
>> scrub ... but it did not fix that issue.
> 
> The stats are only initialized (considered valid) for devices that are
> known at mount.  You could unmount and mount after adding (or replacing)
> new devices and they'd start returning stats.
> 
> The following (bad) patch illustrates the problem, but the code should
> be restructured so stats are reliably read as devices are added.
> 
> - z
> 
> From: Zach Brown <zab@redhat.com>
> Date: Mon, 30 Sep 2013 17:48:05 -0400
> Subject: [PATCH] btrfs: init device stats for new devices
> 
> Device stats are only initialized (read from tree items) on mount.
> Trying to read device stats after adding or replacing new devices will
> return errors.
> 
> This cheesy patch demonstrates the problem, but this should really be a
> natural side-effect of adding devices to the fs_devices list.  We have
> evidence that trying to do it by hand doesn't work.
> 
> Any preferences for how to restructure this?

btrfs_init_new_device() and btrfs_init_dev_replace_tgtdev() are the two
functions that allocate and initialize new btrfs_device structures after
a filesystem is mounted. The device->dev_stats_valid = 1 should be done
there IMO. Before, kzalloc() has set the statistic values to the correct
value zero for new devices.


> ---
>  fs/btrfs/dev-replace.c | 4 +++-
>  fs/btrfs/volumes.c     | 6 ++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 5d84443..7309096 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -556,7 +556,9 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  
>  	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
>  
> -	return 0;
> +	ret = btrfs_init_dev_stats(root->fs_info);
> +
> +	return ret;
>  }
>  
>  static void btrfs_dev_replace_update_device_in_mapping_tree(
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 0431147..e4ccc9b 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2126,6 +2126,9 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>  		ret = btrfs_commit_transaction(trans, root);
>  	}
>  
> +	if (!ret)
> +		ret = btrfs_init_dev_stats(root->fs_info);
> +
>  	return ret;
>  
>  error_trans:
> @@ -6060,6 +6063,9 @@ int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info)
>  		int item_size;
>  		struct btrfs_dev_stats_item *ptr;
>  
> +		if (device->dev_stats_valid)
> +			continue;
> +
>  		key.objectid = 0;
>  		key.type = BTRFS_DEV_STATS_KEY;
>  		key.offset = device->devid;
> 


