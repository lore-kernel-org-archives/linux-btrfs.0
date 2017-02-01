Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751111AbdBAQkU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Feb 2017 11:40:20 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id C42A420154
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Feb 2017 16:40:18 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F8B12034F
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Feb 2017 16:40:17 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: do not create explicit holes when replaying log tree if NO_HOLES enabled
Date: Wed,  1 Feb 2017 16:40:14 +0000
Message-Id: <1485967214-22606-1-git-send-email-fdmanana@kernel.org>
In-Reply-To: <1485962614-7892-1-git-send-email-fdmanana@kernel.org>
References: <1485962614-7892-1-git-send-email-fdmanana@kernel.org>
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

v2: Make the check only if the extent type is regular or prealloc,
    since for inline extents disk_bytenr has no meaning.

 fs/btrfs/tree-log.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index eeffff8..30423ce 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -673,6 +673,10 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 		unsigned long dest_offset;
 		struct btrfs_key ins;
 
+		if (btrfs_file_extent_disk_bytenr(eb, item) == 0 &&
+		    btrfs_fs_incompat(fs_info, NO_HOLES))
+			goto update_inode;
+
 		ret = btrfs_insert_empty_item(trans, root, path, key,
 					      sizeof(*item));
 		if (ret)
@@ -825,6 +829,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	}
 
 	inode_add_bytes(inode, nbytes);
+update_inode:
 	ret = btrfs_update_inode(trans, root, inode);
 out:
 	if (inode)
-- 
2.7.0.rc3

