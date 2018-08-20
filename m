Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34670 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726907AbeHTQns (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 12:43:48 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6CBBCAEE2
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Aug 2018 13:28:08 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfstune: Rename change_header_uuid to change_buffer_header_uuid
Date: Mon, 20 Aug 2018 16:28:05 +0300
Message-Id: <1534771685-4924-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1534771685-4924-1-git-send-email-nborisov@suse.com>
References: <1534771685-4924-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rename the function so its name falls in line with the rest of btrfs
nomenclature. So when we change the uuid of the header it's in fact
of the buffer header. Also remove the root argument since it's used
solely to take a reference to fs_info which can be done via the
mandatory eb argument. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfstune.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 723317a00f3a..3745a00c46ae 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -91,9 +91,9 @@ static int set_super_incompat_flags(struct btrfs_root *root, u64 flags)
 	return ret;
 }
 
-static int change_header_uuid(struct btrfs_root *root, struct extent_buffer *eb)
+static int change_buffer_header_uuid(struct extent_buffer *eb)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	int same_fsid = 1;
 	int same_chunk_tree_uuid = 1;
 	int ret;
@@ -157,7 +157,7 @@ static int change_extents_uuid(struct btrfs_fs_info *fs_info)
 			ret = PTR_ERR(eb);
 			goto out;
 		}
-		ret = change_header_uuid(root, eb);
+		ret = change_buffer_header_uuid(eb);
 		free_extent_buffer(eb);
 		if (ret < 0) {
 			error("failed to change uuid of tree block: %llu",
-- 
2.7.4
