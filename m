Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:46004 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751185AbeACHNX (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 3 Jan 2018 02:13:23 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/5] btrfs-progs: volumes: Remove unnecessary trans parameter
Date: Wed,  3 Jan 2018 15:13:04 +0800
Message-Id: <20180103071306.11500-4-wqu@suse.com>
In-Reply-To: <20180103071306.11500-1-wqu@suse.com>
References: <20180103071306.11500-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove @trans parameter for find_free_dev_extent_start() and its
callers.

The function itself is doing read-only tree search, no use of
transaction.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 volumes.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/volumes.c b/volumes.c
index 0e50e1d5833e..f6c6447fe925 100644
--- a/volumes.c
+++ b/volumes.c
@@ -316,9 +316,9 @@ int btrfs_scan_one_device(int fd, const char *path,
  * But if we don't find suitable free space, it is used to store the size of
  * the max free space.
  */
-static int find_free_dev_extent_start(struct btrfs_trans_handle *trans,
-			       struct btrfs_device *device, u64 num_bytes,
-			       u64 search_start, u64 *start, u64 *len)
+static int find_free_dev_extent_start(struct btrfs_device *device,
+				      u64 num_bytes, u64 search_start,
+				      u64 *start, u64 *len)
 {
 	struct btrfs_key key;
 	struct btrfs_root *root = device->dev_root;
@@ -457,13 +457,11 @@ out:
 	return ret;
 }
 
-static int find_free_dev_extent(struct btrfs_trans_handle *trans,
-			 struct btrfs_device *device, u64 num_bytes,
-			 u64 *start)
+static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
+				u64 *start)
 {
 	/* FIXME use last free of some kind */
-	return find_free_dev_extent_start(trans, device,
-					  num_bytes, 0, start, NULL);
+	return find_free_dev_extent_start(device, num_bytes, 0, start, NULL);
 }
 
 static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
@@ -488,8 +486,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	 * is responsible to make sure it's free.
 	 */
 	if (!convert) {
-		ret = find_free_dev_extent(trans, device, num_bytes,
-					   start);
+		ret = find_free_dev_extent(device, num_bytes, start);
 		if (ret)
 			goto err;
 	}
-- 
2.15.1

