Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932737AbcA0OCU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 09:02:20 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id BE04FAC2E
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 14:02:17 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: add free space tree to lockdep classes
Date: Wed, 27 Jan 2016 15:02:09 +0100
Message-Id: <6b20e0ad2e39b77b7d4a48cc06c4de39768c7bb8.1453902967.git.dsterba@suse.com>
In-Reply-To: <cover.1453902967.git.dsterba@suse.com>
References: <cover.1453902967.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c67c129fe99a..ca78bf2ed287 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -176,6 +176,7 @@ static struct btrfs_lockdep_keyset {
 	{ .id = BTRFS_TREE_RELOC_OBJECTID,	.name_stem = "treloc"	},
 	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	.name_stem = "dreloc"	},
 	{ .id = BTRFS_UUID_TREE_OBJECTID,	.name_stem = "uuid"	},
+	{ .id = BTRFS_FREE_SPACE_TREE_OBJECTID,	.name_stem = "free-space" },
 	{ .id = 0,				.name_stem = "tree"	},
 };
 
-- 
2.6.3

