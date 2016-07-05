Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:58759 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbcGEGEM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jul 2016 02:04:12 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id A4C293592CB
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Jul 2016 07:56:28 +0200 (CEST)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DELqeuprOA7H for <linux-btrfs@vger.kernel.org>;
	Tue,  5 Jul 2016 07:56:26 +0200 (CEST)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Jul 2016 07:56:26 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 05 Jul 2016 14:56:26 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: filesystem read only after power outage
Message-ID: <7db11e52ffdd949a917036bc38f4b0f1@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Getting this lengthy output logged, and the fs mounter read-only after a 
power outage.


Tried also 4.6.3, but it ends just alike.

Jul  5 02:04:20 bkp011 kernel: [  799.298303] ------------[ cut here 
]------------
Jul  5 02:04:20 bkp011 kernel: [  799.298335] WARNING: CPU: 0 PID: 1896 
at /home/kernel/COD/linux/fs/btrfs/extent-tree.c:6599 
__btrfs_free_extent.isra.70+0x877/0xd50 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.298337] Modules linked in: 
xt_CHECKSUM iptable_mangle xt_nat xt_tcpudp ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables bridge 
stp llc btrfs intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp 
kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel aesni_intel ppdev eeepc_wmi asus_wmi aes_x86_64 
sparse_keymap lrw gf128mul input_leds serio_raw glue_helper lpc_ich 
ablk_helper shpchp 8250_fintek cryptd mac_hid tpm_infineon parport_pc lp 
parport autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq 
async_xor async_tx xor raid6_pq libcrc32c raid0 multipath linear raid1 
ahci r8169 libahci mii wmi video fjes
Jul  5 02:04:20 bkp011 kernel: [  799.298388] CPU: 0 PID: 1896 Comm: 
btrfs-cleaner Not tainted 4.6.0-040600-generic #201605151930
Jul  5 02:04:20 bkp011 kernel: [  799.298389] Hardware name: System 
manufacturer System Product Name/P8H67-M PRO, BIOS 1106 10/17/2011
Jul  5 02:04:20 bkp011 kernel: [  799.298392]  0000000000000286 
00000000a9a73565 ffff880418a97b20 ffffffff813f1dd3
Jul  5 02:04:20 bkp011 kernel: [  799.298395]  0000000000000000 
0000000000000000 ffff880418a97b60 ffffffff810827eb
Jul  5 02:04:20 bkp011 kernel: [  799.298398]  000019c7c02d62c6 
00000000fffffffe 000002ab7a2a0000 000002d091318000
Jul  5 02:04:20 bkp011 kernel: [  799.298401] Call Trace:
Jul  5 02:04:20 bkp011 kernel: [  799.298407]  [<ffffffff813f1dd3>] 
dump_stack+0x63/0x90
Jul  5 02:04:20 bkp011 kernel: [  799.298412]  [<ffffffff810827eb>] 
__warn+0xcb/0xf0
Jul  5 02:04:20 bkp011 kernel: [  799.298415]  [<ffffffff8108291d>] 
warn_slowpath_null+0x1d/0x20
Jul  5 02:04:20 bkp011 kernel: [  799.298432]  [<ffffffffc02db6d7>] 
__btrfs_free_extent.isra.70+0x877/0xd50 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.298456]  [<ffffffffc034652f>] ? 
btrfs_merge_delayed_refs+0x5f/0x6a0 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.298474]  [<ffffffffc02dfced>] 
__btrfs_run_delayed_refs+0xa7d/0x11e0 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.298492]  [<ffffffffc02e333e>] 
btrfs_run_delayed_refs+0x8e/0x2b0 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.298512]  [<ffffffffc02f870a>] 
btrfs_should_end_transaction+0x5a/0x60 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.298529]  [<ffffffffc02e19fc>] 
btrfs_drop_snapshot+0x43c/0x810 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.298547]  [<ffffffffc02f8beb>] 
btrfs_clean_one_deleted_snapshot+0xbb/0x110 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.298565]  [<ffffffffc02efcdb>] 
cleaner_kthread+0xcb/0x1c0 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.298583]  [<ffffffffc02efc10>] ? 
btrfs_destroy_pinned_extent+0xe0/0xe0 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.298586]  [<ffffffff810a31b8>] 
kthread+0xd8/0xf0
Jul  5 02:04:20 bkp011 kernel: [  799.298590]  [<ffffffff818423e2>] 
ret_from_fork+0x22/0x40
Jul  5 02:04:20 bkp011 kernel: [  799.298593]  [<ffffffff810a30e0>] ? 
kthread_create_on_node+0x1c0/0x1c0
Jul  5 02:04:20 bkp011 kernel: [  799.298596] ---[ end trace 
9957b92aaab5820e ]---
Jul  5 02:04:20 bkp011 kernel: [  799.298600] BTRFS info (device sda4): 
leaf 361415409664 total ptrs 131 free space 3195
Jul  5 02:04:20 bkp011 kernel: [  799.298602] 	item 0 key (2935511810048 
169 0) itemoff 16025 itemsize 258
Jul  5 02:04:20 bkp011 kernel: [  799.298604] 		extent refs 26 gen 4082 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298606] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.298607] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.298608] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.298610] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.298611] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.298612] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.298613] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.298615] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.298616] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.298617] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.298618] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.298620] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.298621] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.298622] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.298623] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.298624] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.298626] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.298627] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.298628] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.298629] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.298631] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.298632] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.298633] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.298634] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.298635] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.298637] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.298639] 	item 1 key (2935511826432 
169 0) itemoff 15767 itemsize 258
Jul  5 02:04:20 bkp011 kernel: [  799.298640] 		extent refs 26 gen 4082 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298642] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.298643] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.298644] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.298645] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.298647] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.298648] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.298649] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.298650] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.298652] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.298653] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.298654] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.298655] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.298657] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.298658] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.298659] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.298660] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.298661] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.298663] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.298664] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.298665] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.298666] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.298667] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.298669] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.298670] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.298671] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.298672] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.298674] 	item 2 key (2935511842816 
169 0) itemoff 15734 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.298676] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298677] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.298679] 	item 3 key (2935511859200 
169 0) itemoff 15674 itemsize 60
Jul  5 02:04:20 bkp011 kernel: [  799.298681] 		extent refs 4 gen 4331 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298682] 		shared block backref 
parent 3094944907264
Jul  5 02:04:20 bkp011 kernel: [  799.298683] 		shared block backref 
parent 3094685286400
Jul  5 02:04:20 bkp011 kernel: [  799.298684] 		shared block backref 
parent 2935517233152
Jul  5 02:04:20 bkp011 kernel: [  799.298686] 		shared block backref 
parent 2934950363136
Jul  5 02:04:20 bkp011 kernel: [  799.298687] 	item 4 key (2935511875584 
169 0) itemoff 15416 itemsize 258
Jul  5 02:04:20 bkp011 kernel: [  799.298689] 		extent refs 26 gen 4082 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298690] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.298692] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.298693] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.298694] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.298695] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.298696] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.298698] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.298699] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.298700] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.298701] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.298702] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.298704] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.298705] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.298706] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.298707] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.298709] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.298710] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.298711] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.298712] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.298713] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.298715] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.298716] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.298717] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.298718] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.298720] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.298721] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.298723] 	item 5 key (2935511891968 
169 0) itemoff 15158 itemsize 258
Jul  5 02:04:20 bkp011 kernel: [  799.298724] 		extent refs 26 gen 4082 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298725] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.298727] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.298728] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.298729] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.298730] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.298732] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.298733] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.298734] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.298735] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.298736] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.298738] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.298739] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.298740] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.298741] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.298743] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.298744] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.298745] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.298746] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.298747] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.298749] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.298750] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.298751] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.298752] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.298754] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.298755] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.298756] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.298758] 	item 6 key (2935511908352 
169 0) itemoff 15125 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.298759] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298761] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.298763] 	item 7 key (2935511924736 
169 0) itemoff 14867 itemsize 258
Jul  5 02:04:20 bkp011 kernel: [  799.298764] 		extent refs 26 gen 4082 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298765] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.298767] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.298768] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.298769] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.298770] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.298772] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.298773] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.298774] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.298775] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.298776] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.298778] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.298779] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.298780] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.298781] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.298782] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.298784] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.298785] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.298786] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.298787] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.298789] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.298790] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.298791] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.298792] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.298793] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.298795] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.298796] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.298798] 	item 8 key (2935511941120 
169 0) itemoff 14798 itemsize 69
Jul  5 02:04:20 bkp011 kernel: [  799.298799] 		extent refs 5 gen 4122 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.298801] 		tree block backref root 
984
Jul  5 02:04:20 bkp011 kernel: [  799.298802] 		shared block backref 
parent 3404136513536
Jul  5 02:04:20 bkp011 kernel: [  799.298803] 		shared block backref 
parent 2935485775872
Jul  5 02:04:20 bkp011 kernel: [  799.298804] 		shared block backref 
parent 2934851698688
Jul  5 02:04:20 bkp011 kernel: [  799.298806] 		shared block backref 
parent 234327916544
Jul  5 02:04:20 bkp011 kernel: [  799.298808] 	item 9 key (2935511957504 
169 0) itemoff 14540 itemsize 258
Jul  5 02:04:20 bkp011 kernel: [  799.298809] 		extent refs 26 gen 4082 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298810] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.298812] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.298813] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.298814] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.298815] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.298817] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.298818] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.298819] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.298820] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.298821] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.298823] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.298824] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.298825] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.298826] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.298828] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.298829] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.298830] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.298831] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.298832] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.298834] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.298835] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.298836] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.298837] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.298839] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.298840] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.298841] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.298843] 	item 10 key 
(2935511973888 169 0) itemoff 14462 itemsize 78
Jul  5 02:04:20 bkp011 kernel: [  799.298845] 		extent refs 6 gen 7796 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298846] 		shared block backref 
parent 3783307984896
Jul  5 02:04:20 bkp011 kernel: [  799.298847] 		shared block backref 
parent 1860532338688
Jul  5 02:04:20 bkp011 kernel: [  799.298848] 		shared block backref 
parent 1122507931648
Jul  5 02:04:20 bkp011 kernel: [  799.298850] 		shared block backref 
parent 876885065728
Jul  5 02:04:20 bkp011 kernel: [  799.298851] 		shared block backref 
parent 383976865792
Jul  5 02:04:20 bkp011 kernel: [  799.298852] 		shared block backref 
parent 90784464896
Jul  5 02:04:20 bkp011 kernel: [  799.298854] 	item 11 key 
(2935512006656 169 0) itemoff 14204 itemsize 258
Jul  5 02:04:20 bkp011 kernel: [  799.298856] 		extent refs 26 gen 4082 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298857] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.298858] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.298859] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.298860] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.298862] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.298863] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.298864] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.298865] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.298867] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.298868] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.298869] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.298870] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.298872] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.298873] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.298874] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.298875] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.298876] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.298878] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.298879] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.298880] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.298881] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.298883] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.298884] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.298885] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.298886] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.298887] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.298889] 	item 12 key 
(2935512039424 169 0) itemoff 13946 itemsize 258
Jul  5 02:04:20 bkp011 kernel: [  799.298891] 		extent refs 26 gen 4082 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298892] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.298893] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.298895] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.298896] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.298897] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.298898] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.298900] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.298901] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.298902] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.298903] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.298904] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.298906] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.298907] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.298908] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.298909] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.298910] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.298912] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.298913] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.298914] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.298915] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.298917] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.298918] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.298919] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.298920] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.298921] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.298923] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.298925] 	item 13 key 
(2935512055808 169 0) itemoff 13913 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.298926] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298927] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.298929] 	item 14 key 
(2935512072192 169 0) itemoff 13817 itemsize 96
Jul  5 02:04:20 bkp011 kernel: [  799.298931] 		extent refs 8 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298932] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.298933] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.298935] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.298936] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.298937] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.298938] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.298940] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.298941] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.298943] 	item 15 key 
(2935512088576 169 0) itemoff 13757 itemsize 60
Jul  5 02:04:20 bkp011 kernel: [  799.298944] 		extent refs 4 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298945] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.298947] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.298948] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.298949] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.298951] 	item 16 key 
(2935512104960 169 0) itemoff 13724 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.298953] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.298954] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.298956] 	item 17 key 
(2935512121344 169 0) itemoff 13691 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.298958] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298959] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.298961] 	item 18 key 
(2935512137728 169 0) itemoff 13658 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.298962] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.298964] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.298966] 	item 19 key 
(2935512154112 169 0) itemoff 13625 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.298967] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.298968] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.298970] 	item 20 key 
(2935512170496 169 0) itemoff 13592 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.298972] 		extent refs 1 gen 130242 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298973] 		shared block backref 
parent 3404331843584
Jul  5 02:04:20 bkp011 kernel: [  799.298975] 	item 21 key 
(2935512186880 169 0) itemoff 13496 itemsize 96
Jul  5 02:04:20 bkp011 kernel: [  799.298977] 		extent refs 8 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298978] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.298979] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.298980] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.298982] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.298983] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.298984] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.298985] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.298986] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.298988] 	item 22 key 
(2935512203264 169 0) itemoff 13463 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.298990] 		extent refs 1 gen 130242 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298991] 		shared block backref 
parent 3404331843584
Jul  5 02:04:20 bkp011 kernel: [  799.298993] 	item 23 key 
(2935512219648 169 0) itemoff 13430 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.298995] 		extent refs 1 gen 130242 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.298996] 		shared block backref 
parent 2935464738816
Jul  5 02:04:20 bkp011 kernel: [  799.298998] 	item 24 key 
(2935512236032 169 0) itemoff 13325 itemsize 105
Jul  5 02:04:20 bkp011 kernel: [  799.299000] 		extent refs 9 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299001] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.299002] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.299003] 		shared block backref 
parent 143832300748800
Jul  5 02:04:20 bkp011 kernel: [  799.299005] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.299006] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.299007] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.299008] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.299010] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.299011] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.299013] 	item 25 key 
(2935512252416 169 0) itemoff 13292 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299014] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299015] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299017] 	item 26 key 
(2935512268800 169 0) itemoff 13187 itemsize 105
Jul  5 02:04:20 bkp011 kernel: [  799.299019] 		extent refs 9 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299020] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.299021] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.299023] 		shared block backref 
parent 3094812393472
Jul  5 02:04:20 bkp011 kernel: [  799.299024] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.299025] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.299026] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.299028] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.299029] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.299030] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.299032] 	item 27 key 
(2935512285184 169 0) itemoff 13154 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299034] 		extent refs 1 gen 130242 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299035] 		shared block backref 
parent 2935464738816
Jul  5 02:04:20 bkp011 kernel: [  799.299037] 	item 28 key 
(2935512301568 169 0) itemoff 13049 itemsize 105
Jul  5 02:04:20 bkp011 kernel: [  799.299038] 		extent refs 9 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299040] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.299041] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.299042] 		shared block backref 
parent 3094812393472
Jul  5 02:04:20 bkp011 kernel: [  799.299043] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.299044] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.299046] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.299047] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.299048] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.299049] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.299051] 	item 29 key 
(2935512317952 169 0) itemoff 13016 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299053] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299054] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299056] 	item 30 key 
(2935512367104 169 0) itemoff 12983 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299058] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299059] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299061] 	item 31 key 
(2935512383488 169 0) itemoff 12842 itemsize 141
Jul  5 02:04:20 bkp011 kernel: [  799.299062] 		extent refs 13 gen 58049 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299064] 		tree block backref root 
283
Jul  5 02:04:20 bkp011 kernel: [  799.299065] 		shared block backref 
parent 2435060858880
Jul  5 02:04:20 bkp011 kernel: [  799.299066] 		shared block backref 
parent 1630921113600
Jul  5 02:04:20 bkp011 kernel: [  799.299067] 		shared block backref 
parent 1630318788608
Jul  5 02:04:20 bkp011 kernel: [  799.299069] 		shared block backref 
parent 1361002954752
Jul  5 02:04:20 bkp011 kernel: [  799.299070] 		shared block backref 
parent 1061992644608
Jul  5 02:04:20 bkp011 kernel: [  799.299071] 		shared block backref 
parent 984595415040
Jul  5 02:04:20 bkp011 kernel: [  799.299072] 		shared block backref 
parent 984112758784
Jul  5 02:04:20 bkp011 kernel: [  799.299074] 		shared block backref 
parent 587177721856
Jul  5 02:04:20 bkp011 kernel: [  799.299075] 		shared block backref 
parent 534204104704
Jul  5 02:04:20 bkp011 kernel: [  799.299076] 		shared block backref 
parent 461674643456
Jul  5 02:04:20 bkp011 kernel: [  799.299077] 		shared block backref 
parent 361293430784
Jul  5 02:04:20 bkp011 kernel: [  799.299079] 		shared block backref 
parent 272352100352
Jul  5 02:04:20 bkp011 kernel: [  799.299080] 	item 32 key 
(2935512399872 169 0) itemoff 12809 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299082] 		extent refs 1 gen 91314 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299083] 		shared block backref 
parent 3094562947072
Jul  5 02:04:20 bkp011 kernel: [  799.299085] 	item 33 key 
(2935512416256 169 0) itemoff 12776 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299087] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299088] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299090] 	item 34 key 
(2935512432640 169 0) itemoff 12743 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299091] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299093] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299095] 	item 35 key 
(2935512449024 169 0) itemoff 12710 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299096] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299097] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299099] 	item 36 key 
(2935512465408 169 0) itemoff 12605 itemsize 105
Jul  5 02:04:20 bkp011 kernel: [  799.299101] 		extent refs 9 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299102] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.299104] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.299105] 		shared block backref 
parent 3094812393472
Jul  5 02:04:20 bkp011 kernel: [  799.299106] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.299107] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.299108] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.299110] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.299111] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.299112] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.299114] 	item 37 key 
(2935512481792 169 0) itemoff 12572 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299116] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299117] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299119] 	item 38 key 
(2935512498176 169 0) itemoff 12539 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299120] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299122] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299123] 	item 39 key 
(2935512514560 169 0) itemoff 12506 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299125] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299126] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299128] 	item 40 key 
(2935512530944 169 0) itemoff 12239 itemsize 267
Jul  5 02:04:20 bkp011 kernel: [  799.299130] 		extent refs 27 gen 4082 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299131] 		tree block backref root 
984
Jul  5 02:04:20 bkp011 kernel: [  799.299132] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.299134] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.299135] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.299136] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.299137] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.299138] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.299140] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.299141] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.299142] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.299143] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.299145] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.299146] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.299147] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.299148] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.299149] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.299151] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.299152] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.299153] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.299154] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.299156] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.299157] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.299158] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.299159] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.299160] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.299162] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.299163] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.299165] 	item 41 key 
(2935512547328 169 0) itemoff 12134 itemsize 105
Jul  5 02:04:20 bkp011 kernel: [  799.299166] 		extent refs 9 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299168] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.299169] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.299170] 		shared block backref 
parent 3094812393472
Jul  5 02:04:20 bkp011 kernel: [  799.299172] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.299173] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.299174] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.299175] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.299177] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.299178] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.299180] 	item 42 key 
(2935512563712 169 0) itemoff 12029 itemsize 105
Jul  5 02:04:20 bkp011 kernel: [  799.299181] 		extent refs 9 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299182] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.299184] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.299185] 		shared block backref 
parent 3094812393472
Jul  5 02:04:20 bkp011 kernel: [  799.299186] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.299187] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.299189] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.299190] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.299191] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.299192] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.299194] 	item 43 key 
(2935512580096 169 0) itemoff 11996 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299196] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299197] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299199] 	item 44 key 
(2935512596480 169 0) itemoff 11963 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299200] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299202] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299204] 	item 45 key 
(2935512612864 169 0) itemoff 11930 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299205] 		extent refs 1 gen 4886 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299206] 		shared block backref 
parent 3094873538560
Jul  5 02:04:20 bkp011 kernel: [  799.299208] 	item 46 key 
(2935512629248 169 0) itemoff 11897 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299210] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299211] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.299213] 	item 47 key 
(2935512645632 169 0) itemoff 11864 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299215] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299216] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.299218] 	item 48 key 
(2935512662016 169 0) itemoff 11822 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299219] 		extent refs 2 gen 4578 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299221] 		shared block backref 
parent 3404106137600
Jul  5 02:04:20 bkp011 kernel: [  799.299222] 		shared block backref 
parent 3095146201088
Jul  5 02:04:20 bkp011 kernel: [  799.299224] 	item 49 key 
(2935512678400 169 0) itemoff 11789 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299225] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299227] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299228] 	item 50 key 
(2935512694784 169 0) itemoff 11756 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299230] 		extent refs 1 gen 91314 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299231] 		shared block backref 
parent 3094562947072
Jul  5 02:04:20 bkp011 kernel: [  799.299233] 	item 51 key 
(2935512711168 169 0) itemoff 11723 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299235] 		extent refs 1 gen 30413 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299236] 		tree block backref root 
1072
Jul  5 02:04:20 bkp011 kernel: [  799.299238] 	item 52 key 
(2935512727552 169 0) itemoff 11618 itemsize 105
Jul  5 02:04:20 bkp011 kernel: [  799.299240] 		extent refs 9 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299241] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.299242] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.299243] 		shared block backref 
parent 3094812393472
Jul  5 02:04:20 bkp011 kernel: [  799.299245] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.299246] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.299247] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.299248] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.299249] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.299251] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.299253] 	item 53 key 
(2935512743936 169 0) itemoff 11576 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299254] 		extent refs 2 gen 4578 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299255] 		shared block backref 
parent 3404106137600
Jul  5 02:04:20 bkp011 kernel: [  799.299257] 		shared block backref 
parent 3095146201088
Jul  5 02:04:20 bkp011 kernel: [  799.299258] 	item 54 key 
(2935512760320 169 0) itemoff 11534 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299260] 		extent refs 2 gen 4578 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299261] 		shared block backref 
parent 3404106137600
Jul  5 02:04:20 bkp011 kernel: [  799.299262] 		shared block backref 
parent 3095146201088
Jul  5 02:04:20 bkp011 kernel: [  799.299264] 	item 55 key 
(2935512776704 169 0) itemoff 11492 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299266] 		extent refs 2 gen 4578 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299267] 		shared block backref 
parent 3404106137600
Jul  5 02:04:20 bkp011 kernel: [  799.299268] 		shared block backref 
parent 3095146201088
Jul  5 02:04:20 bkp011 kernel: [  799.299270] 	item 56 key 
(2935512793088 169 0) itemoff 11450 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299272] 		extent refs 2 gen 4578 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299273] 		shared block backref 
parent 3404106137600
Jul  5 02:04:20 bkp011 kernel: [  799.299274] 		shared block backref 
parent 3095146201088
Jul  5 02:04:20 bkp011 kernel: [  799.299276] 	item 57 key 
(2935512809472 169 0) itemoff 11408 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299278] 		extent refs 2 gen 4578 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299279] 		shared block backref 
parent 3404106137600
Jul  5 02:04:20 bkp011 kernel: [  799.299280] 		shared block backref 
parent 3095146201088
Jul  5 02:04:20 bkp011 kernel: [  799.299282] 	item 58 key 
(2935512825856 169 0) itemoff 11366 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299283] 		extent refs 2 gen 4578 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299285] 		shared block backref 
parent 3404106137600
Jul  5 02:04:20 bkp011 kernel: [  799.299286] 		shared block backref 
parent 3095146201088
Jul  5 02:04:20 bkp011 kernel: [  799.299288] 	item 59 key 
(2935512842240 169 0) itemoff 11333 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299289] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299291] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299292] 	item 60 key 
(2935512858624 169 0) itemoff 11300 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299294] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299295] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299297] 	item 61 key 
(2935512891392 169 0) itemoff 11267 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299299] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299300] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299302] 	item 62 key 
(2935512907776 169 0) itemoff 11234 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299303] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299305] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.299307] 	item 63 key 
(2935512924160 169 0) itemoff 11201 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299308] 		extent refs 1 gen 4578 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299309] 		tree block backref root 
7
Jul  5 02:04:20 bkp011 kernel: [  799.299311] 	item 64 key 
(2935512940544 169 0) itemoff 11168 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299313] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299314] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.299316] 	item 65 key 
(2935512956928 169 0) itemoff 11063 itemsize 105
Jul  5 02:04:20 bkp011 kernel: [  799.299317] 		extent refs 9 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299319] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.299320] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.299321] 		shared block backref 
parent 3094812393472
Jul  5 02:04:20 bkp011 kernel: [  799.299322] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.299324] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.299325] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.299326] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.299327] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.299329] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.299330] 	item 66 key 
(2935512973312 169 0) itemoff 11030 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299332] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299333] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.299335] 	item 67 key 
(2935512989696 169 0) itemoff 10925 itemsize 105
Jul  5 02:04:20 bkp011 kernel: [  799.299337] 		extent refs 9 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299338] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.299339] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.299340] 		shared block backref 
parent 3094812393472
Jul  5 02:04:20 bkp011 kernel: [  799.299341] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.299343] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.299344] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.299345] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.299346] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.299348] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.299349] 	item 68 key 
(2935513006080 169 0) itemoff 10892 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299351] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299352] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299354] 	item 69 key 
(2935513022464 169 0) itemoff 10859 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299356] 		extent refs 1 gen 4578 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299357] 		tree block backref root 
7
Jul  5 02:04:20 bkp011 kernel: [  799.299359] 	item 70 key 
(2935513038848 169 0) itemoff 10826 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299361] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299362] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299364] 	item 71 key 
(2935513055232 169 0) itemoff 10793 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299365] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299367] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299368] 	item 72 key 
(2935513071616 169 0) itemoff 10688 itemsize 105
Jul  5 02:04:20 bkp011 kernel: [  799.299370] 		extent refs 9 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299371] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.299372] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.299374] 		shared block backref 
parent 3094812393472
Jul  5 02:04:20 bkp011 kernel: [  799.299375] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.299376] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.299377] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.299379] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.299380] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.299381] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.299383] 	item 73 key 
(2935513088000 169 0) itemoff 10646 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299385] 		extent refs 2 gen 22596 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299386] 		tree block backref root 
1072
Jul  5 02:04:20 bkp011 kernel: [  799.299387] 		shared block backref 
parent 3784473526272
Jul  5 02:04:20 bkp011 kernel: [  799.299389] 	item 74 key 
(2935513104384 169 0) itemoff 10613 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299391] 		extent refs 1 gen 91314 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299392] 		shared block backref 
parent 3094562947072
Jul  5 02:04:20 bkp011 kernel: [  799.299394] 	item 75 key 
(2935513120768 169 0) itemoff 10580 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299395] 		extent refs 1 gen 91314 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299397] 		shared block backref 
parent 3094562947072
Jul  5 02:04:20 bkp011 kernel: [  799.299398] 	item 76 key 
(2935513137152 169 0) itemoff 10547 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299400] 		extent refs 1 gen 130242 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299401] 		shared block backref 
parent 2935464738816
Jul  5 02:04:20 bkp011 kernel: [  799.299403] 	item 77 key 
(2935513153536 169 0) itemoff 10514 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299405] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299406] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299408] 	item 78 key 
(2935513169920 169 0) itemoff 10481 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299409] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299411] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299413] 	item 79 key 
(2935513186304 169 0) itemoff 10448 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299414] 		extent refs 1 gen 91314 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299415] 		shared block backref 
parent 3094562947072
Jul  5 02:04:20 bkp011 kernel: [  799.299417] 	item 80 key 
(2935513202688 169 0) itemoff 10415 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299419] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299420] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.299422] 	item 81 key 
(2935513219072 169 0) itemoff 10382 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299423] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299425] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.299427] 	item 82 key 
(2935513235456 169 0) itemoff 10277 itemsize 105
Jul  5 02:04:20 bkp011 kernel: [  799.299428] 		extent refs 9 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299429] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.299431] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.299432] 		shared block backref 
parent 3094812393472
Jul  5 02:04:20 bkp011 kernel: [  799.299433] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.299434] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.299436] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.299437] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.299438] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.299439] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.299441] 	item 83 key 
(2935513251840 169 0) itemoff 10172 itemsize 105
Jul  5 02:04:20 bkp011 kernel: [  799.299443] 		extent refs 9 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299444] 		shared block backref 
parent 3785078800384
Jul  5 02:04:20 bkp011 kernel: [  799.299445] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.299446] 		shared block backref 
parent 3094812393472
Jul  5 02:04:20 bkp011 kernel: [  799.299448] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.299449] 		shared block backref 
parent 2730297606144
Jul  5 02:04:20 bkp011 kernel: [  799.299450] 		shared block backref 
parent 1860094509056
Jul  5 02:04:20 bkp011 kernel: [  799.299451] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.299453] 		shared block backref 
parent 123650965504
Jul  5 02:04:20 bkp011 kernel: [  799.299454] 		shared block backref 
parent 26725072896
Jul  5 02:04:20 bkp011 kernel: [  799.299456] 	item 84 key 
(2935513268224 169 0) itemoff 10139 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299457] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299459] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299460] 	item 85 key 
(2935513284608 169 0) itemoff 10106 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299462] 		extent refs 1 gen 130242 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299463] 		shared block backref 
parent 2935464738816
Jul  5 02:04:20 bkp011 kernel: [  799.299465] 	item 86 key 
(2935513300992 169 0) itemoff 9965 itemsize 141
Jul  5 02:04:20 bkp011 kernel: [  799.299467] 		extent refs 13 gen 58049 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299468] 		tree block backref root 
283
Jul  5 02:04:20 bkp011 kernel: [  799.299469] 		shared block backref 
parent 2435060858880
Jul  5 02:04:20 bkp011 kernel: [  799.299471] 		shared block backref 
parent 1630921113600
Jul  5 02:04:20 bkp011 kernel: [  799.299472] 		shared block backref 
parent 1630318788608
Jul  5 02:04:20 bkp011 kernel: [  799.299473] 		shared block backref 
parent 1361002954752
Jul  5 02:04:20 bkp011 kernel: [  799.299474] 		shared block backref 
parent 1061992644608
Jul  5 02:04:20 bkp011 kernel: [  799.299476] 		shared block backref 
parent 984595415040
Jul  5 02:04:20 bkp011 kernel: [  799.299477] 		shared block backref 
parent 984112758784
Jul  5 02:04:20 bkp011 kernel: [  799.299478] 		shared block backref 
parent 587177721856
Jul  5 02:04:20 bkp011 kernel: [  799.299479] 		shared block backref 
parent 534204104704
Jul  5 02:04:20 bkp011 kernel: [  799.299480] 		shared block backref 
parent 461674643456
Jul  5 02:04:20 bkp011 kernel: [  799.299482] 		shared block backref 
parent 361293430784
Jul  5 02:04:20 bkp011 kernel: [  799.299483] 		shared block backref 
parent 272352100352
Jul  5 02:04:20 bkp011 kernel: [  799.299485] 	item 87 key 
(2935513317376 169 0) itemoff 9932 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299486] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299487] 		shared block backref 
parent 3404142985216
Jul  5 02:04:20 bkp011 kernel: [  799.299489] 	item 88 key 
(2935513333760 169 0) itemoff 9899 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299491] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299492] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.299494] 	item 89 key 
(2935513350144 169 0) itemoff 9632 itemsize 267
Jul  5 02:04:20 bkp011 kernel: [  799.299496] 		extent refs 27 gen 4082 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299497] 		tree block backref root 
984
Jul  5 02:04:20 bkp011 kernel: [  799.299498] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.299499] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.299501] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.299502] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.299503] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.299504] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.299505] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.299507] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.299508] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.299509] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.299510] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.299512] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.299513] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.299514] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.299515] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.299516] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.299518] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.299519] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.299520] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.299521] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.299523] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.299524] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.299525] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.299526] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.299527] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.299529] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.299530] 	item 90 key 
(2935513366528 169 0) itemoff 9599 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299532] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299533] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.299535] 	item 91 key 
(2935513382912 169 0) itemoff 9332 itemsize 267
Jul  5 02:04:20 bkp011 kernel: [  799.299537] 		extent refs 27 gen 4082 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299538] 		tree block backref root 
984
Jul  5 02:04:20 bkp011 kernel: [  799.299539] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.299540] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.299542] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.299543] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.299544] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.299545] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.299547] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.299548] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.299549] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.299550] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.299552] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.299553] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.299554] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.299555] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.299556] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.299558] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.299559] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.299560] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.299561] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.299562] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.299564] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.299565] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.299566] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.299567] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.299569] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.299570] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.299572] 	item 92 key 
(2935513399296 169 0) itemoff 9065 itemsize 267
Jul  5 02:04:20 bkp011 kernel: [  799.299573] 		extent refs 27 gen 4082 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299575] 		tree block backref root 
984
Jul  5 02:04:20 bkp011 kernel: [  799.299576] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.299577] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.299578] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.299579] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.299581] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.299582] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.299583] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.299584] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.299586] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.299587] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.299588] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.299589] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.299590] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.299592] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.299593] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.299594] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.299595] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.299596] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.299598] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.299599] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.299600] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.299601] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.299603] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.299604] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.299605] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.299606] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.299608] 	item 93 key 
(2935513432064 169 0) itemoff 8798 itemsize 267
Jul  5 02:04:20 bkp011 kernel: [  799.299610] 		extent refs 27 gen 4082 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299611] 		tree block backref root 
984
Jul  5 02:04:20 bkp011 kernel: [  799.299612] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.299613] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.299615] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.299616] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.299617] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.299618] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.299619] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.299621] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.299622] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.299623] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.299624] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.299626] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.299627] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.299628] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.299629] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.299630] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.299632] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.299633] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.299634] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.299635] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.299637] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.299638] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.299639] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.299640] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.299641] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.299643] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.299645] 	item 94 key 
(2935513448448 169 0) itemoff 8765 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299646] 		extent refs 1 gen 142918 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299647] 		tree block backref root 
2
Jul  5 02:04:20 bkp011 kernel: [  799.299649] 	item 95 key 
(2935513464832 169 0) itemoff 8561 itemsize 204
Jul  5 02:04:20 bkp011 kernel: [  799.299651] 		extent refs 20 gen 4670 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299652] 		tree block backref root 
984
Jul  5 02:04:20 bkp011 kernel: [  799.299653] 		shared block backref 
parent 3786039967744
Jul  5 02:04:20 bkp011 kernel: [  799.299655] 		shared block backref 
parent 3785558425600
Jul  5 02:04:20 bkp011 kernel: [  799.299656] 		shared block backref 
parent 3784151252992
Jul  5 02:04:20 bkp011 kernel: [  799.299657] 		shared block backref 
parent 3688746172416
Jul  5 02:04:20 bkp011 kernel: [  799.299658] 		shared block backref 
parent 3404142985216
Jul  5 02:04:20 bkp011 kernel: [  799.299660] 		shared block backref 
parent 3403836456960
Jul  5 02:04:20 bkp011 kernel: [  799.299661] 		shared block backref 
parent 3095382327296
Jul  5 02:04:20 bkp011 kernel: [  799.299662] 		shared block backref 
parent 3095241015296
Jul  5 02:04:20 bkp011 kernel: [  799.299663] 		shared block backref 
parent 2160240476160
Jul  5 02:04:20 bkp011 kernel: [  799.299664] 		shared block backref 
parent 2159958884352
Jul  5 02:04:20 bkp011 kernel: [  799.299666] 		shared block backref 
parent 1361447305216
Jul  5 02:04:20 bkp011 kernel: [  799.299667] 		shared block backref 
parent 1360481730560
Jul  5 02:04:20 bkp011 kernel: [  799.299668] 		shared block backref 
parent 1122173878272
Jul  5 02:04:20 bkp011 kernel: [  799.299669] 		shared block backref 
parent 984512233472
Jul  5 02:04:20 bkp011 kernel: [  799.299671] 		shared block backref 
parent 876884328448
Jul  5 02:04:20 bkp011 kernel: [  799.299672] 		shared block backref 
parent 234694524928
Jul  5 02:04:20 bkp011 kernel: [  799.299673] 		shared block backref 
parent 90724499456
Jul  5 02:04:20 bkp011 kernel: [  799.299674] 		shared block backref 
parent 26341343232
Jul  5 02:04:20 bkp011 kernel: [  799.299676] 		shared block backref 
parent 704200704
Jul  5 02:04:20 bkp011 kernel: [  799.299678] 	item 96 key 
(2935513481216 169 0) itemoff 8528 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299679] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299680] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.299682] 	item 97 key 
(2935513497600 169 0) itemoff 8486 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299684] 		extent refs 2 gen 22596 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299685] 		tree block backref root 
1072
Jul  5 02:04:20 bkp011 kernel: [  799.299686] 		shared block backref 
parent 3784473526272
Jul  5 02:04:20 bkp011 kernel: [  799.299688] 	item 98 key 
(2935513513984 169 0) itemoff 8453 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299690] 		extent refs 1 gen 142918 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299691] 		tree block backref root 
2
Jul  5 02:04:20 bkp011 kernel: [  799.299693] 	item 99 key 
(2935513530368 169 0) itemoff 8420 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299694] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299695] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299697] 	item 100 key 
(2935513546752 169 0) itemoff 8351 itemsize 69
Jul  5 02:04:20 bkp011 kernel: [  799.299699] 		extent refs 5 gen 4122 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299700] 		tree block backref root 
984
Jul  5 02:04:20 bkp011 kernel: [  799.299702] 		shared block backref 
parent 3404136513536
Jul  5 02:04:20 bkp011 kernel: [  799.299703] 		shared block backref 
parent 2935485775872
Jul  5 02:04:20 bkp011 kernel: [  799.299704] 		shared block backref 
parent 2934851698688
Jul  5 02:04:20 bkp011 kernel: [  799.299705] 		shared block backref 
parent 234327916544
Jul  5 02:04:20 bkp011 kernel: [  799.299707] 	item 101 key 
(2935513563136 169 0) itemoff 8318 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299709] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299710] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299712] 	item 102 key 
(2935513579520 169 0) itemoff 8276 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299714] 		extent refs 2 gen 4578 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299715] 		shared block backref 
parent 3404057640960
Jul  5 02:04:20 bkp011 kernel: [  799.299716] 		shared block backref 
parent 2012457959424
Jul  5 02:04:20 bkp011 kernel: [  799.299718] 	item 103 key 
(2935513595904 169 0) itemoff 8243 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299720] 		extent refs 1 gen 142918 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299721] 		tree block backref root 
2
Jul  5 02:04:20 bkp011 kernel: [  799.299723] 	item 104 key 
(2935513612288 169 0) itemoff 8201 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299724] 		extent refs 2 gen 4332 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299725] 		shared block backref 
parent 3094684483584
Jul  5 02:04:20 bkp011 kernel: [  799.299727] 		shared block backref 
parent 3094640902144
Jul  5 02:04:20 bkp011 kernel: [  799.299729] 	item 105 key 
(2935513628672 169 0) itemoff 8060 itemsize 141
Jul  5 02:04:20 bkp011 kernel: [  799.299730] 		extent refs 13 gen 4082 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299732] 		tree block backref root 
984
Jul  5 02:04:20 bkp011 kernel: [  799.299733] 		shared block backref 
parent 3404473745408
Jul  5 02:04:20 bkp011 kernel: [  799.299734] 		shared block backref 
parent 3404142673920
Jul  5 02:04:20 bkp011 kernel: [  799.299735] 		shared block backref 
parent 3095602348032
Jul  5 02:04:20 bkp011 kernel: [  799.299737] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.299738] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.299739] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.299740] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.299741] 		shared block backref 
parent 2935319511040
Jul  5 02:04:20 bkp011 kernel: [  799.299743] 		shared block backref 
parent 1860563812352
Jul  5 02:04:20 bkp011 kernel: [  799.299744] 		shared block backref 
parent 782481735680
Jul  5 02:04:20 bkp011 kernel: [  799.299745] 		shared block backref 
parent 360855158784
Jul  5 02:04:20 bkp011 kernel: [  799.299746] 		shared block backref 
parent 234626826240
Jul  5 02:04:20 bkp011 kernel: [  799.299748] 	item 106 key 
(2935513645056 169 0) itemoff 7802 itemsize 258
Jul  5 02:04:20 bkp011 kernel: [  799.299750] 		extent refs 26 gen 4082 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299751] 		shared block backref 
parent 3786607509504
Jul  5 02:04:20 bkp011 kernel: [  799.299752] 		shared block backref 
parent 3786134093824
Jul  5 02:04:20 bkp011 kernel: [  799.299754] 		shared block backref 
parent 3785932996608
Jul  5 02:04:20 bkp011 kernel: [  799.299755] 		shared block backref 
parent 3785484910592
Jul  5 02:04:20 bkp011 kernel: [  799.299756] 		shared block backref 
parent 3785154478080
Jul  5 02:04:20 bkp011 kernel: [  799.299757] 		shared block backref 
parent 3784106180608
Jul  5 02:04:20 bkp011 kernel: [  799.299758] 		shared block backref 
parent 3783058407424
Jul  5 02:04:20 bkp011 kernel: [  799.299760] 		shared block backref 
parent 3782999293952
Jul  5 02:04:20 bkp011 kernel: [  799.299761] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.299762] 		shared block backref 
parent 3095471308800
Jul  5 02:04:20 bkp011 kernel: [  799.299763] 		shared block backref 
parent 3095125835776
Jul  5 02:04:20 bkp011 kernel: [  799.299765] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.299766] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.299767] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.299768] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.299769] 		shared block backref 
parent 2934664822784
Jul  5 02:04:20 bkp011 kernel: [  799.299771] 		shared block backref 
parent 2434766635008
Jul  5 02:04:20 bkp011 kernel: [  799.299772] 		shared block backref 
parent 1361324916736
Jul  5 02:04:20 bkp011 kernel: [  799.299773] 		shared block backref 
parent 1062362169344
Jul  5 02:04:20 bkp011 kernel: [  799.299774] 		shared block backref 
parent 876780683264
Jul  5 02:04:20 bkp011 kernel: [  799.299775] 		shared block backref 
parent 782769897472
Jul  5 02:04:20 bkp011 kernel: [  799.299777] 		shared block backref 
parent 782746550272
Jul  5 02:04:20 bkp011 kernel: [  799.299778] 		shared block backref 
parent 782196064256
Jul  5 02:04:20 bkp011 kernel: [  799.299779] 		shared block backref 
parent 534351446016
Jul  5 02:04:20 bkp011 kernel: [  799.299780] 		shared block backref 
parent 234399875072
Jul  5 02:04:20 bkp011 kernel: [  799.299782] 		shared block backref 
parent 69546065920
Jul  5 02:04:20 bkp011 kernel: [  799.299783] 	item 107 key 
(2935513661440 169 0) itemoff 7769 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299785] 		extent refs 1 gen 4578 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299786] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.299788] 	item 108 key 
(2935513677824 169 0) itemoff 7700 itemsize 69
Jul  5 02:04:20 bkp011 kernel: [  799.299790] 		extent refs 5 gen 4082 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299791] 		shared block backref 
parent 3404142673920
Jul  5 02:04:20 bkp011 kernel: [  799.299792] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.299793] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.299795] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.299796] 		shared block backref 
parent 2934857777152
Jul  5 02:04:20 bkp011 kernel: [  799.299798] 	item 109 key 
(2935513694208 169 0) itemoff 7496 itemsize 204
Jul  5 02:04:20 bkp011 kernel: [  799.299799] 		extent refs 20 gen 4670 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299801] 		tree block backref root 
984
Jul  5 02:04:20 bkp011 kernel: [  799.299802] 		shared block backref 
parent 3786039967744
Jul  5 02:04:20 bkp011 kernel: [  799.299803] 		shared block backref 
parent 3785558425600
Jul  5 02:04:20 bkp011 kernel: [  799.299804] 		shared block backref 
parent 3784151252992
Jul  5 02:04:20 bkp011 kernel: [  799.299806] 		shared block backref 
parent 3688746172416
Jul  5 02:04:20 bkp011 kernel: [  799.299807] 		shared block backref 
parent 3404142985216
Jul  5 02:04:20 bkp011 kernel: [  799.299808] 		shared block backref 
parent 3403836456960
Jul  5 02:04:20 bkp011 kernel: [  799.299809] 		shared block backref 
parent 3095382327296
Jul  5 02:04:20 bkp011 kernel: [  799.299811] 		shared block backref 
parent 3095241015296
Jul  5 02:04:20 bkp011 kernel: [  799.299812] 		shared block backref 
parent 2160240476160
Jul  5 02:04:20 bkp011 kernel: [  799.299813] 		shared block backref 
parent 2159958884352
Jul  5 02:04:20 bkp011 kernel: [  799.299814] 		shared block backref 
parent 1361447305216
Jul  5 02:04:20 bkp011 kernel: [  799.299815] 		shared block backref 
parent 1360481730560
Jul  5 02:04:20 bkp011 kernel: [  799.299817] 		shared block backref 
parent 1122173878272
Jul  5 02:04:20 bkp011 kernel: [  799.299818] 		shared block backref 
parent 984512233472
Jul  5 02:04:20 bkp011 kernel: [  799.299819] 		shared block backref 
parent 876884328448
Jul  5 02:04:20 bkp011 kernel: [  799.299820] 		shared block backref 
parent 234694524928
Jul  5 02:04:20 bkp011 kernel: [  799.299821] 		shared block backref 
parent 90724499456
Jul  5 02:04:20 bkp011 kernel: [  799.299823] 		shared block backref 
parent 26341343232
Jul  5 02:04:20 bkp011 kernel: [  799.299824] 		shared block backref 
parent 704200704
Jul  5 02:04:20 bkp011 kernel: [  799.299826] 	item 110 key 
(2935513710592 169 0) itemoff 7427 itemsize 69
Jul  5 02:04:20 bkp011 kernel: [  799.299828] 		extent refs 5 gen 4082 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299829] 		shared block backref 
parent 3404037406720
Jul  5 02:04:20 bkp011 kernel: [  799.299830] 		shared block backref 
parent 3095058219008
Jul  5 02:04:20 bkp011 kernel: [  799.299831] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.299832] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.299834] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.299836] 	item 111 key 
(2935513726976 169 0) itemoff 7286 itemsize 141
Jul  5 02:04:20 bkp011 kernel: [  799.299837] 		extent refs 13 gen 58049 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299838] 		tree block backref root 
283
Jul  5 02:04:20 bkp011 kernel: [  799.299840] 		shared block backref 
parent 2435060858880
Jul  5 02:04:20 bkp011 kernel: [  799.299841] 		shared block backref 
parent 1630921113600
Jul  5 02:04:20 bkp011 kernel: [  799.299842] 		shared block backref 
parent 1630318788608
Jul  5 02:04:20 bkp011 kernel: [  799.299843] 		shared block backref 
parent 1361002954752
Jul  5 02:04:20 bkp011 kernel: [  799.299845] 		shared block backref 
parent 1061992644608
Jul  5 02:04:20 bkp011 kernel: [  799.299846] 		shared block backref 
parent 984595415040
Jul  5 02:04:20 bkp011 kernel: [  799.299847] 		shared block backref 
parent 984112758784
Jul  5 02:04:20 bkp011 kernel: [  799.299848] 		shared block backref 
parent 587177721856
Jul  5 02:04:20 bkp011 kernel: [  799.299849] 		shared block backref 
parent 534204104704
Jul  5 02:04:20 bkp011 kernel: [  799.299851] 		shared block backref 
parent 461674643456
Jul  5 02:04:20 bkp011 kernel: [  799.299852] 		shared block backref 
parent 361293430784
Jul  5 02:04:20 bkp011 kernel: [  799.299853] 		shared block backref 
parent 272352100352
Jul  5 02:04:20 bkp011 kernel: [  799.299855] 	item 112 key 
(2935513743360 169 0) itemoff 7253 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299857] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299858] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299860] 	item 113 key 
(2935513759744 169 0) itemoff 7220 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299861] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299863] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299865] 	item 114 key 
(2935513776128 169 0) itemoff 7187 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299866] 		extent refs 1 gen 4332 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299867] 		tree block backref root 
7
Jul  5 02:04:20 bkp011 kernel: [  799.299869] 	item 115 key 
(2935513792512 169 0) itemoff 7118 itemsize 69
Jul  5 02:04:20 bkp011 kernel: [  799.299871] 		extent refs 5 gen 4082 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299872] 		shared block backref 
parent 3404142673920
Jul  5 02:04:20 bkp011 kernel: [  799.299873] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.299874] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.299876] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.299877] 		shared block backref 
parent 2934857777152
Jul  5 02:04:20 bkp011 kernel: [  799.299879] 	item 116 key 
(2935513808896 169 0) itemoff 7085 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299880] 		extent refs 1 gen 4332 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299882] 		tree block backref root 
7
Jul  5 02:04:20 bkp011 kernel: [  799.299883] 	item 117 key 
(2935513825280 169 0) itemoff 7034 itemsize 51
Jul  5 02:04:20 bkp011 kernel: [  799.299885] 		extent refs 3 gen 4082 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299886] 		shared block backref 
parent 3094976118784
Jul  5 02:04:20 bkp011 kernel: [  799.299887] 		shared block backref 
parent 3094686679040
Jul  5 02:04:20 bkp011 kernel: [  799.299889] 		shared block backref 
parent 3094557196288
Jul  5 02:04:20 bkp011 kernel: [  799.299891] 	item 118 key 
(2935513841664 169 0) itemoff 6974 itemsize 60
Jul  5 02:04:20 bkp011 kernel: [  799.299892] 		extent refs 4 gen 5883 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299893] 		shared block backref 
parent 3094825336832
Jul  5 02:04:20 bkp011 kernel: [  799.299895] 		shared block backref 
parent 3094812393472
Jul  5 02:04:20 bkp011 kernel: [  799.299896] 		shared block backref 
parent 2935027613696
Jul  5 02:04:20 bkp011 kernel: [  799.299897] 		shared block backref 
parent 876420743168
Jul  5 02:04:20 bkp011 kernel: [  799.299899] 	item 119 key 
(2935513874432 169 0) itemoff 6941 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299900] 		extent refs 1 gen 4332 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299902] 		tree block backref root 
7
Jul  5 02:04:20 bkp011 kernel: [  799.299904] 	item 120 key 
(2935513890816 169 0) itemoff 6908 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299905] 		extent refs 1 gen 111842 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299906] 		tree block backref root 
285
Jul  5 02:04:20 bkp011 kernel: [  799.299908] 	item 121 key 
(2935513923584 169 0) itemoff 6839 itemsize 69
Jul  5 02:04:20 bkp011 kernel: [  799.299910] 		extent refs 5 gen 4122 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299911] 		tree block backref root 
984
Jul  5 02:04:20 bkp011 kernel: [  799.299912] 		shared block backref 
parent 3404136513536
Jul  5 02:04:20 bkp011 kernel: [  799.299914] 		shared block backref 
parent 2935485775872
Jul  5 02:04:20 bkp011 kernel: [  799.299915] 		shared block backref 
parent 2934851698688
Jul  5 02:04:20 bkp011 kernel: [  799.299916] 		shared block backref 
parent 234327916544
Jul  5 02:04:20 bkp011 kernel: [  799.299918] 	item 122 key 
(2935513939968 169 0) itemoff 6806 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299919] 		extent refs 1 gen 142562 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299921] 		tree block backref root 
2
Jul  5 02:04:20 bkp011 kernel: [  799.299922] 	item 123 key 
(2935513956352 169 0) itemoff 6764 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299924] 		extent refs 2 gen 4122 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299925] 		shared block backref 
parent 3095263232000
Jul  5 02:04:20 bkp011 kernel: [  799.299927] 		shared block backref 
parent 3094632071168
Jul  5 02:04:20 bkp011 kernel: [  799.299928] 	item 124 key 
(2935513972736 169 0) itemoff 6722 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299930] 		extent refs 2 gen 4332 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299931] 		shared block backref 
parent 3094684483584
Jul  5 02:04:20 bkp011 kernel: [  799.299932] 		shared block backref 
parent 3094640902144
Jul  5 02:04:20 bkp011 kernel: [  799.299934] 	item 125 key 
(2935513989120 169 0) itemoff 6680 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299936] 		extent refs 2 gen 4332 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299937] 		shared block backref 
parent 3094684483584
Jul  5 02:04:20 bkp011 kernel: [  799.299938] 		shared block backref 
parent 3094640902144
Jul  5 02:04:20 bkp011 kernel: [  799.299940] 	item 126 key 
(2935514005504 169 0) itemoff 6647 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299942] 		extent refs 1 gen 4670 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299943] 		shared block backref 
parent 3094727098368
Jul  5 02:04:20 bkp011 kernel: [  799.299945] 	item 127 key 
(2935514021888 169 0) itemoff 6605 itemsize 42
Jul  5 02:04:20 bkp011 kernel: [  799.299946] 		extent refs 2 gen 4332 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299948] 		shared block backref 
parent 3094684483584
Jul  5 02:04:20 bkp011 kernel: [  799.299949] 		shared block backref 
parent 3094640902144
Jul  5 02:04:20 bkp011 kernel: [  799.299951] 	item 128 key 
(2935514038272 169 0) itemoff 6572 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299952] 		extent refs 1 gen 4332 
flags 258
Jul  5 02:04:20 bkp011 kernel: [  799.299953] 		shared block backref 
parent 3094640902144
Jul  5 02:04:20 bkp011 kernel: [  799.299955] 	item 129 key 
(2935514054656 169 0) itemoff 6539 itemsize 33
Jul  5 02:04:20 bkp011 kernel: [  799.299957] 		extent refs 1 gen 4578 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299958] 		tree block backref root 
7
Jul  5 02:04:20 bkp011 kernel: [  799.299960] 	item 130 key 
(2935514071040 169 0) itemoff 6470 itemsize 69
Jul  5 02:04:20 bkp011 kernel: [  799.299962] 		extent refs 5 gen 4122 
flags 2
Jul  5 02:04:20 bkp011 kernel: [  799.299963] 		tree block backref root 
984
Jul  5 02:04:20 bkp011 kernel: [  799.299964] 		shared block backref 
parent 3404136513536
Jul  5 02:04:20 bkp011 kernel: [  799.299965] 		shared block backref 
parent 2935485775872
Jul  5 02:04:20 bkp011 kernel: [  799.299967] 		shared block backref 
parent 2934851698688
Jul  5 02:04:20 bkp011 kernel: [  799.299968] 		shared block backref 
parent 234327916544
Jul  5 02:04:20 bkp011 kernel: [  799.299970] BTRFS error (device sda4): 
unable to find ref byte nr 2935512236032 parent 3094812393472 root 4329  
owner 0 offset 0
Jul  5 02:04:20 bkp011 kernel: [  799.301656] ------------[ cut here 
]------------
Jul  5 02:04:20 bkp011 kernel: [  799.301675] WARNING: CPU: 0 PID: 1896 
at /home/kernel/COD/linux/fs/btrfs/extent-tree.c:6605 
__btrfs_free_extent.isra.70+0x8da/0xd50 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.301676] BTRFS: Transaction aborted 
(error -2)
Jul  5 02:04:20 bkp011 kernel: [  799.301678] Modules linked in: 
xt_CHECKSUM iptable_mangle xt_nat xt_tcpudp ipt_MASQUERADE 
nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables bridge 
stp llc btrfs intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp 
kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel aesni_intel ppdev eeepc_wmi asus_wmi aes_x86_64 
sparse_keymap lrw gf128mul input_leds serio_raw glue_helper lpc_ich 
ablk_helper shpchp 8250_fintek cryptd mac_hid tpm_infineon parport_pc lp 
parport autofs4 raid10 raid456 async_raid6_recov async_memcpy async_pq 
async_xor async_tx xor raid6_pq libcrc32c raid0 multipath linear raid1 
ahci r8169 libahci mii wmi video fjes
Jul  5 02:04:20 bkp011 kernel: [  799.301846] CPU: 0 PID: 1896 Comm: 
btrfs-cleaner Tainted: G        W       4.6.0-040600-generic 
#201605151930
Jul  5 02:04:20 bkp011 kernel: [  799.301848] Hardware name: System 
manufacturer System Product Name/P8H67-M PRO, BIOS 1106 10/17/2011
Jul  5 02:04:20 bkp011 kernel: [  799.301849]  0000000000000286 
00000000a9a73565 ffff880418a97ac0 ffffffff813f1dd3
Jul  5 02:04:20 bkp011 kernel: [  799.301852]  ffff880418a97b10 
0000000000000000 ffff880418a97b00 ffffffff810827eb
Jul  5 02:04:20 bkp011 kernel: [  799.301855]  000019cd18a97af8 
00000000fffffffe 000002ab7a2a0000 000002d091318000
Jul  5 02:04:20 bkp011 kernel: [  799.301858] Call Trace:
Jul  5 02:04:20 bkp011 kernel: [  799.301861]  [<ffffffff813f1dd3>] 
dump_stack+0x63/0x90
Jul  5 02:04:20 bkp011 kernel: [  799.301865]  [<ffffffff810827eb>] 
__warn+0xcb/0xf0
Jul  5 02:04:20 bkp011 kernel: [  799.301868]  [<ffffffff8108286a>] 
warn_slowpath_fmt+0x5a/0x80
Jul  5 02:04:20 bkp011 kernel: [  799.301885]  [<ffffffffc02db73a>] 
__btrfs_free_extent.isra.70+0x8da/0xd50 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.301906]  [<ffffffffc034652f>] ? 
btrfs_merge_delayed_refs+0x5f/0x6a0 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.301924]  [<ffffffffc02dfced>] 
__btrfs_run_delayed_refs+0xa7d/0x11e0 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.301942]  [<ffffffffc02e333e>] 
btrfs_run_delayed_refs+0x8e/0x2b0 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.301961]  [<ffffffffc02f870a>] 
btrfs_should_end_transaction+0x5a/0x60 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.301978]  [<ffffffffc02e19fc>] 
btrfs_drop_snapshot+0x43c/0x810 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.301996]  [<ffffffffc02f8beb>] 
btrfs_clean_one_deleted_snapshot+0xbb/0x110 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.302014]  [<ffffffffc02efcdb>] 
cleaner_kthread+0xcb/0x1c0 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.302034]  [<ffffffffc02efc10>] ? 
btrfs_destroy_pinned_extent+0xe0/0xe0 [btrfs]
Jul  5 02:04:20 bkp011 kernel: [  799.302040]  [<ffffffff810a31b8>] 
kthread+0xd8/0xf0
Jul  5 02:04:20 bkp011 kernel: [  799.302047]  [<ffffffff818423e2>] 
ret_from_fork+0x22/0x40
Jul  5 02:04:20 bkp011 kernel: [  799.302052]  [<ffffffff810a30e0>] ? 
kthread_create_on_node+0x1c0/0x1c0
Jul  5 02:04:20 bkp011 kernel: [  799.302057] ---[ end trace 
9957b92aaab5820f ]---
Jul  5 02:04:20 bkp011 kernel: [  799.302062] BTRFS: error (device sda4) 
in __btrfs_free_extent:6605: errno=-2 No such entry
Jul  5 02:04:20 bkp011 kernel: [  799.303253] BTRFS info (device sda4): 
forced readonly
Jul  5 02:04:20 bkp011 kernel: [  799.303256] BTRFS: error (device sda4) 
in btrfs_run_delayed_refs:2946: errno=-2 No such entry



Tomasz Chmielewski
https://www.japanizer.org
