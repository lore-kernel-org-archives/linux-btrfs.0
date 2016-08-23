Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59405 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756367AbcHWKno (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:44 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 12EC2AD97
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:26 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 11/13] btrfs-progs: mkfs: handle and report transaction commit failures
Date: Tue, 23 Aug 2016 12:25:15 +0200
Message-Id: <1471947917-5324-12-git-send-email-dsterba@suse.com>
In-Reply-To: <1471947917-5324-1-git-send-email-dsterba@suse.com>
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 mkfs.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index c28a8bb7e983..f063323903dc 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1063,7 +1063,11 @@ static int make_image(char *source_dir, struct btrfs_root *root, int out_fd)
 		error("unable to traverse directory %s: %d", source_dir, ret);
 		goto fail;
 	}
-	btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root);
+	if (ret) {
+		error("transaction commit failed: %d", ret);
+		goto out;
+	}
 
 	if (verbose)
 		printf("Making image is completed.\n");
@@ -1784,7 +1788,11 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root);
+	if (ret) {
+		error("unable to commit transaction: %d", ret);
+		goto out;
+	}
 
 	trans = btrfs_start_transaction(root, 1);
 	if (!trans) {
@@ -1858,7 +1866,11 @@ int main(int argc, char **argv)
 		goto out;
 	}
 
-	btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root);
+	if (ret) {
+		error("unable to commit transaction: %d", ret);
+		goto out;
+	}
 
 	if (source_dir_set) {
 		trans = btrfs_start_transaction(root, 1);
-- 
2.7.1

