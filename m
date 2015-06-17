Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43300 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758105AbbFQHtH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 03:49:07 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5H7lTn5015759
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 15:47:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/5] Rework/enhance btrfs-map-logical
Date: Wed, 17 Jun 2015 15:48:59 +0800
Message-ID: <1434527344-314-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although btrfs-map-logical is mainly a tool for developers, but even as
a developer, I feel quite frustrated about the bug I found:

1) Assert if pass bytenr of a tree root
The most annoying one.
---
$ btrfs-map-logical  -l 29425664 /dev/sda6 
mirror 1 logical 29425664 physical 37814272 device /dev/sda6
mirror 2 logical 29425664 physical 1111556096 device /dev/sda6
extent_io.c:582: free_extent_buffer: Assertion `eb->refs < 0` failed.
btrfs-map-logical[0x41c464]
btrfs-map-logical(free_extent_buffer+0xc0)[0x41cf10]
btrfs-map-logical(btrfs_release_all_roots+0x59)[0x40e649]
btrfs-map-logical(close_ctree+0x1aa)[0x40f51a]
btrfs-map-logical(main+0x387)[0x4077c7]
/usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7f1e7f619790]
btrfs-map-logical(_start+0x29)[0x4078f9]
---

2) Strange logical offset and non-exist mapping
---
$ btrfs-map-logical  -l 1 -b 8192 /dev/sda6 
mirror 1 logical 1 physical 1 device /dev/sda6
mirror 1 logical 4097 physical 4097 device /dev/sda6
---
There is no extents in that range normally.
Despite that, for the first mirror, it's OK to start from 1 as I passed an
unaligned bytenr.
But why the 2nd non-exist mapping is also unaligned?

For all the fix, see the commit message of the 5th patch.

Qu Wenruo (5):
  btrfs-progs: Export read_extent_data function.
  btrfs-progs: map-logical: Introduce map_one_extent function.
  Btrfs-progs: map-logical: Introduce print_mapping_info function.
  Btrfs-progs: map-logical: Introduce write_extent_content function.
  btrfs-progs: map-logical: Rework map-logical logics.

 btrfs-map-logical.c | 273 +++++++++++++++++++++++++++++++++++++++-------------
 cmds-check.c        |  34 -------
 disk-io.c           |  34 +++++++
 disk-io.h           |   2 +
 4 files changed, 243 insertions(+), 100 deletions(-)

-- 
2.4.3

