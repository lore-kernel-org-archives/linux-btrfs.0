Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53638 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727025AbeHGKc6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 06:32:58 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E88B3ADB4
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Aug 2018 08:19:44 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/11] btrfs-progs: qgroup-verify: Also repair qgroup status version
Date: Tue,  7 Aug 2018 16:19:29 +0800
Message-Id: <20180807081938.21348-3-wqu@suse.com>
In-Reply-To: <20180807081938.21348-1-wqu@suse.com>
References: <20180807081938.21348-1-wqu@suse.com>
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
index 4719962df67d..61c3624ff5db 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1014,6 +1014,7 @@ struct btrfs_qgroup_status_item {
 	__le64 rescan;		/* progress during scanning */
 } __attribute__ ((__packed__));
 
+#define BTRFS_QGROUP_STATUS_VERSION		1
 struct btrfs_block_group_item {
 	__le64 used;
 	__le64 chunk_objectid;
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 9b509abb78fd..4b8bfa69914d 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -1598,6 +1598,8 @@ static int repair_qgroup_status(struct btrfs_fs_info *info)
 	btrfs_set_qgroup_status_rescan(path.nodes[0], status_item, 0);
 	btrfs_set_qgroup_status_generation(path.nodes[0], status_item,
 					   trans->transid);
+	btrfs_set_qgroup_status_version(path.nodes[0], status_item,
+					BTRFS_QGROUP_STATUS_VERSION);
 
 	btrfs_mark_buffer_dirty(path.nodes[0]);
 
-- 
2.18.0

