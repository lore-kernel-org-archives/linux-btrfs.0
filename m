Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26105 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030401AbaGCJfh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 05:35:37 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s639ZYQI009551
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 17:35:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/4] Add superblock checksum check for btrfs-progs
Date: Thu, 3 Jul 2014 17:36:34 +0800
Message-ID: <1404380198-25948-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patchset, btrfs-progs will overall ignore the superblock
checksum and continue the routine.
Sometimes this may cause disasters like checking a btrfs with corrupted
superblock will lead to crash in btrfs-progs.

This patch introduces superblock checksum check into btrfs_read_dev_super(),
making btrfs-progs much more restricted and robust.
To allow super-recover to open devices, add options to scan all 3
superblocks when using super-recover.
Also updated the related error string and fix a bug in chunk-recover that
will not be triggered until superblock csum is calculated.

Qu Wenruo (4):
  btrfs-progs: Check superblock's checsum when read dev super
  btrfs-progs: Allow btrfs_read_dev_super() to read all 3 super for    
    super_recover.
  btrfs-progs: Add more meaningful return value for
    btrfs_read_dev_super()     and corresponding error string.
  btrfs-progs: Fix size for malloc for superblock checksum.

 btrfs-find-root.c |  9 ++++--
 chunk-recover.c   | 18 +++++++----
 cmds-filesystem.c |  9 ++++--
 disk-io.c         | 91 +++++++++++++++++++++++++++++++++++++------------------
 disk-io.h         |  5 +--
 super-recover.c   |  2 +-
 utils.c           | 16 ++++++----
 volumes.c         |  8 ++---
 volumes.h         |  2 +-
 9 files changed, 104 insertions(+), 56 deletions(-)

-- 
2.0.1

