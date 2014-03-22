Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49227 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaCVVYw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 17:24:52 -0400
Date: Sat, 22 Mar 2014 14:24:50 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs deadlock (3.14 kernel)
Message-ID: <20140322212450.GN28005@merlins.org>
References: <20140321060632.GD28005@merlins.org> <532C83ED.3040103@fb.com> <20140322005123.GO18959@merlins.org> <20140322064718.GB32023@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140322064718.GB32023@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 21, 2014 at 11:47:18PM -0700, Marc MERLIN wrote:
> On Fri, Mar 21, 2014 at 05:51:23PM -0700, Marc MERLIN wrote:
> > On Fri, Mar 21, 2014 at 02:24:45PM -0400, Josef Bacik wrote:
> > > >Is thre anything I can try to unwedge or prevent this problem next time I 
> > > >try?
> > > 
> > > Sysrq+w would be nice so I can see what everybody is doing.  Thanks,
> > 
> > Sure thing. There you go
> > http://marc.merlins.org/tmp/sysreq-w-btrfs.txt
> > (too big to paste on the list)
> 
> Later on, on the same filesystem, I removed a drive, added another one, and did a balance.
> It's still running as of now, but I'm getting some more blocked messages if that helps.
> 

Mmmh, I have another list of blocks today that may be a different sequence
The system is pretty hozed after this, it was able to write it to syslog
after minutes of hanging, but now I'm not sure I'm going to get anything
more out of it without a reboot.

Let me know if you need more.

Thanks,
Marc

