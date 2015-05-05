Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23855 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752642AbbEEGSu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 02:18:50 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t456HUaM008338
	for <linux-btrfs@vger.kernel.org>; Tue, 5 May 2015 14:17:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/8] Introduce offline fsid/chunk tree uuid change for btrfstune.
Date: Tue, 5 May 2015 14:16:38 +0800
Message-ID: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset will introduce offline fsid/chunk tree uuid change
function to btrfstune command, with "-u" and "-U" options respectively.

The implement is in-place btrfs_header modification, without transaction
protection. So the uuid change can be done on any valid image even it is
already full.

Since we don't use transaction to protect the convert, it's possible one
can stop the running convert progress, causing the fs in a inconsistent
status and unable to be mounted.
To avoid such problem, we introduce new open ctree flags
OPEN_CTREE_IGNORE_FSID, allowing btrfstune to finish the convert.

Qu Wenruo (8):
  btrfs-progs: Allow open_ctree to ignore fsid mismatch.
  btrfs-progs: Export write_tree_block().
  btrfs-progs: Introduce change_header_uuid() function.
  btrfs-progs: Introduce change_extents_uuid() function.
  btrfs-progs: Introduce function change_device_uuid().
  btrfs-progs: Introduce change_devices_uuid() function.
  btrfs-progs: Introduce change_uuid() function.
  btrfs-progs: btrfstune: Introduce new "-u" and "-U" options.

 Documentation/btrfstune.asciidoc |  12 +-
 btrfstune.c                      | 288 ++++++++++++++++++++++++++++++++++++++-
 ctree.h                          |   3 +
 disk-io.c                        |   9 +-
 disk-io.h                        |   6 +
 5 files changed, 309 insertions(+), 9 deletions(-)

-- 
2.3.7

