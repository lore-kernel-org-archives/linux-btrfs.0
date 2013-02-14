Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48328 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3BNEHi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 23:07:38 -0500
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id B23CB3EE0B6
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 13:07:36 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 99EEB45DE53
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 13:07:36 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 81E8B45DE50
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 13:07:36 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 747351DB802C
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 13:07:36 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 26F65E08003
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 13:07:36 +0900 (JST)
Received: from m1001.css.fujitsu.com (m1001 [127.0.0.1])
	by m1001.s.css.fujitsu.com (Postfix) with ESMTP id F206461396
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 13:07:35 +0900 (JST)
Received: from [127.0.0.1] (unknown [10.124.101.82])
	by m1001.s.css.fujitsu.com (Postfix) with ESMTP id C285A61390
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 13:07:35 +0900 (JST)
Message-ID: <511C6302.7060301@jp.fujitsu.com>
Date: Thu, 14 Feb 2013 13:07:30 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs-progs: check out if the swap device
References: <201302140253.AA00020@FM-323941448.jp.fujitsu.com>
In-Reply-To: <201302140253.AA00020@FM-323941448.jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, please ignore this.
I will send again later.

-Tsutomu

On 2013/02/14 11:53, Tsutomu Itoh wrote:
> Currently, the following commands succeed.
>
>   # cat /proc/swaps
>   Filename                                Type            Size    Used    Priority
>   /dev/sda3                               partition       8388604 0       -1
>   /dev/sdc8                               partition       9765884 0       -2
>   # mkfs.btrfs /dev/sdc8
>
>   WARNING! - Btrfs v0.20-rc1-165-g82ac345 IS EXPERIMENTAL
>   WARNING! - see http://btrfs.wiki.kernel.org before using
>
>   fs created label (null) on /dev/sdc8
>           nodesize 4096 leafsize 4096 sectorsize 4096 size 9.31GB
>   Btrfs v0.20-rc1-165-g82ac345
>   # btrfs fi sh /dev/sdc8
>   Label: none  uuid: fc0bdbd0-7eed-460f-b4e9-131273b66df2
>           Total devices 1 FS bytes used 28.00KB
>           devid    1 size 9.31GB used 989.62MB path /dev/sdc8
>
>   Btrfs v0.20-rc1-165-g82ac345
>   #
>
> But we should check out the swap device. Fixed it.
>
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
> (this patch is based on Chris's raid56-experimental branch)
> v1 -> v2:
> 	- O_EXCL is specified at open(), as a last safety check
> 	- check when the swap device is a file is added
> 	- translate '\nnn'(octal) to character
> 	Thank you Eric, David, Zach and others.
> ---
>   mkfs.c  | 30 ++++++++++++++++++++++----
>   utils.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   utils.h |  1 +
>   3 files changed, 102 insertions(+), 4 deletions(-)
>
> diff --git a/mkfs.c b/mkfs.c
> index 2d3c2af..e981517 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1366,6 +1366,16 @@ int main(int ac, char **av)
>
>   	if (source_dir == 0) {
>   		file = av[optind++];
> +		ret = is_swap_device(file);
> +		if (ret < 0) {
> +			fprintf(stderr, "error checking %s status: %s\n", file,
> +				strerror(-ret));
> +			exit(1);
> +		}
> +		if (ret == 1) {
> +			fprintf(stderr, "%s is a swap device\n", file);
> +			exit(1);
> +		}
>   		ret = check_mounted(file);
>   		if (ret < 0) {
>   			fprintf(stderr, "error checking %s mount status\n", file);
> @@ -1376,9 +1386,10 @@ int main(int ac, char **av)
>   			exit(1);
>   		}
>   		ac--;
> -		fd = open(file, O_RDWR);
> +		fd = open(file, O_RDWR|O_EXCL);
>   		if (fd < 0) {
> -			fprintf(stderr, "unable to open %s\n", file);
> +			fprintf(stderr, "unable to open %s: %s\n", file,
> +				strerror(errno));
>   			exit(1);
>   		}
>   		first_file = file;
> @@ -1461,6 +1472,16 @@ int main(int ac, char **av)
>   		int old_mixed = mixed;
>
>   		file = av[optind++];
> +		ret = is_swap_device(file);
> +		if (ret < 0) {
> +			fprintf(stderr, "error checking %s status: %s\n", file,
> +				strerror(-ret));
> +			exit(1);
> +		}
> +		if (ret == 1) {
> +			fprintf(stderr, "%s is a swap device\n", file);
> +			exit(1);
> +		}
>   		ret = check_mounted(file);
>   		if (ret < 0) {
>   			fprintf(stderr, "error checking %s mount status\n",
> @@ -1471,9 +1492,10 @@ int main(int ac, char **av)
>   			fprintf(stderr, "%s is mounted\n", file);
>   			exit(1);
>   		}
> -		fd = open(file, O_RDWR);
> +		fd = open(file, O_RDWR|O_EXCL);
>   		if (fd < 0) {
> -			fprintf(stderr, "unable to open %s\n", file);
> +			fprintf(stderr, "unable to open %s: %s\n", file,
> +				strerror(errno));
>   			exit(1);
>   		}
>   		ret = btrfs_device_already_in_root(root, fd,
> diff --git a/utils.c b/utils.c
> index f9ee812..891edcc 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1386,3 +1386,78 @@ int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>
>   	return 0;
>   }
> +
> +#define isoctal(c)	(((c) & ~7) == '0')
> +
> +static inline void translate(char *f, char *t)
> +{
> +	while (*f != '\0') {
> +		if (*f == '\\' &&
> +		    isoctal(f[1]) && isoctal(f[2]) && isoctal(f[3])) {
> +			*t++ = 64*(f[1] & 7) + 8*(f[2] & 7) + (f[3] & 7);
> +			f += 4;
> +		} else
> +			*t++ = *f++;
> +	}
> +	*t = '\0';
> +	return;
> +}
> +
> +/*
> + * Checks if the swap device.
> + * Returns 1 if swap device, < 0 on error or 0 if not swap device.
> + */
> +int is_swap_device(const char *file)
> +{
> +	FILE	*f;
> +	struct stat	st_buf;
> +	dev_t	dev;
> +	ino_t	ino = 0;
> +	char	tmp[PATH_MAX];
> +	char	buf[PATH_MAX];
> +	char	*cp;
> +	int	ret = 0;
> +
> +	if (stat(file, &st_buf) < 0)
> +		return -errno;
> +	if (S_ISBLK(st_buf.st_mode))
> +		dev = st_buf.st_rdev;
> +	else if (S_ISREG(st_buf.st_mode)) {
> +		dev = st_buf.st_dev;
> +		ino = st_buf.st_ino;
> +	} else
> +		return 0;
> +
> +	if ((f = fopen("/proc/swaps", "r")) == NULL)
> +		return 0;
> +
> +	/* skip the first line */
> +	if (fgets(tmp, sizeof(tmp), f) == NULL)
> +		goto out;
> +
> +	while (fgets(tmp, sizeof(tmp), f) != NULL) {
> +		if ((cp = strchr(tmp, ' ')) != NULL)
> +			*cp = '\0';
> +		if ((cp = strchr(tmp, '\t')) != NULL)
> +			*cp = '\0';
> +		translate(tmp, buf);
> +		if (stat(buf, &st_buf) != 0)
> +			continue;
> +		if (S_ISBLK(st_buf.st_mode)) {
> +			if (dev == st_buf.st_rdev) {
> +				ret = 1;
> +				break;
> +			}
> +		} else if (S_ISREG(st_buf.st_mode)) {
> +			if (dev == st_buf.st_dev && ino == st_buf.st_ino) {
> +				ret = 1;
> +				break;
> +			}
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
>   		struct btrfs_ioctl_dev_info_args **di_ret);
>
>   char *__strncpy__null(char *dest, const char *src, size_t n);
> +int is_swap_device(const char *file);
>   /* Helper to always get proper size of the destination string */
>   #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


