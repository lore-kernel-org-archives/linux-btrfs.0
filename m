Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63259 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaHIVCN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Aug 2014 17:02:13 -0400
Received: by mail-pd0-f180.google.com with SMTP id v10so6986939pde.39
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Aug 2014 14:02:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev>
	<20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
	<pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
	<CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com>
Date: Sat, 9 Aug 2014 16:02:13 -0500
Message-ID: <CAETJ_S9HsWEYrV2zrfr8ZSD69SoFCiHnND38HLo8pq7ENiEPbw@mail.gmail.com>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
From: Jose Ildefonso Camargo Tolosa <ildefonso.camargo@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

3.14.16 test is on its way, it already started with this:

[19732.769100] BTRFS: device fsid 7356e329-62ba-49fb-83cc-f6b91ac3b581
devid 1 transid 111580 /dev/sdb1
[19732.769429] BTRFS info (device sdb1): enabling auto recovery
[19732.769433] BTRFS info (device sdb1): force clearing of disk cache
[20050.137779] INFO: task btrfs-transacti:7353 blocked for more than
120 seconds.
[20050.139361]       Not tainted 3.14.16-031416-generic #201408072035
[20050.140704] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[20050.142422] btrfs-transacti D ffffffff818118e0     0  7353      2 0x00000000
[20050.142430]  ffff880450afddc8 0000000000000002 ffff880450afdd68
ffff880450afdfd8
[20050.142434]  0000000000014500 0000000000014500 ffff88046985e380
ffff8804602018e0
[20050.142437]  ffff880450afddd8 ffff8808642fc000 ffff8802aa5b8800
ffff880450afde00
[20050.142440] Call Trace:
[20050.142447]  [<ffffffff8175b0c9>] schedule+0x29/0x70
[20050.142473]  [<ffffffffa01040ed>]
btrfs_commit_transaction+0x25d/0xa00 [btrfs]
[20050.142482]  [<ffffffff810b4e10>] ? __wake_up_sync+0x20/0x20
[20050.142493]  [<ffffffffa0101e45>] transaction_kthread+0x1d5/0x250 [btrfs]
[20050.142504]  [<ffffffffa0101c70>] ? open_ctree+0x20d0/0x20d0 [btrfs]
[20050.142507]  [<ffffffff8108fd89>] kthread+0xc9/0xe0
[20050.142509]  [<ffffffff8108fcc0>] ? flush_kthread_worker+0xb0/0xb0
[20050.142513]  [<ffffffff817681bc>] ret_from_fork+0x7c/0xb0
[20050.142515]  [<ffffffff8108fcc0>] ? flush_kthread_worker+0xb0/0xb0
[20170.194168] INFO: task btrfs-transacti:7353 blocked for more than
120 seconds.
[20170.195747]       Not tainted 3.14.16-031416-generic #201408072035
[20170.197090] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[20170.198815] btrfs-transacti D ffffffff818118e0     0  7353      2 0x00000000
[20170.198820]  ffff880450afddc8 0000000000000002 ffff880450afdd68
ffff880450afdfd8
[20170.198822]  0000000000014500 0000000000014500 ffff88046985e380
ffff8804602018e0
[20170.198824]  ffff880450afddd8 ffff8808642fc000 ffff8802aa5b8800
ffff880450afde00
[20170.198824] Call Trace:
[20170.198831]  [<ffffffff8175b0c9>] schedule+0x29/0x70
[20170.198856]  [<ffffffffa01040ed>]
btrfs_commit_transaction+0x25d/0xa00 [btrfs]
[20170.198861]  [<ffffffff810b4e10>] ? __wake_up_sync+0x20/0x20
[20170.198875]  [<ffffffffa0101e45>] transaction_kthread+0x1d5/0x250 [btrfs]
[20170.198886]  [<ffffffffa0101c70>] ? open_ctree+0x20d0/0x20d0 [btrfs]
[20170.198889]  [<ffffffff8108fd89>] kthread+0xc9/0xe0
[20170.198891]  [<ffffffff8108fcc0>] ? flush_kthread_worker+0xb0/0xb0
[20170.198895]  [<ffffffff817681bc>] ret_from_fork+0x7c/0xb0
[20170.198897]  [<ffffffff8108fcc0>] ? flush_kthread_worker+0xb0/0xb0
[20290.250561] INFO: task btrfs-transacti:7353 blocked for more than
120 seconds.
[20290.252140]       Not tainted 3.14.16-031416-generic #201408072035
[20290.253483] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[20290.282212] btrfs-transacti D ffffffff818118e0     0  7353      2 0x00000000
[20290.282216]  ffff880450afddc8 0000000000000002 ffff880450afdd68
ffff880450afdfd8
[20290.282219]  0000000000014500 0000000000014500 ffff88046985e380
ffff8804602018e0
[20290.282221]  ffff880450afddd8 ffff8808642fc000 ffff8802aa5b8800
ffff880450afde00
[20290.282221] Call Trace:
[20290.282227]  [<ffffffff8175b0c9>] schedule+0x29/0x70
[20290.282253]  [<ffffffffa01040ed>]
btrfs_commit_transaction+0x25d/0xa00 [btrfs]
[20290.282262]  [<ffffffff810b4e10>] ? __wake_up_sync+0x20/0x20
[20290.282272]  [<ffffffffa0101e45>] transaction_kthread+0x1d5/0x250 [btrfs]
[20290.282283]  [<ffffffffa0101c70>] ? open_ctree+0x20d0/0x20d0 [btrfs]
[20290.282286]  [<ffffffff8108fd89>] kthread+0xc9/0xe0
[20290.282289]  [<ffffffff8108fcc0>] ? flush_kthread_worker+0xb0/0xb0
[20290.282292]  [<ffffffff817681bc>] ret_from_fork+0x7c/0xb0
[20290.282294]  [<ffffffff8108fcc0>] ? flush_kthread_worker+0xb0/0xb0


