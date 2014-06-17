Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54949 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbaFQB3v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 21:29:51 -0400
Received: by mail-ie0-f175.google.com with SMTP id tp5so5794360ieb.20
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 18:29:50 -0700 (PDT)
Date: Mon, 16 Jun 2014 18:29:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH v4] lib: add size unit t/p/e to memparse
In-Reply-To: <1402968140.9806.6.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.02.1406161828180.21018@chino.kir.corp.google.com>
References: <1402623746-1171-1-git-send-email-guihc.fnst@cn.fujitsu.com> <alpine.DEB.2.02.1406131457480.31981@chino.kir.corp.google.com> <1402968140.9806.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 17 Jun 2014, Gui Hecheng wrote:

> > > diff --git a/lib/cmdline.c b/lib/cmdline.c
> > > index d4932f7..76a712e 100644
> > > --- a/lib/cmdline.c
> > > +++ b/lib/cmdline.c
> > > @@ -121,11 +121,7 @@ EXPORT_SYMBOL(get_options);
> > >   *	@retptr: (output) Optional pointer to next char after parse completes
> > >   *
> > >   *	Parses a string into a number.  The number stored at @ptr is
> > > - *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
> > > - *	%M (for megabytes, or 1048576 bytes), or %G (for gigabytes, or
> > > - *	1073741824).  If the number is suffixed with K, M, or G, then
> > > - *	the return value is the number multiplied by one kilobyte, one
> > > - *	megabyte, or one gigabyte, respectively.
> > > + *	potentially suffixed with K, M, G, T, P, E.
> > >   */
> > >  
> > >  unsigned long long memparse(const char *ptr, char **retptr)
> > > @@ -135,6 +131,15 @@ unsigned long long memparse(const char *ptr, char **retptr)
> > >  	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
> > >  
> > >  	switch (*endptr) {
> > > +	case 'E':
> > > +	case 'e':
> > > +		ret <<= 10;
> > > +	case 'P':
> > > +	case 'p':
> > > +		ret <<= 10;
> > > +	case 'T':
> > > +	case 't':
> > > +		ret <<= 10;
> > >  	case 'G':
> > >  	case 'g':
> > >  		ret <<= 10;
> > 
> > Seems fine since unsigned long long is always at least 64 bits, but 
> > perhaps also change simple_strtoull() to use kstrtoull() at the same time 
> > since the former is deprecated?
> 
> Yes, that is a point. But the deprecated function is a separate problem
> and may not be included in this patch.
> Also, I find that simple_strtoull is used in many places in the kernel
> code, it is better to replace it globally?
> 

If you're going to have a go at replacing the simple_strto*() functions 
throughout the kernel, it's probably better to do it per subsystem (as 
defined by the separate sections of MAINTAINERS) and propose the patches 
individually to those maintainers.  Once it has been removed entirely, you 
can submit a patch to remove the functions themselves.

Be aware that there are many callers to the deprecated functions so it may 
take a significant amount of time.
