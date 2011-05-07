From: slyich@gmail.com
Subject: [PATCH 1/4] btrfs: typo: 'btrfS' -> 'btrfs'
Date: Sun,  8 May 2011 00:29:42 +0300
Message-ID: <1304803784-23756-1-git-send-email-slyfox@gentoo.org>
Cc: Chris Mason <chris.mason@oracle.com>,
	Sergei Trofimovich <st@anti-virus.by>,
	Sergei Trofimovich <slyfox@gentoo.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <st@anti-virus.by>

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

