Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60151 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755321AbbI1OHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 10:07:42 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, "'Qu Wenruo'" <quwenruo@cn.fujitsu.com>
References: <cover.1442396165.git.zhaolei@cn.fujitsu.com> <e4768fb11c5e7584b2211559c26d974517e70171.1442396165.git.zhaolei@cn.fujitsu.com> <20150925105002.GE11442@twin.jikos.cz>
In-Reply-To: <20150925105002.GE11442@twin.jikos.cz>
Subject: RE: [PATCH v2 1/2] btrfs-progs: Introduce warning and error for common use
Date: Mon, 28 Sep 2015 22:07:35 +0800
Message-ID: <01c901d0f9f7$06769f20$1363dd60$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

Thanks for review.

> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Friday, September 25, 2015 6:50 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org; Qu Wenruo <quwenruo@cn.fujitsu.com>
> Subject: Re: [PATCH v2 1/2] btrfs-progs: Introduce warning and error for
> common use
> 
> On Wed, Sep 16, 2015 at 05:40:46PM +0800, Zhao Lei wrote:
> > +static inline void __veprintf(const char *prefix, const char *format,
> > +			      va_list ap)
> > +{
> > +	if (prefix)
> > +		fprintf(stderr, "%s", prefix);
> > +	vfprintf(stderr, format, ap);
> 
> I'm not sure we need this helper. All it does it prints a fixed string, we can
> simply add fputs("prefix", stderr) into warning/error functions.
> 
This wrapper is to support locale in future:
Make all message output by one function, then we can put locale code into it
simply.

But now it is hard to introduce locale, because user-land tools
changes output frequently, we need to wait the output about fixed.

So I removed __veprintf() in v3, we can modify it when we need.
 
> > +static inline int warning_on(int condition, const char *fmt, ...) {
> > +	if (!condition)
> > +		return 0;
> > +
> > +	va_list args;
> 
> Please do not put declaration(s) after statements.
> 
Fixed in v3.

> > +static inline int error_on(int condition, const char *fmt, ...) {
> > +	if (!condition)
> > +		return 0;
> > +
> > +	va_list args;
> 
> dtto
> 
Fixed in v3.

Thanks
Zhaolei

> > +
> > +	va_start(args, fmt);
> > +	__veprintf("ERROR: ", fmt, args);
> > +	va_end(args);
> > +
> > +	return 1;
> > +}

