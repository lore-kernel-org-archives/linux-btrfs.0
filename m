Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29076 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750950AbbGJELI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 00:11:08 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6A49MB1016296
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jul 2015 12:09:22 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 0/2] Btrfs partial csum support
Date: Fri, 10 Jul 2015 12:09:01 +0800
Message-ID: <1436501343-2605-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset will add partial csum support for btrfs.

Partial csum will take full advantage of the 32 bytes csum space inside
the tree block, while still maintain backward compatibility on old
kernels.

The overall idea is like the following on 16K leaf:
[Old tree block csum]
0     4     8    12    16    20    24    28    32
-------------------------------------------------
|csum |   unused, all 0				|
-------------------------------------------------
Csum is the crc32 of the whole tree block data.

[New tree block csum]
-------------------------------------------------
|csum0|csum1|csum2|csum3|csum4|csum5|csum6|csum7|
-------------------------------------------------
Where csum0 is the same as the old one, crc32 of the whole tree block
data.

And csum1~csum7 will restore crc32 of each eighth part.
Take example of 16K leafsize, then:
csum1: crc32 of BTRFS_CSUM_SIZE~4K
csum2: crc32 of 4K~6K
...
csum7: crc32 of 14K~16K


When nodesize is small, like 4K, partial csum is completely useless.
But when nodesize grows up, like 32K, each partial csum will just covers
a page, making scrub able to judge which page is OK even without reading
out the whole tree block.

And add the possibility to fix case like corruption happens at all
mirror but in different part.
Such case should be more possible if nodesize goes up beyond 16K.

Qu Wenruo (1):
  btrfs: csum: Introduce partial csum for tree block.

Zhao Lei (1):
  btrfs: scrub: Add support partial csum

 fs/btrfs/disk-io.c |  74 ++++++++++++-------
 fs/btrfs/scrub.c   | 207 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 255 insertions(+), 26 deletions(-)

-- 
2.4.5

