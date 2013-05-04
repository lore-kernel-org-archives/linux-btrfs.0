Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33155 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760153Ab3EDOCs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 May 2013 10:02:48 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so2301971wgh.0
        for <linux-btrfs@vger.kernel.org>; Sat, 04 May 2013 07:02:46 -0700 (PDT)
Received: from [192.168.1.121] (ppp-94-66-153-30.home.otenet.gr. [94.66.153.30])
        by mx.google.com with ESMTPSA id ge7sm3415880wib.6.2013.05.04.07.02.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 04 May 2013 07:02:45 -0700 (PDT)
Message-ID: <51851502.5020304@gmail.com>
Date: Sat, 04 May 2013 17:02:42 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: INFO: task btrfs-endio-wri:32643 blocked for more than 120 seconds
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I got these messages while I was rsyncing a large amount of data to my 
btrfs filesystem

$ uname -r
3.9.0-2-ARCH


$ btrfs fi show --all-devices
Label: none  uuid: 43da70c8-a76e-4d7f-8926-be5412b3d943
         Total devices 5 FS bytes used 4.95TB
         devid    2 size 1.82TB used 1.67TB path /dev/sdb
         devid    3 size 1.82TB used 1.67TB path /dev/sda
         devid    5 size 1.82TB used 1.67TB path /dev/sdc
         devid    1 size 1.82TB used 1.67TB path /dev/sdd
         devid    4 size 1.82TB used 1.67TB path /dev/sde

Btrfs v0.20-rc1-253-g7854c8b

$ btrfs fi df /storage/btrfs
Data, RAID0: total=7.98TB, used=4.93TB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=448.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=187.00GB, used=18.70GB
Metadata: total=8.00MB, used=0.00


UUID=43da70c8-a76e-4d7f-8926-be5412b3d943 /storage/btrfs btrfs 
noatime,compress-force=zlib,space_cache,inode_cache  0 1


[    5.788101] Btrfs loaded
[    5.788592] device fsid 43da70c8-a76e-4d7f-8926-be5412b3d943 devid 2 
transid 82342 /dev/sdb
[    5.788774] device fsid 43da70c8-a76e-4d7f-8926-be5412b3d943 devid 1 
transid 82342 /dev/sdd
[    5.789029] device fsid 43da70c8-a76e-4d7f-8926-be5412b3d943 devid 3 
transid 82342 /dev/sda
[    5.789551] device fsid 43da70c8-a76e-4d7f-8926-be5412b3d943 devid 5 
transid 82342 /dev/sdc
[    5.790003] device fsid 43da70c8-a76e-4d7f-8926-be5412b3d943 devid 4 
transid 82342 /dev/sde
[    6.085875] device fsid 43da70c8-a76e-4d7f-8926-be5412b3d943 devid 4 
transid 82342 /dev/sde
[    6.087891] btrfs: force zlib compression
[    6.087907] btrfs: enabling inode map caching
[    6.087912] btrfs: disk space caching is enabled
[    6.188271] btrfs: bdev /dev/sdc errs: wr 335, rd 2, flush 0, corrupt 
0, gen 0
[ 3263.277141] btrfs: csum mismatch on free space cache
[ 3263.277260] btrfs: failed to load free space cache for block group 
40831549440
[ 3312.233565] btrfs: free space inode generation (0) did not match free 
space cache generation (82330)

