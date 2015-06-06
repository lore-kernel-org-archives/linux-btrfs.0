Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.modernbiztonsag.org ([5.9.77.10]:65110 "EHLO
	mail.modernbiztonsag.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbbFFVfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Jun 2015 17:35:03 -0400
Received: from amavis (amavis.jails [10.0.0.30])
	by mail.modernbiztonsag.org (Postfix) with ESMTP id 28EA118F03A
	for <linux-btrfs@vger.kernel.org>; Sat,  6 Jun 2015 23:28:47 +0200 (CEST)
Received: from mail.modernbiztonsag.org ([10.0.0.5])
	by amavis (amavis.jails [10.0.0.30]) (amavisd-new, port 10026)
	with ESMTP id 2hofFrwFL8Qh for <linux-btrfs@vger.kernel.org>;
	Sat,  6 Jun 2015 23:28:45 +0200 (CEST)
Received: from [192.168.137.155] (5400D012.dsl.pool.telekom.hu [84.0.208.18])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.modernbiztonsag.org (Postfix) with ESMTPSA id BE90D18F030
	for <linux-btrfs@vger.kernel.org>; Sat,  6 Jun 2015 23:28:44 +0200 (CEST)
From: Gabri Mate <mate@gabri.hu>
Content-Type: text/plain; charset=us-ascii
Subject: btrfs-transaction is blocked if mounted as rw
Message-Id: <4E041BB2-AB2D-4E50-9C2A-4C08CDC2CB6E@gabri.hu>
Date: Sat, 6 Jun 2015 23:28:43 +0200
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear List,

I have a 12 disk RAID10 btrfs array running on 3.18.14. The FS is 50% and has about 100 snapshots. The metadata size is about 450 GB. I was doing a metadata balance when the system crashed. After that when I try to mount the FS normally it crashes the host with the following error:

[  601.168088] INFO: task btrfs-transacti:4506 blocked for more than 120 seconds.
[  601.168154]       Not tainted 3.18.14 #1
[  601.168181] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  601.168232] btrfs-transacti D ffff880271ee2e40     0  4506      2 0x00000000
[  601.168240]  ffff8802777873b0 0000000000000046 ffff880474728568 ffff880271ee29e0
[  601.168244]  0000000000012d80 ffff880273ea3fd8 0000000000012d80 ffff880271ee29e0
[  601.168249]  0000000000000246 ffff8801bf70df00 ffff8800790731f0 ffff8800790731f0
[  601.168253] Call Trace:
[  601.168303]  [<ffffffffa02c5661>] ? wait_current_trans.isra.32+0xa1/0x100 [btrfs]
[  601.168314]  [<ffffffff810a7150>] ? finish_wait+0xa0/0xa0
[  601.168333]  [<ffffffffa02c6e38>] ? start_transaction+0x298/0x590 [btrfs]
[  601.168339]  [<ffffffff810c9f10>] ? call_timer_fn+0x100/0x100
[  601.168356]  [<ffffffffa02c3e3d>] ? transaction_kthread+0x7d/0x250 [btrfs]
[  601.168371]  [<ffffffffa02c3dc0>] ? open_ctree+0x2220/0x2220 [btrfs]
[  601.168377]  [<ffffffff81089ec1>] ? kthread+0xc1/0xe0
[  601.168382]  [<ffffffff81089e00>] ? kthread_create_on_node+0x1c0/0x1c0
[  601.168389]  [<ffffffff8154c618>] ? ret_from_fork+0x58/0x90
[  601.168393]  [<ffffffff81089e00>] ? kthread_create_on_node+0x1c0/0x1c0

Mounting it as read only works fine. I have tried skip_balance without any success. I have also tried multiple kernel versions from 3.16 to 4.0 but I got similar results to the above. Do you have any suggestions I could try to get this FS mounted as read-write?

Best regards,
Mate