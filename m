Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35644 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaLALRq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 06:17:46 -0500
Received: from mfilter19-d.gandi.net (mfilter19-d.gandi.net [217.70.178.147])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id 31042A8100
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Dec 2014 12:17:44 +0100 (CET)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter19-d.gandi.net (mfilter19-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id uJPrd9dViR4V for <linux-btrfs@vger.kernel.org>;
	Mon,  1 Dec 2014 12:17:41 +0100 (CET)
Received: from vajra.localnet (unknown [162.38.105.117])
	(Authenticated sender: swami@petaramesh.org)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 71E3CA8163
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Dec 2014 12:17:41 +0100 (CET)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: BRFS balance crash
Date: Mon, 01 Dec 2014 12:17:40 +0100
Message-ID: <4619625.ssjvlSibEN@vajra>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm running Fedora Core 21 beta with kernel 3.17.4-300.fc21.x86_64 and

Btrfs-progs-3.17-1.fc21.x86_64

As my SSD was pretty full, I started :

btrfs balance start -dusage=75 -musage=75 /

This ended in "segmentation fault".

Afterwards my system wouldn't access the disk anymore, and needed a hard 
reboot.

After reboot balance seemingly has resumed then finished :

[root@vajra ~]# btrfs balance status /
Balance on '/' is running
17 out of about 24 chunks balanced (123 considered),  29% left

(later)

[root@vajra ~]# btrfs balance status /
No balance found on '/'


...but my system has logged a (very high) number of kernel WARNINGS such as :

déc. 01 12:11:26 vajra kernel: ------------[ cut here ]------------
déc. 01 12:11:26 vajra kernel: WARNING: CPU: 2 PID: 966 at fs/btrfs/delayed-
inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
déc. 01 12:11:26 vajra kernel: Modules linked in: ccm rfcomm ip6t_rpfilter 
ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc 
ebtable_filter ebtables i
déc. 01 12:11:26 vajra kernel:  rfkill wmi snd_pcm parport_pc parport hp_accel 
snd_timer lis3lv02d mei_me input_polldev tpm_tis mei snd hp_wireless shpchp 
i2c_i801 sou
déc. 01 12:11:26 vajra kernel: CPU: 2 PID: 966 Comm: btrfs-balance Tainted: G        
W  OE  3.17.4-300.fc21.x86_64 #1
déc. 01 12:11:26 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook 820 
G1/1991, BIOS L71 Ver. 01.12 06/25/2014
déc. 01 12:11:26 vajra kernel:  0000000000000000 000000009fd55060 
ffff8800a8467ac8 ffffffff8173f929
déc. 01 12:11:26 vajra kernel:  0000000000000000 ffff8800a8467b00 ffffffff810970ad 
ffff88014b7ee780
déc. 01 12:11:26 vajra kernel:  0000000000000000 ffff88022fcec800 ffff88022f9d1a40 
0000000000000000
déc. 01 12:11:26 vajra kernel: Call Trace:
déc. 01 12:11:26 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
déc. 01 12:11:26 vajra kernel:  [<ffffffff810970ad>] 
warn_slowpath_common+0x7d/0xa0
déc. 01 12:11:26 vajra kernel:  [<ffffffff810971da>] warn_slowpath_null+0x1a/0x20
déc. 01 12:11:26 vajra kernel:  [<ffffffffa02bc169>] 
btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
déc. 01 12:11:26 vajra kernel:  [<ffffffffa02675e8>] 
btrfs_commit_transaction+0x388/0x950 [btrfs]
déc. 01 12:11:26 vajra kernel:  [<ffffffffa02b850d>] prepare_to_merge+0x20d/0x230 
[btrfs]
déc. 01 12:11:26 vajra kernel:  [<ffffffffa02b9163>] 
relocate_block_group+0x403/0x6d0 [btrfs]
déc. 01 12:11:26 vajra kernel:  [<ffffffffa02b9616>] 
btrfs_relocate_block_group+0x1e6/0x2f0 [btrfs]
déc. 01 12:11:26 vajra kernel:  [<ffffffffa028f25a>] 
btrfs_relocate_chunk.isra.27+0x6a/0x750 [btrfs]
déc. 01 12:11:26 vajra kernel:  [<ffffffffa023d7a1>] ? 
btrfs_set_path_blocking+0x41/0x80 [btrfs]
déc. 01 12:11:26 vajra kernel:  [<ffffffffa0242a5d>] ? 
btrfs_search_slot+0x4ad/0xa70 [btrfs]
déc. 01 12:11:26 vajra kernel:  [<ffffffffa027fda9>] ? 
btrfs_get_token_64+0x119/0x140 [btrfs]
déc. 01 12:11:26 vajra kernel:  [<ffffffffa028a1ff>] ? free_extent_buffer+0x4f/0xa0 
[btrfs]
déc. 01 12:11:26 vajra kernel:  [<ffffffffa0292540>] btrfs_balance+0x980/0xf40 
[btrfs]
déc. 01 12:11:26 vajra kernel:  [<ffffffffa0292b5d>] balance_kthread+0x5d/0x80 
[btrfs]
déc. 01 12:11:26 vajra kernel:  [<ffffffffa0292b00>] ? btrfs_balance+0xf40/0xf40 
[btrfs]
déc. 01 12:11:26 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
déc. 01 12:11:26 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 01 12:11:26 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
déc. 01 12:11:26 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 01 12:11:26 vajra kernel: ---[ end trace f1f27f48a0abdf6f ]---


déc. 01 12:11:27 vajra kernel: ------------[ cut here ]------------
déc. 01 12:11:27 vajra kernel: WARNING: CPU: 2 PID: 966 at fs/btrfs/delayed-
inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
déc. 01 12:11:27 vajra kernel: Modules linked in: ccm rfcomm ip6t_rpfilter 
ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc 
ebtable_filter ebtables i
déc. 01 12:11:27 vajra kernel:  rfkill wmi snd_pcm parport_pc parport hp_accel 
snd_timer lis3lv02d mei_me input_polldev tpm_tis mei snd hp_wireless shpchp 
i2c_i801 sou
déc. 01 12:11:27 vajra kernel: CPU: 2 PID: 966 Comm: btrfs-balance Tainted: G        
W  OE  3.17.4-300.fc21.x86_64 #1
déc. 01 12:11:27 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook 820 
G1/1991, BIOS L71 Ver. 01.12 06/25/2014
déc. 01 12:11:27 vajra kernel:  0000000000000000 000000009fd55060 
ffff8800a8467b20 ffffffff8173f929
déc. 01 12:11:27 vajra kernel:  0000000000000000 ffff8800a8467b58 ffffffff810970ad 
ffff880183e6b820
déc. 01 12:11:27 vajra kernel:  0000000000000000 ffff88022fcec800 ffff88022f9d1950 
0000000000000000
déc. 01 12:11:27 vajra kernel: Call Trace:
déc. 01 12:11:27 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
déc. 01 12:11:27 vajra kernel:  [<ffffffff810970ad>] 
warn_slowpath_common+0x7d/0xa0
déc. 01 12:11:27 vajra kernel:  [<ffffffff810971da>] warn_slowpath_null+0x1a/0x20
déc. 01 12:11:27 vajra kernel:  [<ffffffffa02bc169>] 
btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa02675e8>] 
btrfs_commit_transaction+0x388/0x950 [btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa02b91b4>] 
relocate_block_group+0x454/0x6d0 [btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa02b9616>] 
btrfs_relocate_block_group+0x1e6/0x2f0 [btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa028f25a>] 
btrfs_relocate_chunk.isra.27+0x6a/0x750 [btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa023d7a1>] ? 
btrfs_set_path_blocking+0x41/0x80 [btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa0242a5d>] ? 
btrfs_search_slot+0x4ad/0xa70 [btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa027fda9>] ? 
btrfs_get_token_64+0x119/0x140 [btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa028a1ff>] ? free_extent_buffer+0x4f/0xa0 
[btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa0292540>] btrfs_balance+0x980/0xf40 
[btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa0292b5d>] balance_kthread+0x5d/0x80 
[btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa0292b00>] ? btrfs_balance+0xf40/0xf40 
[btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
déc. 01 12:11:27 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 01 12:11:27 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
déc. 01 12:11:27 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 01 12:11:27 vajra kernel: ---[ end trace f1f27f48a0abdf70 ]---


déc. 01 12:11:27 vajra kernel: ------------[ cut here ]------------
déc. 01 12:11:27 vajra kernel: WARNING: CPU: 2 PID: 966 at fs/btrfs/delayed-
inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
déc. 01 12:11:27 vajra kernel: Modules linked in: ccm rfcomm ip6t_rpfilter 
ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc 
ebtable_filter ebtables i
déc. 01 12:11:27 vajra kernel:  rfkill wmi snd_pcm parport_pc parport hp_accel 
snd_timer lis3lv02d mei_me input_polldev tpm_tis mei snd hp_wireless shpchp 
i2c_i801 sou
déc. 01 12:11:27 vajra kernel: CPU: 2 PID: 966 Comm: btrfs-balance Tainted: G        
W  OE  3.17.4-300.fc21.x86_64 #1
déc. 01 12:11:27 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook 820 
G1/1991, BIOS L71 Ver. 01.12 06/25/2014
déc. 01 12:11:27 vajra kernel:  0000000000000000 000000009fd55060 
ffff8800a8467c70 ffffffff8173f929
déc. 01 12:11:27 vajra kernel:  0000000000000000 ffff8800a8467ca8 ffffffff810970ad 
ffff8800b03ae640
déc. 01 12:11:27 vajra kernel:  0000000000000000 ffff8800aed1e800 ffff88022f9d1860 
0000000000000000
déc. 01 12:11:27 vajra kernel: Call Trace:
déc. 01 12:11:27 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
déc. 01 12:11:27 vajra kernel:  [<ffffffff810970ad>] 
warn_slowpath_common+0x7d/0xa0
déc. 01 12:11:27 vajra kernel:  [<ffffffff810971da>] warn_slowpath_null+0x1a/0x20
déc. 01 12:11:27 vajra kernel:  [<ffffffffa02bc169>] 
btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa02675e8>] 
btrfs_commit_transaction+0x388/0x950 [btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa028a1ff>] ? free_extent_buffer+0x4f/0xa0 
[btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa023d889>] ? 
btrfs_release_path+0x29/0xa0 [btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa028c83e>] __cancel_balance+0x17e/0x1b0 
[btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa0292631>] btrfs_balance+0xa71/0xf40 
[btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa0292b5d>] balance_kthread+0x5d/0x80 
[btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffffa0292b00>] ? btrfs_balance+0xf40/0xf40 
[btrfs]
déc. 01 12:11:27 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
déc. 01 12:11:27 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 01 12:11:27 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
déc. 01 12:11:27 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 01 12:11:27 vajra kernel: ---[ end trace f1f27f48a0abdf71 ]---


