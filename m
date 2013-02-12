Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761182Ab3BLEWY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 23:22:24 -0500
Message-ID: <5119C379.7080305@redhat.com>
Date: Mon, 11 Feb 2013 22:22:17 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
CC: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH] Btrfs-progs: check out if the swap device
References: <201302120125.AA00019@FM-323941448.jp.fujitsu.com>
In-Reply-To: <201302120125.AA00019@FM-323941448.jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/11/13 7:25 PM, Tsutomu Itoh wrote:
> Currently, the following commands succeed.
> 
>  # cat /proc/swaps
>  Filename                                Type            Size    Used    Priority
>  /dev/sda3                               partition       8388604 0       -1
>  /dev/sdc8                               partition       9765884 0       -2
>  # mkfs.btrfs /dev/sdc8
>  
>  WARNING! - Btrfs v0.20-rc1-165-g82ac345 IS EXPERIMENTAL
>  WARNING! - see http://btrfs.wiki.kernel.org before using
>  
>  fs created label (null) on /dev/sdc8
>          nodesize 4096 leafsize 4096 sectorsize 4096 size 9.31GB
>  Btrfs v0.20-rc1-165-g82ac345
>  # btrfs fi sh /dev/sdc8
>  Label: none  uuid: fc0bdbd0-7eed-460f-b4e9-131273b66df2
>          Total devices 1 FS bytes used 28.00KB
>          devid    1 size 9.31GB used 989.62MB path /dev/sdc8
>  
>  Btrfs v0.20-rc1-165-g82ac345
>  #
> 
> But we should check out the swap device. So fixed it.

I guess it's nice to parse /proc/swaps to be able to offer the
helpful error message in this case.  (though I wonder how long
/proc/swaps will be available, and in this format?  Does it count
as ABI?)

Your implementation looks just like the one in e2fsprogs, so it should
work fine.

But I also wonder if overall it would be safest to open the device O_EXCL,
which would fail with EBUSY if it were in use for swap, or mounted,
or opened O_EXCL by another process for any other reason:

[root@host tmp]# cat /proc/swaps
Filename				Type		Size	Used	Priority
/dev/sda3                               partition	2048280	822616	-1

[root@host tmp]# strace -e open ./test
open("/etc/ld.so.cache", O_RDONLY)      = 3
open("/lib64/libc.so.6", O_RDONLY)      = 3
open("/dev/sda3", O_RDWR|O_EXCL)        = -1 EBUSY (Device or resource busy)
open: Device or resource busy

-Eric

> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
> (this patch is based on Chris's raid56-experimental branch)
> ---
>  mkfs.c  | 18 ++++++++++++++++++
>  utils.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  utils.h |  1 +
>  3 files changed, 68 insertions(+)
> 
> diff --git a/mkfs.c b/mkfs.c
> index 2d3c2af..fdc3373 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1366,6 +1366,15 @@ int main(int ac, char **av)
>  
>  	if (source_dir == 0) {
>  		file = av[optind++];
> +		ret = is_swap_device(file);
> +		if (ret < 0) {
> +			fprintf(stderr, "error checking %s status\n", file);
> +			exit(1);
> +		}
> +		if (ret == 1) {
> +			fprintf(stderr, "%s is a swap device\n", file);
> +			exit(1);
> +		}
>  		ret = check_mounted(file);
>  		if (ret < 0) {
>  			fprintf(stderr, "error checking %s mount status\n", file);
> @@ -1461,6 +1470,15 @@ int main(int ac, char **av)
>  		int old_mixed = mixed;
>  
>  		file = av[optind++];
> +		ret = is_swap_device(file);
> +		if (ret < 0) {
> +			fprintf(stderr, "error checking %s status\n", file);
> +			exit(1);
> +		}
> +		if (ret == 1) {
> +			fprintf(stderr, "%s is a swap device\n", file);
> +			exit(1);
> +		}
>  		ret = check_mounted(file);
>  		if (ret < 0) {
>  			fprintf(stderr, "error checking %s mount status\n",
> diff --git a/utils.c b/utils.c
> index f9ee812..0c551a0 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1386,3 +1386,52 @@ int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>  
>  	return 0;
>  }
> +
> +/*
> + * Checks if the swap device or not.
> + * Returns 1 if the swap device, < 0 on error or 0 if not the swap device.
> + */
> +int is_swap_device(const char *file)
> +{
> +	FILE	*f;
> +	struct stat	st_buf;
> +	char	buf[1024];
> +	char	*cp;
> +	dev_t	rdev;
> +	int	ret = 0;
> +
> +	if (stat(file, &st_buf) < 0)
> +		return -errno;
> +	if (!S_ISBLK(st_buf.st_mode))
> +		return 0;
> +
> +	rdev = st_buf.st_rdev;
> +
> +	if ((f = fopen("/proc/swaps", "r")) == NULL)
> +		return -errno;
> +
> +	/* skip the first line */
> +	if (fgets(buf, sizeof(buf), f) == NULL)
> +		goto out;
> +
> +	while (fgets(buf, sizeof(buf), f) != NULL) {
> +		if ((cp = strchr(buf, ' ')) != NULL)
> +			*cp = 0;
> +		if ((cp = strchr(buf, '\t')) != NULL)
> +			*cp = 0;
> +		if (strcmp(file, buf) == 0) {
> +			ret = 1;
> +			break;
> +		}
> +		if ((stat(buf, &st_buf) == 0) && S_ISBLK(st_buf.st_mode) &&
> +		    rdev == st_buf.st_rdev) {
> +			ret = 1;
> +			break;
> +		}
> +	}
> +
> +out:
> +	fclose(f);
> +
> +	return ret;
> +}
> diff --git a/utils.h b/utils.h
> index bbcaf6a..60a0fea 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -55,6 +55,7 @@ int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>  		struct btrfs_ioctl_dev_info_args **di_ret);
>  
>  char *__strncpy__null(char *dest, const char *src, size_t n);
> +int is_swap_device(const char *file);
>  /* Helper to always get proper size of the destination string */
>  #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

