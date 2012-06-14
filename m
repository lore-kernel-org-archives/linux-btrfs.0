Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59460 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2FNIQD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 04:16:03 -0400
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <chris.mason@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 05/10 RESEND] Btrfs: make sure that we've made everything in pinned tree clean
Date: Thu, 14 Jun 2012 16:23:21 +0800
Message-Id: <1339662206-5307-6-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1339662206-5307-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have two trees for recording pinned extents, we need to go through
both of them to make sure that we've done everything clean.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1030cff..61deaa6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3553,8 +3553,10 @@ static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
 	u64 start;
 	u64 end;
 	int ret;
+	bool loop = true;
 
 	unpin = pinned_extents;
+again:
 	while (1) {
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
 					    EXTENT_DIRTY);
@@ -3572,6 +3574,15 @@ static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
 		cond_resched();
 	}
 
+	if (loop) {
+		if (unpin == &root->fs_info->freed_extents[0])
+			unpin = &root->fs_info->freed_extents[1];
+		else
+			unpin = &root->fs_info->freed_extents[0];
+		loop = false;
+		goto again;
+	}
+
 	return 0;
 }
 
-- 
1.6.5.2

