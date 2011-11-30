From: Tobias <tracer@robotech.de>
Subject: Re: Blocked for more than 120 seconds
Date: Wed, 30 Nov 2011 10:44:15 +0100
Message-ID: <4ED5FAEF.8070400@robotech.de>
References: <4ED34359.6010305@robotech.de> <1322472549.1962.2.camel@Nokia-N900>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1322472549.1962.2.camel@Nokia-N900>
List-ID: <linux-btrfs.vger.kernel.org>

Am 28.11.2011 10:29, schrieb Chris Samuel:
> Hi Tobias,
>
> On Mon, 28 Nov 2011, 19:16:25 EST, Tobias<tracer@robotech.de>  wrote:
>
>> The problem occurs on the stock ubuntu kernel 2.6.38-8, 3.0.0-12,
>> 3.0.0-13 and on my self-compiled 3.1.2.
> There's a lot of work gone into btrfs in 3.2,
> it would be interesting to know (speaking as
> just another user) whether it still occurs
> with 3.2-rc3.
>
I tried 3.2-rc3 tonight but the messages are still there:

[46203.412044] INFO: task rsync:1653 blocked for more than 120 seconds.
[46203.412056] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[46203.412066] rsync           D ffff8801d7d51aa0     0  1653   1647 
0x00000000
[46203.412073]  ffff8800042b1d98 0000000000000086 0000000000000000 
0000000000000000
[46203.412079]  ffff8801d7d516e0 ffff8800042b1fd8 ffff8800042b1fd8 
ffff8800042b1fd8
[46203.412084]  ffff88023212db80 ffff8801d7d516e0 0000000000000282 
0000000122103228
[46203.412090] Call Trace:
[46203.412101]  [<ffffffff8161259f>] schedule+0x3f/0x60
[46203.412126]  [<ffffffffa01fd1bd>] 
wait_current_trans.isra.22+0x9d/0x100 [btrfs]
[46203.412132]  [<ffffffff81085a40>] ? add_wait_queue+0x60/0x60
[46203.412148]  [<ffffffffa01fe7f5>] start_transaction+0x135/0x2b0 [btrfs]
[46203.412154]  [<ffffffff8117bd5a>] ? kern_path_create+0x8a/0x120
[46203.412171]  [<ffffffffa01fec43>] btrfs_start_transaction+0x13/0x20 
[btrfs]
[46203.412188]  [<ffffffffa020a885>] btrfs_link+0xa5/0x1a0 [btrfs]
[46203.412193]  [<ffffffff81178a91>] vfs_link+0x101/0x190
[46203.412197]  [<ffffffff8117ce88>] sys_linkat+0x168/0x180
[46203.412200]  [<ffffffff8117cebe>] sys_link+0x1e/0x20
[46203.412205]  [<ffffffff8161c442>] system_call_fastpath+0x16/0x1b
[46563.412042] INFO: task btrfs-delalloc-:31614 blocked for more than 
120 seconds.
[46563.412054] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[46563.412064] btrfs-delalloc- D ffff8801f8529aa0     0 31614      2 
0x00000000
[46563.412071]  ffff8801330bdc50 0000000000000046 0000000000000000 
0000000000000004
[46563.412077]  ffff8801f85296e0 ffff8801330bdfd8 ffff8801330bdfd8 
ffff8801330bdfd8
[46563.412082]  ffff88023212db80 ffff8801f85296e0 0000000000000282 
0000000122103228
[46563.412088] Call Trace:
[46563.412098]  [<ffffffff8161259f>] schedule+0x3f/0x60
[46563.412124]  [<ffffffffa01fd1bd>] 
wait_current_trans.isra.22+0x9d/0x100 [btrfs]
[46563.412130]  [<ffffffff81085a40>] ? add_wait_queue+0x60/0x60
[46563.412146]  [<ffffffffa01fe8b0>] start_transaction+0x1f0/0x2b0 [btrfs]
[46563.412163]  [<ffffffffa01fe9c5>] btrfs_join_transaction+0x15/0x20 
[btrfs]
[46563.412179]  [<ffffffffa0206423>] compress_file_range+0x2d3/0x610 [btrfs]
[46563.412197]  [<ffffffffa0206795>] async_cow_start+0x35/0x50 [btrfs]
[46563.412213]  [<ffffffffa02269ba>] worker_loop+0x16a/0x560 [btrfs]
[46563.412231]  [<ffffffffa0226850>] ? btrfs_queue_worker+0x300/0x300 
[btrfs]
[46563.412236]  [<ffffffff81084fac>] kthread+0x8c/0xa0
[46563.412241]  [<ffffffff8161e5b4>] kernel_thread_helper+0x4/0x10
[46563.412246]  [<ffffffff81084f20>] ? flush_kthread_worker+0xa0/0xa0
[46563.412250]  [<ffffffff8161e5b0>] ? gs_change+0x13/0x13
[46563.412255] INFO: task flush-btrfs-1:323 blocked for more than 120 
seconds.
[46563.412263] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[46563.412273] flush-btrfs-1   D ffff8802129bb180     0   323      2 
0x00000000
[46563.412278]  ffff8800209c58e0 0000000000000046 ffff880000000000 
ffff8800218a2710
[46563.412284]  ffff8802129badc0 ffff8800209c5fd8 ffff8800209c5fd8 
ffff8800209c5fd8
[46563.412290]  ffff8802321444a0 ffff8802129badc0 ffff8800209c58e0 
000000018108f20d
[46563.412295] Call Trace:
[46563.412300]  [<ffffffff8110dc90>] ? __lock_page+0x70/0x70
[46563.412305]  [<ffffffff8161259f>] schedule+0x3f/0x60
[46563.412309]  [<ffffffff8161264f>] io_schedule+0x8f/0xd0
[46563.412313]  [<ffffffff8110dc9e>] sleep_on_page+0xe/0x20
[46563.412317]  [<ffffffff81612d1a>] __wait_on_bit_lock+0x5a/0xc0
[46563.412321]  [<ffffffff8110dc87>] __lock_page+0x67/0x70
[46563.412325]  [<ffffffff81085a80>] ? autoremove_wake_function+0x40/0x40
[46563.412342]  [<ffffffffa021c945>] 
extent_write_cache_pages.isra.21.constprop.31+0x215/0x3f0 [btrfs]
[46563.412361]  [<ffffffffa021cd65>] extent_writepages+0x45/0x60 [btrfs]
[46563.412378]  [<ffffffffa0201350>] ? acls_after_inode_item+0xc0/0xc0 
[btrfs]
[46563.412382]  [<ffffffff81085614>] ? bit_waitqueue+0x14/0xc0
[46563.412398]  [<ffffffffa0200448>] btrfs_writepages+0x28/0x30 [btrfs]
[46563.412403]  [<ffffffff811195f1>] do_writepages+0x21/0x40
[46563.412409]  [<ffffffff81194c70>] writeback_single_inode+0x180/0x430
[46563.412413]  [<ffffffff81195336>] writeback_sb_inodes+0x1b6/0x270
[46563.412418]  [<ffffffff8119548e>] __writeback_inodes_wb+0x9e/0xd0
[46563.412422]  [<ffffffff8119573b>] wb_writeback+0x27b/0x330
[46563.412427]  [<ffffffff81187352>] ? get_nr_dirty_inodes+0x52/0x80
[46563.412432]  [<ffffffff8119588f>] wb_check_old_data_flush+0x9f/0xb0
[46563.412436]  [<ffffffff81196731>] wb_do_writeback+0x151/0x1d0
[46563.412441]  [<ffffffff81611fd4>] ? __schedule+0x3d4/0x8d0
[46563.412446]  [<ffffffff81071ae0>] ? usleep_range+0x50/0x50
[46563.412450]  [<ffffffff81196833>] bdi_writeback_thread+0x83/0x2a0
[46563.412455]  [<ffffffff811967b0>] ? wb_do_writeback+0x1d0/0x1d0
[46563.412459]  [<ffffffff81084fac>] kthread+0x8c/0xa0
[46563.412463]  [<ffffffff8161e5b4>] kernel_thread_helper+0x4/0x10
[46563.412468]  [<ffffffff81084f20>] ? flush_kthread_worker+0xa0/0xa0
[46563.412472]  [<ffffffff8161e5b0>] ? gs_change+0x13/0x13
[46563.412475] INFO: task rsync:1653 blocked for more than 120 seconds.
[46563.412483] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[46563.412493] rsync           D ffff8801d7d51aa0     0  1653   1647 
0x00000000
[46563.412498]  ffff8800042b1d98 0000000000000086 0000000000000000 
0000000000000000
[46563.412504]  ffff8801d7d516e0 ffff8800042b1fd8 ffff8800042b1fd8 
ffff8800042b1fd8
[46563.412510]  ffff88023212db80 ffff8801d7d516e0 0000000000000282 
0000000122103228
[46563.412515] Call Trace:
[46563.412520]  [<ffffffff8161259f>] schedule+0x3f/0x60
[46563.412535]  [<ffffffffa01fd1bd>] 
wait_current_trans.isra.22+0x9d/0x100 [btrfs]
[46563.412540]  [<ffffffff81085a40>] ? add_wait_queue+0x60/0x60
[46563.412555]  [<ffffffffa01fe7f5>] start_transaction+0x135/0x2b0 [btrfs]
[46563.412561]  [<ffffffff8117bd5a>] ? kern_path_create+0x8a/0x120
[46563.412577]  [<ffffffffa01fec43>] btrfs_start_transaction+0x13/0x20 
[btrfs]
[46563.412594]  [<ffffffffa020a885>] btrfs_link+0xa5/0x1a0 [btrfs]
[46563.412599]  [<ffffffff81178a91>] vfs_link+0x101/0x190
[46563.412603]  [<ffffffff8117ce88>] sys_linkat+0x168/0x180
[46563.412606]  [<ffffffff8117cebe>] sys_link+0x1e/0x20
[46563.412610]  [<ffffffff8161c442>] system_call_fastpath+0x16/0x1b
[46563.412616] INFO: task rsync:2240 blocked for more than 120 seconds.
[46563.412624] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[46563.412633] rsync           D ffff8802286d1aa0     0  2240   1760 
0x00000000
[46563.412638]  ffff88001b9b7d98 0000000000000086 0000000000000000 
0000000000000000
[46563.412644]  ffff8802286d16e0 ffff88001b9b7fd8 ffff88001b9b7fd8 
ffff88001b9b7fd8
[46563.412650]  ffff88023212db80 ffff8802286d16e0 0000000000000282 
0000000122103228
[46563.412655] Call Trace:
[46563.412660]  [<ffffffff8161259f>] schedule+0x3f/0x60
[46563.412676]  [<ffffffffa01fd1bd>] 
wait_current_trans.isra.22+0x9d/0x100 [btrfs]
[46563.412680]  [<ffffffff81085a40>] ? add_wait_queue+0x60/0x60
[46563.412696]  [<ffffffffa01fe7f5>] start_transaction+0x135/0x2b0 [btrfs]
[46563.412700]  [<ffffffff8117bd5a>] ? kern_path_create+0x8a/0x120
[46563.412716]  [<ffffffffa01fec43>] btrfs_start_transaction+0x13/0x20 
[btrfs]
[46563.412733]  [<ffffffffa020a885>] btrfs_link+0xa5/0x1a0 [btrfs]
[46563.412738]  [<ffffffff81178a91>] vfs_link+0x101/0x190
[46563.412742]  [<ffffffff8117ce88>] sys_linkat+0x168/0x180
[46563.412746]  [<ffffffff8117cebe>] sys_link+0x1e/0x20
[46563.412749]  [<ffffffff8161c442>] system_call_fastpath+0x16/0x1b
[46563.412754] INFO: task rsync:2257 blocked for more than 120 seconds.
[46563.412762] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[46563.412771] rsync           D ffff880232145f40     0  2257   2254 
0x00000000
[46563.412777]  ffff88009c5c3b58 0000000000000086 ffff880000000000 
ffffffff8108572e
[46563.412782]  ffff880232145b80 ffff88009c5c3fd8 ffff88009c5c3fd8 
ffff88009c5c3fd8
[46563.412788]  ffff880232128000 ffff880232145b80 0000000000000286 
0000000122103228
[46563.412793] Call Trace:
[46563.412797]  [<ffffffff8108572e>] ? wake_up_bit+0x2e/0x40
[46563.412802]  [<ffffffff8161259f>] schedule+0x3f/0x60
[46563.412818]  [<ffffffffa01fd1bd>] 
wait_current_trans.isra.22+0x9d/0x100 [btrfs]
[46563.412822]  [<ffffffff81085a40>] ? add_wait_queue+0x60/0x60
[46563.412838]  [<ffffffffa01fe8b0>] start_transaction+0x1f0/0x2b0 [btrfs]
[46563.412854]  [<ffffffffa01fe9c5>] btrfs_join_transaction+0x15/0x20 
[btrfs]
[46563.412871]  [<ffffffffa0209368>] btrfs_dirty_inode+0x48/0x160 [btrfs]
[46563.412876]  [<ffffffff81194440>] __mark_inode_dirty+0x40/0x230
[46563.412880]  [<ffffffff81185814>] file_update_time+0xe4/0x150
[46563.412897]  [<ffffffffa020d500>] btrfs_file_aio_write+0x1c0/0x510 
[btrfs]
[46563.412903]  [<ffffffff8125e857>] ? jbd2_journal_stop+0x1b7/0x2a0
[46563.412908]  [<ffffffff81177d03>] ? putname+0x33/0x50
[46563.412913]  [<ffffffff8116c422>] do_sync_write+0xd2/0x110
[46563.412918]  [<ffffffff812d5e98>] ? apparmor_file_permission+0x18/0x20
[46563.412924]  [<ffffffff8129c57c>] ? security_file_permission+0x2c/0xb0
[46563.412928]  [<ffffffff8116c9b1>] ? rw_verify_area+0x61/0xf0
[46563.412932]  [<ffffffff8116cd13>] vfs_write+0xb3/0x180
[46563.412936]  [<ffffffff8116d03a>] sys_write+0x4a/0x90
[46563.412940]  [<ffffffff8161c442>] system_call_fastpath+0x16/0x1b

Can anyone help?

Tobias

