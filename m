Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:40736 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab1EJTzO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2011 15:55:14 -0400
From: y@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 2/3] btrfs: typo: 'btrfS' -> 'btrfs'
Date: Tue, 10 May 2011 22:57:28 +0300
Message-Id: <1305057449-12075-3-git-send-email-y>
In-Reply-To: <1305057449-12075-1-git-send-email-y>
References: <1305057449-12075-1-git-send-email-y>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 fs/btrfs/dir-item.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index c62f02f..dec9348 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -452,7 +452,7 @@ int verify_dir_item(struct btrfs_root *root,
 		namelen = XATTR_NAME_MAX;
 
 	if (btrfs_dir_name_len(leaf, dir_item) > namelen) {
-		printk(KERN_CRIT "btrfS: invalid dir item name len: %u\n",
+		printk(KERN_CRIT "btrfs: invalid dir item name len: %u\n",
 		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
 		return 1;
 	}
-- 
1.7.3.4

