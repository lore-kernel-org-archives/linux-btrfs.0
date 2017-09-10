Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39926 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbdIJPs3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 11:48:29 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dr4Sv-0004KW-N9
        for linux-btrfs@vger.kernel.org; Sun, 10 Sep 2017 17:48:09 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Help me understand what is going on with my RAID1 FS
Date: Sun, 10 Sep 2017 17:47:50 +0200
Message-ID: <20170910174750.544a4146@jupiter.sol.kaishome.de>
References: <CAOsOv4morDsVyrWEitL8L+7mXjS+0mXXsd9213Y8cdR44qrLYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 10 Sep 2017 15:45:42 +0200
schrieb FLJ <feci2048@gmail.com>:

> Hello all,
> 
> I have a BTRFS RAID1 volume running for the past year. I avoided all
> pitfalls known to me that would mess up this volume. I never
> experimented with quotas, no-COW, snapshots, defrag, nothing really.
> The volume is a RAID1 from day 1 and is working reliably until now.
> 
> Until yesterday it consisted of two 3 TB drives, something along the
> lines:
> 
> Label: 'BigVault'  uuid: a37ad5f5-a21b-41c7-970b-13b6c4db33db
>         Total devices 2 FS bytes used 2.47TiB
>         devid    1 size 2.73TiB used 2.47TiB path /dev/sdb
>         devid    2 size 2.73TiB used 2.47TiB path /dev/sdc
> 
> Yesterday I've added a new drive to the FS and did a full rebalance
> (without filters) over night, which went through without any issues.
> 
> Now I have:
>  Label: 'BigVault'  uuid: a37ad5f5-a21b-41c7-970b-13b6c4db33db
>         Total devices 3 FS bytes used 2.47TiB
>         devid    1 size 2.73TiB used 1.24TiB path /dev/sdb
>         devid    2 size 2.73TiB used 1.24TiB path /dev/sdc
>         devid    3 size 7.28TiB used 2.48TiB path /dev/sda
> 
> # btrfs fi df /mnt/BigVault/
> Data, RAID1: total=2.47TiB, used=2.47TiB
> System, RAID1: total=32.00MiB, used=384.00KiB
> Metadata, RAID1: total=4.00GiB, used=2.74GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> But still df -h is giving me:
> Filesystem           Size  Used Avail Use% Mounted on
> /dev/sdb             6.4T  2.5T  1.5T  63% /mnt/BigVault
> 
> Although I've heard and read about the difficulty in reporting free
> space due to the flexibility of BTRFS, snapshots and subvolumes, etc.,
> but I only have a single volume, no subvolumes, no snapshots, no
> quotas and both data and metadata are RAID1.
> 
> My expectation would've been that in case of BigVault Size == Used +
> Avail.
> 
> Actually based on http://carfax.org.uk/btrfs-usage/index.html I
> would've expected 6 TB of usable space. Here I get 6.4 which is odd,
> but that only 1.5 TB is available is even stranger.
> 
> Could anyone explain what I did wrong or why my expectations are
> wrong?
> 
> Thank you in advance

Btrfs reports estimated free space from the free space of the smallest
member as it can only guarantee that. In your case this is 2.73 minus
1.24 free which is roughly around 1.5T. But since this free space
distributes across three disks with one having much more free space, it
probably will use up that space at half the rate of actual allocation.
But due to how btrfs allocates from free space in chunks, that may not
be possible - thus the low unexpected value. You will probably need to
run balance once in a while to evenly redistribute allocated chunks
across all disks.

It may give you better estimates if you combine sdb and sdc into one
logical device, e.g. using raid0 or jbod via md or lvm.


-- 
Regards,
Kai

Replies to list-only preferred.

