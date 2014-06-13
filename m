Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31411 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750913AbaFMBiK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 21:38:10 -0400
Message-ID: <1402623184.818.1.camel@localhost.localdomain>
Subject: Re: [PATCH v3] lib: add size unit t/p/e to memparse
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
        <1i5t5.duncan@cox.net>
Date: Fri, 13 Jun 2014 09:33:04 +0800
In-Reply-To: <20140612141516.219f8c6b95f0d4f97332b8c7@linux-foundation.org>
References: <1396428877-24089-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140612141516.219f8c6b95f0d4f97332b8c7@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-06-12 at 14:15 -0700, Andrew Morton wrote:
> On Wed, 2 Apr 2014 16:54:37 +0800 Gui Hecheng <guihc.fnst@cn.fujitsu.com> wrote:
> 
> > For modern filesystems such as btrfs, t/p/e size level operations
> > are common.
> > add size unit t/p/e parsing to memparse
> > 
> > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > ---
> > changelog
> > 	v1->v2: replace kilobyte with kibibyte, and others
> > 	v2->v3: add missing unit "bytes" in comment
> > ---
> >  lib/cmdline.c | 25 ++++++++++++++++++++-----
> >  1 file changed, 20 insertions(+), 5 deletions(-)
> > 
> > diff --git a/lib/cmdline.c b/lib/cmdline.c
> > index eb67911..511b9be 100644
> > --- a/lib/cmdline.c
> > +++ b/lib/cmdline.c
> > @@ -119,11 +119,17 @@ char *get_options(const char *str, int nints, int *ints)
> >   *	@retptr: (output) Optional pointer to next char after parse completes
> >   *
> >   *	Parses a string into a number.  The number stored at @ptr is
> > - *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
> > - *	%M (for megabytes, or 1048576 bytes), or %G (for gigabytes, or
> > - *	1073741824).  If the number is suffixed with K, M, or G, then
> > - *	the return value is the number multiplied by one kilobyte, one
> > - *	megabyte, or one gigabyte, respectively.
> > + *	potentially suffixed with
> > + *	%K (for kibibytes, or 1024 bytes),
> > + *	%M (for mebibytes, or 1048576 bytes),
> > + *	%G (for gibibytes, or 1073741824 bytes),
> > + *	%T (for tebibytes, or 1099511627776 bytes),
> > + *	%P (for pebibytes, or 1125899906842624 bytes),
> > + *	%E (for exbibytes, or 1152921504606846976 bytes).
> 
> I'm afraid I find these names quite idiotic - we all know what the
> traditional terms mean so why go and muck with it.
> 
> Also, kibibytes sounds like cat food.

Yes, I will cleanup this part, Thanks very much.

-Gui

> > @@ -133,6 +139,15 @@ unsigned long long memparse(const char *ptr, char **retptr)
> >  	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
> >  
> >  	switch (*endptr) {
> > +	case 'E':
> > +	case 'e':
> > +		ret <<= 10;
> > +	case 'P':
> > +	case 'p':
> > +		ret <<= 10;
> > +	case 'T':
> > +	case 't':
> > +		ret <<= 10;
> >  	case 'G':
> >  	case 'g':
> >  		ret <<= 10;
> 
> That bit makes sense.


