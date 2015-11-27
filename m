Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51261 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbbK0KrT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 05:47:19 -0500
To: linux-btrfs@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Subject: PAX: size overflow detected in function try_merge_map
 fs/btrfs/extent_map.c:238
Message-ID: <565834B3.4020602@gmx.de>
Date: Fri, 27 Nov 2015 11:47:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Happened today few times in a row at a stable 64 bit Gentoo hardened system:



Nov 27 10:23:09 t44 kernel: [41619.519921] PAX: size overflow detected in function try_merge_map fs/btrfs/extent_map.c:238 cicus.107_102 max, count: 13, decl: block_len; num: 0; context: extent_map;
Nov 27 10:23:09 t44 kernel: [41619.519929] CPU: 2 PID: 3361 Comm: host_jskwgen Tainted: G        W       4.2.6-hardened-r6 #3
Nov 27 10:23:09 t44 kernel: [41619.519932] Hardware name: LENOVO 20AQCTO1WW/20AQCTO1WW, BIOS GJET83WW (2.33 ) 03/09/2015
Nov 27 10:23:09 t44 kernel: [41619.519934]  ffffffff81831343 0000000000000000 ffffffff8183132d ffffc9000298b6e8
Nov 27 10:23:09 t44 kernel: [41619.519939]  ffffffff815ee0ea ffff88033e30eec8 ffffffff81831343 ffffc9000298b718
Nov 27 10:23:09 t44 kernel: [41619.519943]  ffffffff811ade1b ffff8802fb611480 ffff88032b717510 ffff88032b74fae0
Nov 27 10:23:09 t44 kernel: [41619.519946] Call Trace:
Nov 27 10:23:09 t44 kernel: [41619.519955]  [<ffffffff815ee0ea>] dump_stack+0x45/0x5d
Nov 27 10:23:09 t44 kernel: [41619.519959]  [<ffffffff811ade1b>] report_size_overflow+0x3b/0x50
Nov 27 10:23:09 t44 kernel: [41619.519963]  [<ffffffff8128c701>] try_merge_map+0x1f1/0x310
Nov 27 10:23:09 t44 kernel: [41619.519966]  [<ffffffff8128ca82>] add_extent_mapping+0x132/0x1c0
Nov 27 10:23:09 t44 kernel: [41619.519968]  [<ffffffff81273ea9>] btrfs_get_extent+0x659/0xdd0
Nov 27 10:23:09 t44 kernel: [41619.519972]  [<ffffffff81197b72>] ? kmem_cache_alloc+0x32/0x140
Nov 27 10:23:09 t44 kernel: [41619.519975]  [<ffffffff81297292>] __do_readpage+0x6f2/0xc30
Nov 27 10:23:09 t44 kernel: [41619.519977]  [<ffffffff8129353e>] ? __set_extent_bit+0x14e/0x580
Nov 27 10:23:09 t44 kernel: [41619.519979]  [<ffffffff81273850>] ? btrfs_real_readdir+0x6f0/0x6f0
Nov 27 10:23:09 t44 kernel: [41619.519983]  [<ffffffff815f4869>] ? _raw_spin_unlock_irq+0x19/0x30
Nov 27 10:23:09 t44 kernel: [41619.519985]  [<ffffffff81290e92>] ? btrfs_lookup_ordered_extent+0xa2/0xe0
Nov 27 10:23:09 t44 kernel: [41619.519987]  [<ffffffff812979a6>] __extent_read_full_page+0x1d6/0x210
Nov 27 10:23:09 t44 kernel: [41619.519989]  [<ffffffff81273850>] ? btrfs_real_readdir+0x6f0/0x6f0
Nov 27 10:23:09 t44 kernel: [41619.519991]  [<ffffffff81273850>] ? btrfs_real_readdir+0x6f0/0x6f0
Nov 27 10:23:09 t44 kernel: [41619.519993]  [<ffffffff812990bf>] extent_read_full_page+0x4f/0x80
Nov 27 10:23:09 t44 kernel: [41619.519997]  [<ffffffff81155cf9>] ? lru_cache_add+0x19/0x30
Nov 27 10:23:09 t44 kernel: [41619.519999]  [<ffffffff81270ac0>] ? inode_tree_add+0x150/0x150
Nov 27 10:23:09 t44 kernel: [41619.520000]  [<ffffffff81270af4>] btrfs_readpage+0x34/0x50
Nov 27 10:23:09 t44 kernel: [41619.520002]  [<ffffffff81270ac0>] ? inode_tree_add+0x150/0x150
Nov 27 10:23:09 t44 kernel: [41619.520004]  [<ffffffff81147919>] do_read_cache_page+0x99/0x1b0
Nov 27 10:23:09 t44 kernel: [41619.520006]  [<ffffffff81270ac0>] ? inode_tree_add+0x150/0x150
Nov 27 10:23:09 t44 kernel: [41619.520008]  [<ffffffff81270ac0>] ? inode_tree_add+0x150/0x150
Nov 27 10:23:09 t44 kernel: [41619.520009]  [<ffffffff81147a68>] read_cache_page+0x38/0x50
Nov 27 10:23:09 t44 kernel: [41619.520012]  [<ffffffff811b4d4a>] page_getlink.isra.48.constprop.51+0x3a/0xa0
Nov 27 10:23:09 t44 kernel: [41619.520014]  [<ffffffff811b4ddb>] page_follow_link_light+0x2b/0x50
Nov 27 10:23:09 t44 kernel: [41619.520016]  [<ffffffff811b557f>] trailing_symlink+0x27f/0x2b0
Nov 27 10:23:09 t44 kernel: [41619.520019]  [<ffffffff811b85db>] path_openat+0x16b/0x1700
Nov 27 10:23:09 t44 kernel: [41619.520021]  [<ffffffff811bae21>] do_filp_open+0x81/0xf0
Nov 27 10:23:09 t44 kernel: [41619.520024]  [<ffffffff811a4cc3>] do_sys_open+0x133/0x280
Nov 27 10:23:09 t44 kernel: [41619.520026]  [<ffffffff811a4e41>] SyS_open+0x31/0x50
Nov 27 10:23:09 t44 kernel: [41619.520028]  [<ffffffff815f5119>] entry_SYSCALL_64_fastpath+0x12/0x83


Furthermore  neither login into the KDE screen saver nor login at the console could be made, sys-rq keys didn't worked  - power off was my friend.



-- 
Toralf, pgp: C4EACDDE 0076E94E
