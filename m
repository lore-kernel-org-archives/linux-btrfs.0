Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaE1RUU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 13:20:20 -0400
Date: Wed, 28 May 2014 19:20:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Improve the parse_size() error message.
Message-ID: <20140528172017.GS5346@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400572305-19818-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400572305-19818-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 20, 2014 at 03:51:45PM +0800, Qu Wenruo wrote:
> When using parse_size(), even non-numeric value is passed, it will only
> give error message "ERROR: size value is empty", which is quite
> confusing for end users.
> 
> This patch will introduce more meaningful error message for the
> following new cases
> 1) Invalid size string (non-numeric string)
> 2) Minus size value (like "-1K")

That's great. A few things below

>  u64 parse_size(char *s)
>  {
> -	int i;
>  	char c;
>  	u64 mult = 1;
> -
> -	for (i = 0; s && s[i] && isdigit(s[i]); i++) ;
> -	if (!i) {
> -		fprintf(stderr, "ERROR: size value is empty\n");
> -		exit(50);
> -	}
> -
> -	if (s[i]) {
> -		c = tolower(s[i]);
> +	long long int ret = 0;
> +	char *endptr;
> +
> +	if (!s)
> +		goto empty;
> +	ret = strtoll(s, &endptr, 10);

> -	return strtoull(s, NULL, 10) * mult;

Now it does not parse sizes from the range LLONG_MAX to ULLONG_MAX (8EiB
to 16EiB). Though we don't have problems with such sizes in real life,
I'd rather keep strtoull so it matches the advertised maximum filesystem
size.

Negative numbers can be simply identified by leading '-'. The only case
where negative number is allowed is in 'fi resize', but the string is
passed to kernel as-is.

> +empty:
> +	fprintf(stderr, "ERROR: Size value is empty\n");
> +	exit(50);
> +suffix:
> +	fprintf(stderr, "ERROR: Illegal suffix contains character '%c' in wrong position\n",
> +		endptr[1]);
> +	exit(51);
> +descriptor:
> +	fprintf(stderr, "ERROR: Unknown size descriptor '%c'\n", c);
> +	exit(52);
> +invalid:
> +	fprintf(stderr, "ERROR: Size value '%s' is invalid\n", s);
> +	exit(53);
> +minus:
> +	fprintf(stderr, "ERROR: Size value '%s' is less equal than 0\n", s);
> +	exit(54);

Please get rid of the error codes, use exit(1). The messages should be
enough to find out what's wrong.
