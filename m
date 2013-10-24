Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f68.google.com ([209.85.160.68]:60712 "EHLO
	mail-pb0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab3JXOW3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 10:22:29 -0400
Received: by mail-pb0-f68.google.com with SMTP id jt11so784981pbb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 07:22:28 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 24 Oct 2013 22:22:28 +0800
Message-ID: <CAC+R54AkkkfvKYQBkAvF5651X3FS_r7PHN-WYYgkH=wp08aejg@mail.gmail.com>
Subject: btrfs raid5 bug task mkfs.btrfs:3695 blocked for more than 120 seconds
From: lilofile <lilofile82@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when i create raid5 in btrfs ,command like this:

./mkfs.btrfs -d raid5 /dev/sdb /dev/sdc /dev/sdd /dev/sde  /dev/sdf
/dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm -f

WARNING! - Btrfs v0.20-rc1-358-g194aa4a-dirty IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

then no response,


there is error in kernel log:

Oct 24 21:25:36 host1 kernel: [ 3000.809503] INFO: task
mkfs.btrfs:3695 blocked for more than 120 seconds.
Oct 24 21:25:36 host1 kernel: [ 3000.809506] "echo 0 >
/proc/sys/kernel/hung_task_
timeout_secs" disables this message.
Oct 24 21:25:36 host1 kernel: [ 3000.809508] mkfs.btrfs      D
0000000000000001     0  3695   3519 0x00000000
Oct 24 21:25:36 host1 kernel: [ 3000.809513]  ffff8807f4441c68
0000000000000082 ffffffff8133677d ffff88080e049590
Oct 24 21:25:36 host1 kernel: [ 3000.809518]  ffff8807f4441fd8
ffff8807f4441fd8 ffff8807f4441fd8 00000000000139c0
Oct 24 21:25:36 host1 kernel: [ 3000.809522]  ffff88080e9ddc00
ffff8808115a8000 ffff88080f7bc000 7fffffffffffffff
Oct 24 21:25:36 host1 kernel: [ 3000.809527] Call Trace:
Oct 24 21:25:36 host1 kernel: [ 3000.809534]  [<ffffffff8133677d>] ?
rb_insert_color+0xad/0x150
Oct 24 21:25:36 host1 kernel: [ 3000.809539]  [<ffffffff8169d8b9>]
schedule+0x29/0x70
Oct 24 21:25:36 host1 kernel: [ 3000.809543]  [<ffffffff8169bfd5>]
schedule_timeout+0x2a5/0x320
Oct 24 21:25:36 host1 kernel: [ 3000.809547]  [<ffffffff8131048c>] ?
blk_queue_bio+0x1cc/0x3a0
Oct 24 21:25:36 host1 kernel: [ 3000.809551]  [<ffffffff8169d70f>]
wait_for_common+0xdf/0x180
Oct 24 21:25:36 host1 kernel: [ 3000.809555]  [<ffffffff8108a360>] ?
try_to_wake_up+0x200/0x200
Oct 24 21:25:36 host1 kernel: [ 3000.809559]  [<ffffffff8169d88d>]
wait_for_completion+0x1d/0x20
Oct 24 21:25:36 host1 kernel: [ 3000.809563]  [<ffffffff81315c14>]
blkdev_issue_discard+0x1b4/0x1c0
Oct 24 21:25:36 host1 kernel: [ 3000.809567]  [<ffffffff81316341>]
blkdev_ioctl+0x461/0x7a0
Oct 24 21:25:36 host1 kernel: [ 3000.809572]  [<ffffffff811beb70>]
block_ioctl+0x40/0x50
Oct 24 21:25:36 host1 kernel: [ 3000.809576]  [<ffffffff811996fa>]
do_vfs_ioctl+0x8a/0x340
Oct 24 21:25:36 host1 kernel: [ 3000.809579]  [<ffffffff8118c72a>] ?
sys_newfstat+0x2a/0x40
Oct 24 21:25:36 host1 kernel: [ 3000.809583]  [<ffffffff81199a41>]
sys_ioctl+0x91/0xa0
Oct 24 21:25:36 host1 kernel: [ 3000.809588]  [<ffffffff816a7029>]
system_call_fastpath+0x16/0x1b
