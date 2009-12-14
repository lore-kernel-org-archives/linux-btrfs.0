From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make subvol=0 mount the original default root
Date: Mon, 14 Dec 2009 14:18:38 -0500
Message-ID: <20091214191838.GC2165@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since theres not a good way to make sure the user sees the original default root
tree id, and not to mention it's 5 so is way different than any other volume,
just make subvol=0 mount the original default root.  This makes it a bit easier
for users to handle in the long run.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/super.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index bcbdc1b..ccc0380 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -305,9 +305,15 @@ static int btrfs_parse_early_options(const char *options, fmode_t flags,
 		switch (token) {
 		case Opt_subvol:
 			intarg = 0;
-			match_int(&args[0], &intarg);
-			if (intarg)
-				*subvol_objectid = intarg;
+			error = match_int(&args[0], &intarg);
+			if (!error) {
+				/* we want the original fs_tree */
+				if (!intarg)
+					*subvol_objectid =
+						BTRFS_FS_TREE_OBJECTID;
+				else
+					*subvol_objectid = intarg;
+			}
 			break;
 		case Opt_device:
 			error = btrfs_scan_one_device(match_strdup(&args[0]),
-- 
1.5.4.3

