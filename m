Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42811 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaEUDgG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 23:36:06 -0400
Message-ID: <537C1FCC.4060801@oracle.com>
Date: Wed, 21 May 2014 11:38:52 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
CC: David Sterba <dsterba@suse.cz>
Subject: Re: [RFC PATCH 2/2] btrfs-progs: Add userspace support for kernel
 missing dev detection.
References: <1399358005-9780-1-git-send-email-quwenruo@cn.fujitsu.com> <1399358005-9780-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1399358005-9780-2-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Qu,

  First of all. With this patch, we don't need the old btrfs-progs
  workaround fix [1] anymore.  David should back-out if you are ok.

[1]
  commit 206efb60cbe3049e0d44c6da3c1909aeee18f813
  Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
  Date:   Fri Feb 7 15:07:19 2014 +0800

     btrfs-progs: Add missing devices check for mounted btrfs.


more below.


On 05/06/2014 02:33 PM, Qu Wenruo wrote:
> Add userspace support for kernel missing dev detection from dev_info
> ioctl.
>
> Now 'btrfs fi show' will auto detect the output format of dev_info ioctl
> and use kernel missing dev detection if supported.
> Also userspace missing dev detection is used as a fallback method and
> when used, a info message will be printed showing 'btrfs dev del missing'
> will not work.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   cmds-filesystem.c | 29 ++++++++++++++++++++++-------
>   utils.c           |  2 ++
>   2 files changed, 24 insertions(+), 7 deletions(-)
>
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 306f715..0ff1ca6 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -369,6 +369,7 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
>   	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
>   	struct btrfs_ioctl_dev_info_args *tmp_dev_info;
>   	int ret;
> +	int new_flag = 0;

  This part didn't work until I made this change
----
-       int new_flag = 0;
+       u64 new_flag = 0;
----


>   	ret = add_seen_fsid(fs_info->fsid);
>   	if (ret == -EEXIST)
> @@ -389,13 +390,22 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
>   	for (i = 0; i < fs_info->num_devices; i++) {
>   		tmp_dev_info = (struct btrfs_ioctl_dev_info_args *)&dev_info[i];
>
> -		/* Add check for missing devices even mounted */
> -		fd = open((char *)tmp_dev_info->path, O_RDONLY);
> -		if (fd < 0) {
> -			missing = 1;
> -			continue;
> +		new_flag = tmp_dev_info->flags & BTRFS_IOCTL_DEV_INFO_FLAG_SET;
> +		if (!new_flag) {
> +			/* Add check for missing devices even mounted */
> +			fd = open((char *)tmp_dev_info->path, O_RDONLY);
> +			if (fd < 0) {
> +				missing = 1;
> +				continue;
> +			}
> +			close(fd);
> +		} else {
> +			if (tmp_dev_info->flags &
> +			    BTRFS_IOCTL_DEV_INFO_MISSING) {
> +				missing = 1;
> +				continue;
> +			}
>   		}
> -		close(fd);
>   		printf("\tdevid %4llu size %s used %s path %s\n",
>   			tmp_dev_info->devid,
>   			pretty_size(tmp_dev_info->total_bytes),
> @@ -403,8 +413,13 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
>   			tmp_dev_info->path);
>   	}
>
> -	if (missing)
> +	if (missing) {
>   		printf("\t*** Some devices missing\n");
> +		if (!new_flag) {
> +			printf("\tOlder kernel detected\n");
> +			printf("\t'btrfs dev delete missing' may not work\n");
> +		}
> +	}

  we need one good solution - which is to update kernel when we have
  missing disk and we don't need the btrfs-progs workaround fix.
  which means we also don't need the new_flag check as well.

>   	printf("\n");
>   	return 0;
>   }
> diff --git a/utils.c b/utils.c
> index 3e9c527..230471f 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1670,6 +1670,8 @@ int get_device_info(int fd, u64 devid,
>
>   	di_args->devid = devid;
>   	memset(&di_args->uuid, '\0', sizeof(di_args->uuid));
> +	/* Clear flags to ensure old kernel returns untouched flags */
> +	memset(&di_args->flags, 0, sizeof(di_args->flags));
>
>   	ret = ioctl(fd, BTRFS_IOC_DEV_INFO, di_args);
>   	return ret ? -errno : 0;
>
