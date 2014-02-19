Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:50890 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaBSPrC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 10:47:02 -0500
Message-ID: <5304D1F6.8040902@libero.it>
Date: Wed, 19 Feb 2014 16:47:02 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs-progs: new helper to parse string to u64 for
 btrfs
References: <1392808674-21656-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1392808674-21656-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392808674-21656-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Wang,

On 02/19/2014 12:17 PM, Wang Shilong wrote:
> There are many places that need parse string to u64 for btrfs commands,
> in fact, we do such things *too casually*, using atoi/atol/atoll..is not
> right at all, and even we don't check whether it is a valid string.
> 
> Let's do everything more gracefully, we introduce a new helper
> btrfs_strtoull() which will do all the necessary checks.If we fail to
> parse string to u64, we will output message and exit directly, this is
> something like what usage() is doing. It is ok to not return erro to
> it's caller, because this function should be called when parsing arg
> (just like usage!)

Please don't do that !

The error reporting of btrfs_strtoull is insufficient.
In case of invalid value the user is not able to 
understand what is the the wrong parameter. This because the error
reporting is handled by the function itself. We should improve the error 
messages, not hide them.


>From my point of view, you have only two choices:
1) change the api as
	u64 btrfs_strtoull(char *str, int *error)
   or 
	int btrfs_strtoull(char *str, u64 *value)

and let the function to return the error code in case of parsing error.
The caller has the responsibility to inform the user of the error.

2) change the api as

	u64 btrfs_strtoull(char *str, char *parameter_name)

so the function in case of error, is able to tell which parameters is wrong.

I prefer the #1.

BR
G.Baroncelli

> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  utils.c | 19 +++++++++++++++++++
>  utils.h |  1 +
>  2 files changed, 20 insertions(+)
> 
> diff --git a/utils.c b/utils.c
> index 97e23d5..0698d8d 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1520,6 +1520,25 @@ scan_again:
>  	return 0;
>  }
>  
> +u64 btrfs_strtoull(char *str, int base)
> +{
> +	u64 value;
> +	char *ptr_parse_end = NULL;
> +	char *ptr_str_end = str + strlen(str);
> +
> +	value = strtoull(str, &ptr_parse_end, base);
> +	if (ptr_parse_end != ptr_str_end) {
> +		fprintf(stderr, "ERROR: %s is not an invalid unsigned long long integer.\n",
> +				str);
> +		exit(1);
> +	}
> +	if (value == ULONG_MAX) {
> +		fprintf(stderr, "ERROR: %s is out of range.\n", str);
> +		exit(1);
> +	}
> +	return value;
> +}
> +
>  u64 parse_size(char *s)
>  {
>  	int i;
> diff --git a/utils.h b/utils.h
> index 04b8c45..094f41d 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -71,6 +71,7 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
>  int get_mountpt(char *dev, char *mntpt, size_t size);
>  int btrfs_scan_block_devices(int run_ioctl);
>  u64 parse_size(char *s);
> +u64 btrfs_strtoull(char *str, int base);
>  int open_file_or_dir(const char *fname, DIR **dirstream);
>  void close_file_or_dir(int fd, DIR *dirstream);
>  int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
