Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36228 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752107AbcLETDz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 14:03:55 -0500
Received: by mail-pf0-f176.google.com with SMTP id 189so65076842pfz.3
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Dec 2016 11:03:54 -0800 (PST)
Date: Mon, 5 Dec 2016 11:03:46 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: utils: negative numbers are more
 plausible than sizes over 8 EiB
Message-ID: <20161205190346.GA6371@vader.DHCP.thefacebook.com>
References: <1480797594-2337-1-git-send-email-ce3g8jdj@umail.furryterror.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480797594-2337-1-git-send-email-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 03, 2016 at 03:39:54PM -0500, Zygo Blaxell wrote:
> I got tired of seeing "16.00EiB" whenever btrfs-progs encounters a
> negative size value, e.g. during resize:
> 
> Unallocated:
>    /dev/mapper/datamd18   16.00EiB
> 
> This version is much more useful:
> 
> Unallocated:
>    /dev/mapper/datamd18  -26.29GiB

Just checked and GCC 6.2.1 doesn't even enable -Wsign-conversion for
-Wextra, so this is probably the way to go.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> 
> ---
> v2: change the function prototype so it's easier to see that the
> mangling implied by the name "pretty" includes "reinterpretation
> of the u64 value as a signed quantity."
> ---
>  utils.c | 12 ++++++------
>  utils.h |  4 ++--
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/utils.c b/utils.c
> index 69b580a..07e8443 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -2575,7 +2575,7 @@ out:
>   * Note: this function uses a static per-thread buffer. Do not call this
>   * function more than 10 times within one argument list!
>   */
> -const char *pretty_size_mode(u64 size, unsigned mode)
> +const char *pretty_size_mode(s64 size, unsigned mode)
>  {
>  	static __thread int ps_index = 0;
>  	static __thread char ps_array[10][32];
> @@ -2594,20 +2594,20 @@ static const char* unit_suffix_binary[] =
>  static const char* unit_suffix_decimal[] =
>  	{ "B", "kB", "MB", "GB", "TB", "PB", "EB"};
>  
> -int pretty_size_snprintf(u64 size, char *str, size_t str_size, unsigned unit_mode)
> +int pretty_size_snprintf(s64 size, char *str, size_t str_size, unsigned unit_mode)
>  {
>  	int num_divs;
>  	float fraction;
> -	u64 base = 0;
> +	s64 base = 0;
>  	int mult = 0;
>  	const char** suffix = NULL;
> -	u64 last_size;
> +	s64 last_size;
>  
>  	if (str_size == 0)
>  		return 0;
>  
>  	if ((unit_mode & ~UNITS_MODE_MASK) == UNITS_RAW) {
> -		snprintf(str, str_size, "%llu", size);
> +		snprintf(str, str_size, "%lld", size);
>  		return 0;
>  	}
>  
> @@ -2642,7 +2642,7 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_size, unsigned unit_mod
>  			   num_divs = 0;
>  			   break;
>  	default:
> -		while (size >= mult) {
> +		while ((size < 0 ? -size : size) >= mult) {
>  			last_size = size;
>  			size /= mult;
>  			num_divs++;
> diff --git a/utils.h b/utils.h
> index 366ca29..525bde9 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -174,9 +174,9 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
>  int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
>  				 int super_offset);
>  
> -int pretty_size_snprintf(u64 size, char *str, size_t str_bytes, unsigned unit_mode);
> +int pretty_size_snprintf(s64 size, char *str, size_t str_bytes, unsigned unit_mode);
>  #define pretty_size(size) 	pretty_size_mode(size, UNITS_DEFAULT)
> -const char *pretty_size_mode(u64 size, unsigned mode);
> +const char *pretty_size_mode(s64 size, unsigned mode);
>  
>  u64 parse_size(char *s);
>  u64 parse_qgroupid(const char *p);
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
