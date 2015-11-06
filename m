Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-out1.informatik.tu-muenchen.de ([131.159.0.8]:64815 "EHLO
	mail-out1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033190AbbKFK5m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Nov 2015 05:57:42 -0500
Received: (Authenticated sender: totakura)
	by mail.in.tum.de (Postfix) with ESMTPSA id 31B271C248B
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2015 11:51:53 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Sree Harsha Totakura <sreeharsha@totakura.in>
Subject: btrfs locking in linux 4.2.5
Message-ID: <563C862D.30604@totakura.in>
Date: Fri, 6 Nov 2015 11:51:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I believe I ran into some btrfs related locking issues with linux-4.2.5.
 It happened when I updated my Arch Linux OS, restarted the system, and
tried to copy (not move) 20GB+ of data with in the btrfs /root partition.

The system's load shot up with load averages peaking up to 20.00 at some
point (the system has 8 cores).  Programs were stuck while loading.

After about 20 minutes, the system returned to normal operation and sane
load averages.

The system log had the following warnings hinting that this could be due
to btrfs locking:

> Nov 05 14:26:42 fulcrum kernel: INFO: task systemd-journal:330 blocked for more than 120 seconds.
> Nov 05 14:26:42 fulcrum kernel: Tainted: P IO 4.2.5-1-ARCH #1
> Nov 05 14:26:42 fulcrum kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 05 14:26:42 fulcrum kernel: systemd-journal D 0000000000000005 0 330 1 0x00000004
> Nov 05 14:26:42 fulcrum kernel: ffff8806027a7d28 0000000000000082 ffff88060125b200 ffff880602a2b200
> Nov 05 14:26:42 fulcrum kernel: 0000000000000000 ffff8806027a8000 ffff8806017689f0 ffff8806017689f0
> Nov 05 14:26:42 fulcrum kernel: ffff880487f1b170 0000000000000001 ffff8806027a7d48 ffffffff8157283e
> Nov 05 14:26:42 fulcrum kernel: Call Trace:
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157283e>] schedule+0x3e/0x90
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e1b2a>] wait_current_trans.isra.9+0xca/0x110 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff810b4c80>] ? wake_atomic_t_function+0x60/0x60
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e36e0>] start_transaction+0x420/0x580 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e385b>] btrfs_start_transaction+0x1b/0x20 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01f9054>] btrfs_sync_file+0x204/0x380 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8120209b>] vfs_fsync_range+0x4b/0xb0
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff81219713>] ? SyS_timerfd_settime+0x53/0xa0
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8120215d>] do_fsync+0x3d/0x70
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff81202400>] SyS_fsync+0x10/0x20
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157626e>] entry_SYSCALL_64_fastpath+0x12/0x71
> Nov 05 14:26:42 fulcrum kernel: INFO: task postgres:894 blocked for more than 120 seconds.
> Nov 05 14:26:42 fulcrum kernel: Tainted: P IO 4.2.5-1-ARCH #1
> Nov 05 14:26:42 fulcrum kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 05 14:26:42 fulcrum kernel: postgres D ffff88061fc95200 0 894 865 0x00000000
> Nov 05 14:26:42 fulcrum kernel: ffff8805f435fb38 0000000000000086 ffff880603ed1900 ffff880603513200
> Nov 05 14:26:42 fulcrum kernel: ffff8805f435fbb8 ffff8805f4360000 ffff8806017689f0 ffff8806017689f0
> Nov 05 14:26:42 fulcrum kernel: ffff88059e5acc38 0000000000000001 ffff8805f435fb58 ffffffff8157283e
> Nov 05 14:26:42 fulcrum kernel: Call Trace:
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157283e>] schedule+0x3e/0x90
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e1b2a>] wait_current_trans.isra.9+0xca/0x110 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff810b4c80>] ? wake_atomic_t_function+0x60/0x60
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e36e0>] start_transaction+0x420/0x580 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e385b>] btrfs_start_transaction+0x1b/0x20 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01f205a>] btrfs_create+0x4a/0x210 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811ddf7c>] vfs_create+0x9c/0xd0
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811def67>] path_openat+0xfb7/0x1110
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811e05ba>] do_filp_open+0x8a/0x100
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811ed2a8>] ? __alloc_fd+0x88/0x110
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811cfd36>] do_sys_open+0x146/0x230
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811cfe3e>] SyS_open+0x1e/0x20
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157626e>] entry_SYSCALL_64_fastpath+0x12/0x71
> Nov 05 14:26:42 fulcrum kernel: INFO: task zsh:1959 blocked for more than 120 seconds.
> Nov 05 14:26:42 fulcrum kernel: Tainted: P IO 4.2.5-1-ARCH #1
> Nov 05 14:26:42 fulcrum kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 05 14:26:42 fulcrum kernel: zsh D 0000000000000001 0 1959 1323 0x00000000
> Nov 05 14:26:42 fulcrum kernel: ffff880556813cd8 0000000000000082 ffff8805ec457080 ffff8805eac5b200
> Nov 05 14:26:42 fulcrum kernel: ffff880556813ce8 ffff880556814000 ffff8805fcde09f0 ffff8805fcde09f0
> Nov 05 14:26:42 fulcrum kernel: ffff8800d4f05ac8 0000000000000001 ffff880556813cf8 ffffffff8157283e
> Nov 05 14:26:42 fulcrum kernel: Call Trace:
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157283e>] schedule+0x3e/0x90
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e1b2a>] wait_current_trans.isra.9+0xca/0x110 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff810b4c80>] ? wake_atomic_t_function+0x60/0x60
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e36e0>] start_transaction+0x420/0x580 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811e8b21>] ? __d_lookup+0xa1/0x160
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e385b>] btrfs_start_transaction+0x1b/0x20 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01f1ac0>] btrfs_symlink+0x80/0x3e0 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811dcfe0>] ? lookup_dcache+0x30/0xb0
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811df37b>] vfs_symlink+0x8b/0xc0
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811e0c17>] SyS_symlinkat+0xd7/0x110
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811e0c66>] SyS_symlink+0x16/0x20
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157626e>] entry_SYSCALL_64_fastpath+0x12/0x71
> Nov 05 14:26:42 fulcrum kernel: INFO: task firefox:2082 blocked for more than 120 seconds.
> Nov 05 14:26:42 fulcrum kernel: Tainted: P IO 4.2.5-1-ARCH #1
> Nov 05 14:26:42 fulcrum kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 05 14:26:42 fulcrum kernel: firefox D ffff88061fc15200 0 2082 1 0x00000004
> Nov 05 14:26:42 fulcrum kernel: ffff8804b9c47b38 0000000000000086 ffffffff81812500 ffff88060135cb00
> Nov 05 14:26:42 fulcrum kernel: ffff88059e63d9f8 ffff8804b9c48000 ffff8805fcde09f0 ffff8805fcde09f0
> Nov 05 14:26:42 fulcrum kernel: ffff8805da1de398 0000000000000001 ffff8804b9c47b58 ffffffff8157283e
> Nov 05 14:26:42 fulcrum kernel: Call Trace:
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157283e>] schedule+0x3e/0x90
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e1b2a>] wait_current_trans.isra.9+0xca/0x110 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff810b4c80>] ? wake_atomic_t_function+0x60/0x60
> Nov 05 14:26:42 fulcrum kernel: 0000000000000000 ffff8806027a8000 ffff8806017689f0 ffff8806017689f0
> Nov 05 14:26:42 fulcrum kernel: ffff880487f1b170 0000000000000001 ffff8806027a7d48 ffffffff8157283e
> Nov 05 14:26:42 fulcrum kernel: Call Trace:
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157283e>] schedule+0x3e/0x90
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e1b2a>] wait_current_trans.isra.9+0xca/0x110 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff810b4c80>] ? wake_atomic_t_function+0x60/0x60
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e36e0>] start_transaction+0x420/0x580 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e385b>] btrfs_start_transaction+0x1b/0x20 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01f9054>] btrfs_sync_file+0x204/0x380 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8120209b>] vfs_fsync_range+0x4b/0xb0
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff81219713>] ? SyS_timerfd_settime+0x53/0xa0
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8120215d>] do_fsync+0x3d/0x70
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff81202400>] SyS_fsync+0x10/0x20
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157626e>] entry_SYSCALL_64_fastpath+0x12/0x71
> Nov 05 14:26:42 fulcrum kernel: INFO: task postgres:894 blocked for more than 120 seconds.
> Nov 05 14:26:42 fulcrum kernel: Tainted: P IO 4.2.5-1-ARCH #1
> Nov 05 14:26:42 fulcrum kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 05 14:26:42 fulcrum kernel: postgres D ffff88061fc95200 0 894 865 0x00000000
> Nov 05 14:26:42 fulcrum kernel: ffff8805f435fb38 0000000000000086 ffff880603ed1900 ffff880603513200
> Nov 05 14:26:42 fulcrum kernel: ffff8805f435fbb8 ffff8805f4360000 ffff8806017689f0 ffff8806017689f0
> Nov 05 14:26:42 fulcrum kernel: ffff88059e5acc38 0000000000000001 ffff8805f435fb58 ffffffff8157283e
> Nov 05 14:26:42 fulcrum kernel: Call Trace:
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157283e>] schedule+0x3e/0x90
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e1b2a>] wait_current_trans.isra.9+0xca/0x110 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff810b4c80>] ? wake_atomic_t_function+0x60/0x60
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e36e0>] start_transaction+0x420/0x580 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e385b>] btrfs_start_transaction+0x1b/0x20 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01f205a>] btrfs_create+0x4a/0x210 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811ddf7c>] vfs_create+0x9c/0xd0
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811def67>] path_openat+0xfb7/0x1110
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811e05ba>] do_filp_open+0x8a/0x100
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811ed2a8>] ? __alloc_fd+0x88/0x110
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811cfd36>] do_sys_open+0x146/0x230
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811cfe3e>] SyS_open+0x1e/0x20
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157626e>] entry_SYSCALL_64_fastpath+0x12/0x71
> Nov 05 14:26:42 fulcrum kernel: INFO: task zsh:1959 blocked for more than 120 seconds.
> Nov 05 14:26:42 fulcrum kernel: Tainted: P IO 4.2.5-1-ARCH #1
> Nov 05 14:26:42 fulcrum kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 05 14:26:42 fulcrum kernel: zsh D 0000000000000001 0 1959 1323 0x00000000
> Nov 05 14:26:42 fulcrum kernel: ffff880556813cd8 0000000000000082 ffff8805ec457080 ffff8805eac5b200
> Nov 05 14:26:42 fulcrum kernel: ffff880556813ce8 ffff880556814000 ffff8805fcde09f0 ffff8805fcde09f0
> Nov 05 14:26:42 fulcrum kernel: ffff8800d4f05ac8 0000000000000001 ffff880556813cf8 ffffffff8157283e
> Nov 05 14:26:42 fulcrum kernel: Call Trace:
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157283e>] schedule+0x3e/0x90
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e1b2a>] wait_current_trans.isra.9+0xca/0x110 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff810b4c80>] ? wake_atomic_t_function+0x60/0x60
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e36e0>] start_transaction+0x420/0x580 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: 0000000000000000 ffff8806027a8000 ffff8806017689f0 ffff8806017689f0
> Nov 05 14:26:42 fulcrum kernel: ffff880487f1b170 0000000000000001 ffff8806027a7d48 ffffffff8157283e
> Nov 05 14:26:42 fulcrum kernel: Call Trace:
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157283e>] schedule+0x3e/0x90
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e1b2a>] wait_current_trans.isra.9+0xca/0x110 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff810b4c80>] ? wake_atomic_t_function+0x60/0x60
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e36e0>] start_transaction+0x420/0x580 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e385b>] btrfs_start_transaction+0x1b/0x20 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01f9054>] btrfs_sync_file+0x204/0x380 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8120209b>] vfs_fsync_range+0x4b/0xb0
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff81219713>] ? SyS_timerfd_settime+0x53/0xa0
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8120215d>] do_fsync+0x3d/0x70
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff81202400>] SyS_fsync+0x10/0x20
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157626e>] entry_SYSCALL_64_fastpath+0x12/0x71
> Nov 05 14:26:42 fulcrum kernel: INFO: task postgres:894 blocked for more than 120 seconds.
> Nov 05 14:26:42 fulcrum kernel: Tainted: P IO 4.2.5-1-ARCH #1
> Nov 05 14:26:42 fulcrum kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 05 14:26:42 fulcrum kernel: postgres D ffff88061fc95200 0 894 865 0x00000000
> Nov 05 14:26:42 fulcrum kernel: ffff8805f435fb38 0000000000000086 ffff880603ed1900 ffff880603513200
> Nov 05 14:26:42 fulcrum kernel: ffff8805f435fbb8 ffff8805f4360000 ffff8806017689f0 ffff8806017689f0
> Nov 05 14:26:42 fulcrum kernel: ffff88059e5acc38 0000000000000001 ffff8805f435fb58 ffffffff8157283e
> Nov 05 14:26:42 fulcrum kernel: Call Trace:
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157283e>] schedule+0x3e/0x90
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e1b2a>] wait_current_trans.isra.9+0xca/0x110 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff810b4c80>] ? wake_atomic_t_function+0x60/0x60
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e36e0>] start_transaction+0x420/0x580 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01e385b>] btrfs_start_transaction+0x1b/0x20 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffffa01f205a>] btrfs_create+0x4a/0x210 [btrfs]
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811ddf7c>] vfs_create+0x9c/0xd0
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811def67>] path_openat+0xfb7/0x1110
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811e05ba>] do_filp_open+0x8a/0x100
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811ed2a8>] ? __alloc_fd+0x88/0x110
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811cfd36>] do_sys_open+0x146/0x230
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff811cfe3e>] SyS_open+0x1e/0x20
> Nov 05 14:26:42 fulcrum kernel: [<ffffffff8157626e>] entry_SYSCALL_64_fastpath+0x12/0x71

.. and many similar lines.

I searched online and found few references to related issues, but they
were all older than an year.  It appeared to me that this issue may have
resurfaced recently and I wanted to post it here.

Also, as the system went back to normal operation after this, I want to
ask how these warnings should be treated.  Should I be worried about any
possible data corruption?

Regards,
Sree Harsha Totakura
