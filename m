Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:36212 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752825Ab2JZNYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 09:24:07 -0400
Date: Fri, 26 Oct 2012 15:23:59 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Can't replace a faulty disk of raid1
Message-ID: <20121026132359.GW2052@vicerveza.homeunix.net>
References: <20121026105721.GU2052@vicerveza.homeunix.net>
 <20121026105954.GV2052@vicerveza.homeunix.net>
 <CAJHuE_CDmQhKt0i18WsFxVj_-hPNiAL6_fhkdt1b+eQnCUoDhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAJHuE_CDmQhKt0i18WsFxVj_-hPNiAL6_fhkdt1b+eQnCUoDhw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 26, 2012 at 01:41:58PM +0200, Goffredo Baroncelli wrote:
> Hi Luis
> 
> On Fri, Oct 26, 2012 at 12:59 PM, Lluís Batlle i Rossell
> <viric@viric.name> wrote:
> [...]
> >>
> >> I tried to remove the missing device, and it said "Input/output error" after a
> >> while. Next attempts simply gave "Invalid argument".
> 
> Todate BTRFS is not capable to remove (via btrfs device delete <path>)
> a missing disk. The user has to unmount the filesystem and remount-it
> in "degraded" mode.

Of course I was doing all I reported with the filesystem in degraded mount. The mount
log showed that. :)

I simply did the proper degraded mount at initrd time.

Regards,
Lluís.
