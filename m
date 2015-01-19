Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41939 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221AbbASGrU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 01:47:20 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0J6kenc022555
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 14:46:40 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 01/10] btrfs-progs: Cleanup, use bitshift instead of immediate number in btrfs_open_ctree_flags.
Date: Mon, 19 Jan 2015 14:45:03 +0800
Message-ID: <1421649912-14539-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change the immediate number in btrfs_open_ctree_flags to bit shift.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/disk-io.h b/disk-io.h
index 4818109..e12870e 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -26,13 +26,13 @@
 #define BTRFS_SUPER_MIRROR_SHIFT 12
 
 enum btrfs_open_ctree_flags {
-	OPEN_CTREE_WRITES		= 1,
-	OPEN_CTREE_PARTIAL		= 2,
-	OPEN_CTREE_BACKUP_ROOT		= 4,
-	OPEN_CTREE_RECOVER_SUPER	= 8,
-	OPEN_CTREE_RESTORE		= 16,
-	OPEN_CTREE_NO_BLOCK_GROUPS	= 32,
-	OPEN_CTREE_EXCLUSIVE		= 64,
+	OPEN_CTREE_WRITES		= (1 << 0),
+	OPEN_CTREE_PARTIAL		= (1 << 1),
+	OPEN_CTREE_BACKUP_ROOT		= (1 << 2),
+	OPEN_CTREE_RECOVER_SUPER	= (1 << 3),
+	OPEN_CTREE_RESTORE		= (1 << 4),
+	OPEN_CTREE_NO_BLOCK_GROUPS	= (1 << 5),
+	OPEN_CTREE_EXCLUSIVE		= (1 << 6),
 };
 
 static inline u64 btrfs_sb_offset(int mirror)
-- 
2.2.2

