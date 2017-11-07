Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:35884 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756638AbdKGInJ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 7 Nov 2017 03:43:09 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 01/12] btrfs-progs: qgroup-verify: Also repair qgroup status version
Date: Tue,  7 Nov 2017 16:42:46 +0800
Message-Id: <20171107084259.22367-3-wqu@suse.com>
In-Reply-To: <20171107084259.22367-1-wqu@suse.com>
References: <20171107084259.22367-1-wqu@suse.com>
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
index 22806599a744..506b76766579 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1011,6 +1011,7 @@ struct btrfs_qgroup_status_item {
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
2.15.0

