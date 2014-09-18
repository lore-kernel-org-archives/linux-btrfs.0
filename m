Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65233 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932154AbaIRPAW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 11:00:22 -0400
Message-ID: <541AF37D.5050505@fb.com>
Date: Thu, 18 Sep 2014 11:00:13 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Sam Thursfield <sam.thursfield@codethink.co.uk>,
        <johannes.hirte@datenkhaos.de>
Subject: [PATCH] Revert "Btrfs: device_list_add() should not update list when
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Johannes and Sam, could you please confirm this patch fixes your mount
regression for now?  Anand, please make sure I kept the generation check
properly.

This reverts commit b96de000bc8bc9688b3a2abea4332bd57648a49f.

This commit is triggering failures to mount by subvolume id in some
configurations.  The main problem is how many different ways this
scanning function is used, both for scanning while mounted and
unmounted.  A proper cleanup is too big for late rcs.

For now, just revert the commit and we'll put a better fix into a later
merge window.

Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/volumes.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 340a92d..2c2d6d1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -529,12 +529,12 @@ static noinline int device_list_add(const char *path,
 		 */
 
 		/*
-		 * As of now don't allow update to btrfs_fs_device through
-		 * the btrfs dev scan cli, after FS has been mounted.
+		 * For now, we do allow update to btrfs_fs_device through the
+		 * btrfs dev scan cli after FS has been mounted.  We're still
+		 * tracking a problem where systems fail mount by subvolume id
+		 * when we reject replacement on a mounted FS.
 		 */
-		if (fs_devices->opened) {
-			return -EBUSY;
-		} else {
+		if (!fs_devices->opened && found_transid < device->generation) {
 			/*
 			 * That is if the FS is _not_ mounted and if you
 			 * are here, that means there is more than one
@@ -542,8 +542,7 @@ static noinline int device_list_add(const char *path,
 			 * with larger generation number or the last-in if
 			 * generation are equal.
 			 */
-			if (found_transid < device->generation)
-				return -EEXIST;
+			return -EEXIST;
 		}
 
 		name = rcu_string_strdup(path, GFP_NOFS);
-- 
1.8.1

