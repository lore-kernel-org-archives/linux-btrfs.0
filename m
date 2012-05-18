Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7889 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756991Ab2ERKDw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 06:03:52 -0400
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q4IA3lS1025150
	for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2012 18:03:48 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs: make sure that we've made everything in pinned tree clean
Date: Fri, 18 May 2012 18:07:50 +0800
Message-Id: <1337335671-24926-2-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1337335671-24926-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1337335671-24926-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have two trees for recording pinned extents, we need to go through
both of them to make sure that we've done everything clean.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 046a737..144f019 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3548,8 +3548,10 @@ static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
 	u64 start;
 	u64 end;
 	int ret;
+	bool loop = true;
 
 	unpin = pinned_extents;
+again:
 	while (1) {
 		ret = find_first_extent_bit(unpin, 0, &start, &end,
 					    EXTENT_DIRTY);
@@ -3567,6 +3569,15 @@ static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
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

