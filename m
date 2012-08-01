Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:48916 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2HATyb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 15:54:31 -0400
Received: from luuna.daevel.fr ([82.67.37.138] helo=[192.168.1.50])
	by licorne.daevel.fr with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1Swetw-0008NS-Pp
	for linux-btrfs@vger.kernel.org; Wed, 01 Aug 2012 21:48:13 +0200
Message-ID: <501987FF.9080304@daevel.fr>
Date: Wed, 01 Aug 2012 21:48:15 +0200
From: Olivier Bonvalet <btrfs.list@daevel.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG at fs/btrfs/extent-tree.c:5038 (linux 3.4.7)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have some trouble with a btrfs filesystem.
As you can see in logs, there is lines which are from btrfs (I supposed), then some warnings at fs/btrfs/extent-tree.c, and finally a "kernel BUG" at fs/btrfs/extent-tree.c:5038.

Do you need more informations ?


Aug  1 21:23:10 backup2 kernel: [    7.015184] Btrfs loaded
Aug  1 21:23:10 backup2 kernel: [    7.023314] device fsid a5dfe512-c8a3-46f0-bc8c-6365b8eccdcb devid 1 transid 110423 /dev/mapper/vg--backupplug-backup
Aug  1 21:23:10 backup2 kernel: [    7.024405] btrfs: force zlib compression
Aug  1 21:23:10 backup2 kernel: [    7.024414] btrfs: not using ssd allocation scheme
Aug  1 21:23:10 backup2 kernel: [   17.938241] NET: Registered protocol family 10
Aug  1 21:26:53 backup2 kernel: [   28.880027] eth0: no IPv6 routers present
Aug  1 21:33:39 backup2 kernel: [  435.285128] leaf 615015878656 total ptrs 28 free space 1651
Aug  1 21:33:39 backup2 kernel: [  435.285146] 	item 0 key (642867957760 a8 4096) itemoff 3944 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285153] 		extent refs 1 gen 108436 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285162] 		tree block key (18446744073709551606 80 1215799304192) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285171] 		tree block backref root 7
Aug  1 21:33:39 backup2 kernel: [  435.285179] 	item 1 key (642867970048 a8 4096) itemoff 3893 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285186] 		extent refs 1 gen 38936 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285196] 		tree block key (401571 54 2912287038) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285202] 		shared block backref parent 615081041920
Aug  1 21:33:39 backup2 kernel: [  435.285208] 	item 2 key (642867994624 a8 4096) itemoff 3824 itemsize 69
Aug  1 21:33:39 backup2 kernel: [  435.285214] 		extent refs 3 gen 38909 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285221] 		tree block key (13092 c 12250) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285226] 		shared block backref parent 1306797543424
Aug  1 21:33:39 backup2 kernel: [  435.285231] 		shared block backref parent 1306797494272
Aug  1 21:33:39 backup2 kernel: [  435.285236] 		shared block backref parent 647007399936
Aug  1 21:33:39 backup2 kernel: [  435.285242] 	item 3 key (642868002816 a8 4096) itemoff 3773 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285248] 		extent refs 1 gen 44304 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285255] 		tree block key (1824364519424 a8 94208) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285260] 		tree block backref root 2
Aug  1 21:33:39 backup2 kernel: [  435.285265] 	item 4 key (642868006912 a8 4096) itemoff 3722 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285271] 		extent refs 1 gen 44304 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285278] 		tree block key (1824369225728 a8 118784) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285284] 		tree block backref root 2
Aug  1 21:33:39 backup2 kernel: [  435.285289] 	item 5 key (642868011008 a8 4096) itemoff 3671 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285295] 		extent refs 1 gen 101712 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285302] 		tree block key (833 6c 162816000) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285307] 		shared block backref parent 617940144128
Aug  1 21:33:39 backup2 kernel: [  435.285313] 	item 6 key (642868015104 a8 4096) itemoff 3593 itemsize 78
Aug  1 21:33:39 backup2 kernel: [  435.285321] 		extent refs 4 gen 38909 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285326] 		tree block key (17721 60 119) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285331] 		shared block backref parent 1314062098432
Aug  1 21:33:39 backup2 kernel: [  435.285336] 		shared block backref parent 1314062094336
Aug  1 21:33:39 backup2 kernel: [  435.285341] 		shared block backref parent 1312740683776
Aug  1 21:33:39 backup2 kernel: [  435.285348] 		shared block backref parent 1312740675584
Aug  1 21:33:39 backup2 kernel: [  435.285354] 	item 7 key (642868019200 a8 4096) itemoff 3542 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285360] 		extent refs 1 gen 44307 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285365] 		tree block key (18446744073709551606 80 1825532395520) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285373] 		tree block backref root 7
Aug  1 21:33:39 backup2 kernel: [  435.285378] 	item 8 key (642868023296 a8 4096) itemoff 3491 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285384] 		extent refs 1 gen 101712 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285389] 		tree block key (833 6c 161284096) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285396] 		shared block backref parent 617940144128
Aug  1 21:33:39 backup2 kernel: [  435.285402] 	item 9 key (642868027392 a8 4096) itemoff 3440 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285408] 		extent refs 1 gen 106320 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285416] 		tree block key (708 6c 4009984) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285421] 		shared block backref parent 643144060928
Aug  1 21:33:39 backup2 kernel: [  435.285426] 	item 10 key (642868031488 a8 4096) itemoff 3389 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285433] 		extent refs 1 gen 101179 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285440] 		tree block key (554 6c 45199360) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285445] 		shared block backref parent 644377743360
Aug  1 21:33:39 backup2 kernel: [  435.285450] 	item 11 key (642868035584 a8 4096) itemoff 3338 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285458] 		extent refs 1 gen 109814 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285464] 		tree block key (1393123659776 a8 118784) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285469] 		tree block backref root 2
Aug  1 21:33:39 backup2 kernel: [  435.285474] 	item 12 key (642868043776 a8 4096) itemoff 3287 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285480] 		extent refs 1 gen 109814 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285487] 		tree block key (1393124843520 b8 618853261312) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285493] 		tree block backref root 2
Aug  1 21:33:39 backup2 kernel: [  435.285498] 	item 13 key (642868056064 a8 4096) itemoff 3236 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285506] 		extent refs 1 gen 109232 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285511] 		tree block key (1299755941888 a8 16384) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285516] 		tree block backref root 2
Aug  1 21:33:39 backup2 kernel: [  435.285521] 	item 14 key (642868060160 a8 4096) itemoff 3185 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285527] 		extent refs 1 gen 44304 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285532] 		tree block key (1824360902656 a8 81920) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285538] 		tree block backref root 2
Aug  1 21:33:39 backup2 kernel: [  435.285543] 	item 15 key (642868064256 a8 4096) itemoff 3134 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285550] 		extent refs 1 gen 107019 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285556] 		tree block key (18446744073709551606 80 1362292793344) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285562] 		tree block backref root 7
Aug  1 21:33:39 backup2 kernel: [  435.285567] 	item 16 key (642868068352 a8 4096) itemoff 3065 itemsize 69
Aug  1 21:33:39 backup2 kernel: [  435.285573] 		extent refs 3 gen 38909 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285579] 		tree block key (13089 c 12249) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285585] 		shared block backref parent 1306797543424
Aug  1 21:33:39 backup2 kernel: [  435.285592] 		shared block backref parent 1306797494272
Aug  1 21:33:39 backup2 kernel: [  435.285597] 		shared block backref parent 647007399936
Aug  1 21:33:39 backup2 kernel: [  435.285603] 	item 17 key (642868072448 a8 4096) itemoff 3014 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285609] 		extent refs 1 gen 107019 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285614] 		tree block key (18446744073709551606 80 1362289672192) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285623] 		tree block backref root 7
Aug  1 21:33:39 backup2 kernel: [  435.285628] 	item 18 key (642868076544 a8 4096) itemoff 2945 itemsize 69
Aug  1 21:33:39 backup2 kernel: [  435.285634] 		extent refs 3 gen 97165 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285639] 		tree block key (3262 54 2184751459) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285649] 		shared block backref parent 646044622848
Aug  1 21:33:39 backup2 kernel: [  435.285654] 		shared block backref parent 644201959424
Aug  1 21:33:39 backup2 kernel: [  435.285659] 		shared block backref parent 642867171328
Aug  1 21:33:39 backup2 kernel: [  435.285664] 	item 19 key (642868080640 a8 4096) itemoff 2876 itemsize 69
Aug  1 21:33:39 backup2 kernel: [  435.285673] 		extent refs 3 gen 38909 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285678] 		tree block key (13113 6c 0) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285685] 		shared block backref parent 1306797543424
Aug  1 21:33:39 backup2 kernel: [  435.285692] 		shared block backref parent 1306797494272
Aug  1 21:33:39 backup2 kernel: [  435.285697] 		shared block backref parent 647007399936
Aug  1 21:33:39 backup2 kernel: [  435.285703] 	item 20 key (642868084736 a8 4096) itemoff 2726 itemsize 150
Aug  1 21:33:39 backup2 kernel: [  435.285710] 		extent refs 12 gen 97165 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285717] 		tree block key (3262 54 2256339809) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285722] 		tree block backref root 2698
Aug  1 21:33:39 backup2 kernel: [  435.285726] 		shared block backref parent 646044622848
Aug  1 21:33:39 backup2 kernel: [  435.285733] 		shared block backref parent 645667573760
Aug  1 21:33:39 backup2 kernel: [  435.285738] 		shared block backref parent 645339078656
Aug  1 21:33:39 backup2 kernel: [  435.285743] 		shared block backref parent 644201959424
Aug  1 21:33:39 backup2 kernel: [  435.285748] 		shared block backref parent 643792703488
Aug  1 21:33:39 backup2 kernel: [  435.285753] 		shared block backref parent 643459452928
Aug  1 21:33:39 backup2 kernel: [  435.285759] 		shared block backref parent 643412889600
Aug  1 21:33:39 backup2 kernel: [  435.285764] 		shared block backref parent 642959036416
Aug  1 21:33:39 backup2 kernel: [  435.285769] 		shared block backref parent 642867171328
Aug  1 21:33:39 backup2 kernel: [  435.285774] 		shared block backref parent 642865500160
Aug  1 21:33:39 backup2 kernel: [  435.285781] 		shared block backref parent 618298048512
Aug  1 21:33:39 backup2 kernel: [  435.285787] 	item 21 key (642868088832 a8 4096) itemoff 2675 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285793] 		extent refs 1 gen 38909 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285798] 		tree block key (1788 54 2201505456) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285805] 		shared block backref parent 615111450624
Aug  1 21:33:39 backup2 kernel: [  435.285811] 	item 22 key (642868092928 a8 4096) itemoff 2606 itemsize 69
Aug  1 21:33:39 backup2 kernel: [  435.285817] 		extent refs 3 gen 38909 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285822] 		tree block key (13116 c 12250) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285827] 		shared block backref parent 1306797543424
Aug  1 21:33:39 backup2 kernel: [  435.285834] 		shared block backref parent 1306797494272
Aug  1 21:33:39 backup2 kernel: [  435.285839] 		shared block backref parent 647007399936
Aug  1 21:33:39 backup2 kernel: [  435.285845] 	item 23 key (642868097024 a8 4096) itemoff 2555 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285853] 		extent refs 1 gen 109232 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285864] 		tree block key (1299832553472 a8 8192) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285871] 		tree block backref root 2
Aug  1 21:33:39 backup2 kernel: [  435.285877] 	item 24 key (642868101120 a8 4096) itemoff 2504 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285885] 		extent refs 1 gen 102767 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285893] 		tree block key (18446744073709551606 80 1488237449216) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285899] 		tree block backref root 7
Aug  1 21:33:39 backup2 kernel: [  435.285904] 	item 25 key (642868105216 a8 4096) itemoff 2453 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285912] 		extent refs 1 gen 109232 flags 2
Aug  1 21:33:39 backup2 kernel: [  435.285917] 		tree block key (1299832934400 a8 4096) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285923] 		tree block backref root 2
Aug  1 21:33:39 backup2 kernel: [  435.285927] 	item 26 key (642868109312 a8 4096) itemoff 2402 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285935] 		extent refs 1 gen 101712 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285941] 		tree block key (833 6c 164655104) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285946] 		shared block backref parent 617940144128
Aug  1 21:33:39 backup2 kernel: [  435.285951] 	item 27 key (642868113408 a8 4096) itemoff 2351 itemsize 51
Aug  1 21:33:39 backup2 kernel: [  435.285957] 		extent refs 1 gen 101712 flags 258
Aug  1 21:33:39 backup2 kernel: [  435.285962] 		tree block key (833 6c 168382464) level 0
Aug  1 21:33:39 backup2 kernel: [  435.285967] 		shared block backref parent 617940144128
Aug  1 21:33:39 backup2 kernel: [  435.285972] ------------[ cut here ]------------
Aug  1 21:33:39 backup2 kernel: [  435.285994] WARNING: at fs/btrfs/extent-tree.c:5022 __btrfs_free_extent+0x2a9/0x5cf [btrfs]()
Aug  1 21:33:39 backup2 kernel: [  435.286002] Modules linked in: xt_LOG nf_conntrack_ipv4 nf_defrag_ipv4 ipv6 xt_state btrfs nf_conntrack
Aug  1 21:33:39 backup2 kernel: [  435.286019] Pid: 1651, comm: btrfs-transacti Tainted: G         C   2.6.44.7-dae-xen #2
Aug  1 21:33:39 backup2 kernel: [  435.286026] Call Trace:
Aug  1 21:33:39 backup2 kernel: [  435.286035]  [<ffffffff8103c7cf>] ? warn_slowpath_common+0x76/0x8a
Aug  1 21:33:39 backup2 kernel: [  435.286049]  [<ffffffffa002ab4e>] ? __btrfs_free_extent+0x2a9/0x5cf [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.286058]  [<ffffffff813007dc>] ? __slab_free+0xd7/0x271
Aug  1 21:33:39 backup2 kernel: [  435.286077]  [<ffffffffa006fae5>] ? arch_spin_is_locked+0x5/0x8 [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.286093]  [<ffffffffa002e09c>] ? run_clustered_refs+0x72b/0x7c2 [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.286108]  [<ffffffffa0027010>] ? spin_unlock+0x5/0x8 [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.286123]  [<ffffffffa002e34c>] ? btrfs_run_delayed_refs+0x219/0x318 [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.286144]  [<ffffffffa0077cda>] ? btrfs_run_delayed_items+0x106/0x12b [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.286153]  [<ffffffff8106e62f>] ? do_raw_spin_unlock+0x5/0x8
Aug  1 21:33:39 backup2 kernel: [  435.286160]  [<ffffffff8106e5f7>] ? arch_local_irq_restore+0x7/0x8
Aug  1 21:33:39 backup2 kernel: [  435.286178]  [<ffffffffa003bbb5>] ? btrfs_commit_transaction+0x3b5/0x875 [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.286187]  [<ffffffff8106e5f7>] ? arch_local_irq_restore+0x7/0x8
Aug  1 21:33:39 backup2 kernel: [  435.286195]  [<ffffffff81051c0e>] ? abort_exclusive_wait+0x79/0x79
Aug  1 21:33:39 backup2 kernel: [  435.286213]  [<ffffffffa003b1e2>] ? join_transaction.isra.28+0x283/0x291 [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.286233]  [<ffffffffa003c4be>] ? start_transaction+0x1f4/0x24b [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.286250]  [<ffffffffa0035e9e>] ? transaction_kthread+0x17a/0x22e [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.485313]  [<ffffffffa0035d24>] ? try_to_freeze+0x2c/0x2c [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.485331]  [<ffffffff8105173a>] ? kthread+0x7d/0x85
Aug  1 21:33:39 backup2 kernel: [  435.485342]  [<ffffffff81305c64>] ? kernel_thread_helper+0x4/0x10
Aug  1 21:33:39 backup2 kernel: [  435.485353]  [<ffffffff813041b8>] ? retint_restore_args+0x5/0x6
Aug  1 21:33:39 backup2 kernel: [  435.485362]  [<ffffffff81305c60>] ? gs_change+0x13/0x13
Aug  1 21:33:39 backup2 kernel: [  435.485371] ---[ end trace d5809b3a28fe4bda ]---
Aug  1 21:33:39 backup2 kernel: [  435.485382] btrfs unable to find ref byte nr 642867965952 parent 0 root 5  owner 1 offset 0
Aug  1 21:33:39 backup2 kernel: [  435.485395] ------------[ cut here ]------------
Aug  1 21:33:39 backup2 kernel: [  435.485412] WARNING: at fs/btrfs/extent-tree.c:5073 __btrfs_free_extent+0x40f/0x5cf [btrfs]()
Aug  1 21:33:39 backup2 kernel: [  435.485423] Modules linked in: xt_LOG nf_conntrack_ipv4 nf_defrag_ipv4 ipv6 xt_state btrfs nf_conntrack
Aug  1 21:33:39 backup2 kernel: [  435.485451] Pid: 1651, comm: btrfs-transacti Tainted: G        WC   2.6.44.7-dae-xen #2
Aug  1 21:33:39 backup2 kernel: [  435.485461] Call Trace:
Aug  1 21:33:39 backup2 kernel: [  435.485470]  [<ffffffff8103c7cf>] ? warn_slowpath_common+0x76/0x8a
Aug  1 21:33:39 backup2 kernel: [  435.485488]  [<ffffffffa002acb4>] ? __btrfs_free_extent+0x40f/0x5cf [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.485500]  [<ffffffff813007dc>] ? __slab_free+0xd7/0x271
Aug  1 21:33:39 backup2 kernel: [  435.485523]  [<ffffffffa006fae5>] ? arch_spin_is_locked+0x5/0x8 [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.485542]  [<ffffffffa002e09c>] ? run_clustered_refs+0x72b/0x7c2 [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.485561]  [<ffffffffa0027010>] ? spin_unlock+0x5/0x8 [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.485581]  [<ffffffffa002e34c>] ? btrfs_run_delayed_refs+0x219/0x318 [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.485606]  [<ffffffffa0077cda>] ? btrfs_run_delayed_items+0x106/0x12b [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.485618]  [<ffffffff8106e62f>] ? do_raw_spin_unlock+0x5/0x8
Aug  1 21:33:39 backup2 kernel: [  435.485630]  [<ffffffff8106e5f7>] ? arch_local_irq_restore+0x7/0x8
Aug  1 21:33:39 backup2 kernel: [  435.485653]  [<ffffffffa003bbb5>] ? btrfs_commit_transaction+0x3b5/0x875 [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.485665]  [<ffffffff8106e5f7>] ? arch_local_irq_restore+0x7/0x8
Aug  1 21:33:39 backup2 kernel: [  435.485675]  [<ffffffff81051c0e>] ? abort_exclusive_wait+0x79/0x79
Aug  1 21:33:39 backup2 kernel: [  435.485699]  [<ffffffffa003b1e2>] ? join_transaction.isra.28+0x283/0x291 [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.485724]  [<ffffffffa003c4be>] ? start_transaction+0x1f4/0x24b [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.485747]  [<ffffffffa0035e9e>] ? transaction_kthread+0x17a/0x22e [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.485770]  [<ffffffffa0035d24>] ? try_to_freeze+0x2c/0x2c [btrfs]
Aug  1 21:33:39 backup2 kernel: [  435.485782]  [<ffffffff8105173a>] ? kthread+0x7d/0x85
Aug  1 21:33:39 backup2 kernel: [  435.485788]  [<ffffffff81305c64>] ? kernel_thread_helper+0x4/0x10
Aug  1 21:33:39 backup2 kernel: [  435.485796]  [<ffffffff813041b8>] ? retint_restore_args+0x5/0x6
Aug  1 21:33:39 backup2 kernel: [  435.485805]  [<ffffffff81305c60>] ? gs_change+0x13/0x13
Aug  1 21:33:39 backup2 kernel: [  435.485813] ---[ end trace d5809b3a28fe4bdb ]---
Aug  1 21:33:39 backup2 kernel: [  435.488037] parent transid verify failed on 615015964672 wanted 110423 found 110424
Aug  1 21:33:40 backup2 kernel: [  435.520841] btrfs read error corrected: ino 1 off 615015964672 (dev /dev/mapper/vg--backupplug-backup sector 1209083760)
Aug  1 21:33:40 backup2 kernel: [  435.520896] leaf 615015903232 total ptrs 52 free space 1114
Aug  1 21:33:40 backup2 kernel: [  435.520904] 	item 0 key (615015927808 b6 615143944192) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.520910] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.520915] 	item 1 key (615015927808 b6 615143989248) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.520922] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.520926] 	item 2 key (615015927808 b6 618017591296) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.520933] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.520937] 	item 3 key (615015927808 b6 618393165824) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.520944] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.520949] 	item 4 key (615015927808 b6 618466762752) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.520955] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.520960] 	item 5 key (615015927808 b6 618605518848) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.520966] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.520971] 	item 6 key (615015927808 b6 632293793792) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.520977] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.520982] 	item 7 key (615015927808 b6 632419733504) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.520989] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.520993] 	item 8 key (615015927808 b6 632459755520) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.521000] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.521005] 	item 9 key (615015927808 b6 642169331712) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.521011] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.521016] 	item 10 key (615015927808 b6 642706571264) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.521022] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.521027] 	item 11 key (615015927808 b6 643082162176) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.521033] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.521038] 	item 12 key (615015927808 b6 644046438400) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.521044] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.521049] 	item 13 key (615015927808 b6 644105711616) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.521055] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.521060] 	item 14 key (615015927808 b6 645157392384) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.521067] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.521071] 	item 15 key (615015927808 b6 645949968384) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.521078] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.521082] 	item 16 key (615015927808 b6 646083702784) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.685205] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.685219] 	item 17 key (615015927808 b6 647496245248) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.685236] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.685247] 	item 18 key (615015927808 b6 647586762752) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.685264] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.685274] 	item 19 key (615015927808 b6 1312669048832) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.685291] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.685301] 	item 20 key (615015927808 b6 1350289035264) itemoff 3995 itemsize 0
Aug  1 21:33:40 backup2 kernel: [  435.685318] 		shared block backref
Aug  1 21:33:40 backup2 kernel: [  435.685329] 	item 21 key (615015931904 a8 4096) itemoff 3944 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685345] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.685356] 		tree block key (632346750976 a8 4096) level 0
Aug  1 21:33:40 backup2 kernel: [  435.685370] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.685380] 	item 22 key (615015936000 a8 4096) itemoff 3893 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685397] 		extent refs 1 gen 44855 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.685408] 		tree block key (350585 54 3891015556) level 1
Aug  1 21:33:40 backup2 kernel: [  435.685423] 		shared block backref parent 1312623005696
Aug  1 21:33:40 backup2 kernel: [  435.685435] 	item 23 key (615015940096 a8 4096) itemoff 3842 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685451] 		extent refs 1 gen 44855 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.685462] 		tree block key (350585 54 3892699538) level 0
Aug  1 21:33:40 backup2 kernel: [  435.685476] 		shared block backref parent 615015936000
Aug  1 21:33:40 backup2 kernel: [  435.685489] 	item 24 key (615015944192 a8 4096) itemoff 3791 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685505] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.685516] 		tree block key (632346931200 a8 4096) level 0
Aug  1 21:33:40 backup2 kernel: [  435.685526] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.685536] 	item 25 key (615015948288 a8 4096) itemoff 3740 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685553] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.685564] 		tree block key (632347131904 a8 4096) level 0
Aug  1 21:33:40 backup2 kernel: [  435.685578] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.685586] 	item 26 key (615015952384 a8 4096) itemoff 3689 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685598] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.685609] 		tree block key (632348577792 a8 4096) level 0
Aug  1 21:33:40 backup2 kernel: [  435.685618] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.685626] 	item 27 key (615015956480 a8 4096) itemoff 3638 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685639] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.685648] 		tree block key (632349069312 a8 4096) level 0
Aug  1 21:33:40 backup2 kernel: [  435.685659] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.685667] 	item 28 key (615015960576 a8 4096) itemoff 3587 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685677] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.685688] 		tree block key (615015415808 a8 4096) level 0
Aug  1 21:33:40 backup2 kernel: [  435.685696] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.685704] 	item 29 key (615015964672 a8 4096) itemoff 3536 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685717] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.685726] 		tree block key (632218943488 a8 4096) level 1
Aug  1 21:33:40 backup2 kernel: [  435.685734] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.685745] 	item 30 key (615015968768 a8 4096) itemoff 3485 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685755] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.685763] 		tree block key (632227590144 a8 4096) level 0
Aug  1 21:33:40 backup2 kernel: [  435.685775] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.685784] 	item 31 key (615015972864 a8 4096) itemoff 3434 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685800] 		extent refs 1 gen 44855 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.685811] 		tree block key (66190 54 758361044) level 1
Aug  1 21:33:40 backup2 kernel: [  435.685826] 		shared block backref parent 1317943054336
Aug  1 21:33:40 backup2 kernel: [  435.685838] 	item 32 key (615015976960 a8 4096) itemoff 3383 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685854] 		extent refs 1 gen 44855 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.685864] 		tree block key (66190 54 2794591185) level 0
Aug  1 21:33:40 backup2 kernel: [  435.685876] 		shared block backref parent 615015972864
Aug  1 21:33:40 backup2 kernel: [  435.685891] 	item 33 key (615015981056 a8 4096) itemoff 3332 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685904] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.685918] 		tree block key (632262762496 a8 4096) level 1
Aug  1 21:33:40 backup2 kernel: [  435.685929] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.685942] 	item 34 key (615015985152 a8 4096) itemoff 3281 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.685955] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.685969] 		tree block key (632271273984 a8 4096) level 0
Aug  1 21:33:40 backup2 kernel: [  435.685981] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.685994] 	item 35 key (615015989248 a8 4096) itemoff 3230 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.686007] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.686018] 		tree block key (632289968128 a8 4096) level 1
Aug  1 21:33:40 backup2 kernel: [  435.686027] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.686034] 	item 36 key (615015993344 a8 4096) itemoff 3179 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.686042] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.686050] 		tree block key (632301543424 b6 645726699520) level 0
Aug  1 21:33:40 backup2 kernel: [  435.686058] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.686065] 	item 37 key (615015997440 a8 4096) itemoff 3128 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.686074] 		extent refs 1 gen 68796 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.686081] 		tree block key (1448 54 1555482842) level 0
Aug  1 21:33:40 backup2 kernel: [  435.686088] 		shared block backref parent 642470191104
Aug  1 21:33:40 backup2 kernel: [  435.686096] 	item 38 key (615016001536 a8 4096) itemoff 3077 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.686105] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.686113] 		tree block key (632302252032 a8 4096) level 1
Aug  1 21:33:40 backup2 kernel: [  435.686120] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.686127] 	item 39 key (615016005632 a8 4096) itemoff 3026 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.686136] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.686143] 		tree block key (632302252032 a8 4096) level 0
Aug  1 21:33:40 backup2 kernel: [  435.686150] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.686157] 	item 40 key (615016009728 a8 4096) itemoff 2975 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.686166] 		extent refs 1 gen 44855 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.686173] 		tree block key (2573968 c 350503) level 0
Aug  1 21:33:40 backup2 kernel: [  435.686181] 		shared block backref parent 1317994450944
Aug  1 21:33:40 backup2 kernel: [  435.686189] 	item 41 key (615016013824 a8 4096) itemoff 2924 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.686198] 		extent refs 1 gen 44855 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.686205] 		tree block key (4866 60 611) level 0
Aug  1 21:33:40 backup2 kernel: [  435.686212] 		shared block backref parent 1316577009664
Aug  1 21:33:40 backup2 kernel: [  435.686220] 	item 42 key (615016017920 a8 4096) itemoff 2873 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.686229] 		extent refs 1 gen 44855 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.686236] 		tree block key (4883 54 2375128439) level 0
Aug  1 21:33:40 backup2 kernel: [  435.686243] 		shared block backref parent 1317896613888
Aug  1 21:33:40 backup2 kernel: [  435.686249] 	item 43 key (615016022016 a8 4096) itemoff 2822 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.885308] 		extent refs 1 gen 44855 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.885315] 		tree block key (4883 54 3035664173) level 0
Aug  1 21:33:40 backup2 kernel: [  435.885323] 		shared block backref parent 1317896613888
Aug  1 21:33:40 backup2 kernel: [  435.885330] 	item 44 key (615016026112 a8 4096) itemoff 2771 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.885336] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.885344] 		tree block key (615015206912 a8 4096) level 0
Aug  1 21:33:40 backup2 kernel: [  435.885350] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.885355] 	item 45 key (615016030208 a8 4096) itemoff 2720 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.885363] 		extent refs 1 gen 44855 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.885368] 		tree block key (4883 54 3707954297) level 0
Aug  1 21:33:40 backup2 kernel: [  435.885373] 		shared block backref parent 1317896613888
Aug  1 21:33:40 backup2 kernel: [  435.885381] 	item 46 key (615016034304 a8 4096) itemoff 2669 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.885388] 		extent refs 1 gen 44855 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.885393] 		tree block key (1831133 6c 0) level 0
Aug  1 21:33:40 backup2 kernel: [  435.885398] 		shared block backref parent 1349895577600
Aug  1 21:33:40 backup2 kernel: [  435.885406] 	item 47 key (615016038400 a8 4096) itemoff 2618 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.885412] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.885417] 		tree block key (632228835328 a8 4096) level 1
Aug  1 21:33:40 backup2 kernel: [  435.885424] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.885429] 	item 48 key (615016042496 a8 4096) itemoff 2567 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.885435] 		extent refs 1 gen 110424 flags 2
Aug  1 21:33:40 backup2 kernel: [  435.885440] 		tree block key (632230457344 a8 4096) level 0
Aug  1 21:33:40 backup2 kernel: [  435.885447] 		tree block backref root 2
Aug  1 21:33:40 backup2 kernel: [  435.885453] 	item 49 key (615016046592 a8 4096) itemoff 2516 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.885459] 		extent refs 1 gen 44855 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.885466] 		tree block key (350585 54 3006241221) level 0
Aug  1 21:33:40 backup2 kernel: [  435.885471] 		shared block backref parent 1316754350080
Aug  1 21:33:40 backup2 kernel: [  435.885477] 	item 50 key (615016050688 a8 4096) itemoff 2465 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.885485] 		extent refs 1 gen 44855 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.885491] 		tree block key (4883 54 1070372513) level 0
Aug  1 21:33:40 backup2 kernel: [  435.885496] 		shared block backref parent 1317896613888
Aug  1 21:33:40 backup2 kernel: [  435.885503] 	item 51 key (615016054784 a8 4096) itemoff 2414 itemsize 51
Aug  1 21:33:40 backup2 kernel: [  435.885510] 		extent refs 1 gen 44855 flags 258
Aug  1 21:33:40 backup2 kernel: [  435.885515] 		tree block key (350585 54 1403681717) level 0
Aug  1 21:33:40 backup2 kernel: [  435.885520] 		shared block backref parent 1313931538432
Aug  1 21:33:40 backup2 kernel: [  435.885525] ------------[ cut here ]------------
Aug  1 21:33:40 backup2 kernel: [  435.885542] WARNING: at fs/btrfs/extent-tree.c:5022 __btrfs_free_extent+0x2a9/0x5cf [btrfs]()
Aug  1 21:33:40 backup2 kernel: [  435.885552] Modules linked in: xt_LOG nf_conntrack_ipv4 nf_defrag_ipv4 ipv6 xt_state btrfs nf_conntrack
Aug  1 21:33:40 backup2 kernel: [  435.885571] Pid: 1651, comm: btrfs-transacti Tainted: G        WC   2.6.44.7-dae-xen #2
Aug  1 21:33:40 backup2 kernel: [  435.885580] Call Trace:
Aug  1 21:33:40 backup2 kernel: [  435.885587]  [<ffffffff8103c7cf>] ? warn_slowpath_common+0x76/0x8a
Aug  1 21:33:40 backup2 kernel: [  435.885604]  [<ffffffffa002ab4e>] ? __btrfs_free_extent+0x2a9/0x5cf [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885614]  [<ffffffff81097be5>] ? __set_page_dirty_nobuffers+0xc4/0xe0
Aug  1 21:33:40 backup2 kernel: [  435.885635]  [<ffffffffa006fae5>] ? arch_spin_is_locked+0x5/0x8 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885653]  [<ffffffffa002e09c>] ? run_clustered_refs+0x72b/0x7c2 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885669]  [<ffffffffa00233f9>] ? comp_keys+0x26/0x2b [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885685]  [<ffffffffa0027010>] ? spin_unlock+0x5/0x8 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885703]  [<ffffffffa002e34c>] ? btrfs_run_delayed_refs+0x219/0x318 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885723]  [<ffffffffa0031e08>] ? btrfs_update_root+0xc6/0xdb [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885740]  [<ffffffffa007f8cd>] ? commit_cowonly_roots+0x24/0x199 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885760]  [<ffffffffa00768fa>] ? spin_unlock+0x5/0x8 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885781]  [<ffffffffa003bc34>] ? btrfs_commit_transaction+0x434/0x875 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885791]  [<ffffffff8106e5f7>] ? arch_local_irq_restore+0x7/0x8
Aug  1 21:33:40 backup2 kernel: [  435.885799]  [<ffffffff81051c0e>] ? abort_exclusive_wait+0x79/0x79
Aug  1 21:33:40 backup2 kernel: [  435.885818]  [<ffffffffa003b1e2>] ? join_transaction.isra.28+0x283/0x291 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885841]  [<ffffffffa003c4be>] ? start_transaction+0x1f4/0x24b [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885862]  [<ffffffffa0035e9e>] ? transaction_kthread+0x17a/0x22e [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885882]  [<ffffffffa0035d24>] ? try_to_freeze+0x2c/0x2c [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.885889]  [<ffffffff8105173a>] ? kthread+0x7d/0x85
Aug  1 21:33:40 backup2 kernel: [  435.885896]  [<ffffffff81305c64>] ? kernel_thread_helper+0x4/0x10
Aug  1 21:33:40 backup2 kernel: [  435.885904]  [<ffffffff813041b8>] ? retint_restore_args+0x5/0x6
Aug  1 21:33:40 backup2 kernel: [  435.885911]  [<ffffffff81305c60>] ? gs_change+0x13/0x13
Aug  1 21:33:40 backup2 kernel: [  435.885916] ---[ end trace d5809b3a28fe4bdc ]---
Aug  1 21:33:40 backup2 kernel: [  435.885922] btrfs unable to find ref byte nr 615015964672 parent 0 root 1  owner 0 offset 0
Aug  1 21:33:40 backup2 kernel: [  435.885937] ------------[ cut here ]------------
Aug  1 21:33:40 backup2 kernel: [  435.885942] kernel BUG at fs/btrfs/extent-tree.c:5038!
Aug  1 21:33:40 backup2 kernel: [  435.885947] invalid opcode: 0000 [#1] SMP
Aug  1 21:33:40 backup2 kernel: [  435.885953] CPU 0
Aug  1 21:33:40 backup2 kernel: [  435.885955] Modules linked in: xt_LOG nf_conntrack_ipv4 nf_defrag_ipv4 ipv6 xt_state btrfs nf_conntrack
Aug  1 21:33:40 backup2 kernel: [  435.885970]
Aug  1 21:33:40 backup2 kernel: [  435.885975] Pid: 1651, comm: btrfs-transacti Tainted: G        WC   2.6.44.7-dae-xen #2
Aug  1 21:33:40 backup2 kernel: [  435.885984] RIP: e030:[<ffffffffa002ab97>]  [<ffffffffa002ab97>] __btrfs_free_extent+0x2f2/0x5cf [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.886002] RSP: e02b:ffff880172689ae0  EFLAGS: 00010297
Aug  1 21:33:40 backup2 kernel: [  435.886008] RAX: 0000000000000000 RBX: ffff88017554f1b0 RCX: ffff880176ef7000
Aug  1 21:33:40 backup2 kernel: [  435.886014] RDX: 0000000000000000 RSI: 000000000000007a RDI: ffff88017555cc18
Aug  1 21:33:40 backup2 kernel: [  435.886021] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff880172689aa8
Aug  1 21:33:40 backup2 kernel: [  435.886027] R10: 0000000000000000 R11: 0000000000000004 R12: ffff88017555cc18
Aug  1 21:33:40 backup2 kernel: [  435.886033] R13: 0000000000000000 R14: 00000000fffffffe R15: 0000008f31cee000
Aug  1 21:33:40 backup2 kernel: [  435.886044] FS:  00007f0f2e59b700(0000) GS:ffff88017fc00000(0000) knlGS:0000000000000000
Aug  1 21:33:40 backup2 kernel: [  435.886052] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug  1 21:33:40 backup2 kernel: [  435.886057] CR2: 00007fe614c28940 CR3: 0000000171c15000 CR4: 0000000000002660
Aug  1 21:33:40 backup2 kernel: [  435.886064] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug  1 21:33:40 backup2 kernel: [  435.886070] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug  1 21:33:40 backup2 kernel: [  435.886077] Process btrfs-transacti (pid: 1651, threadinfo ffff880172688000, task ffff880178092c30)
Aug  1 21:33:40 backup2 kernel: [  435.886084] Stack:
Aug  1 21:33:40 backup2 kernel: [  435.889275]  0000000000000000 0000000000000001 0000000000000000 0000000000000000
Aug  1 21:33:40 backup2 kernel: [  435.889275]  ffff880100000000 ffffffff81097be5 0000000000000033 ffff8801776ddc00
Aug  1 21:33:40 backup2 kernel: [  435.889275]  ffff88016d0c4000 ffffea0005d553c0 0000000000001000 0000000000000024
Aug  1 21:33:40 backup2 kernel: [  435.889275] Call Trace:
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffff81097be5>] ? __set_page_dirty_nobuffers+0xc4/0xe0
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffffa006fae5>] ? arch_spin_is_locked+0x5/0x8 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffffa002e09c>] ? run_clustered_refs+0x72b/0x7c2 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffffa00233f9>] ? comp_keys+0x26/0x2b [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffffa0027010>] ? spin_unlock+0x5/0x8 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffffa002e34c>] ? btrfs_run_delayed_refs+0x219/0x318 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffffa0031e08>] ? btrfs_update_root+0xc6/0xdb [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffffa007f8cd>] ? commit_cowonly_roots+0x24/0x199 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffffa00768fa>] ? spin_unlock+0x5/0x8 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffffa003bc34>] ? btrfs_commit_transaction+0x434/0x875 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffff8106e5f7>] ? arch_local_irq_restore+0x7/0x8
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffff81051c0e>] ? abort_exclusive_wait+0x79/0x79
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffffa003b1e2>] ? join_transaction.isra.28+0x283/0x291 [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffffa003c4be>] ? start_transaction+0x1f4/0x24b [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffffa0035e9e>] ? transaction_kthread+0x17a/0x22e [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffffa0035d24>] ? try_to_freeze+0x2c/0x2c [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffff8105173a>] ? kthread+0x7d/0x85
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffff81305c64>] ? kernel_thread_helper+0x4/0x10
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffff813041b8>] ? retint_restore_args+0x5/0x6
Aug  1 21:33:40 backup2 kernel: [  435.889275]  [<ffffffff81305c60>] ? gs_change+0x13/0x13
Aug  1 21:33:40 backup2 kernel: [  435.889275] Code: 31 ed 31 ed e8 47 3d 2d e1 4c 8b 23 89 ee 4c 89 e7 e8 19 cd ff ff 83 f8 17 89 c2 0f 87 cb 00 00 00 45 85 ed 75 05 3b 6b 40 74 02 <0f> 0b 48 8b 8c 24 d0 00 00 00 45 31 c0 48 89 da 48 8b 74 24 38
Aug  1 21:33:40 backup2 kernel: [  435.889275] RIP  [<ffffffffa002ab97>] __btrfs_free_extent+0x2f2/0x5cf [btrfs]
Aug  1 21:33:40 backup2 kernel: [  435.889275]  RSP <ffff880172689ae0>
Aug  1 21:33:40 backup2 kernel: [  436.085626] ---[ end trace d5809b3a28fe4bdd ]---