I'll allow it to run for a few hours, and then will report.

On a side-note, I ran 'btrfs check' and it returned so many errors
that it went out of my console's history... unfortunately I didn't
redirect its output to a file (big mistake), I didn't thought it would
be so big.  Anyway, part of the output:

(.... older output lost due to term size ....)
root 5 inode 94906683 errors 200, dir isize wrong
root 5 inode 94906716 errors 200, dir isize wrong
root 5 inode 94906730 errors 200, dir isize wrong
root 5 inode 94906735 errors 200, dir isize wrong
root 5 inode 94906758 errors 200, dir isize wrong
(....)
root 5 inode 94928259 errors 200, dir isize wrong
root 5 inode 94928286 errors 200, dir isize wrong
root 5 inode 94928311 errors 200, dir isize wrong
root 5 inode 94928321 errors 200, dir isize wrong
root 5 inode 133964681 errors 200, dir isize wrong
root 5 inode 133964684 errors 200, dir isize wrong
root 5 inode 142590710 errors 200, dir isize wrong
root 5 inode 144973646 errors 200, dir isize wrong
root 5 inode 146401067 errors 100, file extent discount
root 5 inode 146401080 errors 100, file extent discount
root 5 inode 146401096 errors 100, file extent discount
root 5 inode 146401108 errors 100, file extent discount
(.....)
root 5 inode 146436466 errors 100, file extent discount
root 5 inode 146436478 errors 100, file extent discount
root 5 inode 146436507 errors 100, file extent discount
root 5 inode 146436538 errors 100, file extent discount
root 5 inode 146436569 errors 100, file extent discount
root 5 inode 146436570 errors 100, file extent discount
root 5 inode 146436581 errors 100, file extent discount
root 5 inode 146436601 errors 100, file extent discount
root 5 inode 146436627 errors 100, file extent discount
root 5 inode 146938464 errors 100, file extent discount
root 5 inode 146953375 errors 100, file extent discount
root 5 inode 147034342 errors 100, file extent discount
found 3028618030140 bytes used err is 1
total csum bytes: 10600828544
total tree bytes: 69761568768
total fs tree bytes: 51199995904
total extent tree bytes: 6283046912
btree space waste bytes: 13467432119
file data blocks allocated: 52622775431168
 referenced 11853450313728
Btrfs v3.14.2

real    266m24.291s    <---- this is why i do not want to run it
again, unless absolutely necessary.
user    40m8.369s
sys     15m37.105s

Ildefonso
