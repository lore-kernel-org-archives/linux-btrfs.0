Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760040Ab3ICML2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 08:11:28 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: [PATCH 3/3] btrfs: set FIEMAP_EXTENT_DATA_COMPRESSED for compressed extents
Date: Tue,  3 Sep 2013 14:11:06 +0200
Message-Id: <b52a181a78da239c4e0f45fedcb2f6627794ad5e.1378209377.git.dsterba@suse.cz>
In-Reply-To: <cover.1378209377.git.dsterba@suse.cz>
References: <cover.1378209377.git.dsterba@suse.cz>
In-Reply-To: <cover.1378209377.git.dsterba@suse.cz>
References: <cover.1378209377.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Set the EXTENT_DATA_COMPRESSED flag together with EXTENT_ENCODED as
defined by fiemap spec.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fe443fe..bb2e346 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4095,8 +4095,10 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		} else {
 			disko = em->block_start + offset_in_extent;
 		}
-		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
+		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
 			flags |= FIEMAP_EXTENT_ENCODED;
+			flags |= FIEMAP_EXTENT_DATA_COMPRESSED;
+		}
 
 		free_extent_map(em);
 		em = NULL;
-- 
1.7.9

