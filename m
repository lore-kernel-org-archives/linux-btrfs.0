Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42045 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaG1W6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 18:58:00 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, Cody P Schafer <dev@codyps.com>,
        Marc MERLIN <marc@merlins.org>
Subject: Re: BTRFS hang with 3.16-rc5 (and also with 3.16-rc4)
Date: Tue, 29 Jul 2014 00:57:57 +0200
Message-ID: <3028943.O2kv9eKhCx@merkaba>
In-Reply-To: <53D166C6.2070403@fb.com>
References: <1502954.OtX3SzjMKZ@merkaba> <1557956.045aK4K0qS@merkaba> <53D166C6.2070403@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 24. Juli 2014, 16:04:22 schrieb Chris Mason:
> On 07/24/2014 02:49 PM, Martin Steigerwald wrote:
> > Am Donnerstag, 24. Juli 2014, 10:58:51 schrieb Chris Mason:
> >> On 07/23/2014 06:47 PM, Martin Steigerwald wrote:
> >>> Am Dienstag, 15. Juli 2014, 17:08:27 schrieb Martin Steigerwald:
> >>>> Am Dienstag, 15. Juli 2014, 09:21:40 schrieb Chris Mason:
> >>>>> On 07/14/2014 05:58 PM, Martin Steigerwald wrote:
> >>>>>> Am Montag, 14. Juli 2014, 16:12:22 schrieb Chris Mason:
> >>>>>>> On 07/14/2014 11:10 AM, Martin Steigerwald wrote:
> >>>>>>>> Am Montag, 14. Juli 2014, 17:04:22 schrieben Sie:
> >>>>>>>>> Hi!
> >>>>>>>>> 
> >>>>>>>>> While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several
> >>>>>>>>> days
> >>>>>>>>> of
> >>>>>>>>> usage, with 3-16-rc5 I had a hang again. Less than a hour since
> >>>>>>>>> booting
> >>>>>>>>> it.
> >>>>>>>>> 
> >>>>>>>>> Since the hang bug I and others had with 3.15 and upto 3.16-rc2
> >>>>>>>>> usually
> >>>>>>>>> didn´t happen that quickly after boot and since backtrace looks a
> >>>>>>>>> bit
> >>>>>>>>> different from what I have in memory, I post this in a new thread.
> >>>>>>>>> See thread "Blocked tasks on 3.15.1" for a discussion of previous
> >>>>>>>>> hang
> >>>>>>>>> issues.
> >>>>>>>> 
> >>>>>>>> Probably good to add some basic information on the filesystem:
> >>>>>>> Do you have compression enabled?  I wasn't able to nail down the
> >>>>>>> 3.15.1
> >>>>>>> hang before vacation attacked me, but I'm hoping to track it down
> >>>>>>> today.
> >>>>>> 
> >>>>>> Yes. I have.
> >>>>>> 
> >>>>>> It just hung again while I was playing PlaneShift.
> >>>>>> 
> >>>>>> Back to 3.16-rc4 as rc5 seems to be broke here.
> >>>>> 
> >>>>> The btrfs hang you're hitting goes back to 3.15.  So 3.16-rc4 vs rc5
> >>>>> shouldn't be a factor.  Are you hitting other problems with 3.16?
> >>>> 
> >>>> So far for this day 3.16-rc4 behaves nicely. With 3.16-rc5 I had a
> >>>> BTRFS
> >>>> hang twice yesterday. 3.16-rc4 before also behaved nicely for several
> >>>> days
> >>>> or well about a week here.
> >>> 
> >>> 3.16-rc4 now hung as well…
> >> 
> >> Liu Bo has a promising patch:
> >> 
> >> https://urldefense.proofpoint.com/v1/url?u=https://patchwork.kernel.org/p
> >> atch/4618421/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2B
> >> QyA%3D%3D%0A&m=CJPREifRDOxlzhYeURx75h33LGU7YemJsNeLP%2FvXCv8%3D%0A&s=8fb0
> >> a70afce09530f16ea66a47d2af07966706b21281a7142d86256979013bab
> >> 
> >> Please give it a shot.  There's a second deadlock reading the free space
> >> cache, I'm still working on that one too.
> > 
> > Now running 3.16-rc6 + current git + this patch.
> > 
> > It may take some time tough cause during compiling the kernel BTRFS hung
> > again, which caused loss of KDE Baloo desktop search file index and parts
> > of a mail I wrote in KMail.
> > 
> > Since the patch mentioned ENOSPC issues but the filesystem has enough free
> > space according to df I shrunk the trees with
> 
> Thanks for giving it a try.  The ENOSPC mentioned here is looking for a
> contiguous extent, so it's easily possible to trigger that enospc
> without actually being full.

So far no lockup with 3.16.0-rc6-tp520-fixcompwrite+

But BTRFS still not used up all space for laying out trees after balance:

Label: 'home'  uuid: […]
        Total devices 2 FS bytes used 126.70GiB
        devid    1 size 160.00GiB used 156.00GiB path /dev/dm-0
        devid    2 size 160.00GiB used 156.00GiB path /dev/mapper/sata-home

May be a good sign nonetheless, thus mentioned.

Any other findings?

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
