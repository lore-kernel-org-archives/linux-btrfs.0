Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbbIYKvA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 06:51:00 -0400
Date: Fri, 25 Sep 2015 12:50:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2 1/2] btrfs-progs: Introduce warning and error for
 common use
Message-ID: <20150925105002.GE11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1442396165.git.zhaolei@cn.fujitsu.com>
 <e4768fb11c5e7584b2211559c26d974517e70171.1442396165.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e4768fb11c5e7584b2211559c26d974517e70171.1442396165.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 16, 2015 at 05:40:46PM +0800, Zhao Lei wrote:
> +static inline void __veprintf(const char *prefix, const char *format,
> +			      va_list ap)
> +{
> +	if (prefix)
> +		fprintf(stderr, "%s", prefix);
> +	vfprintf(stderr, format, ap);

I'm not sure we need this helper. All it does it prints a fixed string,
we can simply add fputs("prefix", stderr) into warning/error functions.

> +static inline int warning_on(int condition, const char *fmt, ...)
> +{
> +	if (!condition)
> +		return 0;
> +
> +	va_list args;

Please do not put declaration(s) after statements.

> +static inline int error_on(int condition, const char *fmt, ...)
> +{
> +	if (!condition)
> +		return 0;
> +
> +	va_list args;

dtto

> +
> +	va_start(args, fmt);
> +	__veprintf("ERROR: ", fmt, args);
> +	va_end(args);
> +
> +	return 1;
> +}
