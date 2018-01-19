Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33439 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753548AbeASFhs (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:37:48 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 07/16] btrfs-progs: check: Move fs_root_objectid function to check/common.h
Date: Fri, 19 Jan 2018 13:37:22 +0800
Message-Id: <20180119053731.10795-8-wqu@suse.com>
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
References: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just another small wrapper shared between original and lowmem mode.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/common.h |  8 ++++++++
 check/main.c   | 10 ----------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/check/common.h b/check/common.h
index 3e0a5ebee54b..77a0ab54166f 100644
--- a/check/common.h
+++ b/check/common.h
@@ -72,4 +72,12 @@ static inline u8 imode_to_type(u32 imode)
 #undef S_SHIFT
 }
 
+static inline int fs_root_objectid(u64 objectid)
+{
+	if (objectid == BTRFS_TREE_RELOC_OBJECTID ||
+	    objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+		return 1;
+	return is_fstree(objectid);
+}
+
 #endif
diff --git a/check/main.c b/check/main.c
index eaa8e7fbde20..9ecbac8f19c3 100644
--- a/check/main.c
+++ b/check/main.c
@@ -2167,8 +2167,6 @@ out:
 	return err;
 }
 
-static int fs_root_objectid(u64 objectid);
-
 /*
  * Update global fs information.
  */
@@ -4250,14 +4248,6 @@ skip_walking:
 	return ret;
 }
 
-static int fs_root_objectid(u64 objectid)
-{
-	if (objectid == BTRFS_TREE_RELOC_OBJECTID ||
-	    objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
-		return 1;
-	return is_fstree(objectid);
-}
-
 static int check_fs_roots(struct btrfs_fs_info *fs_info,
 			  struct cache_tree *root_cache)
 {
-- 
2.15.1

