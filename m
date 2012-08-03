Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60383 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2HCHLc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2012 03:11:32 -0400
Received: by yhmm54 with SMTP id m54so457159yhm.19
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Aug 2012 00:11:32 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Aug 2012 09:11:31 +0200
Message-ID: <CAB9VWqBANPS9eQ6reVDBsE-cssp_sEPK2aDAXyQHLtHkBXV_BA@mail.gmail.com>
Subject: wait_for_more_refs not waking up
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I got a deadlock happening while creating a snapshot and ordered
writes are pending. I can reproduce it 100% using btrfs send/receive.
It happens when I receive a set of streams on a freshly created FS. I
think I can exclude send/receive as the source of the problem as it
happens while receiving, even when rebooting between send and receive.
Receive does not depend on any extra kernel support and only uses
normal vfs syscalls.

I tried to bisect and found that reverting commit cf874d73 "Btrfs:
hooks for qgroup to record delayed refs" avoids the deadlock. I can
however not see why it does so. Reverting only parts of the commit
either changes nothing or triggers BUGs in quota code due to wrong
accounting.

>From my debugging so far, I see that one btrfs-endio-writer thread is
hanging in wait_for_more_refs. It either never wakes up or the
condition never gets true.
The snapshot ioctl is hanging in btrfs_start_ordered_extent, waiting
for BTRFS_ORDERED_COMPLETE. This flag should be triggered by
btrfs_remove_ordered_extent, which is called by
btrfs_finish_ordered_io. This function is queued into the worker
threads by btrfs_writepage_end_io_hook. I added a lot of debugging
into this and found out that the call to btrfs_finish_ordered_io is
queued correctly, but never gets processed. I suspect that the worker
threads are busy waiting (wait_for_more_refs?) and thus unable to
process it.

Having "Btrfs: barrier before waitqueue_active V2" applied does not
change anything here. I found a place where a wakeup is probably
missing: btrfs_get_tree_mod_seq. If I add a wakeup there, behavior
changes and I get the deadlock some received snapshots later (but not
always).

I tried to understand when a wakeup should occur and I'm not sure if
the way it is implemented currently is reliable. The wait statement in
wait_for_more_refs is:

        wait_event(fs_info->tree_mod_seq_wait,
                   num_refs != delayed_refs->num_entries ||
                   fs_info->tree_mod_seq_list.next != first_seq);

I see some possible problems here:
1. update_existing_ref is not changing num_entries in all cases, so
the wait condition does not get true. Not sure if this is important as
I don't even know what wait_for_more_refs is waiting for. Also, what
happens if an entry gets deleted and a new one added immediately? Will
num_entries stay the same?
2. What happens if an entry in tree_mod_seq_list is removed+freed and
immediately after that a new entry is allocated and added. May it
happen that the newly allocated ref lies at the same place in memory?
If yes, the condition will stay false in that case.
3. btrfs_get_tree_mod_seq is adding new elements to the tail, but the
condition is checking for changes to the head.
4. btrfs_put_tree_mod_seq is deleting entries from the middle of
tree_mod_seq_list. I see the same problems as with 3. here.

