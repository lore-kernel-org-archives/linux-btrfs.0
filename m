Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:41337 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbeHEROD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Aug 2018 13:14:03 -0400
Received: by mail-oi0-f47.google.com with SMTP id k12-v6so17886725oiw.8
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Aug 2018 08:09:09 -0700 (PDT)
MIME-Version: 1.0
From: Zoltan <zoltan1980@gmail.com>
Date: Sun, 5 Aug 2018 17:08:28 +0200
Message-ID: <CAA-GF5uG3tyJCM_EBSW4FywT9zL44iWP8jSL9Q6TQNouFE5Y9g@mail.gmail.com>
Subject: Hanging btrfs-transaction
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Btrfs Experts,

I would like to ask for advice regarding the following problem:

I regularly do incremental backups of snapshots using commands like:

btrfs send -p /volumes/root/snapshots/2018-08-02
/volumes/root/snapshots/2018-08-03 | btrfs receive
/volumes/sj-backup/root

Recently the command started hanging with the following message
showing up in dmesg:

[136055.426170] INFO: task btrfs-transacti:13368 blocked for more than
120 seconds.
[136055.426181]       Tainted: P           OE    4.15.0-29-generic #31-Ubuntu
[136055.426186] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[136055.426192] btrfs-transacti D    0 13368      2 0x80000000
[136055.426199] Call Trace:
[136055.426215]  __schedule+0x291/0x8a0
[136055.426224]  schedule+0x2c/0x80
[136055.426283]  btrfs_commit_transaction+0x81d/0x8f0 [btrfs]
[136055.426291]  ? wait_woken+0x80/0x80
[136055.426342]  transaction_kthread+0x18d/0x1b0 [btrfs]
[136055.426351]  kthread+0x121/0x140
[136055.426395]  ? btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[136055.426402]  ? kthread_create_worker_on_cpu+0x70/0x70
[136055.426409]  ret_from_fork+0x35/0x40

This message is repeated 6 times. The first time this happened, I
waited a few hours for the command to finish (usually it only takes a
few minutes), but finally I gave up waiting and rebooted. When I ran
the command again, I got the same result.

I have another backup disk stored in a different location and from
time to time I swap them. I swapped them just to test whether the
problem is on the sending or the receiving side and with the other
disk everything works fine. I swapped them back and the problem
returned.

I have tried scrubbing the disk, it did not find any errors.
Interestingly, when I removed a few older snapshots from the target
disk, the command started working again, but a few days later, it
started hanging again. While it was working, I removed some more older
snapshots, which may or may not have been the trigger behind the
problem resurfacing.

I'm using Ubuntu 18.04, kernel 4.15.0-29-generic.

Thanks,

Zoltan
