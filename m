Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:38488 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaLENa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Dec 2014 08:30:27 -0500
Received: from mfilter13-d.gandi.net (mfilter13-d.gandi.net [217.70.178.141])
	by relay5-d.mail.gandi.net (Postfix) with ESMTP id 3574B41C07A
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Dec 2014 14:30:25 +0100 (CET)
Received: from relay5-d.mail.gandi.net ([217.70.183.197])
	by mfilter13-d.gandi.net (mfilter13-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id rjzzPADW07ky for <linux-btrfs@vger.kernel.org>;
	Fri,  5 Dec 2014 14:30:23 +0100 (CET)
Received: from vajra.localnet (port-mbouisso.univ-montp2.fr [162.38.105.117])
	(Authenticated sender: swami@petaramesh.org)
	by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 96FC041C06D
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Dec 2014 14:30:23 +0100 (CET)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: More and more kernel oopses in 3.17.4
Date: Fri, 05 Dec 2014 14:30:22 +0100
Message-ID: <13252483.6C90zYvgUF@vajra>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fedora Core21 with 3.17.4-301.fc21.x86_64

Now BTRFS sux bigtime :-/

And my syslog is full of :

éc. 05 14:28:11 vajra kernel: ------------[ cut here ]------------
déc. 05 14:28:11 vajra kernel: WARNING: CPU: 3 PID: 613 at fs/btrfs/delayed-
inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
déc. 05 14:28:11 vajra kernel: Modules linked in: vfat fat uas usb_storage ccm 
rfcomm ip6t_rpfilter ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge 
stp llc ebtabl
déc. 05 14:28:11 vajra kernel:  snd_seq_device serio_raw memstick snd_pcm 
cfg80211 parport_pc rfkill parport wmi i2c_i801 snd_timer snd hp_accel 
lis3lv02d tpm_tis hp_wireles
déc. 05 14:28:11 vajra kernel: CPU: 3 PID: 613 Comm: btrfs-transacti Tainted: 
G        W  OE  3.17.4-301.fc21.x86_64 #1
déc. 05 14:28:11 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook 820 
G1/1991, BIOS L71 Ver. 01.12 06/25/2014
déc. 05 14:28:11 vajra kernel:  0000000000000000 000000002dda6cf7 
ffff88022df6bdb8 ffffffff8173f929
déc. 05 14:28:11 vajra kernel:  0000000000000000 ffff88022df6bdf0 ffffffff810970ad 
ffff88013f6378c0
déc. 05 14:28:11 vajra kernel:  0000000000000000 ffff88003672f000 ffff8801f7014b40 
0000000000000000
déc. 05 14:28:11 vajra kernel: Call Trace:
déc. 05 14:28:11 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
déc. 05 14:28:11 vajra kernel:  [<ffffffff810970ad>] 
warn_slowpath_common+0x7d/0xa0
déc. 05 14:28:11 vajra kernel:  [<ffffffff810971da>] warn_slowpath_null+0x1a/0x20
déc. 05 14:28:11 vajra kernel:  [<ffffffffa0300169>] 
btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
déc. 05 14:28:11 vajra kernel:  [<ffffffffa02ab5e8>] 
btrfs_commit_transaction+0x388/0x950 [btrfs]
déc. 05 14:28:11 vajra kernel:  [<ffffffffa02a72b5>] 
transaction_kthread+0x245/0x260 [btrfs]
déc. 05 14:28:11 vajra kernel:  [<ffffffffa02a7070>] ? 
btrfs_cleanup_transaction+0x550/0x550 [btrfs]
déc. 05 14:28:11 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
déc. 05 14:28:11 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 05 14:28:11 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
déc. 05 14:28:11 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 05 14:28:11 vajra kernel: ---[ end trace 6138896e6248d2bf ]---
déc. 05 14:28:12 vajra abrt-dump-journal-oops[1102]: abrt-dump-journal-oops: 
Found oopses: 1
déc. 05 14:28:12 vajra abrt-dump-journal-oops[1102]: abrt-dump-journal-oops: 
Creating problem directories
déc. 05 14:28:12 vajra abrt-server[11566]: Deleting problem directory 
oops-2014-12-05-14:28:12-1102-0 (dup of oops-2014-12-01-12:12:02-1332-0)
déc. 05 14:28:13 vajra abrt-dump-journal-oops[1102]: Reported 1 kernel oopses 
to Abrt
déc. 05 14:28:41 vajra kernel: ------------[ cut here ]------------
déc. 05 14:28:41 vajra kernel: WARNING: CPU: 3 PID: 613 at fs/btrfs/delayed-
inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
déc. 05 14:28:41 vajra kernel: Modules linked in: vfat fat uas usb_storage ccm 
rfcomm ip6t_rpfilter ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge 
stp llc ebtabl
déc. 05 14:28:41 vajra kernel:  snd_seq_device serio_raw memstick snd_pcm 
cfg80211 parport_pc rfkill parport wmi i2c_i801 snd_timer snd hp_accel 
lis3lv02d tpm_tis hp_wireles
déc. 05 14:28:41 vajra kernel: CPU: 3 PID: 613 Comm: btrfs-transacti Tainted: 
G        W  OE  3.17.4-301.fc21.x86_64 #1
déc. 05 14:28:41 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook 820 
G1/1991, BIOS L71 Ver. 01.12 06/25/2014
déc. 05 14:28:41 vajra kernel:  0000000000000000 000000002dda6cf7 
ffff88022df6bdb8 ffffffff8173f929
déc. 05 14:28:41 vajra kernel:  0000000000000000 ffff88022df6bdf0 ffffffff810970ad 
ffff88008364e0a0
déc. 05 14:28:41 vajra kernel:  0000000000000000 ffff88003672f000 ffff8801f7014c30 
0000000000000000
déc. 05 14:28:41 vajra kernel: Call Trace:
déc. 05 14:28:41 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
déc. 05 14:28:41 vajra kernel:  [<ffffffff810970ad>] 
warn_slowpath_common+0x7d/0xa0
déc. 05 14:28:41 vajra kernel:  [<ffffffff810971da>] warn_slowpath_null+0x1a/0x20
déc. 05 14:28:41 vajra kernel:  [<ffffffffa0300169>] 
btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
déc. 05 14:28:41 vajra kernel:  [<ffffffffa02ab5e8>] 
btrfs_commit_transaction+0x388/0x950 [btrfs]
déc. 05 14:28:41 vajra kernel:  [<ffffffffa02a72b5>] 
transaction_kthread+0x245/0x260 [btrfs]
déc. 05 14:28:41 vajra kernel:  [<ffffffffa02a7070>] ? 
btrfs_cleanup_transaction+0x550/0x550 [btrfs]
déc. 05 14:28:41 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
déc. 05 14:28:41 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 05 14:28:41 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
déc. 05 14:28:41 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 05 14:28:41 vajra kernel: ---[ end trace 6138896e6248d2c0 ]---
déc. 05 14:28:42 vajra abrt-dump-journal-oops[1102]: abrt-dump-journal-oops: 
Found oopses: 1
déc. 05 14:28:42 vajra abrt-dump-journal-oops[1102]: abrt-dump-journal-oops: 
Creating problem directories
déc. 05 14:28:42 vajra abrt-server[11581]: Deleting problem directory 
oops-2014-12-05-14:28:42-1102-0 (dup of oops-2014-12-01-12:12:02-1332-0)
déc. 05 14:28:43 vajra abrt-dump-journal-oops[1102]: Reported 1 kernel oopses 
to Abrt


-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

