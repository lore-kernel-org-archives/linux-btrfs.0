Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:38727 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752413AbeCWLEu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 07:04:50 -0400
Received: by mail-ot0-f182.google.com with SMTP id 95-v6so12797955ote.5
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 04:04:50 -0700 (PDT)
MIME-Version: 1.0
From: james harvey <jamespharvey20@gmail.com>
Date: Fri, 23 Mar 2018 07:04:49 -0400
Message-ID: <CA+X5Wn5E_Ybvka7MfLZkZs7gT44buB0K9n=6UPVZVX2M5YuEdw@mail.gmail.com>
Subject: Hard reset during balance - How to continue?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a system unexpectedly reboots during a balance, what's the best next step?

>From an ISO, read-only operations/mounting looks fine.

Didn't want to make any writes until I ask, because I see some reports
of bad things happening with a reboot during a balance, and don't want
to mis-step.

btrfs check reports no errors.  mount -o ro,skip_balance works fine
and directory entries seem correct.

$ sudo btrfs balance status -v /mnt/tmp
Balance on '/mnt/tmp' is paused
0 out of about 0 chunks balanced (0 considered), -nan% left
Dumping filters: flags 0x17, state 0x0, force is off
  DATA (flags 0x0): balancing
  METADATA (flags 0x0): balancing
  SYSTEM (flags 0x0): balancing

This surprised me.  Not sure if it's expected for an interrupted or
paused balance to show 0/0/0/nan.

Do I re-mount without "ro,skip_balance" and see if it finishes the
balance?  (If it doesn't, cancel and restart it?)

Do I re-mount without "ro" but still with "skip_balance", and cancel
the balance and restart it?  (Never trying to continue the interrupted
balance?)

Something else that I'm not aware of?

... System didn't reboot on its own, it became completely unresponsive
for over 24 hours, and I had to perform a hard reset.  Active ssh
sessions permanently hung, and local logins didn't get past asking for
password.  Hoped I could get a btrfs balance cancel to run.



$ uname -a
Linux terra 4.15.8-1-ARCH #1 SMP PREEMPT Sat Mar 10 00:00:33 UTC 2018
x86_64 GNU/Linux

$ btrfs --version
btrfs-progs v4.15.1

$ sudo btrfs fi show /mnt/tmp
Label: 'losable'  uuid: 9208dacc-8bb3-4303-9f71-124f0cecc7e7
        Total devices 4 FS bytes used 6.92TiB
        devid    1 size 2.50TiB used 1.78TiB path /dev/mapper/lvm-losable1
        devid    2 size 2.50TiB used 1.78TiB path /dev/mapper/lvm-losable2
        devid    3 size 2.50TiB used 1.78TiB path /dev/mapper/lvm-losable3
        devid    4 size 2.50TiB used 1.60TiB path /dev/mapper/lvm-losable4

$ sudo btrfs fi df /mnt/tmp
Data, RAID0: total=6.92TiB, used=6.91TiB
System, RAID1: total=8.00MiB, used=400.00KiB
Metadata, RAID1: total=7.00GiB, used=5.77GiB
GlobalReserve, single: total=368.09MiB, used=0.00B
