Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-3.smtp-out.eu-west-1.amazonses.com ([54.240.4.3]:44306 "EHLO
        a4-3.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727398AbeHQT3k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 15:29:40 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Martin Raiber <martin@urbackup.org>
Subject: Hang after growing file system (4.14.48)
Message-ID: <0102016548b4e2a4-a73ffb8d-fd08-4362-a7bc-3919c50adbe1-000000@eu-west-1.amazonses.com>
Date: Fri, 17 Aug 2018 16:25:38 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

after growing a single btrfs file system (on a loop device, with btrfs
fi resize max /fs ) it hangs later (sometimes much later). Symptoms:

* A unkillable btrfs process using 100% (of one) CPU in R state (no
kernel trace, cannot attach with strace, gdb or run linux perf)
* Other processes with following stack trace:

Fri Aug 17 16:21:06 2018] INFO: task python3:46794 blocked for more than
120 seconds.
[Fri Aug 17 16:21:06 2018]       Not tainted 4.14.48 #2
[Fri Aug 17 16:21:06 2018] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Fri Aug 17 16:21:06 2018] python3         D    0 46794  46702 0x00000000
[Fri Aug 17 16:21:06 2018] Call Trace:
[Fri Aug 17 16:21:06 2018]  ? __schedule+0x2de/0x7b0
[Fri Aug 17 16:21:06 2018]  schedule+0x32/0x80
[Fri Aug 17 16:21:06 2018]  schedule_preempt_disabled+0xa/0x10
[Fri Aug 17 16:21:06 2018]  __mutex_lock.isra.1+0x295/0x4c0
[Fri Aug 17 16:21:06 2018]  ? btrfs_show_devname+0x25/0xd0
[Fri Aug 17 16:21:06 2018]  btrfs_show_devname+0x25/0xd0
[Fri Aug 17 16:21:06 2018]  show_vfsmnt+0x44/0x150
[Fri Aug 17 16:21:06 2018]  seq_read+0x314/0x3d0
[Fri Aug 17 16:21:06 2018]  __vfs_read+0x26/0x130
[Fri Aug 17 16:21:06 2018]  vfs_read+0x91/0x130
[Fri Aug 17 16:21:06 2018]  SyS_read+0x42/0x90
[Fri Aug 17 16:21:06 2018]  do_syscall_64+0x6e/0x120
[Fri Aug 17 16:21:06 2018]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[Fri Aug 17 16:21:06 2018] RIP: 0033:0x7f67fd41b6d0
[Fri Aug 17 16:21:06 2018] RSP: 002b:00007ffd80be2678 EFLAGS: 00000246
ORIG_RAX: 0000000000000000
[Fri Aug 17 16:21:06 2018] RAX: ffffffffffffffda RBX: 000056521bf7bb00
RCX: 00007f67fd41b6d0
[Fri Aug 17 16:21:06 2018] RDX: 0000000000000400 RSI: 000056521bf7bd30
RDI: 0000000000000004
[Fri Aug 17 16:21:06 2018] RBP: 0000000000000d68 R08: 00007f67fe655700
R09: 0000000000000101
[Fri Aug 17 16:21:06 2018] R10: 000056521bf7c0cc R11: 0000000000000246
R12: 00007f67fd6d6440
[Fri Aug 17 16:21:06 2018] R13: 00007f67fd6d5900 R14: 0000000000000064
R15: 0000000000000000

Regards,
Martin Raiber
