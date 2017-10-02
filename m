Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:42282 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdJBKCa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Oct 2017 06:02:30 -0400
Received: from localhost (unknown [192.168.1.197])
        by mail.linuxsystems.it (Postfix) with ESMTPSA id 34F97B41F6
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Oct 2017 12:02:28 +0200 (CEST)
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Subject: Why do full balance and deduplication reduce available free =?iso-8859-1?Q?space=3F?=
Date: Mon, 02 Oct 2017 12:02:16 +0200
MIME-Version: 1.0
Message-ID: <49ec6395-19b4-46e0-83cf-806ef6cdd396@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I have several subvolumes mounted with compress-force=lzo and autodefrag. 
Since I use lots of snapshots (snapper keeps around 24 hourly snapshots, 7 
daily snapshots and 4 weekly snapshots) I had to create a systemd timer to 
perform a full balance and deduplication each night. In fact data needs to 
be already deduplicated when snapshots are created, otherwise I have no 
other way to deduplicate snapshots.

This is how I performe balance: btrfs balance start --full-balance rootfs
This is how I perform deduplication (duperemove is from git master):
duperemove -drh --dedupe-options=noblock --hashfile=../rootfs.hash 
<all_subvols_except_snapshots_ones>

Looking at the logs I noticed something weird: available free space 
actually decreases after balance or deduplication.

This is just before the timer starts:

Overall:
    Device size:                 128.00GiB
    Device allocated:             49.03GiB
    Device unallocated:           78.97GiB
    Device missing:                  0.00B
    Used:                         43.78GiB
    Free (estimated):             82.97GiB      (min: 82.97GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:44.00GiB, Used:40.00GiB
   /dev/sda5      44.00GiB

Metadata,single: Size:5.00GiB, Used:3.78GiB
   /dev/sda5       5.00GiB

System,single: Size:32.00MiB, Used:16.00KiB
   /dev/sda5      32.00MiB

Unallocated:
   /dev/sda5      78.97GiB



I also manually performed a full balance just before the timer starts:

Overall:
    Device size:                 128.00GiB
    Device allocated:             46.03GiB
    Device unallocated:           81.97GiB
    Device missing:                  0.00B
    Used:                         43.78GiB
    Free (estimated):             82.96GiB      (min: 82.96GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:41.00GiB, Used:40.01GiB
   /dev/sda5      41.00GiB

Metadata,single: Size:5.00GiB, Used:3.77GiB
   /dev/sda5       5.00GiB

System,single: Size:32.00MiB, Used:16.00KiB
   /dev/sda5      32.00MiB

Unallocated:
   /dev/sda5      81.97GiB



As you can see even doing a full balance was enough to reduce the available 
free space!

Then the timer started and it performed the deduplication:

Overall:
    Device size:                 128.00GiB
    Device allocated:             46.03GiB
    Device unallocated:           81.97GiB
    Device missing:                  0.00B
    Used:                         43.87GiB
    Free (estimated):             82.94GiB      (min: 82.94GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 176.00KiB)

Data,single: Size:41.00GiB, Used:40.03GiB
   /dev/sda5      41.00GiB

Metadata,single: Size:5.00GiB, Used:3.84GiB
   /dev/sda5       5.00GiB

System,single: Size:32.00MiB, Used:16.00KiB
   /dev/sda5      32.00MiB

Unallocated:
   /dev/sda5      81.97GiB



Once again it reduced the available free space!

Then, after the deduplication, the timer also performed a full balance:

Overall:
    Device size:                 128.00GiB
    Device allocated:             46.03GiB
    Device unallocated:           81.97GiB
    Device missing:                  0.00B
    Used:                         44.00GiB
    Free (estimated):             82.93GiB      (min: 82.93GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:41.00GiB, Used:40.04GiB
   /dev/sda5      41.00GiB

Metadata,single: Size:5.00GiB, Used:3.97GiB
   /dev/sda5       5.00GiB

System,single: Size:32.00MiB, Used:16.00KiB
   /dev/sda5      32.00MiB

Unallocated:
   /dev/sda5      81.97GiB




It further reduced the available free space! Balance and deduplication 
actually reduced my available free space of 400MB!
400MB each night!
How is it possible? Should I avoid doing balances and deduplications at 
all?

Thanks,
Niccolò
