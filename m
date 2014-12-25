Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55709 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaLYGoD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Dec 2014 01:44:03 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 60C843EE0AE
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 15:44:01 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 6C098AC00A1
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 15:44:00 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 131F0E08002
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 15:44:00 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
	by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 296E7BD6893
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 15:43:59 +0900 (JST)
Message-ID: <549BB228.5040007@jp.fujitsu.com>
Date: Thu, 25 Dec 2014 15:43:52 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: move check_arg_type() to util.c
References: <1419470195-2889-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1419470195-2889-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/12/25 10:16, Gui Hecheng wrote:
> The check_arg_type() function does quite generic thing,
> move it to utils.c.
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>   cmds-filesystem.c | 32 --------------------------------
>   utils.c           | 32 ++++++++++++++++++++++++++++++++
>   utils.h           |  1 +
>   3 files changed, 33 insertions(+), 32 deletions(-)
> 
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index 253f105..4d7a797 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -537,38 +537,6 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
>   	return 0;
>   }
>   
> -/* This function checks if the given input parameter is
> - * an uuid or a path
> - * return -1: some error in the given input
> - * return 0: unknow input
> - * return 1: given input is uuid
> - * return 2: given input is path
> - */
> -static int check_arg_type(char *input)
> -{
> -	uuid_t	out;
> -	char path[PATH_MAX];
> -
> -	if (!input)
> -		return -EINVAL;
> -
> -	if (realpath(input, path)) {
> -		if (is_block_device(path) == 1)
> -			return BTRFS_ARG_BLKDEV;
> -
> -		if (is_mount_point(path) == 1)
> -			return BTRFS_ARG_MNTPOINT;
> -
> -		return BTRFS_ARG_UNKNOWN;
> -	}
> -
> -	if (strlen(input) == (BTRFS_UUID_UNPARSED_SIZE - 1) &&
> -		!uuid_parse(input, out))
> -		return BTRFS_ARG_UUID;
> -
> -	return BTRFS_ARG_UNKNOWN;
> -}
> -
>   static int btrfs_scan_kernel(void *search)
>   {
>   	int ret = 0, fd;
> diff --git a/utils.c b/utils.c
> index 2a92416..80f85e9 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -852,6 +852,38 @@ int is_mount_point(const char *path)
>   	return ret;
>   }
>   
> +/* This function checks if the given input parameter is
> + * an uuid or a path
> + * return -1: some error in the given input
> + * return 0: unknow input
> + * return 1: given input is uuid
> + * return 2: given input is path
> + */
> +int check_arg_type(const char *input)
> +{
> +	uuid_t	out;
> +	char path[PATH_MAX];
> +
> +	if (!input)
> +		return -EINVAL;
> +
> +	if (realpath(input, path)) {
> +		if (is_block_device(path) == 1)
> +			return BTRFS_ARG_BLKDEV;
> +
> +		if (is_mount_point(path) == 1)
> +			return BTRFS_ARG_MNTPOINT;
> +
> +		return BTRFS_ARG_UNKNOWN;
> +	}
> +
> +	if (strlen(input) == (BTRFS_UUID_UNPARSED_SIZE - 1) &&
> +		!uuid_parse(input, out))
> +		return BTRFS_ARG_UUID;
> +
> +	return BTRFS_ARG_UNKNOWN;
> +}
> +
>   /*
>    * Find the mount point for a mounted device.
>    * On success, returns 0 with mountpoint in *mp.
> diff --git a/utils.h b/utils.h
> index 289e86b..8d67720 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -115,6 +115,7 @@ int set_label(const char *btrfs_dev, const char *label);
>   char *__strncpy__null(char *dest, const char *src, size_t n);
>   int is_block_device(const char *file);
>   int is_mount_point(const char *file);
> +int check_arg_type(const char *input);
>   int open_path_or_dev_mnt(const char *path, DIR **dirstream);
>   u64 btrfs_device_size(int fd, struct stat *st);
>   /* Helper to always get proper size of the destination string */
> 

