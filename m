Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:57657 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab2GKNTb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jul 2012 09:19:31 -0400
Message-ID: <4FFD7D61.8070502@jan-o-sch.net>
Date: Wed, 11 Jul 2012 15:19:29 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, daniel@quora.org, clmason@fusionio.com,
        sensille@gmx.net
Subject: Re: [PATCH] Btrfs: allow delayed refs to be merged
References: <1341946331-18058-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1341946331-18058-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

I hit a warning with this patch on top of the current cmason/for-linus
branch. Takes about 15 minutes to produce when running xfstest 278 in
a loop and, in another shell, doing fsstress on the same volume to
force metadata modifications.

fs/btrfs/extent-tree.c
...
5032         } else if (ret == -ENOENT) {
5033                 btrfs_print_leaf(extent_root, path->nodes[0]);
5034                 WARN_ON(1);
5035                 printk(KERN_ERR "btrfs unable to find ref byte nr %llu "
5036                        "parent %llu root %llu  owner %llu offset %llu\n",
5037                        (unsigned long long)bytenr,
5038                        (unsigned long long)parent,
5039                        (unsigned long long)root_objectid,
5040                        (unsigned long long)owner_objectid,
5041                        (unsigned long long)owner_offset);
5042         } else {

<6>[469120.918975] leaf 133349376 total ptrs 36 free space 1187
<6>[469120.918978]      item 0 key (1070149632 a8 53248) itemoff 3942 itemsize 53
<6>[469120.918981]              extent refs 1 gen 358 flags 1
<6>[469120.918983]              extent data backref root 5 objectid 40286 offset 0 count 1
<6>[469120.918986]      item 1 key (1070202880 a8 53248) itemoff 3889 itemsize 53
<6>[469120.918988]              extent refs 1 gen 358 flags 1
<6>[469120.918989]              extent data backref root 5 objectid 40287 offset 0 count 1
<6>[469120.918992]      item 2 key (1070256128 a8 53248) itemoff 3836 itemsize 53
<6>[469120.918994]              extent refs 1 gen 358 flags 1
<6>[469120.918996]              extent data backref root 5 objectid 40288 offset 0 count 1
<6>[469120.918998]      item 3 key (1070309376 a8 53248) itemoff 3783 itemsize 53
<6>[469120.919000]              extent refs 1 gen 358 flags 1
<6>[469120.919002]              extent data backref root 5 objectid 40289 offset 0 count 1
<6>[469120.919004]      item 4 key (1070362624 a8 53248) itemoff 3730 itemsize 53
<6>[469120.919006]              extent refs 1 gen 358 flags 1
<6>[469120.919008]              extent data backref root 5 objectid 40290 offset 0 count 1
<6>[469120.919010]      item 5 key (1070415872 a8 53248) itemoff 3677 itemsize 53
<6>[469120.919012]              extent refs 1 gen 358 flags 1
<6>[469120.919014]              extent data backref root 5 objectid 40291 offset 0 count 1
<6>[469120.919016]      item 6 key (1070469120 a8 53248) itemoff 3624 itemsize 53
<6>[469120.919018]              extent refs 1 gen 358 flags 1
<6>[469120.919020]              extent data backref root 5 objectid 40292 offset 0 count 1
<6>[469120.919022]      item 7 key (1070522368 a8 53248) itemoff 3571 itemsize 53
<6>[469120.919024]              extent refs 1 gen 358 flags 1
<6>[469120.919026]              extent data backref root 5 objectid 40293 offset 0 count 1
<6>[469120.919028]      item 8 key (1070575616 a8 53248) itemoff 3518 itemsize 53
<6>[469120.919030]              extent refs 1 gen 358 flags 1
<6>[469120.919032]              extent data backref root 5 objectid 40294 offset 0 count 1
<6>[469120.919034]      item 9 key (1070628864 a8 53248) itemoff 3465 itemsize 53
<6>[469120.919036]              extent refs 1 gen 358 flags 1
<6>[469120.919038]              extent data backref root 5 objectid 40295 offset 0 count 1
<6>[469120.919040]      item 10 key (1070682112 a8 53248) itemoff 3412 itemsize 53
<6>[469120.919042]              extent refs 1 gen 358 flags 1
<6>[469120.919044]              extent data backref root 5 objectid 40296 offset 0 count 1
<6>[469120.919046]      item 11 key (1070735360 a8 53248) itemoff 3359 itemsize 53
<6>[469120.919048]              extent refs 1 gen 358 flags 1
<6>[469120.919050]              extent data backref root 5 objectid 40297 offset 0 count 1
<6>[469120.919052]      item 12 key (1071714304 a8 32768) itemoff 3306 itemsize 53
<6>[469120.919054]              extent refs 1 gen 791704 flags 1
<6>[469120.919056]              extent data backref root 5 objectid 14760797 offset 475136 count 1
<6>[469120.919059]      item 13 key (1071755264 a8 49152) itemoff 3253 itemsize 53
<6>[469120.919061]              extent refs 1 gen 791702 flags 1
<6>[469120.919062]              extent data backref root 5 objectid 14760670 offset 651264 count 1
<6>[469120.919065]      item 14 key (1072099328 a8 258048) itemoff 3200 itemsize 53
<6>[469120.919067]              extent refs 1 gen 791694 flags 1
<6>[469120.919069]              extent data backref root 5 objectid 14760709 offset 548864 count 1
<6>[469120.919071]      item 15 key (1072410624 a8 94208) itemoff 3147 itemsize 53
<6>[469120.919073]              extent refs 1 gen 791690 flags 1
<6>[469120.919075]              extent data backref root 5 objectid 14760670 offset 4096 count 1
<6>[469120.919077]      item 16 key (1072635904 a8 86016) itemoff 3094 itemsize 53
<6>[469120.919079]              extent refs 1 gen 791697 flags 1
<6>[469120.919081]              extent data backref root 5 objectid 14760652 offset 864256 count 1
<6>[469120.919084]      item 17 key (1072734208 a8 102400) itemoff 3041 itemsize 53
<6>[469120.919086]              extent refs 1 gen 791690 flags 1
<6>[469120.919088]              extent data backref root 5 objectid 14760665 offset 937984 count 1
<6>[469120.919090]      item 18 key (1072836608 a8 163840) itemoff 2988 itemsize 53
<6>[469120.919092]              extent refs 1 gen 791697 flags 1
<6>[469120.919094]              extent data backref root 5 objectid 14760641 offset 339968 count 1
<6>[469120.919096]      item 19 key (1073119232 a8 106496) itemoff 2935 itemsize 53
<6>[469120.919098]              extent refs 1 gen 791697 flags 1
<6>[469120.919100]              extent data backref root 5 objectid 14760665 offset 688128 count 1
<6>[469120.919103]      item 20 key (1073225728 a8 45056) itemoff 2882 itemsize 53
<6>[469120.919104]              extent refs 1 gen 791699 flags 1
<6>[469120.919106]              extent data backref root 5 objectid 14760674 offset 909312 count 1
<6>[469120.919109]      item 21 key (1073270784 a8 69632) itemoff 2829 itemsize 53
<6>[469120.919111]              extent refs 1 gen 791700 flags 1
<6>[469120.919113]              extent data backref root 5 objectid 14760665 offset 3403776 count 1
<6>[469120.919115]      item 22 key (1073356800 a8 73728) itemoff 2776 itemsize 53
<6>[469120.919117]              extent refs 1 gen 791699 flags 1
<6>[469120.919119]              extent data backref root 5 objectid 14760683 offset 1835008 count 1
<6>[469120.919121]      item 23 key (1073430528 a8 57344) itemoff 2723 itemsize 53
<6>[469120.919123]              extent refs 1 gen 791699 flags 1
<6>[469120.919125]              extent data backref root 5 objectid 14760713 offset 266240 count 1
<6>[469120.919128]      item 24 key (1073487872 a8 65536) itemoff 2670 itemsize 53
<6>[469120.919130]              extent refs 1 gen 791700 flags 1
<6>[469120.919131]              extent data backref root 1 objectid 260 offset 0 count 1
<6>[469120.919134]      item 25 key (1073553408 a8 40960) itemoff 2617 itemsize 53
<6>[469120.919136]              extent refs 1 gen 791701 flags 1
<6>[469120.919138]              extent data backref root 5 objectid 14760660 offset 1241088 count 1
<6>[469120.919140]      item 26 key (1073602560 a8 131072) itemoff 2564 itemsize 53
<6>[469120.919142]              extent refs 1 gen 791691 flags 1
<6>[469120.919144]              extent data backref root 5 objectid 14760686 offset 212992 count 1
<6>[469120.919146]      item 27 key (1073733632 a8 180224) itemoff 2511 itemsize 53
<6>[469120.919148]              extent refs 1 gen 791691 flags 1
<6>[469120.919150]              extent data backref root 5 objectid 14760686 offset 32768 count 1
<6>[469120.919153]      item 28 key (1073913856 a8 245760) itemoff 2458 itemsize 53
<6>[469120.919155]              extent refs 3 gen 791691 flags 1
<6>[469120.919157]              extent data backref root 5 objectid 14760686 offset 344064 count 3
<6>[469120.919159]      item 29 key (1074159616 a8 131072) itemoff 2405 itemsize 53
<6>[469120.919161]              extent refs 1 gen 791691 flags 1
<6>[469120.919163]              extent data backref root 5 objectid 14760655 offset 147456 count 1
<6>[469120.919165]      item 30 key (1074290688 a8 724992) itemoff 2352 itemsize 53
<6>[469120.919167]              extent refs 1 gen 791693 flags 1
<6>[469120.919169]              extent data backref root 5 objectid 14760673 offset 2031616 count 1
<6>[469120.919172]      item 31 key (1075015680 a8 270336) itemoff 2299 itemsize 53
<6>[469120.919174]              extent refs 1 gen 791704 flags 1
<6>[469120.919175]              extent data backref root 5 objectid 14760728 offset 413696 count 1
<6>[469120.919178]      item 32 key (1075625984 a8 126976) itemoff 2246 itemsize 53
<6>[469120.919180]              extent refs 1 gen 791704 flags 1
<6>[469120.919182]              extent data backref root 5 objectid 14760670 offset 1712128 count 1
<6>[469120.919184]      item 33 key (1075867648 a8 61440) itemoff 2193 itemsize 53
<6>[469120.919186]              extent refs 1 gen 791704 flags 1
<6>[469120.919188]              extent data backref root 5 objectid 14760743 offset 512000 count 1
<6>[469120.919190]      item 34 key (1075953664 a8 131072) itemoff 2140 itemsize 53
<6>[469120.919192]              extent refs 1 gen 791698 flags 1
<6>[469120.919194]              extent data backref root 5 objectid 14760673 offset 1437696 count 1
<6>[469120.919197]      item 35 key (1076084736 a8 118784) itemoff 2087 itemsize 53
<6>[469120.919199]              extent refs 1 gen 791704 flags 1
<6>[469120.919201]              extent data backref root 5 objectid 14760683 offset 561152 count 1
<4>[469120.919202] ------------[ cut here ]------------
<4>[469120.919216] WARNING: at fs/btrfs/extent-tree.c:5034 __btrfs_free_extent+0x675/0x740 [btrfs]()
<4>[469120.919218] Hardware name: X8SIL
<4>[469120.919220] Modules linked in: btrfs mpt2sas scsi_transport_sas raid_class [last unloaded: btrfs]
<4>[469120.919228] Pid: 31351, comm: rm Tainted: G        W    3.4.0+ #25
<4>[469120.919230] Call Trace:
<4>[469120.919235]  [<ffffffff8108101a>] warn_slowpath_common+0x7a/0xb0
<4>[469120.919238]  [<ffffffff81081065>] warn_slowpath_null+0x15/0x20
<4>[469120.919249]  [<ffffffffa0136bc5>] __btrfs_free_extent+0x675/0x740 [btrfs]
<4>[469120.919260]  [<ffffffffa01374fd>] run_clustered_refs+0x86d/0x9d0 [btrfs]
<4>[469120.919270]  [<ffffffffa0137802>] btrfs_run_delayed_refs+0x1a2/0x500 [btrfs]
<4>[469120.919283]  [<ffffffffa01485e5>] __btrfs_end_transaction+0xa5/0x270 [btrfs]
<4>[469120.919295]  [<ffffffffa0148810>] btrfs_end_transaction+0x10/0x20 [btrfs]
<4>[469120.919308]  [<ffffffffa014ed14>] btrfs_evict_inode+0x254/0x300 [btrfs]
<4>[469120.919312]  [<ffffffff811ab34a>] evict+0x9a/0x190
<4>[469120.919315]  [<ffffffff811ab54c>] iput+0x10c/0x200
<4>[469120.919318]  [<ffffffff811a1347>] do_unlinkat+0x167/0x1d0
<4>[469120.919322]  [<ffffffff811cef5e>] ? fsnotify_find_inode_mark+0x3e/0x50
<4>[469120.919326]  [<ffffffff8190eac7>] ? sysret_check+0x1b/0x56
<4>[469120.919330]  [<ffffffff810d9aa5>] ? trace_hardirqs_on_caller+0x105/0x190
<4>[469120.919334]  [<ffffffff8142628e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
<4>[469120.919337]  [<ffffffff811a152d>] sys_unlinkat+0x1d/0x40
<4>[469120.919340]  [<ffffffff8190eaa2>] system_call_fastpath+0x16/0x1b
<4>[469120.919342] ---[ end trace 1dfd6883330a5208 ]---
<3>[469120.919345] btrfs unable to find ref byte nr 1072283648 parent 0 root 5  owner 14760652 offset 819200

-Jan
