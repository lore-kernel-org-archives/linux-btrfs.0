Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:40726 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbcBOOPl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 09:15:41 -0500
Received: from homiemail-a30.g.dreamhost.com (sub4.mail.dreamhost.com [69.163.253.135])
	by hapkido.dreamhost.com (Postfix) with ESMTP id E1B14987EF
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Feb 2016 18:15:24 -0800 (PST)
Received: from homiemail-a30.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a30.g.dreamhost.com (Postfix) with ESMTP id 50F8C21DE8B
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Feb 2016 18:15:22 -0800 (PST)
Received: from [192.168.1.14] (pool-74-104-127-105.bstnma.fios.verizon.net [74.104.127.105])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: laurion@lebor.net)
	by homiemail-a30.g.dreamhost.com (Postfix) with ESMTPSA id 1DC5D21DE7E
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Feb 2016 18:15:22 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Chad Bergeron <chad@chadbergeron.com>
Subject: btrfs check --repair dumps out
Message-ID: <56C134B9.4030200@chadbergeron.com>
Date: Sun, 14 Feb 2016 21:15:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a multi-drive raid10 btrfs array that isn't working. When I can 
mount it, it is r/o, and before I give it up for lost, I thought I'd 
share what happens when I try to run btrfs check.

For starters-
uname -a: Linux palantir 4.4.1-2-ARCH #1 SMP PREEMPT Wed Feb 3 13:12:33 
UTC 2016 x86_64 GNU/Linux
btrfs --version: btrfs-progs v4.4

Now here's what I get with a regular check:
btrfs check /dev/sdb
Checking filesystem on /dev/sdb
UUID: 0f9f134a-dc79-47a2-92e4-48296074fc5c
checking extents
parent transid verify failed on 14750730125312 wanted 77856 found 195709
parent transid verify failed on 14750730125312 wanted 77856 found 195709
parent transid verify failed on 14750730125312 wanted 77856 found 195709
parent transid verify failed on 14750730125312 wanted 77856 found 195709
Ignoring transid failure
leaf parent key incorrect 14750730125312
bad block 14750730125312
Errors found in extent allocation tree or chunk allocation
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 5 root dir 256 not found
found 101074178 bytes used err is 1
total csum bytes: 0
total tree bytes: 2310144
total fs tree bytes: 393216
total extent tree bytes: 98304
btree space waste bytes: 431919
file data blocks allocated: 1149239296
  referenced 1149239296

I know to ignore messages about transid and space cache. It's the bad 
block and the missing root 5 directory that concern me.

Having taken other steps and with little reason not to, I run check 
--repair and get:
btrfs check --repair /dev/sdb
enabling repair mode
Checking filesystem on /dev/sdb
UUID: 0f9f134a-dc79-47a2-92e4-48296074fc5c
checking extents
parent transid verify failed on 14750730125312 wanted 77856 found 195709
parent transid verify failed on 14750730125312 wanted 77856 found 195709
parent transid verify failed on 14750730125312 wanted 77856 found 195709
parent transid verify failed on 14750730125312 wanted 77856 found 195709
Ignoring transid failure
leaf parent key incorrect 14750730125312
bad block 14750730125312
Errors found in extent allocation tree or chunk allocation
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 5 missing its root dir, recreating
Failed to find [14750727241728, 168, 16384]
btrfs unable to find ref byte nr 14751506759680 parent 0 root 5 owner 2 
offset 0
ctree.c:195: update_ref_for_cow: Assertion `ret` failed.
btrfs[0x4379c4]
btrfs(__btrfs_cow_block+0x630)[0x438b20]
btrfs(btrfs_cow_block+0x35)[0x438bb5]
btrfs(btrfs_search_slot+0x2c4)[0x43b5a4]
btrfs(btrfs_insert_empty_items+0x9c)[0x43c9fc]
btrfs(btrfs_insert_item+0x5e)[0x43cdfe]
btrfs(btrfs_insert_inode+0x34)[0x44c964]
btrfs(btrfs_make_root_dir+0x94)[0x454cb4]
btrfs[0x40dda9]
btrfs(cmd_check+0x10d7)[0x42abd7]
btrfs(main+0x82)[0x40f372]
/usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7f598278d610]
btrfs(_start+0x29)[0x40f479]

Let me know if you'd like any other debugging info, why --repair bombed 
out, and what next steps you think I should take.

Chad


