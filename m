Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17324 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbcBPJHb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 04:07:31 -0500
Subject: Re: [PATCH 10/15] btrfs: rename __check_raid_min_devices
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1455556900.git.dsterba@suse.com>
 <f618945b86f4bba6037bd4917a4b461503183f0e.1455556900.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56C2E6CD.20503@oracle.com>
Date: Tue, 16 Feb 2016 17:07:25 +0800
MIME-Version: 1.0
In-Reply-To: <f618945b86f4bba6037bd4917a4b461503183f0e.1455556900.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  thanks.

Reviewed-by: Anand Jain <anand.jain@oracle.com>


On 02/16/2016 01:34 AM, David Sterba wrote:
> Underscores are for special functions, use the full prefix for better
> stacktrace recognition.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/volumes.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 20af20b0eaee..4fa4a836a072 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1705,7 +1705,7 @@ static int btrfs_rm_dev_item(struct btrfs_root *root,
>   	return ret;
>   }
>
> -static int __check_raid_min_devices(struct btrfs_fs_info *fs_info)
> +static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info)
>   {
>   	u64 all_avail;
>   	u64 num_devices;
> @@ -1760,7 +1760,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
>
>   	mutex_lock(&uuid_mutex);
>
> -	ret = __check_raid_min_devices(root->fs_info);
> +	ret = btrfs_check_raid_min_devices(root->fs_info);
>   	if (ret)
>   		goto out;
>
>
