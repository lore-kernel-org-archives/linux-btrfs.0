Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32909 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbcKYGUW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 01:20:22 -0500
Received: by mail-wm0-f65.google.com with SMTP id u144so6810852wmu.0
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Nov 2016 22:20:21 -0800 (PST)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 25 Nov 2016 09:19:39 +0300
Message-ID: <CAGqmi74PvWRLwwxsd1b76QqyS=NHZwxm871DN57ALnEjMZfreA@mail.gmail.com>
Subject: Help with stack trace
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, i use btrfs as a storage for root and data for ElasticSearch
servers and i catch strange bug then servers hungs.
But i get this stack trace only if start Elastic.

Debian 8 x64
Linux msq-k1-srv-ids-02 4.8.0-1-amd64 #1 SMP Debian 4.8.5-1
(2016-10-28) x86_64 GNU/Linux
Also catch it on Debian linux 4.7.6
btrfs-progs v4.7.3

btrfs check don't find any errors, so i think may be this is some kind
of race condition?

Stack trace:
[  365.619814] INFO: task kworker/u480:1:205 blocked for more than 120 seconds.
[  365.619891]       Not tainted 4.8.0-1-amd64 #1
[  365.619926] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  365.619984] kworker/u480:1  D ffff888d7bb18180     0   205      2 0x00000000
[  365.620103] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  365.620158]  ffff888d7235a000 ffff888d74b820c0 ffffffffc03c68fb
ffff888d6b9d3a58
[  365.620227]  ffff888d6b9d4000 ffff887e12709508 00000000ffffff00
ffff888d7235a000
[  365.620292]  ffff888d7235a000 ffff888d6b9d3a70 ffffffffaabeb4e1
ffff887e127094a0
[  365.620358] Call Trace:
[  365.620416]  [<ffffffffc03c68fb>] ? btrfs_get_token_32+0x6b/0x130 [btrfs]
[  365.620475]  [<ffffffffaabeb4e1>] ? schedule+0x31/0x80
[  365.620542]  [<ffffffffc03e96a5>] ? btrfs_tree_read_lock+0xd5/0x120 [btrfs]
[  365.620597]  [<ffffffffaa6bcf40>] ? wake_atomic_t_function+0x60/0x60
[  365.620666]  [<ffffffffc037ef8f>] ?
btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
[  365.620742]  [<ffffffffc0383fa6>] ? btrfs_search_slot+0x756/0x9f0 [btrfs]
[  365.620817]  [<ffffffffc03a467b>] ? btrfs_buffer_uptodate+0x4b/0x70 [btrfs]
[  365.620889]  [<ffffffffc038124b>] ?
generic_bin_search.constprop.37+0x9b/0x210 [btrfs]
[  365.620971]  [<ffffffffc039e5fa>] ?
btrfs_lookup_file_extent+0x4a/0x70 [btrfs]
[  365.621049]  [<ffffffffc03c15f4>] ? __btrfs_drop_extents+0x164/0xdd0 [btrfs]
[  365.621105]  [<ffffffffaa7e136c>] ? kmem_cache_alloc+0xbc/0x530
[  365.621176]  [<ffffffffc03aebf4>] ?
insert_reserved_file_extent.constprop.64+0xb4/0x330 [btrfs]
[  365.621263]  [<ffffffffc03ac275>] ? start_transaction+0x95/0x4b0 [btrfs]
[  365.621336]  [<ffffffffc03b5ab7>] ?
btrfs_finish_ordered_io+0x307/0x680 [btrfs]
[  365.621394]  [<ffffffffaa6a47e0>] ? check_preempt_curr+0x50/0x90
[  365.621467]  [<ffffffffc03df8a1>] ?
btrfs_scrubparity_helper+0xd1/0x2d0 [btrfs]
[  365.621524]  [<ffffffffaa694ec0>] ? process_one_work+0x160/0x410
[  365.621570]  [<ffffffffaa6951bd>] ? worker_thread+0x4d/0x480
[  365.621614]  [<ffffffffaa695170>] ? process_one_work+0x410/0x410
[  365.621662]  [<ffffffffaa69af8d>] ? kthread+0xcd/0xf0
[  365.621704]  [<ffffffffaabefb2f>] ? ret_from_fork+0x1f/0x40
[  365.621748]  [<ffffffffaa69aec0>] ? kthread_create_on_node+0x190/0x190
[  365.621799] INFO: task kworker/u480:2:1467 blocked for more than 120 seconds.
[  365.621852]       Not tainted 4.8.0-1-amd64 #1
[  365.621886] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  365.621942] kworker/u480:2  D ffff888d7bd98180     0  1467      2 0x00000000
[  365.622032] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  365.622085]  ffff888d6bab50c0 ffff888d74b8d040 ffffffffc03c68fb
ffff888d6a1f7a58
[  365.622151]  ffff888d6a1f8000 ffff887e12709508 00000000ffffff00
ffff888d6bab50c0
[  365.622217]  ffff888d6bab50c0 ffff888d6a1f7a70 ffffffffaabeb4e1
ffff887e127094a0
[  365.622283] Call Trace:
[  365.622334]  [<ffffffffc03c68fb>] ? btrfs_get_token_32+0x6b/0x130 [btrfs]
[  365.622387]  [<ffffffffaabeb4e1>] ? schedule+0x31/0x80
[  365.622453]  [<ffffffffc03e96a5>] ? btrfs_tree_read_lock+0xd5/0x120 [btrfs]
[  365.622506]  [<ffffffffaa6bcf40>] ? wake_atomic_t_function+0x60/0x60
[  365.622575]  [<ffffffffc037ef8f>] ?
btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
[  365.624240]  [<ffffffffc0383fa6>] ? btrfs_search_slot+0x756/0x9f0 [btrfs]
[  365.625855]  [<ffffffffaa94ff0a>] ? swiotlb_map_sg_attrs+0x6a/0x130
[  365.627491]  [<ffffffffc039e5fa>] ?
btrfs_lookup_file_extent+0x4a/0x70 [btrfs]
[  365.629124]  [<ffffffffc03c15f4>] ? __btrfs_drop_extents+0x164/0xdd0 [btrfs]
[  365.630692]  [<ffffffffaa7e136c>] ? kmem_cache_alloc+0xbc/0x530
[  365.632279]  [<ffffffffc03aebf4>] ?
insert_reserved_file_extent.constprop.64+0xb4/0x330 [btrfs]
[  365.633759]  [<ffffffffc03ac275>] ? start_transaction+0x95/0x4b0 [btrfs]
[  365.635211]  [<ffffffffc03b5ab7>] ?
btrfs_finish_ordered_io+0x307/0x680 [btrfs]
[  365.636647]  [<ffffffffaa6a47e0>] ? check_preempt_curr+0x50/0x90
[  365.638095]  [<ffffffffc03df8a1>] ?
btrfs_scrubparity_helper+0xd1/0x2d0 [btrfs]
[  365.639526]  [<ffffffffaa694ec0>] ? process_one_work+0x160/0x410
[  365.640959]  [<ffffffffaa6951bd>] ? worker_thread+0x4d/0x480
[  365.642361]  [<ffffffffaa695170>] ? process_one_work+0x410/0x410
[  365.643769]  [<ffffffffaa69af8d>] ? kthread+0xcd/0xf0
[  365.645072]  [<ffffffffaabefb2f>] ? ret_from_fork+0x1f/0x40
[  365.646349]  [<ffffffffaa69aec0>] ? kthread_create_on_node+0x190/0x190
[  365.647669] INFO: task btrfs-transacti:4130 blocked for more than
120 seconds.
[  365.648981]       Not tainted 4.8.0-1-amd64 #1
[  365.650270] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  365.651585] btrfs-transacti D ffff888d7bc18180     0  4130      2 0x00000000
[  365.652928]  ffff888d6a269000 ffff888d71ec0000 ffffffffaa6e6f39
ffff888d6d38be08
[  365.654270]  ffff888d6d38c000 ffff888d720eb9f0 ffff888d720eb800
ffff888d720eb9f0
[  365.655612]  0000000000000000 ffff888d6a269000 ffffffffaabeb4e1
ffff888d6b57e3a0
[  365.656951] Call Trace:
[  365.658183]  [<ffffffffaa6e6f39>] ? try_to_del_timer_sync+0x59/0x80
[  365.659411]  [<ffffffffaabeb4e1>] ? schedule+0x31/0x80
[  365.660680]  [<ffffffffc03a9dad>] ?
wait_current_trans.isra.21+0xcd/0x110 [btrfs]
[  365.662001]  [<ffffffffaa6bcf40>] ? wake_atomic_t_function+0x60/0x60
[  365.663249]  [<ffffffffc03ac453>] ? start_transaction+0x273/0x4b0 [btrfs]
[  365.664539]  [<ffffffffc03a62d7>] ? transaction_kthread+0x77/0x200 [btrfs]
[  365.665817]  [<ffffffffc03a6260>] ?
btrfs_cleanup_transaction+0x590/0x590 [btrfs]
[  365.667070]  [<ffffffffaa69af8d>] ? kthread+0xcd/0xf0
[  365.668334]  [<ffffffffaabefb2f>] ? ret_from_fork+0x1f/0x40
[  365.669530]  [<ffffffffaa69aec0>] ? kthread_create_on_node+0x190/0x190
[  365.670735] INFO: task java:4930 blocked for more than 120 seconds.
[  365.671903]       Not tainted 4.8.0-1-amd64 #1
[  365.673066] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  365.674225] java            D ffff888d7ba18180     0  4930      1 0x00000100
[  365.675388]  ffff888d69ddd080 ffffffffab00d500 000000003a0f5db8
0000000000000000
[  365.676564]  ffff888548e60000 ffff888548e5fe90 ffff888d6f7c5868
ffff888d6f7c5880
[  365.677761]  ffffffffffffffff ffff888548e5fe20 ffffffffaabeb4e1
ffff888d69ddd080
[  365.678933] Call Trace:
[  365.680108]  [<ffffffffaabeb4e1>] ? schedule+0x31/0x80
[  365.681220]  [<ffffffffaabede58>] ? rwsem_down_read_failed+0xf8/0x150
[  365.682306]  [<ffffffffaa934ee4>] ? call_rwsem_down_read_failed+0x14/0x30
[  365.683382]  [<ffffffffaabed71c>] ? down_read+0x1c/0x30
[  365.684462]  [<ffffffffaa665caf>] ? __do_page_fault+0x43f/0x500
[  365.685554]  [<ffffffffaabf0cd8>] ? page_fault+0x28/0x30
[  365.686622] INFO: task java:4936 blocked for more than 120 seconds.
[  365.687689]       Not tainted 4.8.0-1-amd64 #1
[  365.688755] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  365.689866] java            D ffff888d7bfd8180     0  4936      1 0x00000100
[  365.690960]  ffff888d69e91080 ffff888d74418100 ffffffffaa6a575d
0000000000000000
[  365.692076]  ffff888548e78000 ffff888548e77e90 ffff888d6f7c5868
ffff888d6f7c5880
[  365.693127]  ffffffffffffffff ffff888548e77e20 ffffffffaabeb4e1
ffff888d69e91080
[  365.694145] Call Trace:
[  365.695149]  [<ffffffffaa6a575d>] ? wake_up_q+0x2d/0x60
[  365.696174]  [<ffffffffaabeb4e1>] ? schedule+0x31/0x80
[  365.697187]  [<ffffffffaabede58>] ? rwsem_down_read_failed+0xf8/0x150
[  365.698199]  [<ffffffffaa934ee4>] ? call_rwsem_down_read_failed+0x14/0x30
[  365.699211]  [<ffffffffaabed71c>] ? down_read+0x1c/0x30
[  365.700229]  [<ffffffffaa665caf>] ? __do_page_fault+0x43f/0x500
[  365.701254]  [<ffffffffaabf0cd8>] ? page_fault+0x28/0x30
[  365.702269] INFO: task java:4939 blocked for more than 120 seconds.
[  365.703275]       Not tainted 4.8.0-1-amd64 #1
[  365.704285] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  365.705258] java            D ffff888d7bbd8180     0  4939      1 0x00000100
[  365.706224]  ffff888d72353140 ffff888d74b85000 ffffffffaa6a575d
0000000000000000
[  365.707182]  ffff888548ea0000 ffff888548e9fe90 ffff888d6f7c5868
ffff888d6f7c5880
[  365.708159]  ffffffffffffffff ffff888548e9fe20 ffffffffaabeb4e1
ffff888d72353140
[  365.709143] Call Trace:
[  365.710075]  [<ffffffffaa6a575d>] ? wake_up_q+0x2d/0x60
[  365.711024]  [<ffffffffaabeb4e1>] ? schedule+0x31/0x80
[  365.711985]  [<ffffffffaabede58>] ? rwsem_down_read_failed+0xf8/0x150
[  365.712947]  [<ffffffffaa934ee4>] ? call_rwsem_down_read_failed+0x14/0x30
[  365.713890]  [<ffffffffaabed71c>] ? down_read+0x1c/0x30
[  365.714820]  [<ffffffffaa665caf>] ? __do_page_fault+0x43f/0x500
[  365.715755]  [<ffffffffaabf0cd8>] ? page_fault+0x28/0x30
[  365.716641] INFO: task java:4940 blocked for more than 120 seconds.
[  365.717514]       Not tainted 4.8.0-1-amd64 #1
[  365.718388] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  365.719295] java            D ffff888d7be18180     0  4940      1 0x00000100
[  365.720244]  ffff888d6e428100 ffff888d72129080 ffffffffaa6a575d
0000000000000000
[  365.721154]  ffff888548ea4000 ffff888548ea3e90 ffff888d6f7c5868
ffff888d6f7c5880
[  365.722052]  ffffffffffffffff ffff888548ea3e20 ffffffffaabeb4e1
ffff888d6e428100
[  365.722940] Call Trace:
[  365.723813]  [<ffffffffaa6a575d>] ? wake_up_q+0x2d/0x60
[  365.724688]  [<ffffffffaabeb4e1>] ? schedule+0x31/0x80
[  365.725557]  [<ffffffffaabede58>] ? rwsem_down_read_failed+0xf8/0x150
[  365.726429]  [<ffffffffaa934ee4>] ? call_rwsem_down_read_failed+0x14/0x30
[  365.727303]  [<ffffffffaabed71c>] ? down_read+0x1c/0x30
[  365.728182]  [<ffffffffaa665caf>] ? __do_page_fault+0x43f/0x500
[  365.729044]  [<ffffffffaabf0cd8>] ? page_fault+0x28/0x30
[  365.729906] INFO: task java:4941 blocked for more than 120 seconds.
[  365.730772]       Not tainted 4.8.0-1-amd64 #1
[  365.731639] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  365.732533] java            D ffff888d7bc58180     0  4941      1 0x00000100
[  365.733411]  ffff888d6b176040 ffff888d74b87080 ffffffffaa6a575d
0000000000000000
[  365.734258]  ffff888548ea8000 ffff888548ea7e90 ffff888d6f7c5868
ffff888d6f7c5880
[  365.735103]  ffffffffffffffff ffff888548ea7e20 ffffffffaabeb4e1
ffff888d6b176040
[  365.735954] Call Trace:
[  365.736785]  [<ffffffffaa6a575d>] ? wake_up_q+0x2d/0x60
[  365.737614]  [<ffffffffaabeb4e1>] ? schedule+0x31/0x80
[  365.738430]  [<ffffffffaabede58>] ? rwsem_down_read_failed+0xf8/0x150
[  365.739252]  [<ffffffffaa934ee4>] ? call_rwsem_down_read_failed+0x14/0x30
[  365.740089]  [<ffffffffaabed71c>] ? down_read+0x1c/0x30
[  365.740915]  [<ffffffffaa665caf>] ? __do_page_fault+0x43f/0x500
[  365.741737]  [<ffffffffaabf0cd8>] ? page_fault+0x28/0x30
[  365.742555] INFO: task java:4942 blocked for more than 120 seconds.
[  365.743378]       Not tainted 4.8.0-1-amd64 #1
[  365.744209] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  365.745058] java            D ffff888d7bcd8180     0  4942      1 0x00000100
[  365.745908]  ffff888d69dc0000 ffff888d74b89100 ffffffffaa6a575d
0000000000000000
[  365.746756]  ffff888548eac000 ffff888548eabe90 ffff888d6f7c5868
ffff888d6f7c5880
[  365.747608]  ffffffffffffffff ffff888548eabe20 ffffffffaabeb4e1
ffff888d69dc0000
[  365.748448] Call Trace:
[  365.749273]  [<ffffffffaa6a575d>] ? wake_up_q+0x2d/0x60
[  365.750101]  [<ffffffffaabeb4e1>] ? schedule+0x31/0x80
[  365.750915]  [<ffffffffaabede58>] ? rwsem_down_read_failed+0xf8/0x150
[  365.751747]  [<ffffffffaa934ee4>] ? call_rwsem_down_read_failed+0x14/0x30
[  365.752551]  [<ffffffffaabed71c>] ? down_read+0x1c/0x30
[  365.753341]  [<ffffffffaa665caf>] ? __do_page_fault+0x43f/0x500
[  365.754123]  [<ffffffffaabf0cd8>] ? page_fault+0x28/0x30
[  365.754901] INFO: task java:4944 blocked for more than 120 seconds.
[  365.755686]       Not tainted 4.8.0-1-amd64 #1
[  365.756480] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  365.757302] java            D ffff888d7bc18180     0  4944      1 0x00000100
[  365.758113]  ffff888d69cf7080 ffff888d74b86040 ffffffffaa6f9aa4
0000000000000000
[  365.758922]  ffff888548eb4000 ffff888548eb3df0 ffff888d6f7c5868
ffff888d6f7c5880
[  365.759721]  ffffffffffffffff ffff888548eb3d80 ffffffffaabeb4e1
ffff888d69cf7080
[  365.760544] Call Trace:
[  365.761330]  [<ffffffffaa6f9aa4>] ? get_futex_key+0x304/0x3d0
[  365.762124]  [<ffffffffaabeb4e1>] ? schedule+0x31/0x80
[  365.762906]  [<ffffffffaabede58>] ? rwsem_down_read_failed+0xf8/0x150
[  365.763689]  [<ffffffffaa934ee4>] ? call_rwsem_down_read_failed+0x14/0x30
[  365.764487]  [<ffffffffaabed71c>] ? down_read+0x1c/0x30
[  365.765270]  [<ffffffffaa7c84ac>] ? SyS_madvise+0x3cc/0x920
[  365.766029]  [<ffffffffaa60337c>] ? syscall_trace_enter+0xcc/0x300
[  365.766780]  [<ffffffffaa603b8a>] ? do_syscall_64+0x7a/0xd0
[  365.767524]  [<ffffffffaabef9a5>] ? entry_SYSCALL64_slow_path+0x25/0x25


Can someone comment, it's btrfs releated problem or not?

Thanks.
-- 
Have a nice day,
Timofey.
