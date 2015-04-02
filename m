Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38272 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbbDBLjH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Apr 2015 07:39:07 -0400
Received: by wibgn9 with SMTP id gn9so101945918wib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Apr 2015 04:39:06 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 2 Apr 2015 14:38:24 +0300
Message-ID: <CAGqmi74e_U5-UVUy+MHbxc2f-38pRyjK1Zo0Up-V9ndFpv-bXA@mail.gmail.com>
Subject: Btrfs hangs 3.19-10
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've get it several times, after rebooting or unclean shutdown system.

This is very strange bug, because if i reboot, and mount it from live
cd, all that okay, and after reboot in system, system successful mount
all and working good.
i did try to found any previous issues on it, and found nothing.


[  240.100043] INFO: task mount:485 blocked for more than 120 seconds.
[  240.100156]       Not tainted 3.19.0-10-generic #10-Ubuntu
[  240.100244] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  240.100359] mount           D ffff88009e907818     0   485      1 0x00000004
[  240.100364]  ffff88009e907818 ffff8804473ac4b0 0000000000014200
ffff88009e907fd8
[  240.100368]  0000000000014200 ffff88044ae3f5c0 ffff8804473ac4b0
ffff88009e907828
[  240.100371]  ffff88045d073c70 ffff88045d073cd8 ffff88045d073cf0
ffff88009e907858
[  240.100374] Call Trace:
[  240.100386]  [<ffffffff817c38e9>] schedule+0x29/0x70
[  240.100427]  [<ffffffffc050a7e5>] btrfs_tree_lock+0x55/0x1f0 [btrfs]
[  240.100432]  [<ffffffff810b6200>] ? wait_woken+0x90/0x90
[  240.100444]  [<ffffffffc04acc69>] btrfs_search_slot+0x709/0xa60 [btrfs]
[  240.100457]  [<ffffffffc04ae8ad>] btrfs_insert_empty_items+0x7d/0xd0 [btrfs]
[  240.100469]  [<ffffffffc04a78aa>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  240.100487]  [<ffffffffc050aab8>] btrfs_insert_orphan_item+0x58/0x80 [btrfs]
[  240.100509]  [<ffffffffc050c04e>] insert_orphan_item+0x5e/0x90 [btrfs]
[  240.100529]  [<ffffffffc0510d11>] replay_one_buffer+0x351/0x370 [btrfs]
[  240.100547]  [<ffffffffc050b991>] walk_up_log_tree+0xd1/0x240 [btrfs]
[  240.100558]  [<ffffffffc04a78aa>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  240.100577]  [<ffffffffc050bb9b>] walk_log_tree+0x9b/0x1a0 [btrfs]
[  240.100596]  [<ffffffffc0513214>] btrfs_recover_log_trees+0x1d4/0x470 [btrfs]
[  240.100614]  [<ffffffffc05109c0>] ? replay_one_extent+0x6b0/0x6b0 [btrfs]
[  240.100630]  [<ffffffffc04ceb23>] open_ctree+0x1813/0x2090 [btrfs]
[  240.100642]  [<ffffffffc04a4b00>] btrfs_mount+0x850/0x920 [btrfs]
[  240.100649]  [<ffffffff811f7208>] mount_fs+0x38/0x1c0
[  240.100653]  [<ffffffff8119b5e5>] ? __alloc_percpu+0x15/0x20
[  240.100658]  [<ffffffff812138fb>] vfs_kern_mount+0x6b/0x120
[  240.100662]  [<ffffffff81216754>] do_mount+0x204/0xb20
[  240.100665]  [<ffffffff8121738b>] SyS_mount+0x8b/0xd0
[  240.100669]  [<ffffffff817c824d>] system_call_fastpath+0x16/0x1b
[  240.100676] INFO: task btrfs-transacti:506 blocked for more than 120 seconds.
[  240.100780]       Not tainted 3.19.0-10-generic #10-Ubuntu
[  240.100869] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  240.100982] btrfs-transacti D ffff8804474abdc8     0   506      2 0x00000000
[  240.100986]  ffff8804474abdc8 ffff88009ef83ae0 0000000000014200
ffff8804474abfd8
[  240.100989]  0000000000014200 ffffffff81c1a580 ffff88009ef83ae0
ffff8804474abdd8
[  240.100992]  ffff880448695000 ffff88045d396000 ffff88045d33afc0
ffff8804474abe00
[  240.100995] Call Trace:
[  240.100998]  [<ffffffff817c38e9>] schedule+0x29/0x70
[  240.101018]  [<ffffffffc04d14c5>]
btrfs_commit_transaction+0x375/0xa40 [btrfs]
[  240.101021]  [<ffffffff810b6200>] ? wait_woken+0x90/0x90
[  240.101037]  [<ffffffffc04ccf5d>] transaction_kthread+0x1dd/0x250 [btrfs]
[  240.101052]  [<ffffffffc04ccd80>] ?
btrfs_cleanup_transaction+0x550/0x550 [btrfs]
[  240.101057]  [<ffffffff81094679>] kthread+0xc9/0xe0
[  240.101061]  [<ffffffff810945b0>] ? kthread_create_on_node+0x1c0/0x1c0
[  240.101064]  [<ffffffff817c8198>] ret_from_fork+0x58/0x90
[  240.101067]  [<ffffffff810945b0>] ? kthread_create_on_node+0x1c0/0x1c0

-- 
Have a nice day,
Timofey.