[221129.876129] INFO: task btrfs-endio-wri:32643 blocked for more than 
120 seconds.
[221129.876271] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[221129.876408] btrfs-endio-wri D ffff88000064cb60     0 32643 2 0x00000000
[221129.876419]  ffff880002717c30 0000000000000046 0000000000014280 
ffff880002717fd8
[221129.876429]  ffff880002717fd8 0000000000014280 ffff88000064cb60 
0000000000000000
[221129.876437]  ffff880002717bc0 ffffffffa0a1540f 00007f5fa0a3523e 
ffff880059434000
[221129.876445] Call Trace:
[221129.876482]  [<ffffffffa0a1540f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[221129.876516]  [<ffffffffa0a5753e>] ? free_extent_state+0x1e/0x30 [btrfs]
[221129.876527]  [<ffffffff81172b5a>] ? kmem_cache_free+0x1ea/0x210
[221129.876556]  [<ffffffffa0a5753e>] ? free_extent_state+0x1e/0x30 [btrfs]
[221129.876565]  [<ffffffff814d0649>] schedule+0x29/0x70
[221129.876592]  [<ffffffffa0a2d50e>] btrfs_run_delayed_refs+0x31e/0x500 
[btrfs]
[221129.876601]  [<ffffffff8107c3f0>] ? wake_up_bit+0x30/0x30
[221129.876630]  [<ffffffffa0a3e4b7>] __btrfs_end_transaction+0xc7/0x310 
[btrfs]
[221129.876659]  [<ffffffffa0a3e710>] btrfs_end_transaction+0x10/0x20 
[btrfs]
[221129.876688]  [<ffffffffa0a4a304>] 
btrfs_finish_ordered_io+0x114/0x9d0 [btrfs]
[221129.876697]  [<ffffffff81123e97>] ? mempool_free_slab+0x17/0x20
[221129.876704]  [<ffffffff81124439>] ? mempool_free+0x49/0x90
[221129.876731]  [<ffffffffa0a7f368>] ? 
end_compressed_bio_write+0xe8/0xf0 [btrfs]
[221129.876760]  [<ffffffffa0a4ada5>] finish_ordered_fn+0x15/0x20 [btrfs]
[221129.876788]  [<ffffffffa0a69edc>] worker_loop+0x12c/0x550 [btrfs]
[221129.876817]  [<ffffffffa0a69db0>] ? btrfs_queue_worker+0x330/0x330 
[btrfs]
[221129.876824]  [<ffffffff8107b5d0>] kthread+0xc0/0xd0
[221129.876831]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221129.876838]  [<ffffffff814d932c>] ret_from_fork+0x7c/0xb0
[221129.876845]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221129.876858] INFO: task btrfs-endio-wri:1292 blocked for more than 
120 seconds.
[221129.876983] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[221129.877118] btrfs-endio-wri D ffff880073b9dc20     0  1292 2 0x00000000
[221129.877125]  ffff880015b65c30 0000000000000046 0000000000014280 
ffff880015b65fd8
[221129.877132]  ffff880015b65fd8 0000000000014280 ffff880073b9dc20 
ffffffffa0a1da45
[221129.877139]  0000247b00001f93 ffff880015b65cc6 ffff8800176642d0 
0000000000000296
[221129.877146] Call Trace:
[221129.877172]  [<ffffffffa0a1da45>] ? 
setup_items_for_insert+0x2c5/0x3c0 [btrfs]
[221129.877202]  [<ffffffffa0a5753e>] ? free_extent_state+0x1e/0x30 [btrfs]
[221129.877210]  [<ffffffff81172b5a>] ? kmem_cache_free+0x1ea/0x210
[221129.877239]  [<ffffffffa0a5753e>] ? free_extent_state+0x1e/0x30 [btrfs]
[221129.877245]  [<ffffffff814d0649>] schedule+0x29/0x70
[221129.877271]  [<ffffffffa0a2d50e>] btrfs_run_delayed_refs+0x31e/0x500 
[btrfs]
[221129.877278]  [<ffffffff8107c3f0>] ? wake_up_bit+0x30/0x30
[221129.877307]  [<ffffffffa0a3e4b7>] __btrfs_end_transaction+0xc7/0x310 
[btrfs]
[221129.877335]  [<ffffffffa0a3e710>] btrfs_end_transaction+0x10/0x20 
[btrfs]
[221129.877364]  [<ffffffffa0a4a304>] 
btrfs_finish_ordered_io+0x114/0x9d0 [btrfs]
[221129.877372]  [<ffffffff81123e97>] ? mempool_free_slab+0x17/0x20
[221129.877379]  [<ffffffff81124439>] ? mempool_free+0x49/0x90
[221129.877406]  [<ffffffffa0a7f368>] ? 
end_compressed_bio_write+0xe8/0xf0 [btrfs]
[221129.877435]  [<ffffffffa0a4ada5>] finish_ordered_fn+0x15/0x20 [btrfs]
[221129.877463]  [<ffffffffa0a69edc>] worker_loop+0x12c/0x550 [btrfs]
[221129.877472]  [<ffffffff8108cb42>] ? default_wake_function+0x12/0x20
[221129.877500]  [<ffffffffa0a69db0>] ? btrfs_queue_worker+0x330/0x330 
[btrfs]
[221129.877507]  [<ffffffff8107b5d0>] kthread+0xc0/0xd0
[221129.877513]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221129.877519]  [<ffffffff814d932c>] ret_from_fork+0x7c/0xb0
[221129.877526]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221129.877532] INFO: task btrfs-endio-wri:1293 blocked for more than 
120 seconds.
[221129.877657] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[221129.877791] btrfs-endio-wri D ffff880073b990c0     0  1293 2 0x00000000
[221129.877798]  ffff880011359c30 0000000000000046 0000000000014280 
ffff880011359fd8
[221129.877805]  ffff880011359fd8 0000000000014280 ffff880073b990c0 
ffffffffa0a1da45
[221129.877812]  00004a330000203b ffff880011359cc6 ffff880042667090 
ffff8800734a4000
[221129.877818] Call Trace:
[221129.877843]  [<ffffffffa0a1da45>] ? 
setup_items_for_insert+0x2c5/0x3c0 [btrfs]
[221129.877873]  [<ffffffffa0a5753e>] ? free_extent_state+0x1e/0x30 [btrfs]
[221129.877881]  [<ffffffff81172b5a>] ? kmem_cache_free+0x1ea/0x210
[221129.877910]  [<ffffffffa0a5753e>] ? free_extent_state+0x1e/0x30 [btrfs]
[221129.877916]  [<ffffffff814d0649>] schedule+0x29/0x70
[221129.877942]  [<ffffffffa0a2d50e>] btrfs_run_delayed_refs+0x31e/0x500 
[btrfs]
[221129.877949]  [<ffffffff8107c3f0>] ? wake_up_bit+0x30/0x30
[221129.877977]  [<ffffffffa0a3e4b7>] __btrfs_end_transaction+0xc7/0x310 
[btrfs]
[221129.878006]  [<ffffffffa0a3e710>] btrfs_end_transaction+0x10/0x20 
[btrfs]
[221129.878036]  [<ffffffffa0a4a304>] 
btrfs_finish_ordered_io+0x114/0x9d0 [btrfs]
[221129.878044]  [<ffffffff81068842>] ? del_timer_sync+0x52/0x60
[221129.878053]  [<ffffffff814ce00c>] ? schedule_timeout+0x13c/0x290
[221129.878062]  [<ffffffff81067c10>] ? call_timer_fn+0x190/0x190
[221129.878092]  [<ffffffffa0a4ada5>] finish_ordered_fn+0x15/0x20 [btrfs]
[221129.878120]  [<ffffffffa0a69edc>] worker_loop+0x12c/0x550 [btrfs]
[221129.878128]  [<ffffffff8108cb42>] ? default_wake_function+0x12/0x20
[221129.878156]  [<ffffffffa0a69db0>] ? btrfs_queue_worker+0x330/0x330 
[btrfs]
[221129.878162]  [<ffffffff8107b5d0>] kthread+0xc0/0xd0
[221129.878169]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221129.878176]  [<ffffffff814d932c>] ret_from_fork+0x7c/0xb0
[221129.878182]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221129.878187] INFO: task btrfs-endio-wri:1294 blocked for more than 
120 seconds.
[221129.878313] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[221129.878447] btrfs-endio-wri D ffff880073b98860     0  1294 2 0x00000000
[221129.878453]  ffff880007ddfc30 0000000000000046 0000000000014280 
ffff880007ddffd8
[221129.878460]  ffff880007ddffd8 0000000000014280 ffff880073b98860 
0000000000000000
[221129.878466]  ffff880007ddfbc0 ffffffffa0a1540f 00007f5fa0a3523e 
ffff880059434000
[221129.878473] Call Trace:
[221129.878497]  [<ffffffffa0a1540f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[221129.878527]  [<ffffffffa0a5753e>] ? free_extent_state+0x1e/0x30 [btrfs]
[221129.878534]  [<ffffffff81172b5a>] ? kmem_cache_free+0x1ea/0x210
[221129.878563]  [<ffffffffa0a5753e>] ? free_extent_state+0x1e/0x30 [btrfs]
[221129.878570]  [<ffffffff814d0649>] schedule+0x29/0x70
[221129.878595]  [<ffffffffa0a2d50e>] btrfs_run_delayed_refs+0x31e/0x500 
[btrfs]
[221129.878602]  [<ffffffff8107c3f0>] ? wake_up_bit+0x30/0x30
[221129.878630]  [<ffffffffa0a3e4b7>] __btrfs_end_transaction+0xc7/0x310 
[btrfs]
[221129.878659]  [<ffffffffa0a3e710>] btrfs_end_transaction+0x10/0x20 
[btrfs]
[221129.878688]  [<ffffffffa0a4a304>] 
btrfs_finish_ordered_io+0x114/0x9d0 [btrfs]
[221129.878696]  [<ffffffff81123e97>] ? mempool_free_slab+0x17/0x20
[221129.878703]  [<ffffffff81124439>] ? mempool_free+0x49/0x90
[221129.878730]  [<ffffffffa0a7f368>] ? 
end_compressed_bio_write+0xe8/0xf0 [btrfs]
[221129.878759]  [<ffffffffa0a4ada5>] finish_ordered_fn+0x15/0x20 [btrfs]
[221129.878787]  [<ffffffffa0a69edc>] worker_loop+0x12c/0x550 [btrfs]
[221129.878795]  [<ffffffff8108cb42>] ? default_wake_function+0x12/0x20
[221129.878823]  [<ffffffffa0a69db0>] ? btrfs_queue_worker+0x330/0x330 
[btrfs]
[221129.878829]  [<ffffffff8107b5d0>] kthread+0xc0/0xd0
[221129.878836]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221129.878842]  [<ffffffff814d932c>] ret_from_fork+0x7c/0xb0
[221129.878849]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221129.878854] INFO: task btrfs-endio-wri:1295 blocked for more than 
120 seconds.
[221129.878979] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[221129.879113] btrfs-endio-wri D ffff880073b06ce0     0  1295 2 0x00000000
[221129.879119]  ffff880052febc30 0000000000000046 0000000000014280 
ffff880052febfd8
[221129.879126]  ffff880052febfd8 0000000000014280 ffff880073b06ce0 
0000000000000000
[221129.879132]  ffff880052febbc0 ffffffffa0a1540f 00007f5fa0a3523e 
ffff880059434000
[221129.879139] Call Trace:
[221129.879163]  [<ffffffffa0a1540f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[221129.879172]  [<ffffffff814cf190>] ? __mutex_lock_slowpath+0x260/0x360
[221129.879201]  [<ffffffffa0a57389>] ? 
release_extent_buffer.isra.33+0xa9/0xd0 [btrfs]
[221129.879231]  [<ffffffffa0a5753e>] ? free_extent_state+0x1e/0x30 [btrfs]
[221129.879237]  [<ffffffff814d0649>] schedule+0x29/0x70
[221129.879263]  [<ffffffffa0a2d50e>] btrfs_run_delayed_refs+0x31e/0x500 
[btrfs]
[221129.879270]  [<ffffffff8107c3f0>] ? wake_up_bit+0x30/0x30
[221129.879298]  [<ffffffffa0a3e4b7>] __btrfs_end_transaction+0xc7/0x310 
[btrfs]
[221129.879326]  [<ffffffffa0a3e710>] btrfs_end_transaction+0x10/0x20 
[btrfs]
[221129.879355]  [<ffffffffa0a4a304>] 
btrfs_finish_ordered_io+0x114/0x9d0 [btrfs]
[221129.879363]  [<ffffffff81068842>] ? del_timer_sync+0x52/0x60
[221129.879371]  [<ffffffff814ce00c>] ? schedule_timeout+0x13c/0x290
[221129.879378]  [<ffffffff81067c10>] ? call_timer_fn+0x190/0x190
[221129.879466]  [<ffffffffa0a4ada5>] finish_ordered_fn+0x15/0x20 [btrfs]
[221129.879494]  [<ffffffffa0a69edc>] worker_loop+0x12c/0x550 [btrfs]
[221129.879523]  [<ffffffffa0a69db0>] ? btrfs_queue_worker+0x330/0x330 
[btrfs]
[221129.879529]  [<ffffffff8107b5d0>] kthread+0xc0/0xd0
[221129.879536]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221129.879543]  [<ffffffff814d932c>] ret_from_fork+0x7c/0xb0
[221129.879550]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221129.879576] INFO: task btrfs-endio-wri:1296 blocked for more than 
120 seconds.
[221129.879702] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[221129.879836] btrfs-endio-wri D ffff880073b99920     0  1296 2 0x00000000
[221129.879843]  ffff88006ec37c30 0000000000000046 0000000000014280 
ffff88006ec37fd8
[221129.879849]  ffff88006ec37fd8 0000000000014280 ffff880073b99920 
0000000000000000
[221129.879856]  ffff88006ec37bc0 ffffffffa0a1540f 00007f5fa0a3523e 
ffff880059434000
[221129.879863] Call Trace:
[221129.879887]  [<ffffffffa0a1540f>] ? leaf_space_used+0xcf/0x110 [btrfs]
[221129.879917]  [<ffffffffa0a5753e>] ? free_extent_state+0x1e/0x30 [btrfs]
[221129.879924]  [<ffffffff81172b5a>] ? kmem_cache_free+0x1ea/0x210
[221129.879954]  [<ffffffffa0a5753e>] ? free_extent_state+0x1e/0x30 [btrfs]
[221129.879960]  [<ffffffff814d0649>] schedule+0x29/0x70
[221129.879986]  [<ffffffffa0a2d50e>] btrfs_run_delayed_refs+0x31e/0x500 
[btrfs]
[221129.879993]  [<ffffffff8107c3f0>] ? wake_up_bit+0x30/0x30
[221129.880021]  [<ffffffffa0a3e4b7>] __btrfs_end_transaction+0xc7/0x310 
[btrfs]
[221129.880050]  [<ffffffffa0a3e710>] btrfs_end_transaction+0x10/0x20 
[btrfs]
[221129.880079]  [<ffffffffa0a4a304>] 
btrfs_finish_ordered_io+0x114/0x9d0 [btrfs]
[221129.880087]  [<ffffffff81068842>] ? del_timer_sync+0x52/0x60
[221129.880095]  [<ffffffff814ce00c>] ? schedule_timeout+0x13c/0x290
[221129.880102]  [<ffffffff81067c10>] ? call_timer_fn+0x190/0x190
[221129.880131]  [<ffffffffa0a4ada5>] finish_ordered_fn+0x15/0x20 [btrfs]
[221129.880159]  [<ffffffffa0a69edc>] worker_loop+0x12c/0x550 [btrfs]
[221129.880187]  [<ffffffffa0a69db0>] ? btrfs_queue_worker+0x330/0x330 
[btrfs]
[221129.880194]  [<ffffffff8107b5d0>] kthread+0xc0/0xd0
[221129.880200]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221129.880207]  [<ffffffff814d932c>] ret_from_fork+0x7c/0xb0
[221129.880213]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221850.952262] INFO: task btrfs-cleaner:241 blocked for more than 120 
seconds.
[221850.952401] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[221850.952539] btrfs-cleaner   D ffff8800734a31e8     0   241 2 0x00000000
[221850.952549]  ffff88006c779d08 0000000000000046 0000000000014280 
ffff88006c779fd8
[221850.952559]  ffff88006c779fd8 0000000000014280 ffff880073263240 
ffffffffa0a1974d
[221850.952567]  ffff88006c779d28 ffff88006d533500 000000196c779cb8 
ffff88006c779fd8
[221850.952575] Call Trace:
[221850.952614]  [<ffffffffa0a1974d>] ? 
generic_bin_search.constprop.42+0x8d/0x1a0 [btrfs]
[221850.952645]  [<ffffffffa0a2d51a>] ? 
btrfs_run_delayed_refs+0x32a/0x500 [btrfs]
[221850.952655]  [<ffffffff814d0649>] schedule+0x29/0x70
[221850.952684]  [<ffffffffa0a3cc35>] 
wait_current_trans.isra.20+0xa5/0xf0 [btrfs]
[221850.952692]  [<ffffffff8107c3f0>] ? wake_up_bit+0x30/0x30
[221850.952721]  [<ffffffffa0a3df15>] start_transaction+0x165/0x530 [btrfs]
[221850.952750]  [<ffffffffa0a3e5a8>] ? 
__btrfs_end_transaction+0x1b8/0x310 [btrfs]
[221850.952779]  [<ffffffffa0a3e2f8>] btrfs_start_transaction+0x18/0x20 
[btrfs]
[221850.952805]  [<ffffffffa0a2bd4b>] btrfs_drop_snapshot+0x52b/0x620 
[btrfs]
[221850.952835]  [<ffffffffa0a44182>] ? 
btrfs_run_delayed_iputs+0xe2/0x100 [btrfs]
[221850.952864]  [<ffffffffa0a3ee37>] 
btrfs_clean_old_snapshots+0xa7/0x150 [btrfs]
[221850.952891]  [<ffffffffa0a35098>] cleaner_kthread+0xa8/0x120 [btrfs]
[221850.952917]  [<ffffffffa0a34ff0>] ? transaction_kthread+0x230/0x230 
[btrfs]
[221850.952924]  [<ffffffff8107b5d0>] kthread+0xc0/0xd0
[221850.952932]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221850.952939]  [<ffffffff814d932c>] ret_from_fork+0x7c/0xb0
[221850.952946]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221850.952954] INFO: task rsync:14299 blocked for more than 120 seconds.
[221850.953067] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[221850.953202] rsync           D ffff88006ac7bbd0     0 14299 14293 
0x00000000
[221850.953209]  ffff88006ac7bb40 0000000000000082 0000000000014280 
ffff88006ac7bfd8
[221850.953217]  ffff88006ac7bfd8 0000000000014280 ffff88006c1a5c20 
ffff88006ac7bb18
[221850.953224]  ffffffffa0a4606e 0000000000000000 0000000000000050 
ffff88006ac7bbd4
[221850.953231] Call Trace:
[221850.953261]  [<ffffffffa0a4606e>] ? run_delalloc_range+0x19e/0x3a0 
[btrfs]
[221850.953270]  [<ffffffff8101c919>] ? read_tsc+0x9/0x20
[221850.953278]  [<ffffffff81121450>] ? filemap_fdatawait+0x30/0x30
[221850.953285]  [<ffffffff814d0649>] schedule+0x29/0x70
[221850.953291]  [<ffffffff814d08ef>] io_schedule+0x8f/0xe0
[221850.953297]  [<ffffffff8112145e>] sleep_on_page+0xe/0x20
[221850.953307]  [<ffffffff814ce33b>] __wait_on_bit_lock+0x5b/0xc0
[221850.953314]  [<ffffffff8112159a>] __lock_page+0x6a/0x70
[221850.953320]  [<ffffffff8107c430>] ? autoremove_wake_function+0x40/0x40
[221850.953350]  [<ffffffffa0a56e2e>] ? flush_write_bio+0xe/0x10 [btrfs]
[221850.953380]  [<ffffffffa0a5ba51>] 
extent_write_cache_pages.isra.31.constprop.47+0x391/0x3e0 [btrfs]
[221850.953411]  [<ffffffffa0a5753e>] ? free_extent_state+0x1e/0x30 [btrfs]
[221850.953440]  [<ffffffffa0a56f54>] ? 
free_extent_state.part.34+0x34/0xc0 [btrfs]
[221850.953470]  [<ffffffffa0a5753e>] ? free_extent_state+0x1e/0x30 [btrfs]
[221850.953499]  [<ffffffffa0a5bd8d>] extent_writepages+0x4d/0x70 [btrfs]
[221850.953528]  [<ffffffffa0a42230>] ? can_nocow_odirect+0x270/0x270 
[btrfs]
[221850.953557]  [<ffffffffa0a41188>] btrfs_writepages+0x28/0x30 [btrfs]
[221850.953565]  [<ffffffff8112d55e>] do_writepages+0x1e/0x40
[221850.953573]  [<ffffffff81122889>] __filemap_fdatawrite_range+0x59/0x60
[221850.953581]  [<ffffffff81122953>] filemap_fdatawrite_range+0x13/0x20
[221850.953611]  [<ffffffffa0a56117>] 
btrfs_wait_ordered_range+0xf7/0x110 [btrfs]
[221850.953640]  [<ffffffffa0a48492>] btrfs_truncate+0x72/0x2d0 [btrfs]
[221850.953648]  [<ffffffff811302d9>] ? truncate_pagecache+0x59/0x60
[221850.953677]  [<ffffffffa0a4b664>] btrfs_setattr+0x164/0x230 [btrfs]
[221850.953685]  [<ffffffff811a5c1c>] notify_change+0x1dc/0x360
[221850.953693]  [<ffffffff811896eb>] do_truncate+0x6b/0xa0
[221850.953702]  [<ffffffff8118d1a9>] ? __sb_start_write+0x49/0x100
[221850.953709]  [<ffffffff81189a68>] 
do_sys_ftruncate.constprop.11+0x118/0x170
[221850.953716]  [<ffffffff81189afe>] sys_ftruncate+0xe/0x10
[221850.953723]  [<ffffffff814d93dd>] system_call_fastpath+0x1a/0x1f
[221850.953729] INFO: task flush-btrfs-1:15339 blocked for more than 120 
seconds.
[221850.953853] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[221850.953987] flush-btrfs-1   D ffff88005f6d5a70     0 15339 2 0x00000000
[221850.953994]  ffff88005f6d59e0 0000000000000046 0000000000014280 
ffff88005f6d5fd8
[221850.954001]  ffff88005f6d5fd8 0000000000014280 ffff880073266ce0 
ffffffffa0a4606e
[221850.954008]  0000000000000000 0000000000000050 ffff88005f6d5a6c 
ffff880073266ce0
[221850.954015] Call Trace:
[221850.954045]  [<ffffffffa0a4606e>] ? run_delalloc_range+0x19e/0x3a0 
[btrfs]
[221850.954052]  [<ffffffff8101c919>] ? read_tsc+0x9/0x20
[221850.954059]  [<ffffffff81121450>] ? filemap_fdatawait+0x30/0x30
[221850.954066]  [<ffffffff814d0649>] schedule+0x29/0x70
[221850.954071]  [<ffffffff814d08ef>] io_schedule+0x8f/0xe0
[221850.954078]  [<ffffffff8112145e>] sleep_on_page+0xe/0x20
[221850.954086]  [<ffffffff814ce33b>] __wait_on_bit_lock+0x5b/0xc0
[221850.954093]  [<ffffffff8112159a>] __lock_page+0x6a/0x70
[221850.954099]  [<ffffffff8107c430>] ? autoremove_wake_function+0x40/0x40
[221850.954129]  [<ffffffffa0a56e2e>] ? flush_write_bio+0xe/0x10 [btrfs]
[221850.954158]  [<ffffffffa0a5ba51>] 
extent_write_cache_pages.isra.31.constprop.47+0x391/0x3e0 [btrfs]
[221850.954189]  [<ffffffffa0a5bd8d>] extent_writepages+0x4d/0x70 [btrfs]
[221850.954218]  [<ffffffffa0a42230>] ? can_nocow_odirect+0x270/0x270 
[btrfs]
[221850.954247]  [<ffffffffa0a41188>] btrfs_writepages+0x28/0x30 [btrfs]
[221850.954253]  [<ffffffff8112d55e>] do_writepages+0x1e/0x40
[221850.954262]  [<ffffffff811b3890>] __writeback_single_inode+0x40/0x320
[221850.954270]  [<ffffffff811b5d02>] writeback_sb_inodes+0x252/0x440
[221850.954278]  [<ffffffff811b5f8f>] __writeback_inodes_wb+0x9f/0xd0
[221850.954286]  [<ffffffff811b62eb>] wb_writeback+0x32b/0x360
[221850.954295]  [<ffffffff811b6ac8>] wb_do_writeback+0x1b8/0x250
[221850.954303]  [<ffffffff811b6bf3>] bdi_writeback_thread+0x93/0x2f0
[221850.954311]  [<ffffffff811b6b60>] ? wb_do_writeback+0x250/0x250
[221850.954317]  [<ffffffff8107b5d0>] kthread+0xc0/0xd0
[221850.954323]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221850.954330]  [<ffffffff814d932c>] ret_from_fork+0x7c/0xb0
[221850.954336]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221850.954348] INFO: task btrfs-endio-wri:1294 blocked for more than 
120 seconds.
[221850.954473] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[221850.954608] btrfs-endio-wri D ffff8800734a79e8     0  1294 2 0x00000000
[221850.954614]  ffff880007ddfc88 0000000000000046 0000000000014280 
ffff880007ddffd8
[221850.954621]  ffff880007ddffd8 0000000000014280 ffff880073b98860 
ffff880007ddfbf0
[221850.954627]  0000000000000297 ffffea000038dc40 0000000000000000 
0000000000000001
[221850.954634] Call Trace:
[221850.954642]  [<ffffffff811299a7>] ? __free_pages+0x47/0x50
[221850.954648]  [<ffffffff81129bb2>] ? __free_memcg_kmem_pages+0x22/0x50
[221850.954679]  [<ffffffffa0a56704>] ? tree_insert+0x54/0x60 [btrfs]
[221850.954708]  [<ffffffffa0a5655e>] ? set_state_bits+0x3e/0x80 [btrfs]
[221850.954715]  [<ffffffff814d0649>] schedule+0x29/0x70
[221850.954743]  [<ffffffffa0a3cc35>] 
wait_current_trans.isra.20+0xa5/0xf0 [btrfs]
[221850.954749]  [<ffffffff8107c3f0>] ? wake_up_bit+0x30/0x30
[221850.954778]  [<ffffffffa0a3e0e8>] start_transaction+0x338/0x530 [btrfs]
[221850.954807]  [<ffffffffa0a594e8>] ? test_range_bit+0xe8/0x130 [btrfs]
[221850.954836]  [<ffffffffa0a3e337>] btrfs_join_transaction+0x17/0x20 
[btrfs]
[221850.954865]  [<ffffffffa0a4a580>] 
btrfs_finish_ordered_io+0x390/0x9d0 [btrfs]
[221850.954872]  [<ffffffff81172b5a>] ? kmem_cache_free+0x1ea/0x210
[221850.954880]  [<ffffffff81123e97>] ? mempool_free_slab+0x17/0x20
[221850.954887]  [<ffffffff81124439>] ? mempool_free+0x49/0x90
[221850.954895]  [<ffffffff811c1ce5>] ? bio_put+0x75/0x90
[221850.954922]  [<ffffffffa0a7f368>] ? 
end_compressed_bio_write+0xe8/0xf0 [btrfs]
[221850.954951]  [<ffffffffa0a4ada5>] finish_ordered_fn+0x15/0x20 [btrfs]
[221850.954979]  [<ffffffffa0a69edc>] worker_loop+0x12c/0x550 [btrfs]
[221850.954988]  [<ffffffff8108cb42>] ? default_wake_function+0x12/0x20
[221850.955017]  [<ffffffffa0a69db0>] ? btrfs_queue_worker+0x330/0x330 
[btrfs]
[221850.955023]  [<ffffffff8107b5d0>] kthread+0xc0/0xd0
[221850.955030]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120
[221850.955036]  [<ffffffff814d932c>] ret_from_fork+0x7c/0xb0
[221850.955043]  [<ffffffff8107b510>] ? kthread_create_on_node+0x120/0x120

