Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4.ptmail.sapo.pt ([212.55.154.24]:41802 "EHLO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751064AbcC2XiH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 19:38:07 -0400
Received: from unknown (HELO undercity) (as13914087@sapo.pt@[37.28.247.191])
          (envelope-sender <ab@tevsa.net>)
          by mta-auth02 (qmail-ptmail-1.0.0) with ESMTPA
          for <linux-btrfs@vger.kernel.org>; 29 Mar 2016 23:31:23 -0000
Received: from [10.5.2.101] (faraday.azeroth.net [10.5.2.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by undercity (Postfix) with ESMTPSA id 27B72146EC32
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Mar 2016 00:31:23 +0100 (WEST)
From: Alec Blayne <ab@tevsa.net>
Subject: PaX: size overflow detected
To: linux-btrfs@vger.kernel.org
Message-ID: <56FB1034.8010405@tevsa.net>
Date: Wed, 30 Mar 2016 00:31:00 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I got this warning on dmesg:

 PAX: size overflow detected in function btrfs_get_extent
fs/btrfs/inode.c:6690 cicus.1228_386 min, count: 104, decl: len; num: 0;
context: extent_map;

Which was followed by this Call Trace:

[  354.375166] Call Trace:
[  354.375173]  [<ffffffff81421945>] ? dump_stack+0x47/0x72
[  354.375177]  [<ffffffff811a94c5>] ? report_size_overflow+0x65/0x80
[  354.375182]  [<ffffffff812de407>] ? btrfs_get_extent+0xd07/0xd40
[  354.375186]  [<ffffffff81301e55>] ? __do_readpage+0x295/0xef0
[  354.375189]  [<ffffffff812fdd1c>] ? insert_state+0x9c/0x120
[  354.375191]  [<ffffffff812dd700>] ? btrfs_direct_IO+0x500/0x500
[  354.375195]  [<ffffffff810b84ac>] ? get_parent_ip+0xc/0x30
[  354.375197]  [<ffffffff81302fe6>] ?
__extent_readpages.constprop.43+0x316/0x360
[  354.375200]  [<ffffffff812dd700>] ? btrfs_direct_IO+0x500/0x500
[  354.375202]  [<ffffffff81304c1d>] ? extent_readpages+0x17d/0x190
[  354.375204]  [<ffffffff812dd700>] ? btrfs_direct_IO+0x500/0x500
[  354.375207]  [<ffffffff81184c3f>] ? alloc_pages_current+0x7f/0x110
[  354.375209]  [<ffffffff81147585>] ? __do_page_cache_readahead+0x1c5/0x240
[  354.375211]  [<ffffffff811476d9>] ? ondemand_readahead+0xd9/0x300
[  354.375214]  [<ffffffff81139965>] ? find_get_entry+0x65/0xa0
[  354.375216]  [<ffffffff8113a172>] ? pagecache_get_page+0x22/0x1b0
[  354.375218]  [<ffffffff8113b65d>] ? generic_file_read_iter+0x61d/0x7b0
[  354.375220]  [<ffffffff811a179b>] ? __vfs_read+0xdb/0x100
[  354.375222]  [<ffffffff811a22a6>] ? vfs_read+0xc6/0x250
[  354.375224]  [<ffffffff811a37b2>] ? SyS_pread64+0x82/0xa0
[  354.375228]  [<ffffffff818cf9d9>] ? entry_SYSCALL_64_fastpath+0x12/0x83
[  354.375230]  [<ffffffff818cfb61>] ? int_ret_from_sys_call+0x3a/0xa4


After this a process which was writting on the disk just hanged,
couldn't kill it etc.

Thought it might interest someone.

I'm running the following kernel on Gentoo:
"Linux faraday 4.4.6-hardened #7 SMP PREEMPT Sun Mar 27 10:37:51 WEST
2016 x86_64 Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz GenuineIntel GNU/Linux"

It has grsecurity patchset, as well as BFQ scheduler.

The filesystem is a two partition raid 1, sitting on top of luks.

Cheers.
