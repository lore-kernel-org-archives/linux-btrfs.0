Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:60671 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbcEKS3x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 14:29:53 -0400
Date: Wed, 11 May 2016 20:29:47 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        Eric Biggers <ebiggers3@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH for 4.6] btrfs: disable a spurious WARN_ON in
 btrfs_destroy_inode.
Message-ID: <20160511182947.GB6423@angband.pl>
References: <20160510235758.3ow2wdumtisauw4n@floor.thefacebook.com>
 <20160511182514.GA6423@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160511182514.GA6423@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This happens a lot on real-world loads.  The issue is apparently benign,
as unsaved pending checksums are moot when the ship^Winode is going down
anyway.  Thus, no need to cause panic in users.

I've retained the warning in CONFIG_BTRFS_ASSERT builds, as this shouldn't
happen.  I've replaced the no longer helpful register+stack dump with a
printk that mentions the device affected.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 fs/btrfs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2aaba58..ed78104 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9258,7 +9258,10 @@ void btrfs_destroy_inode(struct inode *inode)
 	WARN_ON(BTRFS_I(inode)->outstanding_extents);
 	WARN_ON(BTRFS_I(inode)->reserved_extents);
 	WARN_ON(BTRFS_I(inode)->delalloc_bytes);
-	WARN_ON(BTRFS_I(inode)->csum_bytes);
+#ifdef CONFIG_BTRFS_ASSERT
+	if (BTRFS_I(inode)->csum_bytes)
+		btrfs_info(root->fs_info, "btrfs_destroy_inode: leftover csum_bytes");
+#endif
 	WARN_ON(BTRFS_I(inode)->defrag_bytes);
 
 	/*
--
2.8.1
