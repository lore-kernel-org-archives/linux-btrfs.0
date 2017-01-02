Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:35199 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933206AbdABSue (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jan 2017 13:50:34 -0500
Received: by mail-yw0-f175.google.com with SMTP id v81so170957925ywb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jan 2017 10:50:34 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 2 Jan 2017 11:50:33 -0700
Message-ID: <CAJCQCtRhgxqtrpnsibOPqkMA75Cf=ryRAeTb0Gf-ygy=gjD_Yg@mail.gmail.com>
Subject: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Attempt 2. The original post isn't showing up on spinics, just my followup.


The Problem: The file system goes read-only soon after startup. It
only happens with a particular subvolume used for root fs, and only
with kernel 4.9.0 and 4.10-rc1.

If I boot kernel 4.8.15 with this subvolume as root fs, the problem
doesn't happen.
If I boot kernel 4.9.0 with a different subvolume as root fs, the
problem doesn't happen.

btrfs-progs 4.8.5, btrfs check reports no problems

Complete dmesg:
https://drive.google.com/open?id=0B_2Asp8DGjJ9SXZhWXdWSGVRbE0


And this is a snippet of the call trace.
[   34.787957] ------------[ cut here ]------------
[   34.788019] WARNING: CPU: 1 PID: 398 at
fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items+0x5f3/0x600
[btrfs]
[   34.788029] BTRFS: Transaction aborted (error -2)
[   34.788031] Modules linked in:
[...snipped...]
[   34.788272] CPU: 1 PID: 398 Comm: btrfs-transacti Not tainted
4.9.0-1.fc26.x86_64 #1
[   34.788276] Hardware name: HP HP Spectre Notebook/81A0, BIOS F.30 12/15/2016
[   34.788281]  ffff9bb10134fca0 ffffffffab3ecfcd ffff9bb10134fcf0
0000000000000000
[   34.788288]  ffff9bb10134fce0 ffffffffab0a2fbb 0000049200000002
ffff8bed30862800
[   34.788294]  00000000fffffffe 00000000ffffffff ffff8bed28194be0
ffff8bed30ede1c0
[   34.788301] Call Trace:
[   34.788312]  [<ffffffffab3ecfcd>] dump_stack+0x63/0x86
[   34.788318]  [<ffffffffab0a2fbb>] __warn+0xcb/0xf0
[   34.788323]  [<ffffffffab0a303f>] warn_slowpath_fmt+0x5f/0x80
[   34.788386]  [<ffffffffc03ef810>] ?
__btrfs_release_delayed_node+0x70/0x1c0 [btrfs]
[   34.788429]  [<ffffffffc03f0913>]
__btrfs_run_delayed_items+0x5f3/0x600 [btrfs]
[   34.788436]  [<ffffffffab229850>] ? kmem_cache_free+0x1c0/0x1f0
[   34.788473]  [<ffffffffc03f0f73>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[   34.788511]  [<ffffffffc039303a>]
btrfs_commit_transaction+0x23a/0xa20 [btrfs]
[   34.788549]  [<ffffffffc038dc7e>] transaction_kthread+0x1ce/0x1f0 [btrfs]
[   34.788583]  [<ffffffffc038dab0>] ?
btrfs_cleanup_transaction+0x520/0x520 [btrfs]
[   34.788590]  [<ffffffffab0c3319>] kthread+0xd9/0xf0
[   34.788597]  [<ffffffffab0c3240>] ? kthread_park+0x60/0x60
[   34.788603]  [<ffffffffab815e15>] ret_from_fork+0x25/0x30
[   34.788622] ---[ end trace d28d9fa7dece608b ]---
[   34.788628] BTRFS: error (device nvme0n1p4) in
__btrfs_run_delayed_items:1170: errno=-2 No such entry
[   34.788632] BTRFS info (device nvme0n1p4): forced readonly
[   34.788636] BTRFS warning (device nvme0n1p4): Skipping commit of
aborted transaction.
[   34.788640] BTRFS: error (device nvme0n1p4) in
cleanup_transaction:1850: errno=-2 No such entry
[   34.789000] BTRFS info (device nvme0n1p4): delayed_refs has NO entry



-- 
Chris Murphy
