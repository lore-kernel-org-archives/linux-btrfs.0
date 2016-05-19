Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27912 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbcESIor (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 04:44:47 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: jbacik@fb.com
Subject: [PATCH] btrfs-progs: Enhance tree block check by checking empty leaf or node
Date: Thu, 19 May 2016 16:44:35 +0800
Message-Id: <1463647475-22102-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs, it's possible to have empty leaf, but empty node is not
possible.

Add check for empty node for tree blocks.

Suggested-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/disk-io.c b/disk-io.c
index 86abdeb..b4f185f 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -67,6 +67,11 @@ static int check_tree_block(struct btrfs_fs_info *fs_info,
 						    nodesize))
 		return BTRFS_BAD_NRITEMS;
 
+	/* Only leaf can be empty */
+	if (btrfs_header_nritems(buf) == 0 &&
+	    btrfs_header_level(buf) != 0)
+		return BTRFS_BAD_NRITEMS;
+
 	fs_devices = fs_info->fs_devices;
 	while (fs_devices) {
 		if (fs_info->ignore_fsid_mismatch ||
-- 
2.8.2



