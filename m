Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36671 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753908AbdK2JQU (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 29 Nov 2017 04:16:20 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 5/9] btrfs-progs: mkfs: Separate shrink from rootdir
Date: Wed, 29 Nov 2017 17:16:00 +0800
Message-Id: <20171129091604.2194-6-wqu@suse.com>
In-Reply-To: <20171129091604.2194-1-wqu@suse.com>
References: <20171129091604.2194-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make --shrink a separate option for --rootdir, and make it default to
off.
So this will cause less confusion.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/mkfs.btrfs.asciidoc | 11 +++++++++++
 mkfs/main.c                       | 26 ++++++++++++++++++++------
 mkfs/rootdir.c                    | 21 ++++++++++++++++++++-
 mkfs/rootdir.h                    |  3 ++-
 4 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 62f5a5bebaee..ded798216a5b 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -106,6 +106,17 @@ Please see the mount option 'discard' for that in `btrfs`(5).
 *-r|--rootdir <rootdir>*::
 Populate the toplevel subvolume with files from 'rootdir'.  This does not
 require root permissions and does not mount the filesystem.
++
+NOTE: This option may enlarge the image or file to ensure it's large enough to
+contain the files from 'rootdir'.
+
+*--shrink*:
+Shrink the filesystem to its minimal size, only works with *-r|--rootdir*
+option.
++
+NOTE: If the destination is regular file, this option will also reduce the
+file size. Or it will only reduce the filesystem available space.
+Extra space will not be usable unless resized using 'btrfs filesystem resize'.
 
 *-O|--features <feature1>[,<feature2>...]*::
 A list of filesystem features turned on at mkfs time. Not all features are
diff --git a/mkfs/main.c b/mkfs/main.c
index eb3e5bb1f92e..64cf03289188 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -746,9 +746,11 @@ int main(int argc, char **argv)
 	char *subvol_name = NULL;
 	int subvol_name_set = 0;
 	char *source_dir = NULL;
-	int source_dir_set = 0;
+	bool source_dir_set = false;
+	bool shrink_rootdir = false;
 	u64 source_dir_size = 0;
 	u64 min_dev_size;
+	u64 shrink_size;
 	int dev_cnt = 0;
 	int saved_optind;
 	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
@@ -758,6 +760,7 @@ int main(int argc, char **argv)
 
 	while(1) {
 		int c;
+		enum { GETOPT_VAL_SHRINK = 257 };
 		static const struct option long_options[] = {
 			{ "alloc-start", required_argument, NULL, 'A'},
 			{ "byte-count", required_argument, NULL, 'b' },
@@ -776,6 +779,7 @@ int main(int argc, char **argv)
 			{ "features", required_argument, NULL, 'O' },
 			{ "uuid", required_argument, NULL, 'U' },
 			{ "quiet", 0, NULL, 'q' },
+			{ "shrink", no_argument, NULL, GETOPT_VAL_SHRINK },
 			{ "help", no_argument, NULL, GETOPT_VAL_HELP },
 			{ NULL, 0, NULL, 0}
 		};
@@ -847,7 +851,7 @@ int main(int argc, char **argv)
 				break;
 			case 'r':
 				source_dir = optarg;
-				source_dir_set = 1;
+				source_dir_set = true;
 				break;
 			case 'U':
 				strncpy(fs_uuid, optarg,
@@ -859,6 +863,9 @@ int main(int argc, char **argv)
 			case 'q':
 				verbose = 0;
 				break;
+			case GETOPT_VAL_SHRINK:
+				shrink_rootdir = true;
+				break;
 			case GETOPT_VAL_HELP:
 			default:
 				print_usage(c != GETOPT_VAL_HELP);
@@ -886,6 +893,10 @@ int main(int argc, char **argv)
 		error("the option -r is limited to a single device");
 		goto error;
 	}
+	if (shrink_rootdir && !source_dir_set) {
+		error("the option --shrink can only be paired with -r");
+		goto error;
+	}
 
 	if (*fs_uuid) {
 		uuid_t dummy_uuid;
@@ -1256,10 +1267,13 @@ raid_groups:
 				goto out;
 			}
 		}
-		ret = btrfs_mkfs_shrink_fs(fs_info, NULL);
-		if (ret < 0) {
-			error("error while shrinking filesystem: %d", ret);
-			goto out;
+		if (shrink_rootdir) {
+			ret = btrfs_mkfs_shrink_fs(fs_info, &shrink_size,
+						   shrink_rootdir);
+			if (ret < 0) {
+				error("error while shrinking filesystem: %d", ret);
+				goto out;
+			}
 		}
 	}
 
diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 271167fe0c02..b91900834316 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -899,11 +899,13 @@ err:
 	return ret;
 }
 
-int btrfs_mkfs_shrink_fs(struct btrfs_fs_info *fs_info, u64 *new_size_ret)
+int btrfs_mkfs_shrink_fs(struct btrfs_fs_info *fs_info, u64 *new_size_ret,
+			 bool shrink_file_size)
 {
 	u64 new_size;
 	struct btrfs_device *device;
 	struct list_head *cur;
+	struct stat64 file_stat;
 	int nr_devs = 0;
 	int ret;
 
@@ -931,5 +933,22 @@ int btrfs_mkfs_shrink_fs(struct btrfs_fs_info *fs_info, u64 *new_size_ret)
 		return ret;
 	if (new_size_ret)
 		*new_size_ret = new_size;
+
+	if (shrink_file_size) {
+		ret = fstat64(device->fd, &file_stat);
+		if (ret < 0) {
+			error("failed to stat devid %llu: %s", device->devid,
+				strerror(errno));
+			return ret;
+		}
+		if (!S_ISREG(file_stat.st_mode))
+			return ret;
+		ret = ftruncate64(device->fd, new_size);
+		if (ret < 0) {
+			error("failed to truncate device file of devid %llu: %s",
+				device->devid, strerror(errno));
+			return ret;
+		}
+	}
 	return ret;
 }
diff --git a/mkfs/rootdir.h b/mkfs/rootdir.h
index 91bebc507f02..7ab53c292c9d 100644
--- a/mkfs/rootdir.h
+++ b/mkfs/rootdir.h
@@ -32,5 +32,6 @@ int btrfs_mkfs_fill_dir(const char *source_dir, struct btrfs_root *root,
 			bool verbose);
 u64 btrfs_mkfs_size_dir(const char *dir_name, u32 sectorsize, u64 min_dev_size,
 			u64 meta_profile, u64 data_profile);
-int btrfs_mkfs_shrink_fs(struct btrfs_fs_info *fs_info, u64 *new_size_ret);
+int btrfs_mkfs_shrink_fs(struct btrfs_fs_info *fs_info, u64 *new_size_ret,
+			 bool shrink_file_size);
 #endif
-- 
2.15.0