[  136.389129] btrfs-worker-1  S 0000000000000000  6576  2612      2 0x00000000
[  136.389129]  ffff88001e0bfd40 0000000000000046 ffff88001f957000
ffff88001e0bffd8
[  136.389129]  ffff88001e0bffd8 ffff88001e0bffd8 ffff88001f826000
ffff88001f957000
[  136.389129]  0000000000000286 ffff88001e0bfd80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-genwork-1 S 0000000000000000  6576  2613      2 0x00000000
[  136.389129]  ffff88001e2c1d40 0000000000000046 ffff88001fa05000
ffff88001e2c1fd8
[  136.389129]  ffff88001e2c1fd8 ffff88001e2c1fd8 ffff88001f957000
ffff88001fa05000
[  136.389129]  0000000000000286 ffff88001e2c1d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-submit-1  S 0000000000000000  6576  2614      2 0x00000000
[  136.389129]  ffff88001d511d40 0000000000000046 ffff88001d4a5000
ffff88001d511fd8
[  136.389129]  ffff88001d511fd8 ffff88001d511fd8 ffff88001e0f2000
ffff88001d4a5000
[  136.389129]  0000000000000286 ffff88001d511d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-delalloc- S 0000000000000000  6576  2615      2 0x00000000
[  136.389129]  ffff88001e2cbd40 0000000000000046 ffff88001e362000
ffff88001e2cbfd8
[  136.389129]  ffff88001e2cbfd8 ffff88001e2cbfd8 ffff88001e0f3000
ffff88001e362000
[  136.389129]  0000000000000286 ffff88001e2cbd80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-fixup-1   S 0000000000000000  6576  2616      2 0x00000000
[  136.389129]  ffff88001d4a9d40 0000000000000046 ffff88001fa1a000
ffff88001d4a9fd8
[  136.389129]  ffff88001d4a9fd8 ffff88001d4a9fd8 ffff88001d4a5000
ffff88001fa1a000
[  136.389129]  0000000000000286 ffff88001d4a9d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-endio-1   S 0000000000000000  6576  2617      2 0x00000000
[  136.389129]  ffff88001e04dd40 0000000000000046 ffff88001e1a8000
ffff88001e04dfd8
[  136.389129]  ffff88001e04dfd8 ffff88001e04dfd8 ffff88001e0f4000
ffff88001e1a8000
[  136.389129]  0000000000000286 ffff88001e04dd80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-endio-met S 0000000000000000  6024  2618      2 0x00000000
[  136.389129]  ffff88001e029d40 0000000000000046 ffff88001e0f0000
ffff88001e029fd8
[  136.389129]  ffff88001e029fd8 ffff88001e029fd8 ffffffff81e13440
ffff88001e0f0000
[  136.389129]  0000000000000286 ffff88001e029d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-endio-met S 0000000000000000  6576  2619      2 0x00000000
[  136.389129]  ffff88001e115d40 0000000000000046 ffff88001e0f1000
ffff88001e115fd8
[  136.389129]  ffff88001e115fd8 ffff88001e115fd8 ffff88001e0f5000
ffff88001e0f1000
[  136.389129]  0000000000000286 ffff88001e115d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-endio-wri S 0000000000000000  6576  2620      2 0x00000000
[  136.389129]  ffff88001d505d40 0000000000000046 ffff88001e0f2000
ffff88001d505fd8
[  136.389129]  ffff88001d505fd8 ffff88001d505fd8 ffff88001fa05000
ffff88001e0f2000
[  136.389129]  0000000000000286 ffff88001d505d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-freespace S 0000000000000000  6576  2621      2 0x00000000
[  136.389129]  ffff88001d4f9d40 0000000000000046 ffff88001e0f3000
ffff88001d4f9fd8
[  136.389129]  ffff88001d4f9fd8 ffff88001d4f9fd8 ffff88001fa1a000
ffff88001e0f3000
[  136.389129]  0000000000000286 ffff88001d4f9d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-delayed-m S 0000000000000000  6576  2622      2 0x00000000
[  136.389129]  ffff88001d4d1d40 0000000000000046 ffff88001e0f4000
ffff88001d4d1fd8
[  136.389129]  ffff88001d4d1fd8 ffff88001d4d1fd8 ffff88001e0f1000
ffff88001e0f4000
[  136.389129]  0000000000000286 ffff88001d4d1d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-cache-1   S 0000000000000000  6576  2623      2 0x00000000
[  136.389129]  ffff88001d7d3d40 0000000000000046 ffff88001e0f5000
ffff88001d7d3fd8
[  136.389129]  ffff88001d7d3fd8 ffff88001d7d3fd8 ffff88001e362000
ffff88001e0f5000
[  136.389129]  0000000000000286 ffff88001d7d3d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-readahead S 0000000000000000  6576  2624      2 0x00000000
[  136.389129]  ffff88001c979d40 0000000000000046 ffff88001e0f6000
ffff88001c979fd8
[  136.389129]  ffff88001c979fd8 ffff88001c979fd8 ffffffff81e13440
ffff88001e0f6000
[  136.389129]  0000000000000286 ffff88001c979d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-cleaner   S 0000000000000000  6520  2625      2 0x00000000
[  136.389129]  ffff88001c8d9e50 0000000000000046 ffff88001e0f7000
ffff88001c8d9fd8
[  136.389129]  ffff88001c8d9fd8 ffff88001c8d9fd8 ffffffff81e13440
ffff88001e0f7000
[  136.389129]  ffff88001c8d9e50 ffff88001e0f7000 ffff88001f96d000
ffffffff812bee58
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff812bee58>] ? end_workqueue_fn+0x80/0x80
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff812bef31>] cleaner_kthread+0xd9/0x10a
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-transacti S 0000000000000000  6608  2626      2 0x00000000
[  136.389129]  ffff88001e195d60 0000000000000046 ffff88001fa03000
ffff88001e195fd8
[  136.389129]  ffff88001e195fd8 ffff88001e195fd8 ffff88001e0f7000
ffff88001fa03000
[  136.389129]  0000000000000282 ffff88001e195da0 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff812bef62>] ? cleaner_kthread+0x10a/0x10a
[  136.389129]  [<ffffffff812bf17a>] transaction_kthread+0x218/0x249
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-worker-1  S 0000000000000000  5328  2628      2 0x00000000
[  136.389129]  ffff88001e1f9d40 0000000000000046 ffff88001e342000
ffff88001e1f9fd8
[  136.389129]  ffff88001e1f9fd8 ffff88001e1f9fd8 ffff88001b149000
ffff88001e342000
[  136.389129]  0000000000000286 ffff88001e1f9d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-genwork-1 S 0000000000000000  6064  2629      2 0x00000000
[  136.389129]  ffff88001c80fd40 0000000000000046 ffff88001e343000
ffff88001c80ffd8
[  136.389129]  ffff88001c80ffd8 ffff88001c80ffd8 ffff88000f5a0000
ffff88001e343000
[  136.389129]  0000000000000286 ffff88001c80fd80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-submit-1  S 0000000000000000  5264  2630      2 0x00000000
[  136.389129]  ffff88001d7d9d40 0000000000000046 ffff88001e344000
ffff88001d7d9fd8
[  136.389129]  ffff88001d7d9fd8 ffff88001d7d9fd8 ffff88001e342000
ffff88001e344000
[  136.389129]  0000000000000286 ffff88001d7d9d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-delalloc- S 0000000000000000  6576  2631      2 0x00000000
[  136.389129]  ffff88001c973d40 0000000000000046 ffff88001e345000
ffff88001c973fd8
[  136.389129]  ffff88001c973fd8 ffff88001c973fd8 ffffffff81e13440
ffff88001e345000
[  136.389129]  0000000000000286 ffff88001c973d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-fixup-1   S 0000000000000000  6576  2632      2 0x00000000
[  136.389129]  ffff88001d7ffd40 0000000000000046 ffff88001e346000
ffff88001d7fffd8
[  136.389129]  ffff88001d7fffd8 ffff88001d7fffd8 ffff88001e345000
ffff88001e346000
[  136.389129]  0000000000000286 ffff88001d7ffd80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-endio-1   S 0000000000000000  6576  2633      2 0x00000000
[  136.389129]  ffff88001c975d40 0000000000000046 ffff88001e347000
ffff88001c975fd8
[  136.389129]  ffff88001c975fd8 ffff88001c975fd8 ffff88001e346000
ffff88001e347000
[  136.389129]  0000000000000286 ffff88001c975d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-endio-met S 0000000000000000  6192  2634      2 0x00000000
[  136.389129]  ffff88001d763d40 0000000000000046 ffff88001d768000
ffff88001d763fd8
[  136.389129]  ffff88001d763fd8 ffff88001d763fd8 ffff88001e302000
ffff88001d768000
[  136.389129]  0000000000000286 ffff88001d763d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-endio-met S 0000000000000000  6576  2635      2 0x00000000
[  136.389129]  ffff88001d755d40 0000000000000046 ffff88001d769000
ffff88001d755fd8
[  136.389129]  ffff88001d755fd8 ffff88001d755fd8 ffff88001d76e000
ffff88001d769000
[  136.389129]  0000000000000286 ffff88001d755d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-endio-wri D 0000000000000000  3456  2636      2 0x00000000
[  136.389129]  ffff88001e061b20 0000000000000046 ffff88001d76a000
ffff88001e061fd8
[  136.389129]  ffff88001e061fd8 ffff88001e061fd8 ffffffff81e13440
ffff88001d76a000
[  136.389129]  ffff88001e061b30 ffff88001d76a000 0000000000e1a000
ffffffff81303fe6
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff812a2efb>] wait_for_more_refs+0x10c/0x166
[  136.389129]  [<ffffffff8105e7d0>] ? __init_waitqueue_head+0x60/0x60
[  136.389129]  [<ffffffff812a328c>] btrfs_run_delayed_refs+0x211/0x415
[  136.389129]  [<ffffffff812c66c8>] __btrfs_end_transaction+0x176/0x3ee
[  136.389129]  [<ffffffff812a6bc9>] ? btrfs_block_rsv_release+0x7a/0x7c
[  136.389129]  [<ffffffff812c696a>] btrfs_end_transaction+0x2a/0x3f
[  136.389129]  [<ffffffff812d0396>] btrfs_finish_ordered_io+0x651/0x6d7
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff812d044a>] finish_ordered_fn+0x2e/0x30
[  136.389129]  [<ffffffff81304090>] worker_loop+0xaa/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-freespace S 0000000000000000  5640  2637      2 0x00000000
[  136.389129]  ffff88001c891d40 0000000000000046 ffff88001d76b000
ffff88001c891fd8
[  136.389129]  ffff88001c891fd8 ffff88001c891fd8 ffff88001e302000
ffff88001d76b000
[  136.389129]  0000000000000286 ffff88001c891d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-delayed-m S 0000000000000000  4096  2638      2 0x00000000
[  136.389129]  ffff88001c8efd40 0000000000000046 ffff88001d76c000
ffff88001c8effd8
[  136.389129]  ffff88001c8effd8 ffff88001c8effd8 ffff88001e302000
ffff88001d76c000
[  136.389129]  0000000000000286 ffff88001c8efd80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-cache-1   S 0000000000000000  6248  2639      2 0x00000000
[  136.389129]  ffff88001c86dd40 0000000000000046 ffff88001d76d000
ffff88001c86dfd8
[  136.389129]  ffff88001c86dfd8 ffff88001c86dfd8 ffff88001f826000
ffff88001d76d000
[  136.389129]  0000000000000286 ffff88001c86dd80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-readahead S 0000000000000000  6576  2640      2 0x00000000
[  136.389129]  ffff88001d7b9d40 0000000000000046 ffff88001d76e000
ffff88001d7b9fd8
[  136.389129]  ffff88001d7b9fd8 ffff88001d7b9fd8 ffff88001e347000
ffff88001d76e000
[  136.389129]  0000000000000286 ffff88001d7b9d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-cleaner   S 0000000000000000  6784  2641      2 0x00000000
[  136.389129]  ffff88001c8f5e50 0000000000000046 ffff88001d76f000
ffff88001c8f5fd8
[  136.389129]  ffff88001c8f5fd8 ffff88001c8f5fd8 ffffffff81e13440
ffff88001d76f000
[  136.389129]  ffff88001c8f5e50 ffff88001d76f000 ffff88001e356000
ffffffff812bee58
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff812bee58>] ? end_workqueue_fn+0x80/0x80
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff812bef31>] cleaner_kthread+0xd9/0x10a
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-transacti D 0000000000000000  3192  2642      2 0x00000000
[  136.389129]  ffff88001d6b5c00 0000000000000046 ffff88001e341000
ffff88001d6b5fd8
[  136.389129]  ffff88001d6b5fd8 ffff88001d6b5fd8 ffffffff81e13440
ffff88001e341000
[  136.389129]  ffff88001d6b5c10 ffff88001e341000 ffff88001e356000
ffffffff812bef62
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff812bef62>] ? cleaner_kthread+0x10a/0x10a
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff812a2efb>] wait_for_more_refs+0x10c/0x166
[  136.389129]  [<ffffffff8105e7d0>] ? __init_waitqueue_head+0x60/0x60
[  136.389129]  [<ffffffff812a328c>] btrfs_run_delayed_refs+0x211/0x415
[  136.389129]  [<ffffffff818688a9>] ? mutex_unlock+0x9/0x10
[  136.389129]  [<ffffffff812e7b7d>] ? btrfs_run_ordered_operations+0x1fb/0x202
[  136.389129]  [<ffffffff812c84d7>] btrfs_commit_transaction+0x12f/0xe7e
[  136.389129]  [<ffffffff812c4db7>] ? sb_start_intwrite+0x22/0x24
[  136.389129]  [<ffffffff8105e7d0>] ? __init_waitqueue_head+0x60/0x60
[  136.389129]  [<ffffffff812bf0c9>] transaction_kthread+0x167/0x249
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] flush-8:32      S 0000000000000000  6032  2644      2 0x00000000
[  136.389129]  ffff88001e217e30 0000000000000046 ffff88001e303000
ffff88001e217fd8
[  136.389129]  ffff88001e217fd8 ffff88001e217fd8 ffff88001e302000
ffff88001e303000
[  136.389129]  0000000000000000 0000000000000000 ffff88001e303000
ffff88001e651970
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff8115eac5>] bdi_writeback_thread+0x155/0x230
[  136.389129]  [<ffffffff8115e970>] ? wb_do_writeback+0x1f0/0x1f0
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] flush-btrfs-2   S 0000000000000000  1600  2645      2 0x00000000
[  136.389129]  ffff88001e17fd70 0000000000000046 ffff88001e305000
ffff88001e17ffd8
[  136.389129]  ffff88001e17ffd8 ffff88001e17ffd8 ffffffff81e13440
ffff88001e305000
[  136.389129]  0000000000000286 ffff88001e17fdb0 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff8115ead9>] bdi_writeback_thread+0x169/0x230
[  136.389129]  [<ffffffff8115e970>] ? wb_do_writeback+0x1f0/0x1f0
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-worker-2  S 0000000000000000  5328  2646      2 0x00000000
[  136.389129]  ffff88001e0a3d40 0000000000000046 ffff88001e1ba000
ffff88001e0a3fd8
[  136.389129]  ffff88001e0a3fd8 ffff88001e0a3fd8 ffff88001e342000
ffff88001e1ba000
[  136.389129]  0000000000000286 ffff88001e0a3d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-endio-wri S 0000000000000000  3496  2647      2 0x00000000
[  136.389129]  ffff88001e385d40 0000000000000046 ffff88001d4f5000
ffff88001e385fd8
[  136.389129]  ffff88001e385fd8 ffff88001e385fd8 ffff88001d76a000
ffff88001d4f5000
[  136.389129]  0000000000000286 ffff88001e385d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-endio-wri S 0000000000000000  3888  2648      2 0x00000000
[  136.389129]  ffff88001e3bfd40 0000000000000046 ffff88001c852000
ffff88001e3bffd8
[  136.389129]  ffff88001e3bffd8 ffff88001e3bffd8 ffff88001d76a000
ffff88001c852000
[  136.389129]  0000000000000286 ffff88001e3bfd80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-worker-3  S 0000000000000000  5712  2649      2 0x00000000
[  136.389129]  ffff88001b6cbd40 0000000000000046 ffff88001e00b000
ffff88001b6cbfd8
[  136.389129]  ffff88001b6cbfd8 ffff88001b6cbfd8 ffff88001e344000
ffff88001e00b000
[  136.389129]  0000000000000286 ffff88001b6cbd80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-delayed-m S 0000000000000000  5680  2650      2 0x00000000
[  136.389129]  ffff880016223d40 0000000000000046 ffff88001e20d000
ffff880016223fd8
[  136.389129]  ffff880016223fd8 ffff880016223fd8 ffff88001e302000
ffff88001e20d000
[  136.389129]  0000000000000286 ffff880016223d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs-delayed-m S 0000000000000000  4416  2651      2 0x00000000
[  136.389129]  ffff880006599d40 0000000000000046 ffff88000f5a0000
ffff880006599fd8
[  136.389129]  ffff880006599fd8 ffff880006599fd8 ffff88001e302000
ffff88000f5a0000
[  136.389129]  0000000000000286 ffff880006599d80 ffffffff81fe2e00
ffffffff81fe2e00
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff818674ca>] schedule_timeout+0x13a/0x230
[  136.389129]  [<ffffffff81049a20>] ? usleep_range+0x40/0x40
[  136.389129]  [<ffffffff81303fe6>] ? get_next_work+0x12c/0x12c
[  136.389129]  [<ffffffff813042b7>] worker_loop+0x2d1/0x333
[  136.389129]  [<ffffffff8105ddce>] kthread+0x8e/0xa0
[  136.389129]  [<ffffffff818738a4>] kernel_thread_helper+0x4/0x10
[  136.389129]  [<ffffffff8186af19>] ? retint_restore_args+0xe/0xe
[  136.389129]  [<ffffffff8105dd40>] ? __init_kthread_worker+0x70/0x70
[  136.389129]  [<ffffffff818738a0>] ? gs_change+0xb/0xb
[  136.389129] btrfs           D 0000000000000003  2536  2652   2564 0x00000000
[  136.389129]  ffff880013f3ba38 0000000000000046 ffff88001b149000
ffff880013f3bfd8
[  136.389129]  ffff880013f3bfd8 ffff880013f3bfd8 ffff88001d76a000
ffff88001b149000
[  136.389129]  ffff880013f3ba48 0000000000000000 0000000000000003
ffff88001dc25a60
[  136.389129] Call Trace:
[  136.389129]  [<ffffffff81869934>] schedule+0x24/0x70
[  136.389129]  [<ffffffff812e7d88>] btrfs_start_ordered_extent+0x204/0x22a
[  136.389129]  [<ffffffff8105e7d0>] ? __init_waitqueue_head+0x60/0x60
[  136.389129]  [<ffffffff812e78fb>] btrfs_wait_ordered_extents+0x1ef/0x276
[  136.389129]  [<ffffffff8105e7d0>] ? __init_waitqueue_head+0x60/0x60
[  136.389129]  [<ffffffff812c8814>] btrfs_commit_transaction+0x46c/0xe7e
[  136.389129]  [<ffffffff8105e7d0>] ? __init_waitqueue_head+0x60/0x60
[  136.389129]  [<ffffffff81304fed>] ? spin_unlock+0x18/0x1a
[  136.389129]  [<ffffffff81307700>] create_snapshot+0x1cb/0x290
[  136.389129]  [<ffffffff81307afd>] ? btrfs_mksubvol+0xe6/0x1d5
[  136.389129]  [<ffffffff81307b4b>] btrfs_mksubvol+0x134/0x1d5
[  136.389129]  [<ffffffff81135340>] ? fget_raw+0xd0/0xd0
[  136.389129]  [<ffffffff813097d1>] btrfs_ioctl_snap_create_transid+0x194/0x1bc
[  136.389129]  [<ffffffff813099f3>] btrfs_ioctl_snap_create_v2+0x15f/0x1cd
[  136.389129]  [<ffffffff81367931>] ? avc_has_perm_flags+0x101/0x1a0
[  136.389129]  [<ffffffff8130ef89>] btrfs_ioctl+0x390/0x75f
[  136.389129]  [<ffffffff811466e7>] do_vfs_ioctl+0x97/0x580
[  136.389129]  [<ffffffff81368675>] ?
inode_has_perm.isra.27.constprop.67+0x25/0x30
[  136.389129]  [<ffffffff8136905f>] ? file_has_perm+0x8f/0xa0
[  136.389129]  [<ffffffff81872747>] ? sysret_check+0x1b/0x56
[  136.389129]  [<ffffffff81146c69>] sys_ioctl+0x99/0xa0
[  136.389129]  [<ffffffff81872722>] system_call_fastpath+0x16/0x1b
[  136.389129]
[  136.389129] Showing all locks held in the system:
[  136.389129] 1 lock held by getty/2557:
[  136.389129]  #0:  (&tty->atomic_read_lock){+.+...}, at:
[<ffffffff81439de0>] n_tty_read+0x5c0/0x890
[  136.389129] 1 lock held by getty/2558:
[  136.389129]  #0:  (&tty->atomic_read_lock){+.+...}, at:
[<ffffffff81439de0>] n_tty_read+0x5c0/0x890
[  136.389129] 1 lock held by getty/2559:
[  136.389129]  #0:  (&tty->atomic_read_lock){+.+...}, at:
[<ffffffff81439de0>] n_tty_read+0x5c0/0x890
[  136.389129] 1 lock held by getty/2560:
[  136.389129]  #0:  (&tty->atomic_read_lock){+.+...}, at:
[<ffffffff81439de0>] n_tty_read+0x5c0/0x890
[  136.389129] 1 lock held by getty/2561:
[  136.389129]  #0:  (&tty->atomic_read_lock){+.+...}, at:
[<ffffffff81439de0>] n_tty_read+0x5c0/0x890
[  136.389129] 1 lock held by getty/2562:
[  136.389129]  #0:  (&tty->atomic_read_lock){+.+...}, at:
[<ffffffff81439de0>] n_tty_read+0x5c0/0x890
[  136.389129] 1 lock held by btrfs-endio-wri/2636:
[  136.389129]  #0:  (sb_internal){.+.+..}, at: [<ffffffff812c4db7>]
sb_start_intwrite+0x22/0x24
[  136.389129] 2 locks held by btrfs-transacti/2642:
[  136.389129]  #0:  (&fs_info->transaction_kthread_mutex){+.+...},
at: [<ffffffff812befa1>] transaction_kthread+0x3f/0x249
[  136.389129]  #1:  (sb_internal){.+.+..}, at: [<ffffffff812c4db7>]
sb_start_intwrite+0x22/0x24
[  136.389129] 4 locks held by btrfs/2652:
[  136.389129]  #0:  (sb_writers#9){.+.+.+}, at: [<ffffffff81152b43>]
mnt_want_write_file+0x23/0x50
[  136.389129]  #1:  (&type->i_mutex_dir_key#4/1){+.+.+.}, at:
[<ffffffff81307a5f>] btrfs_mksubvol+0x48/0x1d5
[  136.389129]  #2:  (&fs_info->subvol_sem){+++++.}, at:
[<ffffffff81307afd>] btrfs_mksubvol+0xe6/0x1d5
[  136.389129]  #3:  (sb_internal){.+.+..}, at: [<ffffffff812c4db7>]
sb_start_intwrite+0x22/0x24
[  136.389129]
[  136.389129] =============================================
[  136.389129]
