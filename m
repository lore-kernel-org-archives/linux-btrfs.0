Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.palepurple.co.uk ([89.16.183.188]:46593 "EHLO
	mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbbLIKrJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Dec 2015 05:47:09 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.palepurple.co.uk (Postfix) with ESMTP id 90AE2812B
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Dec 2015 10:47:07 +0000 (GMT)
Received: from mail.palepurple.co.uk ([127.0.0.1])
	by localhost (mail.palepurple.co.uk [127.0.0.50]) (amavisd-new, port 10024)
	with ESMTP id JSWz_-XfyEUc for <linux-btrfs@vger.kernel.org>;
	Wed,  9 Dec 2015 10:46:52 +0000 (GMT)
Received: from [172.30.33.200] (host81-133-46-190.in-addr.btopenworld.com [81.133.46.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: david@palepurple.co.uk)
	by mail.palepurple.co.uk (Postfix) with ESMTPSA id 3A7C38111
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Dec 2015 10:46:52 +0000 (GMT)
From: David Goodwin <david@codepoets.co.uk>
Subject: kernel 4.1.13 - balance bug?
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <5668069C.6010608@codepoets.co.uk>
Date: Wed, 9 Dec 2015 10:46:52 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Trying to run a balance on a filesystem results in the below dmesg output.

Kernel is 4.1.13 from kernel.org.
System is running in AWS (hence the Xen stuff).



INFO: task btrfs:28938 blocked for more than 120 seconds.
       Not tainted 4.1.13-dg1 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs           D ffff8800eb016840     0 28938  28934 0x00000000
  ffff8800e92694f0 ffffffff810046ff ffff8800e6dbc050 ffff8800ea6f4010
  ffff880000078000 7fffffffffffffff ffff8800ae8f77d8 ffff8800e92694f0
  ffff8800ae19ce20 0000000000000001 ffffffff81574a4f ffff8800ae8f77e0
Call Trace:
  [<ffffffff810046ff>] ? xen_load_sp0+0x7f/0x130
  [<ffffffff81574a4f>] ? schedule+0x2f/0x80
  [<ffffffff81577dfa>] ? schedule_timeout+0x21a/0x290
  [<ffffffff815743a0>] ? __schedule+0x2b0/0x930
  [<ffffffff815761c5>] ? wait_for_completion+0xb5/0x180
  [<ffffffff8109c4b0>] ? wake_up_state+0x20/0x20
  [<ffffffffa0088c16>] ? btrfs_async_run_delayed_refs+0x126/0x150 [btrfs]
  [<ffffffffa00a3d4e>] ? __btrfs_end_transaction+0x27e/0x410 [btrfs]
  [<ffffffffa00f5dc7>] ? relocate_block_group+0x277/0x6b0 [btrfs]
  [<ffffffffa00f63d6>] ? btrfs_relocate_block_group+0x1d6/0x2e0 [btrfs]
  [<ffffffffa00cb6be>] ? btrfs_relocate_chunk.isra.38+0x3e/0xd0 [btrfs]
  [<ffffffffa00ccd3c>] ? btrfs_balance+0x91c/0xed0 [btrfs]
  [<ffffffffa00d5add>] ? btrfs_ioctl_balance+0x3ad/0x420 [btrfs]
  [<ffffffffa00d9710>] ? btrfs_ioctl+0x570/0x27e0 [btrfs]
  [<ffffffff81008615>] ? xen_set_pte_at+0x85/0x2a0
  [<ffffffff8118a25c>] ? handle_mm_fault+0xc0c/0x1640
  [<ffffffff811e0328>] ? do_vfs_ioctl+0x2e8/0x4f0
  [<ffffffff81060d61>] ? __do_page_fault+0x1d1/0x490
  [<ffffffff811e05b1>] ? SyS_ioctl+0x81/0xa0
  [<ffffffff815790f2>] ? system_call_fastpath+0x16/0x75


After rebooting, the same message comes up if I try to resume the balance.


After rebooting again, if I cancel the balance (mount -o ... 
skip_balance ; btrfs balance cancel /whatever )

and then run

'btrfs check --repair /dev/whatever' I see messages like :


bad metadata [279388160000, 279388176384) crossing stripe boundary
bad metadata [279388946432, 279388962816) crossing stripe boundary
bad metadata [279389208576, 279389224960) crossing stripe boundary
... (repeat a few times)

repaired damaged extent references
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
reset nbytes for ino 1571860 root 1412
warning line 3597
checking csums
checking root refs
found 538506966512 bytes used err is 0
total csum bytes: 500379820
total tree bytes: 26440007680
total fs tree bytes: 23403429888
total extent tree bytes: 2439593984
btree space waste bytes: 6268486972
file data blocks allocated: 1918116421632
  referenced 1946322268160
btrfs-progs v4.2.3


But after this 'repair' a balance will still not complete, with the same 
error as above being generated.


Otherwise the FS seems usable ... so for now I'll just skip running a 
balance on it and hope it's fixed in a newer kernel when I eventually 
upgrade.

thanks
David.

