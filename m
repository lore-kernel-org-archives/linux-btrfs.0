Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:34997 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbcLCS0G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Dec 2016 13:26:06 -0500
Received: by mail-pg0-f52.google.com with SMTP id p66so119892914pga.2
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Dec 2016 10:25:19 -0800 (PST)
Date: Sat, 3 Dec 2016 10:25:17 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: utils: negative numbers are more plausible
 than sizes over 8 EiB
Message-ID: <20161203182517.GA18526@mew>
References: <1480745978-24996-1-git-send-email-ce3g8jdj@umail.furryterror.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480745978-24996-1-git-send-email-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 03, 2016 at 01:19:38AM -0500, Zygo Blaxell wrote:
> I got tired of seeing "16.00EiB" whenever btrfs-progs encounters a
> negative size value.
> 
> e.g. during filesystem shrink we see:
> 
> Unallocated:
>    /dev/mapper/testvol0   16.00EiB
> 
> Interpreting this as a signed quantity is much more useful:
> 
> Unallocated:
>    /dev/mapper/testvol0  -26.29GiB
> 
> Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> ---
>  utils.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/utils.c b/utils.c
> index 69b580a..bd2b66e 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -2594,20 +2594,23 @@ static const char* unit_suffix_binary[] =
>  static const char* unit_suffix_decimal[] =
>  	{ "B", "kB", "MB", "GB", "TB", "PB", "EB"};
>  
> -int pretty_size_snprintf(u64 size, char *str, size_t str_size, unsigned unit_mode)
> +int pretty_size_snprintf(u64 usize, char *str, size_t str_size, unsigned unit_mode)
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
> +	/* Negative numbers are more plausible than sizes over 8 EiB. */
> +	s64 size = (s64)usize;

Just make pretty_size_snprintf() take an s64 size so it's clear from the
function signature that it's signed instead of hidden in the definition.

> +
>  	if ((unit_mode & ~UNITS_MODE_MASK) == UNITS_RAW) {
> -		snprintf(str, str_size, "%llu", size);
> +		snprintf(str, str_size, "%lld", size);
>  		return 0;
>  	}
>  
> @@ -2642,7 +2645,7 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_size, unsigned unit_mod
>  			   num_divs = 0;
>  			   break;
>  	default:
> -		while (size >= mult) {
> +		while ((size < 0 ? -size : size) >= mult) {
>  			last_size = size;
>  			size /= mult;
>  			num_divs++;
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
