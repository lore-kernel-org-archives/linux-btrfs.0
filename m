Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48063 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753748AbbJZKaD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 06:30:03 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9QATSde004070
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 18:29:28 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 0/5] btrfs-progs: Add all missing close_ctree and btrfs_close_all_devices
Date: Mon, 26 Oct 2015 18:28:17 +0800
Message-ID: <cover.1445855131.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch add all missing close_ctree and btrfs_close_all_devices
to several tools in btrfs progs, to avoid memory leak.

Changelog v1->v2:
 Move btrfs_close_all_devices() from cmd-XXX into btrfs.c to make
 code simple, and avoid similar problem in cmd-XXX in future.

Zhao Lei (5):
  btrfs-progs: btrfs: Add missing btrfs_close_all_devices for btrfs
    command
  btrfs-progs: Remove all btrfs_close_all_devices in sub-command
  btrfs-progs: Add all missing btrfs_close_all_devices to standalone
    tools
  btrfs-progs: Add missing close_ctree to btrfs-select-super.c
  btrfs-progs: use system's default path for math.h

 btrfs-calc-size.c    | 1 +
 btrfs-debug-tree.c   | 5 ++++-
 btrfs-find-root.c    | 1 +
 btrfs-map-logical.c  | 1 +
 btrfs-select-super.c | 3 +++
 btrfs.c              | 9 ++++++++-
 btrfstune.c          | 1 +
 cmds-check.c         | 1 -
 cmds-device.c        | 3 ---
 cmds-replace.c       | 2 --
 extent-tree.c        | 2 +-
 11 files changed, 20 insertions(+), 9 deletions(-)

-- 
1.8.5.1

