Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35787 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaGYJf7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 05:35:59 -0400
Message-ID: <53D225CD.5020603@oracle.com>
Date: Fri, 25 Jul 2014 17:39:25 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/10] Btrfs: don't write any data into a readonly device
 when scrub
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com> <1406173035-29478-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1406173035-29478-2-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/24/2014 11:37 AM, Miao Xie wrote:
> We should not write data into a readonly device especially seed device when
> doing scrub, skip those devices.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>   fs/btrfs/scrub.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index b6d198f..23d3f6e 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -2904,6 +2904,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>   	struct scrub_ctx *sctx;
>   	int ret;
>   	struct btrfs_device *dev;
> +	struct rcu_string *name;
>
>   	if (btrfs_fs_closing(fs_info))
>   		return -EINVAL;
> @@ -2965,6 +2966,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>   		return -ENODEV;
>   	}
>
> +	if (!is_dev_replace && !readonly && !dev->writeable) {

  just reading the commit message would ask question what
  about readonly scrub anyway. Nice readonly scrub case
  is taken care as well.


> +		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +		rcu_read_lock();
> +		name = rcu_dereference(dev->name);
> +		btrfs_err(fs_info, "scrub: device %s is not writable",
> +			  name->str);
> +		rcu_read_unlock();
> +		return -EROFS;
> +	}
> +
>   	mutex_lock(&fs_info->scrub_lock);
>   	if (!dev->in_fs_metadata || dev->is_tgtdev_for_dev_replace) {
>   		mutex_unlock(&fs_info->scrub_lock);
>