déc. 01 12:12:01 vajra kernel: ------------[ cut here ]------------
déc. 01 12:12:01 vajra kernel: WARNING: CPU: 0 PID: 844 at fs/btrfs/delayed-
inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
déc. 01 12:12:01 vajra kernel: Modules linked in: ccm rfcomm ip6t_rpfilter 
ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc 
ebtable_filter ebtables i
déc. 01 12:12:01 vajra kernel:  rfkill wmi snd_pcm parport_pc parport hp_accel 
snd_timer lis3lv02d mei_me input_polldev tpm_tis mei snd hp_wireless shpchp 
i2c_i801 sou
déc. 01 12:12:01 vajra kernel: CPU: 0 PID: 844 Comm: btrfs-transacti Tainted: 
G        W  OE  3.17.4-300.fc21.x86_64 #1
déc. 01 12:12:01 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook 820 
G1/1991, BIOS L71 Ver. 01.12 06/25/2014
déc. 01 12:12:01 vajra kernel:  0000000000000000 000000005aad0390 
ffff88003675fdb8 ffffffff8173f929
déc. 01 12:12:01 vajra kernel:  0000000000000000 ffff88003675fdf0 ffffffff810970ad 
ffff8801222c03c0
déc. 01 12:12:01 vajra kernel:  0000000000000000 ffff8800aed1e800 ffff88022f9d1770 
0000000000000000
déc. 01 12:12:01 vajra kernel: Call Trace:
déc. 01 12:12:01 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
déc. 01 12:12:01 vajra kernel:  [<ffffffff810970ad>] 
warn_slowpath_common+0x7d/0xa0
déc. 01 12:12:01 vajra kernel:  [<ffffffff810971da>] warn_slowpath_null+0x1a/0x20
déc. 01 12:12:01 vajra kernel:  [<ffffffffa02bc169>] 
btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
déc. 01 12:12:01 vajra kernel:  [<ffffffffa02675e8>] 
btrfs_commit_transaction+0x388/0x950 [btrfs]
déc. 01 12:12:01 vajra kernel:  [<ffffffffa02632b5>] 
transaction_kthread+0x245/0x260 [btrfs]
déc. 01 12:12:01 vajra kernel:  [<ffffffffa0263070>] ? 
btrfs_cleanup_transaction+0x550/0x550 [btrfs]
déc. 01 12:12:01 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
déc. 01 12:12:01 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 01 12:12:01 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
déc. 01 12:12:01 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 01 12:12:01 vajra kernel: ---[ end trace f1f27f48a0abdf72 ]---


