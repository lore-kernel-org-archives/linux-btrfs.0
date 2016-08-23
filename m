Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753986AbcHWKnn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:43 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ADE3DAD8F
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:25 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 07/13] btrfs-progs: mkfs: improve error handling in main()
Date: Tue, 23 Aug 2016 12:25:11 +0200
Message-Id: <1471947917-5324-8-git-send-email-dsterba@suse.com>
In-Reply-To: <1471947917-5324-1-git-send-email-dsterba@suse.com>
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 mkfs.c | 49 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index b2baf47bb595..94b349f157ca 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1805,7 +1805,10 @@ int main(int argc, char **argv)
 
 		ret = btrfs_add_to_fsid(trans, root, fd, file, dev_block_count,
 					sectorsize, sectorsize, sectorsize);
-		BUG_ON(ret);
+		if (ret) {
+			error("unable to add %s to filesystem: %d", file, ret);
+			goto out;
+		}
 		if (verbose >= 2) {
 			struct btrfs_device *device;
 
@@ -1820,11 +1823,17 @@ int main(int argc, char **argv)
 	if (!source_dir_set) {
 		ret = create_raid_groups(trans, root, data_profile,
 				 metadata_profile, mixed, &allocation);
-		BUG_ON(ret);
+		if (ret) {
+			error("unable to create raid groups: %d", ret);
+			goto out;
+		}
 	}
 
 	ret = create_data_reloc_tree(trans, root);
-	BUG_ON(ret);
+	if (ret) {
+		error("unable to create data reloc tree: %d", ret);
+		goto out;
+	}
 
 	btrfs_commit_transaction(trans, root);
 
@@ -1833,11 +1842,21 @@ int main(int argc, char **argv)
 		ret = create_chunks(trans, root,
 				    num_of_meta_chunks, size_of_data,
 				    &allocation);
-		BUG_ON(ret);
-		btrfs_commit_transaction(trans, root);
+		if (ret) {
+			error("unable to create chunks: %d", ret);
+			goto out;
+		}
+		ret = btrfs_commit_transaction(trans, root);
+		if (ret) {
+			error("transaction commit failed: %d", ret);
+			goto out;
+		}
 
 		ret = make_image(source_dir, root, fd);
-		BUG_ON(ret);
+		if (ret) {
+			error("error wihle filling filesystem: %d", ret);
+			goto out;
+		}
 	}
 	ret = cleanup_temp_chunks(root->fs_info, &allocation, data_profile,
 				  metadata_profile, metadata_profile);
@@ -1886,17 +1905,19 @@ int main(int argc, char **argv)
 	root->fs_info->finalize_on_close = 1;
 out:
 	ret = close_ctree(root);
-	BUG_ON(ret);
 
-	optind = saved_optind;
-	dev_cnt = argc - optind;
-	while (dev_cnt-- > 0) {
-		file = argv[optind++];
-		if (is_block_device(file) == 1)
-			btrfs_register_one_device(file);
+	if (!ret) {
+		optind = saved_optind;
+		dev_cnt = argc - optind;
+		while (dev_cnt-- > 0) {
+			file = argv[optind++];
+			if (is_block_device(file) == 1)
+				btrfs_register_one_device(file);
+		}
 	}
 
 	btrfs_close_all_devices();
 	free(label);
-	return 0;
+
+	return !!ret;
 }
-- 
2.7.1

