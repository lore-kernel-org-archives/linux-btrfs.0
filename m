From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: [PATCH] btrfsck: CRC error case handling.
Date: Fri, 02 Oct 2009 14:52:49 +0900
Message-ID: <4AC59531.40102@jp.fujitsu.com>
References: <4AC59118.6030707@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AC59118.6030707@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


In tree block CRC error case, btrfsck fails in segmentation fault.
In CRC error case, read_tree_block returns NULL as extent_buffer
like other(ex. ENOMEM) case, and btrfsck refers it without check.

If CRC error tree block is tree root, btrfsck aborts in previous
stage.
Like this, as for CRC error handling, BUG() is often used such as
in find_and_setup_root(disk-io.c), but CRC error is not a bug, so,
btrfsck should not abort but report, I think.

Because read_tree_block puts error message in CRC error case,
patch logic is simply return to caller with error.


Signed-off-by: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
---
 btrfsck.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index ecc7b19..cc00e28 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -2504,6 +2504,9 @@ static int run_next_block(struct btrfs_root *root,

 	/* fixme, get the real parent transid */
 	buf = read_tree_block(root, bytenr, size, 0);
+	if (buf == NULL)
+		return -1;
+
 	nritems = btrfs_header_nritems(buf);

 	ret = btrfs_lookup_extent_info(NULL, root, bytenr, size, NULL, &flags);
@@ -2785,6 +2788,8 @@ static int check_extents(struct btrfs_root *root)
 					      btrfs_root_bytenr(&ri),
 					      btrfs_level_size(root,
 					       btrfs_root_level(&ri)), 0);
+			if (buf == NULL)
+				return 1;
 			add_root_to_pending(buf, bits, bits_nr, &extent_cache,
 					    &pending, &seen, &reada, &nodes,
 					    &found_key);
@@ -2796,6 +2801,8 @@ static int check_extents(struct btrfs_root *root)
 	while(1) {
 		ret = run_next_block(root, bits, bits_nr, &last, &pending,
 				     &seen, &reada, &nodes, &extent_cache);
+		if (ret < 0)
+			return 1;
 		if (ret != 0)
 			break;
 	}
-- 
1.6.2.1



