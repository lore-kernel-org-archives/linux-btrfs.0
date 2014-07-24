Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:40758 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059AbaGXStj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 14:49:39 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, Cody P Schafer <dev@codyps.com>,
        Marc MERLIN <marc@merlins.org>
Subject: Re: BTRFS hang with 3.16-rc5 (and also with 3.16-rc4)
Date: Thu, 24 Jul 2014 20:49:37 +0200
Message-ID: <1557956.045aK4K0qS@merkaba>
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

Now running 3.16-rc6 + current git + this patch.

It may take some time tough cause during compiling the kernel BTRFS hung 
again, which caused loss of KDE Baloo desktop search file index and parts of a 
mail I wrote in KMail.

Since the patch mentioned ENOSPC issues but the filesystem has enough free 
space according to df I shrunk the trees with

btrfs balance start -musage=50 /home
btrfs balance start -musage=50 /home


merkaba:~> btrfs fi sh /home                   
Label: 'home'  uuid: […]
        Total devices 2 FS bytes used 124.05GiB
        devid    1 size 160.00GiB used 150.00GiB path /dev/mapper/msata-home
        devid    2 size 160.00GiB used 150.00GiB path /dev/dm-3


As I bet that the error is more likely to happen when trees occupy all space, 
it may take some time till it happens again.

Well its growing slowly already:

merkaba:~> btrfs fi df /home
Data, RAID1: total=146.97GiB, used=121.84GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=4.00GiB, used=2.62GiB
unknown, single: total=512.00MiB, used=0.00
merkaba:~> btrfs fi sh /home
Label: 'home'  uuid: […]
        Total devices 2 FS bytes used 124.46GiB
        devid    1 size 160.00GiB used 151.00GiB path /dev/dm-0
        devid    2 size 160.00GiB used 151.00GiB path /dev/mapper/sata-home

Btrfs v3.14.1


I wonder why ENOSPC conditions happens with that much space inside trees free. 
Were they just too fragmented?

To me

merkaba:~> LANG=C df -hT /home
Filesystem     Type   Size  Used Avail Use% Mounted on
/dev/dm-0      btrfs  320G  249G   69G  79% /home

is a quite healthy free space margin.


Well, lets see how this goes.

I hope it can be fixed soon as it causes loss of recently saved data and 
generally locks up a machine running KDE desktop quite quickly on a BTRFS 
hang.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
