Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bitfolk.com ([85.119.80.223]:58740 "EHLO mail.bitfolk.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbbDAP3u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Apr 2015 11:29:50 -0400
Received: from andy by mail.bitfolk.com with local (Exim 4.72)
	(envelope-from <andy@strugglers.net>)
	id 1YdKIU-0006Cg-IZ
	for linux-btrfs@vger.kernel.org; Wed, 01 Apr 2015 15:11:14 +0000
Date: Wed, 1 Apr 2015 15:11:14 +0000
From: Andy Smith <andy@strugglers.net>
To: linux-btrfs@vger.kernel.org
Subject: Is this normal? Should I use scrub?
Message-ID: <20150401151114.GR4327@bitfolk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a 6 device RAID-1 filesystem:

$ sudo btrfs fi df /srv/tank
Data, RAID1: total=1.24TiB, used=1.24TiB
System, RAID1: total=32.00MiB, used=184.00KiB
Metadata, RAID1: total=3.00GiB, used=1.65GiB
unknown, single: total=512.00MiB, used=0.00
$ sudo btrfs fi sh /srv/tank
Label: 'tank'  uuid: 472ee2b3-4dc3-4fc1-80bc-5ba967069ceb
        Total devices 6 FS bytes used 1.24TiB
        devid    2 size 1.82TiB used 384.03GiB path /dev/sdh
        devid    3 size 1.82TiB used 383.00GiB path /dev/sdg
        devid    4 size 1.82TiB used 384.00GiB path /dev/sdf
        devid    5 size 2.73TiB used 1.13TiB path /dev/sdk
        devid    6 size 1.82TiB used 121.00GiB path /dev/sdj
        devid    7 size 2.73TiB used 116.00GiB path /dev/sde

Btrfs v3.14.2

All of these devices are in an external eSATA enclosure.

A few days ago (I believe) something went wrong with the enclosure
hardware and the SCSI bus kept getting reset over and over. At one
point three of the six devices were kicked out and the filesystem
was left running (read-only) on three devices.

Through some trial and error I determined that the enclosure was
taking exception to one of the devices, and by removing it I was
able to get things up and running with five devices, writeable,
mounted in degraded mode. /dev/sdk is the device that was kept out
of the filesystem.

I do not believe that there is anything wrong with /dev/sdk as I put
it in another system and was able to read it entirely, do SMART long
tests on it, etc.

I wasn't able to prove it is a hardware problem until I took the
enclosure out of service as it's the only enclosure I had. So that's
a task for later.

I have now got a new enclosure and put this system back together
with all six devices. I was not expecting this filesystem to mount
without assistance on boot because of /dev/sdk being "stale"
compared to the other devices. I suppose this incorrect view is a
holdover from my experience with mdadm.

Anyway, I booted it and /srv/tank was mounted automatically with all
six devices.  I got a bunch of these messages as soon as it was
mounted:

    http://pastie.org/private/2ghahjwtzlcm6hwp66hkg

There's lots more of it but it's all like that. That paste is from
the end of the log and there haven't been any more such message
since, so that's about 20 minutes (the times are in GMT).

Is that normal output indicating that btrfs is repairing the
"staleness" of sdk from the other copy?

I seem to be able to use the filesystem and a cursory inspection
isn't turning up anything that I can't read or that seems
corrupted. I will now run checksums against my last good backup.

Should I run a scrub as well?

Cheers,
Andy
