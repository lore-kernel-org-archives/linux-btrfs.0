Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:57041 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaEZM2w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 08:28:52 -0400
Received: by mail-yh0-f49.google.com with SMTP id c41so6297079yho.8
        for <linux-btrfs@vger.kernel.org>; Mon, 26 May 2014 05:28:52 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 26 May 2014 14:28:51 +0200
Message-ID: <CA+3u+RcGa2Xr+mzwGL-V89A7DEa05B_NS+cgS-Es1b3d8b5xKg@mail.gmail.com>
Subject: Btrfs filesystem freezing during snapshots
From: David Bloquel <david.bloquel@jimywoo.fr>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a problem with my btrfs filesystem which is freezing when I am
doing snapshots.

I have a cron that is snapshoting around 70 sub volume every ten
minutes. The sub volumes that btrfs is snapshoting are containers
folders that are running through my virtual environment.
Sub directories that btrfs is snapshoting are not that big (from 500MB
to 10GB max and usually around 3GB) but there is a lot of IO on the
filesystem because of the intensive use of the CTs and VMs.

At some point the snapshot process becomes really slow, at first it
snapshot around one folder per seconds but then after a while it can
take 30seconds or even few minutes to snapshot one single sub volumes.
Subvolumes are really similar to each other in size and number of
files so there is no reason that it takes 1second for one sub volume
and then 3minutes for another one.

Moreover when my snapshot cron is running all my vms and containers
are slowing down until the whole filesystem freezes which leads to
frozen CT and VMs (which is a real problem for me).

Moreover I can see that my CPU load is really high during the process.

when I'm am looking to dmesg there is a lot of messages of this kind:

[96537.686467] BTRFS debug (device drbd0): unlinked 290 orphans
[96540.819101] BTRFS debug (device drbd0): unlinked 2317 orphans
[96544.852499] BTRFS debug (device drbd0): unlinked 25 orphans
[96547.494132] BTRFS debug (device drbd0): unlinked 20 orphans
[96770.954615] BTRFS debug (device drbd0): unlinked 95 orphans
[96814.027538] BTRFS debug (device drbd0): unlinked 3331 orphans
[96841.240481] BTRFS debug (device drbd0): unlinked 24 orphans
[96851.094867] BTRFS debug (device drbd0): unlinked 6 orphans
[96862.285772] BTRFS debug (device drbd0): unlinked 2105 orphans
[96869.611062] BTRFS debug (device drbd0): unlinked 9 orphans
[96875.920977] BTRFS debug (device drbd0): unlinked 2 orphans
[96892.333661] BTRFS debug (device drbd0): unlinked 1640 orphans
[96902.928344] BTRFS debug (device drbd0): unlinked 482 orphans
[96907.615605] BTRFS debug (device drbd0): unlinked 83 orphans
[96914.216044] BTRFS debug (device drbd0): unlinked 39 orphans
[96921.936762] BTRFS debug (device drbd0): unlinked 50 orphans
[96927.035003] BTRFS debug (device drbd0): unlinked 12 orphans
[96932.864481] BTRFS debug (device drbd0): unlinked 5 orphans
[96937.511487] BTRFS debug (device drbd0): unlinked 31 orphans
[96946.521916] BTRFS debug (device drbd0): unlinked 5 orphans
[96948.591532] BTRFS debug (device drbd0): unlinked 4 orphans


I am not copying the whole dmesg because there is hundreds of orphans warning.

In addition of orphans warning there is also this kind of messages in
the log files:

[69537.117372] INFO: task btrfs-transacti:14507 blocked for more than
120 seconds.
[69537.117439]       Not tainted 3.12-0.bpo.1-amd64 #1
[69537.117475] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[69537.117535] btrfs-transacti D ffff88047fdd4300     0 14507      2 0x00000000
[69537.117546]  ffff88046bc740c0 0000000000000046 0000000000000296
ffff88046f0dc840
[69537.117557]  ffff880075987fd8 ffff880075987fd8 ffff880075987fd8
ffff88046bc740c0
[69537.117565]  0000000000000246 ffff880351942ea8 ffff880351942f30
0000000000000000
[69537.117574] Call Trace:
[69537.117613]  [<ffffffffa04b4dc5>] ? wait_for_commit.isra.25+0x55/0x90 [btrfs]
[69537.117624]  [<ffffffff81082d20>] ? add_wait_queue+0x60/0x60
[69537.117650]  [<ffffffffa04b69bb>] ?
btrfs_commit_transaction+0x10b/0x9f0 [btrfs]
[69537.117675]  [<ffffffffa04b0385>] ? transaction_kthread+0x1b5/0x220 [btrfs]
[69537.117699]  [<ffffffffa04b01d0>] ?
btree_readpage_end_io_hook+0x2d0/0x2d0 [btrfs]
[69537.117707]  [<ffffffff81082333>] ? kthread+0xb3/0xc0
[69537.117715]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
[69537.117724]  [<ffffffff814cb70c>] ? ret_from_fork+0x7c/0xb0
[69537.117732]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
[69657.215298] INFO: task btrfs-transacti:14507 blocked for more than
120 seconds.
[69657.215360]       Not tainted 3.12-0.bpo.1-amd64 #1
[69657.215393] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[69657.215450] btrfs-transacti D ffff88047fdd4300     0 14507      2 0x00000000
[69657.215455]  ffff88046bc740c0 0000000000000046 0000000000000296
ffff88046f0dc840
[69657.215461]  ffff880075987fd8 ffff880075987fd8 ffff880075987fd8
ffff88046bc740c0
[69657.215465]  0000000000000246 ffff880351942ea8 ffff880351942f30
0000000000000000
[69657.215469] Call Trace:
[69657.215490]  [<ffffffffa04b4dc5>] ? wait_for_commit.isra.25+0x55/0x90 [btrfs]
[69657.215496]  [<ffffffff81082d20>] ? add_wait_queue+0x60/0x60
[69657.215508]  [<ffffffffa04b69bb>] ?
btrfs_commit_transaction+0x10b/0x9f0 [btrfs]
[69657.215520]  [<ffffffffa04b0385>] ? transaction_kthread+0x1b5/0x220 [btrfs]
[69657.215531]  [<ffffffffa04b01d0>] ?
btree_readpage_end_io_hook+0x2d0/0x2d0 [btrfs]
[69657.215535]  [<ffffffff81082333>] ? kthread+0xb3/0xc0
[69657.215539]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
[69657.215543]  [<ffffffff814cb70c>] ? ret_from_fork+0x7c/0xb0
[69657.215547]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0


I think the message: "[69537.117372] INFO: task btrfs-transacti:14507
blocked for more than 120 seconds." appears when the filesystem is
frozen.


A solution would be to wait few seconds between each snapshot to avoid
high load however I think it's just a way to avoid the problem and I
would rather fix it because I am affraid it could appear during
another operation (copy of a lot of small files etc...).

I have checked a lot of old messages from this mailling list and I got
some clues but no real/working solution in my case.

I hope some of you could give me some advises

If you need any further information please do not hesitate.

(Sorry for my English, I tried to make it as good as I can)

Best regards,
David
