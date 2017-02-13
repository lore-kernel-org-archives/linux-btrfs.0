Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40374 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750853AbdBMOak (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 09:30:40 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 51B45AD51
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 14:30:39 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/7] btrfs: qgroups: make __del_qgroup_relation static
Date: Mon, 13 Feb 2017 15:30:10 +0100
Message-Id: <9f1039e7f1bf04eb6a5222e8010e509580bbe754.1486995885.git.dsterba@suse.com>
In-Reply-To: <cover.1486995885.git.dsterba@suse.com>
References: <cover.1486995885.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Internal helper.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8496dbf3f38b..971701328229 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1223,7 +1223,7 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int __del_qgroup_relation(struct btrfs_trans_handle *trans,
+static int __del_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst)
 {
 	struct btrfs_root *quota_root;
-- 
2.10.1

