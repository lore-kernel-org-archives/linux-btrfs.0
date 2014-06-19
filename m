Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:60132 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbaFSLcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 07:32:52 -0400
Received: by mail-we0-f178.google.com with SMTP id x48so2153382wes.23
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 04:32:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140425191448.GJ2391@carfax.org.uk>
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung>
	<75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com>
	<535AA581.1080301@gmail.com>
	<20140425191448.GJ2391@carfax.org.uk>
Date: Thu, 19 Jun 2014 14:32:51 +0300
Message-ID: <CAOcd+r0fo55dC2QbPwdwpCB+GD7HR7wrrn3s+srrsNSnrNECjA@mail.gmail.com>
Subject: Re: safe/necessary to balance system chunks?
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>, Steve Leung <sjleung@shaw.ca>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 25, 2014 at 10:14 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Apr 25, 2014 at 02:12:17PM -0400, Austin S Hemmelgarn wrote:
>> On 2014-04-25 13:24, Chris Murphy wrote:
>> >
>> > On Apr 25, 2014, at 8:57 AM, Steve Leung <sjleung@shaw.ca> wrote:
>> >
>> >>
>> >> Hi list,
>> >>
>> >> I've got a 3-device RAID1 btrfs filesystem that started out life as single-device.
>> >>
>> >> btrfs fi df:
>> >>
>> >> Data, RAID1: total=1.31TiB, used=1.07TiB
>> >> System, RAID1: total=32.00MiB, used=224.00KiB
>> >> System, DUP: total=32.00MiB, used=32.00KiB
>> >> System, single: total=4.00MiB, used=0.00
>> >> Metadata, RAID1: total=66.00GiB, used=2.97GiB
>> >>
>> >> This still lists some system chunks as DUP, and not as RAID1.  Does this mean that if one device were to fail, some system chunks would be unrecoverable?  How bad would that be?
>> >
>> > Since it's "system" type, it might mean the whole volume is toast if the drive containing those 32KB dies. I'm not sure what kind of information is in system chunk type, but I'd expect it's important enough that if unavailable that mounting the file system may be difficult or impossible. Perhaps btrfs restore would still work?
>> >
>> > Anyway, it's probably a high penalty for losing only 32KB of data.  I think this could use some testing to try and reproduce conversions where some amount of "system" or "metadata" type chunks are stuck in DUP. This has come up before on the list but I'm not sure how it's happening, as I've never encountered it.
>> >
>> As far as I understand it, the system chunks are THE root chunk tree for
>> the entire system, that is to say, it's the tree of tree roots that is
>> pointed to by the superblock. (I would love to know if this
>> understanding is wrong).  Thus losing that data almost always means
>> losing the whole filesystem.
>
>    From a conversation I had with cmason a while ago, the System
> chunks contain the chunk tree. They're special because *everything* in
> the filesystem -- including the locations of all the trees, including
> the chunk tree and the roots tree -- is positioned in terms of the
> internal virtual address space. Therefore, when starting up the FS,
> you can read the superblock (which is at a known position on each
> device), which tells you the virtual address of the other trees... and
> you still need to find out where that really is.
>
>    The superblock has (I think) a list of physical block addresses at
> the end of it (sys_chunk_array), which allows you to find the blocks
> for the chunk tree and work out this mapping, which allows you to find
> everything else. I'm not 100% certain of the actual format of that
> array -- it's declared as u8 [2048], so I'm guessing there's a load of
> casting to something useful going on in the code somewhere.
The format is just a list of pairs:
struct btrfs_disk_key,  struct btrfs_chunk
struct btrfs_disk_key,  struct btrfs_chunk
...

For each SYSTEM block-group (btrfs_chunk), we need one entry in the
sys_chunk_array. During mkfs the first SYSTEM block group is created,
for me its 4MB. So only if the whole chunk tree grows over 4MB, we
need to create an additional SYSTEM block group, and then we need to
have a second entry in the sys_chunk_array. And so on.

Alex.


>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>     --- Is it still called an affair if I'm sleeping with my wife ---
>                         behind her lover's back?
