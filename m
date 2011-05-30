From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 2/9] btrfs-convert: fix typo: 'all inode' -> 'all inodes'
Date: Tue, 31 May 2011 00:19:01 +0300
Message-ID: <1306790348-9553-3-git-send-email-slyfox@gentoo.org>
References: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 convert.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/convert.c b/convert.c
index fbcf4a3..291dc27 100644
--- a/convert.c
+++ b/convert.c
@@ -1120,7 +1120,7 @@ fail:
 	return ret;
 }
 /*
- * scan ext2's inode bitmap and copy all used inode.
+ * scan ext2's inode bitmap and copy all used inodes.
  */
 static int copy_inodes(struct btrfs_root *root, ext2_filsys ext2_fs,
 		       int datacsum, int packing, int noxattr)
-- 
1.7.3.4

