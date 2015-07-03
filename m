Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:36610 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbbGCFcY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jul 2015 01:32:24 -0400
Received: by obdbs4 with SMTP id bs4so63369833obd.3
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2015 22:32:23 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 2 Jul 2015 22:32:23 -0700
Message-ID: <CAG+QAKX1eSmarBn+YXq5dkZ0zTWsSDM6cfwTtDg-43-nTRSXWQ@mail.gmail.com>
Subject: btrfs full, but not full, can't rebalance
From: Rich Rauenzahn <rrauenza@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Running on CentOS7 ... / got full, I removed the files, but it still
thinks it is full.  I've tried following the FAQ, even adding a
loopback device during the rebalance.

# btrfs fi show /
Label: 'centos7'  uuid: 35f0ce3f-0902-47a3-8ad8-86179d1f3e3a
        Total devices 2 FS bytes used 24.27GiB
        devid    1 size 111.11GiB used 111.05GiB path /dev/sdf3
        devid    2 size 111.11GiB used 111.05GiB path /dev/sdg3

# btrfs fi df /
Data, RAID1: total=107.02GiB, used=22.12GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=4.05GiB, used=2.15GiB
GlobalReserve, single: total=512.00MiB, used=0.00

# btrfs balance start -v -dusage=1 /
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=1
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail

# btrfs balance start -m /
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail

What can I do?
