Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33637 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755341AbdBGQoY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 11:44:24 -0500
Received: by mail-lf0-f41.google.com with SMTP id x1so66418375lff.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 08:44:24 -0800 (PST)
MIME-Version: 1.0
From: Vasco Visser <vasco.visser@gmail.com>
Date: Tue, 7 Feb 2017 17:44:02 +0100
Message-ID: <CALg=eG_C-Xkw+TTHpNq9y_euza81TPTd+YN10_V=9WSprN0BPw@mail.gmail.com>
Subject: understanding disk space usage
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

My system is or seems to be running out of disk space but I can't find
out how or why. Might be a BTRFS peculiarity, hence posting on this
list. Most indicators seem to suggest I'm filling up, but I can't
trace the disk usage to files on the FS.

The issue is on my root filesystem on a 28GiB ssd partition (commands
below issued when booted into single user mode):


$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda3              28G   26G  2.1G  93% /


$ btrfs --version
btrfs-progs v4.4


$ btrfs fi usage /
Overall:
    Device size:  27.94GiB
    Device allocated:  27.94GiB
    Device unallocated:   1.00MiB
    Device missing:     0.00B
    Used:  25.03GiB
    Free (estimated):   2.37GiB (min: 2.37GiB)
    Data ratio:      1.00
    Metadata ratio:      1.00
    Global reserve: 256.00MiB (used: 0.00B)
Data,single: Size:26.69GiB, Used:24.32GiB
   /dev/sda3  26.69GiB
Metadata,single: Size:1.22GiB, Used:731.45MiB
   /dev/sda3   1.22GiB
System,single: Size:32.00MiB, Used:16.00KiB
   /dev/sda3  32.00MiB
Unallocated:
   /dev/sda3   1.00MiB


$ btrfs fi df /
Data, single: total=26.69GiB, used=24.32GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=1.22GiB, used=731.48MiB
GlobalReserve, single: total=256.00MiB, used=0.00B


However:
$ mount -o bind / /mnt
$ sudo du -hs /mnt
9.3G /mnt


Try to balance:
$ btrfs balance start /
ERROR: error during balancing '/': No space left on device


Am I really filling up? What can explain the huge discrepancy with the
output of du (no open file descriptors on deleted files can explain
this in single user mode) and the FS stats?

Any advice on possible causes and how to proceed?


--
Vasco
