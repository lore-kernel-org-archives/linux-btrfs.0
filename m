Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36638 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbeCKAK0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 19:10:26 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1euoXB-0008LX-VM
        for linux-btrfs@vger.kernel.org; Sun, 11 Mar 2018 01:08:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to replace a failed drive in btrfs RAID 1 filesystem
Date: Sun, 11 Mar 2018 00:08:11 +0000 (UTC)
Message-ID: <pan$8cfb6$4ed7e051$5bf7a95d$ea1cf3f5@cox.net>
References: <CAMoswehA9P+JEoLmrMcWDys8t_pgNQxjvSGsk5XHhshFo+=e-Q@mail.gmail.com>
        <923562e4-7069-7541-0500-e16c302893dc@gmail.com>
        <b9c2d96c-8b06-2cf7-6d04-a70a3d41b0e3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andrei Borzenkov posted on Sat, 10 Mar 2018 13:27:03 +0300 as excerpted:


> And "missing" is not the answer because I obviously may have more than
> one missing device.

"missing" is indeed the answer when using btrfs device remove.  See the 
btrfs-device manpage, which explains that if there's more than one device 
missing, either just the first one described by the metadata will be 
removed (if missing is only specified once), or missing can be specified 
multiple times.

raid6 with two devices missing is the only normal candidate for that 
presently, tho on-list we've seen aborted-add cases where it still worked 
as well, because while the metadata listed the new device it didn't 
actually have any data when it became apparent it was bad and thus needed 
to be removed again.

Note that because btrfs raid1 and raid10 only does two-way-mirroring 
regardless of the number of devices, and because of the per-chunk (as 
opposed to per-device) nature of btrfs raid10, those modes can only 
expect successful recovery with a single missing device, altho as 
mentioned above we've seen on-list at least one case where an aborted 
device-add of device found to be bad after the add didn't actually have 
anything on it, so it could still be removed along with the device it was 
originally intended to replace.

Of course the N-way-mirroring mode, whenever it eventually gets 
implemented, will allow missing devices upto N-1, and N-way-parity mode, 
if it's ever implemented, similar, but N-way-mirroring was scheduled for 
after raid56 mode so it could make use of some of the same code, and that 
has of course taken years on years to get merged and stabilize, and 
there's no sign yet of N-way-mirroring patches, which based on the raid56 
case could take years to stabilize and debug after original merge, so the 
still somewhat iffy raid6 mode is likely to remain the only normal usage 
of multiple missing for years, yet.

For btrfs replace, the manpage says ID's the only way to handle missing, 
but getting that ID, as you've indicated, could be difficult.  For 
filesystems with only a few devices that haven't had any or many device 
config changes, it should be pretty easy to guess (a two device 
filesystem with no changes should have IDs 1 and 2, so if only one is 
listed, the other is obvious, and a 3-4 device fs with only one or two 
previous device changes, likely well remembered by the admin, should 
still be reasonably easy to guess), but as the number of devices and the 
number of device adds/removes/replaces increases, finding/guessing the 
missing one becomes far more difficult.

Of course the sysadmin's first rule of backups states in simple form that 
not having one == defining the value of the data as trivial, not worth 
the trouble of a backup, which in turn means that at some point before 
there's /too/ many device change events, it's likely going to be less 
trouble (particularly after factoring in reliability) to restore from 
backups to a fresh filesystem than it is to do yet another device change, 
and together with the current practical limits btrfs imposes on the 
number of missing devices, that tends to impose /some/ limit on the 
possibilities for missing device IDs, so the situation, while not ideal, 
isn't yet /entirely/ out of hand, either, because a successful guess 
based on available information should be possible without /too/ many 
attempts.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

