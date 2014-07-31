Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaGaMVg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 08:21:36 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3D437AC3D
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 12:21:35 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: mkfs: remove experimental tag
Date: Thu, 31 Jul 2014 14:21:34 +0200
Message-Id: <1406809294-24702-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make it consistent with kernel status and documentation.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 mkfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 16e92221a547..538b6e6837b2 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1439,8 +1439,8 @@ int main(int ac, char **av)
 	}
 
 	/* if we are here that means all devs are good to btrfsify */
-	printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
-	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
+	printf("%s\n", BTRFS_BUILD_VERSION);
+	printf("See http://btrfs.wiki.kernel.org for more\n\n");
 
 	dev_cnt--;
 
@@ -1597,7 +1597,6 @@ raid_groups:
 	    label, first_file, nodesize, leafsize, sectorsize,
 	    pretty_size(btrfs_super_total_bytes(root->fs_info->super_copy)));
 
-	printf("%s\n", BTRFS_BUILD_VERSION);
 	btrfs_commit_transaction(trans, root);
 
 	if (source_dir_set) {
-- 
1.9.0

