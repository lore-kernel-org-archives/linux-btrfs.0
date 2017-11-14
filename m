Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:50073 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754243AbdKNJ4H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 04:56:07 -0500
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: how to repair or access broken btrfs?
Message-ID: <32c4071e-4ec0-4d22-95f9-68b22725cff7@profihost.ag>
Date: Tue, 14 Nov 2017 10:56:04 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

after a controller firmware bug / failure i've a broken btrfs.

# parent transid verify failed on 181846016 wanted 143404 found 143399

running repair, fsck or zero-log always results in the same failure message:
extent-tree.c:2725: alloc_reserved_tree_block: BUG_ON `ret` triggered,
value -1
.. stack trace ..

Is there an chance to get at least a single file out of the broken fs?

Greets,
Stefan


Complete output:
./btrfs check --repair /dev/mapper/crypt_md0
enabling repair mode
parent transid verify failed on 181846016 wanted 143404 found 143399
parent transid verify failed on 181846016 wanted 143404 found 143399
Ignoring transid failure
Checking filesystem on /dev/mapper/crypt_md0
UUID: d3f9eee9-efbd-4590-858f-27b39d453350
repair mode will force to clear out log tree, are you sure? [y/N]: y
parent transid verify failed on 308183040 wanted 143404 found 143399
parent transid verify failed on 308183040 wanted 143404 found 143399
Ignoring transid failure
parent transid verify failed on 338870272 wanted 143404 found 143399
parent transid verify failed on 338870272 wanted 143404 found 143399
Ignoring transid failure
parent transid verify failed on 12778157178880 wanted 143404 found 143399
parent transid verify failed on 12778157178880 wanted 143404 found 143399
Ignoring transid failure
leaf parent key incorrect 38699008
btrfs unable to find ref byte nr 12778147823616 parent 0 root 2  owner 0
offset 0
parent transid verify failed on 308183040 wanted 143404 found 143399
Ignoring transid failure
leaf parent key incorrect 91766784
extent-tree.c:2725: alloc_reserved_tree_block: BUG_ON `ret` triggered,
value -1
./btrfs[0x415cb3]
./btrfs[0x416ee5]
./btrfs[0x417104]
./btrfs[0x418cea]
./btrfs[0x418f06]
./btrfs(btrfs_alloc_free_block+0x1e4)[0x41b8d0]
./btrfs(__btrfs_cow_block+0xd3)[0x40c5f9]
./btrfs(btrfs_cow_block+0x110)[0x40d03b]
./btrfs(commit_tree_roots+0x53)[0x439a37]
./btrfs(btrfs_commit_transaction+0xf9)[0x439e02]
./btrfs(cmd_check+0x861)[0x46172e]
./btrfs(main+0x163)[0x40b5e9]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f44b14fab45]
./btrfs[0x40b0b9]
Aborted
