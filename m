Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933085Ab3ICQ3B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 12:29:01 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CF32CA51B7
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Sep 2013 18:28:59 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: add lockdep and tracing annotations for uuid tree
Date: Tue,  3 Sep 2013 18:28:57 +0200
Message-Id: <1378225737-1524-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c           |    1 +
 include/trace/events/btrfs.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4cbb00a..72cf08b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -157,6 +157,7 @@ static struct btrfs_lockdep_keyset {
 	{ .id = BTRFS_TREE_LOG_OBJECTID,	.name_stem = "log"	},
 	{ .id = BTRFS_TREE_RELOC_OBJECTID,	.name_stem = "treloc"	},
 	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	.name_stem = "dreloc"	},
+	{ .id = BTRFS_UUID_TREE_OBJECTID,	.name_stem = "uuid"	},
 	{ .id = 0,				.name_stem = "tree"	},
 };
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 45702c3..f18b3b7 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -42,6 +42,7 @@ struct extent_buffer;
 		{ BTRFS_TREE_LOG_OBJECTID,	"TREE_LOG"	},	\
 		{ BTRFS_QUOTA_TREE_OBJECTID,	"QUOTA_TREE"	},	\
 		{ BTRFS_TREE_RELOC_OBJECTID,	"TREE_RELOC"	},	\
+		{ BTRFS_UUID_TREE_OBJECTID,	"UUID_RELOC"	},	\
 		{ BTRFS_DATA_RELOC_TREE_OBJECTID, "DATA_RELOC_TREE" })
 
 #define show_root_type(obj)						\
-- 
1.7.9

