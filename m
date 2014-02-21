Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371AbaBUPv5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 10:51:57 -0500
Message-ID: <53077614.2050909@redhat.com>
Date: Fri, 21 Feb 2014 09:51:48 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 1/4] Btrfs-progs: new helper to parse string to u64
 for btrfs
References: <1392962825-2967-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392962825-2967-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/21/14, 12:07 AM, Wang Shilong wrote:
> There are many places that need parse string to u64 for btrfs commands,
> in fact, we do such things *too casually*, using atoi/atol/atoll..is not
> right at all, and even we don't check whether it is a valid string.
> 
> Let's do everything more gracefully, we introduce a new helper
> arg_strtou64() which will do all the necessary checks.If we fail to
> parse string to u64, we will output message and exit directly, this is
> something like what usage() is doing. It is ok to not return erro to
> it's caller, because this function should be called when parsing arg
> (just like usage!)
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

I like it, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> v3->v4:
> 	move prefix '-' check after strtoull call, which will
> 	make negative output more precise to common users!(Thanks to Eric Sandeen)
> ---
>  utils.c | 33 +++++++++++++++++++++++++++++++++
>  utils.h |  1 +
>  2 files changed, 34 insertions(+)
> 
> diff --git a/utils.c b/utils.c
> index 97e23d5..9120877 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1520,6 +1520,39 @@ scan_again:
>  	return 0;
>  }
>  
> +/*
> + * This function should be only used when parsing
> + * command arg, it won't return error to it's
> + * caller and rather exit directly just like usage().
> + */
> +u64 arg_strtou64(const char *str)
> +{
> +	u64 value;
> +	char *ptr_parse_end = NULL;
> +
> +	value = strtoull(str, &ptr_parse_end, 0);
> +	if (ptr_parse_end && *ptr_parse_end != '\0') {
> +		fprintf(stderr, "ERROR: %s is not a valid numeric value.\n",
> +			str);
> +		exit(1);
> +	}
> +	/*
> +	 * if we pass a negative number to strtoull,
> +	 * it will return an unexpected number to us,
> +	 * so let's do the check ourselves.
> +	 */
> +	if (str[0] == '-') {
> +		fprintf(stderr, "ERROR: %s: negative value is invalid.\n",
> +			str);
> +		exit(1);
> +	}
> +	if (value == ULLONG_MAX) {
> +		fprintf(stderr, "ERROR: %s is too large.\n", str);
> +		exit(1);
> +	}
> +	return value;
> +}
> +
>  u64 parse_size(char *s)
>  {
>  	int i;
> diff --git a/utils.h b/utils.h
> index 04b8c45..a201085 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -71,6 +71,7 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
>  int get_mountpt(char *dev, char *mntpt, size_t size);
>  int btrfs_scan_block_devices(int run_ioctl);
>  u64 parse_size(char *s);
> +u64 arg_strtou64(const char *str);
>  int open_file_or_dir(const char *fname, DIR **dirstream);
>  void close_file_or_dir(int fd, DIR *dirstream);
>  int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
> 

