Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44621 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbcAFXkY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jan 2016 18:40:24 -0500
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] Btrfs: fix regression that makes fitrim ioctl discard a device's MBR
Date: Wed,  6 Jan 2016 23:40:14 +0000
Message-Id: <1452123616-24023-1-git-send-email-fdmanana@kernel.org>
In-Reply-To: <1452121064-15594-1-git-send-email-fdmanana@kernel.org>
References: <1452121064-15594-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

As of the 4.3 kernel release, the fitrim ioctl can now discard any region
of a disk that is not part of a chunk/block group, including the MBR
(master boot record).
Fix this by not allowing to trim/discard any region in the device starting
with an offset not greater than min(alloc_start_mount_option, 1Mb), just
as we did for space allocated to chunks/block groups.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=109341
Fixes: 499f377f49f0 (btrfs: iterate over unused chunk space in FITRIM)
Cc: stable@vger.kernel.org # 4.3+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Fix possiblity of endless loop with fitrim call.

 fs/btrfs/volumes.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a114b7b..fd71ee3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1258,6 +1258,14 @@ int find_free_dev_extent_start(struct btrfs_transaction *transaction,
 	int ret;
 	int slot;
 	struct extent_buffer *l;
+	u64 min_search_start;
+
+	/*
+	 * we don't want to overwrite the superblock on the drive (nor the MBR
+	 * sector), so we make sure to start at an offset of at least 1MB
+	 */
+	min_search_start = max(root->fs_info->alloc_start, 1024ull * 1024);
+	search_start = max(search_start, min_search_start);
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -1398,18 +1406,9 @@ int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *len)
 {
-	struct btrfs_root *root = device->dev_root;
-	u64 search_start;
-
 	/* FIXME use last free of some kind */
-
-	/*
-	 * we don't want to overwrite the superblock on the drive,
-	 * so we make sure to start at an offset of at least 1MB
-	 */
-	search_start = max(root->fs_info->alloc_start, 1024ull * 1024);
 	return find_free_dev_extent_start(trans->transaction, device,
-					  num_bytes, search_start, start, len);
+					  num_bytes, 0, start, len);
 }
 
 static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
-- 
2.1.3

