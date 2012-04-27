From: Daniel J Blueman <daniel@quora.org>
Subject: worker list corruption crash
Date: Fri, 27 Apr 2012 10:26:27 +0800
Message-ID: <CAMVG2ssoaPFDj9cBtBByE4xXuENYo=SXipgP=XxrXKmqaK=78w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In 3.4-rc4, I've come across worker list corruption while scrubbing,
leading to (in two separate cases) warning [1] and crashing [2]. The
connection with scrubbing is likely the increased rate of worker
threads starting and stopping.

In btrfs_stop_workers, access to worker->worker_list is done without
holding worker->lock (it is in all other callsites). We can't take
worker->lock there due to lock inversion deadlock (as it is the outer
lock), and if we drop the workers->lock to acquire worker->lock and
then workers->lock, we can't guarantee worker is still valid.

If feels like a global workers list pointer should be used and it's
lock should be the outer one to avoid this scenario, or maybe I'm
missing something?

Daniel

--- [1]

WARNING: at lib/list_debug.c:55 __list_del_entry+0xa1/0xd0()
Hardware name: Latitude E5420
list_del corruption. prev->next should be ffff88019cb3e268, but was
ffff88021af4f628
Pid: 5232, comm: btrfs-scrub-4 Not tainted 3.4.0-rc4-debug+ #1
Call Trace:
 [<ffffffff8103c54a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103c621>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff81229931>] __list_del_entry+0xa1/0xd0
 [<ffffffffa01087d5>] try_worker_shutdown+0x73/0xad [btrfs]
 [<ffffffffa00dfbff>] worker_loop+0x17f/0x330 [btrfs]
 [<ffffffffa00dfa80>] ? check_pending_worker_creates.isra.1+0xd0/0xd0 [btrfs]
 [<ffffffff8105d9ee>] kthread+0x8e/0xa0
 [<ffffffff815ae0d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff815ac799>] ? retint_restore_args+0xe/0xe
 [<ffffffff8105d960>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff815ae0d0>] ? gs_change+0xb/0xb

(gdb) list *(try_worker_shutdown+0x73)
0x7e854 is in try_worker_shutdown (fs/btrfs/async-thread.c:241).
warning: Source file is more recent than executable.
236		    atomic_read(&worker->num_pending) == 0) {
237			freeit = 1;
238			list_del_init(&worker->worker_list);
239			worker->workers->num_workers--;
240		}
241		spin_unlock(&worker->workers->lock);
242		spin_unlock_irq(&worker->lock);
243	
244		if (freeit)
245			put_worker(worker);

--- [2]

BUG: unable to handle kernel paging request at ffffffff8157f529
IP: [<ffffffff8108dd2e>] __lock_acquire+0x1be/0x900
PGD 1a0d067 PUD 1a11063 PMD 14001e1
Oops: 0003 [#1] SMP
CPU 1
Pid: 2975, comm: btrfs-scrub-3 Tainted: G        W    3.4.0-rc4-debug+
#1 Dell Inc. Latitude E5420/0H5TG2
RIP: 0010:[<ffffffff8108dd2e>]  [<ffffffff8108dd2e>] __lock_acquire+0x1be/0x900
RSP: 0018:ffff8801ad747d00  EFLAGS: 00010082
RAX: ffffffff81110b08 RBX: ffff8801df242288 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8801df242288
RBP: ffff8801ad747d70 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000000 R11: ffff8801df39c190 R12: ffff8801df39bc00
R13: 0000000000000000 R14: 0000000000000002 R15: ffffffff8157f391
FS:  0000000000000000(0000) GS:ffff88022ec80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff8157f529 CR3: 0000000001a0b000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-scrub-3 (pid: 2975, threadinfo ffff8801ad746000, task
ffff8801df39bc00)
Stack:
 ffff8801ad747d20 0000000000000286 ffff8801ad747d80 ffffffff82577548
 ffff8801ad747d60 ffff8801df39c190 ffff880100000000 ffffffff8104a5ca
 ffff8801ad747d80 ffff8801df39bc00 0000000000000046 ffff880221cdde90
Call Trace:
 [<ffffffff8104a5ca>] ? del_timer_sync+0x8a/0xc0
 [<ffffffff8108e995>] lock_acquire+0x55/0x70
 [<ffffffffa010878b>] ? try_worker_shutdown+0x29/0xad [btrfs]
 [<ffffffff815abaac>] _raw_spin_lock+0x3c/0x50
 [<ffffffffa010878b>] ? try_worker_shutdown+0x29/0xad [btrfs]
 [<ffffffffa010878b>] try_worker_shutdown+0x29/0xad [btrfs]
 [<ffffffffa00dfbff>] worker_loop+0x17f/0x330 [btrfs]
 [<ffffffffa00dfa80>] ? check_pending_worker_creates.isra.1+0xd0/0xd0 [btrfs]
 [<ffffffff8105d9ee>] kthread+0x8e/0xa0
 [<ffffffff815ae0d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff815ac799>] ? retint_restore_args+0xe/0xe
 [<ffffffff8105d960>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff815ae0d0>] ? gs_change+0xb/0xb
Code: 00 48 c7 c7 50 30 7b 81 89 55 b0 e8 6d e8 fa ff 8b 55 b0 eb a8
0f 1f 84 00 00 00 00 00 4c 8b 7c d3 08 4d 85 ff 0f 84 c9 fe ff ff <f0>
41 ff 87 98 0$
RIP  [<ffffffff8108dd2e>] __lock_acquire+0x1be/0x900
 RSP <ffff8801ad747d00>
CR2: ffffffff8157f529

(gdb) list *(try_worker_shutdown+0x29)
0x7e80a is in try_worker_shutdown (fs/btrfs/async-thread.c:232).
227	
228		spin_lock_irq(&worker->lock);
229		spin_lock(&worker->workers->lock);
230		if (worker->workers->num_workers > 1 &&
231		    worker->idle &&
232		    !worker->working &&
233		    !list_empty(&worker->worker_list) &&
234		    list_empty(&worker->prio_pending) &&
235		    list_empty(&worker->pending) &&
236		    atomic_read(&worker->num_pending) == 0) {
-- 
Daniel J Blueman
