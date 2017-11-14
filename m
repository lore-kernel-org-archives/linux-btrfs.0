Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:47670 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752704AbdKNMib (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 07:38:31 -0500
Date: Tue, 14 Nov 2017 13:38:29 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Klaus Agnoletti <klaus@agnoletti.dk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: A partially failing disk in raid0 needs replacement
Message-ID: <20171114123829.r4kmvsp6aeuylo67@angband.pl>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 14, 2017 at 10:36:22AM +0200, Klaus Agnoletti wrote:
> I used to have 3x2TB in a btrfs in raid0. A few weeks ago, one of the
                                     ^^^^^
> 2TB disks started giving me I/O errors in dmesg like this:
> 
> [388659.188988] Add. Sense: Unrecovered read error - auto reallocate failed

Alas, chances to recover anything are pretty slim.  That's RAID0 metadata
for you.

On the other hand, losing any non-trivial file while being able to gape at
intact metadata isn't that much better, thus -mraid0 isn't completely
unreasonable.

> To fix it, it ended up with me adding a new 6TB disk and trying to
> delete the failing 2TB disks.
> 
> That didn't go so well; apparently, the delete command aborts when
> ever it encounters I/O errors. So now my raid0 looks like this:
> 
> klaus@box:~$ sudo btrfs fi show
> [sudo] password for klaus:
> Label: none  uuid: 5db5f82c-2571-4e62-a6da-50da0867888a
>         Total devices 4 FS bytes used 5.14TiB
>         devid    1 size 1.82TiB used 1.78TiB path /dev/sde
>         devid    2 size 1.82TiB used 1.78TiB path /dev/sdf
>         devid    3 size 0.00B used 1.49TiB path /dev/sdd
>         devid    4 size 5.46TiB used 305.21GiB path /dev/sdb

> Obviously, I want /dev/sdd emptied and deleted from the raid.
> 
> So how do I do that?
> 
> I thought of three possibilities myself. I am sure there are more,
> given that I am in no way a btrfs expert:
> 
> 1)Try to force a deletion of /dev/sdd where btrfs copies all intact
> data to the other disks
> 2) Somehow re-balances the raid so that sdd is emptied, and then deleted
> 3) converting into a raid1, physically removing the failing disk,
> simulating a hard error, starting the raid degraded, and converting it
> back to raid0 again.

There's hardly any intact data: roughly 2/3 of chunks have half of their
blocks on the failed disk, densely interspersed.  Even worse, metadata
required to map those blocks to files is gone, too: if we naively assume
there's only a single tree, a tree node is intact only if it and every
single node on the path to the root is intact.  In practice, this means
it's a total filesystem loss.

> How do you guys think I should go about this? Given that it's a raid0
> for a reason, it's not the end of the world losing all data, but I'd
> really prefer losing as little as possible, obviously.

As the disk isn't _completely_ gone, there's a slim chance of some stuff
requiring only still-readable sectors.  Probably a waste of time to try
to recover, though.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ Laws we want back: Poland, Dz.U. 1921 nr.30 poz.177 (also Dz.U. 
⣾⠁⢰⠒⠀⣿⡁ 1920 nr.11 poz.61): Art.2: An official, guilty of accepting a gift
⢿⡄⠘⠷⠚⠋⠀ or another material benefit, or a promise thereof, [in matters
⠈⠳⣄⠀⠀⠀⠀ relevant to duties], shall be punished by death by shooting.
