Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:37775 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751798AbdJXIkK (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Oct 2017 04:40:10 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
Subject: [PATCH 6/6] btrfs: qgroup: Cleanup the remaining old reservation counters
Date: Tue, 24 Oct 2017 16:39:41 +0800
Message-Id: <20171024083941.21428-7-wqu@suse.com>
In-Reply-To: <20171024083941.21428-1-wqu@suse.com>
References: <20171024083941.21428-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So qgroup is switched to new separate types reservation system.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 13 -------------
 fs/btrfs/qgroup.h |  1 -
 2 files changed, 14 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 2b587056b797..c5936fc75a4d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1063,19 +1063,6 @@ static void qgroup_dirty(struct btrfs_fs_info *fs_info,
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
  * only have exclusive extents.
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 0b04cbc5b5ce..7b21e61a399c 100644
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
2.14.2

