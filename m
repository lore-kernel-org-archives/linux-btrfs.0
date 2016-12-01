Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933545AbcLAR20 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Dec 2016 12:28:26 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5DFCBAABE
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Dec 2016 17:28:25 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] btrfs-progs: Initialize ret to suppress compiler warning
Date: Thu,  1 Dec 2016 11:28:20 -0600
Message-Id: <20161201172820.1139-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 cmds-check.c    | 2 +-
 qgroup-verify.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 85eaa63..a9501f5 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8041,7 +8041,7 @@ static int record_extent(struct btrfs_trans_handle *trans,
 			 struct extent_backref *back,
 			 int allocated, u64 flags)
 {
-	int ret;
+	int ret = 0;
 	struct btrfs_root *extent_root = info->extent_root;
 	struct extent_buffer *leaf;
 	struct btrfs_key ins_key;
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 39762bf..ff46bc4 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -1575,7 +1575,7 @@ out:
 
 int repair_qgroups(struct btrfs_fs_info *info, int *repaired)
 {
-	int ret;
+	int ret = 0;
 	struct qgroup_count *count, *tmpcount;
 
 	*repaired = 0;
-- 
2.10.2

