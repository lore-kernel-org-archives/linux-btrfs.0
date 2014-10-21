Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40143 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618AbaJUV2Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 17:28:25 -0400
Date: Tue, 21 Oct 2014 23:28:22 +0200
From: Petr Janecek <janecek@ucw.cz>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs-progs release 3.17
Message-ID: <20141021212822.GA22009@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> the version 3.17 of btrfs-progs has been released.

  on a system with 3-disk raid1 and 4 and 5-disk raid10 fs,
"btrfs filesystem show" now stalls for approx. half a minute after the
listing, just before the version information. During that time, it
often prints something like

[...]
        devid    4 size 2.73TiB used 806.01GiB path /dev/sdh
        devid    5 size 3.64TiB used 123.00GiB path /dev/sdp

parent transid verify failed on 2636556500992 wanted 2264 found 2268
parent transid verify failed on 2636556500992 wanted 2264 found 2268
parent transid verify failed on 2636556500992 wanted 2264 found 2268
parent transid verify failed on 2636556500992 wanted 2264 found 2268
Ignoring transid failure
extent buffer leak: start 2636556091392 len 16384
Btrfs v3.17

I've had a balance running that time, but "btrfs fi sh /any/btrfs/mount"
returned always quickly as in previous versions.

  Now, with the balance paused, the stalls continue to appear, but no
messages as above. During the stalls, btrfs is reading the disks at rate
several MB/s, probably seek limited. /proc/<btrfs fi sh pid>/fd shows
that it scans again the devices it has already written about.

  Umounted all the btrfs, checked them -- nothing wrong.

  Resumed the balance -- error messages are (sometimes) back:

[...]
Label: 'BTR3'  uuid: 0bf93650-fd12-4f82-8086-2c7484141e97
        Total devices 5 FS bytes used 1.63TiB
        devid    1 size 2.73TiB used 800.00GiB path /dev/sde
        devid    2 size 2.73TiB used 800.00GiB path /dev/sdf
        devid    3 size 2.73TiB used 800.03GiB path /dev/sdg
        devid    4 size 2.73TiB used 801.00GiB path /dev/sdh
        devid    5 size 3.64TiB used 143.03GiB path /dev/sdp

Check tree block failed, want=2730665181184, have=9727841172931608576
Check tree block failed, want=2730665181184, have=9727841172931608576
Check tree block failed, want=2730665181184, have=8388343671073157408
Check tree block failed, want=2730665181184, have=9727841172931608576
Check tree block failed, want=2730665181184, have=9727841172931608576
read block failed check_tree_block
Label: 'BTR1'  uuid: 2ec4b5a1-a2c4-4687-9015-cf5b519297f3
        Total devices 3 FS bytes used 2.47TiB
        devid    1 size 3.64TiB used 1.79TiB path /dev/sdm
        devid    2 size 3.64TiB used 1.79TiB path /dev/sdn
        devid    3 size 3.64TiB used 1.79TiB path /dev/sdo

Btrfs v3.17

  (or the "parent transid verify failed..." + "extent buffer leak..." as
in the first case as well)

  Kernel version 3.18-rc1


Regards,

Petr
