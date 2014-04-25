Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38960 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaDYK0x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 06:26:53 -0400
Date: Fri, 25 Apr 2014 18:26:41 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: allow compression property gets for
 read-only subvolumes
Message-ID: <20140425102640.GA6138@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1397591247-25376-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1397591247-25376-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 08:47:27PM +0100, Filipe David Borba Manana wrote:
> Because the function open_file_or_dir() always opened the input file in
> read/write mode (O_RDWR), we were not able to due a compression property
> get against a file living in a read-only subvolume/snapshot.
> Fix this by opening the file with O_RDONLY mode if we're doing a property
> get.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

thanks,
-liubo

> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  props.c | 3 ++-
>  utils.c | 9 +++++++--
>  utils.h | 1 +
>  3 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/props.c b/props.c
> index 4d0aeea..bd74975 100644
> --- a/props.c
> +++ b/props.c
> @@ -119,8 +119,9 @@ static int prop_compression(enum prop_object_type type,
>  	DIR *dirstream = NULL;
>  	char *buf = NULL;
>  	char *xattr_name = NULL;
> +	int open_flags = value ? O_RDWR : O_RDONLY;
>  
> -	fd = open_file_or_dir(object, &dirstream);
> +	fd = open_file_or_dir3(object, &dirstream, open_flags);
>  	if (fd == -1) {
>  		ret = -errno;
>  		fprintf(stderr, "ERROR: open %s failed. %s\n",
> diff --git a/utils.c b/utils.c
> index 0bfb9d9..458ba54 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1625,7 +1625,7 @@ u64 parse_size(char *s)
>  	return strtoull(s, NULL, 10) * mult;
>  }
>  
> -int open_file_or_dir(const char *fname, DIR **dirstream)
> +int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags)
>  {
>  	int ret;
>  	struct stat st;
> @@ -1641,7 +1641,7 @@ int open_file_or_dir(const char *fname, DIR **dirstream)
>  			return -1;
>  		fd = dirfd(*dirstream);
>  	} else if (S_ISREG(st.st_mode) || S_ISLNK(st.st_mode)) {
> -		fd = open(fname, O_RDWR);
> +		fd = open(fname, open_flags);
>  	} else {
>  		/*
>  		 * we set this on purpose, in case the caller output
> @@ -1658,6 +1658,11 @@ int open_file_or_dir(const char *fname, DIR **dirstream)
>  	return fd;
>  }
>  
> +int open_file_or_dir(const char *fname, DIR **dirstream)
> +{
> +	return open_file_or_dir3(fname, dirstream, O_RDWR);
> +}
> +
>  void close_file_or_dir(int fd, DIR *dirstream)
>  {
>  	if (dirstream)
> diff --git a/utils.h b/utils.h
> index 06ec938..fc581ca 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -73,6 +73,7 @@ int btrfs_scan_block_devices(int run_ioctl);
>  u64 parse_size(char *s);
>  u64 arg_strtou64(const char *str);
>  int open_file_or_dir(const char *fname, DIR **dirstream);
> +int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags);
>  void close_file_or_dir(int fd, DIR *dirstream);
>  int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>  		struct btrfs_ioctl_dev_info_args **di_ret);
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
