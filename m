Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35222 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbbHaSOW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 14:14:22 -0400
Received: by qgz60 with SMTP id 60so13061486qgz.2
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 11:14:22 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 31 Aug 2015 21:14:21 +0300
Message-ID: <CAOE4rSwiQxR16fSNtnaX5D5MaTcG3q+v__=qP4-m3So3fu_ksQ@mail.gmail.com>
Subject: [BUG] kernel BUG at fs/btrfs/extent_io.c:2062 (v4.2.0-rc8)
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm getting kernel crash and complete system lockup when trying to access
journal on two disk btrfs filesystem with data/metadata as RAID1.

I can't get proper log because whole system hangs and even kdump fails,
seems it doesn't start or I'm doing something wrong.

Also because there are several call traces and they all get printed on
screen within few seconds I can get photos only on few last ones.
But I managed to get some low-quality blurry photos with 80 FPS
recording.

So from them I saw

kernel BUG at fs/btrfs/extent_io.c:2062
extent_io.c@2062.png => http://i.imgur.com/uuxOGIR.png

kernel BUG at fs/btrfs/extent_io.c:2140
extent_io.c@2140.png => http://i.imgur.com/j5xrt7w.png

kernel BUG at fs/btrfs/extent_io.c:2338
extent_io.c@2338_0.png => http://i.imgur.com/EosplAu.png
extent_io.c@2338_1.png => http://i.imgur.com/rsE9qNT.png

kernel BUG at fs/btrfs/volumes.c:5399
volumes.c@5399_0.png => http://i.imgur.com/iV9zqAv.png
volumes.c@5399_1.png => http://i.imgur.com/VCyr07R.png


And better photos

BUG: scheduling while atomic: kworker/u16
scheduling_while_atomic_0.jpg => http://i.imgur.com/asHjcM9.jpg
scheduling_while_atomic_1.jpg => http://i.imgur.com/OJSFDUx.jpg
scheduling_while_atomic_2.jpg => http://i.imgur.com/0nHQin8.jpg
scheduling_while_atomic_3.jpg => http://i.imgur.com/ZmzOh7f.jpg

Watchdog detected hard LOCKUP on cpu
watchdog_detected_hard_LOCKUP_0.jpg => http://i.imgur.com/6W4FlfI.jpg
watchdog_detected_hard_LOCKUP_1.jpg => http://i.imgur.com/WxxGozJ.jpg
watchdog_detected_hard_LOCKUP_2.jpg => http://i.imgur.com/0Mmifwf.jpg

BUG: unable to handle kernel paging request
unable_to_handle_kernel_paging_request.jpg => http://i.imgur.com/4Sz4v96.jpg

BUG: unable to handle kernel
unable_to_handle_kernel.jpg => http://i.imgur.com/T0x7K4a.jpg


Weird is that it crashes only sometimes and when reading all files then
it doesn't crash, but only when try to open journal with journalctl.
Also btrfs scrub and balance finishes without any errors.
Even btrfs check and check --repair completed successfully without
finding anything to repair. Also this crash happened on v4.1.6 too and
now I'll recompile v4.2 as it got released.


I'm getting this crash since I decided to test how well Linux handles
one disk loss on btrfs RAID1 (I just pulled one disk out), it kept
working but there were some call traces and when I plugged it back
in then btrfs failed to write to it and after few mins system froze but
before that SMART test passed on that disk.
Then I rebooted and ran scrub which fixed errors on that disk.
Next I was trying to test other disk and for it executed
echo 1 > /sys/block/sdf/device/delete
which caused immediate system hang.
And now this filesystem crashes kernel when I try to view journal.
I think RAID1 should handle well such cases when one disk
disappears or is corrupted but currently it doesn't work and
crashes whole system.

PS. this is a resend without attachments.
