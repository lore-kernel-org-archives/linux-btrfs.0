Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:54007 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751388AbdKDTOE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 4 Nov 2017 15:14:04 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: btrfs-progs: check --repair crashes with BUG ON
Message-ID: <e0476253-d0e6-8b0d-df01-28c2f7fcbe77@profihost.ag>
Date: Sat, 4 Nov 2017 20:08:37 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

after a power failure i have a btrfs volume which isn't mountable.

dmesg shows:
parent transid verify failed on 181846016 wanted 143404 found 143399

If i run:
btrfs check --repair /dev/mapper/crypt_md1

The output is:
parent transid verify failed on 181846016 wanted 143404 found 143399
parent transid verify failed on 181846016 wanted 143404 found 143399
Ignoring transid failure
Clearing log on /dev/mapper/crypt_md0, previous log_root 1520200695808,
level 0
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
./btrfs(commit_tree_roots+0x53)[0x439baa]
./btrfs(btrfs_commit_transaction+0xf9)[0x439f75]
./btrfs[0x467212]
./btrfs(handle_command_group+0x5d)[0x40b360]
./btrfs(cmd_rescue+0x15)[0x46749f]
./btrfs(main+0x163)[0x40b5e9]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7fc63f25db45]
./btrfs[0x40b0b9]
Aborted

This is btrfs-progs branch: devel - same happens with master or v4.13.3.

Stefan
