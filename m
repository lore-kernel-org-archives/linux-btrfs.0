Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:58962 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaDUGc5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 02:32:57 -0400
Received: by mail-ob0-f178.google.com with SMTP id wn1so3866617obc.23
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Apr 2014 23:32:57 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 21 Apr 2014 08:32:56 +0200
Message-ID: <CAG6W84JS1-rzAJfGyPmXMTPLqLN=0UbqefRa-BoqgyzFruhJ_g@mail.gmail.com>
Subject: convert from RAID5: enospc errors during balance (500 GB free on each device)
From: Arjen Nienhuis <a.g.nienhuis@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I experimented with RAID5, but now I want to get rid of it:

$ sudo btrfs balance start -dconvert=raid1,soft -v /
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x300): converting, target=16, soft is on
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail

This is in dmesg:

[  166.799139] btrfs: relocating block group 13368320589824 flags 129
[  248.927524] btrfs: relocating block group 13338255818752 flags 129
...
[  409.184588] btrfs: relocating block group 11607454253056 flags 129
[  410.528075] btrfs: relocating block group 11605306769408 flags 129
[  411.957809] btrfs: 62 enospc errors during balance

Extra info:
Data, RAID1: total=3.26TiB, used=3.25TiB
Data, RAID5: total=124.00GiB, used=123.90GiB
System, RAID1: total=32.00MiB, used=508.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID1: total=9.00GiB, used=7.97GiB
Label: data  uuid: 93be47ab-af7a-4329-8a6c-c6ff220060b0
        Total devices 3 FS bytes used 3.38TiB
        devid    1 size 1.82TiB used 1.22TiB path /dev/sdd
        devid    2 size 3.64TiB used 2.63TiB path /dev/sdb
        devid    6 size 3.64TiB used 2.87TiB path /dev/sdc

Btrfs v3.12

Linux maxi 3.13.0-24-generic #46-Ubuntu SMP Thu Apr 10 19:11:08 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux

I tried scrub (no errors) and I cleared the free space cache. Nothing worked.

Now I'm doing full balance (without 'soft') but that will take days.
