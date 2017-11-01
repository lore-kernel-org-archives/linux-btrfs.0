Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:50566 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdKAKWl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 06:22:41 -0400
Received: by mail-yw0-f177.google.com with SMTP id i198so1419906ywe.7
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 03:22:41 -0700 (PDT)
MIME-Version: 1.0
From: Lars Noschinski <noschinl@gmail.com>
Date: Wed, 1 Nov 2017 11:22:40 +0100
Message-ID: <CAM4geavt2usykGhGdUznBY_gY9tLWerEjDZWWYzqZJF825Se1Q@mail.gmail.com>
Subject: Machine died with OOM after (re)moving lots of data and snapshot
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I have a machine which had an almost full 4TB btrfs partition on a
SATA harddisk. I added another 4TB harddisk, put a btrfs partition on
it and moved 1TB of data to the new partition.

After that, I moved another part of the data (probably around 500GB)
to the new partition and deleted all the snapshots taken during the
last year -- probably around 300.

The machine was slow during this (which did not surprise me due to
heavy disk I/O). I left the machine working for the rest of the day
and found it totally dead the next morning (no ping, not even the VGA
console coming up after pressing a key).


After a restart, I found the following messages in the kernel log. For
a few minutes, there where a few messages like:

Oct 31 15:48:44 wuerfelzucker kernel: [107426.623818] INFO: task
rm:4456 blocked for more than 120 seconds.
Oct 31 15:48:44 wuerfelzucker kernel: [107426.623952]       Not
tainted 4.9.0-4-amd64 #1 Debian 4.9.51-1
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624058] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624200] rm
D    0  4456   4453 0x00000000
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624209]
ffff94060f2ee800 0000000000000000 ffff94060e8ed080 ffff94061fc98240
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624216]
ffff9406102d3140 ffffb807818bfd90 ffffffff82c038e3 000000020b0f4000
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624222]
00ffffffc03c17ee ffff94061fc98240 ffff940611e36288 ffff94060e8ed080
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624228] Call Trace:
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624242]
[<ffffffff82c038e3>] ? __schedule+0x233/0x6d0
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624248]
[<ffffffff82c03db2>] ? schedule+0x32/0x80
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624315]
[<ffffffffc03d40f1>] ? wait_current_trans.isra.20+0xc1/0x110 [btrfs]
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624323]
[<ffffffff826b8e80>] ? prepare_to_wait_event+0xf0/0xf0
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624374]
[<ffffffffc03d675b>] ? start_transaction+0x25b/0x480 [btrfs]
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624425]
[<ffffffffc03e2f2f>] ? btrfs_evict_inode+0x45f/0x5d0 [btrfs]
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624432]
[<ffffffff8281f806>] ? evict+0xb6/0x180
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624439]
[<ffffffff82813778>] ? do_unlinkat+0x148/0x330
Oct 31 15:48:44 wuerfelzucker kernel: [107426.624447]
[<ffffffff82c085bb>] ? system_call_fast_compare_end+0xc/0x9b

9h later, the OOM killer kicked in and kept killing processes for
another 30 minutes, before the logs end. The full log file is found at

https://bugzilla.kernel.org/attachment.cgi?id=260455

The last few invocations of the OOM killer where by a process kalled
"btrfs-transacti".

As far as I can tell from the logs, moving the data was finished by
then (at least, I don't see an instance of "mv" in the process list
from the OOM killer). Otherwise, the machine was idle.

If you need any more data for investigating this problem, I might be
able to provide that; I haven't touched the affected disks yet.

The machine is a HP Microserver N54L with 10GB of ECC ram running a
current Debian stretch:
* kernel: Linux version 4.9.0-4-amd64 (debian-kernel@lists.debian.org)
(gcc version 6.3.0 20170516 (Debian 6.3.0-18) ) #1 SMP Debian 4.9.51-1
(2017-09-28)
* btrfs-tools: 4.7.3-1

I also reported this as #197627 in the kernel bugzilla.

Best regards, Lars Noschinski
