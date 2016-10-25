Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32921 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756446AbcJYOJm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 10:09:42 -0400
Date: Tue, 25 Oct 2016 16:09:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs-progs: fsck: Add support to clear v1 free
 space cache.
Message-ID: <20161025140934.GQ22935@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161013092227.19761-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
In-Reply-To: <20161013092227.19761-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 13, 2016 at 05:22:26PM +0800, Qu Wenruo wrote:
> Kernel clear_cache mount option will only rebuilt free space cache if
> used space of that chunk has changed.
> 
> So it won't ensure any corrupted free space cache get cleared.
> 
> So add a new option "--clear-space-cache v1|v2" to btrfsck, to
> completely wipe out free space cache.
> So kernel won't complain again.
> 
> Reported-by: Ivan P <chrnosphered@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied with the attached diff, use it as a review feedback.

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fsc.diff"

diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
index ef1e464ef05f..5ef414ebab24 100644
--- a/Documentation/btrfs-check.asciidoc
+++ b/Documentation/btrfs-check.asciidoc
@@ -79,12 +79,13 @@ This can be used to use a different starting point if some of the primary
 superblock is damaged.
 
 --clear-space-cache v1|v2::
-completely wipe out all free space cache.
-Only v1(file based) free space cache is supported yet.
+completely wipe all free space cache of given type
+
+NOTE: Only v1 free space cache supported is implemented.
 +
-NOTE: Kernel mount option 'clear_cache' is only designed to rebuild free space cache
-which is modified during the lifetime of that mount option.
-It doesn't rebuild all free space cache, nor clear them out.
+Kernel mount option 'clear_cache' is only designed to rebuild free space cache
+which is modified during the lifetime of that mount option.  It doesn't rebuild
+all free space cache, nor clear them out.
 
 
 DANGEROUS OPTIONS
diff --git a/cmds-check.c b/cmds-check.c
index d55c87591ec6..a017b5712acf 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12650,9 +12650,8 @@ const char * const cmd_check_usage[] = {
 	"-r|--tree-root <bytenr>     use the given bytenr for the tree root",
 	"--chunk-root <bytenr>       use the given bytenr for the chunk tree root",
 	"-p|--progress               indicate progress",
-	"--clear-space-cache v1|v2   clear space cache for v1(file based) or ",
-	"                            v2(tree based).",
-	"                            Only support v1 yet",
+	"--clear-space-cache v1|v2   clear space cache for v1 or v2",
+	"                            NOTE: v1 support implemented",
 	NULL
 };
 
@@ -12775,8 +12774,10 @@ int cmd_check(int argc, char **argv)
 				}
 				break;
 			case GETOPT_VAL_CLEAR_SPACE_CACHE:
-				if (strcmp(optarg, "v1")) {
-					error("only support to clear 'v1' space cache");
+				if (strcmp(optarg, "v1") != 0) {
+					error(
+			"only v1 support implmented, unrecognized value %s",
+			optarg);
 					exit(1);
 				}
 				clear_space_cache = 1;
@@ -12839,7 +12840,8 @@ int cmd_check(int argc, char **argv)
 	if (clear_space_cache) {
 		if (btrfs_fs_compat_ro(info,
 				BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE)) {
-			error("doesn't support free space cache v2(tree based) yet");
+			error(
+			"free space cache v2 detected, clearing not implemented");
 			ret = 1;
 			goto close_out;
 		}
diff --git a/free-space-cache.c b/free-space-cache.c
index 88a1013220d7..286b185ee2ee 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -920,8 +920,8 @@ int btrfs_clear_free_space_cache(struct btrfs_fs_info *fs_info,
 	/* Delete the free space header, as we have the ino to continue */
 	ret = btrfs_del_item(trans, tree_root, &path);
 	if (ret < 0) {
-		error("failed to remove free space header for block group %llu",
-		      bg->key.objectid);
+		error("failed to remove free space header for block group %llu: %d",
+		      bg->key.objectid, ret);
 		goto out;
 	}
 	btrfs_release_path(&path);
@@ -932,8 +932,8 @@ int btrfs_clear_free_space_cache(struct btrfs_fs_info *fs_info,
 	key.offset = (u64)-1;
 	ret = btrfs_search_slot(trans, tree_root, &key, &path, -1, 1);
 	if (ret < 0) {
-		error("failed to locate free space cache extent for block group %llu",
-		      bg->key.objectid);
+		error("failed to locate free space cache extent for block group %llu: %d",
+		      bg->key.objectid, ret);
 		goto out;
 	}
 	while (1) {
@@ -941,7 +941,6 @@ int btrfs_clear_free_space_cache(struct btrfs_fs_info *fs_info,
 		u64 disk_bytenr;
 		u64 disk_num_bytes;
 
-
 		ret = btrfs_previous_item(tree_root, &path, ino,
 					  BTRFS_EXTENT_DATA_KEY);
 		if (ret > 0) {
@@ -949,8 +948,9 @@ int btrfs_clear_free_space_cache(struct btrfs_fs_info *fs_info,
 			break;
 		}
 		if (ret < 0) {
-			error("failed to locate free space cache extent for block group %llu",
-			      bg->key.objectid);
+			error(
+	"failed to locate free space cache extent for block group %llu: %d",
+				bg->key.objectid, ret);
 			goto out;
 		}
 		node = path.nodes[0];
@@ -964,14 +964,15 @@ int btrfs_clear_free_space_cache(struct btrfs_fs_info *fs_info,
 					disk_num_bytes, 0, tree_root->objectid,
 					ino, key.offset);
 		if (ret < 0) {
-			error("failed to remove backref for disk bytenr %llu",
-			      disk_bytenr);
+			error("failed to remove backref for disk bytenr %llu: %d",
+			      disk_bytenr, ret);
 			goto out;
 		}
 		ret = btrfs_del_item(trans, tree_root, &path);
 		if (ret < 0) {
-			error("failed to remove free space extent data for ino %llu offset %llu",
-			      ino, key.offset);
+			error(
+	"failed to remove free space extent data for ino %llu offset %llu: %d",
+			      ino, key.offset, ret);
 			goto out;
 		}
 	}
@@ -986,14 +987,16 @@ int btrfs_clear_free_space_cache(struct btrfs_fs_info *fs_info,
 	if (ret > 0)
 		warning("free space inode %llu not found, ignore", ino);
 	if (ret < 0) {
-		error("failed to locate free space cache inode %llu for block group %llu",
-		      ino, bg->key.objectid);
+		error(
+	"failed to locate free space cache inode %llu for block group %llu: %d",
+		      ino, bg->key.objectid, ret);
 		goto out;
 	}
 	ret = btrfs_del_item(trans, tree_root, &path);
 	if (ret < 0) {
-		error("failed to delete free space cache inode %llu for block group %llu",
-		      ino, bg->key.objectid);
+		error(
+	"failed to delete free space cache inode %llu for block group %llu: %d",
+		      ino, bg->key.objectid, ret);
 	}
 out:
 	btrfs_release_path(&path);

--UugvWAfsgieZRqgk--
