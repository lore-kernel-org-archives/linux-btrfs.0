Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.palepurple.co.uk ([89.16.183.188]:35253 "EHLO
	mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbbLGLPU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 06:15:20 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.palepurple.co.uk (Postfix) with ESMTP id 9CEC2812B
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Dec 2015 11:09:13 +0000 (GMT)
Received: from mail.palepurple.co.uk ([127.0.0.1])
	by localhost (mail.palepurple.co.uk [127.0.0.50]) (amavisd-new, port 10024)
	with ESMTP id I1B92PqrQo-w for <linux-btrfs@vger.kernel.org>;
	Mon,  7 Dec 2015 11:09:13 +0000 (GMT)
Received: from [172.30.33.200] (host81-133-46-190.in-addr.btopenworld.com [81.133.46.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: david@palepurple.co.uk)
	by mail.palepurple.co.uk (Postfix) with ESMTPSA id 5CA7680D3
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Dec 2015 11:09:13 +0000 (GMT)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: David Goodwin <david@codepoets.co.uk>
Subject: kernel 4.1.12 - hung_task_timeout
Message-ID: <566568D9.7070501@codepoets.co.uk>
Date: Mon, 7 Dec 2015 11:09:13 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

See below for oops messages from a 4.1.12 kernel.

The system would probably have been running a balance or scrub at the time.

Processes trying to use subvolumes blocked and it eventually needed 
rebooting via sysrq to fix.

Kernel is a vanilla one from kernel.org.

thanks,

David.


INFO: task cron:12252 blocked for more than 120 seconds.
       Not tainted 4.1.12-dg1 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
cron            D ffff8803e0256840     0 12252   2356 0x00000000
  ffff88021366caa0 ffff8803cb01c170 ffff8803cea84a20 0000000000000246
  ffff880004e70000 ffff8800e72829f0 0000000000140000 ffff8800e72829f0
  0000000000000001 ffff880028eb3438 ffffffff8157494f ffff88003bf0c2e0
Call Trace:
  [<ffffffff8157494f>] ? schedule+0x2f/0x80
  [<ffffffffa0126e2f>] ? wait_current_trans.isra.19+0x9f/0x100 [btrfs]
  [<ffffffff810b04d0>] ? wait_woken+0x90/0x90
  [<ffffffffa0128848>] ? start_transaction+0x438/0x5b0 [btrfs]
  [<ffffffffa0136f09>] ? btrfs_create+0x39/0x1e0 [btrfs]
  [<ffffffff811e4a88>] ? __d_instantiate+0x98/0x120
  [<ffffffff811e32db>] ? d_rehash+0x4b/0x60
  [<ffffffff811d79c4>] ? vfs_create+0xc4/0x130
  [<ffffffff811dbe34>] ? do_last+0x1154/0x1210
  [<ffffffff810afe01>] ? __init_waitqueue_head+0x1/0x20
  [<ffffffff811dbf73>] ? path_openat+0x83/0x600
  [<ffffffff810b0122>] ? __wake_up_bit+0x42/0x50
  [<ffffffff81194393>] ? page_add_file_rmap+0x13/0x60
  [<ffffffff811ddcd0>] ? do_filp_open+0x30/0xa0
  [<ffffffff811ea55f>] ? __alloc_fd+0x9f/0x130
  [<ffffffff811cb18a>] ? do_sys_open+0x12a/0x220
  [<ffffffff81578ff2>] ? system_call_fastpath+0x16/0x75
INFO: task cron:12566 blocked for more than 120 seconds.
       Not tainted 4.1.12-dg1 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
cron            D ffff8803e0216840     0 12566  25790 0x00000000
  ffff8803b08ac3d0 ffff8801b234d5c8 ffffffff81814540 ffff8803b08ac3d0
  ffff88004ecc4000 ffff880266c26634 ffff8803b08ac3d0 00000000ffffffff
  ffff880266c26638 0000000000000000 ffffffff8157494f ffff880266c26630
Call Trace:
  [<ffffffff8157494f>] ? schedule+0x2f/0x80
  [<ffffffff81574c7e>] ? schedule_preempt_disabled+0xe/0x20
  [<ffffffff81576b15>] ? __mutex_lock_slowpath+0x95/0x110
  [<ffffffff81576bab>] ? mutex_lock+0x1b/0x30
  [<ffffffff811db061>] ? do_last+0x381/0x1210
  [<ffffffff810afe01>] ? __init_waitqueue_head+0x1/0x20
  [<ffffffff811dbf73>] ? path_openat+0x83/0x600
  [<ffffffff811ddcd0>] ? do_filp_open+0x30/0xa0
  [<ffffffff811ea55f>] ? __alloc_fd+0x9f/0x130
  [<ffffffff811cb18a>] ? do_sys_open+0x12a/0x220
  [<ffffffff81578ff2>] ? system_call_fastpath+0x16/0x75
INFO: task cron:12568 blocked for more than 120 seconds.
       Not tainted 4.1.12-dg1 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
cron            D ffff8803e0256840     0 12568   2356 0x00000000
  ffff880004b71430 ffff8801247ba588 ffff8803cea84a20 ffff88004ecf0000
  ffff88004ecf0000 ffff8803baccd2a4 ffff880004b71430 00000000ffffffff
  ffff8803baccd2a8 0000000000000000 ffffffff8157494f ffff8803baccd2a0
Call Trace:
  [<ffffffff8157494f>] ? schedule+0x2f/0x80
  [<ffffffff81574c7e>] ? schedule_preempt_disabled+0xe/0x20
  [<ffffffff81576b15>] ? __mutex_lock_slowpath+0x95/0x110
  [<ffffffff81576bab>] ? mutex_lock+0x1b/0x30
  [<ffffffff811db061>] ? do_last+0x381/0x1210
  [<ffffffff810afe01>] ? __init_waitqueue_head+0x1/0x20
  [<ffffffff811dbf73>] ? path_openat+0x83/0x600
  [<ffffffff810b0122>] ? __wake_up_bit+0x42/0x50
  [<ffffffff8115c7e8>] ? filemap_map_pages+0xc8/0x250
  [<ffffffff811ddcd0>] ? do_filp_open+0x30/0xa0
  [<ffffffff811ea55f>] ? __alloc_fd+0x9f/0x130
  [<ffffffff811cb18a>] ? do_sys_open+0x12a/0x220
  [<ffffffff81578ff2>] ? system_call_fastpath+0x16/0x75
