Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42918 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaF3Ibt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jun 2014 04:31:49 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s5U8VmAs015102
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 08:31:48 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s5U8VlrF016119
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 08:31:48 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s5U8VkTq016040
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 08:31:46 GMT
Message-ID: <53B1206B.6020402@oracle.com>
Date: Mon, 30 Jun 2014 16:31:39 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: device list could grow infinite
References: <1403614303-4210-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1403614303-4210-1-git-send-email-Anand.Jain@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


NACK for this. I have null pointer deference with this patch.
extremely sorry. I am investigating..

Anand


On 24/06/2014 20:51, Anand Jain wrote:
> Reproducer 1:
> modprobe -r btrfs; modprobe btrfs
>
> while true ; do mkfs.btrfs -f /dev/sde > /dev/null 2>&1; done
> CTLR-C
> we keep stale FSIDs.
>
> btrfs-devlist | egrep "/dev/sde" | wc -l
> 41
>
> Reproducer 2:
> mkfs.btrfs -d raid1 -m raid1 /dev/sdd /dev/sdf
> mkfs.btrfs -f /dev/sdf
> btrfs dev ready /dev/sdd
> echo $?
> 0 <-- wrong
>
> fix this at device_list_add() to check and delete if the newly added disk path
> is already in the device list
>
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
> ---
>   fs/btrfs/volumes.c | 41 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 41 insertions(+)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b107ad8..91ba2cf 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -598,6 +598,40 @@ static void pending_bios_fn(struct btrfs_work *work)
>   	run_scheduled_bios(device);
>   }
>
> +static void find_delete_duplicate_dev(struct btrfs_device *new_dev)
> +{
> +	struct btrfs_fs_devices *fs_devs;
> +	struct btrfs_fs_devices *cur_fs_devs;
> +	struct btrfs_device	*dev;
> +
> +	list_for_each_entry(fs_devs, &fs_uuids, list) {
> +
> +		if (new_dev->fs_devices == fs_devs || fs_devs->opened)
> +			continue;
> +
> +		cur_fs_devs = fs_devs;
> +		list_for_each_entry(dev, &cur_fs_devs->devices, dev_list) {
> +
> +			if (dev->name && !strcmp(new_dev->name->str,
> +							dev->name->str)) {
> +				if (cur_fs_devs->num_devices == 1) {
> +					free_fs_devices(cur_fs_devs);
> +				} else {
> +					mutex_lock(&cur_fs_devs->device_list_mutex);
> +					list_del_rcu(&dev->dev_list);
> +					cur_fs_devs->num_devices--;
> +					if (dev->missing)
> +						cur_fs_devs->missing_devices--;
> +					mutex_unlock(&cur_fs_devs->device_list_mutex);
> +					rcu_string_free(dev->name);
> +					kfree(dev);
> +				}
> +				return;
> +			}
> +		}
> +	}
> +}
> +
>   static noinline int device_list_add(const char *path,
>   			   struct btrfs_super_block *disk_super,
>   			   u64 devid, struct btrfs_fs_devices **fs_devices_ret)
> @@ -708,6 +742,13 @@ static noinline int device_list_add(const char *path,
>   		fs_devices->latest_devid = devid;
>   		fs_devices->latest_trans = found_transid;
>   	}
> +
> +	/*
> +	 * if new fs is created on the same path we need to clean
> +	 * the old one.
> +	 */
> +	find_delete_duplicate_dev(device);
> +
>   	*fs_devices_ret = fs_devices;
>   	return 0;
>   }
>
