Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:50203 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752089AbeBVEX4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 23:23:56 -0500
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 6AA29AC01AE
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Feb 2018 13:23:51 +0900 (JST)
Subject: Re: [PATCH v2 16/27] btrfs-progs: use libbtrfsutil for read-only
 property
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
CC: <kernel-team@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
 <f906d40f5464b26fc9707a145254a48efac2ff50.1518720598.git.osandov@fb.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <954ea177-da85-ae8f-41d0-3e7d46b69158@jp.fujitsu.com>
Date: Thu, 22 Feb 2018 13:23:45 +0900
MIME-Version: 1.0
In-Reply-To: <f906d40f5464b26fc9707a145254a48efac2ff50.1518720598.git.osandov@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/02/16 4:05, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  messages.h | 13 ++++++++++++
>  props.c    | 69 +++++++++++++++++++++++---------------------------------------
>  2 files changed, 38 insertions(+), 44 deletions(-)
> 
> diff --git a/messages.h b/messages.h
> index 4999c7b9..004d5167 100644
> --- a/messages.h
> +++ b/messages.h
> @@ -54,6 +54,19 @@
>  			DO_ABORT_ON_ERROR;				\
>  	} while (0)
>  
> +#define error_btrfs_util(err)						\
> +	do {								\
> +		const char *errno_str = strerror(errno);		\
> +		const char *lib_str = btrfs_util_strerror(err)		\

"make D=trace" fails because ";" is missing here.

> +		PRINT_TRACE_ON_ERROR;					\
> +		PRINT_VERBOSE_ERROR;					\
> +		if (lib_str && strcmp(errno_str, lib_str) != 0)		\
> +			__btrfs_error("%s: %s", lib_str, errno_str);	\
> +		else							\
> +			__btrfs_error("%s", errno_str);			\
> +		DO_ABORT_ON_ERROR;					\
> +	} while (0)
> +
>  #define warning(fmt, ...)						\
>  	do {								\
>  		PRINT_TRACE_ON_ERROR;					\
> diff --git a/props.c b/props.c
> index cddbd927..e4edba06 100644
> --- a/props.c
> +++ b/props.c
> @@ -21,6 +21,8 @@
>  #include <fcntl.h>
>  #include <unistd.h>
>  
> +#include <btrfsutil.h>
> +
>  #include "ctree.h"
>  #include "commands.h"
>  #include "utils.h"
> @@ -41,56 +43,35 @@ static int prop_read_only(enum prop_object_type type,
>  			  const char *name,
>  			  const char *value)
>  {
> -	int ret = 0;
> -	int fd = -1;
> -	u64 flags = 0;
> -
> -	fd = open(object, O_RDONLY);
> -	if (fd < 0) {
> -		ret = -errno;
> -		error("failed to open %s: %s", object, strerror(-ret));
> -		goto out;
> -	}
> +	enum btrfs_util_error err;
> +	bool read_only;
>  
> -	ret = ioctl(fd, BTRFS_IOC_SUBVOL_GETFLAGS, &flags);
> -	if (ret < 0) {
> -		ret = -errno;
> -		error("failed to get flags for %s: %s", object,
> -				strerror(-ret));
> -		goto out;
> -	}
> -
> -	if (!value) {
> -		if (flags & BTRFS_SUBVOL_RDONLY)
> -			fprintf(stdout, "ro=true\n");
> -		else
> -			fprintf(stdout, "ro=false\n");
> -		ret = 0;
> -		goto out;
> -	}
> +	if (value) {
> +		if (!strcmp(value, "true")) {
> +			read_only = true;
> +		} else if (!strcmp(value, "false")) {
> +			read_only = false;
> +		} else {
> +			error("invalid value for property: %s", value);
> +			return -EINVAL;
> +		}
>  
> -	if (!strcmp(value, "true")) {
> -		flags |= BTRFS_SUBVOL_RDONLY;
> -	} else if (!strcmp(value, "false")) {
> -		flags = flags & ~BTRFS_SUBVOL_RDONLY;
> +		err = btrfs_util_set_subvolume_read_only(object, read_only);
> +		if (err) {
> +			error_btrfs_util(err);
> +			return -errno;
> +		}
>  	} else {
> -		ret = -EINVAL;
> -		error("invalid value for property: %s", value);
> -		goto out;
> -	}
> +		err = btrfs_util_get_subvolume_read_only(object, &read_only);
> +		if (err) {
> +			error_btrfs_util(err);
> +			return -errno;
> +		}
>  
> -	ret = ioctl(fd, BTRFS_IOC_SUBVOL_SETFLAGS, &flags);
> -	if (ret < 0) {
> -		ret = -errno;
> -		error("failed to set flags for %s: %s", object,
> -				strerror(-ret));
> -		goto out;
> +		printf("ro=%s\n", read_only ? "true" : "false");
>  	}
>  
> -out:
> -	if (fd != -1)
> -		close(fd);
> -	return ret;
> +	return 0;
>  }
>  
>  static int prop_label(enum prop_object_type type,
> 

