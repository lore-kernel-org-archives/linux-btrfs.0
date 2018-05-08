Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42465 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754151AbeEHGcC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 02:32:02 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C3083AF68
        for <linux-btrfs@vger.kernel.org>; Tue,  8 May 2018 06:32:01 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 01/12] btrfs-progs: qgroup-verify: Also repair qgroup status version
Date: Tue,  8 May 2018 14:31:45 +0800
Message-Id: <20180508063156.24665-2-wqu@suse.com>
In-Reply-To: <20180508063156.24665-1-wqu@suse.com>
References: <20180508063156.24665-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current kernel only supports qgroup version 1.
Make qgroup-verify to follow this standard.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h         | 1 +
 qgroup-verify.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/ctree.h b/ctree.h
index fa861ba0b4c3..cf99df1c90a8 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1012,6 +1012,7 @@ struct btrfs_qgroup_status_item {
 	__le64 rescan;		/* progress during scanning */
 } __attribute__ ((__packed__));
 
+#define BTRFS_QGROUP_STATUS_VERSION		1
 struct btrfs_block_group_item {
 	__le64 used;
 	__le64 chunk_objectid;
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 571b4d4f7171..58c735788977 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -1563,6 +1563,8 @@ static int repair_qgroup_status(struct btrfs_fs_info *info)
 	btrfs_set_qgroup_status_rescan(path.nodes[0], status_item, 0);
 	btrfs_set_qgroup_status_generation(path.nodes[0], status_item,
 					   trans->transid);
+	btrfs_set_qgroup_status_version(path.nodes[0], status_item,
+					BTRFS_QGROUP_STATUS_VERSION);
 
 	btrfs_mark_buffer_dirty(path.nodes[0]);
 
-- 
2.17.0