déc. 01 12:12:32 vajra kernel: ------------[ cut here ]------------
déc. 01 12:12:32 vajra kernel: WARNING: CPU: 3 PID: 844 at fs/btrfs/delayed-
inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
déc. 01 12:12:32 vajra kernel: Modules linked in: ccm rfcomm ip6t_rpfilter 
ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc 
ebtable_filter ebtables i
déc. 01 12:12:32 vajra kernel:  rfkill wmi snd_pcm parport_pc parport hp_accel 
snd_timer lis3lv02d mei_me input_polldev tpm_tis mei snd hp_wireless shpchp 
i2c_i801 sou
déc. 01 12:12:32 vajra kernel: CPU: 3 PID: 844 Comm: btrfs-transacti Tainted: 
G        W  OE  3.17.4-300.fc21.x86_64 #1
déc. 01 12:12:32 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook 820 
G1/1991, BIOS L71 Ver. 01.12 06/25/2014
déc. 01 12:12:32 vajra kernel:  0000000000000000 000000005aad0390 
ffff88003675fdb8 ffffffff8173f929
déc. 01 12:12:32 vajra kernel:  0000000000000000 ffff88003675fdf0 ffffffff810970ad 
ffff880190745500
déc. 01 12:12:32 vajra kernel:  0000000000000000 ffff8800aed1e800 ffff8800abeee870 
0000000000000000
déc. 01 12:12:32 vajra kernel: Call Trace:
déc. 01 12:12:32 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
déc. 01 12:12:32 vajra kernel:  [<ffffffff810970ad>] 
warn_slowpath_common+0x7d/0xa0
déc. 01 12:12:32 vajra kernel:  [<ffffffff810971da>] warn_slowpath_null+0x1a/0x20
déc. 01 12:12:32 vajra kernel:  [<ffffffffa02bc169>] 
btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
déc. 01 12:12:32 vajra kernel:  [<ffffffffa02675e8>] 
btrfs_commit_transaction+0x388/0x950 [btrfs]
déc. 01 12:12:32 vajra kernel:  [<ffffffffa02632b5>] 
transaction_kthread+0x245/0x260 [btrfs]
déc. 01 12:12:32 vajra kernel:  [<ffffffffa0263070>] ? 
btrfs_cleanup_transaction+0x550/0x550 [btrfs]
déc. 01 12:12:32 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
déc. 01 12:12:32 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 01 12:12:32 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
déc. 01 12:12:32 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 01 12:12:32 vajra kernel: ---[ end trace f1f27f48a0abdf73 ]---


...etc.

Any indight / help much appreciated.

TIA and kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

