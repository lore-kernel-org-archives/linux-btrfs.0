Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2781 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754078AbaFQB1a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 21:27:30 -0400
Message-ID: <1402968140.9806.6.camel@localhost.localdomain>
Subject: Re: [PATCH v4] lib: add size unit t/p/e to memparse
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: David Rientjes <rientjes@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
        <akpm@linux-foundation.org>
Date: Tue, 17 Jun 2014 09:22:20 +0800
In-Reply-To: <alpine.DEB.2.02.1406131457480.31981@chino.kir.corp.google.com>
References: <1402623746-1171-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <alpine.DEB.2.02.1406131457480.31981@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-06-13 at 14:58 -0700, David Rientjes wrote:
> On Fri, 13 Jun 2014, Gui Hecheng wrote:
> 
> > diff --git a/lib/cmdline.c b/lib/cmdline.c
> > index d4932f7..76a712e 100644
> > --- a/lib/cmdline.c
> > +++ b/lib/cmdline.c
> > @@ -121,11 +121,7 @@ EXPORT_SYMBOL(get_options);
> >   *	@retptr: (output) Optional pointer to next char after parse completes
> >   *
> >   *	Parses a string into a number.  The number stored at @ptr is
> > - *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
> > - *	%M (for megabytes, or 1048576 bytes), or %G (for gigabytes, or
> > - *	1073741824).  If the number is suffixed with K, M, or G, then
> > - *	the return value is the number multiplied by one kilobyte, one
> > - *	megabyte, or one gigabyte, respectively.
> > + *	potentially suffixed with K, M, G, T, P, E.
> >   */
> >  
> >  unsigned long long memparse(const char *ptr, char **retptr)
> > @@ -135,6 +131,15 @@ unsigned long long memparse(const char *ptr, char **retptr)
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
> Seems fine since unsigned long long is always at least 64 bits, but 
> perhaps also change simple_strtoull() to use kstrtoull() at the same time 
> since the former is deprecated?

Yes, that is a point. But the deprecated function is a separate problem
and may not be included in this patch.
Also, I find that simple_strtoull is used in many places in the kernel
code, it is better to replace it globally?

-Gui

