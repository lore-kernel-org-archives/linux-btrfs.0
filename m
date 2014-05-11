Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.commandict.com.au ([203.190.234.55]:53606 "EHLO
	mascot.commandict.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaEKLIY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 07:08:24 -0400
Date: Sun, 11 May 2014 21:08:19 +1000
From: brett.king@commandict.com.au
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <c35fe9f3-038c-4aed-b245-5c501a65b544.maildroid@localhost>
In-Reply-To: <20140511092527.GB23212@carfax.org.uk>
References: <536f2c84.B0TBIV79nRteuoU7%brett.king@commandict.com.au>
 <20140511092527.GB23212@carfax.org.uk>
Subject: Re: RAID10 across different sized disks shows data layout as single
 not RAID10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----Original Message-----
From: Hugo Mills <hugo@carfax.org.uk>
To: brett.king@commandict.com.au
Cc: linux-btrfs@vger.kernel.org
Sent: Sun, 11 May 2014 7:25 PM
Subject: Re: RAID10 across different sized disks shows data layout as single not RAID10

On Sun, May 11, 2014 at 05:53:40PM +1000, brett.king@commandict.com.au wrote:
> Hi,

> I created a RAID10 array of 4x 4TB disks and later added another 4x
> 3TB disks, expecting the result to be the same level of fault
> tolerance however with simply more capacity. Recently I noticed the
> output of 'btrfs fi df' lists the Data layout as 'single' and not
> RAID10 per my initial mkfs.btrfs -d raid10 -m raid10 /dev/...
> command.

   That's odd. Was it fully RAID-10 before you added the other
devices?

I can't be certain as it was created many months ago, however yes I recall it was showing RAID10 for data on the first 4x disks.

 Looking at the btrfs fi df output, there's no vestigial
"single" chunks for your metadata, so it's been balanced at least
once. What can happen is that if the FS is balanced when new (i.e.
with no data in the data chunk -- so "touch foo" isn't sufficient),
the data chunk(s) are removed because there's no data in them. With no
data chunks at all, the FS then can't guess what type it should be
using, and falls back to single.

Ok sounds reasonable, though I wouldn't have thought it would be so fluid especially after creating it as a specific layout.

> Is this single data layout due to the overall inconsistent disk size
> used ? e.g. it can no longer fully stripe across all disks hence
> simply concatenates the subsequent smaller disks and displays this
> as an overall 'single' Data layout.

   No, it should be fine. With a balanced RAID-10 in your case, it
will fill up all 8 devices equally, until the smaller ones are full,
and then drop from 8 devices per stripe to 4, and continue to fill up
the remaining devices.

Great, this is what I wanted and expected.

> I require fault tolerance hence ultimately want to know if I
> actually do have a RAID10 data layout, else should try perhaps a
> 'btrfs fi balance start -dconvert=raid10 /export' (assuming enough
> free space exists).

   Yes, that would be the thing to do.

Ok fair enough, another balance now it's loaded with data to counter the first when empty.

 Note that you'll be _very_
close to full (of not actually full) after doing that, based on the
figures you've quoted below. You have 4*3.64 + 4*2.73 = 25.48 TiB of
raw space, which works out as 12.74 TiB of usable space under RAID-10,
so you're within 100 GiB of full. I'd suggest, if you can, shifting
100 GiB or so of data off to somewhere else temporarily while the
balance runs, just in case.

Yep will do (looking forward to being able to view usable space without manual calculation).

> I also noticed there are 2x System layouts shown, which leads me to
> think perhaps the first disks (4x4TB) are laid out as RAID10 for
> Data however the subsequent disks (4x3TB) are simply concatenated,
> giving me hopefully a limited level of fault tolerance for now.

   You'll note that the System/single is empty -- this is left over
from the mkfs process. There would originally have been similar small
empty chunks for Data and Metadata, but these will have gone away on
the first balance.

The phantom empty balance strikes again :) will see how it looks after another.

   As it stands, though, your data is not fault tolerant at all -- but
you're in with a good chance of recovering quite a lot of it if one
disk fails.

Bugger .. glad I asked, cheers.

   Hugo.

> [root@array ~]# uname -a
> Linux array.commandict.com.au 3.14.2-200.fc20.x86_64 #1 SMP Mon Apr 28 14:40:57 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
> [root@array ~]# btrfs --version
> Btrfs v3.12
> [root@array ~]# btrfs fi show
> Label: export  uuid: 22c7663a-93ca-40a6-9491-26abaa62b924
>         Total devices 8 FS bytes used 12.66TiB
>         devid    1 size 3.64TiB used 2.12TiB path /dev/sda
>         devid    2 size 3.64TiB used 2.12TiB path /dev/sde
>         devid    3 size 3.64TiB used 2.12TiB path /dev/sdi
>         devid    4 size 3.64TiB used 2.12TiB path /dev/sdg
>         devid    5 size 2.73TiB used 1.21TiB path /dev/sdb
>         devid    6 size 2.73TiB used 1.21TiB path /dev/sdf
>         devid    7 size 2.73TiB used 1.21TiB path /dev/sdh
>         devid    8 size 2.73TiB used 1.21TiB path /dev/sdj
> 
> Btrfs v3.12
> [root@array ~]# btrfs fi df /export
> Data, single: total=13.25TiB, used=12.65TiB
> System, RAID10: total=64.00MiB, used=1.41MiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID10: total=19.00GiB, used=16.47GiB
> [root@array ~]#
> 
> Thanks in advance,
> Brett.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- The glass is neither half-full nor half-empty; it is twice as ---  
                        large as it needs to be.                         
