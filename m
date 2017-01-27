Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:34558 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751144AbdA0TOn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Jan 2017 14:14:43 -0500
Received: by mail-ua0-f172.google.com with SMTP id 35so212062430uak.1
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jan 2017 11:14:38 -0800 (PST)
MIME-Version: 1.0
From: MegaBrutal <megabrutal@gmail.com>
Date: Fri, 27 Jan 2017 19:45:00 +0100
Message-ID: <CAE8gLhk=Gf7Qejs6zit+hGdFNeNSPexJZ=jgCY1CADt6xoNHhA@mail.gmail.com>
Subject: File system is oddly full after kernel upgrade, balance doesn't help
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Not sure if it caused by the upgrade, but I only encountered this
problem after I upgraded to Ubuntu Yakkety, which comes with a 4.8
kernel.
Linux vmhost 4.8.0-34-generic #36-Ubuntu SMP Wed Dec 21 17:24:18 UTC
2016 x86_64 x86_64 x86_64 GNU/Linux

This is the 2nd file system which showed these symptoms, so I thought
it's more than happenstance. I don't remember what I did with the
first one, but I somehow managed to fix it with balance, if I remember
correctly, but it doesn't help with this one.

FS state before any attempts to fix:
Filesystem                             1M-blocks   Used Available Use%
Mounted on
/dev/mapper/vmdata--vg-lxc--curlybrace      1024   1024         0 100%
/tmp/mnt/curlybrace

Resized LV, run „btrfs filesystem resize max /tmp/mnt/curlybrace”:
/dev/mapper/vmdata--vg-lxc--curlybrace      2048   1303         0 100%
/tmp/mnt/curlybrace

Notice how the usage magically jumped up to 1303 MB, and despite the
FS size is 2048 MB, the usage is still displayed as 100%.

Tried full balance (other options with -dusage had no result):
root@vmhost:~# btrfs balance start -v /tmp/mnt/curlybrace
Dumping filters: flags 0x7, state 0x0, force is off
  DATA (flags 0x0): balancing
  METADATA (flags 0x0): balancing
  SYSTEM (flags 0x0): balancing
WARNING:

    Full balance without filters requested. This operation is very
    intense and takes potentially very long. It is recommended to
    use the balance filters to narrow down the balanced data.
    Use 'btrfs balance start --full-balance' option to skip this
    warning. The operation will start in 10 seconds.
    Use Ctrl-C to stop it.
10 9 8 7 6 5 4 3 2 1
Starting balance without any filters.
ERROR: error during balancing '/tmp/mnt/curlybrace': No space left on device
There may be more info in syslog - try dmesg | tail

No space left on device? How?

But it changed the situation:
/dev/mapper/vmdata--vg-lxc--curlybrace      2048   1302       190  88%
/tmp/mnt/curlybrace

This is still not acceptable. I need to recover at least 50% free
space (since I increased the FS to the double).

A 2nd balance attempt resulted in this:
/dev/mapper/vmdata--vg-lxc--curlybrace      2048   1302       162  89%
/tmp/mnt/curlybrace

So... it became slightly worse.

What's going on? How can I fix the file system to show real data?


Regards,
MegaBrutal
