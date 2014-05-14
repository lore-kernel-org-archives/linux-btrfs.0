Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51283 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaENLk2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 07:40:28 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1WkXXv-0000P5-5W
	for <linux-btrfs@vger.kernel.org>; Wed, 14 May 2014 04:40:27 -0700
Date: Wed, 14 May 2014 04:40:27 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: 3.15rc5 deadlock
Message-ID: <20140514114027.GA32301@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got this soon after boot:

[  720.086389] INFO: task pidgin:11330 blocked for more than 120 seconds.
[  720.086402]       Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #1
[  720.086406] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.086411] pidgin          D 0000000000000004     0 11330   5187 0x00000080
[  720.086423]  ffff8803d7233c30 0000000000000082 ffff8803d7233c00 ffff8803d7233fd8
[  720.086433]  ffff8804066345d0 00000000000141c0 ffff88041e3141c0 ffff8804066345d0
[  720.086441]  ffff8803d7233cd0 0000000000000002 ffffffff810fda1a ffff8803d7233c40
[  720.086450] Call Trace:
[  720.086468]  [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
[  720.086494]  [<ffffffff8161c816>] schedule+0x73/0x75
[  720.086502]  [<ffffffff8161c9bb>] io_schedule+0x60/0x7a
[  720.086510]  [<ffffffff810fda28>] sleep_on_page+0xe/0x12
[  720.086519]  [<ffffffff8161cd4b>] __wait_on_bit_lock+0x46/0x8a
[  720.086528]  [<ffffffff810fdae3>] __lock_page+0x69/0x6b
[  720.086536]  [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
[  720.086544]  [<ffffffff81240c41>] lock_page+0x1e/0x21
[  720.086553]  [<ffffffff8124470e>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
[  720.086562]  [<ffffffff81244b6c>] extent_writepages+0x4b/0x5c
[  720.086573]  [<ffffffff813159e0>] ? debug_smp_processor_id+0x17/0x19
[  720.086581]  [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
[  720.086592]  [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
[  720.086602]  [<ffffffff811082b1>] do_writepages+0x1e/0x2c
[  720.086611]  [<ffffffff810ff179>] __filemap_fdatawrite_range+0x55/0x57
[  720.086620]  [<ffffffff810ff1ef>] filemap_fdatawrite_range+0x13/0x15
[  720.086628]  [<ffffffff8123883d>] btrfs_sync_file+0x8b/0x2b3
[  720.086636]  [<ffffffff8132042f>] ? __percpu_counter_add+0x8c/0xa6
[  720.086647]  [<ffffffff81157087>] ? __sb_end_write+0x2d/0x5b
[  720.086657]  [<ffffffff8117a1a7>] vfs_fsync_range+0x18/0x22
[  720.086663]  [<ffffffff8117a1cd>] vfs_fsync+0x1c/0x1e
[  720.086670]  [<ffffffff8117a3d9>] do_fsync+0x2c/0x4c
[  720.086678]  [<ffffffff8117a5e2>] SyS_fsync+0x10/0x14
[  720.086686]  [<ffffffff81625b6d>] system_call_fastpath+0x1a/0x1f
[  720.086698] INFO: task BrowserBlocking:12907 blocked for more than 120 seconds.
[  720.086702]       Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #1
[  720.086706] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.086709] BrowserBlocking D 0000000000000007     0 12907   5254 0x00000080
[  720.086718]  ffff8803bc35dc30 0000000000000086 ffff8803bc35dc00 ffff8803bc35dfd8
[  720.086726]  ffff8803d704e090 00000000000141c0 ffff88041e3d41c0 ffff8803d704e090
[  720.086734]  ffff8803bc35dcd0 0000000000000002 ffffffff810fda1a ffff8803bc35dc40
[  720.086742] Call Trace:
[  720.086751]  [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
[  720.086759]  [<ffffffff8161c816>] schedule+0x73/0x75
[  720.086767]  [<ffffffff8161c9bb>] io_schedule+0x60/0x7a
[  720.086774]  [<ffffffff810fda28>] sleep_on_page+0xe/0x12
[  720.086783]  [<ffffffff8161cd4b>] __wait_on_bit_lock+0x46/0x8a
[  720.086791]  [<ffffffff810fdae3>] __lock_page+0x69/0x6b
[  720.086797]  [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
[  720.086803]  [<ffffffff81240c41>] lock_page+0x1e/0x21
[  720.086810]  [<ffffffff8124470e>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
[  720.086820]  [<ffffffff810fdbef>] ? file_accessed+0x13/0x15
[  720.086826]  [<ffffffff81244b6c>] extent_writepages+0x4b/0x5c
[  720.086833]  [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
[  720.086841]  [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
[  720.086849]  [<ffffffff811082b1>] do_writepages+0x1e/0x2c
[  720.086857]  [<ffffffff810ff179>] __filemap_fdatawrite_range+0x55/0x57
[  720.086866]  [<ffffffff810ff1ef>] filemap_fdatawrite_range+0x13/0x15
[  720.086873]  [<ffffffff8123883d>] btrfs_sync_file+0x8b/0x2b3
[  720.086880]  [<ffffffff8117a1a7>] vfs_fsync_range+0x18/0x22
[  720.086887]  [<ffffffff8117a1cd>] vfs_fsync+0x1c/0x1e
[  720.086893]  [<ffffffff8117a3d9>] do_fsync+0x2c/0x4c
[  720.086901]  [<ffffffff8117a5f9>] SyS_fdatasync+0x13/0x17
[  720.086907]  [<ffffffff81625b6d>] system_call_fastpath+0x1a/0x1f
[  720.086912] INFO: task Chrome_DBThread:12908 blocked for more than 120 seconds.
[  720.086916]       Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #1
[  720.086920] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.086923] Chrome_DBThread D 0000000000000006     0 12908   5254 0x00000080
[  720.086930]  ffff8803bc32dc30 0000000000000086 ffff8803bc32dc00 ffff8803bc32dfd8
[  720.086937]  ffff8803d5406410 00000000000141c0 ffff88041e3941c0 ffff8803d5406410
[  720.086945]  ffff8803bc32dcd0 0000000000000002 ffffffff810fda1a ffff8803bc32dc40
[  720.086953] Call Trace:
[  720.086961]  [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
[  720.086969]  [<ffffffff8161c816>] schedule+0x73/0x75
[  720.086977]  [<ffffffff8161c9bb>] io_schedule+0x60/0x7a
[  720.086985]  [<ffffffff810fda28>] sleep_on_page+0xe/0x12
[  720.086993]  [<ffffffff8161cd4b>] __wait_on_bit_lock+0x46/0x8a
[  720.087001]  [<ffffffff810fdae3>] __lock_page+0x69/0x6b
[  720.087008]  [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
[  720.087014]  [<ffffffff81240c41>] lock_page+0x1e/0x21
[  720.087020]  [<ffffffff8124470e>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
[  720.087032]  [<ffffffff8111ce6c>] ? pagefault_enable+0xe/0x21
[  720.087040]  [<ffffffff8111cfe2>] ? copy_page_to_iter+0x163/0x26b
[  720.087049]  [<ffffffff810fdbef>] ? file_accessed+0x13/0x15
[  720.087055]  [<ffffffff81244b6c>] extent_writepages+0x4b/0x5c
[  720.087061]  [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
[  720.087070]  [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
[  720.087077]  [<ffffffff811082b1>] do_writepages+0x1e/0x2c
[  720.087086]  [<ffffffff810ff179>] __filemap_fdatawrite_range+0x55/0x57
[  720.087095]  [<ffffffff810ff1ef>] filemap_fdatawrite_range+0x13/0x15
[  720.087101]  [<ffffffff8123885a>] btrfs_sync_file+0xa8/0x2b3
[  720.087109]  [<ffffffff8117a1a7>] vfs_fsync_range+0x18/0x22
[  720.087115]  [<ffffffff8117a1cd>] vfs_fsync+0x1c/0x1e
[  720.087122]  [<ffffffff8117a3d9>] do_fsync+0x2c/0x4c
[  720.087129]  [<ffffffff8117a5f9>] SyS_fdatasync+0x13/0x17
[  720.087135]  [<ffffffff81625b6d>] system_call_fastpath+0x1a/0x1f
[  720.087143] INFO: task IndexedDB:12914 blocked for more than 120 seconds.
[  720.087147]       Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #1
[  720.087150] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.087153] IndexedDB       D 0000000000000003     0 12914   5254 0x00000080
[  720.087160]  ffff8803b9ee7c30 0000000000000086 ffff8803b9ee7c00 ffff8803b9ee7fd8
[  720.087168]  ffff8803d5666390 00000000000141c0 ffff88041e2d41c0 ffff8803d5666390
[  720.087175]  ffff8803b9ee7cd0 0000000000000002 ffffffff810fda1a ffff8803b9ee7c40
[  720.087183] Call Trace:
[  720.087192]  [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
[  720.087200]  [<ffffffff8161c816>] schedule+0x73/0x75
[  720.087208]  [<ffffffff8161c9bb>] io_schedule+0x60/0x7a
[  720.087215]  [<ffffffff810fda28>] sleep_on_page+0xe/0x12
[  720.087224]  [<ffffffff8161cd4b>] __wait_on_bit_lock+0x46/0x8a
[  720.087232]  [<ffffffff810fdae3>] __lock_page+0x69/0x6b
[  720.087238]  [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
[  720.087244]  [<ffffffff81240c41>] lock_page+0x1e/0x21
[  720.087251]  [<ffffffff8124470e>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
[  720.087261]  [<ffffffff8161d274>] ? mutex_unlock+0x16/0x18
[  720.087268]  [<ffffffff81239c74>] ? btrfs_file_aio_write+0x3e9/0x4b6
[  720.087275]  [<ffffffff81244b6c>] extent_writepages+0x4b/0x5c
[  720.087281]  [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
[  720.087289]  [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
[  720.087297]  [<ffffffff811082b1>] do_writepages+0x1e/0x2c
[  720.087305]  [<ffffffff810ff179>] __filemap_fdatawrite_range+0x55/0x57
[  720.087314]  [<ffffffff810ff1ef>] filemap_fdatawrite_range+0x13/0x15
[  720.087321]  [<ffffffff8123885a>] btrfs_sync_file+0xa8/0x2b3
[  720.087328]  [<ffffffff8132042f>] ? __percpu_counter_add+0x8c/0xa6
[  720.087336]  [<ffffffff8117a1a7>] vfs_fsync_range+0x18/0x22
[  720.087342]  [<ffffffff8117a1cd>] vfs_fsync+0x1c/0x1e
[  720.087349]  [<ffffffff8117a3d9>] do_fsync+0x2c/0x4c
[  720.087356]  [<ffffffff8117a5f9>] SyS_fdatasync+0x13/0x17
[  720.087362]  [<ffffffff81625b6d>] system_call_fastpath+0x1a/0x1f
[  720.087368] INFO: task BrowserBlocking:12917 blocked for more than 120 seconds.
[  720.087372]       Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #1
[  720.087375] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.087379] BrowserBlocking D 0000000000000000     0 12917   5254 0x00000080
[  720.087385]  ffff8803bc3c3c30 0000000000000086 ffff8803bc3c3c00 ffff8803bc3c3fd8
[  720.087393]  ffff8803cf788050 00000000000141c0 ffff88041e2141c0 ffff8803cf788050
[  720.087400]  ffff8803bc3c3cd0 0000000000000002 ffffffff810fda1a ffff8803bc3c3c40
[  720.087408] Call Trace:
[  720.087416]  [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
[  720.087424]  [<ffffffff8161c816>] schedule+0x73/0x75
[  720.087432]  [<ffffffff8161c9bb>] io_schedule+0x60/0x7a
[  720.087440]  [<ffffffff810fda28>] sleep_on_page+0xe/0x12
[  720.087448]  [<ffffffff8161cd4b>] __wait_on_bit_lock+0x46/0x8a
[  720.087456]  [<ffffffff810fdae3>] __lock_page+0x69/0x6b
[  720.087462]  [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
[  720.087468]  [<ffffffff81240c41>] lock_page+0x1e/0x21
[  720.087475]  [<ffffffff8124470e>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
[  720.087483]  [<ffffffff81244b6c>] extent_writepages+0x4b/0x5c
[  720.087489]  [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
[  720.087498]  [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
[  720.087505]  [<ffffffff811082b1>] do_writepages+0x1e/0x2c
[  720.087514]  [<ffffffff810ff179>] __filemap_fdatawrite_range+0x55/0x57
[  720.087522]  [<ffffffff810ff1ef>] filemap_fdatawrite_range+0x13/0x15
[  720.087529]  [<ffffffff8123883d>] btrfs_sync_file+0x8b/0x2b3
[  720.087536]  [<ffffffff81157087>] ? __sb_end_write+0x2d/0x5b
[  720.087544]  [<ffffffff8117a1a7>] vfs_fsync_range+0x18/0x22
[  720.087550]  [<ffffffff8117a1cd>] vfs_fsync+0x1c/0x1e
[  720.087557]  [<ffffffff8117a3d9>] do_fsync+0x2c/0x4c
[  720.087564]  [<ffffffff8117a5e2>] SyS_fsync+0x10/0x14
[  720.087570]  [<ffffffff81625b6d>] system_call_fastpath+0x1a/0x1f
[  720.087577] INFO: task BrowserBlocking:12933 blocked for more than 120 seconds.
[  720.087580]       Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #1
[  720.087584] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.087587] BrowserBlocking D 0000000000000000     0 12933   5254 0x00000080
[  720.087593]  ffff8803b798bc30 0000000000000086 ffff8803b798bc00 ffff8803b798bfd8
[  720.087601]  ffff8800bb862190 00000000000141c0 ffff88041e2141c0 ffff8800bb862190
[  720.087608]  ffff8803b798bcd0 0000000000000002 ffffffff810fda1a ffff8803b798bc40
[  720.087616] Call Trace:
[  720.087624]  [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
[  720.087632]  [<ffffffff8161c816>] schedule+0x73/0x75
[  720.087640]  [<ffffffff8161c9bb>] io_schedule+0x60/0x7a
[  720.087648]  [<ffffffff810fda28>] sleep_on_page+0xe/0x12
[  720.087656]  [<ffffffff8161cd4b>] __wait_on_bit_lock+0x46/0x8a
[  720.087664]  [<ffffffff810fdae3>] __lock_page+0x69/0x6b
[  720.087670]  [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
[  720.087676]  [<ffffffff81240c41>] lock_page+0x1e/0x21
[  720.087683]  [<ffffffff8124470e>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
[  720.087712]  [<ffffffff8161d274>] ? mutex_unlock+0x16/0x18
[  720.087719]  [<ffffffff81239c74>] ? btrfs_file_aio_write+0x3e9/0x4b6
[  720.087725]  [<ffffffff81244b6c>] extent_writepages+0x4b/0x5c
[  720.087731]  [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
[  720.087740]  [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
[  720.087748]  [<ffffffff811082b1>] do_writepages+0x1e/0x2c
[  720.087756]  [<ffffffff810ff179>] __filemap_fdatawrite_range+0x55/0x57
[  720.087765]  [<ffffffff810ff1ef>] filemap_fdatawrite_range+0x13/0x15
[  720.087771]  [<ffffffff8123885a>] btrfs_sync_file+0xa8/0x2b3
[  720.087778]  [<ffffffff8132042f>] ? __percpu_counter_add+0x8c/0xa6
[  720.087786]  [<ffffffff8117a1a7>] vfs_fsync_range+0x18/0x22
[  720.087793]  [<ffffffff8117a1cd>] vfs_fsync+0x1c/0x1e
[  720.087799]  [<ffffffff8117a3d9>] do_fsync+0x2c/0x4c
[  720.087806]  [<ffffffff8117a5f9>] SyS_fdatasync+0x13/0x17
[  720.087812]  [<ffffffff81625b6d>] system_call_fastpath+0x1a/0x1f
[  720.087881] INFO: task mutt:13900 blocked for more than 120 seconds.
[  720.087885]       Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #1
[  720.087888] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.087892] mutt            D 0000000000000006     0 13900   7279 0x00000080
[  720.087898]  ffff880096b45b40 0000000000000086 ffff880096b45b10 ffff880096b45fd8
[  720.087906]  ffff880096a341d0 00000000000141c0 ffff88041e3941c0 ffff880096a341d0
[  720.087913]  ffff880096b45be0 0000000000000002 ffffffff810fda1a ffff880096b45b50
[  720.087921] Call Trace:
[  720.087930]  [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
[  720.087938]  [<ffffffff8161c816>] schedule+0x73/0x75
[  720.087945]  [<ffffffff8161c9bb>] io_schedule+0x60/0x7a
[  720.087953]  [<ffffffff810fda28>] sleep_on_page+0xe/0x12
[  720.087961]  [<ffffffff8161cd4b>] __wait_on_bit_lock+0x46/0x8a
[  720.087969]  [<ffffffff810fdae3>] __lock_page+0x69/0x6b
[  720.087975]  [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
[  720.087981]  [<ffffffff81240c41>] lock_page+0x1e/0x21
[  720.087988]  [<ffffffff8124470e>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
[  720.087996]  [<ffffffff8110a5b2>] ? pagevec_lookup_entries+0x1e/0x26
[  720.088003]  [<ffffffff8110ae23>] ? truncate_inode_pages_range+0x2a9/0x3ad
[  720.088013]  [<ffffffff81211106>] ? setup_items_for_insert+0x2ba/0x2da
[  720.088019]  [<ffffffff81244b6c>] extent_writepages+0x4b/0x5c
[  720.088025]  [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
[  720.088034]  [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
[  720.088042]  [<ffffffff811082b1>] do_writepages+0x1e/0x2c
[  720.088050]  [<ffffffff810ff179>] __filemap_fdatawrite_range+0x55/0x57
[  720.088059]  [<ffffffff810ff1ef>] filemap_fdatawrite_range+0x13/0x15
[  720.088067]  [<ffffffff8123fcda>] btrfs_wait_ordered_range+0x85/0x11a
[  720.088074]  [<ffffffff8123321e>] btrfs_truncate+0x45/0x22b
[  720.088081]  [<ffffffff81233cb1>] btrfs_setattr+0x19b/0x273
[  720.088090]  [<ffffffff8116b148>] notify_change+0x1be/0x2a6
[  720.088100]  [<ffffffff81153d74>] do_truncate+0x69/0x90
[  720.088108]  [<ffffffff811579d5>] ? __sb_start_write+0x9f/0xd3
[  720.088117]  [<ffffffff81153fff>] do_sys_ftruncate.constprop.6+0xbf/0xf3
[  720.088126]  [<ffffffff81154064>] SyS_ftruncate+0xe/0x10
[  720.088132]  [<ffffffff81625b6d>] system_call_fastpath+0x1a/0x1f
[  720.088153] INFO: task kworker/u16:51:15411 blocked for more than 120 seconds.
[  720.088157]       Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #1
[  720.088160] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.088163] kworker/u16:51  D 0000000000000000     0 15411      2 0x00000080
[  720.088179] Workqueue: btrfs-delalloc normal_work_helper
[  720.088183]  ffff8800751db860 0000000000000046 ffff8800751db830 ffff8800751dbfd8
[  720.088190]  ffff8800751d8550 00000000000141c0 ffff88041e2541c0 ffff8800751d8550
[  720.088198]  ffff8800751db900 0000000000000002 ffffffff810fda1a ffff8800751db870
[  720.088206] Call Trace:
[  720.088214]  [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
[  720.088222]  [<ffffffff8161c816>] schedule+0x73/0x75
[  720.088230]  [<ffffffff8161c9bb>] io_schedule+0x60/0x7a
[  720.088238]  [<ffffffff810fda28>] sleep_on_page+0xe/0x12
[  720.088246]  [<ffffffff8161cd4b>] __wait_on_bit_lock+0x46/0x8a
[  720.088254]  [<ffffffff810fdae3>] __lock_page+0x69/0x6b
[  720.088260]  [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
[  720.088268]  [<ffffffff810fe3c9>] lock_page+0x19/0x1c
[  720.088276]  [<ffffffff810fe425>] find_lock_entry+0x33/0x55
[  720.088284]  [<ffffffff810fe455>] find_lock_page+0xe/0x1b
[  720.088293]  [<ffffffff810fe93e>] find_or_create_page+0x31/0x83
[  720.088302]  [<ffffffff8125edca>] io_ctl_prepare_pages+0x49/0x11c
[  720.088310]  [<ffffffff8126097a>] __load_free_space_cache+0x1be/0x56c
[  720.088319]  [<ffffffff81260e0e>] load_free_space_cache+0xe6/0x199
[  720.088330]  [<ffffffff810764de>] ? get_parent_ip+0xd/0x3c
[  720.088339]  [<ffffffff81215c2e>] cache_block_group+0x1c4/0x343
[  720.088345]  [<ffffffff8108473d>] ? finish_wait+0x65/0x65
[  720.088354]  [<ffffffff8121a966>] find_free_extent+0x391/0x89e
[  720.088363]  [<ffffffff8121afce>] btrfs_reserve_extent+0x70/0x114
[  720.088370]  [<ffffffff8123087c>] cow_file_range+0x1b0/0x388
[  720.088377]  [<ffffffff8123152b>] submit_compressed_extents+0x102/0x40f
[  720.088384]  [<ffffffff8122fa27>] ? async_cow_free+0x24/0x27
[  720.088391]  [<ffffffff812318be>] async_cow_submit+0x86/0x8b
[  720.088399]  [<ffffffff812505c1>] normal_work_helper+0x194/0x240
[  720.088408]  [<ffffffff81065d2e>] process_one_work+0x195/0x2d2
[  720.088415]  [<ffffffff8106624a>] worker_thread+0x136/0x205
[  720.088422]  [<ffffffff81066114>] ? rescuer_thread+0x27a/0x27a
[  720.088429]  [<ffffffff8106b467>] kthread+0xae/0xb6
[  720.088435]  [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
[  720.088441]  [<ffffffff81625abc>] ret_from_fork+0x7c/0xb0
[  720.088447]  [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
[  720.088453] INFO: task kworker/u16:55:15415 blocked for more than 120 seconds.
[  720.088456]       Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #1
[  720.088460] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.088463] kworker/u16:55  D 0000000000000000     0 15415      2 0x00000080
[  720.088475] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-1)
[  720.088480]  ffff8800752a5a00 0000000000000046 ffff8800752a59d0 ffff8800752a5fd8
[  720.088488]  ffff8800b9ef4550 00000000000141c0 ffff88041e2541c0 ffff8800b9ef4550
[  720.088496]  ffff8800752a5aa0 0000000000000002 ffffffff810fda1a ffff8800752a5a10
[  720.088503] Call Trace:
[  720.088512]  [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
[  720.088520]  [<ffffffff8161c816>] schedule+0x73/0x75
[  720.088528]  [<ffffffff8161c9bb>] io_schedule+0x60/0x7a
[  720.088535]  [<ffffffff810fda28>] sleep_on_page+0xe/0x12
[  720.088544]  [<ffffffff8161cd4b>] __wait_on_bit_lock+0x46/0x8a
[  720.088552]  [<ffffffff810fdae3>] __lock_page+0x69/0x6b
[  720.088558]  [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
[  720.088564]  [<ffffffff81240c41>] lock_page+0x1e/0x21
[  720.088571]  [<ffffffff8124470e>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
[  720.088579]  [<ffffffff81244b6c>] extent_writepages+0x4b/0x5c
[  720.088585]  [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
[  720.088594]  [<ffffffff816227cc>] ? preempt_count_add+0x77/0x8d
[  720.088602]  [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
[  720.088610]  [<ffffffff811082b1>] do_writepages+0x1e/0x2c
[  720.088616]  [<ffffffff81175ef2>] __writeback_single_inode+0x7d/0x238
[  720.088623]  [<ffffffff81176c2a>] writeback_sb_inodes+0x1eb/0x339
[  720.088630]  [<ffffffff81176dec>] __writeback_inodes_wb+0x74/0xb7
[  720.088637]  [<ffffffff81176f67>] wb_writeback+0x138/0x293
[  720.088644]  [<ffffffff811774ce>] bdi_writeback_workfn+0xc9/0x329
[  720.088655]  [<ffffffff8100d047>] ? load_TLS+0xb/0xf
[  720.088661]  [<ffffffff810733c1>] ? mmdrop+0x11/0x20
[  720.088669]  [<ffffffff81065d2e>] process_one_work+0x195/0x2d2
[  720.088676]  [<ffffffff8106624a>] worker_thread+0x136/0x205
[  720.088683]  [<ffffffff81066114>] ? rescuer_thread+0x27a/0x27a
[  720.088689]  [<ffffffff8106b467>] kthread+0xae/0xb6
[  720.088695]  [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
[  720.088701]  [<ffffffff81625abc>] ret_from_fork+0x7c/0xb0
[  720.088707]  [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
[  720.088726] INFO: task sync:18457 blocked for more than 120 seconds.
[  720.088730]       Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #1
[  720.088733] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  720.088737] sync            D 0000000000000001     0 18457  18373 0x00000080
[  720.088743]  ffff8802e6fe3d60 0000000000000086 ffff8800b9ef4cdc ffff8802e6fe3fd8
[  720.088751]  ffff8802aa324190 00000000000141c0 7fffffffffffffff ffff8802e6fe3e98
[  720.088758]  0000000000000002 ffffffff8161be00 7fffffffffffffff ffff8802e6fe3d70
[  720.088766] Call Trace:
[  720.088775]  [<ffffffff8161be00>] ? sock_rps_reset_flow+0x36/0x36
[  720.088783]  [<ffffffff8161c816>] schedule+0x73/0x75
[  720.088791]  [<ffffffff8161be39>] schedule_timeout+0x39/0x129
[  720.088798]  [<ffffffff8161ef3b>] ? _raw_spin_unlock+0x17/0x2a
[  720.088805]  [<ffffffff810764de>] ? get_parent_ip+0xd/0x3c
[  720.088813]  [<ffffffff816227cf>] ? preempt_count_add+0x7a/0x8d
[  720.088821]  [<ffffffff8161cffc>] __wait_for_common+0x11a/0x159
[  720.088831]  [<ffffffff810780a9>] ? wake_up_state+0x12/0x12
[  720.088838]  [<ffffffff8117a1cf>] ? vfs_fsync+0x1e/0x1e
[  720.088846]  [<ffffffff8161d05f>] wait_for_completion+0x24/0x26
[  720.088852]  [<ffffffff81176485>] sync_inodes_sb+0xb6/0x1a0
[  720.088860]  [<ffffffff8117a1cf>] ? vfs_fsync+0x1e/0x1e
[  720.088867]  [<ffffffff8117a1e3>] sync_inodes_one_sb+0x14/0x16
[  720.088874]  [<ffffffff81157cf4>] iterate_supers+0x6e/0xc2
[  720.088881]  [<ffffffff8117a4be>] sys_sync+0x32/0x80
[  720.088888]  [<ffffffff81625b6d>] system_call_fastpath+0x1a/0x1f


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
