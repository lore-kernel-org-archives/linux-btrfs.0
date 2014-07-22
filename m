Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.54]:41390 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbaGVTmz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 15:42:55 -0400
Message-ID: <53CEBEAB.3010206@skagestad.org>
Date: Tue, 22 Jul 2014 21:42:35 +0200
From: =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Blocked tasks on 3.15.1
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com> <53C7CD0F.7070603@fb.com> <CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com> <1745216.hDa4tC2HJJ@merkaba> <53CE7ACF.7070109@fb.com>
In-Reply-To: <53CE7ACF.7070109@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/22/2014 04:53 PM, Chris Mason wrote:
>
> On 07/19/2014 02:23 PM, Martin Steigerwald wrote:
>
>>> Running 3.15.6 with this patch applied on top:
>>>   - still causes a hang with `rsync -hPaHAXx --del /mnt/home/nyx/ /home/nyx/`
>>> - no extra error messages printed (`dmesg | grep racing`) compared to
>>> without the patch
>> I got same results with 3.16-rc5 + this patch (see thread BTRFS hang with
>> 3.16-rc5). 3.16-rc4 still is fine with me. No hang whatsoever so far.
>>
>>> To recap some details (so I can have it all in one place):
>>>   - /home/ is btrfs with compress=lzo
>> BTRFS RAID 1 with lzo.
>>
>>>   - I have _not_ created any nodatacow files.
>> Me neither.
>>
>>>   - Full stack is: sata <-> dmcrypt <-> lvm <-> btrfs (I noticed others
>>> mentioning the use of dmcrypt)
>> Same, except no dmcrypt.
>>
> Thanks for the help in tracking this down everyone.  We'll get there!
> Are you all running multi-disk systems (from a btrfs POV, more than one
> device?)  I don't care how many physical drives this maps to, just does
> btrfs think there's more than one drive.
>
> -chris
3.16-rc6 with your patch on top still causes hangs here.
No traces of "racing" in dmesg
Hang is on a btrfs raid 0 consisting of 3 drives.
Full stack is: sata <-> dmcrypt <-> btrfs raid0

Hang was caused by
1. Several rsync -av --inplace --delete <source> <backup subvol>
2. btrfs subvolume snapshot -r <backup subvol> <bacup snap>

The rsync jobs are done one at a time
btrfs is stuck when trying to create the read only snapshot

--
Torbjørn

All output via netconsole.
sysrq-w: 
https://gist.github.com/anonymous/d1837187e261f9a4cbd2#file-gistfile1-txt
sysrq-t: 
https://gist.github.com/anonymous/2bdb73f035ab9918c63d#file-gistfile1-txt

