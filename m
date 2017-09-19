Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:44643 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdISP4b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 11:56:31 -0400
Received: by mail-io0-f178.google.com with SMTP id v36so170236ioi.1
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 08:56:31 -0700 (PDT)
MIME-Version: 1.0
From: Rich Rauenzahn <rrauenza@gmail.com>
Date: Tue, 19 Sep 2017 08:56:29 -0700
Message-ID: <CAG+QAKXTRiC0s5pH_EQoz7Zd7nNfMC5++AN+EFgU6yY=3uvckw@mail.gmail.com>
Subject: WARNING: CPU: 3 PID: 439 at fs/btrfs/ctree.h:1559 btrfs_update_device+0x1c5/0x1d0
 [btrfs]
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've filed a bug on this kernel trace -- I get 100's of these a day.
I'd like to make them go away ....

https://bugzilla.kernel.org/show_bug.cgi?id=196949

[    4.747356] ------------[ cut here ]------------
[    4.747377] WARNING: CPU: 3 PID: 439 at fs/btrfs/ctree.h:1559
btrfs_update_device+0x1c5/0x1d0 [btrfs]
[    4.747377] Modules linked in: nfs_acl lockd grace sunrpc ip_tables
btrfs xor raid6_pq sd_mod crc32c_intel firewire_ohci igb ahci
 firewire_core crc_itu_t dca libahci i915 libata i2c_algo_bit e1000e
drm_kms_helper ptp syscopyarea sysfillrect pps_core sysimgblt f
b_sys_fops drm video
[    4.747385] CPU: 3 PID: 439 Comm: btrfs-cleaner Not tainted
4.13.2-1.el7.elrepo.x86_64 #1
[    4.747385] Hardware name: Supermicro X10SAE/X10SAE, BIOS 2.0a 05/09/2014
[    4.747386] task: ffff88040cdcae80 task.stack: ffffc900021f4000
[    4.747396] RIP: 0010:btrfs_update_device+0x1c5/0x1d0 [btrfs]
[    4.747396] RSP: 0018:ffffc900021f7d00 EFLAGS: 00010206
[    4.747397] RAX: 0000000000000fff RBX: ffff880407b7aa80 RCX: 0000001bc6c71e00
[    4.747397] RDX: ffff880000000000 RSI: ffff880404cd3f3c RDI: ffff880409417b58
[    4.747398] RBP: ffffc900021f7d48 R08: 0000000000003f60 R09: ffffc900021f7cb8
[    4.747398] R10: 0000000000001000 R11: 0000000000000003 R12: ffff88040559f800
[    4.747398] R13: 0000000000000000 R14: ffff880409417b58 R15: 0000000000003f3c
[    4.747399] FS:  0000000000000000(0000) GS:ffff88041fac0000(0000)
knlGS:0000000000000000
[    4.747399] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.747400] CR2: 00007f29c3000248 CR3: 00000004056a4000 CR4: 00000000001406e0
[    4.747400] Call Trace:
[    4.747410]  btrfs_remove_chunk+0x2fb/0x8b0 [btrfs]
[    4.747418]  btrfs_delete_unused_bgs+0x363/0x440 [btrfs]
[    4.747426]  cleaner_kthread+0x150/0x180 [btrfs]
[    4.747429]  kthread+0x109/0x140
[    4.747436]  ? btree_invalidatepage+0xa0/0xa0 [btrfs]
[    4.747437]  ? kthread_park+0x60/0x60
[    4.747439]  ret_from_fork+0x25/0x30
[    4.747439] Code: 10 00 00 00 4c 89 fe e8 8a 30 ff ff 4c 89 f7 e8
32 f6 fc ff e9 d3 fe ff ff b8 f4 ff ff ff e9 d4 fe ff ff 0f 1f 00 e8
bb 2e 9e e0 <0f> ff eb af 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 31 d2
be 02
[    4.747450] ---[ end trace 1ef80a625983d73b ]---
