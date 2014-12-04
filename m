Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:58343 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaLDHyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 02:54:55 -0500
Received: from mfilter8-d.gandi.net (mfilter8-d.gandi.net [217.70.178.137])
	by relay6-d.mail.gandi.net (Postfix) with ESMTP id 64709FB8A4
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Dec 2014 08:54:53 +0100 (CET)
Received: from relay6-d.mail.gandi.net ([217.70.183.198])
	by mfilter8-d.gandi.net (mfilter8-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id BVP+cPqClDK1 for <linux-btrfs@vger.kernel.org>;
	Thu,  4 Dec 2014 08:54:51 +0100 (CET)
Received: from vajra.localnet (port-mbouisso.univ-montp2.fr [162.38.105.117])
	(Authenticated sender: swami@petaramesh.org)
	by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id D93C1FB8A7
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Dec 2014 08:54:51 +0100 (CET)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Another BTRFS kernel Oops
Date: Thu, 04 Dec 2014 08:54:51 +0100
Message-ID: <4432682.FqYBntj3yh@vajra>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

BTFS is oopsing on me again ;-)

# uname -r
3.17.4-300.fc21.x86_64


Déc. 04 08:51:28 vajra kernel: ------------[ cut here ]------------
déc. 04 08:51:28 vajra kernel: WARNING: CPU: 2 PID: 758 at fs/btrfs/delayed-
inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
déc. 04 08:51:28 vajra kernel: Modules linked in: des3_ede_x86_64 des_generic 
md4 nls_utf8 cifs dns_resolver fscache ccm rfcomm ip6t_rpfilter ip6t_REJECT 
xt_conntrack 
déc. 04 08:51:28 vajra kernel:  serio_raw snd_hda_codec rtsx_pci_ms snd_hwdep 
memstick snd_seq snd_seq_device rfkill snd_pcm wmi parport_pc parport 
snd_timer i2c_i801 
déc. 04 08:51:28 vajra kernel: CPU: 2 PID: 758 Comm: btrfs-transacti Tainted: 
G        W  OE  3.17.4-300.fc21.x86_64 #1
déc. 04 08:51:28 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook 820 
G1/1991, BIOS L71 Ver. 01.12 06/25/2014
déc. 04 08:51:28 vajra kernel:  0000000000000000 00000000f84369c6 
ffff88022df6fdb8 ffffffff8173f929
déc. 04 08:51:28 vajra kernel:  0000000000000000 ffff88022df6fdf0 ffffffff810970ad 
ffff880058164140
déc. 04 08:51:28 vajra kernel:  0000000000000000 ffff880036725000 ffff88022e2362d0 
0000000000000000
déc. 04 08:51:28 vajra kernel: Call Trace:
déc. 04 08:51:28 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
déc. 04 08:51:28 vajra kernel:  [<ffffffff810970ad>] 
warn_slowpath_common+0x7d/0xa0
déc. 04 08:51:28 vajra kernel:  [<ffffffff810971da>] warn_slowpath_null+0x1a/0x20
déc. 04 08:51:28 vajra kernel:  [<ffffffffa02f1169>] 
btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
déc. 04 08:51:28 vajra kernel:  [<ffffffffa029c5e8>] 
btrfs_commit_transaction+0x388/0x950 [btrfs]
déc. 04 08:51:28 vajra kernel:  [<ffffffffa02982b5>] 
transaction_kthread+0x245/0x260 [btrfs]
déc. 04 08:51:28 vajra kernel:  [<ffffffffa0298070>] ? 
btrfs_cleanup_transaction+0x550/0x550 [btrfs]
déc. 04 08:51:28 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
déc. 04 08:51:28 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 04 08:51:28 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
déc. 04 08:51:28 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 04 08:51:28 vajra kernel: ---[ end trace 449348f354fd5be4 ]---
déc. 04 08:51:29 vajra abrt-dump-journal-oops[1249]: abrt-dump-journal-oops: 
Found oopses: 1
déc. 04 08:51:29 vajra abrt-dump-journal-oops[1249]: abrt-dump-journal-oops: 
Creating problem directories
déc. 04 08:51:29 vajra abrt-server[16211]: Deleting problem directory 
oops-2014-12-04-08:51:29-1249-0 (dup of oops-2014-12-01-12:12:02-1332-0)
déc. 04 08:51:30 vajra abrt-dump-journal-oops[1249]: Reported 1 kernel oopses 
to Abrt
déc. 04 08:51:58 vajra kernel: ------------[ cut here ]------------
déc. 04 08:51:58 vajra kernel: WARNING: CPU: 2 PID: 758 at fs/btrfs/delayed-
inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()
déc. 04 08:51:58 vajra kernel: Modules linked in: des3_ede_x86_64 des_generic 
md4 nls_utf8 cifs dns_resolver fscache ccm rfcomm ip6t_rpfilter ip6t_REJECT 
xt_conntrack 
déc. 04 08:51:58 vajra kernel:  serio_raw snd_hda_codec rtsx_pci_ms snd_hwdep 
memstick snd_seq snd_seq_device rfkill snd_pcm wmi parport_pc parport 
snd_timer i2c_i801 
déc. 04 08:51:58 vajra kernel: CPU: 2 PID: 758 Comm: btrfs-transacti Tainted: 
G        W  OE  3.17.4-300.fc21.x86_64 #1
déc. 04 08:51:58 vajra kernel: Hardware name: Hewlett-Packard HP EliteBook 820 
G1/1991, BIOS L71 Ver. 01.12 06/25/2014
déc. 04 08:51:58 vajra kernel:  0000000000000000 00000000f84369c6 
ffff88022df6fdb8 ffffffff8173f929
déc. 04 08:51:58 vajra kernel:  0000000000000000 ffff88022df6fdf0 ffffffff810970ad 
ffff8801360f4780
déc. 04 08:51:58 vajra kernel:  0000000000000000 ffff880036725000 ffff88022e1fa1e0 
0000000000000000
déc. 04 08:51:58 vajra kernel: Call Trace:
déc. 04 08:51:58 vajra kernel:  [<ffffffff8173f929>] dump_stack+0x45/0x56
déc. 04 08:51:58 vajra kernel:  [<ffffffff810970ad>] 
warn_slowpath_common+0x7d/0xa0
déc. 04 08:51:58 vajra kernel:  [<ffffffff810971da>] warn_slowpath_null+0x1a/0x20
déc. 04 08:51:58 vajra kernel:  [<ffffffffa02f1169>] 
btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]
déc. 04 08:51:58 vajra kernel:  [<ffffffffa029c5e8>] 
btrfs_commit_transaction+0x388/0x950 [btrfs]
déc. 04 08:51:58 vajra kernel:  [<ffffffffa02982b5>] 
transaction_kthread+0x245/0x260 [btrfs]
déc. 04 08:51:58 vajra kernel:  [<ffffffffa0298070>] ? 
btrfs_cleanup_transaction+0x550/0x550 [btrfs]
déc. 04 08:51:58 vajra kernel:  [<ffffffff810b52fa>] kthread+0xea/0x100
déc. 04 08:51:58 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 04 08:51:58 vajra kernel:  [<ffffffff81746a3c>] ret_from_fork+0x7c/0xb0
déc. 04 08:51:58 vajra kernel:  [<ffffffff810b5210>] ? 
kthread_create_on_node+0x1a0/0x1a0
déc. 04 08:51:58 vajra kernel: ---[ end trace 449348f354fd5be5 ]---
déc. 04 08:51:59 vajra abrt-dump-journal-oops[1249]: abrt-dump-journal-oops: 
Found oopses: 1
déc. 04 08:51:59 vajra abrt-dump-journal-oops[1249]: abrt-dump-journal-oops: 
Creating problem directories

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

L'espoir luit comme un brin de paille dans l'étable.
-- Paul Verlaine

