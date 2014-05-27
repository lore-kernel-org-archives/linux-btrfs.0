Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.54]:37991 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaE0SZE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 14:25:04 -0400
Received: from 229.24.34.95.customer.cdi.no ([95.34.24.229]:39140 helo=[10.0.0.6])
	by smtp.domeneshop.no with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <lists@skagestad.org>)
	id 1WpLqK-00004z-0O
	for linux-btrfs@vger.kernel.org; Tue, 27 May 2014 20:11:20 +0200
Message-ID: <5384D53C.9070509@skagestad.org>
Date: Tue, 27 May 2014 20:11:08 +0200
From: =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: 3.15-rc6 - btrfs-transacti:4157 blocked for more than 120 seconds.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Btrfs-transaction keeps blocking for me on all 3.15-rc versions.
3.14 does not have this issue.
The process never gets unstuck. btrfs fi sync does not help. A hard 
reboot seems to be the only way to recover.

The volume is still readable when it's in this state.

dmesg + sysrq-w is available at http://pastebin.com/vHQnRE2F
It's over 6000 lines, and would most likely not be allowed on the list.

The blocking happons on a server with local kvm-clients reading and 
writing to a local btrfs-volume over nfs.
The btrfs-volume is on top of dm-crypt devices.

Any additional info I can give to help?
Tests you want me to run?

--
Torbjørn

--snip--
[138011.263478] INFO: task btrfs-transacti:4157 blocked for more than 
120 seconds.
[138011.263558]       Tainted: G            E 3.15.0-rc6 #58
[138011.263605] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[138011.263687] btrfs-transacti D ffff88042fc94500     0  4157 2 0x00000000
[138011.263744]  ffff880400737e10 0000000000000002 ffff880403b33260 
ffff880400737fd8
[138011.263831]  0000000000014500 0000000000014500 ffff88041973b260 
ffff8802a9c97b40
[138011.263919]  ffff880403a0e800 ffff880400737e30 ffff8800c950ac00 
ffff8800c950ac58
[138011.264007] Call Trace:
[138011.264045]  [<ffffffff816f81a9>] schedule+0x29/0x70
[138011.264097]  [<ffffffffa01a6f65>] 
btrfs_commit_transaction+0x315/0xa10 [btrfs]
[138011.264178]  [<ffffffff810acf40>] ? prepare_to_wait_event+0x100/0x100
[138011.264235]  [<ffffffffa01a2ea5>] transaction_kthread+0x1b5/0x240 
[btrfs]
[138011.264293]  [<ffffffffa01a2cf0>] ? 
btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[138011.264376]  [<ffffffff81088e72>] kthread+0xd2/0xf0
[138011.264422]  [<ffffffff81088da0>] ? kthread_create_on_node+0x190/0x190
[138011.264475]  [<ffffffff81704dfc>] ret_from_fork+0x7c/0xb0
[138011.264522]  [<ffffffff81088da0>] ? kthread_create_on_node+0x190/0x190
--snip--
