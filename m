Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56846 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaGOPI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 11:08:29 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS hang with 3.16-rc5
Date: Tue, 15 Jul 2014 17:08:27 +0200
Message-ID: <1984661.CMGGdWA6Ux@merkaba>
In-Reply-To: <53C52AE4.6010803@fb.com>
References: <1502954.OtX3SzjMKZ@merkaba> <29286605.flGgbBIpOj@merkaba> <53C52AE4.6010803@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 15. Juli 2014, 09:21:40 schrieb Chris Mason:
> On 07/14/2014 05:58 PM, Martin Steigerwald wrote:
> > Am Montag, 14. Juli 2014, 16:12:22 schrieb Chris Mason:
> >> On 07/14/2014 11:10 AM, Martin Steigerwald wrote:
> >>> Am Montag, 14. Juli 2014, 17:04:22 schrieben Sie:
> >>>> Hi!
> >>>> 
> >>>> While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several days
> >>>> of
> >>>> usage, with 3-16-rc5 I had a hang again. Less than a hour since booting
> >>>> it.
> >>>> 
> >>>> Since the hang bug I and others had with 3.15 and upto 3.16-rc2 usually
> >>>> didn´t happen that quickly after boot and since backtrace looks a bit
> >>>> different from what I have in memory, I post this in a new thread.
> >>>> See thread "Blocked tasks on 3.15.1" for a discussion of previous hang
> >>>> issues.
> >>> 
> >>> Probably good to add some basic information on the filesystem:
> >> Do you have compression enabled?  I wasn't able to nail down the 3.15.1
> >> hang before vacation attacked me, but I'm hoping to track it down today.
> > 
> > Yes. I have.
> > 
> > It just hung again while I was playing PlaneShift.
> > 
> > Back to 3.16-rc4 as rc5 seems to be broke here.
> 
> The btrfs hang you're hitting goes back to 3.15.  So 3.16-rc4 vs rc5
> shouldn't be a factor.  Are you hitting other problems with 3.16?

So far for this day 3.16-rc4 behaves nicely. With 3.16-rc5 I had a BTRFS hang 
twice yesterday. 3.16-rc4 before also behaved nicely for several days or well 
about a week here.

So what I see here for now is: 3.15 until 3-16-rc2 an occassional hang, 3.16-
rc3 and 3.16-rc4 okay, 3.16-rc5 two hangs in one day and then I stopped using 
it as I use this laptop for production :).

This is on ThinkPad T520 with Sandybrige and 16 GiB RAM.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
