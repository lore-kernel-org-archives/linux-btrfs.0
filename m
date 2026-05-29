Received: from r3-22.sinamail.sina.com.cn (r3-22.sinamail.sina.com.cn [202.108.3.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6137237C906
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 22:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780092387; cv=none; b=mx/V8OQ55X856JFDxXEc4ox4NZqQksJQ4hxv05mtI3Frm3RfkD0aCwS0ktssvObVGxSW+zwg7IZPfC3E7xxOHMPJmC/7/O3dQthhCKG9rJpqMHFEqXgZc5x+/u8u/LKuHNEtk9PYFzQWGK34e+DeJEGW/mfvCpZVQhwb9hmWgUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780092387; c=relaxed/simple;
	bh=FrlNSD5ptoLwRoC92Nn/ePPH3Q6UgR3eP7lFPmRGkjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqK7aflC1tzz6hNBCURV9JpTkJXle89V4l3GsJ5ORvc3FsrvsjzX1YOzLnf/liWZ3BiTBWjukeuuxtb6vlyIcNT3f1JBdXEPzLWR4nIBFejYx5yslRvN6yXod2iR+scNIFf61lmswOft1Rt4q3jKxGjRP41TKV6CHCsCFqJdeXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=lF4ptmmp; arc=none smtp.client-ip=202.108.3.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="lF4ptmmp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1780092384;
	bh=tV9YFy/TIg8r8/7C2E2kcrSOZPl7xJdXK++V+f+9xIc=;
	h=From:Subject:Date:Message-ID;
	b=lF4ptmmpl2hSaR0pt1SzcUtYrZXCBYywEJEKV+Sx86sNmO9W7mNkhG8A8/xX9BIC6
	 qyq/xtwwbl/pPhryeueGdgtZp2h57bcdKrjzkuNUw8sU1sbSI3QPa4a5soD5Xp9Wzf
	 oSJIWCF5uFsFMcI5SSZXjNCl1vKedjeBGh5GGmZ8=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.33) with ESMTP
	id 6A1A0DD200007033; Fri, 30 May 2026 06:06:11 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 9575776685448
X-SMAIL-UIID: 45EF894C6A164D4D8498A92F92AF606C-20260530-060611-1
From: Hillf Danton <hdanton@sina.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <tom.leiming@gmail.com>,
	linux-block <linux-block@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	syzbot+78ad2c6a58c0a1faa5f5@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
Date: Sat, 30 May 2026 06:05:59 +0800
Message-ID: <20260529220600.1226-1-hdanton@sina.com>
In-Reply-To: <20260529070411.1206-1-hdanton@sina.com>
References: 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 29 May 2026 15:04:10 +0800 Hillf Danton wrote:
>On Fri, 29 May 2026 09:14:47 +0900 Tetsuo Handa wrote:
>>On 2026/05/29 8:00, Hillf Danton wrote:
>>>> Given the loop workqueue that triggered the jfs warning, can you specify
>>>> the reason why the workqueue in question is NOT flushed while closing disk?
>>>>
>>> Got it, the loop workqueue is NOT flushed to avoid deadlock, see d292dc80686a
>>> ("loop: don't destroy lo->workqueue in __loop_clr_fd") for detail.
>>> And the deadlock can be reproduced by flushing the loop workqueue with
>>> disk->open_mutex held [1].
>>> 
>>> [1] Subject: Re: [syzbot] possible deadlock in blkdev_put (3)
>>> https://lore.kernel.org/lkml/000000000000ea753505da2658d5@google.com/
>>
>>We can avoid the following lockdep warnings (including [1] you mentioned)
>>
>>  https://syzkaller.appspot.com/bug?extid=2f62807dc3239b8f584e
>>  https://syzkaller.appspot.com/bug?extid=c4e9d077bcc86bee08dc
>>  https://syzkaller.appspot.com/bug?extid=0f427123ae84b3ba6dc7
>>  https://syzkaller.appspot.com/bug?extid=4feabfc9641267769c97
>>  https://syzkaller.appspot.com/bug?extid=fb0ff9bfe34ad282ebd4
>>
>>caused by "drain_workqueue() with disk->open_mutex held" if we assign
>>caller-specific lockdep class to disk->open_mutex
>>
>>  https://sourceforge.net/p/tomoyo/tomoyo.git/ci/c2245c765ebeba9dcb924d9171d8d470a9ac41c8/
>>
>>.
>>
>>Also, we can avoid lockdep warning caused by "drain_workqueue() with disk->open_mutex held" +
>>"holding system_transition_mutex" if we forbid binding to pseudo files as backing file
>>in the loop driver
>>
>>  https://lkml.kernel.org/r/d38e4600-3c32-491f-aa49-905f4fad1bfb@I-love.SAKURA.ne.jp
>>
>>which we can reproduce with
>>
>>  echo 7:0 > /sys/power/resume
>>  losetup /dev/loop0 /sys/power/resume
>>  cat /dev/loop0 > /dev/null
>>  losetup -d /dev/loop0
>>
>>.
>>
>> Therefore, I think we can address this problem by "drain_workqueue() with disk->open_mutex
>> held" in the loop driver side.
>>
> Good news.
>
Bad news: Subject: [syzbot] [block?] possible deadlock in loop_process_work
[3] https://lore.kernel.org/lkml/6a19f5f7.5099cdd9.8e407.0004.GAE@google.com/

syzbot found the following issue on:

HEAD commit:    c1ecb239fa34 Add linux-next specific files for 20260522
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12fa6336580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=77a9211ff284de54
dashboard link: https://syzkaller.appspot.com/bug?extid=78ad2c6a58c0a1faa5f5
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4cb88c910144/disk-c1ecb239.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4a9bc938cf88/vmlinux-c1ecb239.xz
kernel image: https://storage.googleapis.com/syzbot-assets/684f1e33f264/bzImage-c1ecb239.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+78ad2c6a58c0a1faa5f5@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L
------------------------------------------------------
kworker/u8:15/1491 is trying to acquire lock:
ffff88805e1a6480 (sb_writers#5){.+.+}-{0:0}, at: do_req_filebacked drivers/block/loop.c:433 [inline]
ffff88805e1a6480 (sb_writers#5){.+.+}-{0:0}, at: loop_handle_cmd drivers/block/loop.c:1941 [inline]
ffff88805e1a6480 (sb_writers#5){.+.+}-{0:0}, at: loop_process_work+0x637/0x11b0 drivers/block/loop.c:1976

but task is already holding lock:
ffffc90006e27c40 ((work_completion)(&worker->work)){+.+.}-{0:0}, at: process_one_work+0x8be/0x1630 kernel/workqueue.c:3294

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #7 ((work_completion)(&worker->work)){+.+.}-{0:0}:
       process_one_work+0x8d7/0x1630 kernel/workqueue.c:3294
       process_scheduled_works kernel/workqueue.c:3401 [inline]
       worker_thread+0xb49/0x1140 kernel/workqueue.c:3482
       kthread+0x388/0x470 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #6 ((wq_completion)loop4){+.+.}-{0:0}:
       touch_wq_lockdep_map+0xcb/0x180 kernel/workqueue.c:4033
       __flush_workqueue+0x14b/0x14f0 kernel/workqueue.c:4075
       drain_workqueue+0xd3/0x390 kernel/workqueue.c:4239
       __loop_clr_fd drivers/block/loop.c:1130 [inline]
       lo_release+0x287/0x8f0 drivers/block/loop.c:1767
       bdev_release+0x541/0x660 block/bdev.c:-1
       blkdev_release+0x15/0x20 block/fops.c:705
       __fput+0x461/0xa70 fs/file_table.c:510
       fput_close_sync+0x11f/0x240 fs/file_table.c:615
       __do_sys_close fs/open.c:1511 [inline]
       __se_sys_close fs/open.c:1496 [inline]
       __x64_sys_close+0x7e/0x110 fs/open.c:1496
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #5 (&disk->open_mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
       mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
       __del_gendisk+0x127/0x980 block/genhd.c:710
       del_gendisk+0xe7/0x160 block/genhd.c:823
       nbd_dev_remove drivers/block/nbd.c:268 [inline]
       nbd_dev_remove_work+0x47/0xe0 drivers/block/nbd.c:284
       process_one_work+0x98b/0x1630 kernel/workqueue.c:3318
       process_scheduled_works kernel/workqueue.c:3401 [inline]
       worker_thread+0xb49/0x1140 kernel/workqueue.c:3482
       kthread+0x388/0x470 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #4 (&set->update_nr_hwq_lock){++++}-{4:4}:
       down_read+0x97/0x200 kernel/locking/rwsem.c:1568
       add_disk_fwnode+0xe7/0x480 block/genhd.c:596
       add_disk include/linux/blkdev.h:794 [inline]
       nbd_dev_add+0x72c/0xb50 drivers/block/nbd.c:1984
       nbd_genl_connect+0x965/0x1c80 drivers/block/nbd.c:2125
       genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1114
       genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
       genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1209
       netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2551
       genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x780/0x920 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1895
       sock_sendmsg_nosec+0x112/0x150 net/socket.c:797
       __sock_sendmsg net/socket.c:812 [inline]
       ____sys_sendmsg+0x55c/0x870 net/socket.c:2716
       ___sys_sendmsg+0x2a5/0x360 net/socket.c:2770
       __sys_sendmsg net/socket.c:2802 [inline]
       __do_sys_sendmsg net/socket.c:2807 [inline]
       __se_sys_sendmsg net/socket.c:2805 [inline]
       __x64_sys_sendmsg+0x1c3/0x2a0 net/socket.c:2805
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #3 (genl_mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
       mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
       genl_lock net/netlink/genetlink.c:35 [inline]
       genl_lock_all net/netlink/genetlink.c:48 [inline]
       genl_register_family+0x7b9/0x17b0 net/netlink/genetlink.c:784
       vdpa_init+0x39/0x70 drivers/vdpa/vdpa.c:1565
       do_one_initcall+0x250/0x870 init/main.c:1347
       do_initcall_level+0x104/0x190 init/main.c:1409
       do_initcalls+0x59/0xa0 init/main.c:1425
       kernel_init_freeable+0x2a6/0x3e0 init/main.c:1658
       kernel_init+0x1d/0x1d0 init/main.c:1548
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (cb_lock){++++}-{4:4}:
       down_read+0x97/0x200 kernel/locking/rwsem.c:1568
       genl_rcv+0x19/0x40 net/netlink/genetlink.c:1217
       netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
       netlink_unicast+0x780/0x920 net/netlink/af_netlink.c:1345
       netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1895
       sock_sendmsg_nosec+0x112/0x150 net/socket.c:797
       __sock_sendmsg net/socket.c:812 [inline]
       sock_sendmsg+0x1ca/0x2d0 net/socket.c:835
       splice_to_socket+0xae5/0x11f0 fs/splice.c:884
       do_splice_from fs/splice.c:936 [inline]
       do_splice+0xef8/0x1940 fs/splice.c:1349
       __do_splice fs/splice.c:1431 [inline]
       __do_sys_splice fs/splice.c:1634 [inline]
       __se_sys_splice+0x353/0x490 fs/splice.c:1616
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&pipe->mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
       mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
       iter_file_splice_write+0x1f3/0x10f0 fs/splice.c:682
       do_splice_from fs/splice.c:936 [inline]
       do_splice+0xef8/0x1940 fs/splice.c:1349
       __do_splice fs/splice.c:1431 [inline]
       __do_sys_splice fs/splice.c:1634 [inline]
       __se_sys_splice+0x353/0x490 fs/splice.c:1616
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (sb_writers#5){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3167 [inline]
       check_prevs_add kernel/locking/lockdep.c:3286 [inline]
       validate_chain kernel/locking/lockdep.c:3910 [inline]
       __lock_acquire+0x15a5/0x2d10 kernel/locking/lockdep.c:5239
       lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5870
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
       __sb_start_write include/linux/fs/super.h:19 [inline]
       sb_start_write include/linux/fs/super.h:125 [inline]
       kiocb_start_write include/linux/fs.h:2767 [inline]
       lo_rw_aio+0xb1b/0xf00 drivers/block/loop.c:401
       do_req_filebacked drivers/block/loop.c:433 [inline]
       loop_handle_cmd drivers/block/loop.c:1941 [inline]
       loop_process_work+0x637/0x11b0 drivers/block/loop.c:1976
       process_one_work+0x98b/0x1630 kernel/workqueue.c:3318
       process_scheduled_works kernel/workqueue.c:3401 [inline]
       worker_thread+0xb49/0x1140 kernel/workqueue.c:3482
       kthread+0x388/0x470 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  sb_writers#5 --> (wq_completion)loop4 --> (work_completion)(&worker->work)

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock((work_completion)(&worker->work));
                               lock((wq_completion)loop4);
                               lock((work_completion)(&worker->work));
  rlock(sb_writers#5);

 *** DEADLOCK ***
