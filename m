Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57206 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbaGXQYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 12:24:43 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, Cody P Schafer <dev@codyps.com>,
        Marc MERLIN <marc@merlins.org>
Subject: Re: BTRFS hang with 3.16-rc5 (and also with 3.16-rc4)
Date: Thu, 24 Jul 2014 18:24:40 +0200
Message-ID: <2270420.7Gkuf5KIN8@merkaba>
In-Reply-To: <53D11F2B.1070008@fb.com>
References: <1502954.OtX3SzjMKZ@merkaba> <1809953.ithLVmijbn@merkaba> <53D11F2B.1070008@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 24. Juli 2014, 10:58:51 schrieb Chris Mason:
> On 07/23/2014 06:47 PM, Martin Steigerwald wrote:
> > Am Dienstag, 15. Juli 2014, 17:08:27 schrieb Martin Steigerwald:
> >> Am Dienstag, 15. Juli 2014, 09:21:40 schrieb Chris Mason:
> >>> On 07/14/2014 05:58 PM, Martin Steigerwald wrote:
> >>>> Am Montag, 14. Juli 2014, 16:12:22 schrieb Chris Mason:
> >>>>> On 07/14/2014 11:10 AM, Martin Steigerwald wrote:
> >>>>>> Am Montag, 14. Juli 2014, 17:04:22 schrieben Sie:
> >>>>>>> Hi!
> >>>>>>> 
> >>>>>>> While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several
> >>>>>>> days
> >>>>>>> of
> >>>>>>> usage, with 3-16-rc5 I had a hang again. Less than a hour since
> >>>>>>> booting
> >>>>>>> it.
> >>>>>>> 
> >>>>>>> Since the hang bug I and others had with 3.15 and upto 3.16-rc2
> >>>>>>> usually
> >>>>>>> didn´t happen that quickly after boot and since backtrace looks a
> >>>>>>> bit
> >>>>>>> different from what I have in memory, I post this in a new thread.
> >>>>>>> See thread "Blocked tasks on 3.15.1" for a discussion of previous
> >>>>>>> hang
> >>>>>>> issues.
> >>>>>> 
> >>>>>> Probably good to add some basic information on the filesystem:
> >>>>> Do you have compression enabled?  I wasn't able to nail down the
> >>>>> 3.15.1
> >>>>> hang before vacation attacked me, but I'm hoping to track it down
> >>>>> today.
> >>>> 
> >>>> Yes. I have.
> >>>> 
> >>>> It just hung again while I was playing PlaneShift.
> >>>> 
> >>>> Back to 3.16-rc4 as rc5 seems to be broke here.
> >>> 
> >>> The btrfs hang you're hitting goes back to 3.15.  So 3.16-rc4 vs rc5
> >>> shouldn't be a factor.  Are you hitting other problems with 3.16?
> >> 
> >> So far for this day 3.16-rc4 behaves nicely. With 3.16-rc5 I had a BTRFS
> >> hang twice yesterday. 3.16-rc4 before also behaved nicely for several
> >> days
> >> or well about a week here.
> > 
> > 3.16-rc4 now hung as well…
> 
> Liu Bo has a promising patch:
> 
> https://patchwork.kernel.org/patch/4618421/
> 
> Please give it a shot.  There's a second deadlock reading the free space
> cache, I'm still working on that one too.

Okay, I reverted your printk patch and applied this on on git linus git.

Lets see how this works.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
