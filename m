Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50701 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaEGH55 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 03:57:57 -0400
Message-ID: <5369E818.7000606@oracle.com>
Date: Wed, 07 May 2014 16:00:24 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] btrfs: Add missing device check in dev_info/rm_dev
 ioctl
References: <1399357993-9254-1-git-send-email-quwenruo@cn.fujitsu.com> <1399357993-9254-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1399357993-9254-2-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Thanks for working on this.
I am running some tests will let you know.

Anand


On 05/06/2014 02:33 PM, Qu Wenruo wrote:
> Old btrfs can't find a missing btrfs device since there is no
> mechanism for block layer to inform fs layer.
>
> But we can use a workaround that only check status(by using
> request_queue->queue_flags) of every device in a btrfs
> filesystem when calling dev_info/rm_dev ioctl, since other ioctls
> do not really cares about missing device.
>
> Cc: Anand Jain <Anand.Jain@oracle.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/ioctl.c   |  1 +
>   fs/btrfs/volumes.c | 25 ++++++++++++++++++++++++-
>   fs/btrfs/volumes.h |  2 ++
>   3 files changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 0401397..7680a40 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2606,6 +2606,7 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
>   		goto out;
>   	}
>
> +	btrfs_check_dev_missing(root, dev, 1);
>   	di_args->devid = dev->devid;
>   	di_args->bytes_used = dev->bytes_used;
>   	di_args->total_bytes = dev->total_bytes;
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index d241130a..c7d7908 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1548,9 +1548,10 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>   		 * is held.
>   		 */
>   		list_for_each_entry(tmp, devices, dev_list) {
> +			btrfs_check_dev_missing(root, tmp, 0);
>   			if (tmp->in_fs_metadata &&
>   			    !tmp->is_tgtdev_for_dev_replace &&
> -			    !tmp->bdev) {
> +			    (!tmp->bdev || tmp->missing)) {
>   				device = tmp;
>   				break;
>   			}
> @@ -6300,3 +6301,25 @@ int btrfs_scratch_superblock(struct btrfs_device *device)
>
>   	return 0;
>   }
> +
> +/* If need_lock is set, uuid_mutex will be used */
> +int btrfs_check_dev_missing(struct btrfs_root *root, struct btrfs_device *dev,
> +			    int need_lock)
> +{
> +	struct request_queue *q;
> +
> +	if (unlikely(!dev || !dev->bdev || !dev->bdev->bd_queue))
> +		return -ENOENT;
> +	q = dev->bdev->bd_queue;
> +
> +	if (need_lock)
> +		mutex_lock(&uuid_mutex);
> +	if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags) ||
> +	    test_bit(QUEUE_FLAG_DYING, &q->queue_flags)) {
> +		dev->missing = 1;
> +		root->fs_info->fs_devices->missing_devices++;
> +	}
> +	if (need_lock)
> +		mutex_unlock(&uuid_mutex);
> +	return 0;
> +}
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 80754f9..47a44af 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -356,6 +356,8 @@ unsigned long btrfs_full_stripe_len(struct btrfs_root *root,
>   int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
>   				struct btrfs_root *extent_root,
>   				u64 chunk_offset, u64 chunk_size);
> +int btrfs_check_dev_missing(struct btrfs_root *root, struct btrfs_device *dev,
> +			    int need_lock);
>   static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
>   				      int index)
>   {
>
