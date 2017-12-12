Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:59088 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbdLLHfE (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 12 Dec 2017 02:35:04 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
Subject: [PATCH 06/14] btrfs: qgroup: Cleanup the remaining old reservation counters
Date: Tue, 12 Dec 2017 15:34:28 +0800
Message-Id: <20171212073436.16447-7-wqu@suse.com>
In-Reply-To: <20171212073436.16447-1-wqu@suse.com>
References: <20171212073436.16447-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So qgroup is switched to new separate types reservation system.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 13 -------------
 fs/btrfs/qgroup.h |  1 -
 2 files changed, 14 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index fbf7dd3b6fd1..39bdf5341372 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1065,19 +1065,6 @@ static void qgroup_dirty(struct btrfs_fs_info *fs_info,
 		list_add(&qgroup->dirty, &fs_info->dirty_qgroups);
 }
 
-static void report_reserved_underflow(struct btrfs_fs_info *fs_info,
-				      struct btrfs_qgroup *qgroup,
-				      u64 num_bytes)
-{
-#ifdef CONFIG_BTRFS_DEBUG
-	WARN_ON(qgroup->reserved < num_bytes);
-	btrfs_debug(fs_info,
-		"qgroup %llu reserved space underflow, have: %llu, to free: %llu",
-		qgroup->qgroupid, qgroup->reserved, num_bytes);
-#endif
-	qgroup->reserved = 0;
-}
-
 /*
  * The easy accounting, we're updating qgroup relationship whose child qgroup
  * only has exclusive extents.
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index fead9955af72..c8c81b923674 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -107,7 +107,6 @@ struct btrfs_qgroup {
 	/*
 	 * reservation tracking
 	 */
-	u64 reserved;
 	struct btrfs_qgroup_rsv rsv;
 
 	/*
-- 
2.15.1

