Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758699Ab3D3R3d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 13:29:33 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 16BD8A5211
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 19:29:32 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: annotate quota tree for lockdep
Date: Tue, 30 Apr 2013 19:29:29 +0200
Message-Id: <1367342969-19155-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quota tree has been missing from lockdep annotations, though no warning
has been seen in the wild.

There's currently one entry that does not belong there,
BTRFS_ORPHAN_OBJECTID.  No such tree exists, it's probably a copy &
paste mistake, the id is defined among tree ids.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h   |    6 +++---
 fs/btrfs/disk-io.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 63c328a..2720d55 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -88,12 +88,12 @@ struct btrfs_ordered_sum;
 /* holds checksums of all the data extents */
 #define BTRFS_CSUM_TREE_OBJECTID 7ULL
 
-/* for storing balance parameters in the root tree */
-#define BTRFS_BALANCE_OBJECTID -4ULL
-
 /* holds quota configuration and tracking */
 #define BTRFS_QUOTA_TREE_OBJECTID 8ULL
 
+/* for storing balance parameters in the root tree */
+#define BTRFS_BALANCE_OBJECTID -4ULL
+
 /* orhpan objectid for tracking unlinked/truncated files */
 #define BTRFS_ORPHAN_OBJECTID -5ULL
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8da11a1..a3f297f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -152,7 +152,7 @@ static struct btrfs_lockdep_keyset {
 	{ .id = BTRFS_DEV_TREE_OBJECTID,	.name_stem = "dev"	},
 	{ .id = BTRFS_FS_TREE_OBJECTID,		.name_stem = "fs"	},
 	{ .id = BTRFS_CSUM_TREE_OBJECTID,	.name_stem = "csum"	},
-	{ .id = BTRFS_ORPHAN_OBJECTID,		.name_stem = "orphan"	},
+	{ .id = BTRFS_QUOTA_TREE_OBJECTID,	.name_stem = "quota"	},
 	{ .id = BTRFS_TREE_LOG_OBJECTID,	.name_stem = "log"	},
 	{ .id = BTRFS_TREE_RELOC_OBJECTID,	.name_stem = "treloc"	},
 	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	.name_stem = "dreloc"	},
-- 
1.7.9