[23049.987258] BTRFS info (device dm-9): found 30649 extents
[23064.281199] BTRFS info (device dm-9): found 30649 extents
[23065.579373] BTRFS info (device dm-9): relocating block group 783034744832 flags 129
[23235.361816] BTRFS info (device dm-9): found 61920 extents
[23252.948433] BTRFS info (device dm-9): found 61920 extents
[23254.622630] BTRFS info (device dm-9): relocating block group 772163108864 flags 129
[23520.560068] INFO: task btrfs-transacti:7371 blocked for more than 120 seconds.
[23520.560084]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[23520.560089] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23520.560092] btrfs-transacti D ffff88006e326880     0  7371      2 0x00000080
[23520.560102]  ffff880059c53bc0 0000000000000046 ffff880059c53fd8 ffff88006e326350
[23520.560113]  00000000000141c0 ffff88006e326350 ffff88007fc141c0 ffff88006e326350
[23520.560124]  ffff880059c53c60 ffffffff810fe5f2 0000000000000002 ffff880059c53bd0
[23520.560141] Call Trace:
[23520.560151]  [<ffffffff810fe5f2>] ? wait_on_page_read+0x3c/0x3c
[23520.560158]  [<ffffffff8160c331>] schedule+0x73/0x75
[23520.560163]  [<ffffffff8160c4d6>] io_schedule+0x60/0x7a
[23520.560169]  [<ffffffff810fe600>] sleep_on_page+0xe/0x12
[23520.560174]  [<ffffffff8160c768>] __wait_on_bit+0x48/0x7a
[23520.560179]  [<ffffffff810fe5a0>] wait_on_page_bit+0x7a/0x7c
[23520.560186]  [<ffffffff810850fd>] ? autoremove_wake_function+0x34/0x34
[23520.560192]  [<ffffffff81109c3d>] ? pagevec_lookup_tag+0x21/0x29
[23520.560198]  [<ffffffff810ff090>] filemap_fdatawait_range+0x7e/0x126
[23520.560205]  [<ffffffff8122abde>] btrfs_wait_marked_extents+0x7d/0xcd
[23520.560211]  [<ffffffff8122aca3>] btrfs_write_and_wait_transaction+0x75/0x87
[23520.560217]  [<ffffffff8122b423>] btrfs_commit_transaction+0x65c/0x849
[23520.560223]  [<ffffffff810850c9>] ? finish_wait+0x65/0x65
[23520.560228]  [<ffffffff812277ca>] transaction_kthread+0xf8/0x1ab
[23520.560238]  [<ffffffff812276d2>] ? btrfs_cleanup_transaction+0x43f/0x43f
[23520.560242]  [<ffffffff8106bc56>] kthread+0xae/0xb6
[23520.560246]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[23520.560251]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[23520.560254]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[23640.564048] INFO: task jbd2/sda6-8:1018 blocked for more than 120 seconds.
[23640.564065]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[23640.564069] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23640.564072] jbd2/sda6-8     D ffff88007a2f0a80     0  1018      2 0x00000000
[23640.564082]  ffff880078c99cc0 0000000000000046 ffff880078c99fd8 ffff88007a2f0550
[23640.564094]  00000000000141c0 ffff88007a2f0550 ffff880078c99d88 ffff88006c6ad4a0
[23640.564104]  ffff880078c99da0 ffff880078db3800 ffff88006c6ad440 ffff880078c99cd0
[23640.564120] Call Trace:
[23640.564130]  [<ffffffff8160c331>] schedule+0x73/0x75
[23640.564137]  [<ffffffff811f9317>] jbd2_journal_commit_transaction+0x270/0x14cf
[23640.564143]  [<ffffffff8107d766>] ? update_entity_load_avg+0x270/0x27f
[23640.564150]  [<ffffffff81015eed>] ? paravirt_read_tsc+0x9/0xd
[23640.564156]  [<ffffffff81015efa>] ? paravirt_sched_clock+0x9/0xd
[23640.564162]  [<ffffffff8107b383>] ? sched_clock_cpu+0xb5/0xd7
[23640.564168]  [<ffffffff810850c9>] ? finish_wait+0x65/0x65
[23640.564174]  [<ffffffff81059bd4>] ? lock_timer_base.isra.24+0x2b/0x4f
[23640.564180]  [<ffffffff81059cab>] ? try_to_del_timer_sync+0x55/0x5f
[23640.564186]  [<ffffffff811fea06>] kjournald2+0xc0/0x232
[23640.564191]  [<ffffffff810850c9>] ? finish_wait+0x65/0x65
[23640.564196]  [<ffffffff811fe946>] ? get_slab+0x47/0x47
[23640.564202]  [<ffffffff8106bc56>] kthread+0xae/0xb6
[23640.564208]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[23640.564215]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[23640.564220]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[23640.564248] INFO: task nscd:3917 blocked for more than 120 seconds.
[23640.564251]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[23640.564253] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23640.564255] nscd            D ffff88006d2e2c40     0  3917      1 0x00000080
[23640.564263]  ffff88006bd07aa8 0000000000000086 ffff88006bd07fd8 ffff88006d2e2710
[23640.564275]  00000000000141c0 ffff88006d2e2710 ffff880078db3800 0000000000000000
[23640.564284]  ffff880078db3870 0000000000015afd ffff88006c6ad440 ffff88006bd07ab8
[23640.564291] Call Trace:
[23640.564295]  [<ffffffff8160c331>] schedule+0x73/0x75
[23640.564299]  [<ffffffff811f6932>] wait_transaction_locked+0x8e/0xa7
[23640.564303]  [<ffffffff810850c9>] ? finish_wait+0x65/0x65
[23640.564307]  [<ffffffff811f6ecf>] start_this_handle+0x2e6/0x4bf
[23640.564312]  [<ffffffff8114118d>] ? kmem_cache_alloc+0xe3/0x161
[23640.564315]  [<ffffffff811f716c>] jbd2__journal_start+0xc4/0x19d
[23640.564320]  [<ffffffff811c4183>] ? ext4_dirty_inode+0x2a/0x59
[23640.564324]  [<ffffffff811e43d6>] __ext4_journal_start_sb+0x97/0xbb
[23640.564328]  [<ffffffff811c4183>] ext4_dirty_inode+0x2a/0x59
[23640.564333]  [<ffffffff81176cb6>] __mark_inode_dirty+0x68/0x23b
[23640.564337]  [<ffffffff8116997d>] update_time+0xab/0xb4
[23640.564343]  [<ffffffff8116a3df>] file_update_time+0x96/0xb2
[23640.564347]  [<ffffffff811c434a>] ext4_page_mkwrite+0x56/0x2ae
[23640.564351]  [<ffffffff811205d3>] do_wp_page+0x175/0x574
[23640.564355]  [<ffffffff81122b43>] handle_mm_fault+0x8df/0x9b0
[23640.564359]  [<ffffffff8111f4d1>] ? tlb_flush_mmu+0x58/0x75
[23640.564363]  [<ffffffff81611e78>] __do_page_fault+0x393/0x3df
[23640.564366]  [<ffffffff8113f9d1>] ? __cache_free.isra.39+0x1b4/0x1c3
[23640.564371]  [<ffffffff8131e669>] ? __percpu_counter_add+0x71/0x8b
[23640.564375]  [<ffffffff8112513a>] ? vm_acct_memory+0x19/0x1b
[23640.564379]  [<ffffffff81126d39>] ? do_munmap+0x2bb/0x2dc
[23640.564383]  [<ffffffff81611ed2>] do_page_fault+0xe/0x10
[23640.564386]  [<ffffffff8160f478>] page_fault+0x28/0x30
[23640.564390] INFO: task nscd:3918 blocked for more than 120 seconds.
[23640.564392]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[23640.564395] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23640.564397] nscd            D ffff88006cc64880     0  3918      1 0x00000080
[23640.564403]  ffff88006bd2dde0 0000000000000086 ffff88006bd2dfd8 ffff88006cc64350
[23640.564410]  00000000000141c0 ffff88006cc64350 ffff88007b1fd460 ffff88006cc64350
[23640.564419]  ffffffff00000001 ffff88007b1fd468 ffffffffffffffff ffff88006bd2ddf0
[23640.564427] Call Trace:
[23640.564431]  [<ffffffff8160c331>] schedule+0x73/0x75
[23640.564435]  [<ffffffff8160e20a>] rwsem_down_write_failed+0x118/0x19a
[23640.564440]  [<ffffffff8130af63>] call_rwsem_down_write_failed+0x13/0x20
[23640.564444]  [<ffffffff81296fb8>] ? cap_mmap_addr+0x49/0x49
[23640.564448]  [<ffffffff8160dcb9>] ? down_write+0x24/0x26
[23640.564453]  [<ffffffff811166e2>] vm_mmap_pgoff+0x5a/0xaf
[23640.564456]  [<ffffffff8116bd38>] ? __fget+0x6f/0x79
[23640.564460]  [<ffffffff81126704>] SyS_mmap_pgoff+0x188/0x1d4
[23640.564464]  [<ffffffff8101368a>] SyS_mmap+0x1b/0x27
[23640.564468]  [<ffffffff816154ad>] system_call_fastpath+0x1a/0x1f
[23640.564483] INFO: task btrfs-transacti:7371 blocked for more than 120 seconds.
[23640.564486]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[23640.564488] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23640.564491] btrfs-transacti D ffff88006e326880     0  7371      2 0x00000080
[23640.564496]  ffff880059c53bc0 0000000000000046 ffff880059c53fd8 ffff88006e326350
[23640.564504]  00000000000141c0 ffff88006e326350 ffff88007fc141c0 ffff88006e326350
[23640.564511]  ffff880059c53c60 ffffffff810fe5f2 0000000000000002 ffff880059c53bd0
[23640.564518] Call Trace:
[23640.564522]  [<ffffffff810fe5f2>] ? wait_on_page_read+0x3c/0x3c
[23640.564526]  [<ffffffff8160c331>] schedule+0x73/0x75
[23640.564529]  [<ffffffff8160c4d6>] io_schedule+0x60/0x7a
[23640.564533]  [<ffffffff810fe600>] sleep_on_page+0xe/0x12
[23640.564536]  [<ffffffff8160c768>] __wait_on_bit+0x48/0x7a
[23640.564540]  [<ffffffff810fe5a0>] wait_on_page_bit+0x7a/0x7c
[23640.564544]  [<ffffffff810850fd>] ? autoremove_wake_function+0x34/0x34
[23640.564548]  [<ffffffff81109c3d>] ? pagevec_lookup_tag+0x21/0x29
[23640.564552]  [<ffffffff810ff090>] filemap_fdatawait_range+0x7e/0x126
[23640.564557]  [<ffffffff8122abde>] btrfs_wait_marked_extents+0x7d/0xcd
[23640.564561]  [<ffffffff8122aca3>] btrfs_write_and_wait_transaction+0x75/0x87
[23640.564565]  [<ffffffff8122b423>] btrfs_commit_transaction+0x65c/0x849
[23640.564568]  [<ffffffff810850c9>] ? finish_wait+0x65/0x65
[23640.564572]  [<ffffffff812277ca>] transaction_kthread+0xf8/0x1ab
[23640.564576]  [<ffffffff812276d2>] ? btrfs_cleanup_transaction+0x43f/0x43f
[23640.564580]  [<ffffffff8106bc56>] kthread+0xae/0xb6
[23640.564584]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[23640.564588]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[23640.564591]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[23640.564595] INFO: task btrfs-endio-wri:7519 blocked for more than 120 seconds.
[23640.564597]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[23640.564600] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23640.564602] btrfs-endio-wri D ffff88004d62c6c0     0  7519      2 0x00000080
[23640.564608]  ffff88001181bb70 0000000000000046 ffff88001181bfd8 ffff88004d62c190
[23640.564615]  00000000000141c0 ffff88004d62c190 ffff88007be0e5b0 ffff88007be0e5b4
[23640.564623]  ffff88004d62c190 ffff88007be0e5b8 00000000ffffffff ffff88001181bb80
[23640.564630] Call Trace:
[23640.564634]  [<ffffffff8160c331>] schedule+0x73/0x75
[23640.564637]  [<ffffffff8160c5f2>] schedule_preempt_disabled+0x18/0x24
[23640.564641]  [<ffffffff8160d129>] __mutex_lock_slowpath+0x158/0x1cf
[23640.564645]  [<ffffffff8160d1b7>] mutex_lock+0x17/0x27
[23640.564649]  [<ffffffff81100016>] generic_file_aio_write+0x43/0xc3
[23640.564655]  [<ffffffff811bb398>] ext4_file_write+0x394/0x3c0
[23640.564659]  [<ffffffff8108911d>] ? cpuacct_charge+0x4c/0x53
[23640.564662]  [<ffffffff8107e08c>] ? update_curr+0xcd/0x13f
[23640.564666]  [<ffffffff8107ce76>] ? update_stats_wait_end+0x7c/0xdb
[23640.564670]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[23640.564674]  [<ffffffff81154e98>] do_sync_write+0x59/0x78
[23640.564679]  [<ffffffff810b35bf>] do_acct_process+0x30b/0x393
[23640.564683]  [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
[23640.564687]  [<ffffffff810b3bef>] acct_process+0x77/0x92
[23640.564693]  [<ffffffff810520f4>] do_exit+0x3a0/0x938
[23640.564696]  [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
[23640.564700]  [<ffffffff8106bc5e>] kthread+0xb6/0xb6
[23640.564704]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[23640.564707]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[23640.564711]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[23640.564715] INFO: task btrfs:18919 blocked for more than 120 seconds.
[23640.564718]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[23640.564720] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23640.564722] btrfs           D ffff88007b500840     0 18919   6108 0x00000084
[23640.564728]  ffff880031ee9150 0000000000000086 ffff880031ee9fd8 ffff88005c348210
[23640.564735]  00000000000141c0 ffff88005c348210 ffff88007fc141c0 ffff88005c348210
[23640.564741]  ffff880031ee91f0 ffffffff810fe5f2 0000000000000002 ffff880031ee9160
[23640.564748] Call Trace:
[23640.564752]  [<ffffffff810fe5f2>] ? wait_on_page_read+0x3c/0x3c
[23640.564756]  [<ffffffff8160c331>] schedule+0x73/0x75
[23640.564759]  [<ffffffff8160c4d6>] io_schedule+0x60/0x7a
[23640.564762]  [<ffffffff810fe600>] sleep_on_page+0xe/0x12
[23640.564766]  [<ffffffff8160c768>] __wait_on_bit+0x48/0x7a
[23640.564770]  [<ffffffff810fe5a0>] wait_on_page_bit+0x7a/0x7c
[23640.564773]  [<ffffffff810850fd>] ? autoremove_wake_function+0x34/0x34
[23640.564777]  [<ffffffff81245ea2>] read_extent_buffer_pages+0x1bf/0x204
[23640.564781]  [<ffffffff81223942>] ? free_root_pointers+0x5b/0x5b
[23640.564785]  [<ffffffff81224644>] btree_read_extent_buffer_pages.constprop.45+0x66/0x100
[23640.564789]  [<ffffffff81225599>] read_tree_block+0x2f/0x47
[23640.564794]  [<ffffffff8120e6e8>] read_block_for_search.isra.26+0x24a/0x287
[23640.564797]  [<ffffffff8120ff29>] btrfs_search_slot+0x4f4/0x6bb
[23640.564801]  [<ffffffff81140d66>] ? ____cache_alloc_node+0xf1/0x134
[23640.564805]  [<ffffffff81220d07>] btrfs_lookup_csum+0x5e/0xfb
[23640.564809]  [<ffffffff81220fdb>] __btrfs_lookup_bio_sums+0x237/0x3fe
[23640.564813]  [<ffffffff812213a8>] btrfs_lookup_bio_sums+0x16/0x18
[23640.564816]  [<ffffffff8122cfde>] btrfs_submit_bio_hook+0xc5/0x152
[23640.564829]  [<ffffffffa048c6fd>] ? dm_merge_bvec+0xaa/0xca [dm_mod]
[23640.564833]  [<ffffffff8124035b>] submit_one_bio+0x8a/0xc0
[23640.564837]  [<ffffffff81242b68>] submit_extent_page.isra.19+0x9d/0x182
[23640.564841]  [<ffffffff81243c5c>] __do_readpage+0x439/0x4ef
[23640.564844]  [<ffffffff81242ee5>] ? repair_eb_io_failure+0x93/0x93
[23640.564848]  [<ffffffff8122eed5>] ? btrfs_submit_direct+0x3f4/0x3f4
[23640.564852]  [<ffffffff81243e9e>] __do_contiguous_readpages.constprop.23+0xc3/0xe3
[23640.564856]  [<ffffffff8122eed5>] ? btrfs_submit_direct+0x3f4/0x3f4
[23640.564859]  [<ffffffff81243fb8>] __extent_readpages.constprop.22+0xfa/0x109
[23640.564863]  [<ffffffff8110a8d9>] ? __lru_cache_add+0x5d/0x73
[23640.564867]  [<ffffffff8122eed5>] ? btrfs_submit_direct+0x3f4/0x3f4
[23640.564870]  [<ffffffff81244c39>] extent_readpages+0x10e/0x1a4
[23640.564874]  [<ffffffff8122d59d>] btrfs_readpages+0x1f/0x21
[23640.564878]  [<ffffffff8110916a>] __do_page_cache_readahead+0x15c/0x1f8
[23640.564882]  [<ffffffff8110944b>] ra_submit+0x21/0x25
[23640.564885]  [<ffffffff81109667>] ondemand_readahead+0x218/0x240
[23640.564889]  [<ffffffff810fec39>] ? find_get_page+0x69/0x75
[23640.564893]  [<ffffffff811096cc>] page_cache_sync_readahead+0x3d/0x3f
[23640.564897]  [<ffffffff81266d69>] relocate_file_extent_cluster+0x136/0x32c
[23640.564901]  [<ffffffff81266ff1>] relocate_data_extent+0x92/0xa7
[23640.564904]  [<ffffffff8126aa58>] relocate_block_group+0x2b2/0x49a
[23640.564908]  [<ffffffff8123f526>] ? btrfs_wait_ordered_roots+0x107/0x140
[23640.564912]  [<ffffffff8126ad98>] btrfs_relocate_block_group+0x158/0x26a
[23640.564916]  [<ffffffff81249544>] btrfs_relocate_chunk.isra.23+0x5c/0x5e8
[23640.564920]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[23640.564923]  [<ffffffff812452f7>] ? free_extent_buffer+0x8a/0x8d
[23640.564927]  [<ffffffff8124bdca>] btrfs_balance+0x9b6/0xb74
[23640.564931]  [<ffffffff812523b9>] btrfs_ioctl_balance+0x23e/0x2b7
[23640.564935]  [<ffffffff81255fa9>] btrfs_ioctl+0x1223/0x24b1
[23640.564938]  [<ffffffff811610e4>] ? path_openat+0x237/0x4de
[23640.564942]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[23640.564946]  [<ffffffff81611e15>] ? __do_page_fault+0x330/0x3df
[23640.564949]  [<ffffffff81125bc6>] ? vma_link+0x74/0x93
[23640.564953]  [<ffffffff81163b16>] do_vfs_ioctl+0x3d2/0x41d
[23640.564956]  [<ffffffff81163bb8>] SyS_ioctl+0x57/0x82
[23640.564960]  [<ffffffff81611ed2>] ? do_page_fault+0xe/0x10
[23640.564964]  [<ffffffff816154ad>] system_call_fastpath+0x1a/0x1f
[23640.564967] INFO: task btrfs-worker-3:18929 blocked for more than 120 seconds.
[23640.564969]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[23640.564972] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23640.564974] btrfs-worker-3  D ffff88004dc08b40     0 18929      2 0x00000080
[23640.564979]  ffff88000d2b1b70 0000000000000046 ffff88000d2b1fd8 ffff88004dc08610
[23640.564986]  00000000000141c0 ffff88004dc08610 ffff88007be0e5b0 ffff88007be0e5b4
[23640.564993]  ffff88004dc08610 ffff88007be0e5b8 00000000ffffffff ffff88000d2b1b80
[23640.565000] Call Trace:
[23640.565004]  [<ffffffff8160c331>] schedule+0x73/0x75
[23640.565007]  [<ffffffff8160c5f2>] schedule_preempt_disabled+0x18/0x24
[23640.565011]  [<ffffffff8160d129>] __mutex_lock_slowpath+0x158/0x1cf
[23640.565015]  [<ffffffff8160d1b7>] mutex_lock+0x17/0x27
[23640.565018]  [<ffffffff81100016>] generic_file_aio_write+0x43/0xc3
[23640.565022]  [<ffffffff811bb398>] ext4_file_write+0x394/0x3c0
[23640.565026]  [<ffffffff81015eed>] ? paravirt_read_tsc+0x9/0xd
[23640.565030]  [<ffffffff81016495>] ? native_sched_clock+0x34/0x36
[23640.565033]  [<ffffffff8107ce76>] ? update_stats_wait_end+0x7c/0xdb
[23640.565037]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[23640.565041]  [<ffffffff81154e98>] do_sync_write+0x59/0x78
[23640.565045]  [<ffffffff810b35bf>] do_acct_process+0x30b/0x393
[23640.565049]  [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
[23640.565052]  [<ffffffff810b3bef>] acct_process+0x77/0x92
[23640.565056]  [<ffffffff810520f4>] do_exit+0x3a0/0x938
[23640.565059]  [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
[23640.565063]  [<ffffffff8106bc5e>] kthread+0xb6/0xb6
[23640.565067]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[23640.565070]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[23640.565074]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[23640.565079] INFO: task btrfs-endio-4:19488 blocked for more than 120 seconds.
[23640.565083]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[23640.565086] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23640.565088] btrfs-endio-4   D ffff88003c1e2580     0 19488      2 0x00000080
[23640.565093]  ffff880067cb3b70 0000000000000046 ffff880067cb3fd8 ffff88003c1e2050
[23640.565102]  00000000000141c0 ffff88003c1e2050 ffff88007be0e5b0 ffff88007be0e5b4
[23640.565109]  ffff88003c1e2050 ffff88007be0e5b8 00000000ffffffff ffff880067cb3b80
[23640.565116] Call Trace:
[23640.565120]  [<ffffffff8160c331>] schedule+0x73/0x75
[23640.565123]  [<ffffffff8160c5f2>] schedule_preempt_disabled+0x18/0x24
[23640.565127]  [<ffffffff8160d129>] __mutex_lock_slowpath+0x158/0x1cf
[23640.565131]  [<ffffffff8160d1b7>] mutex_lock+0x17/0x27
[23640.565135]  [<ffffffff81100016>] generic_file_aio_write+0x43/0xc3
[23640.565139]  [<ffffffff811bb398>] ext4_file_write+0x394/0x3c0
[23640.565142]  [<ffffffff8108911d>] ? cpuacct_charge+0x4c/0x53
[23640.565145]  [<ffffffff8107e08c>] ? update_curr+0xcd/0x13f
[23640.565149]  [<ffffffff8107ce76>] ? update_stats_wait_end+0x7c/0xdb
[23640.565153]  [<ffffffff8130536e>] ? rb_erase+0x28e/0x295
[23640.565156]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[23640.565160]  [<ffffffff81154e98>] do_sync_write+0x59/0x78
[23640.565164]  [<ffffffff810b35bf>] do_acct_process+0x30b/0x393
[23640.565168]  [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
[23640.565171]  [<ffffffff810b3bef>] acct_process+0x77/0x92
[23640.565175]  [<ffffffff810520f4>] do_exit+0x3a0/0x938
[23640.565178]  [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
[23640.565182]  [<ffffffff8106bc5e>] kthread+0xb6/0xb6
[23640.565186]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[23640.565189]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[23640.565193]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[23640.565196] INFO: task btrfs-endio-wri:19490 blocked for more than 120 seconds.
[23640.565199]       Not tainted 3.14.0-rc5-amd64-i915-preempt-20140216c #1
[23640.565201] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[23640.565203] btrfs-endio-wri D ffff8800006c05c0     0 19490      2 0x00000080
[23640.565209]  ffff880000b47b70 0000000000000046 ffff880000b47fd8 ffff8800006c0090
[23640.565216]  00000000000141c0 ffff8800006c0090 ffff88007be0e5b0 ffff88007be0e5b4
[23640.565222]  ffff8800006c0090 ffff88007be0e5b8 00000000ffffffff ffff880000b47b80
[23640.565229] Call Trace:
[23640.565233]  [<ffffffff8160c331>] schedule+0x73/0x75
[23640.565237]  [<ffffffff8160c5f2>] schedule_preempt_disabled+0x18/0x24
[23640.565240]  [<ffffffff8160d129>] __mutex_lock_slowpath+0x158/0x1cf
[23640.565244]  [<ffffffff8160d1b7>] mutex_lock+0x17/0x27
[23640.565248]  [<ffffffff81100016>] generic_file_aio_write+0x43/0xc3
[23640.565251]  [<ffffffff811bb398>] ext4_file_write+0x394/0x3c0
[23640.565255]  [<ffffffff8108911d>] ? cpuacct_charge+0x4c/0x53
[23640.565258]  [<ffffffff8107ce76>] ? update_stats_wait_end+0x7c/0xdb
[23640.565262]  [<ffffffff8160ea0b>] ? _raw_spin_unlock+0x17/0x2a
[23640.565266]  [<ffffffff81154e98>] do_sync_write+0x59/0x78
[23640.565270]  [<ffffffff810b35bf>] do_acct_process+0x30b/0x393
[23640.565275]  [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
[23640.565279]  [<ffffffff810b3bef>] acct_process+0x77/0x92
[23640.565284]  [<ffffffff810520f4>] do_exit+0x3a0/0x938
[23640.565288]  [<ffffffff812505d7>] ? btrfs_queue_worker+0x283/0x283
[23640.565291]  [<ffffffff8106bc5e>] kthread+0xb6/0xb6
[23640.565295]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61
[23640.565299]  [<ffffffff816153fc>] ret_from_fork+0x7c/0xb0
[23640.565303]  [<ffffffff8106bba8>] ? __kthread_parkme+0x61/0x61

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
