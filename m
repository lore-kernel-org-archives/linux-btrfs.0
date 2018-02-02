Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:48849 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbeBBITo (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 2 Feb 2018 03:19:44 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 5/7] btrfs-progs: volumes: Allow find_free_dev_extent() to return maximum hole size
Date: Fri,  2 Feb 2018 16:19:27 +0800
Message-Id: <20180202081929.15162-6-wqu@suse.com>
In-Reply-To: <20180202081929.15162-1-wqu@suse.com>
References: <20180202081929.15162-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just as kernel find_free_dev_extent(), allow it to return maximum hole
size for us to build device list for later chunk allocator rework.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 volumes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/volumes.c b/volumes.c
index b47ff1f392b5..f4009ffa7c9e 100644
--- a/volumes.c
+++ b/volumes.c
@@ -516,10 +516,10 @@ out:
 }
 
 static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
-				u64 *start)
+				u64 *start, u64 *len)
 {
 	/* FIXME use last free of some kind */
-	return find_free_dev_extent_start(device, num_bytes, 0, start, NULL);
+	return find_free_dev_extent_start(device, num_bytes, 0, start, len);
 }
 
 static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
@@ -543,7 +543,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	 * is responsible to make sure it's free.
 	 */
 	if (!convert) {
-		ret = find_free_dev_extent(device, num_bytes, start);
+		ret = find_free_dev_extent(device, num_bytes, start, NULL);
 		if (ret)
 			goto err;
 	}
-- 
2.16.1

