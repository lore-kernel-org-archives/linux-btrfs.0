Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22095 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaBGJYl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 04:24:41 -0500
Message-ID: <52F4A8B6.5070009@oracle.com>
Date: Fri, 07 Feb 2014 17:34:46 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Add missing devices check for mounted
 btrfs.
References: <1391755560-4721-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1391755560-4721-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  IMO btrfs-progs shouldn't add its intelligence to know if disk
  is missing. If btrfs-kernel doesn't know when disk is missing
  that's a bug to fix in btrfs-kernel. yes that indeed true as
  of now in btrfs-kernel. btrfs kernel has no idea when disk
  goes missing, just -EIO doesn't tell btrfs that. I am trying
  to fix this first.

  But the problem is there isn't good way with in btrfs/FS
  to know when disk goes missing. did I miss anything ?


Thanks, Anand


On 02/07/2014 02:45 PM, Qu Wenruo wrote:
> In btrfs/003 of xfstest, it will check whether btrfs fi show can find
> missing devices.
>
> But before the patch, btrfs-progs will not check whether device missing
> if given a mounted btrfs mountpoint/block device.
> This patch fixes the bug and will pass btrfs/003.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Cc: Anand Jain <anand.jain@oracle.com>
> ---
>   cmds-filesystem.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 384d1b9..4c9933d 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -363,6 +363,8 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
>   		char *label, char *path)
>   {
>   	int i;
> +	int fd;
> +	int missing;
>   	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
>   	struct btrfs_ioctl_dev_info_args *tmp_dev_info;
>   	int ret;
> @@ -385,6 +387,14 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
>
>   	for (i = 0; i < fs_info->num_devices; i++) {
>   		tmp_dev_info = (struct btrfs_ioctl_dev_info_args *)&dev_info[i];
> +
> +		/* Add check for missing devices even mounted */
> +		fd = open((char *)tmp_dev_info->path, O_RDONLY);
> +		if (fd < 0) {
> +			missing = 1;
> +			continue;
> +		}
> +		close(fd);
>   		printf("\tdevid %4llu size %s used %s path %s\n",
>   			tmp_dev_info->devid,
>   			pretty_size(tmp_dev_info->total_bytes),
> @@ -392,6 +402,8 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
>   			tmp_dev_info->path);
>   	}
>
> +	if (missing)
> +		printf("\t*** Some devices missing\n");
>   	printf("\n");
>   	return 0;
>   }
>
