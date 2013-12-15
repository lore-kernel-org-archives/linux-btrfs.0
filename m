Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:36396 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab3LODmU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 22:42:20 -0500
Received: by mail-qe0-f50.google.com with SMTP id 1so2919434qec.37
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 19:42:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1387053647-25680-1-git-send-email-fdmanana@gmail.com>
References: <1387053647-25680-1-git-send-email-fdmanana@gmail.com>
Date: Sun, 15 Dec 2013 11:42:20 +0800
Message-ID: <CAP9B-Qmy55a_C+CCAsXuyqhnq8fRce00ZiOzxc+XWYaA2ufg-w@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix deadlock when iterating inode refs and running
 delayed inodes
From: Shilong Wang <wangshilong1991@gmail.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Filipe,

I mean no hurt, but your changelog is really too long.
I think pasting some of dmesg is ok...


Thanks,
Wang
2013/12/15 Filipe David Borba Manana <fdmanana@gmail.com>:
> While running btrfs/004 from xfstests, after 503 iterations, dmesg reported
> a deadlock between tasks iterating inode refs and tasks running delayed inodes
> (during a transaction commit).
>
> It turns out that iterating inode refs implies doing one tree search and
> release all nodes in the path except the leaf node, and then passing that
> leaf node to btrfs_ref_to_path(), which in turn does another tree search
> without releasing the lock on the leaf node it received as parameter.
>
> This is a problem when other task wants to write to the btree as well and
> ends up updating the leaf that is read locked - the writer task locks the
> parent of the leaf and then blocks waiting for the leaf's lock to be
> released - at the same time, the task executing btrfs_ref_to_path()
> does a second tree search, without releasing the lock on the first leaf,
> and wants to access a leaf (the same or another one) that is a child of
> the same parent, resulting in a deadlock.
>
> The trace reported by lockdep follows.
>
> [84314.936373] INFO: task fsstress:11930 blocked for more than 120 seconds.
> [84314.936381]       Tainted: G        W  O 3.12.0-fdm-btrfs-next-16+ #70
> [84314.936383] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [84314.936386] fsstress        D ffff8806e1bf8000     0 11930  11926 0x00000000
> [84314.936393]  ffff8804d6d89b78 0000000000000046 ffff8804d6d89b18 ffffffff810bd8bd
> [84314.936399]  ffff8806e1bf8000 ffff8804d6d89fd8 ffff8804d6d89fd8 ffff8804d6d89fd8
> [84314.936405]  ffff880806308000 ffff8806e1bf8000 ffff8804d6d89c08 ffff8804deb8f190
> [84314.936410] Call Trace:
> [84314.936421]  [<ffffffff810bd8bd>] ? trace_hardirqs_on+0xd/0x10
> [84314.936428]  [<ffffffff81774269>] schedule+0x29/0x70
> [84314.936451]  [<ffffffffa0715bf5>] btrfs_tree_lock+0x75/0x270 [btrfs]
> [84314.936457]  [<ffffffff810715c0>] ? __init_waitqueue_head+0x60/0x60
> [84314.936470]  [<ffffffffa06ba231>] btrfs_search_slot+0x7f1/0x930 [btrfs]
> [84314.936489]  [<ffffffffa0731c2a>] ? __btrfs_run_delayed_items+0x13a/0x1e0 [btrfs]
> [84314.936504]  [<ffffffffa06d2e1f>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
> [84314.936510]  [<ffffffff810bd6ef>] ? trace_hardirqs_on_caller+0x1f/0x1e0
> [84314.936528]  [<ffffffffa073173c>] __btrfs_update_delayed_inode+0x4c/0x1d0 [btrfs]
> [84314.936543]  [<ffffffffa0731c2a>] ? __btrfs_run_delayed_items+0x13a/0x1e0 [btrfs]
> [84314.936558]  [<ffffffffa0731c2a>] ? __btrfs_run_delayed_items+0x13a/0x1e0 [btrfs]
> [84314.936573]  [<ffffffffa0731c82>] __btrfs_run_delayed_items+0x192/0x1e0 [btrfs]
> [84314.936589]  [<ffffffffa0731d03>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
> [84314.936604]  [<ffffffffa06dbcd4>] btrfs_flush_all_pending_stuffs+0x24/0x80 [btrfs]
> [84314.936620]  [<ffffffffa06ddc13>] btrfs_commit_transaction+0x223/0xa20 [btrfs]
> [84314.936630]  [<ffffffffa06ae5ae>] btrfs_sync_fs+0x6e/0x110 [btrfs]
> [84314.936635]  [<ffffffff811d0b50>] ? __sync_filesystem+0x60/0x60
> [84314.936639]  [<ffffffff811d0b50>] ? __sync_filesystem+0x60/0x60
> [84314.936643]  [<ffffffff811d0b70>] sync_fs_one_sb+0x20/0x30
> [84314.936648]  [<ffffffff811a3541>] iterate_supers+0xf1/0x100
> [84314.936652]  [<ffffffff811d0c45>] sys_sync+0x55/0x90
> [84314.936658]  [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
> [84314.936660] INFO: lockdep is turned off.
> [84314.936663] INFO: task btrfs:11955 blocked for more than 120 seconds.
> [84314.936666]       Tainted: G        W  O 3.12.0-fdm-btrfs-next-16+ #70
> [84314.936668] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [84314.936670] btrfs           D ffff880541729a88     0 11955  11608 0x00000000
> [84314.936674]  ffff880541729a38 0000000000000046 ffff8805417299d8 ffffffff810bd8bd
> [84314.936680]  ffff88075430c8a0 ffff880541729fd8 ffff880541729fd8 ffff880541729fd8
> [84314.936685]  ffffffff81c104e0 ffff88075430c8a0 ffff8804de8b00b8 ffff8804de8b0000
> [84314.936690] Call Trace:
> [84314.936695]  [<ffffffff810bd8bd>] ? trace_hardirqs_on+0xd/0x10
> [84314.936700]  [<ffffffff81774269>] schedule+0x29/0x70
> [84314.936717]  [<ffffffffa0715815>] btrfs_tree_read_lock+0xd5/0x140 [btrfs]
> [84314.936721]  [<ffffffff810715c0>] ? __init_waitqueue_head+0x60/0x60
> [84314.936733]  [<ffffffffa06ba201>] btrfs_search_slot+0x7c1/0x930 [btrfs]
> [84314.936746]  [<ffffffffa06bd505>] btrfs_find_item+0x55/0x160 [btrfs]
> [84314.936763]  [<ffffffffa06ff689>] ? free_extent_buffer+0x49/0xc0 [btrfs]
> [84314.936780]  [<ffffffffa073c9ca>] btrfs_ref_to_path+0xba/0x1e0 [btrfs]
> [84314.936797]  [<ffffffffa06f9719>] ? release_extent_buffer+0xb9/0xe0 [btrfs]
> [84314.936813]  [<ffffffffa06ff689>] ? free_extent_buffer+0x49/0xc0 [btrfs]
> [84314.936830]  [<ffffffffa073cb50>] inode_to_path+0x60/0xd0 [btrfs]
> [84314.936846]  [<ffffffffa073d365>] paths_from_inode+0x115/0x3c0 [btrfs]
> [84314.936851]  [<ffffffff8118dd44>] ? kmem_cache_alloc_trace+0x114/0x200
> [84314.936868]  [<ffffffffa0714494>] btrfs_ioctl+0xf14/0x2030 [btrfs]
> [84314.936873]  [<ffffffff817762db>] ? _raw_spin_unlock+0x2b/0x50
> [84314.936877]  [<ffffffff8116598f>] ? handle_mm_fault+0x34f/0xb00
> [84314.936882]  [<ffffffff81075563>] ? up_read+0x23/0x40
> [84314.936886]  [<ffffffff8177a41c>] ? __do_page_fault+0x20c/0x5a0
> [84314.936892]  [<ffffffff811b2946>] do_vfs_ioctl+0x96/0x570
> [84314.936896]  [<ffffffff81776e23>] ? error_sti+0x5/0x6
> [84314.936901]  [<ffffffff810b71e8>] ? trace_hardirqs_off_caller+0x28/0xd0
> [84314.936906]  [<ffffffff81776a09>] ? retint_swapgs+0xe/0x13
> [84314.936910]  [<ffffffff811b2eb1>] SyS_ioctl+0x91/0xb0
> [84314.936915]  [<ffffffff813eecde>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [84314.936920]  [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
> [84314.936922] INFO: lockdep is turned off.
> [84434.866873] INFO: task btrfs-transacti:11921 blocked for more than 120 seconds.
> [84434.866881]       Tainted: G        W  O 3.12.0-fdm-btrfs-next-16+ #70
> [84434.866883] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [84434.866886] btrfs-transacti D ffff880755b6a478     0 11921      2 0x00000000
> [84434.866893]  ffff8800735b9ce8 0000000000000046 ffff8800735b9c88 ffffffff810bd8bd
> [84434.866899]  ffff8805a1b848a0 ffff8800735b9fd8 ffff8800735b9fd8 ffff8800735b9fd8
> [84434.866904]  ffffffff81c104e0 ffff8805a1b848a0 ffff880755b6a478 ffff8804cece78f0
> [84434.866910] Call Trace:
> [84434.866920]  [<ffffffff810bd8bd>] ? trace_hardirqs_on+0xd/0x10
> [84434.866927]  [<ffffffff81774269>] schedule+0x29/0x70
> [84434.866948]  [<ffffffffa06dd2ef>] wait_current_trans.isra.33+0xbf/0x120 [btrfs]
> [84434.866954]  [<ffffffff810715c0>] ? __init_waitqueue_head+0x60/0x60
> [84434.866970]  [<ffffffffa06dec18>] start_transaction+0x388/0x5a0 [btrfs]
> [84434.866985]  [<ffffffffa06db9b5>] ? transaction_kthread+0xb5/0x280 [btrfs]
> [84434.866999]  [<ffffffffa06dee97>] btrfs_attach_transaction+0x17/0x20 [btrfs]
> [84434.867012]  [<ffffffffa06dba9e>] transaction_kthread+0x19e/0x280 [btrfs]
> [84434.867026]  [<ffffffffa06db900>] ? open_ctree+0x2260/0x2260 [btrfs]
> [84434.867030]  [<ffffffff81070dad>] kthread+0xed/0x100
> [84434.867035]  [<ffffffff81070cc0>] ? flush_kthread_worker+0x190/0x190
> [84434.867040]  [<ffffffff8177ee6c>] ret_from_fork+0x7c/0xb0
> [84434.867044]  [<ffffffff81070cc0>] ? flush_kthread_worker+0x190/0x190
> [84434.867046] INFO: lockdep is turned off.
> [84434.867049] INFO: task fsstress:11930 blocked for more than 120 seconds.
> [84434.867052]       Tainted: G        W  O 3.12.0-fdm-btrfs-next-16+ #70
> [84434.867053] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [84434.867055] fsstress        D ffff8806e1bf8000     0 11930  11926 0x00000000
> [84434.867060]  ffff8804d6d89b78 0000000000000046 ffff8804d6d89b18 ffffffff810bd8bd
> [84434.867066]  ffff8806e1bf8000 ffff8804d6d89fd8 ffff8804d6d89fd8 ffff8804d6d89fd8
> [84434.867071]  ffff880806308000 ffff8806e1bf8000 ffff8804d6d89c08 ffff8804deb8f190
> [84434.867076] Call Trace:
> [84434.867081]  [<ffffffff810bd8bd>] ? trace_hardirqs_on+0xd/0x10
> [84434.867086]  [<ffffffff81774269>] schedule+0x29/0x70
> [84434.867104]  [<ffffffffa0715bf5>] btrfs_tree_lock+0x75/0x270 [btrfs]
> [84434.867108]  [<ffffffff810715c0>] ? __init_waitqueue_head+0x60/0x60
> [84434.867120]  [<ffffffffa06ba231>] btrfs_search_slot+0x7f1/0x930 [btrfs]
> [84434.867139]  [<ffffffffa0731c2a>] ? __btrfs_run_delayed_items+0x13a/0x1e0 [btrfs]
> [84434.867154]  [<ffffffffa06d2e1f>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
> [84434.867158]  [<ffffffff810bd6ef>] ? trace_hardirqs_on_caller+0x1f/0x1e0
> [84434.867176]  [<ffffffffa073173c>] __btrfs_update_delayed_inode+0x4c/0x1d0 [btrfs]
> [84434.867192]  [<ffffffffa0731c2a>] ? __btrfs_run_delayed_items+0x13a/0x1e0 [btrfs]
> [84434.867207]  [<ffffffffa0731c2a>] ? __btrfs_run_delayed_items+0x13a/0x1e0 [btrfs]
> [84434.867223]  [<ffffffffa0731c82>] __btrfs_run_delayed_items+0x192/0x1e0 [btrfs]
> [84434.867239]  [<ffffffffa0731d03>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
> [84434.867253]  [<ffffffffa06dbcd4>] btrfs_flush_all_pending_stuffs+0x24/0x80 [btrfs]
> [84434.867267]  [<ffffffffa06ddc13>] btrfs_commit_transaction+0x223/0xa20 [btrfs]
> [84434.867278]  [<ffffffffa06ae5ae>] btrfs_sync_fs+0x6e/0x110 [btrfs]
> [84434.867283]  [<ffffffff811d0b50>] ? __sync_filesystem+0x60/0x60
> [84434.867287]  [<ffffffff811d0b50>] ? __sync_filesystem+0x60/0x60
> [84434.867291]  [<ffffffff811d0b70>] sync_fs_one_sb+0x20/0x30
> [84434.867296]  [<ffffffff811a3541>] iterate_supers+0xf1/0x100
> [84434.867300]  [<ffffffff811d0c45>] sys_sync+0x55/0x90
> [84434.867304]  [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
> [84434.867307] INFO: lockdep is turned off.
> [84434.867309] INFO: task btrfs:11955 blocked for more than 120 seconds.
> [84434.867311]       Tainted: G        W  O 3.12.0-fdm-btrfs-next-16+ #70
> [84434.867313] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [84434.867315] btrfs           D ffff880541729a88     0 11955  11608 0x00000000
> [84434.867320]  ffff880541729a38 0000000000000046 ffff8805417299d8 ffffffff810bd8bd
> [84434.867325]  ffff88075430c8a0 ffff880541729fd8 ffff880541729fd8 ffff880541729fd8
> [84434.867330]  ffffffff81c104e0 ffff88075430c8a0 ffff8804de8b00b8 ffff8804de8b0000
> [84434.867335] Call Trace:
> [84434.867340]  [<ffffffff810bd8bd>] ? trace_hardirqs_on+0xd/0x10
> [84434.867344]  [<ffffffff81774269>] schedule+0x29/0x70
> [84434.867361]  [<ffffffffa0715815>] btrfs_tree_read_lock+0xd5/0x140 [btrfs]
> [84434.867365]  [<ffffffff810715c0>] ? __init_waitqueue_head+0x60/0x60
> [84434.867377]  [<ffffffffa06ba201>] btrfs_search_slot+0x7c1/0x930 [btrfs]
> [84434.867389]  [<ffffffffa06bd505>] btrfs_find_item+0x55/0x160 [btrfs]
> [84434.867406]  [<ffffffffa06ff689>] ? free_extent_buffer+0x49/0xc0 [btrfs]
> [84434.867423]  [<ffffffffa073c9ca>] btrfs_ref_to_path+0xba/0x1e0 [btrfs]
> [84434.867440]  [<ffffffffa06f9719>] ? release_extent_buffer+0xb9/0xe0 [btrfs]
> [84434.867456]  [<ffffffffa06ff689>] ? free_extent_buffer+0x49/0xc0 [btrfs]
> [84434.867473]  [<ffffffffa073cb50>] inode_to_path+0x60/0xd0 [btrfs]
> [84434.867488]  [<ffffffffa073d365>] paths_from_inode+0x115/0x3c0 [btrfs]
> [84434.867493]  [<ffffffff8118dd44>] ? kmem_cache_alloc_trace+0x114/0x200
> [84434.867510]  [<ffffffffa0714494>] btrfs_ioctl+0xf14/0x2030 [btrfs]
> [84434.867514]  [<ffffffff817762db>] ? _raw_spin_unlock+0x2b/0x50
> [84434.867519]  [<ffffffff8116598f>] ? handle_mm_fault+0x34f/0xb00
> [84434.867523]  [<ffffffff81075563>] ? up_read+0x23/0x40
> [84434.867528]  [<ffffffff8177a41c>] ? __do_page_fault+0x20c/0x5a0
> [84434.867533]  [<ffffffff811b2946>] do_vfs_ioctl+0x96/0x570
> [84434.867538]  [<ffffffff81776e23>] ? error_sti+0x5/0x6
> [84434.867543]  [<ffffffff810b71e8>] ? trace_hardirqs_off_caller+0x28/0xd0
> [84434.867547]  [<ffffffff81776a09>] ? retint_swapgs+0xe/0x13
> [84434.867552]  [<ffffffff811b2eb1>] SyS_ioctl+0x91/0xb0
> [84434.867557]  [<ffffffff813eecde>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [84434.867561]  [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
> [84434.867563] INFO: lockdep is turned off.
> [84554.797366] INFO: task btrfs-transacti:11921 blocked for more than 120 seconds.
> [84554.797373]       Tainted: G        W  O 3.12.0-fdm-btrfs-next-16+ #70
> [84554.797375] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [84554.797378] btrfs-transacti D ffff880755b6a478     0 11921      2 0x00000000
> [84554.797385]  ffff8800735b9ce8 0000000000000046 ffff8800735b9c88 ffffffff810bd8bd
> [84554.797391]  ffff8805a1b848a0 ffff8800735b9fd8 ffff8800735b9fd8 ffff8800735b9fd8
> [84554.797396]  ffffffff81c104e0 ffff8805a1b848a0 ffff880755b6a478 ffff8804cece78f0
> [84554.797402] Call Trace:
> [84554.797412]  [<ffffffff810bd8bd>] ? trace_hardirqs_on+0xd/0x10
> [84554.797418]  [<ffffffff81774269>] schedule+0x29/0x70
> [84554.797439]  [<ffffffffa06dd2ef>] wait_current_trans.isra.33+0xbf/0x120 [btrfs]
> [84554.797445]  [<ffffffff810715c0>] ? __init_waitqueue_head+0x60/0x60
> [84554.797461]  [<ffffffffa06dec18>] start_transaction+0x388/0x5a0 [btrfs]
> [84554.797476]  [<ffffffffa06db9b5>] ? transaction_kthread+0xb5/0x280 [btrfs]
> [84554.797490]  [<ffffffffa06dee97>] btrfs_attach_transaction+0x17/0x20 [btrfs]
> [84554.797504]  [<ffffffffa06dba9e>] transaction_kthread+0x19e/0x280 [btrfs]
> [84554.797517]  [<ffffffffa06db900>] ? open_ctree+0x2260/0x2260 [btrfs]
> [84554.797522]  [<ffffffff81070dad>] kthread+0xed/0x100
> [84554.797526]  [<ffffffff81070cc0>] ? flush_kthread_worker+0x190/0x190
> [84554.797532]  [<ffffffff8177ee6c>] ret_from_fork+0x7c/0xb0
> [84554.797536]  [<ffffffff81070cc0>] ? flush_kthread_worker+0x190/0x190
> [84554.797538] INFO: lockdep is turned off.
> [84554.797541] INFO: task fsstress:11930 blocked for more than 120 seconds.
> [84554.797544]       Tainted: G        W  O 3.12.0-fdm-btrfs-next-16+ #70
> [84554.797545] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [84554.797547] fsstress        D ffff8806e1bf8000     0 11930  11926 0x00000000
> [84554.797552]  ffff8804d6d89b78 0000000000000046 ffff8804d6d89b18 ffffffff810bd8bd
> [84554.797558]  ffff8806e1bf8000 ffff8804d6d89fd8 ffff8804d6d89fd8 ffff8804d6d89fd8
> [84554.797563]  ffff880806308000 ffff8806e1bf8000 ffff8804d6d89c08 ffff8804deb8f190
> [84554.797568] Call Trace:
> [84554.797573]  [<ffffffff810bd8bd>] ? trace_hardirqs_on+0xd/0x10
> [84554.797578]  [<ffffffff81774269>] schedule+0x29/0x70
> [84554.797596]  [<ffffffffa0715bf5>] btrfs_tree_lock+0x75/0x270 [btrfs]
> [84554.797601]  [<ffffffff810715c0>] ? __init_waitqueue_head+0x60/0x60
> [84554.797613]  [<ffffffffa06ba231>] btrfs_search_slot+0x7f1/0x930 [btrfs]
> [84554.797631]  [<ffffffffa0731c2a>] ? __btrfs_run_delayed_items+0x13a/0x1e0 [btrfs]
> [84554.797646]  [<ffffffffa06d2e1f>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
> [84554.797651]  [<ffffffff810bd6ef>] ? trace_hardirqs_on_caller+0x1f/0x1e0
> [84554.797668]  [<ffffffffa073173c>] __btrfs_update_delayed_inode+0x4c/0x1d0 [btrfs]
> [84554.797685]  [<ffffffffa0731c2a>] ? __btrfs_run_delayed_items+0x13a/0x1e0 [btrfs]
> [84554.797700]  [<ffffffffa0731c2a>] ? __btrfs_run_delayed_items+0x13a/0x1e0 [btrfs]
> [84554.797715]  [<ffffffffa0731c82>] __btrfs_run_delayed_items+0x192/0x1e0 [btrfs]
> [84554.797731]  [<ffffffffa0731d03>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
> [84554.797745]  [<ffffffffa06dbcd4>] btrfs_flush_all_pending_stuffs+0x24/0x80 [btrfs]
> [84554.797759]  [<ffffffffa06ddc13>] btrfs_commit_transaction+0x223/0xa20 [btrfs]
> [84554.797770]  [<ffffffffa06ae5ae>] btrfs_sync_fs+0x6e/0x110 [btrfs]
> [84554.797775]  [<ffffffff811d0b50>] ? __sync_filesystem+0x60/0x60
> [84554.797779]  [<ffffffff811d0b50>] ? __sync_filesystem+0x60/0x60
> [84554.797783]  [<ffffffff811d0b70>] sync_fs_one_sb+0x20/0x30
> [84554.797788]  [<ffffffff811a3541>] iterate_supers+0xf1/0x100
> [84554.797792]  [<ffffffff811d0c45>] sys_sync+0x55/0x90
> [84554.797797]  [<ffffffff8177ef12>] system_call_fastpath+0x16/0x1b
> [84554.797799] INFO: lockdep is turned off.
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/backref.c |   20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 6a3f7f5..bed1456 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1568,8 +1568,8 @@ static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
>         struct btrfs_inode_ref *iref;
>         struct btrfs_key found_key;
>
> +       path->leave_spinning = 0;
>         while (!ret) {
> -               path->leave_spinning = 1;
>                 ret = inode_ref_info(inum, parent ? parent+1 : 0, fs_root, path,
>                                      &found_key);
>                 if (ret < 0)
> @@ -1582,9 +1582,12 @@ static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
>
>                 parent = found_key.offset;
>                 slot = path->slots[0];
> -               eb = path->nodes[0];
> -               /* make sure we can use eb after releasing the path */
> -               atomic_inc(&eb->refs);
> +               eb = btrfs_clone_extent_buffer(path->nodes[0]);
> +               if (!eb) {
> +                       ret = -ENOMEM;
> +                       break;
> +               }
> +               extent_buffer_get(eb);
>                 btrfs_tree_read_lock(eb);
>                 btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>                 btrfs_release_path(path);
> @@ -1642,9 +1645,12 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
>                 ++found;
>
>                 slot = path->slots[0];
> -               eb = path->nodes[0];
> -               /* make sure we can use eb after releasing the path */
> -               atomic_inc(&eb->refs);
> +               eb = btrfs_clone_extent_buffer(path->nodes[0]);
> +               if (!eb) {
> +                       ret = -ENOMEM;
> +                       break;
> +               }
> +               extent_buffer_get(eb);
>
>                 btrfs_tree_read_lock(eb);
>                 btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
