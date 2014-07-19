Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46616 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732AbaGSApI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 20:45:08 -0400
Date: Fri, 18 Jul 2014 17:44:57 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: Cody P Schafer <dev@codyps.com>, Chris Samuel <chris@csamuel.org>,
        linux-btrfs@vger.kernel.org
Message-ID: <20140719004457.GC11996@merlins.org>
References: <53B1A862.50503@fb.com>
 <53B1ACAA.5040505@fb.com>
 <CAPoQQ-14VPzzwTDDXmLSmEUs2Rm_HyukoYjeFfOi9LOjqaRCWw@mail.gmail.com>
 <53B32275.6010200@fb.com>
 <CAPoQQ-3DmAg=s0eBKirGmkfMhaC1bEyJu8fSJc-6fV-EvUbmxQ@mail.gmail.com>
 <CAPoQQ-1kn+UNfcE4+qeO4yKaX43PenqxBtMXABuP=Ot8=ZB2Gw@mail.gmail.com>
 <53B40FEC.4030902@fb.com>
 <53B4140C.8060406@fb.com>
 <53C7CD0F.7070603@fb.com>
 <20140719003345.GB11996@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140719003345.GB11996@merlins.org>
Subject: Re: Blocked tasks on 3.15.1, raid1 btrfs is no ends of trouble for me
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 18, 2014 at 05:33:45PM -0700, Marc MERLIN wrote:
> Howver, I have found that btrfs raid 1 on top of dmcrypt has given me no ends of trouble.
> I lost that filesystem twice due to corruption, and now it hangs my machine (strace finds
> that df is hanging on that partition).
> gargamel:~# btrfs fi df /mnt/btrfs_raid0
> Data, RAID1: total=222.00GiB, used=221.61GiB
> Data, single: total=8.00MiB, used=0.00
> System, RAID1: total=8.00MiB, used=48.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=2.00GiB, used=1.10GiB
> Metadata, single: total=8.00MiB, used=0.00
> unknown, single: total=384.00MiB, used=0.00
> gargamel:~# btrfs fi show /mnt/btrfs_raid0
> Label: 'btrfs_raid0'  uuid: 74279e10-46e7-4ac4-8216-a291819a6691
>         Total devices 2 FS bytes used 222.71GiB
>         devid    1 size 836.13GiB used 224.03GiB path /dev/dm-3
>         devid    2 size 836.13GiB used 224.01GiB path /dev/mapper/raid0d2
> 
> Btrfs v3.14.1
> 
> 
> This is not encouraging, I think I'm going to stop using raid1 in btrfs :(

Sorry, this may be a bit misleading. I actually lost 2 filesystems that
were raid0 on top of dmcrypt.
This time it's raid1, and the data isn't lost, but btrfs is tripping all
over itself and taking my whole system apparently because of that
filesystem.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
