Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17798 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751317AbaLSGPP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 01:15:15 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBJ6EkpN027632
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 14:14:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/5] Cleanup warnings from clang
Date: Fri, 19 Dec 2014 14:13:07 +0800
Message-ID: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup warning when compile btrfs-progs with clang.

Clang analyser also reports about 60+ errors, but it will be another
patchset fixing it later.

Qu Wenruo (5):
  btrfs-progs: Makefile: Move linker only option to LDFLAGS
  btrfs-progs: Fix a clang dead-judgement warning in disk-io.c.
  btrfs-progs: Remove a unused function root_gtp_mask().
  btrfs-progs: Remove a unused function offset_to_bitmap()
  btrfs-progs: Remove deprecated _BSD_SOURCE macro.

 Makefile           |  3 ++-
 cmds-receive.c     |  2 +-
 disk-io.c          |  9 ++++++---
 free-space-cache.c | 16 ----------------
 radix-tree.c       |  5 -----
 5 files changed, 9 insertions(+), 26 deletions(-)

-- 
2.1.3

