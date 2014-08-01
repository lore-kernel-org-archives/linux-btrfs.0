Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39932 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbaHAXMs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 19:12:48 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/12] btrfs: handle errors from reading the quota tree root
Date: Fri,  1 Aug 2014 18:12:37 -0500
Message-Id: <1406934766-16974-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reading the quota tree root may fail with ENOENT
if there is no quota, which is fine, but the code was
ignoring every other error as well, which is not fine.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/disk-io.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e6746be..28d35a8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2733,7 +2733,12 @@ retry_root_backup:
 
 	location.objectid = BTRFS_QUOTA_TREE_OBJECTID;
 	quota_root = btrfs_read_tree_root(tree_root, &location);
-	if (!IS_ERR(quota_root)) {
+	if (IS_ERR(quota_root)) {
+		ret = PTR_ERR(quota_root);
+		/* It's fine to not have quotas */
+		if (ret != -ENOENT)
+			goto recovery_tree_root;
+	} else {
 		set_bit(BTRFS_ROOT_TRACK_DIRTY, &quota_root->state);
 		fs_info->quota_enabled = 1;
 		fs_info->pending_quota_state = 1;
-- 
1.7.1

