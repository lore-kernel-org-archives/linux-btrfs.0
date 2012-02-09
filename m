From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH v2] Btrfs: return the internal error unchanged if btrfs_get_extent_fiemap()
 call failed for SEEK_DATA/SEEK_HOLE inquiry
Date: Thu, 09 Feb 2012 14:25:50 +0800
Message-ID: <4F3366EE.7070909@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Dave Chinner <david@fromorbit.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Given that ENXIO only means "offset beyond EOF" for either SEEK_DATA or SEEK_HOLE inquiry
in a desired file range, so we should return the internal error unchanged if btrfs_get_extent_fiemap()
call failed, rather than ENXIO.

Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/btrfs/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 97fbe93..6d9e796 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1761,7 +1761,7 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int origin)
 						     start - root->sectorsize,
 						     root->sectorsize, 0);
 		if (IS_ERR(em)) {
-			ret = -ENXIO;
+			ret = PTR_ERR(em);
 			goto out;
 		}
 		last_end = em->start + em->len;
@@ -1773,7 +1773,7 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int origin)
 	while (1) {
 		em = btrfs_get_extent_fiemap(inode, NULL, 0, start, len, 0);
 		if (IS_ERR(em)) {
-			ret = -ENXIO;
+			ret = PTR_ERR(em);
 			break;
 		}
 
-- 
1.7.9
