Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9654 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751517AbaFMGIt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 02:08:49 -0400
Message-ID: <1402639424.6709.4.camel@localhost.localdomain>
Subject: Re: [PATCH v4] lib: add size unit t/p/e to memparse
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Brendan Hide <brendan@swiftspirit.co.za>
CC: <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
        <akpm@linux-foundation.org>
Date: Fri, 13 Jun 2014 14:03:44 +0800
In-Reply-To: <539A926B.7000204@swiftspirit.co.za>
References: <1402623746-1171-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <539A926B.7000204@swiftspirit.co.za>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-06-13 at 07:55 +0200, Brendan Hide wrote:
> On 13/06/14 03:42, Gui Hecheng wrote:
> > For modern filesystems such as btrfs, t/p/e size level operations
> > are common.
> > add size unit t/p/e parsing to memparse
> >
> > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > ---
> > changelog
> > 	v1->v2: replace kilobyte with kibibyte, and others
> > 	v2->v3: add missing unit "bytes" in comment
> > 	v3->v4: remove idiotic name for K,M,G,P,T,E
> > ---
> >   lib/cmdline.c | 15 ++++++++++-----
> >   1 file changed, 10 insertions(+), 5 deletions(-)
> >
> > diff --git a/lib/cmdline.c b/lib/cmdline.c
> > index d4932f7..76a712e 100644
> > --- a/lib/cmdline.c
> > +++ b/lib/cmdline.c
> > @@ -121,11 +121,7 @@ EXPORT_SYMBOL(get_options);
> >    *	@retptr: (output) Optional pointer to next char after parse completes
> >    *
> >    *	Parses a string into a number.  The number stored at @ptr is
> > - *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
> > - *	%M (for megabytes, or 1048576 bytes), or %G (for gigabytes, or
> > - *	1073741824).  If the number is suffixed with K, M, or G, then
> > - *	the return value is the number multiplied by one kilobyte, one
> > - *	megabyte, or one gigabyte, respectively.
> > + *	potentially suffixed with K, M, G, T, P, E.
> >    */
> >   
> >   unsigned long long memparse(const char *ptr, char **retptr)
> > @@ -135,6 +131,15 @@ unsigned long long memparse(const char *ptr, char **retptr)
> >   	unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
> >   
> >   	switch (*endptr) {
> > +	case 'E':
> > +	case 'e':
> > +		ret <<= 10;
> > +	case 'P':
> > +	case 'p':
> > +		ret <<= 10;
> > +	case 'T':
> > +	case 't':
> > +		ret <<= 10;
> >   	case 'G':
> >   	case 'g':
> >   		ret <<= 10;
> Ah, I see - you've removed all reference to their names. That's good too. :)
> 
Thank you for your review!
I think maybe more people would like cleaner things in the kernel.

-Gui

