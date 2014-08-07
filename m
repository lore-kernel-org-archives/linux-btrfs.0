Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:46125 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaHGPMi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Aug 2014 11:12:38 -0400
Received: by mail-vc0-f170.google.com with SMTP id lf12so6471233vcb.29
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Aug 2014 08:12:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPoQQ-3ceufwBNUOGsObwX8AMC5LZBDy6imZD3BaX+8B2_=W-w@mail.gmail.com>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
 <53C7CD0F.7070603@fb.com> <CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com>
 <1745216.hDa4tC2HJJ@merkaba> <53CE7ACF.7070109@fb.com> <CAPoQQ-3ceufwBNUOGsObwX8AMC5LZBDy6imZD3BaX+8B2_=W-w@mail.gmail.com>
From: Tobias Holst <tobby@tobby.eu>
Date: Thu, 7 Aug 2014 17:12:17 +0200
Message-ID: <CAGwxe4iMg5fL=Ao5_7o86JTuXs0ttF3YsyBj+D-t_5+sBy8KAw@mail.gmail.com>
Subject: Re: Blocked tasks on 3.15.1
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

Is there anything new on this topic? I am using Ubuntu 14.04.1 and
experiencing the same problem.
- 6 HDDs
- LUKS on every HDD
- btrfs RAID6 over this 6 crypt-devices
No LVM, no nodatacow files.
Mount-options: defaults,compress-force=lzo,space_cache
With the original 3.13-kernel (3.13.0-32-generic) it is working fine.

Then I tried the following kernels from here:
http://kernel.ubuntu.com/~kernel-ppa/mainline/
linux-image-3.14.15-031415-generic_3.14.15-031415.201407311853_amd64.deb
- not even booting, kernel panic at boot.
linux-image-3.15.6-031506-generic_3.15.6-031506.201407172034_amd64.deb,
linux-image-3.15.7-031507-generic_3.15.7-031507.201407281235_amd64.deb,
and linux-image-3.16.0-031600-generic_3.16.0-031600.201408031935_amd64.deb
causing the hangs like described in this thread. When doing big IO
(unpacking a .rar-archive with multiple GB) the filesystem stops
working. Load stays very high but nothing actually happens on the
drives accoding to dstat. htop shows a D (uninterruptible sleep
(usually IO)) at many kworker-threads.
Unmounting of the btrfs-filesystem only works with -l (lazy) option.
Reboot or shutdown doesn't work because of the blocking threads. So
only a power cut works. After the reboot the last written data before
the hang is lost.

I am now back on 3.13.

Regards


2014-07-25 4:27 GMT+02:00 Cody P Schafer <dev@codyps.com>:
>
> On Tue, Jul 22, 2014 at 9:53 AM, Chris Mason <clm@fb.com> wrote:
> >
> >
> > On 07/19/2014 02:23 PM, Martin Steigerwald wrote:
> >
> >>> Running 3.15.6 with this patch applied on top:
> >>>  - still causes a hang with `rsync -hPaHAXx --del /mnt/home/nyx/ /home/nyx/`
> >>> - no extra error messages printed (`dmesg | grep racing`) compared to
> >>> without the patch
> >>
> >> I got same results with 3.16-rc5 + this patch (see thread BTRFS hang with
> >> 3.16-rc5). 3.16-rc4 still is fine with me. No hang whatsoever so far.
> >>
> >>> To recap some details (so I can have it all in one place):
> >>>  - /home/ is btrfs with compress=lzo
> >>
> >> BTRFS RAID 1 with lzo.
> >>
> >>>  - I have _not_ created any nodatacow files.
> >>
> >> Me neither.
> >>
> >>>  - Full stack is: sata <-> dmcrypt <-> lvm <-> btrfs (I noticed others
> >>> mentioning the use of dmcrypt)
> >>
> >> Same, except no dmcrypt.
> >>
> >
> > Thanks for the help in tracking this down everyone.  We'll get there!
> > Are you all running multi-disk systems (from a btrfs POV, more than one
> > device?)  I don't care how many physical drives this maps to, just does
> > btrfs think there's more than one drive.
>
> No, both of my btrfs filesystems are single disk.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
