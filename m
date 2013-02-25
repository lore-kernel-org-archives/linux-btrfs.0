Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758826Ab3BYUYC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 15:24:02 -0500
Date: Mon, 25 Feb 2013 12:19:50 -0800
From: Zach Brown <zab@redhat.com>
To: kreijack@inwind.it
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/8] Add some helpers to manage the strings
 allocation/deallocation.
Message-ID: <20130225201950.GC1658@lenny.home.zabbo.net>
References: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com>
 <1361627171-8246-2-git-send-email-goffredo.baroncelli@yahoo.com>
 <512ACA84.3010408@redhat.com>
 <512BC2B2.2010108@tiscalinet.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <512BC2B2.2010108@tiscalinet.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>    printf("Disk size:\t\t%*s\n", width,
>         df_pretty_sizes(total_disk, mode));
> 
> it would be translated (note the '%*s'):
> 
>    if (mode == DF_HUMAN_UNIT)
> 	   printf("Disk size:\t\t%*s%s\n", width-2,
>         	df_pretty_sizes_number(total_disk),
> 		df_pretty_sizes_unit(total_disk));
>    else
> 	   printf("Disk size:\t\t%*lld\n", width, total_disk);

So use mode as the argument in the second case, just like you did in the
first.

printf("Disk dize:\t\t"sz_fmt"\n", sz_arg(total_disk, mode, width));

#define sz_fmt "%*llu%s"
#define sz_fmt(v,m,w) width(w, m), scaled(v, m), units(v, m)

And again, the reason we jump through these mildly distasteful hoops is
that *it gets rid of allocated strings entirely*.

That bug in df_pretty_sizes() where it allocates a 20 byte buffer to
store a string that can be 21 bytes long with its null?  It'd just
vanish.  Not needed.

The only code that is *sure* to be bug free is the code that doesn't
exist.

> To avoid all this mess, we should add another conversion specifier with
> the function register_printf_function(). Unfortunately I was not able to
> find the equivalent one for sprintf().

Doesn't that prevent compile-time verification that the types of the
format specifiers match the arguments?

- z
