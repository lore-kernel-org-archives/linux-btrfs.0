Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fallback3.mail.ru ([94.100.181.189]:48722 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbbKBMM2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Nov 2015 07:12:28 -0500
Received: from smtp53.i.mail.ru (smtp53.i.mail.ru [94.100.177.113])
	by fallback3.mail.ru (mPOP.Fallback_MX) with ESMTP id E268116108CFA
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2015 14:42:53 +0300 (MSK)
Received: from 77-173-215-182.ip.telfort.nl ([77.173.215.182]:49742 helo=centurion)
	by smtp53.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
	id 1ZtDVj-0001YL-C1
	for linux-btrfs@vger.kernel.org; Mon, 02 Nov 2015 14:42:51 +0300
Received: from [127.0.0.1] (localhost [IPv6:::1])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by centurion (Postfix) with ESMTPSA id 0AFC6280B5B
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2015 12:42:47 +0100 (CET)
Message-ID: <56374C7D.5080609@mail.ru>
Date: Mon, 02 Nov 2015 12:43:57 +0100
From: Dmitry Katsubo <dma_k@mail.ru>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Process is blocked for more than 120 seconds
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I have noticed the following in the log. The system continues to run,
but I am not sure for how long it will be stable.

# uname -a
Linux Debian 4.2.3-2~bpo8+1 (2015-10-20) i686 GNU/Linux

# mount | grep /var
/dev/sdd2 on /var type btrfs
(rw,noatime,compress=lzo,space_cache,subvolid=258,subvol=/var)

> [Mon Nov  2 06:35:57 2015] INFO: task nscd:859 blocked for more than 120 seconds.
> [Mon Nov  2 06:35:57 2015]       Not tainted 4.2.0-0.bpo.1-686-pae #1
> [Mon Nov  2 06:35:57 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Mon Nov  2 06:35:57 2015] nscd            D f1c7dd20     0   859      1 0x00000000
> [Mon Nov  2 06:35:57 2015]  f1c7dd40 00200082 f79de900 f1c7dd20 c10bc119 ffffffe0 f3aec740 00200246
> [Mon Nov  2 06:35:57 2015]  f74ea800 f79e3f40 f77fb800 f1c7e000 f6b381dc f6b38000 f1c7dd4c c14f1fdb
> [Mon Nov  2 06:35:57 2015]  d5553960 f1c7dd70 f867672f 00000000 f77fb800 c1099250 d0a4be08 d9755e68
> [Mon Nov  2 06:35:57 2015] Call Trace:
> [Mon Nov  2 06:35:57 2015]  [<c10bc119>] ? del_timer_sync+0x49/0x50
> [Mon Nov  2 06:35:57 2015]  [<c14f1fdb>] ? schedule+0x2b/0x80
> [Mon Nov  2 06:35:57 2015]  [<f867672f>] ? wait_current_trans.isra.21+0x8f/0xf0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<c1099250>] ? wait_woken+0x80/0x80
> [Mon Nov  2 06:35:57 2015]  [<f86782b0>] ? start_transaction+0x3d0/0x5d0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<f866483d>] ? btrfs_delalloc_reserve_metadata+0x32d/0x580 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<f867e480>] ? btrfs_dirty_inode+0xb0/0xb0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<f8678533>] ? btrfs_join_transaction+0x23/0x30 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<f867e409>] ? btrfs_dirty_inode+0x39/0xb0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<f867e480>] ? btrfs_dirty_inode+0xb0/0xb0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<c11aaa6e>] ? file_update_time+0x7e/0xc0
> [Mon Nov  2 06:35:57 2015]  [<f8689aa0>] ? btrfs_page_mkwrite+0x80/0x3c0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<c10bec89>] ? hrtimer_cancel+0x19/0x20
> [Mon Nov  2 06:35:57 2015]  [<c10d0871>] ? futex_wait+0x1e1/0x270
> [Mon Nov  2 06:35:57 2015]  [<c115d098>] ? do_page_mkwrite+0x38/0x90
> [Mon Nov  2 06:35:57 2015]  [<c115ecd2>] ? do_wp_page+0x2e2/0x6d0
> [Mon Nov  2 06:35:57 2015]  [<c10cf491>] ? futex_wake+0x71/0x140
> [Mon Nov  2 06:35:57 2015]  [<c105c717>] ? kmap_atomic_prot+0xe7/0x110
> [Mon Nov  2 06:35:57 2015]  [<c1160a89>] ? handle_mm_fault+0xd59/0x14d0
> [Mon Nov  2 06:35:57 2015]  [<c1054bcc>] ? __do_page_fault+0x18c/0x480
> [Mon Nov  2 06:35:57 2015]  [<c1054ec0>] ? __do_page_fault+0x480/0x480
> [Mon Nov  2 06:35:57 2015]  [<c14f67cf>] ? error_code+0x67/0x6c
> [Mon Nov  2 06:35:57 2015] INFO: task nscd:864 blocked for more than 120 seconds.
> [Mon Nov  2 06:35:57 2015]       Not tainted 4.2.0-0.bpo.1-686-pae #1
> [Mon Nov  2 06:35:57 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Mon Nov  2 06:35:57 2015] nscd            D f1c87f5c     0   864      1 0x00000000
> [Mon Nov  2 06:35:57 2015]  f1c87ef4 00200082 f1c87f80 f1c87f5c 000003e7 f1c87ee4 f3aec740 ac76c560
> [Mon Nov  2 06:35:57 2015]  f74ea800 f79e3f40 f3c7b040 f1c88000 f3c7b040 ffff0001 f1c87f00 c14f1fdb
> [Mon Nov  2 06:35:57 2015]  f3aec77c f1c87f38 c14f4265 f1c87f1c f3aec780 f3aec788 00000000 00000125
> [Mon Nov  2 06:35:57 2015] Call Trace:
> [Mon Nov  2 06:35:57 2015]  [<c14f1fdb>] ? schedule+0x2b/0x80
> [Mon Nov  2 06:35:57 2015]  [<c14f4265>] ? rwsem_down_write_failed+0x185/0x280
> [Mon Nov  2 06:35:57 2015]  [<c12964d2>] ? call_rwsem_down_write_failed+0x6/0x8
> [Mon Nov  2 06:35:57 2015]  [<c14f3b85>] ? down_write+0x25/0x40
> [Mon Nov  2 06:35:57 2015]  [<c11505ba>] ? vm_mmap_pgoff+0x4a/0xa0
> [Mon Nov  2 06:35:57 2015]  [<c1196d08>] ? SyS_fstat64+0x28/0x30
> [Mon Nov  2 06:35:57 2015]  [<c1164e50>] ? SyS_mmap_pgoff+0x110/0x210
> [Mon Nov  2 06:35:57 2015]  [<c14f559b>] ? sysenter_do_call+0x12/0x12
> [Mon Nov  2 06:35:57 2015] INFO: task nmbd:1330 blocked for more than 120 seconds.
> [Mon Nov  2 06:35:57 2015]       Not tainted 4.2.0-0.bpo.1-686-pae #1
> [Mon Nov  2 06:35:57 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Mon Nov  2 06:35:57 2015] nmbd            D 00000000     0  1330      1 0x00000000
> [Mon Nov  2 06:35:57 2015]  ef44bd74 00200086 00000000 00000000 00000000 00000000 f3984900 00000000
> [Mon Nov  2 06:35:57 2015]  f69e1800 f79e3f40 f3a7a800 ef44c000 d17255a0 d17255a0 ef44bd80 c14f1fdb
> [Mon Nov  2 06:35:57 2015]  d1725600 ef44bdc8 f86961b5 000d3fff 00000000 00001000 00000000 000d3000
> [Mon Nov  2 06:35:57 2015] Call Trace:
> [Mon Nov  2 06:35:57 2015]  [<c14f1fdb>] ? schedule+0x2b/0x80
> [Mon Nov  2 06:35:57 2015]  [<f86961b5>] ? btrfs_start_ordered_extent+0xd5/0x100 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<c1099250>] ? wait_woken+0x80/0x80
> [Mon Nov  2 06:35:57 2015]  [<f868b254>] ? lock_and_cleanup_extent_if_need+0x134/0x260 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<f868bb46>] ? prepare_pages+0xc6/0x150 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<f868c76a>] ? __btrfs_buffered_write+0x17a/0x5e0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<c113e663>] ? __alloc_pages_nodemask+0x133/0x880
> [Mon Nov  2 06:35:57 2015]  [<f8690f85>] ? btrfs_file_write_iter+0x1e5/0x550 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<c116980c>] ? page_add_new_anon_rmap+0x6c/0x90
> [Mon Nov  2 06:35:57 2015]  [<c1191e29>] ? new_sync_write+0x79/0xb0
> [Mon Nov  2 06:35:57 2015]  [<c1192433>] ? vfs_write+0x93/0x1a0
> [Mon Nov  2 06:35:57 2015]  [<c1054be8>] ? __do_page_fault+0x1a8/0x480
> [Mon Nov  2 06:35:57 2015]  [<c14f3030>] ? mutex_lock+0x10/0x30
> [Mon Nov  2 06:35:57 2015]  [<c1192d96>] ? SyS_write+0x46/0x90
> [Mon Nov  2 06:35:57 2015]  [<c14f559b>] ? sysenter_do_call+0x12/0x12
> [Mon Nov  2 06:35:57 2015] INFO: task master:2321 blocked for more than 120 seconds.
> [Mon Nov  2 06:35:57 2015]       Not tainted 4.2.0-0.bpo.1-686-pae #1
> [Mon Nov  2 06:35:57 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Mon Nov  2 06:35:57 2015] master          D f79e3f40     0  2321      1 0x00000004
> [Mon Nov  2 06:35:57 2015]  edcd9e18 00200082 cb7fd040 f79e3f40 cb7fd040 ffffffe0 f3903c80 00200246
> [Mon Nov  2 06:35:57 2015]  c167cb00 f79d1f40 eef44800 edcda000 f6b381dc f6b38000 edcd9e24 c14f1fdb
> [Mon Nov  2 06:35:57 2015]  d5553960 edcd9e48 f867672f 00000000 eef44800 c1099250 f3309e68 c7a17d64
> [Mon Nov  2 06:35:57 2015] Call Trace:
> [Mon Nov  2 06:35:57 2015]  [<c14f1fdb>] ? schedule+0x2b/0x80
> [Mon Nov  2 06:35:57 2015]  [<f867672f>] ? wait_current_trans.isra.21+0x8f/0xf0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<c1099250>] ? wait_woken+0x80/0x80
> [Mon Nov  2 06:35:57 2015]  [<f86782b0>] ? start_transaction+0x3d0/0x5d0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<f867e480>] ? btrfs_dirty_inode+0xb0/0xb0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<f8678533>] ? btrfs_join_transaction+0x23/0x30 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<f867e409>] ? btrfs_dirty_inode+0x39/0xb0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<f867e480>] ? btrfs_dirty_inode+0xb0/0xb0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<c11aaa6e>] ? file_update_time+0x7e/0xc0
> [Mon Nov  2 06:35:57 2015]  [<c11998ea>] ? pipe_write+0x32a/0x400
> [Mon Nov  2 06:35:57 2015]  [<c1191e29>] ? new_sync_write+0x79/0xb0
> [Mon Nov  2 06:35:57 2015]  [<c1192433>] ? vfs_write+0x93/0x1a0
> [Mon Nov  2 06:35:57 2015]  [<c11a4d88>] ? poll_select_set_timeout+0x68/0x80
> [Mon Nov  2 06:35:57 2015]  [<c1192d96>] ? SyS_write+0x46/0x90
> [Mon Nov  2 06:35:57 2015]  [<c14f559b>] ? sysenter_do_call+0x12/0x12
> [Mon Nov  2 06:35:57 2015] INFO: task xfce4-sensors-p:2611 blocked for more than 120 seconds.
> [Mon Nov  2 06:35:57 2015]       Not tainted 4.2.0-0.bpo.1-686-pae #1
> [Mon Nov  2 06:35:57 2015] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Mon Nov  2 06:35:57 2015] xfce4-sensors-p D 00000000     0  2611   2560 0x00000000
> [Mon Nov  2 06:35:57 2015]  e71f9e50 00200086 00000000 00000000 5ca90000 ffffffe0 eeec4ac0 00200246
> [Mon Nov  2 06:35:57 2015]  c167cb00 f79d1f40 e7ea3040 e71fa000 f6f345dc f6f34400 e71f9e5c c14f1fdb
> [Mon Nov  2 06:35:57 2015]  d5553960 e71f9e80 f867672f 00000000 e7ea3040 c1099250 c7a17d64 ea299e84
> [Mon Nov  2 06:35:57 2015] Call Trace:
> [Mon Nov  2 06:35:57 2015]  [<c14f1fdb>] ? schedule+0x2b/0x80
> [Mon Nov  2 06:35:57 2015]  [<f867672f>] ? wait_current_trans.isra.21+0x8f/0xf0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<c1099250>] ? wait_woken+0x80/0x80
> [Mon Nov  2 06:35:57 2015]  [<f8678331>] ? start_transaction+0x451/0x5d0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<f86784d4>] ? btrfs_start_transaction+0x24/0x30 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<f86795a0>] ? __unlink_start_trans+0x20/0xb0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<c11a6e02>] ? d_rehash+0x42/0x50
> [Mon Nov  2 06:35:57 2015]  [<f86829c8>] ? btrfs_unlink+0x28/0xb0 [btrfs]
> [Mon Nov  2 06:35:57 2015]  [<c119e222>] ? vfs_unlink+0xf2/0x190
> [Mon Nov  2 06:35:57 2015]  [<c11a0afb>] ? do_unlinkat+0x21b/0x280
> [Mon Nov  2 06:35:57 2015]  [<c11a1505>] ? SyS_unlink+0x15/0x20
> [Mon Nov  2 06:35:57 2015]  [<c14f559b>] ? sysenter_do_call+0x12/0x12


-- 
With best regards,
Dmitry
