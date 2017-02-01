Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbdBAPXm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Feb 2017 10:23:42 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id F16C5202EB
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Feb 2017 15:23:40 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C5A7202B8
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Feb 2017 15:23:39 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not create explicit holes when replaying log tree if NO_HOLES enabled
Date: Wed,  1 Feb 2017 15:23:34 +0000
Message-Id: <1485962614-7892-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

We log holes explicitly by using file extent items, however when replaying
a log tree, if a logged file extent item corresponds to a hole and the
NO_HOLES feature is enabled we do not need to copy the file extent item
into the fs/subvolume tree, as the absence of such file extent items is
the purpose of the NO_HOLES feature. So skip the copying of file extent
items representing holes when the NO_HOLES feature is enabled.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index eeffff8..44aca7f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -667,6 +667,10 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
+	if (btrfs_file_extent_disk_bytenr(eb, item) == 0 &&
+	    btrfs_fs_incompat(fs_info, NO_HOLES))
+		goto update_inode;
+
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		u64 offset;
@@ -825,6 +829,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	}
 
 	inode_add_bytes(inode, nbytes);
+update_inode:
 	ret = btrfs_update_inode(trans, root, inode);
 out:
 	if (inode)
-- 
2.7.0.rc3

