From: y@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: typo: 'btrfS' -> 'btrfs'
Date: Tue, 10 May 2011 22:57:28 +0300
Message-ID: <5284.11026248268$1305057325@news.gmane.org>
References: <1305057449-12075-1-git-send-email-y>
Cc: Chris Mason <chris.mason@oracle.com>,
	Sergei Trofimovich <slyfox@gentoo.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305057449-12075-1-git-send-email-y>
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

