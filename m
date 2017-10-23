Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:57256 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750743AbdJWE0G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 00:26:06 -0400
Received: from mail-yw0-f176.google.com ([209.85.161.176]) by
 mrelay.perfora.net (mreueus001 [74.208.5.2]) with ESMTPSA (Nemesis) id
 0Lsj8x-1d4RTI3QyH-0129Sm for <linux-btrfs@vger.kernel.org>; Mon, 23 Oct 2017
 06:26:05 +0200
Received: by mail-yw0-f176.google.com with SMTP id q126so8059477ywq.10
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Oct 2017 21:26:05 -0700 (PDT)
MIME-Version: 1.0
From: Zak Kohler <y2k@y2kbugger.com>
Date: Mon, 23 Oct 2017 00:25:34 -0400
Message-ID: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
Subject: btrfs send yields "ERROR: send ioctl failed with -5: Input/output error"
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Was attempting my first btrfs send receive over ssh and continually
received ioctl error at different points but always in the first 3
minutes. The volume consists of three devices with only metadata
duplication. I narrowed down the error to the send command by
recreating the error while redirecting to /dev/null. Sometime it would
happen after ~12Gib, or ~7.6Gib, right now rerunning multiple times it
has stopped on exactly 3.76 multiple times.

$ sudo btrfs send /mnt/dataroot.2017.10.21/ | pv -i5 > /dev/null
At subvol /mnt/dataroot.2017.10.21/
ERROR: send ioctl failed with -5: Input/output error                    ]
3.76GiB 0:00:13 [ 290MiB/s] [      <=>                                  ]


First I checked the btrfs device stats, each of the 3 drives appear clean:
$ sudo btrfs device stats /mnt
[/dev/sdi].write_io_errs    0
[/dev/sdi].read_io_errs     0
[/dev/sdi].flush_io_errs    0
[/dev/sdi].corruption_errs  0
[/dev/sdi].generation_errs  0
[/dev/sdh].write_io_errs    0
[/dev/sdh].read_io_errs     0
[/dev/sdh].flush_io_errs    0
[/dev/sdh].corruption_errs  0
[/dev/sdh].generation_errs  0
[/dev/sdn].write_io_errs    0
[/dev/sdn].read_io_errs     0
[/dev/sdn].flush_io_errs    0
[/dev/sdn].corruption_errs  0
[/dev/sdn].generation_errs  0

The next thing I tried was running and checking that SMART short
selftest passed on each of three drives with no error.
$ sudo smartctl -l selftest /dev/sdh
# 1  Short offline       Completed without error


I read somewhere to check dmesg, which yielded some info:
BTRFS warning (device sdn): csum failed ino 6407 off 7683907584 csum
1745651892 expected csum 3952841867

But when I when to see if scrub could detect the errors, nothing was found:
$ sudo btrfs scrub status -d /mnt
scrub status for 88406942-e3e1-42c6-ad71-e23bb315caa7
scrub device /dev/sdi (id 1) history
        scrub started at Sun Oct 22 14:43:20 2017 and finished after 01:57:00
        total bytes scrubbed: 677.69GiB with 0 errors
scrub device /dev/sdh (id 2) history
        scrub started at Sun Oct 22 14:43:20 2017 and finished after 01:56:38
        total bytes scrubbed: 677.44GiB with 0 errors
scrub device /dev/sdn (id 3) history
        scrub started at Sun Oct 22 14:43:20 2017 and finished after 01:56:38
        total bytes scrubbed: 677.36GiB with 0 errors


After all that scrubbing I still receive the ioctl error.


Does anyone have any ideas of what to try next? Right now I am running
the SMART 'long' self test.
