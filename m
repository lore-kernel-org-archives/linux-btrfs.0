Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab2FGXEH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jun 2012 19:04:07 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Cc: chris.mason@oracle.com, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 3/3] [PATCH] btrfs-progs: mkfs support for extended inode refs
Date: Thu,  7 Jun 2012 16:00:56 -0700
Message-Id: <1339110056-21484-4-git-send-email-mfasheh@suse.de>
In-Reply-To: <1339110056-21484-1-git-send-email-mfasheh@suse.de>
References: <1339110056-21484-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Mark Fasheh <mfasheh@suse.com>

This patch turns on the BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF superblock flag
when creating a new file system in mkfs, enabling extended inode refs.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 mkfs.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index c531ef2..2bf4ee9 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1224,6 +1224,8 @@ int main(int ac, char **av)
 	u64 size_of_data = 0;
 	u64 source_dir_size = 0;
 	char *pretty_buf;
+	struct btrfs_super_block *super;
+	u64 flags;
 
 	while(1) {
 		int c;
@@ -1426,13 +1428,14 @@ raid_groups:
 	ret = create_data_reloc_tree(trans, root);
 	BUG_ON(ret);
 
-	if (mixed) {
-		struct btrfs_super_block *super = &root->fs_info->super_copy;
-		u64 flags = btrfs_super_incompat_flags(super);
+	super = &root->fs_info->super_copy;
+	flags = btrfs_super_incompat_flags(super);
+	flags |= BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF;
 
+	if (mixed)
 		flags |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
-		btrfs_set_super_incompat_flags(super, flags);
-	}
+
+	btrfs_set_super_incompat_flags(super, flags);
 
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
 	    "sectorsize %u size %s\n",
-- 
1.7.7

