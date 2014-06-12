Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932878AbaFLKPI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 06:15:08 -0400
Date: Thu, 12 Jun 2014 12:15:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: Improve the parse_size() error message.
Message-ID: <20140612101505.GM1903@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401327731-15769-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401327731-15769-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 29, 2014 at 09:42:11AM +0800, Qu Wenruo wrote:
> When using parse_size(), even non-numeric value is passed, it will only
> give error message "ERROR: size value is empty", which is quite
> confusing for end users.
> 
> This patch will introduce more meaningful error message for the
> following new cases
> 1) Invalid size string (non-numeric string)
> 2) Minus size value (like "-1K")
> 
> Also this patch will take full use of endptr returned by strtoll() to
> reduce unneeded loop.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  utils.c | 56 +++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 39 insertions(+), 17 deletions(-)
> 
> diff --git a/utils.c b/utils.c
> index 392c5cf..499f08f 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1612,18 +1612,45 @@ scan_again:
>  
>  u64 parse_size(char *s)
>  {
> -	int i;
>  	char c;
> +	char *endptr;
>  	u64 mult = 1;
> +	long long int signed_ret;
> +	u64 ret;
>  
> -	for (i = 0; s && s[i] && isdigit(s[i]); i++) ;
> -	if (!i) {
> -		fprintf(stderr, "ERROR: size value is empty\n");
> -		exit(50);
> +	if (!s) {
> +		fprintf(stderr, "ERROR: Size value is empty\n");
> +		exit(1);

We never pass a NULL pointer to parse_size so this check will be always
false. Previously it verified that there are at least some digits.

>  	}
> -
> -	if (s[i]) {
> -		c = tolower(s[i]);
> +	signed_ret = strtoll(s, &endptr, 10);
> +	if (endptr == s) {
> +		fprintf(stderr, "ERROR: Size value '%s' is invalid\n", s);
> +		exit(1);
> +	}
> +	if (endptr[0] && endptr[1]) {
> +		fprintf(stderr, "ERROR: Illegal suffix contains character '%c' in wrong position\n",
> +			endptr[1]);
> +		exit(1);
> +	}
> +	if (signed_ret <= 0) {
> +		fprintf(stderr,
> +			"ERROR: Size value '%s' is less equal than 0\n", s);
> +		exit(1);
> +	}
> +	/* strtoll returns LLONG_MAX when overflow, if this happens,
> +	 * need to call strtoull to get the real size */
> +	if (errno == ERANGE && signed_ret == LLONG_MAX) {
> +		ret = strtoull(s, NULL, 10);

Why do you parse the number twice? Negative sizes are currently not used
so you can reject them.

> +		if (errno == ERANGE && ret == ULLONG_MAX) {
> +			fprintf(stderr,
> +				"ERROR: Size value '%s' is too large for u64\n",
> +				s);
> +			exit(1);
> +		}
> +	} else
> +		ret = signed_ret;
> +	if (endptr[0]) {
> +		c = tolower(endptr[0]);
>  		switch (c) {
>  		case 'e':
>  			mult *= 1024;
> @@ -1646,18 +1673,13 @@ u64 parse_size(char *s)
>  		case 'b':
>  			break;
>  		default:
> -			fprintf(stderr, "ERROR: Unknown size descriptor "
> -				"'%c'\n", c);
> +			fprintf(stderr, "ERROR: Unknown size descriptor '%c'\n", c);
>  			exit(1);
>  		}
>  	}
> -	if (s[i] && s[i+1]) {
> -		fprintf(stderr, "ERROR: Illegal suffix contains "
> -			"character '%c' in wrong position\n",
> -			s[i+1]);
> -		exit(51);
> -	}
> -	return strtoull(s, NULL, 10) * mult;
> +
> +	ret *= mult;

Although there was no overflow check before, I think it should be here.
Eg. 12345678P is a valid size string but the result does not fit u64.

> +	return ret;
>  }