dmesg:
[ 9352.784136] INFO: task btrfs-transacti:3874 blocked for more than 120 
seconds.
[ 9352.784222]       Tainted: G            E 3.16.0-rc6+ #64
[ 9352.784270] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 9352.784354] btrfs-transacti D ffff88042fc943c0     0  3874      2 
0x00000000
[ 9352.784413]  ffff8803fb9dfca0 0000000000000002 ffff8800c4214b90 
ffff8803fb9dffd8
[ 9352.784502]  00000000000143c0 00000000000143c0 ffff88041977b260 
ffff8803d29f23a0
[ 9352.784592]  ffff8803d29f23a8 7fffffffffffffff ffff8800c4214b90 
ffff880232e2c0a8
[ 9352.784682] Call Trace:
[ 9352.784726]  [<ffffffff8170eb59>] schedule+0x29/0x70
[ 9352.784774]  [<ffffffff8170df99>] schedule_timeout+0x209/0x280
[ 9352.784827]  [<ffffffff8170874b>] ? __slab_free+0xfe/0x2c3
[ 9352.784879]  [<ffffffff810829f4>] ? wake_up_worker+0x24/0x30
[ 9352.784929]  [<ffffffff8170f656>] wait_for_completion+0xa6/0x160
[ 9352.784981]  [<ffffffff8109d4e0>] ? wake_up_state+0x20/0x20
[ 9352.785049]  [<ffffffffc045b936>] 
btrfs_wait_and_free_delalloc_work+0x16/0x30 [btrfs]
[ 9352.785141]  [<ffffffffc04658be>] 
btrfs_run_ordered_operations+0x1ee/0x2c0 [btrfs]
[ 9352.785260]  [<ffffffffc044bbb7>] btrfs_commit_transaction+0x27/0xa40 
[btrfs]
[ 9352.785324]  [<ffffffffc0447d65>] transaction_kthread+0x1b5/0x240 [btrfs]
[ 9352.785385]  [<ffffffffc0447bb0>] ? 
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[ 9352.785469]  [<ffffffff8108cc52>] kthread+0xd2/0xf0
[ 9352.785517]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9352.785571]  [<ffffffff81712dfc>] ret_from_fork+0x7c/0xb0
[ 9352.785620]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9352.785678] INFO: task kworker/u16:3:6932 blocked for more than 120 
seconds.
[ 9352.785732]       Tainted: G            E 3.16.0-rc6+ #64
[ 9352.785780] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 9352.785863] kworker/u16:3   D ffff88042fd943c0     0  6932      2 
0x00000000
[ 9352.785930] Workqueue: btrfs-flush_delalloc normal_work_helper [btrfs]
[ 9352.785983]  ffff88035f1bbb58 0000000000000002 ffff880417e564c0 
ffff88035f1bbfd8
[ 9352.786072]  00000000000143c0 00000000000143c0 ffff8800c1a03260 
ffff88042fd94cd8
[ 9352.786160]  ffff88042ffb4be8 ffff88035f1bbbe0 0000000000000002 
ffffffff81159930
[ 9352.786250] Call Trace:
[ 9352.786292]  [<ffffffff81159930>] ? wait_on_page_read+0x60/0x60
[ 9352.786343]  [<ffffffff8170ee6d>] io_schedule+0x9d/0x130
[ 9352.786393]  [<ffffffff8115993e>] sleep_on_page+0xe/0x20
[ 9352.786443]  [<ffffffff8170f3e8>] __wait_on_bit_lock+0x48/0xb0
[ 9352.786495]  [<ffffffff81159a4a>] __lock_page+0x6a/0x70
[ 9352.786544]  [<ffffffff810b14a0>] ? autoremove_wake_function+0x40/0x40
[ 9352.786607]  [<ffffffffc046711e>] ? flush_write_bio+0xe/0x10 [btrfs]
[ 9352.786669]  [<ffffffffc046b0c0>] 
extent_write_cache_pages.isra.28.constprop.46+0x3d0/0x3f0 [btrfs]
[ 9352.786766]  [<ffffffffc046cd2d>] extent_writepages+0x4d/0x70 [btrfs]
[ 9352.786828]  [<ffffffffc04506f0>] ? btrfs_submit_direct+0x6a0/0x6a0 
[btrfs]
[ 9352.786883]  [<ffffffff810b0d78>] ? __wake_up_common+0x58/0x90
[ 9352.786943]  [<ffffffffc044e1d8>] btrfs_writepages+0x28/0x30 [btrfs]
[ 9352.786997]  [<ffffffff811668ee>] do_writepages+0x1e/0x40
[ 9352.787045]  [<ffffffff8115b409>] __filemap_fdatawrite_range+0x59/0x60
[ 9352.787097]  [<ffffffff8115b4bc>] filemap_flush+0x1c/0x20
[ 9352.787151]  [<ffffffffc045158a>] btrfs_run_delalloc_work+0x5a/0xa0 
[btrfs]
[ 9352.787211]  [<ffffffffc047accf>] normal_work_helper+0x11f/0x2b0 [btrfs]
[ 9352.787266]  [<ffffffff810858d2>] process_one_work+0x182/0x450
[ 9352.787317]  [<ffffffff81086043>] worker_thread+0x123/0x5a0
[ 9352.787464]  [<ffffffff81085f20>] ? rescuer_thread+0x380/0x380
[ 9352.787515]  [<ffffffff8108cc52>] kthread+0xd2/0xf0
[ 9352.787563]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9352.787616]  [<ffffffff81712dfc>] ret_from_fork+0x7c/0xb0
[ 9352.787666]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9352.787744] INFO: task kworker/u16:9:8360 blocked for more than 120 
seconds.
[ 9352.787799]       Tainted: G            E 3.16.0-rc6+ #64
[ 9352.787847] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 9352.787949] kworker/u16:9   D ffff88042fd543c0     0  8360      2 
0x00000000
[ 9352.788015] Workqueue: btrfs-delalloc normal_work_helper [btrfs]
[ 9352.788139]  ffff88035f20f838 0000000000000002 ffff8803216c1930 
ffff88035f20ffd8
[ 9352.788229]  00000000000143c0 00000000000143c0 ffff8804157e0000 
ffff88042fd54cd8
[ 9352.788317]  ffff88042ffad6e8 ffff88035f20f8c0 0000000000000002 
ffffffff81159930
[ 9352.788406] Call Trace:
[ 9352.788445]  [<ffffffff81159930>] ? wait_on_page_read+0x60/0x60
[ 9352.788495]  [<ffffffff8170ee6d>] io_schedule+0x9d/0x130
[ 9352.788543]  [<ffffffff8115993e>] sleep_on_page+0xe/0x20
[ 9352.788591]  [<ffffffff8170f3e8>] __wait_on_bit_lock+0x48/0xb0
[ 9352.788642]  [<ffffffff8133c8a4>] ? blk_finish_plug+0x14/0x40
[ 9352.788692]  [<ffffffff81159a4a>] __lock_page+0x6a/0x70
[ 9352.788740]  [<ffffffff810b14a0>] ? autoremove_wake_function+0x40/0x40
[ 9352.788792]  [<ffffffff8115ac34>] pagecache_get_page+0x164/0x1f0
[ 9352.788849]  [<ffffffffc048e447>] io_ctl_prepare_pages+0x67/0x180 [btrfs]
[ 9352.788933]  [<ffffffffc048fd0f>] __load_free_space_cache+0x1ff/0x700 
[btrfs]
[ 9352.788998]  [<ffffffffc049030c>] load_free_space_cache+0xfc/0x1c0 
[btrfs]
[ 9352.789059]  [<ffffffffc0430292>] cache_block_group+0x192/0x390 [btrfs]
[ 9352.789113]  [<ffffffff810b1460>] ? prepare_to_wait_event+0x100/0x100
[ 9352.789173]  [<ffffffffc04390a2>] find_free_extent+0xc72/0xcb0 [btrfs]
[ 9352.789233]  [<ffffffffc04392ef>] btrfs_reserve_extent+0xaf/0x1b0 [btrfs]
[ 9352.789295]  [<ffffffffc04526cc>] cow_file_range+0x13c/0x430 [btrfs]
[ 9352.789355]  [<ffffffffc0453c80>] ? 
submit_compressed_extents+0x480/0x480 [btrfs]
[ 9352.789444]  [<ffffffffc04539d2>] 
submit_compressed_extents+0x1d2/0x480 [btrfs]
[ 9352.789533]  [<ffffffffc0451524>] ? async_cow_free+0x24/0x30 [btrfs]
[ 9352.789592]  [<ffffffffc0453c80>] ? 
submit_compressed_extents+0x480/0x480 [btrfs]
[ 9352.789680]  [<ffffffffc0453d06>] async_cow_submit+0x86/0x90 [btrfs]
[ 9352.789737]  [<ffffffffc047ad43>] normal_work_helper+0x193/0x2b0 [btrfs]
[ 9352.789790]  [<ffffffff810858d2>] process_one_work+0x182/0x450
[ 9352.789840]  [<ffffffff81086043>] worker_thread+0x123/0x5a0
[ 9352.789889]  [<ffffffff81085f20>] ? rescuer_thread+0x380/0x380
[ 9352.789938]  [<ffffffff8108cc52>] kthread+0xd2/0xf0
[ 9352.789984]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9352.790038]  [<ffffffff81712dfc>] ret_from_fork+0x7c/0xb0
[ 9352.790088]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9352.790144] INFO: task kworker/u16:0:11682 blocked for more than 120 
seconds.
[ 9352.790199]       Tainted: G            E 3.16.0-rc6+ #64
[ 9352.795261] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 9352.795347] kworker/u16:0   D ffff88042fd543c0     0 11682      2 
0x00000000
[ 9352.795409] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-3)
[ 9352.795465]  ffff8802161cf9d8 0000000000000002 ffff8803fc3c0000 
ffff8802161cffd8
[ 9352.795554]  00000000000143c0 00000000000143c0 ffff8804197e0000 
ffff88042fd54cd8
[ 9352.795644]  ffff88042ffaa9e8 ffff8802161cfa60 0000000000000002 
ffffffff81159930
[ 9352.795734] Call Trace:
[ 9352.795776]  [<ffffffff81159930>] ? wait_on_page_read+0x60/0x60
[ 9352.795829]  [<ffffffff8170ee6d>] io_schedule+0x9d/0x130
[ 9352.795879]  [<ffffffff8115993e>] sleep_on_page+0xe/0x20
[ 9352.795928]  [<ffffffff8170f3e8>] __wait_on_bit_lock+0x48/0xb0
[ 9352.795979]  [<ffffffff81159a4a>] __lock_page+0x6a/0x70
[ 9352.796029]  [<ffffffff810b14a0>] ? autoremove_wake_function+0x40/0x40
[ 9352.796150]  [<ffffffffc046711e>] ? flush_write_bio+0xe/0x10 [btrfs]
[ 9352.796212]  [<ffffffffc046b0c0>] 
extent_write_cache_pages.isra.28.constprop.46+0x3d0/0x3f0 [btrfs]
[ 9352.796309]  [<ffffffffc046cd2d>] extent_writepages+0x4d/0x70 [btrfs]
[ 9352.796369]  [<ffffffffc04506f0>] ? btrfs_submit_direct+0x6a0/0x6a0 
[btrfs]
[ 9352.796428]  [<ffffffffc044e1d8>] btrfs_writepages+0x28/0x30 [btrfs]
[ 9352.796481]  [<ffffffff811668ee>] do_writepages+0x1e/0x40
[ 9352.796530]  [<ffffffff811f17d0>] __writeback_single_inode+0x40/0x210
[ 9352.796581]  [<ffffffff811f22b7>] writeback_sb_inodes+0x247/0x3e0
[ 9352.796632]  [<ffffffff811f24ef>] __writeback_inodes_wb+0x9f/0xd0
[ 9352.796682]  [<ffffffff811f2763>] wb_writeback+0x243/0x2c0
[ 9352.796731]  [<ffffffff811f4e09>] bdi_writeback_workfn+0x1b9/0x430
[ 9352.796784]  [<ffffffff810858d2>] process_one_work+0x182/0x450
[ 9352.796833]  [<ffffffff81086043>] worker_thread+0x123/0x5a0
[ 9352.796882]  [<ffffffff81085f20>] ? rescuer_thread+0x380/0x380
[ 9352.796933]  [<ffffffff8108cc52>] kthread+0xd2/0xf0
[ 9352.796979]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9352.797031]  [<ffffffff81712dfc>] ret_from_fork+0x7c/0xb0
[ 9352.797079]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9352.797134] INFO: task kworker/u16:4:13743 blocked for more than 120 
seconds.
[ 9352.797189]       Tainted: G            E 3.16.0-rc6+ #64
[ 9352.797299] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 9352.797383] kworker/u16:4   D ffff88042fc943c0     0 13743      2 
0x00000000
[ 9352.797451] Workqueue: btrfs-flush_delalloc normal_work_helper [btrfs]
[ 9352.797505]  ffff880139843b58 0000000000000002 ffff880191e38000 
ffff880139843fd8
[ 9352.797594]  00000000000143c0 00000000000143c0 ffff88041977b260 
ffff88042fc94cd8
[ 9352.797684]  ffff88042ffb4be8 ffff880139843be0 0000000000000002 
ffffffff81159930
[ 9352.797773] Call Trace:
[ 9352.797813]  [<ffffffff81159930>] ? wait_on_page_read+0x60/0x60
[ 9352.797865]  [<ffffffff8170ee6d>] io_schedule+0x9d/0x130
[ 9352.797914]  [<ffffffff8115993e>] sleep_on_page+0xe/0x20
[ 9352.797963]  [<ffffffff8170f3e8>] __wait_on_bit_lock+0x48/0xb0
[ 9352.798013]  [<ffffffff81159a4a>] __lock_page+0x6a/0x70
[ 9352.798060]  [<ffffffff810b14a0>] ? autoremove_wake_function+0x40/0x40
[ 9352.798119]  [<ffffffffc046711e>] ? flush_write_bio+0xe/0x10 [btrfs]
[ 9352.798176]  [<ffffffffc046b0c0>] 
extent_write_cache_pages.isra.28.constprop.46+0x3d0/0x3f0 [btrfs]
[ 9352.798269]  [<ffffffffc046cd2d>] extent_writepages+0x4d/0x70 [btrfs]
[ 9352.798326]  [<ffffffffc04506f0>] ? btrfs_submit_direct+0x6a0/0x6a0 
[btrfs]
[ 9352.798385]  [<ffffffffc044e1d8>] btrfs_writepages+0x28/0x30 [btrfs]
[ 9352.798437]  [<ffffffff811668ee>] do_writepages+0x1e/0x40
[ 9352.798485]  [<ffffffff8115b409>] __filemap_fdatawrite_range+0x59/0x60
[ 9352.798537]  [<ffffffff8115b4bc>] filemap_flush+0x1c/0x20
[ 9352.798590]  [<ffffffffc045158a>] btrfs_run_delalloc_work+0x5a/0xa0 
[btrfs]
[ 9352.798650]  [<ffffffffc047accf>] normal_work_helper+0x11f/0x2b0 [btrfs]
[ 9352.798703]  [<ffffffff810858d2>] process_one_work+0x182/0x450
[ 9352.798752]  [<ffffffff81086043>] worker_thread+0x123/0x5a0
[ 9352.798801]  [<ffffffff81085f20>] ? rescuer_thread+0x380/0x380
[ 9352.798851]  [<ffffffff8108cc52>] kthread+0xd2/0xf0
[ 9352.798897]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9352.798949]  [<ffffffff81712dfc>] ret_from_fork+0x7c/0xb0
[ 9352.798997]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9352.799049] INFO: task btrfs:13823 blocked for more than 120 seconds.
[ 9352.799101]       Tainted: G            E 3.16.0-rc6+ #64
[ 9352.799148] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 9352.799229] btrfs           D ffff88042fd943c0     0 13823  13461 
0x00000000
[ 9352.799286]  ffff880177203a80 0000000000000002 ffff8800c1a01930 
ffff880177203fd8
[ 9352.799375]  00000000000143c0 00000000000143c0 ffff8800c2f664c0 
ffff8803d29f2438
[ 9352.799463]  ffff8803d29f2440 7fffffffffffffff ffff8800c1a01930 
ffff880177203bc0
[ 9352.799552] Call Trace:
[ 9352.799590]  [<ffffffff8170eb59>] schedule+0x29/0x70
[ 9352.799637]  [<ffffffff8170df99>] schedule_timeout+0x209/0x280
[ 9352.799687]  [<ffffffff8109d4a3>] ? wake_up_process+0x23/0x40
[ 9352.799736]  [<ffffffff810829f4>] ? wake_up_worker+0x24/0x30
[ 9352.799786]  [<ffffffff810836ab>] ? insert_work+0x6b/0xb0
[ 9352.799877]  [<ffffffff8170f656>] wait_for_completion+0xa6/0x160
[ 9352.799928]  [<ffffffff8109d4e0>] ? wake_up_state+0x20/0x20
[ 9352.799989]  [<ffffffffc045b936>] 
btrfs_wait_and_free_delalloc_work+0x16/0x30 [btrfs]
[ 9352.800080]  [<ffffffffc045bafe>] __start_delalloc_inodes+0x1ae/0x2a0 
[btrfs]
[ 9352.800150]  [<ffffffffc045bc2e>] 
btrfs_start_delalloc_inodes+0x3e/0x120 [btrfs]
[ 9352.800235]  [<ffffffff810b1228>] ? finish_wait+0x58/0x70
[ 9352.800293]  [<ffffffffc047fa24>] btrfs_mksubvol.isra.29+0x1d4/0x570 
[btrfs]
[ 9352.800348]  [<ffffffff810b1460>] ? prepare_to_wait_event+0x100/0x100
[ 9352.800409]  [<ffffffffc047ff46>] 
btrfs_ioctl_snap_create_transid+0x186/0x190 [btrfs]
[ 9352.800501]  [<ffffffffc04800ab>] 
btrfs_ioctl_snap_create_v2+0xeb/0x130 [btrfs]
[ 9352.800592]  [<ffffffffc048218f>] btrfs_ioctl+0xcaf/0x2ae0 [btrfs]
[ 9352.800645]  [<ffffffff8118d933>] ? mmap_region+0x163/0x5d0
[ 9352.800696]  [<ffffffff81057c8c>] ? __do_page_fault+0x20c/0x550
[ 9352.800748]  [<ffffffff811dc840>] do_vfs_ioctl+0x2e0/0x4c0
[ 9352.800798]  [<ffffffff810a0e64>] ? vtime_account_user+0x54/0x60
[ 9352.800850]  [<ffffffff811dcaa1>] SyS_ioctl+0x81/0xa0
[ 9352.800899]  [<ffffffff817130bf>] tracesys+0xe1/0xe6
[ 9354.863323] kvm [4191]: vcpu0 unhandled rdmsr: 0x345
[ 9354.869074] kvm_set_msr_common: 118 callbacks suppressed
[ 9354.869130] kvm [4191]: vcpu0 unhandled wrmsr: 0x680 data 0
[ 9354.869185] kvm [4191]: vcpu0 unhandled wrmsr: 0x6c0 data 0
[ 9354.869240] kvm [4191]: vcpu0 unhandled wrmsr: 0x681 data 0
[ 9354.869294] kvm [4191]: vcpu0 unhandled wrmsr: 0x6c1 data 0
[ 9354.869346] kvm [4191]: vcpu0 unhandled wrmsr: 0x682 data 0
[ 9354.869397] kvm [4191]: vcpu0 unhandled wrmsr: 0x6c2 data 0
[ 9354.869449] kvm [4191]: vcpu0 unhandled wrmsr: 0x683 data 0
[ 9354.869502] kvm [4191]: vcpu0 unhandled wrmsr: 0x6c3 data 0
[ 9354.869556] kvm [4191]: vcpu0 unhandled wrmsr: 0x684 data 0
[ 9354.869610] kvm [4191]: vcpu0 unhandled wrmsr: 0x6c4 data 0
[ 9376.448998] kvm [4191]: vcpu0 unhandled rdmsr: 0x611
[ 9376.449052] kvm [4191]: vcpu0 unhandled rdmsr: 0x639
[ 9376.449100] kvm [4191]: vcpu0 unhandled rdmsr: 0x641
[ 9376.449148] kvm [4191]: vcpu0 unhandled rdmsr: 0x619
[ 9472.705412] INFO: task btrfs-transacti:3874 blocked for more than 120 
seconds.
[ 9472.705499]       Tainted: G            E 3.16.0-rc6+ #64
[ 9472.705547] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 9472.705629] btrfs-transacti D ffff88042fc943c0     0  3874      2 
0x00000000
[ 9472.705688]  ffff8803fb9dfca0 0000000000000002 ffff8800c4214b90 
ffff8803fb9dffd8
[ 9472.705778]  00000000000143c0 00000000000143c0 ffff88041977b260 
ffff8803d29f23a0
[ 9472.705868]  ffff8803d29f23a8 7fffffffffffffff ffff8800c4214b90 
ffff880232e2c0a8
[ 9472.705976] Call Trace:
[ 9472.706019]  [<ffffffff8170eb59>] schedule+0x29/0x70
[ 9472.706067]  [<ffffffff8170df99>] schedule_timeout+0x209/0x280
[ 9472.706118]  [<ffffffff8170874b>] ? __slab_free+0xfe/0x2c3
[ 9472.706169]  [<ffffffff810829f4>] ? wake_up_worker+0x24/0x30
[ 9472.706219]  [<ffffffff8170f656>] wait_for_completion+0xa6/0x160
[ 9472.706270]  [<ffffffff8109d4e0>] ? wake_up_state+0x20/0x20
[ 9472.706338]  [<ffffffffc045b936>] 
btrfs_wait_and_free_delalloc_work+0x16/0x30 [btrfs]
[ 9472.706429]  [<ffffffffc04658be>] 
btrfs_run_ordered_operations+0x1ee/0x2c0 [btrfs]
[ 9472.706518]  [<ffffffffc044bbb7>] btrfs_commit_transaction+0x27/0xa40 
[btrfs]
[ 9472.706579]  [<ffffffffc0447d65>] transaction_kthread+0x1b5/0x240 [btrfs]
[ 9472.706637]  [<ffffffffc0447bb0>] ? 
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[ 9472.706720]  [<ffffffff8108cc52>] kthread+0xd2/0xf0
[ 9472.706767]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9472.706820]  [<ffffffff81712dfc>] ret_from_fork+0x7c/0xb0
[ 9472.706869]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9472.706926] INFO: task kworker/u16:3:6932 blocked for more than 120 
seconds.
[ 9472.706980]       Tainted: G            E 3.16.0-rc6+ #64
[ 9472.707029] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 9472.707112] kworker/u16:3   D ffff88042fd943c0     0  6932      2 
0x00000000
[ 9472.707179] Workqueue: btrfs-flush_delalloc normal_work_helper [btrfs]
[ 9472.707233]  ffff88035f1bbb58 0000000000000002 ffff880417e564c0 
ffff88035f1bbfd8
[ 9472.707322]  00000000000143c0 00000000000143c0 ffff8800c1a03260 
ffff88042fd94cd8
[ 9472.707413]  ffff88042ffb4be8 ffff88035f1bbbe0 0000000000000002 
ffffffff81159930
[ 9472.707502] Call Trace:
[ 9472.707543]  [<ffffffff81159930>] ? wait_on_page_read+0x60/0x60
[ 9472.707593]  [<ffffffff8170ee6d>] io_schedule+0x9d/0x130
[ 9472.707643]  [<ffffffff8115993e>] sleep_on_page+0xe/0x20
[ 9472.707697]  [<ffffffff8170f3e8>] __wait_on_bit_lock+0x48/0xb0
[ 9472.707770]  [<ffffffff81159a4a>] __lock_page+0x6a/0x70
[ 9472.707820]  [<ffffffff810b14a0>] ? autoremove_wake_function+0x40/0x40
[ 9472.707884]  [<ffffffffc046711e>] ? flush_write_bio+0xe/0x10 [btrfs]
[ 9472.707947]  [<ffffffffc046b0c0>] 
extent_write_cache_pages.isra.28.constprop.46+0x3d0/0x3f0 [btrfs]
[ 9472.713000]  [<ffffffffc046cd2d>] extent_writepages+0x4d/0x70 [btrfs]
[ 9472.713092]  [<ffffffffc04506f0>] ? btrfs_submit_direct+0x6a0/0x6a0 
[btrfs]
[ 9472.713148]  [<ffffffff810b0d78>] ? __wake_up_common+0x58/0x90
[ 9472.713203]  [<ffffffffc044e1d8>] btrfs_writepages+0x28/0x30 [btrfs]
[ 9472.713256]  [<ffffffff811668ee>] do_writepages+0x1e/0x40
[ 9472.713305]  [<ffffffff8115b409>] __filemap_fdatawrite_range+0x59/0x60
[ 9472.713359]  [<ffffffff8115b4bc>] filemap_flush+0x1c/0x20
[ 9472.713425]  [<ffffffffc045158a>] btrfs_run_delalloc_work+0x5a/0xa0 
[btrfs]
[ 9472.713491]  [<ffffffffc047accf>] normal_work_helper+0x11f/0x2b0 [btrfs]
[ 9472.713547]  [<ffffffff810858d2>] process_one_work+0x182/0x450
[ 9472.713598]  [<ffffffff81086043>] worker_thread+0x123/0x5a0
[ 9472.713648]  [<ffffffff81085f20>] ? rescuer_thread+0x380/0x380
[ 9472.713723]  [<ffffffff8108cc52>] kthread+0xd2/0xf0
[ 9472.713794]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9472.713849]  [<ffffffff81712dfc>] ret_from_fork+0x7c/0xb0
[ 9472.713898]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9472.713953] INFO: task kworker/u16:9:8360 blocked for more than 120 
seconds.
[ 9472.714028]       Tainted: G            E 3.16.0-rc6+ #64
[ 9472.714076] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 9472.714159] kworker/u16:9   D ffff88042fd543c0     0  8360      2 
0x00000000
[ 9472.714225] Workqueue: btrfs-delalloc normal_work_helper [btrfs]
[ 9472.714277]  ffff88035f20f838 0000000000000002 ffff8803216c1930 
ffff88035f20ffd8
[ 9472.714366]  00000000000143c0 00000000000143c0 ffff8804157e0000 
ffff88042fd54cd8
[ 9472.714455]  ffff88042ffad6e8 ffff88035f20f8c0 0000000000000002 
ffffffff81159930
[ 9472.714544] Call Trace:
[ 9472.714584]  [<ffffffff81159930>] ? wait_on_page_read+0x60/0x60
[ 9472.714636]  [<ffffffff8170ee6d>] io_schedule+0x9d/0x130
[ 9472.714684]  [<ffffffff8115993e>] sleep_on_page+0xe/0x20
[ 9472.714734]  [<ffffffff8170f3e8>] __wait_on_bit_lock+0x48/0xb0
[ 9472.714785]  [<ffffffff8133c8a4>] ? blk_finish_plug+0x14/0x40
[ 9472.714835]  [<ffffffff81159a4a>] __lock_page+0x6a/0x70
[ 9472.714884]  [<ffffffff810b14a0>] ? autoremove_wake_function+0x40/0x40
[ 9472.714938]  [<ffffffff8115ac34>] pagecache_get_page+0x164/0x1f0
[ 9472.714999]  [<ffffffffc048e447>] io_ctl_prepare_pages+0x67/0x180 [btrfs]
[ 9472.715088]  [<ffffffffc048fd0f>] __load_free_space_cache+0x1ff/0x700 
[btrfs]
[ 9472.715152]  [<ffffffffc049030c>] load_free_space_cache+0xfc/0x1c0 
[btrfs]
[ 9472.715213]  [<ffffffffc0430292>] cache_block_group+0x192/0x390 [btrfs]
[ 9472.715267]  [<ffffffff810b1460>] ? prepare_to_wait_event+0x100/0x100
[ 9472.715328]  [<ffffffffc04390a2>] find_free_extent+0xc72/0xcb0 [btrfs]
[ 9472.715388]  [<ffffffffc04392ef>] btrfs_reserve_extent+0xaf/0x1b0 [btrfs]
[ 9472.715451]  [<ffffffffc04526cc>] cow_file_range+0x13c/0x430 [btrfs]
[ 9472.715511]  [<ffffffffc0453c80>] ? 
submit_compressed_extents+0x480/0x480 [btrfs]
[ 9472.715602]  [<ffffffffc04539d2>] 
submit_compressed_extents+0x1d2/0x480 [btrfs]
[ 9472.715691]  [<ffffffffc0451524>] ? async_cow_free+0x24/0x30 [btrfs]
[ 9472.715748]  [<ffffffffc0453c80>] ? 
submit_compressed_extents+0x480/0x480 [btrfs]
[ 9472.715835]  [<ffffffffc0453d06>] async_cow_submit+0x86/0x90 [btrfs]
[ 9472.715894]  [<ffffffffc047ad43>] normal_work_helper+0x193/0x2b0 [btrfs]
[ 9472.715948]  [<ffffffff810858d2>] process_one_work+0x182/0x450
[ 9472.715998]  [<ffffffff81086043>] worker_thread+0x123/0x5a0
[ 9472.716047]  [<ffffffff81085f20>] ? rescuer_thread+0x380/0x380
[ 9472.716098]  [<ffffffff8108cc52>] kthread+0xd2/0xf0
[ 9472.716145]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9472.716197]  [<ffffffff81712dfc>] ret_from_fork+0x7c/0xb0
[ 9472.716246]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9472.716303] INFO: task kworker/u16:0:11682 blocked for more than 120 
seconds.
[ 9472.716357]       Tainted: G            E 3.16.0-rc6+ #64
[ 9472.716405] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 9472.716488] kworker/u16:0   D ffff88042fd543c0     0 11682      2 
0x00000000
[ 9472.716548] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-3)
[ 9472.716610]  ffff8802161cf9d8 0000000000000002 ffff8803fc3c0000 
ffff8802161cffd8
[ 9472.716699]  00000000000143c0 00000000000143c0 ffff8804197e0000 
ffff88042fd54cd8
[ 9472.716788]  ffff88042ffaa9e8 ffff8802161cfa60 0000000000000002 
ffffffff81159930
[ 9472.716878] Call Trace:
[ 9472.716917]  [<ffffffff81159930>] ? wait_on_page_read+0x60/0x60
[ 9472.716968]  [<ffffffff8170ee6d>] io_schedule+0x9d/0x130
[ 9472.717017]  [<ffffffff8115993e>] sleep_on_page+0xe/0x20
[ 9472.717067]  [<ffffffff8170f3e8>] __wait_on_bit_lock+0x48/0xb0
[ 9472.717118]  [<ffffffff81159a4a>] __lock_page+0x6a/0x70
[ 9472.717167]  [<ffffffff810b14a0>] ? autoremove_wake_function+0x40/0x40
[ 9472.717231]  [<ffffffffc046711e>] ? flush_write_bio+0xe/0x10 [btrfs]
[ 9472.717293]  [<ffffffffc046b0c0>] 
extent_write_cache_pages.isra.28.constprop.46+0x3d0/0x3f0 [btrfs]
[ 9472.717402]  [<ffffffffc046cd2d>] extent_writepages+0x4d/0x70 [btrfs]
[ 9472.717465]  [<ffffffffc04506f0>] ? btrfs_submit_direct+0x6a0/0x6a0 
[btrfs]
[ 9472.717553]  [<ffffffffc044e1d8>] btrfs_writepages+0x28/0x30 [btrfs]
[ 9472.717607]  [<ffffffff811668ee>] do_writepages+0x1e/0x40
[ 9472.717657]  [<ffffffff811f17d0>] __writeback_single_inode+0x40/0x210
[ 9472.717710]  [<ffffffff811f22b7>] writeback_sb_inodes+0x247/0x3e0
[ 9472.717784]  [<ffffffff811f24ef>] __writeback_inodes_wb+0x9f/0xd0
[ 9472.717836]  [<ffffffff811f2763>] wb_writeback+0x243/0x2c0
[ 9472.717885]  [<ffffffff811f4e09>] bdi_writeback_workfn+0x1b9/0x430
[ 9472.717938]  [<ffffffff810858d2>] process_one_work+0x182/0x450
[ 9472.717990]  [<ffffffff81086043>] worker_thread+0x123/0x5a0
[ 9472.718039]  [<ffffffff81085f20>] ? rescuer_thread+0x380/0x380
[ 9472.718089]  [<ffffffff8108cc52>] kthread+0xd2/0xf0
[ 9472.718136]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
[ 9472.718188]  [<ffffffff81712dfc>] ret_from_fork+0x7c/0xb0
[ 9472.718237]  [<ffffffff8108cb80>] ? kthread_create_on_node+0x180/0x180
