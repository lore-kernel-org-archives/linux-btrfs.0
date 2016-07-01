Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:39730 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbcGASM3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jul 2016 14:12:29 -0400
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout1.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (port 25) (Exim 4.85 #1)
	id 1bJ2vT-0004yc-CE
	for linux-btrfs@vger.kernel.org; Fri, 01 Jul 2016 20:12:27 +0200
Received: from localhost ([::1]:45128 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
	id 1bJ2vT-0005wP-7q
	for linux-btrfs@vger.kernel.org; Fri, 01 Jul 2016 20:12:27 +0200
Received: from mx10.freenet.de ([195.4.92.20]:36507)
	by mjail1.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
	id 1bJ2sw-0003zR-VO
	for linux-btrfs@vger.kernel.org; Fri, 01 Jul 2016 20:09:50 +0200
Received: from ppp-88-217-0-175.dynamic.mnet-online.de ([88.217.0.175]:33064 helo=[192.168.1.204])
	by mx10.freenet.de with esmtpsa (ID master.b.at.raven@chefmail.de) (TLSv1.2:DHE-RSA-AES128-SHA:128) (port 465) (Exim 4.85 #1)
	id 1bJ2sw-0003TT-Qu
	for linux-btrfs@vger.kernel.org; Fri, 01 Jul 2016 20:09:50 +0200
From: g6094199@freenet.de
Subject: FYI: *buntu - btrfs kernel error
To: linux-btrfs@vger.kernel.org
Message-ID: <dc10db83-ce23-161e-0307-9011f4ed4ec7@chefmail.de>
Date: Fri, 1 Jul 2016 20:09:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

he guys,

yes i know its *buntu xenial and nobody knows what they have backported,
but maybe its still interesting for someone....


its a kvm guest:

uname -a
Linux Storage 4.4.0-29-generic #48-Ubuntu SMP Tue Jun 28 18:34:37 UTC
2016 x86_64 x86_64 x86_64 GNU/Linux

btrfs --version
btrfs-progs v4.4

sudo btrfs fi show /
Label: 'storage'  uuid: f7f34b00-862b-45a7-9cdb-ee1546aac7db
    Total devices 1 FS bytes used 545.22GiB
    devid    1 size 990.00GiB used 550.07GiB path /dev/vda1

sudo btrfs fi df /
Data, single: total=543.01GiB, used=542.54GiB

System, DUP: total=32.00MiB, used=112.00KiB
Metadata, DUP: total=3.50GiB, used=2.68GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

sudo btrfs fi usage /
Overall:
    Device size:         990.00GiB
    Device allocated:         550.07GiB
    Device unallocated:         439.93GiB
    Device missing:             0.00B
    Used:             547.90GiB
    Free (estimated):         440.39GiB    (min: 220.43GiB)
    Data ratio:                  1.00
    Metadata ratio:              2.00
    Global reserve:         512.00MiB    (used: 0.00B)

Data,single: Size:543.01GiB, Used:542.54GiB
   /dev/vda1     543.01GiB

Metadata,DUP: Size:3.50GiB, Used:2.68GiB
   /dev/vda1       7.00GiB

System,DUP: Size:32.00MiB, Used:112.00KiB
   /dev/vda1      64.00MiB

Unallocated:
   /dev/vda1     439.93GiB

[55557.490198] INFO: task btrfs-cleaner:204 blocked for more than 120
seconds.
[55557.490228]       Not tainted 4.4.0-29-generic #48-Ubuntu
[55557.490230] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[55557.490236] btrfs-cleaner   D ffff88005aaafce8     0   204      2
0x00000000
[55557.490241]  ffff88005aaafce8 ffff8801b4bcd780 ffffffff81e11500
ffff88015401b200
[55557.490243]  ffff88005aab0000 ffff8801996fe9f0 ffff8801996fe800
ffff8801996fe9f0
[55557.490245]  0000000000000001 ffff88005aaafd00 ffffffff818295a5
ffff8800bb7941b0
[55557.490247] Call Trace:
[55557.490290]  [<ffffffff818295a5>] schedule+0x35/0x80
[55557.642574]  [<ffffffffc016afb3>]
wait_current_trans.isra.21+0xd3/0x120 [btrfs]
[55557.664980]  [<ffffffff810c3ca0>] ? wake_atomic_t_function+0x60/0x60
[55557.665104]  [<ffffffffc016c8db>] start_transaction+0x2cb/0x4c0 [btrfs]
[55557.665125]  [<ffffffffc016cae8>] btrfs_start_transaction+0x18/0x20
[btrfs]
[55557.665143]  [<ffffffffc0154daf>] btrfs_drop_snapshot+0x7f/0x830 [btrfs]
[55557.665149]  [<ffffffff81828ef6>] ? __schedule+0x3b6/0xa30
[55557.665169]  [<ffffffffc016bae2>]
btrfs_clean_one_deleted_snapshot+0xb2/0x100 [btrfs]
[55557.665188]  [<ffffffffc01643af>] cleaner_kthread+0xcf/0x220 [btrfs]
[55557.665207]  [<ffffffffc01642e0>] ? check_leaf+0x360/0x360 [btrfs]
[55557.665219]  [<ffffffff810a0808>] kthread+0xd8/0xf0
[55557.665223]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0
[55557.665226]  [<ffffffff8182da4f>] ret_from_fork+0x3f/0x70
[55557.665228]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0
[55557.665269] INFO: task kworker/u4:2:4036 blocked for more than 120
seconds.
[55557.665272]       Not tainted 4.4.0-29-generic #48-Ubuntu
[55557.665273] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[55557.665275] kworker/u4:2    D ffff8801254cfc48     0  4036      2
0x00000000
[55557.665294] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[55557.665296]  ffff8801254cfc48 0000000000000040 ffff8801b7052580
ffff8801b4bcbe80
[55557.665298]  ffff8801254d0000 ffff8801996fb9f0 ffff8801996fb800
ffff8801996fb9f0
[55557.665299]  0000000000000001 ffff8801254cfc60 ffffffff818295a5
ffff8800bb7941b0
[55557.665301] Call Trace:
[55557.665304]  [<ffffffff818295a5>] schedule+0x35/0x80
[55557.665316]  [<ffffffffc016afb3>]
wait_current_trans.isra.21+0xd3/0x120 [btrfs]
[55557.665318]  [<ffffffff810c3ca0>] ? wake_atomic_t_function+0x60/0x60
[55557.665331]  [<ffffffffc016c88b>] start_transaction+0x27b/0x4c0 [btrfs]
[55557.665344]  [<ffffffffc016cb27>] btrfs_join_transaction+0x17/0x20
[btrfs]
[55557.665357]  [<ffffffffc0175295>] btrfs_finish_ordered_io+0x435/0x650
[btrfs]
[55557.665367]  [<ffffffff813b991e>] ? bio_free+0x4e/0x60
[55557.665369]  [<ffffffff813b9953>] ? bio_put+0x23/0x30
[55557.665385]  [<ffffffffc0175775>] finish_ordered_fn+0x15/0x20 [btrfs]
[55557.665506]  [<ffffffffc019deaa>] btrfs_scrubparity_helper+0xca/0x2f0
[btrfs]
[55557.665509]  [<ffffffff810abcb7>] ? try_to_wake_up+0x47/0x3b0
[55557.665523]  [<ffffffffc019e15e>] btrfs_endio_write_helper+0xe/0x10
[btrfs]
[55557.665526]  [<ffffffff8109a2c5>] process_one_work+0x165/0x480
[55557.665528]  [<ffffffff8109a62b>] worker_thread+0x4b/0x4c0
[55557.665529]  [<ffffffff8109a5e0>] ? process_one_work+0x480/0x480
[55557.665531]  [<ffffffff810a0808>] kthread+0xd8/0xf0
[55557.665532]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0
[55557.665534]  [<ffffffff8182da4f>] ret_from_fork+0x3f/0x70
[55557.665536]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0
[55557.665538] INFO: task kworker/u4:1:4067 blocked for more than 120
seconds.
[55557.665540]       Not tainted 4.4.0-29-generic #48-Ubuntu
[55557.665540] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[55557.665541] kworker/u4:1    D ffff88001bccfcc8     0  4067      2
0x00000000
[55557.665558] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[55557.665576]  ffff88001bccfcc8 ffffffff811908a9 ffff88015401b200
ffff8801b4bcd780
[55557.665578]  ffff88001bcd0000 ffff8801996fe9f0 ffff8801996fe800
ffff8801996fe9f0
[55557.665580]  0000000000000001 ffff88001bccfce0 ffffffff818295a5
ffff8800bb7941b0
[55557.665581] Call Trace:
[55557.665592]  [<ffffffff811908a9>] ? mempool_free+0x29/0x80
[55557.665594]  [<ffffffff818295a5>] schedule+0x35/0x80
[55557.665607]  [<ffffffffc016afb3>]
wait_current_trans.isra.21+0xd3/0x120 [btrfs]
[55557.665609]  [<ffffffff810c3ca0>] ? wake_atomic_t_function+0x60/0x60
[55557.665622]  [<ffffffffc016c88b>] start_transaction+0x27b/0x4c0 [btrfs]
[55557.665634]  [<ffffffffc016cb27>] btrfs_join_transaction+0x17/0x20
[btrfs]
[55557.665645]  [<ffffffffc0156c38>] delayed_ref_async_start+0x18/0x90
[btrfs]
[55557.665659]  [<ffffffffc019deaa>] btrfs_scrubparity_helper+0xca/0x2f0
[btrfs]
[55557.665673]  [<ffffffffc019e10e>] btrfs_extent_refs_helper+0xe/0x10
[btrfs]
[55557.665675]  [<ffffffff8109a2c5>] process_one_work+0x165/0x480
[55557.665677]  [<ffffffff8109a62b>] worker_thread+0x4b/0x4c0
[55557.665679]  [<ffffffff8109a5e0>] ? process_one_work+0x480/0x480
[55557.665680]  [<ffffffff8109a5e0>] ? process_one_work+0x480/0x480
[55557.665682]  [<ffffffff810a0808>] kthread+0xd8/0xf0
[55557.665683]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0
[55557.665685]  [<ffffffff8182da4f>] ret_from_fork+0x3f/0x70
[55557.665686]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0
[55557.665689] INFO: task kworker/u4:3:4095 blocked for more than 120
seconds.
[55557.665690]       Not tainted 4.4.0-29-generic #48-Ubuntu
[55557.665691] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[55557.665692] kworker/u4:3    D ffff88001b8cfc48     0  4095      2
0x00000000
[55557.665708] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[55557.665709]  ffff88001b8cfc48 0000000000000040 ffff8801b4bcbe80
ffff8801b7319900
[55557.665711]  ffff88001b8d0000 ffff8801996fb9f0 ffff8801996fb800
ffff8801996fb9f0
[55557.665712]  0000000000000001 ffff88001b8cfc60 ffffffff818295a5
ffff8800bb7941b0
[55557.665718] Call Trace:
[55557.665721]  [<ffffffff818295a5>] schedule+0x35/0x80
[55557.665734]  [<ffffffffc016afb3>]
wait_current_trans.isra.21+0xd3/0x120 [btrfs]
[55557.665736]  [<ffffffff810c3ca0>] ? wake_atomic_t_function+0x60/0x60
[55557.665748]  [<ffffffffc016c88b>] start_transaction+0x27b/0x4c0 [btrfs]
[55557.665763]  [<ffffffffc016cb27>] btrfs_join_transaction+0x17/0x20
[btrfs]
[55557.665777]  [<ffffffffc0175295>] btrfs_finish_ordered_io+0x435/0x650
[btrfs]
[55557.665790]  [<ffffffffc0175775>] finish_ordered_fn+0x15/0x20 [btrfs]
[55557.665804]  [<ffffffffc019deaa>] btrfs_scrubparity_helper+0xca/0x2f0
[btrfs]
[55557.665806]  [<ffffffff810abcb7>] ? try_to_wake_up+0x47/0x3b0
[55557.665819]  [<ffffffffc019e15e>] btrfs_endio_write_helper+0xe/0x10
[btrfs]
[55557.665821]  [<ffffffff8109a2c5>] process_one_work+0x165/0x480
[55557.665823]  [<ffffffff8109a62b>] worker_thread+0x4b/0x4c0
[55557.665825]  [<ffffffff8109a5e0>] ? process_one_work+0x480/0x480
[55557.665826]  [<ffffffff810a0808>] kthread+0xd8/0xf0
[55557.665828]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0
[55557.665829]  [<ffffffff8182da4f>] ret_from_fork+0x3f/0x70
[55557.665831]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0
[55557.665833] INFO: task kworker/u4:5:4342 blocked for more than 120
seconds.
[55557.665834]       Not tainted 4.4.0-29-generic #48-Ubuntu
[55557.665835] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[55557.665836] kworker/u4:5    D ffff88014961fc48     0  4342      2
0x00000000
[55557.665852] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[55557.665853]  ffff88014961fc48 0000000000000040 ffff8801b4bce400
ffff8801b7053200
[55557.665855]  ffff880149620000 ffff8801996fb9f0 ffff8801996fb800
ffff8801996fb9f0
[55557.665856]  0000000000000001 ffff88014961fc60 ffffffff818295a5
ffff8800bb7941b0
[55557.665868] Call Trace:
[55557.665871]  [<ffffffff818295a5>] schedule+0x35/0x80
[55557.665883]  [<ffffffffc016afb3>]
wait_current_trans.isra.21+0xd3/0x120 [btrfs]
[55557.665885]  [<ffffffff810c3ca0>] ? wake_atomic_t_function+0x60/0x60
[55557.665898]  [<ffffffffc016c88b>] start_transaction+0x27b/0x4c0 [btrfs]
[55557.665911]  [<ffffffffc016cb27>] btrfs_join_transaction+0x17/0x20
[btrfs]
[55557.665924]  [<ffffffffc0175295>] btrfs_finish_ordered_io+0x435/0x650
[btrfs]
[55557.665937]  [<ffffffffc0175775>] finish_ordered_fn+0x15/0x20 [btrfs]
[55557.665951]  [<ffffffffc019deaa>] btrfs_scrubparity_helper+0xca/0x2f0
[btrfs]
[55557.665952]  [<ffffffff810abcb7>] ? try_to_wake_up+0x47/0x3b0
[55557.665966]  [<ffffffffc019e15e>] btrfs_endio_write_helper+0xe/0x10
[btrfs]
[55557.665968]  [<ffffffff8109a2c5>] process_one_work+0x165/0x480
[55557.665970]  [<ffffffff8109a62b>] worker_thread+0x4b/0x4c0
[55557.665972]  [<ffffffff8109a5e0>] ? process_one_work+0x480/0x480
[55557.665973]  [<ffffffff8109a5e0>] ? process_one_work+0x480/0x480
[55557.665975]  [<ffffffff810a0808>] kthread+0xd8/0xf0
[55557.665976]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0
[55557.665978]  [<ffffffff8182da4f>] ret_from_fork+0x3f/0x70
[55557.665979]  [<ffffffff810a0730>] ? kthread_create_on_node+0x1e0/0x1e0


regards

sash

