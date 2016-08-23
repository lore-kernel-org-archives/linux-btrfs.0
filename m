Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59414 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753768AbcHWKnp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4F142AD9E
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:26 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 13/13] btrfs-progs: mkfs: clean up make_image
Date: Tue, 23 Aug 2016 12:25:17 +0200
Message-Id: <1471947917-5324-14-git-send-email-dsterba@suse.com>
In-Reply-To: <1471947917-5324-1-git-send-email-dsterba@suse.com>
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The exact errors are printed, the removed message does not seem to be
necessary. Return proper errors.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 mkfs.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index ef0b099a58d7..2aa1d5d31523 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1042,16 +1042,14 @@ static int make_image(char *source_dir, struct btrfs_root *root, int out_fd)
 {
 	int ret;
 	struct btrfs_trans_handle *trans;
-
 	struct stat root_st;
-
 	struct directory_name_entry dir_head;
-
 	struct directory_name_entry *dir_entry = NULL;
 
 	ret = lstat(source_dir, &root_st);
 	if (ret) {
 		error("unable to lstat %s: %s", source_dir, strerror(errno));
+		ret = -errno;
 		goto out;
 	}
 
@@ -1080,8 +1078,7 @@ static int make_image(char *source_dir, struct btrfs_root *root, int out_fd)
 		free(dir_entry);
 	}
 out:
-	fprintf(stderr, "Making image is aborted.\n");
-	return -1;
+	return ret;
 }
 
 /*
-- 
2.7.1

