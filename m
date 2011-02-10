From: Eduardo Silva <eduardo.silva@oracle.com>
Subject: [PATCH] Btrfs-progs new btrfs_error() macro to deprecate
 fprintf(stderr, ...)
Date: Thu, 10 Feb 2011 11:54:55 -0300
Message-ID: <1297349695.28159.21.camel@monotop>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-/rS7Zs4YBfhLIwTs6HoD"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-/rS7Zs4YBfhLIwTs6HoD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi, 

This patch add a new macro called btrfs_error(...) which deprecate the
use of fprintf(stderr, ...)

regards, 

Eduardo

--=-/rS7Zs4YBfhLIwTs6HoD
Content-Disposition: attachment; filename="0001-New-btrfs_error-macro-to-deprecate-fprintf-stderr.patch"
Content-Type: text/x-patch; name="0001-New-btrfs_error-macro-to-deprecate-fprintf-stderr.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From e661fd2bdfc4145a7170ecf5de5fd012af7baf4e Mon Sep 17 00:00:00 2001
From: Eduardo Silva <eduardo.silva@oracle.com>
Date: Thu, 10 Feb 2011 11:50:14 -0300
Subject: [PATCH] New btrfs_error() macro to deprecate fprintf(stderr, ...)

---
 btrfs-image.c       |   10 ++--
 btrfs-list.c        |   14 +++---
 btrfs-map-logical.c |   15 ++++---
 btrfs-show.c        |    6 +-
 btrfs-vol.c         |   22 +++++-----
 btrfs-zero-log.c    |    8 ++--
 btrfs.c             |   13 +++---
 btrfs_cmds.c        |  102 +++++++++++++++++++++++++-------------------------
 btrfsck.c           |   72 +++++++++++++++++-----------------
 btrfsctl.c          |   22 +++++-----
 btrfstune.c         |   10 ++--
 convert.c           |  104 +++++++++++++++++++++++++-------------------------
 debug-tree.c        |    9 ++--
 dir-test.c          |   12 +++---
 disk-io.c           |    6 +-
 extent_io.c         |    3 +-
 mkfs.c              |   58 ++++++++++++++--------------
 print-tree.c        |    3 +-
 quick-test.c        |   10 ++--
 random-test.c       |   12 +++---
 utils.c             |   20 +++++-----
 utils.h             |    3 +
 22 files changed, 271 insertions(+), 263 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index f2bbcc8..6b88b24 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -791,7 +791,7 @@ static int restore_metadump(const char *input, FILE *out, int num_threads)
 		header = &cluster->header;
 		if (le64_to_cpu(header->magic) != HEADER_MAGIC ||
 		    le64_to_cpu(header->bytenr) != bytenr) {
-			fprintf(stderr, "bad header in metadump image\n");
+			btrfs_error("bad header in metadump image\n");
 			return 1;
 		}
 		ret = add_cluster(cluster, &mdrestore, &bytenr);
@@ -809,10 +809,10 @@ static int restore_metadump(const char *input, FILE *out, int num_threads)
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: btrfs-image [options] source target\n");
-	fprintf(stderr, "\t-r      \trestore metadump image\n");
-	fprintf(stderr, "\t-c value\tcompression level (0 ~ 9)\n");
-	fprintf(stderr, "\t-t value\tnumber of threads (1 ~ 32)\n");
+	btrfs_error("usage: btrfs-image [options] source target\n");
+	btrfs_error("\t-r      \trestore metadump image\n");
+	btrfs_error("\t-c value\tcompression level (0 ~ 9)\n");
+	btrfs_error("\t-t value\tnumber of threads (1 ~ 32)\n");
 	exit(1);
 }
 
diff --git a/btrfs-list.c b/btrfs-list.c
index 93766a8..470cf1c 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -276,7 +276,7 @@ static int lookup_ino_path(int fd, struct root_info *ri)
 
 	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
 	if (ret) {
-		fprintf(stderr, "ERROR: Failed to lookup path for root %llu\n",
+		btrfs_error("ERROR: Failed to lookup path for root %llu\n",
 			(unsigned long long)ri->ref_tree);
 		return ret;
 	}
@@ -327,7 +327,7 @@ static u64 find_root_gen(int fd)
 	/* this ioctl fills in ino_args->treeid */
 	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &ino_args);
 	if (ret) {
-		fprintf(stderr, "ERROR: Failed to lookup path for dirid %llu\n",
+		btrfs_error("ERROR: Failed to lookup path for dirid %llu\n",
 			(unsigned long long)BTRFS_FIRST_FREE_OBJECTID);
 		return 0;
 	}
@@ -352,7 +352,7 @@ static u64 find_root_gen(int fd)
 	while (1) {
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		if (ret < 0) {
-			fprintf(stderr, "ERROR: can't perform the search\n");
+			btrfs_error("ERROR: can't perform the search\n");
 			return 0;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
@@ -413,7 +413,7 @@ static char *__ino_resolve(int fd, u64 dirid)
 
 	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
 	if (ret) {
-		fprintf(stderr, "ERROR: Failed to lookup path for dirid %llu\n",
+		btrfs_error("ERROR: Failed to lookup path for dirid %llu\n",
 			(unsigned long long)dirid);
 		return ERR_PTR(ret);
 	}
@@ -491,7 +491,7 @@ static char *ino_resolve(int fd, u64 ino, u64 *cache_dirid, char **cache_name)
 
 	ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 	if (ret < 0) {
-		fprintf(stderr, "ERROR: can't perform the search\n");
+		btrfs_error("ERROR: can't perform the search\n");
 		return NULL;
 	}
 	/* the ioctl returns the number of item it found in nr_items */
@@ -579,7 +579,7 @@ int list_subvols(int fd)
 	while(1) {
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		if (ret < 0) {
-			fprintf(stderr, "ERROR: can't perform the search\n");
+			btrfs_error("ERROR: can't perform the search\n");
 			return ret;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
@@ -774,7 +774,7 @@ int find_updated_files(int fd, u64 root_id, u64 oldest_gen)
 	while(1) {
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		if (ret < 0) {
-			fprintf(stderr, "ERROR: can't perform the search\n");
+			btrfs_error("ERROR: can't perform the search\n");
 			return ret;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index a109c6a..235bb1e 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -31,6 +31,7 @@
 #include "transaction.h"
 #include "list.h"
 #include "version.h"
+#include "utils.h"
 
 /* we write the mirror info to stdout unless they are dumping the data
  * to stdout
@@ -86,11 +87,11 @@ struct extent_buffer *debug_read_block(struct btrfs_root *root, u64 bytenr,
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: btrfs-map-logical [options] mount_point\n");
-	fprintf(stderr, "\t-l Logical extent to map\n");
-	fprintf(stderr, "\t-c Copy of the extent to read (usually 1 or 2)\n");
-	fprintf(stderr, "\t-o Output file to hold the extent\n");
-	fprintf(stderr, "\t-s Number of bytes to read\n");
+	btrfs_error("usage: btrfs-map-logical [options] mount_point\n");
+	btrfs_error("\t-l Logical extent to map\n");
+	btrfs_error("\t-c Copy of the extent to read (usually 1 or 2)\n");
+	btrfs_error("\t-o Output file to hold the extent\n");
+	btrfs_error("\t-s Number of bytes to read\n");
 	exit(1);
 }
 
@@ -171,7 +172,7 @@ int main(int ac, char **av)
 
 	root = open_ctree(dev, 0, 0);
 	if (!root) {
-		fprintf(stderr, "Open ctree failed\n");
+		btrfs_error("Open ctree failed\n");
 		exit(1);
 	}
 
@@ -203,7 +204,7 @@ int main(int ac, char **av)
 		if (eb && output_file) {
 			err = write(out_fd, eb->data, eb->len);
 			if (err < 0 || err != eb->len) {
-				fprintf(stderr, "output file write failed\n");
+				btrfs_error("output file write failed\n");
 				goto out_close_fd;
 			}
 		}
diff --git a/btrfs-show.c b/btrfs-show.c
index c49626c..17fa543 100644
--- a/btrfs-show.c
+++ b/btrfs-show.c
@@ -98,8 +98,8 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: btrfs-show [search label or device]\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+	btrfs_error("usage: btrfs-show [search label or device]\n");
+	btrfs_error("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
 
@@ -135,7 +135,7 @@ int main(int ac, char **av)
 
 	ret = btrfs_scan_one_dir("/dev", 0);
 	if (ret)
-		fprintf(stderr, "error %d while scanning\n", ret);
+		btrfs_error("error %d while scanning\n", ret);
 
 	all_uuids = btrfs_scanned_uuids();
 	list_for_each(cur_uuid, all_uuids) {
diff --git a/btrfs-vol.c b/btrfs-vol.c
index 4ed799d..bbb2d98 100644
--- a/btrfs-vol.c
+++ b/btrfs-vol.c
@@ -49,10 +49,10 @@ static inline int ioctl(int fd, int define, void *arg) { return 0; }
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: btrfs-vol [options] mount_point\n");
-	fprintf(stderr, "\t-a device add one device\n");
-	fprintf(stderr, "\t-b balance chunks across all devices\n");
-	fprintf(stderr, "\t-r device remove one device\n");
+	btrfs_error("usage: btrfs-vol [options] mount_point\n");
+	btrfs_error("\t-a device add one device\n");
+	btrfs_error("\t-b balance chunks across all devices\n");
+	btrfs_error("\t-r device remove one device\n");
 	exit(1);
 }
 
@@ -107,7 +107,7 @@ int main(int ac, char **av)
 
 	if (device && strcmp(device, "missing") == 0 &&
 	    cmd == BTRFS_IOC_RM_DEV) {
-		fprintf(stderr, "removing missing devices from %s\n", mnt);
+		btrfs_error("removing missing devices from %s\n", mnt);
 	} else if (cmd != BTRFS_IOC_BALANCE) {
 		if (cmd == BTRFS_IOC_ADD_DEV) {
 			ret = check_mounted(device);
@@ -118,34 +118,34 @@ int main(int ac, char **av)
 				exit(1);
 			}
 			if (ret == 1) {
-				fprintf(stderr, "%s is mounted\n", device);
+				btrfs_error("%s is mounted\n", device);
 				exit(1);
 			}
 		}
 		devfd = open(device, O_RDWR);
 		if (devfd < 0) {
-			fprintf(stderr, "Unable to open device %s\n", device);
+			btrfs_error("Unable to open device %s\n", device);
 			exit(1);
 		}
 		ret = fstat(devfd, &st);
 		if (ret) {
-			fprintf(stderr, "Unable to stat %s\n", device);
+			btrfs_error("Unable to stat %s\n", device);
 			exit(1);
 		}
 		if (!S_ISBLK(st.st_mode)) {
-			fprintf(stderr, "%s is not a block device\n", device);
+			btrfs_error("%s is not a block device\n", device);
 			exit(1);
 		}
 	}
 	dirstream = opendir(mnt);
 	if (!dirstream) {
-		fprintf(stderr, "Unable to open directory %s\n", mnt);
+		btrfs_error("Unable to open directory %s\n", mnt);
 		exit(1);
 	}
 	if (cmd == BTRFS_IOC_ADD_DEV) {
 		ret = btrfs_prepare_device(devfd, device, 1, &dev_block_count);
 		if (ret) {
-			fprintf(stderr, "Unable to init %s\n", device);
+			btrfs_error("Unable to init %s\n", device);
 			exit(1);
 		}
 	}
diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index f10438b..066dd6e 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -34,8 +34,8 @@
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: btrfs-zero-log dev\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+	btrfs_error("usage: btrfs-zero-log dev\n");
+	btrfs_error("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
 
@@ -50,10 +50,10 @@ int main(int ac, char **av)
 	radix_tree_init();
 
 	if((ret = check_mounted(av[1])) < 0) {
-		fprintf(stderr, "Could not check mount status: %s\n", strerror(ret));
+		btrfs_error("Could not check mount status: %s\n", strerror(ret));
 		return ret;
 	} else if(ret) {
-		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[1]);
+		btrfs_error("%s is currently mounted. Aborting.\n", av[1]);
 		return -EBUSY;
 	}
 
diff --git a/btrfs.c b/btrfs.c
index 46314cf..4dc2c3c 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -22,6 +22,7 @@
 #include "kerncompat.h"
 #include "btrfs_cmds.h"
 #include "version.h"
+#include "utils.h"
 
 typedef int (*CommandFunction)(int argc, char **argv);
 
@@ -209,10 +210,10 @@ static int check_ambiguity(struct Command *cmd, char **argv){
 		}
 		if(match){
 			int j;
-			fprintf(stderr, "ERROR: in command '");
+			btrfs_error("ERROR: in command '");
 			for( j = 0 ; j <= i ; j++ )
-				fprintf(stderr, "%s%s",j?" ":"", argv[j+1]);
-			fprintf(stderr, "', '%s' is ambiguous\n",argv[j]);
+				btrfs_error("%s%s",j?" ":"", argv[j+1]);
+			btrfs_error("', '%s' is ambiguous\n",argv[j]);
 			return -2;
 		}
 	}
@@ -350,18 +351,18 @@ static int parse_args(int argc, char **argv,
 
 	/* check the number of argument */
 	if (matchcmd->nargs < 0 && matchcmd->nargs < -*nargs_ ){
-		fprintf(stderr, "ERROR: '%s' requires minimum %d arg(s)\n",
+		btrfs_error("ERROR: '%s' requires minimum %d arg(s)\n",
 			matchcmd->verb, -matchcmd->nargs);
 			return -2;
 	}
 	if(matchcmd->nargs >= 0 && matchcmd->nargs != *nargs_ && matchcmd->nargs != 999){
-		fprintf(stderr, "ERROR: '%s' requires %d arg(s)\n",
+		btrfs_error("ERROR: '%s' requires %d arg(s)\n",
 			matchcmd->verb, matchcmd->nargs);
 			return -2;
 	}
 	
         if (prepare_args( nargs_, args_, prgname, matchcmd )){
-                fprintf(stderr, "ERROR: not enough memory\\n");
+                btrfs_error("ERROR: not enough memory\\n");
 		return -20;
         }
 
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index 8031c58..ac3247e 100644
--- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -134,7 +134,7 @@ static u64 parse_size(char *s)
 		case 'b':
 			break;
 		default:
-			fprintf(stderr, "Unknown size descriptor %c\n", c);
+			btrfs_error("Unknown size descriptor %c\n", c);
 			exit(1);
 		}
 		s[len - 1] = '\0';
@@ -187,13 +187,13 @@ int do_defrag(int ac, char **av)
 			fancy_ioctl = 1;
 			break;
 		default:
-			fprintf(stderr, "Invalid arguments for defragment\n");
+			btrfs_error("Invalid arguments for defragment\n");
 			free(av);
 			return 1;
 		}
 	}
 	if (ac - optind == 0) {
-		fprintf(stderr, "Invalid arguments for defragment\n");
+		btrfs_error("Invalid arguments for defragment\n");
 		free(av);
 		return 1;
 	}
@@ -212,7 +212,7 @@ int do_defrag(int ac, char **av)
 			printf("%s\n", av[i]);
 		fd = open_file_or_dir(av[i]);
 		if (fd < 0) {
-			fprintf(stderr, "failed to open %s\n", av[i]);
+			btrfs_error("failed to open %s\n", av[i]);
 			perror("open:");
 			errors++;
 			continue;
@@ -222,7 +222,7 @@ int do_defrag(int ac, char **av)
 		} else {
 			ret = ioctl(fd, BTRFS_IOC_DEFRAG_RANGE, &range);
 			if (ret && errno == ENOTTY) {
-				fprintf(stderr, "defrag range ioctl not "
+				btrfs_error("defrag range ioctl not "
 					"supported in this kernel, please try "
 					"without any options.\n");
 				errors++;
@@ -230,7 +230,7 @@ int do_defrag(int ac, char **av)
 			}
 		}
 		if (ret) {
-			fprintf(stderr, "ioctl failed on %s ret %d errno %d\n",
+			btrfs_error("ioctl failed on %s ret %d errno %d\n",
 				av[i], ret, errno);
 			errors++;
 		}
@@ -239,7 +239,7 @@ int do_defrag(int ac, char **av)
 	if (verbose)
 		printf("%s\n", BTRFS_BUILD_VERSION);
 	if (errors) {
-		fprintf(stderr, "total %d failures\n", errors);
+		btrfs_error("total %d failures\n", errors);
 		exit(1);
 	}
 
@@ -259,17 +259,17 @@ int do_find_newer(int argc, char **argv)
 
 	ret = test_issubvolume(subvol);
 	if (ret < 0) {
-		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
+		btrfs_error("ERROR: error accessing '%s'\n", subvol);
 		return 12;
 	}
 	if (!ret) {
-		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
+		btrfs_error("ERROR: '%s' is not a subvolume\n", subvol);
 		return 13;
 	}
 
 	fd = open_file_or_dir(subvol);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+		btrfs_error("ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
 	ret = find_updated_files(fd, 0, last_gen);
@@ -288,17 +288,17 @@ int do_subvol_list(int argc, char **argv)
 
 	ret = test_issubvolume(subvol);
 	if (ret < 0) {
-		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
+		btrfs_error("ERROR: error accessing '%s'\n", subvol);
 		return 12;
 	}
 	if (!ret) {
-		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
+		btrfs_error("ERROR: '%s' is not a subvolume\n", subvol);
 		return 13;
 	}
 
 	fd = open_file_or_dir(subvol);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+		btrfs_error("ERROR: can't access '%s'\n", subvol);
 		return 12;
 	}
 	ret = list_subvols(fd);
@@ -320,17 +320,17 @@ int do_clone(int argc, char **argv)
 
 	res = test_issubvolume(subvol);
 	if(res<0){
-		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
+		btrfs_error("ERROR: error accessing '%s'\n", subvol);
 		return 12;
 	}
 	if(!res){
-		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
+		btrfs_error("ERROR: '%s' is not a subvolume\n", subvol);
 		return 13;
 	}
 
 	res = test_isdir(dst);
 	if(res == 0 ){
-		fprintf(stderr, "ERROR: '%s' exists and it is not a directory\n", dst);
+		btrfs_error("ERROR: '%s' exists and it is not a directory\n", dst);
 		return 12;
 	}
 
@@ -347,28 +347,28 @@ int do_clone(int argc, char **argv)
 
 	if( !strcmp(newname,".") || !strcmp(newname,"..") ||
 	     strchr(newname, '/') ){
-		fprintf(stderr, "ERROR: incorrect snapshot name ('%s')\n",
+		btrfs_error("ERROR: incorrect snapshot name ('%s')\n",
 			newname);
 		return 14;
 	}
 
 	len = strlen(newname);
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-		fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
+		btrfs_error("ERROR: snapshot name too long ('%s)\n",
 			newname);
 		return 14;
 	}
 
 	fddst = open_file_or_dir(dstdir);
 	if (fddst < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
+		btrfs_error("ERROR: can't access to '%s'\n", dstdir);
 		return 12;
 	}
 
 	fd = open_file_or_dir(subvol);
 	if (fd < 0) {
 		close(fddst);
-		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
+		btrfs_error("ERROR: can't access to '%s'\n", dstdir);
 		return 12;
 	}
 
@@ -399,11 +399,11 @@ int do_delete_subvolume(int argc, char **argv)
 
 	res = test_issubvolume(path);
 	if(res<0){
-		fprintf(stderr, "ERROR: error accessing '%s'\n", path);
+		btrfs_error("ERROR: error accessing '%s'\n", path);
 		return 12;
 	}
 	if(!res){
-		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", path);
+		btrfs_error("ERROR: '%s' is not a subvolume\n", path);
 		return 13;
 	}
 
@@ -416,14 +416,14 @@ int do_delete_subvolume(int argc, char **argv)
 
 	if( !strcmp(vname,".") || !strcmp(vname,"..") ||
 	     strchr(vname, '/') ){
-		fprintf(stderr, "ERROR: incorrect subvolume name ('%s')\n",
+		btrfs_error("ERROR: incorrect subvolume name ('%s')\n",
 			vname);
 		return 14;
 	}
 
 	len = strlen(vname);
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-		fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
+		btrfs_error("ERROR: snapshot name too long ('%s)\n",
 			vname);
 		return 14;
 	}
@@ -431,7 +431,7 @@ int do_delete_subvolume(int argc, char **argv)
 	fd = open_file_or_dir(dname);
 	if (fd < 0) {
 		close(fd);
-		fprintf(stderr, "ERROR: can't access to '%s'\n", dname);
+		btrfs_error("ERROR: can't access to '%s'\n", dname);
 		return 12;
 	}
 
@@ -460,7 +460,7 @@ int do_create_subvol(int argc, char **argv)
 
 	res = test_isdir(dst);
 	if(res >= 0 ){
-		fprintf(stderr, "ERROR: '%s' exists\n", dst);
+		btrfs_error("ERROR: '%s' exists\n", dst);
 		return 12;
 	}
 
@@ -471,21 +471,21 @@ int do_create_subvol(int argc, char **argv)
 
 	if( !strcmp(newname,".") || !strcmp(newname,"..") ||
 	     strchr(newname, '/') ){
-		fprintf(stderr, "ERROR: uncorrect subvolume name ('%s')\n",
+		btrfs_error("ERROR: uncorrect subvolume name ('%s')\n",
 			newname);
 		return 14;
 	}
 
 	len = strlen(newname);
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-		fprintf(stderr, "ERROR: subvolume name too long ('%s)\n",
+		btrfs_error("ERROR: subvolume name too long ('%s)\n",
 			newname);
 		return 14;
 	}
 
 	fddst = open_file_or_dir(dstdir);
 	if (fddst < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", dstdir);
+		btrfs_error("ERROR: can't access to '%s'\n", dstdir);
 		return 12;
 	}
 
@@ -511,7 +511,7 @@ int do_fssync(int argc, char **argv)
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		btrfs_error("ERROR: can't access to '%s'\n", path);
 		return 12;
 	}
 
@@ -519,7 +519,7 @@ int do_fssync(int argc, char **argv)
 	res = ioctl(fd, BTRFS_IOC_SYNC);
 	close(fd);
 	if( res < 0 ){
-		fprintf(stderr, "ERROR: unable to fs-syncing '%s'\n", path);
+		btrfs_error("ERROR: unable to fs-syncing '%s'\n", path);
 		return 16;
 	}
 
@@ -535,7 +535,7 @@ int do_scan(int argc, char **argv)
 		printf("Scanning for Btrfs filesystems\n");
 		ret = btrfs_scan_one_dir("/dev", 1);
 		if (ret){
-			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
+			btrfs_error("ERROR: error %d while scanning\n", ret);
 			return 18;
 		}
 		return 0;
@@ -563,7 +563,7 @@ int do_scan(int argc, char **argv)
 
 		if( ret < 0 ){
 			close(fd);
-			fprintf(stderr, "ERROR: unable to scan the device '%s'\n", argv[i]);
+			btrfs_error("ERROR: unable to scan the device '%s'\n", argv[i]);
 			return 11;
 		}
 	}
@@ -582,12 +582,12 @@ int do_resize(int argc, char **argv)
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		btrfs_error("ERROR: can't access to '%s'\n", path);
 		return 12;
 	}
 	len = strlen(amount);
 	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-		fprintf(stderr, "ERROR: size value too long ('%s)\n",
+		btrfs_error("ERROR: size value too long ('%s)\n",
 			amount);
 		return 14;
 	}
@@ -597,7 +597,7 @@ int do_resize(int argc, char **argv)
 	res = ioctl(fd, BTRFS_IOC_RESIZE, &args);
 	close(fd);
 	if( res < 0 ){
-		fprintf(stderr, "ERROR: unable to resize '%s'\n", path);
+		btrfs_error("ERROR: unable to resize '%s'\n", path);
 		return 30;
 	}
 	return 0;
@@ -671,7 +671,7 @@ int do_show_filesystem(int argc, char **argv)
 
 	ret = btrfs_scan_one_dir("/dev", 0);
 	if (ret){
-		fprintf(stderr, "ERROR: error %d while scanning\n", ret);
+		btrfs_error("ERROR: error %d while scanning\n", ret);
 		return 18;
 	}
 
@@ -696,7 +696,7 @@ int do_add_volume(int nargs, char **args)
 
 	fdmnt = open_file_or_dir(mntpnt);
 	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", mntpnt);
+		btrfs_error("ERROR: can't access to '%s'\n", mntpnt);
 		return 12;
 	}
 
@@ -708,20 +708,20 @@ int do_add_volume(int nargs, char **args)
 
 		devfd = open(args[i], O_RDWR);
 		if (!devfd) {
-			fprintf(stderr, "ERROR: Unable to open device '%s'\n", args[i]);
+			btrfs_error("ERROR: Unable to open device '%s'\n", args[i]);
 			close(devfd);
 			ret++;
 			continue;
 		}
 		ret = fstat(devfd, &st);
 		if (ret) {
-			fprintf(stderr, "ERROR: Unable to stat '%s'\n", args[i]);
+			btrfs_error("ERROR: Unable to stat '%s'\n", args[i]);
 			close(devfd);
 			ret++;
 			continue;
 		}
 		if (!S_ISBLK(st.st_mode)) {
-			fprintf(stderr, "ERROR: '%s' is not a block device\n", args[i]);
+			btrfs_error("ERROR: '%s' is not a block device\n", args[i]);
 			close(devfd);
 			ret++;
 			continue;
@@ -729,7 +729,7 @@ int do_add_volume(int nargs, char **args)
 
 		res = btrfs_prepare_device(devfd, args[i], 1, &dev_block_count);
 		if (res) {
-			fprintf(stderr, "ERROR: Unable to init '%s'\n", args[i]);
+			btrfs_error("ERROR: Unable to init '%s'\n", args[i]);
 			close(devfd);
 			ret++;
 			continue;
@@ -739,7 +739,7 @@ int do_add_volume(int nargs, char **args)
 		strcpy(ioctl_args.name, args[i]);
 		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
 		if(res<0){
-			fprintf(stderr, "ERROR: error adding the device '%s'\n", args[i]);
+			btrfs_error("ERROR: error adding the device '%s'\n", args[i]);
 			ret++;
 		}
 
@@ -762,7 +762,7 @@ int do_balance(int argc, char **argv)
 
 	fdmnt = open_file_or_dir(path);
 	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		btrfs_error("ERROR: can't access to '%s'\n", path);
 		return 12;
 	}
 
@@ -770,7 +770,7 @@ int do_balance(int argc, char **argv)
 	ret = ioctl(fdmnt, BTRFS_IOC_BALANCE, &args);
 	close(fdmnt);
 	if(ret<0){
-		fprintf(stderr, "ERROR: balancing '%s'\n", path);
+		btrfs_error("ERROR: balancing '%s'\n", path);
 
 		return 19;
 	}
@@ -784,7 +784,7 @@ int do_remove_volume(int nargs, char **args)
 
 	fdmnt = open_file_or_dir(mntpnt);
 	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", mntpnt);
+		btrfs_error("ERROR: can't access to '%s'\n", mntpnt);
 		return 12;
 	}
 
@@ -795,7 +795,7 @@ int do_remove_volume(int nargs, char **args)
 		strcpy(arg.name, args[i]);
 		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
 		if(res<0){
-			fprintf(stderr, "ERROR: error removing the device '%s'\n", args[i]);
+			btrfs_error("ERROR: error removing the device '%s'\n", args[i]);
 			ret++;
 		}
 	}
@@ -816,19 +816,19 @@ int do_set_default_subvol(int nargs, char **argv)
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		btrfs_error("ERROR: can't access to '%s'\n", path);
 		return 12;
 	}
 
 	objectid = (unsigned long long)strtoll(subvolid, NULL, 0);
 	if (errno == ERANGE) {
-		fprintf(stderr, "ERROR: invalid tree id (%s)\n",subvolid);
+		btrfs_error("ERROR: invalid tree id (%s)\n",subvolid);
 		return 30;
 	}
 	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
 	close(fd);
 	if( ret < 0 ){
-		fprintf(stderr, "ERROR: unable to set a new default subvolume\n");
+		btrfs_error("ERROR: unable to set a new default subvolume\n");
 		return 30;
 	}
 	return 0;
@@ -844,7 +844,7 @@ int do_df_filesystem(int nargs, char **argv)
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		btrfs_error("ERROR: can't access to '%s'\n", path);
 		return 12;
 	}
 
diff --git a/btrfsck.c b/btrfsck.c
index 63e44d1..01accef 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -792,7 +792,7 @@ static int process_dir_item(struct extent_buffer *eb,
 					  key->objectid, key->offset, namebuf,
 					  len, filetype, key->type, error);
 		} else {
-			fprintf(stderr, "warning line %d\n", __LINE__);
+			btrfs_error("warning line %d\n", __LINE__);
 		}
 
 		len = sizeof(*di) + name_len + data_len;
@@ -1199,7 +1199,7 @@ static int check_inode_recs(struct btrfs_root *root,
 
 	if (btrfs_root_refs(&root->root_item) == 0) {
 		if (!cache_tree_empty(inode_cache))
-			fprintf(stderr, "warning line %d\n", __LINE__);
+			btrfs_error("warning line %d\n", __LINE__);
 		return 0;
 	}
 
@@ -1207,13 +1207,13 @@ static int check_inode_recs(struct btrfs_root *root,
 	if (rec) {
 		ret = check_root_dir(rec);
 		if (ret) {
-			fprintf(stderr, "root %llu root dir %llu error\n",
+			btrfs_error("root %llu root dir %llu error\n",
 				(unsigned long long)root->root_key.objectid,
 				(unsigned long long)root_dirid);
 			error++;
 		}
 	} else {
-		fprintf(stderr, "root %llu root dir %llu not found\n",
+		btrfs_error("root %llu root dir %llu not found\n",
 			(unsigned long long)root->root_key.objectid,
 			(unsigned long long)root_dirid);
 	}
@@ -1247,7 +1247,7 @@ static int check_inode_recs(struct btrfs_root *root,
 			rec->errors |= I_ERR_NO_INODE_ITEM;
 		if (rec->found_link != rec->nlink)
 			rec->errors |= I_ERR_LINK_COUNT_WRONG;
-		fprintf(stderr, "root %llu inode %llu errors %x\n",
+		btrfs_error("root %llu inode %llu errors %x\n",
 			(unsigned long long) root->root_key.objectid,
 			(unsigned long long) rec->ino, rec->errors);
 		list_for_each_entry(backref, &rec->backrefs, list) {
@@ -1257,7 +1257,7 @@ static int check_inode_recs(struct btrfs_root *root,
 				backref->errors |= REF_ERR_NO_DIR_INDEX;
 			if (!backref->found_inode_ref)
 				backref->errors |= REF_ERR_NO_INODE_REF;
-			fprintf(stderr, "\tunresolved ref dir %llu index %llu"
+			btrfs_error("\tunresolved ref dir %llu index %llu"
 				" namelen %u name %s filetype %d error %x\n",
 				(unsigned long long)backref->dir,
 				(unsigned long long)backref->index,
@@ -1489,7 +1489,7 @@ static int check_root_refs(struct btrfs_root *root,
 			if (ret == 0)
 				continue;
 			errors++;
-			fprintf(stderr, "fs tree %llu not referenced\n",
+			btrfs_error("fs tree %llu not referenced\n",
 				(unsigned long long)rec->objectid);
 		}
 
@@ -1512,7 +1512,7 @@ static int check_root_refs(struct btrfs_root *root,
 			continue;
 
 		errors++;
-		fprintf(stderr, "fs tree %llu refs %u %s\n",
+		btrfs_error("fs tree %llu refs %u %s\n",
 			(unsigned long long)rec->objectid, rec->found_ref,
 			 rec->found_root_item ? "" : "not found");
 
@@ -1521,7 +1521,7 @@ static int check_root_refs(struct btrfs_root *root,
 				continue;
 			if (!backref->errors && rec->found_root_item)
 				continue;
-			fprintf(stderr, "\tunresolved ref root %llu dir %llu"
+			btrfs_error("\tunresolved ref root %llu dir %llu"
 				" index %llu namelen %u name %s error %x\n",
 				(unsigned long long)backref->ref_root,
 				(unsigned long long)backref->dir,
@@ -1705,7 +1705,7 @@ static int check_fs_roots(struct btrfs_root *root,
 	btrfs_release_path(tree_root, &path);
 
 	if (!cache_tree_empty(&wc.shared))
-		fprintf(stderr, "warning line %d\n", __LINE__);
+		btrfs_error("warning line %d\n", __LINE__);
 
 	return err;
 }
@@ -1745,12 +1745,12 @@ static int check_leaf(struct btrfs_root *root,
 	u32 nritems = btrfs_header_nritems(buf);
 
 	if (btrfs_header_level(buf) != 0) {
-		fprintf(stderr, "leaf is not a leaf %llu\n",
+		btrfs_error("leaf is not a leaf %llu\n",
 		       (unsigned long long)btrfs_header_bytenr(buf));
 		return 1;
 	}
 	if (btrfs_leaf_free_space(root, buf) < 0) {
-		fprintf(stderr, "leaf free space incorrect %llu %d\n",
+		btrfs_error("leaf free space incorrect %llu %d\n",
 			(unsigned long long)btrfs_header_bytenr(buf),
 			btrfs_leaf_free_space(root, buf));
 		return 1;
@@ -1761,7 +1761,7 @@ static int check_leaf(struct btrfs_root *root,
 
 	btrfs_item_key(buf, &key, 0);
 	if (parent_key->type && memcmp(parent_key, &key, sizeof(key))) {
-		fprintf(stderr, "leaf parent key incorrect %llu\n",
+		btrfs_error("leaf parent key incorrect %llu\n",
 		       (unsigned long long)btrfs_header_bytenr(buf));
 		return 1;
 	}
@@ -1769,19 +1769,19 @@ static int check_leaf(struct btrfs_root *root,
 		btrfs_item_key(buf, &key, i);
 		btrfs_item_key_to_cpu(buf, &cpukey, i + 1);
 		if (btrfs_comp_keys(&key, &cpukey) >= 0) {
-			fprintf(stderr, "bad key ordering %d %d\n", i, i+1);
+			btrfs_error("bad key ordering %d %d\n", i, i+1);
 			return 1;
 		}
 		if (btrfs_item_offset_nr(buf, i) !=
 			btrfs_item_end_nr(buf, i + 1)) {
-			fprintf(stderr, "incorrect offsets %u %u\n",
+			btrfs_error("incorrect offsets %u %u\n",
 				btrfs_item_offset_nr(buf, i),
 				btrfs_item_end_nr(buf, i + 1));
 			return 1;
 		}
 		if (i == 0 && btrfs_item_end_nr(buf, i) !=
 		    BTRFS_LEAF_DATA_SIZE(root)) {
-			fprintf(stderr, "bad item end %u wanted %u\n",
+			btrfs_error("bad item end %u wanted %u\n",
 				btrfs_item_end_nr(buf, i),
 				(unsigned)BTRFS_LEAF_DATA_SIZE(root));
 			return 1;
@@ -1808,7 +1808,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 				goto out;
 			if (back->is_data) {
 				dback = (struct data_backref *)back;
-				fprintf(stderr, "Backref %llu %s %llu"
+				btrfs_error("Backref %llu %s %llu"
 					" owner %llu offset %llu num_refs %lu"
 					" not found in extent tree\n",
 					(unsigned long long)rec->start,
@@ -1822,7 +1822,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 					(unsigned long)dback->num_refs);
 			} else {
 				tback = (struct tree_backref *)back;
-				fprintf(stderr, "Backref %llu parent %llu"
+				btrfs_error("Backref %llu parent %llu"
 					" root %llu not found in extent tree\n",
 					(unsigned long long)rec->start,
 					(unsigned long long)tback->parent,
@@ -1834,7 +1834,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 			if (!print_errs)
 				goto out;
 			tback = (struct tree_backref *)back;
-			fprintf(stderr, "Backref %llu %s %llu not referenced\n",
+			btrfs_error("Backref %llu %s %llu not referenced\n",
 				(unsigned long long)rec->start,
 				back->full_backref ? "parent" : "root",
 				back->full_backref ?
@@ -1847,7 +1847,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 				err = 1;
 				if (!print_errs)
 					goto out;
-				fprintf(stderr, "Incorrect local backref count"
+				btrfs_error("Incorrect local backref count"
 					" on %llu %s %llu owner %llu"
 					" offset %llu found %u wanted %u\n",
 					(unsigned long long)rec->start,
@@ -1872,7 +1872,7 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 		err = 1;
 		if (!print_errs)
 			goto out;
-		fprintf(stderr, "Incorrect global backref count "
+		btrfs_error("Incorrect global backref count "
 			"on %llu found %llu wanted %llu\n",
 			(unsigned long long)rec->start,
 			(unsigned long long)found,
@@ -1978,7 +1978,7 @@ static int check_block(struct btrfs_root *root,
 		ret = check_node(root, &rec->parent_key, buf);
 	}
 	if (ret) {
-		fprintf(stderr, "bad block %llu\n",
+		btrfs_error("bad block %llu\n",
 			(unsigned long long)buf->start);
 	} else {
 		rec->content_checked = 1;
@@ -2111,14 +2111,14 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 			rec->nr = nr;
 
 		if (start != rec->start) {
-			fprintf(stderr, "warning, start mismatch %llu %llu\n",
+			btrfs_error("warning, start mismatch %llu %llu\n",
 				(unsigned long long)rec->start,
 				(unsigned long long)start);
 			ret = 1;
 		}
 		if (extent_item_refs) {
 			if (rec->extent_item_refs) {
-				fprintf(stderr, "block %llu rec "
+				btrfs_error("block %llu rec "
 					"extent_item_refs %llu, passed %llu\n",
 					(unsigned long long)start,
 					(unsigned long long)
@@ -2205,7 +2205,7 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 
 	if (found_ref) {
 		if (back->node.found_ref) {
-			fprintf(stderr, "Extent back ref already exists "
+			btrfs_error("Extent back ref already exists "
 				"for %llu parent %llu root %llu \n",
 				(unsigned long long)bytenr,
 				(unsigned long long)parent,
@@ -2214,7 +2214,7 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 		back->node.found_ref = 1;
 	} else {
 		if (back->node.found_extent_tree) {
-			fprintf(stderr, "Extent back ref already exists "
+			btrfs_error("Extent back ref already exists "
 				"for %llu parent %llu root %llu \n",
 				(unsigned long long)bytenr,
 				(unsigned long long)parent,
@@ -2255,7 +2255,7 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 		back->found_ref += 1;
 	} else {
 		if (back->node.found_extent_tree) {
-			fprintf(stderr, "Extent back ref already exists "
+			btrfs_error("Extent back ref already exists "
 				"for %llu parent %llu root %llu"
 				"owner %llu offset %llu num_refs %lu\n",
 				(unsigned long long)bytenr,
@@ -2547,7 +2547,7 @@ static int run_next_block(struct btrfs_root *root,
 					btrfs_disk_key_objectid(disk_key),
 					btrfs_disk_key_offset(disk_key),
 					btrfs_block_group_used(bi));
-				fprintf(stderr, "flags %x\n", bi->flags);
+				btrfs_error("flags %x\n", bi->flags);
 #endif
 				continue;
 			}
@@ -2695,23 +2695,23 @@ static int check_extent_refs(struct btrfs_root *root,
 			break;
 		rec = container_of(cache, struct extent_record, cache);
 		if (rec->refs != rec->extent_item_refs) {
-			fprintf(stderr, "ref mismatch on [%llu %llu] ",
+			btrfs_error("ref mismatch on [%llu %llu] ",
 				(unsigned long long)rec->start,
 				(unsigned long long)rec->nr);
-			fprintf(stderr, "extent item %llu, found %llu\n",
+			btrfs_error("extent item %llu, found %llu\n",
 				(unsigned long long)rec->extent_item_refs,
 				(unsigned long long)rec->refs);
 			err = 1;
 		}
 		if (all_backpointers_checked(rec, 1)) {
-			fprintf(stderr, "backpointer mismatch on [%llu %llu]\n",
+			btrfs_error("backpointer mismatch on [%llu %llu]\n",
 				(unsigned long long)rec->start,
 				(unsigned long long)rec->nr);
 
 			err = 1;
 		}
 		if (!rec->owner_ref_checked) {
-			fprintf(stderr, "owner ref check failed [%llu %llu]\n",
+			btrfs_error("owner ref check failed [%llu %llu]\n",
 				(unsigned long long)rec->start,
 				(unsigned long long)rec->nr);
 			err = 1;
@@ -2811,8 +2811,8 @@ static int check_extents(struct btrfs_root *root)
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: btrfsck dev\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+	btrfs_error("usage: btrfsck dev\n");
+	btrfs_error("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
 
@@ -2849,10 +2849,10 @@ int main(int ac, char **av)
 	cache_tree_init(&root_cache);
 
 	if((ret = check_mounted(av[optind])) < 0) {
-		fprintf(stderr, "Could not check mount status: %s\n", strerror(ret));
+		btrfs_error("Could not check mount status: %s\n", strerror(ret));
 		return ret;
 	} else if(ret) {
-		fprintf(stderr, "%s is currently mounted. Aborting.\n", av[optind]);
+		btrfs_error("%s is currently mounted. Aborting.\n", av[optind]);
 		return -EBUSY;
 	}
 
diff --git a/btrfsctl.c b/btrfsctl.c
index 92bdf39..d6620da 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -108,14 +108,14 @@ int main(int ac, char **av)
 	u64 objectid = 0;
 
 	if (ac == 2 && strcmp(av[1], "-a") == 0) {
-		fprintf(stderr, "Scanning for Btrfs filesystems\n");
+		btrfs_error("Scanning for Btrfs filesystems\n");
 		btrfs_scan_one_dir("/dev", 1);
 		exit(0);
 	}
 	for (i = 1; i < ac; i++) {
 		if (strcmp(av[i], "-s") == 0) {
 			if (i + 1 >= ac - 1) {
-				fprintf(stderr, "-s requires an arg");
+				btrfs_error("-s requires an arg");
 				print_usage();
 			}
 			fullpath = av[i + 1];
@@ -142,7 +142,7 @@ int main(int ac, char **av)
 			command = BTRFS_IOC_SNAP_CREATE;
 		} else if (strcmp(av[i], "-S") == 0) {
 			if (i + 1 >= ac - 1) {
-				fprintf(stderr, "-S requires an arg");
+				btrfs_error("-S requires an arg");
 				print_usage();
 			}
 			name = av[i + 1];
@@ -160,13 +160,13 @@ int main(int ac, char **av)
 			command = BTRFS_IOC_SUBVOL_CREATE;
 		} else if (strcmp(av[i], "-d") == 0) {
 			if (i >= ac - 1) {
-				fprintf(stderr, "-d requires an arg\n");
+				btrfs_error("-d requires an arg\n");
 				print_usage();
 			}
 			command = BTRFS_IOC_DEFRAG;
 		} else if (strcmp(av[i], "-D") == 0) {
 			if (i >= ac - 1) {
-				fprintf(stderr, "-D requires an arg\n");
+				btrfs_error("-D requires an arg\n");
 				print_usage();
 			}
 			command = BTRFS_IOC_SNAP_DESTROY;
@@ -183,24 +183,24 @@ int main(int ac, char **av)
 				}
 			}
 			if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-				fprintf(stderr, "-D size too long\n");
+				btrfs_error("-D size too long\n");
 				exit(1);
 			}
 		} else if (strcmp(av[i], "-A") == 0) {
 			if (i >= ac - 1) {
-				fprintf(stderr, "-A requires an arg\n");
+				btrfs_error("-A requires an arg\n");
 				print_usage();
 			}
 			command = BTRFS_IOC_SCAN_DEV;
 		} else if (strcmp(av[i], "-r") == 0) {
 			if (i >= ac - 1) {
-				fprintf(stderr, "-r requires an arg\n");
+				btrfs_error("-r requires an arg\n");
 				print_usage();
 			}
 			name = av[i + 1];
 			len = strlen(name);
 			if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-				fprintf(stderr, "-r size too long\n");
+				btrfs_error("-r size too long\n");
 				exit(1);
 			}
 			command = BTRFS_IOC_RESIZE;
@@ -212,14 +212,14 @@ int main(int ac, char **av)
 				objectid = (unsigned long long)
 					    strtoll(av[i + 1], NULL, 0);
 				if (errno == ERANGE) {
-					fprintf(stderr, "invalid tree id\n");
+					btrfs_error("invalid tree id\n");
 					exit(1);
 				}
 			}
 		}
 	}
 	if (command == 0) {
-		fprintf(stderr, "no valid commands given\n");
+		btrfs_error("no valid commands given\n");
 		print_usage();
 		exit(1);
 	}
diff --git a/btrfstune.c b/btrfstune.c
index 47830c5..957ad8f 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -44,14 +44,14 @@ int update_seeding_flag(struct btrfs_root *root, int set_flag)
 	super_flags = btrfs_super_flags(disk_super);
 	if (set_flag) {
 		if (super_flags & BTRFS_SUPER_FLAG_SEEDING) {
-			fprintf(stderr, "seeding flag is already set on %s\n",
+			btrfs_error("seeding flag is already set on %s\n",
 				device);
 			return 1;
 		}
 		super_flags |= BTRFS_SUPER_FLAG_SEEDING;
 	} else {
 		if (!(super_flags & BTRFS_SUPER_FLAG_SEEDING)) {
-			fprintf(stderr, "seeding flag is not set on %s\n",
+			btrfs_error("seeding flag is not set on %s\n",
 				device);
 			return 1;
 		}
@@ -67,8 +67,8 @@ int update_seeding_flag(struct btrfs_root *root, int set_flag)
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: btrfstune [options] device\n");
-	fprintf(stderr, "\t-S value\tenable/disable seeding\n");
+	btrfs_error("usage: btrfstune [options] device\n");
+	btrfs_error("\t-S value\tenable/disable seeding\n");
 }
 
 int main(int argc, char *argv[])
@@ -102,7 +102,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (check_mounted(device)) {
-		fprintf(stderr, "%s is mounted\n", device);
+		btrfs_error("%s is mounted\n", device);
 		return 1;
 	}
 
diff --git a/convert.c b/convert.c
index d037c98..70bc3f0 100644
--- a/convert.c
+++ b/convert.c
@@ -57,18 +57,18 @@ static int open_ext2fs(const char *name, ext2_filsys *ret_fs)
 	ext2_ino_t ino;
 	ret = ext2fs_open(name, 0, 0, 0, unix_io_manager, &ext2_fs);
 	if (ret) {
-		fprintf(stderr, "ext2fs_open: %s\n", error_message(ret));
+		btrfs_error("ext2fs_open: %s\n", error_message(ret));
 		goto fail;
 	}
 	ret = ext2fs_read_inode_bitmap(ext2_fs);
 	if (ret) {
-		fprintf(stderr, "ext2fs_read_inode_bitmap: %s\n",
+		btrfs_error("ext2fs_read_inode_bitmap: %s\n",
 			error_message(ret));
 		goto fail;
 	}
 	ret = ext2fs_read_block_bitmap(ext2_fs);
 	if (ret) {
-		fprintf(stderr, "ext2fs_read_block_bitmap: %s\n",
+		btrfs_error("ext2fs_read_block_bitmap: %s\n",
 			error_message(ret));
 		goto fail;
 	}
@@ -196,7 +196,7 @@ static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
 		return 0;
 	}
 fail:
-	fprintf(stderr, "not enough free space\n");
+	btrfs_error("not enough free space\n");
 	return -ENOSPC;
 }
 
@@ -330,7 +330,7 @@ static int create_dir_entries(struct btrfs_trans_handle *trans,
 	}
 	return ret;
 error:
-	fprintf(stderr, "ext2fs_dir_iterate2: %s\n", error_message(err));
+	btrfs_error("ext2fs_dir_iterate2: %s\n", error_message(err));
 	return -1;
 }
 
@@ -634,7 +634,7 @@ fail:
 		free(buffer);
 	return ret;
 error:
-	fprintf(stderr, "ext2fs_block_iterate2: %s\n", error_message(err));
+	btrfs_error("ext2fs_block_iterate2: %s\n", error_message(err));
 	return -1;
 }
 
@@ -861,7 +861,7 @@ static int copy_single_xattr(struct btrfs_trans_handle *trans,
 	strncat(namebuf, EXT2_EXT_ATTR_NAME(entry), entry->e_name_len);
 	if (name_len + datalen > BTRFS_LEAF_DATA_SIZE(root) -
 	    sizeof(struct btrfs_item) - sizeof(struct btrfs_dir_item)) {
-		fprintf(stderr, "skip large xattr on inode %Lu name %.*s\n",
+		btrfs_error("skip large xattr on inode %Lu name %.*s\n",
 			objectid - INO_OFFSET, name_len, namebuf);
 		goto out;
 	}
@@ -900,7 +900,7 @@ static int copy_extended_attrs(struct btrfs_trans_handle *trans,
 	err = ext2fs_read_inode_full(ext2_fs, ext2_ino, (void *)ext2_inode,
 				     inode_size);
 	if (err) {
-		fprintf(stderr, "ext2fs_read_inode_full: %s\n",
+		btrfs_error("ext2fs_read_inode_full: %s\n",
 			error_message(err));
 		ret = -1;
 		goto out;
@@ -952,7 +952,7 @@ static int copy_extended_attrs(struct btrfs_trans_handle *trans,
 	}
 	err = ext2fs_read_ext_attr(ext2_fs, ext2_inode->i_file_acl, buffer);
 	if (err) {
-		fprintf(stderr, "ext2fs_read_ext_attr: %s\n",
+		btrfs_error("ext2fs_read_ext_attr: %s\n",
 			error_message(err));
 		ret = -1;
 		goto out;
@@ -1138,7 +1138,7 @@ static int copy_inodes(struct btrfs_root *root, ext2_filsys ext2_fs,
 		return -ENOMEM;
 	err = ext2fs_open_inode_scan(ext2_fs, 0, &ext2_scan);
 	if (err) {
-		fprintf(stderr, "ext2fs_open_inode_scan: %s\n", error_message(err));
+		btrfs_error("ext2fs_open_inode_scan: %s\n", error_message(err));
 		return -1;
 	}
 	while (!(err = ext2fs_get_next_inode(ext2_scan, &ext2_ino,
@@ -1165,7 +1165,7 @@ static int copy_inodes(struct btrfs_root *root, ext2_filsys ext2_fs,
 		}
 	}
 	if (err) {
-		fprintf(stderr, "ext2fs_get_next_inode: %s\n", error_message(err));
+		btrfs_error("ext2fs_get_next_inode: %s\n", error_message(err));
 		return -1;
 	}
 	ret = btrfs_commit_transaction(trans, root);
@@ -1819,7 +1819,7 @@ static int migrate_super_block(int fd, u64 old_bytenr, u32 sectorsize)
 			len = sectorsize;
 		ret = pwrite(fd, buf->data, len, bytenr);
 		if (ret != len) {
-			fprintf(stderr, "unable to zero fill device\n");
+			btrfs_error("unable to zero fill device\n");
 			break;
 		}
 		bytenr += len;
@@ -2345,24 +2345,24 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 
 	ret = open_ext2fs(devname, &ext2_fs);
 	if (ret) {
-		fprintf(stderr, "unable to open the Ext2fs\n");
+		btrfs_error("unable to open the Ext2fs\n");
 		goto fail;
 	}
 	blocksize = ext2_fs->blocksize;
 	total_bytes = (u64)ext2_fs->super->s_blocks_count * blocksize;
 	if (blocksize < 4096) {
-		fprintf(stderr, "block size is too small\n");
+		btrfs_error("block size is too small\n");
 		goto fail;
 	}
 	if (!(ext2_fs->super->s_feature_incompat &
 	      EXT2_FEATURE_INCOMPAT_FILETYPE)) {
-		fprintf(stderr, "filetype feature is missing\n");
+		btrfs_error("filetype feature is missing\n");
 		goto fail;
 	}
 	for (i = 0; i < 7; i++) {
 		ret = ext2_alloc_block(ext2_fs, 0, blocks + i);
 		if (ret) {
-			fprintf(stderr, "not enough free space\n");
+			btrfs_error("not enough free space\n");
 			goto fail;
 		}
 		blocks[i] *= blocksize;
@@ -2370,30 +2370,30 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 	super_bytenr = blocks[0];
 	fd = open(devname, O_RDWR);
 	if (fd < 0) {
-		fprintf(stderr, "unable to open %s\n", devname);
+		btrfs_error("unable to open %s\n", devname);
 		goto fail;
 	}
 	ret = make_btrfs(fd, devname, ext2_fs->super->s_volume_name,
 			 blocks, total_bytes, blocksize, blocksize,
 			 blocksize, blocksize);
 	if (ret) {
-		fprintf(stderr, "unable to create initial ctree\n");
+		btrfs_error("unable to create initial ctree\n");
 		goto fail;
 	}
 	/* create a system chunk that maps the whole device */
 	ret = prepare_system_chunk(fd, super_bytenr, blocksize);
 	if (ret) {
-		fprintf(stderr, "unable to update system chunk\n");
+		btrfs_error("unable to update system chunk\n");
 		goto fail;
 	}
 	root = open_ctree_fd(fd, devname, super_bytenr, O_RDWR);
 	if (!root) {
-		fprintf(stderr, "unable to open ctree\n");
+		btrfs_error("unable to open ctree\n");
 		goto fail;
 	}
 	ret = cache_free_extents(root, ext2_fs);
 	if (ret) {
-		fprintf(stderr, "error during cache_free_extents %d\n", ret);
+		btrfs_error("error during cache_free_extents %d\n", ret);
 		goto fail;
 	}
 	root->fs_info->extent_ops = &extent_ops;
@@ -2404,35 +2404,35 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 	}
 	ret = init_btrfs(root);
 	if (ret) {
-		fprintf(stderr, "unable to setup the root tree\n");
+		btrfs_error("unable to setup the root tree\n");
 		goto fail;
 	}
 	printf("creating btrfs metadata.\n");
 	ret = copy_inodes(root, ext2_fs, datacsum, packing, noxattr);
 	if (ret) {
-		fprintf(stderr, "error during copy_inodes %d\n", ret);
+		btrfs_error("error during copy_inodes %d\n", ret);
 		goto fail;
 	}
 	printf("creating ext2fs image file.\n");
 	ext2_root = link_subvol(root, "ext2_saved", EXT2_IMAGE_SUBVOL_OBJECTID);
 	if (!ext2_root) {
-		fprintf(stderr, "unable to create subvol\n");
+		btrfs_error("unable to create subvol\n");
 		goto fail;
 	}
 	ret = create_ext2_image(ext2_root, ext2_fs, "image");
 	if (ret) {
-		fprintf(stderr, "error during create_ext2_image %d\n", ret);
+		btrfs_error("error during create_ext2_image %d\n", ret);
 		goto fail;
 	}
 	printf("cleaning up system chunk.\n");
 	ret = cleanup_sys_chunk(root, ext2_root);
 	if (ret) {
-		fprintf(stderr, "error during cleanup_sys_chunk %d\n", ret);
+		btrfs_error("error during cleanup_sys_chunk %d\n", ret);
 		goto fail;
 	}
 	ret = close_ctree(root);
 	if (ret) {
-		fprintf(stderr, "error during close_ctree %d\n", ret);
+		btrfs_error("error during close_ctree %d\n", ret);
 		goto fail;
 	}
 	close_ext2fs(ext2_fs);
@@ -2443,19 +2443,19 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 	 */
 	ret = migrate_super_block(fd, super_bytenr, blocksize);
 	if (ret) {
-		fprintf(stderr, "unable to migrate super block\n");
+		btrfs_error("unable to migrate super block\n");
 		goto fail;
 	}
 
 	root = open_ctree_fd(fd, devname, 0, O_RDWR);
 	if (!root) {
-		fprintf(stderr, "unable to open ctree\n");
+		btrfs_error("unable to open ctree\n");
 		goto fail;
 	}
 	/* move chunk tree into system chunk. */
 	ret = fixup_chunk_mapping(root);
 	if (ret) {
-		fprintf(stderr, "error during fixup_chunk_tree\n");
+		btrfs_error("error during fixup_chunk_tree\n");
 		goto fail;
 	}
 	ret = close_ctree(root);
@@ -2464,7 +2464,7 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 	printf("conversion complete.\n");
 	return 0;
 fail:
-	fprintf(stderr, "conversion aborted.\n");
+	btrfs_error("conversion aborted.\n");
 	return -1;
 }
 
@@ -2543,24 +2543,24 @@ int do_rollback(const char *devname, int force)
 
 	fd = open(devname, O_RDWR);
 	if (fd < 0) {
-		fprintf(stderr, "unable to open %s\n", devname);
+		btrfs_error("unable to open %s\n", devname);
 		goto fail;
 	}
 	root = open_ctree_fd(fd, devname, 0, O_RDWR);
 	if (!root) {
-		fprintf(stderr, "unable to open ctree\n");
+		btrfs_error("unable to open ctree\n");
 		goto fail;
 	}
 	ret = may_rollback(root);
 	if (ret < 0) {
-		fprintf(stderr, "unable to do rollback\n");
+		btrfs_error("unable to do rollback\n");
 		goto fail;
 	}
 
 	sectorsize = root->sectorsize;
 	buf = malloc(sectorsize);
 	if (!buf) {
-		fprintf(stderr, "unable to allocate memory\n");
+		btrfs_error("unable to allocate memory\n");
 		goto fail;
 	}
 
@@ -2571,7 +2571,7 @@ int do_rollback(const char *devname, int force)
 	key.offset = (u64)-1;
 	ext2_root = btrfs_read_fs_root(root->fs_info, &key);
 	if (!ext2_root || IS_ERR(ext2_root)) {
-		fprintf(stderr, "unable to open subvol %llu\n",
+		btrfs_error("unable to open subvol %llu\n",
 			key.objectid);
 		goto fail;
 	}
@@ -2581,7 +2581,7 @@ int do_rollback(const char *devname, int force)
 	dir = btrfs_lookup_dir_item(NULL, ext2_root, &path,
 				   root_dir, name, strlen(name), 0);
 	if (!dir || IS_ERR(dir)) {
-		fprintf(stderr, "unable to find file %s\n", name);
+		btrfs_error("unable to find file %s\n", name);
 		goto fail;
 	}
 	leaf = path.nodes[0];
@@ -2592,7 +2592,7 @@ int do_rollback(const char *devname, int force)
 
 	ret = btrfs_lookup_inode(NULL, ext2_root, &path, &key, 0);
 	if (ret) {
-		fprintf(stderr, "unable to find inode item\n");
+		btrfs_error("unable to find inode item\n");
 		goto fail;
 	}
 	leaf = path.nodes[0];
@@ -2605,7 +2605,7 @@ int do_rollback(const char *devname, int force)
 	btrfs_set_key_type(&key, BTRFS_EXTENT_DATA_KEY);
 	ret = btrfs_search_slot(NULL, ext2_root, &key, &path, 0, 0);
 	if (ret != 0) {
-		fprintf(stderr, "unable to find first file extent\n");
+		btrfs_error("unable to find first file extent\n");
 		btrfs_release_path(ext2_root, &path);
 		goto fail;
 	}
@@ -2660,7 +2660,7 @@ next_extent:
 	btrfs_release_path(ext2_root, &path);
 
 	if (offset < total_bytes) {
-		fprintf(stderr, "unable to build extent mapping\n");
+		btrfs_error("unable to build extent mapping\n");
 		goto fail;
 	}
 
@@ -2668,7 +2668,7 @@ next_extent:
 	first_free &= ~((u64)sectorsize - 1);
 	/* backup for extent #0 should exist */
 	if(!test_range_bit(&io_tree, 0, first_free - 1, EXTENT_LOCKED, 1)) {
-		fprintf(stderr, "no backup for the first extent\n");
+		btrfs_error("no backup for the first extent\n");
 		goto fail;
 	}
 	/* force no allocation from system block group */
@@ -2709,13 +2709,13 @@ next_extent:
 	}
 	/* only extent #0 left in system block group? */
 	if (num_bytes > first_free) {
-		fprintf(stderr, "unable to empty system block group\n");
+		btrfs_error("unable to empty system block group\n");
 		goto fail;
 	}
 	/* create a system chunk that maps the whole device */
 	ret = prepare_system_chunk_sb(&root->fs_info->super_copy);
 	if (ret) {
-		fprintf(stderr, "unable to update system chunk\n");
+		btrfs_error("unable to update system chunk\n");
 		goto fail;
 	}
 
@@ -2724,7 +2724,7 @@ next_extent:
 
 	ret = close_ctree(root);
 	if (ret) {
-		fprintf(stderr, "error during close_ctree %d\n", ret);
+		btrfs_error("error during close_ctree %d\n", ret);
 		goto fail;
 	}
 
@@ -2758,13 +2758,13 @@ next_extent:
 			}
 			ret = pread(fd, buf, sectorsize, bytenr);
 			if (ret < 0) {
-				fprintf(stderr, "error during pread %d\n", ret);
+				btrfs_error("error during pread %d\n", ret);
 				goto fail;
 			}
 			BUG_ON(ret != sectorsize);
 			ret = pwrite(fd, buf, sectorsize, start);
 			if (ret < 0) {
-				fprintf(stderr, "error during pwrite %d\n", ret);
+				btrfs_error("error during pwrite %d\n", ret);
 				goto fail;
 			}
 			BUG_ON(ret != sectorsize);
@@ -2776,7 +2776,7 @@ next_sector:
 
 	ret = fsync(fd);
 	if (ret) {
-		fprintf(stderr, "error during fsync %d\n", ret);
+		btrfs_error("error during fsync %d\n", ret);
 		goto fail;
 	}
 	/*
@@ -2784,19 +2784,19 @@ next_sector:
 	 */
 	ret = pread(fd, buf, sectorsize, sb_bytenr);
 	if (ret < 0) {
-		fprintf(stderr, "error during pread %d\n", ret);
+		btrfs_error("error during pread %d\n", ret);
 		goto fail;
 	}
 	BUG_ON(ret != sectorsize);
 	ret = pwrite(fd, buf, sectorsize, BTRFS_SUPER_INFO_OFFSET);
 	if (ret < 0) {
-		fprintf(stderr, "error during pwrite %d\n", ret);
+		btrfs_error("error during pwrite %d\n", ret);
 		goto fail;
 	}
 	BUG_ON(ret != sectorsize);
 	ret = fsync(fd);
 	if (ret) {
-		fprintf(stderr, "error during fsync %d\n", ret);
+		btrfs_error("error during fsync %d\n", ret);
 		goto fail;
 	}
 
@@ -2806,7 +2806,7 @@ next_sector:
 	printf("rollback complete.\n");
 	return 0;
 fail:
-	fprintf(stderr, "rollback aborted.\n");
+	btrfs_error("rollback aborted.\n");
 	return -1;
 }
 
@@ -2857,7 +2857,7 @@ int main(int argc, char *argv[])
 
 	file = argv[optind];
 	if (check_mounted(file)) {
-		fprintf(stderr, "%s is mounted\n", file);
+		btrfs_error("%s is mounted\n", file);
 		return 1;
 	}
 
diff --git a/debug-tree.c b/debug-tree.c
index 0525354..5e1f005 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -27,11 +27,12 @@
 #include "print-tree.h"
 #include "transaction.h"
 #include "version.h"
+#include "utils.h"
 
 static int print_usage(void)
 {
-	fprintf(stderr, "usage: debug-tree [ -e ] device\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+	btrfs_error("usage: debug-tree [ -e ] device\n");
+	btrfs_error("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
 
@@ -147,7 +148,7 @@ int main(int ac, char **av)
 
 	root = open_ctree(av[optind], 0, 0);
 	if (!root) {
-		fprintf(stderr, "unable to open %s\n", av[optind]);
+		btrfs_error("unable to open %s\n", av[optind]);
 		exit(1);
 	}
 	if (block_only) {
@@ -166,7 +167,7 @@ int main(int ac, char **av)
 					      root->nodesize, 0);
 		}
 		if (!leaf) {
-			fprintf(stderr, "failed to read %llu\n", block_only);
+			btrfs_error("failed to read %llu\n", block_only);
 			return 0;
 		}
 		btrfs_print_tree(root, leaf, 0);
diff --git a/dir-test.c b/dir-test.c
index 3ae9c68..c808b0a 100644
--- a/dir-test.c
+++ b/dir-test.c
@@ -348,7 +348,7 @@ static int empty_tree(struct btrfs_trans_handle *trans, struct btrfs_root
 			break;
 	}
 	return 0;
-	fprintf(stderr, "failed to delete from the radix %lu\n", found);
+	btrfs_error("failed to delete from the radix %lu\n", found);
 	return -1;
 }
 
@@ -360,13 +360,13 @@ static int fill_tree(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	for (i = 0; i < count; i++) {
 		ret = ins_one(trans, root, radix);
 		if (ret) {
-			fprintf(stderr, "fill failed\n");
+			btrfs_error("fill failed\n");
 			goto out;
 		}
 		if (i % 1000 == 0) {
 			ret = btrfs_commit_transaction(trans, root, &super);
 			if (ret) {
-				fprintf(stderr, "fill commit failed\n");
+				btrfs_error("fill commit failed\n");
 				return ret;
 			}
 		}
@@ -408,7 +408,7 @@ int (*ops[])(struct btrfs_trans_handle *trans, struct btrfs_root *root, struct
 void sigstopper(int ignored)
 {
 	keep_running = 0;
-	fprintf(stderr, "caught exit signal, stopping\n");
+	btrfs_error("caught exit signal, stopping\n");
 }
 
 int print_usage(void)
@@ -483,10 +483,10 @@ int main(int ac, char **av)
 		while(count--) {
 			ret = ops[op](trans, root, &radix);
 			if (ret) {
-				fprintf(stderr, "op %d failed %d:%d\n",
+				btrfs_error("op %d failed %d:%d\n",
 					op, i, iterations);
 				btrfs_print_tree(root, root->node, 1);
-				fprintf(stderr, "op %d failed %d:%d\n",
+				btrfs_error("op %d failed %d:%d\n",
 					op, i, iterations);
 				err = ret;
 				goto out;
diff --git a/disk-io.c b/disk-io.c
index a6e1000..e8793c0 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -581,7 +581,7 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes)
 
 	fp = open(filename, flags, 0600);
 	if (fp < 0) {
-		fprintf (stderr, "Could not open %s\n", filename);
+		btrfs_error("Could not open %s\n", filename);
 		return NULL;
 	}
 	root = open_ctree_fd(fp, filename, sb_bytenr, writes);
@@ -619,7 +619,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				    &total_devs, sb_bytenr);
 
 	if (ret) {
-		fprintf(stderr, "No valid Btrfs found on %s\n", path);
+		btrfs_error("No valid Btrfs found on %s\n", path);
 		return NULL;
 	}
 
@@ -920,7 +920,7 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 
 	ret = write_all_supers(root);
 	if (ret)
-		fprintf(stderr, "failed to write new super block err %d\n", ret);
+		btrfs_error("failed to write new super block err %d\n", ret);
 	return ret;
 }
 
diff --git a/extent_io.c b/extent_io.c
index 069c199..77a1abf 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -27,6 +27,7 @@
 #include "kerncompat.h"
 #include "extent_io.h"
 #include "list.h"
+#include "utils.h"
 
 u64 cache_max = 1024 * 1024 * 32;
 
@@ -68,7 +69,7 @@ void extent_io_tree_cleanup(struct extent_io_tree *tree)
 	while(!list_empty(&tree->lru)) {
 		eb = list_entry(tree->lru.next, struct extent_buffer, lru);
 		if (eb->refs != 1) {
-			fprintf(stderr, "extent buffer leak: "
+			btrfs_error("extent buffer leak: "
 				"start %llu len %u\n",
 				(unsigned long long)eb->start, eb->len);
 			eb->refs = 1;
diff --git a/mkfs.c b/mkfs.c
index 2e99b95..a2a5182 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -61,7 +61,7 @@ static u64 parse_size(char *s)
 		case 'b':
 			break;
 		default:
-			fprintf(stderr, "Unknown size descriptor %c\n", c);
+			btrfs_error("Unknown size descriptor %c\n", c);
 			exit(1);
 		}
 		s[len - 1] = '\0';
@@ -266,23 +266,23 @@ static int create_data_reloc_tree(struct btrfs_trans_handle *trans,
 
 static void print_usage(void)
 {
-	fprintf(stderr, "usage: mkfs.btrfs [options] dev [ dev ... ]\n");
-	fprintf(stderr, "options:\n");
-	fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
-	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
-	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid10 or single\n");
-	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
-	fprintf(stderr, "\t -L --label set a label\n");
-	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
-	fprintf(stderr, "\t -n --nodesize size of btree nodes\n");
-	fprintf(stderr, "\t -s --sectorsize min block allocation\n");
-	fprintf(stderr, "%s\n", BTRFS_BUILD_VERSION);
+	btrfs_error("usage: mkfs.btrfs [options] dev [ dev ... ]\n");
+	btrfs_error("options:\n");
+	btrfs_error("\t -A --alloc-start the offset to start the FS\n");
+	btrfs_error("\t -b --byte-count total number of bytes in the FS\n");
+	btrfs_error("\t -d --data data profile, raid0, raid1, raid10 or single\n");
+	btrfs_error("\t -l --leafsize size of btree leaves\n");
+	btrfs_error("\t -L --label set a label\n");
+	btrfs_error("\t -m --metadata metadata profile, values like data profile\n");
+	btrfs_error("\t -n --nodesize size of btree nodes\n");
+	btrfs_error("\t -s --sectorsize min block allocation\n");
+	btrfs_error("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
 
 static void print_version(void)
 {
-	fprintf(stderr, "mkfs.btrfs, part of %s\n", BTRFS_BUILD_VERSION);
+	btrfs_error("mkfs.btrfs, part of %s\n", BTRFS_BUILD_VERSION);
 	exit(0);
 }
 
@@ -297,7 +297,7 @@ static u64 parse_profile(char *s)
 	} else if (strcmp(s, "single") == 0) {
 		return 0;
 	} else {
-		fprintf(stderr, "Unknown option %s\n", s);
+		btrfs_error("Unknown option %s\n", s);
 		print_usage();
 	}
 	return 0;
@@ -309,13 +309,13 @@ static char *parse_label(char *input)
 	int len = strlen(input);
 
 	if (len > BTRFS_LABEL_SIZE) {
-		fprintf(stderr, "Label %s is too long (max %d)\n", input,
+		btrfs_error("Label %s is too long (max %d)\n", input,
 			BTRFS_LABEL_SIZE);
 		exit(1);
 	}
 	for (i = 0; i < len; i++) {
 		if (input[i] == '/' || input[i] == '\\') {
-			fprintf(stderr, "invalid label %s\n", input);
+			btrfs_error("invalid label %s\n", input);
 			exit(1);
 		}
 	}
@@ -390,7 +390,7 @@ int main(int ac, char **av)
 			case 'b':
 				block_count = parse_size(optarg);
 				if (block_count < 256*1024*1024) {
-					fprintf(stderr, "File system size "
+					btrfs_error("File system size "
 						"%llu bytes is too small, "
 						"256M is required at least\n",
 						(unsigned long long)block_count);
@@ -407,11 +407,11 @@ int main(int ac, char **av)
 	}
 	sectorsize = max(sectorsize, (u32)getpagesize());
 	if (leafsize < sectorsize || (leafsize & (sectorsize - 1))) {
-		fprintf(stderr, "Illegal leafsize %u\n", leafsize);
+		btrfs_error("Illegal leafsize %u\n", leafsize);
 		exit(1);
 	}
 	if (nodesize < sectorsize || (nodesize & (sectorsize - 1))) {
-		fprintf(stderr, "Illegal nodesize %u\n", nodesize);
+		btrfs_error("Illegal nodesize %u\n", nodesize);
 		exit(1);
 	}
 	ac = ac - optind;
@@ -424,17 +424,17 @@ int main(int ac, char **av)
 	file = av[optind++];
 	ret = check_mounted(file);
 	if (ret < 0) {
-		fprintf(stderr, "error checking %s mount status\n", file);
+		btrfs_error("error checking %s mount status\n", file);
 		exit(1);
 	}
 	if (ret == 1) {
-		fprintf(stderr, "%s is mounted\n", file);
+		btrfs_error("%s is mounted\n", file);
 		exit(1);
 	}
 	ac--;
 	fd = open(file, O_RDWR);
 	if (fd < 0) {
-		fprintf(stderr, "unable to open %s\n", file);
+		btrfs_error("unable to open %s\n", file);
 		exit(1);
 	}
 	first_fd = fd;
@@ -453,7 +453,7 @@ int main(int ac, char **av)
 			 nodesize, leafsize,
 			 sectorsize, stripesize);
 	if (ret) {
-		fprintf(stderr, "error during mkfs %d\n", ret);
+		btrfs_error("error during mkfs %d\n", ret);
 		exit(1);
 	}
 	root = open_ctree(file, 0, O_RDWR);
@@ -461,7 +461,7 @@ int main(int ac, char **av)
 
 	ret = make_root_dir(root);
 	if (ret) {
-		fprintf(stderr, "failed to setup the root directory\n");
+		btrfs_error("failed to setup the root directory\n");
 		exit(1);
 	}
 
@@ -472,7 +472,7 @@ int main(int ac, char **av)
 
 	btrfs_register_one_device(file);
 	if (!root) {
-		fprintf(stderr, "ctree init failed\n");
+		btrfs_error("ctree init failed\n");
 		return -1;
 	}
 
@@ -481,23 +481,23 @@ int main(int ac, char **av)
 		file = av[optind++];
 		ret = check_mounted(file);
 		if (ret < 0) {
-			fprintf(stderr, "error checking %s mount status\n",
+			btrfs_error("error checking %s mount status\n",
 				file);
 			exit(1);
 		}
 		if (ret == 1) {
-			fprintf(stderr, "%s is mounted\n", file);
+			btrfs_error("%s is mounted\n", file);
 			exit(1);
 		}
 		fd = open(file, O_RDWR);
 		if (fd < 0) {
-			fprintf(stderr, "unable to open %s\n", file);
+			btrfs_error("unable to open %s\n", file);
 			exit(1);
 		}
 		ret = btrfs_device_already_in_root(root, fd,
 						   BTRFS_SUPER_INFO_OFFSET);
 		if (ret) {
-			fprintf(stderr, "skipping duplicate device %s in FS\n",
+			btrfs_error("skipping duplicate device %s in FS\n",
 				file);
 			close(fd);
 			continue;
diff --git a/print-tree.c b/print-tree.c
index ac575d5..ebda4b6 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -24,6 +24,7 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "print-tree.h"
+#include "utils.h"
 
 static int print_dir_item(struct extent_buffer *eb, struct btrfs_item *item,
 			  struct btrfs_dir_item *di)
@@ -655,7 +656,7 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 					     size,
 					     btrfs_node_ptr_generation(eb, i));
 		if (!next) {
-			fprintf(stderr, "failed to read %llu in tree %llu\n",
+			btrfs_error("failed to read %llu in tree %llu\n",
 				(unsigned long long)btrfs_node_blockptr(eb, i),
 				(unsigned long long)btrfs_header_owner(eb));
 			continue;
diff --git a/quick-test.c b/quick-test.c
index fa6fd83..15a147e 100644
--- a/quick-test.c
+++ b/quick-test.c
@@ -60,7 +60,7 @@ int main(int ac, char **av) {
 		// num = i;
 		sprintf(buf, "string-%d", num);
 		if (i % 10000 == 0)
-			fprintf(stderr, "insert %d:%d\n", num, i);
+			btrfs_error("insert %d:%d\n", num, i);
 		ins.objectid = num;
 		ins.offset = 0;
 		ret = btrfs_insert_item(trans, root, &ins, buf, 512);
@@ -82,7 +82,7 @@ int main(int ac, char **av) {
 		ins.objectid = num;
 		btrfs_init_path(&path);
 		if (i % 10000 == 0)
-			fprintf(stderr, "search %d:%d\n", num, i);
+			btrfs_error("search %d:%d\n", num, i);
 		ret = btrfs_search_slot(NULL, root, &ins, &path, 0, 0);
 		if (ret) {
 			btrfs_print_tree(root, root->node, 1);
@@ -110,7 +110,7 @@ int main(int ac, char **av) {
 		ret = btrfs_search_slot(trans, root, &ins, &path, -1, 1);
 		if (!ret) {
 			if (i % 10000 == 0)
-				fprintf(stderr, "del %d:%d\n", num, i);
+				btrfs_error("del %d:%d\n", num, i);
 			ret = btrfs_del_item(trans, root, &path);
 			if (ret != 0)
 				BUG();
@@ -129,7 +129,7 @@ int main(int ac, char **av) {
 		sprintf(buf, "string-%d", num);
 		ins.objectid = num;
 		if (i % 10000 == 0)
-			fprintf(stderr, "insert %d:%d\n", num, i);
+			btrfs_error("insert %d:%d\n", num, i);
 		ret = btrfs_insert_item(trans, root, &ins, buf, 512);
 		if (!ret)
 			tree_size++;
@@ -145,7 +145,7 @@ int main(int ac, char **av) {
 		ins.objectid = num;
 		btrfs_init_path(&path);
 		if (i % 10000 == 0)
-			fprintf(stderr, "search %d:%d\n", num, i);
+			btrfs_error("search %d:%d\n", num, i);
 		ret = btrfs_search_slot(NULL, root, &ins, &path, 0, 0);
 		if (ret) {
 			btrfs_print_tree(root, root->node, 1);
diff --git a/random-test.c b/random-test.c
index 0003236..9e1ac93 100644
--- a/random-test.c
+++ b/random-test.c
@@ -220,7 +220,7 @@ static int empty_tree(struct btrfs_trans_handle *trans, struct btrfs_root
 	}
 	return 0;
 error:
-	fprintf(stderr, "failed to delete from the radix %lu\n", found);
+	btrfs_error("failed to delete from the radix %lu\n", found);
 	return -1;
 }
 
@@ -232,13 +232,13 @@ static int fill_tree(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	for (i = 0; i < count; i++) {
 		ret = ins_one(trans, root, radix);
 		if (ret) {
-			fprintf(stderr, "fill failed\n");
+			btrfs_error("fill failed\n");
 			goto out;
 		}
 		if (i % 1000 == 0) {
 			ret = btrfs_commit_transaction(trans, root, &super);
 			if (ret) {
-				fprintf(stderr, "fill commit failed\n");
+				btrfs_error("fill commit failed\n");
 				return ret;
 			}
 		}
@@ -329,7 +329,7 @@ static int fill_radix(struct btrfs_root *root, struct radix_tree_root *radix)
 void sigstopper(int ignored)
 {
 	keep_running = 0;
-	fprintf(stderr, "caught exit signal, stopping\n");
+	btrfs_error("caught exit signal, stopping\n");
 }
 
 int print_usage(void)
@@ -402,10 +402,10 @@ int main(int ac, char **av)
 		while(count--) {
 			ret = ops[op](trans, root, &radix);
 			if (ret) {
-				fprintf(stderr, "op %d failed %d:%d\n",
+				btrfs_error("op %d failed %d:%d\n",
 					op, i, iterations);
 				btrfs_print_tree(root, root->node, 1);
-				fprintf(stderr, "op %d failed %d:%d\n",
+				btrfs_error("op %d failed %d:%d\n",
 					op, i, iterations);
 				err = ret;
 				goto out;
diff --git a/utils.c b/utils.c
index fd894f3..4f8e97e 100644
--- a/utils.c
+++ b/utils.c
@@ -520,25 +520,25 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret)
 
 	ret = fstat(fd, &st);
 	if (ret < 0) {
-		fprintf(stderr, "unable to stat %s\n", file);
+		btrfs_error("unable to stat %s\n", file);
 		exit(1);
 	}
 
 	block_count = device_size(fd, &st);
 	if (block_count == 0) {
-		fprintf(stderr, "unable to find %s size\n", file);
+		btrfs_error("unable to find %s size\n", file);
 		exit(1);
 	}
 	zero_end = 1;
 
 	if (block_count < 256 * 1024 * 1024) {
-		fprintf(stderr, "device %s is too small "
+		btrfs_error("device %s is too small "
 		        "(must be at least 256 MB)\n", file);
 		exit(1);
 	}
 	ret = zero_dev_start(fd);
 	if (ret) {
-		fprintf(stderr, "failed to zero device start %d\n", ret);
+		btrfs_error("failed to zero device start %d\n", ret);
 		exit(1);
 	}
 
@@ -552,7 +552,7 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret)
 	if (zero_end) {
 		ret = zero_dev_end(fd, block_count);
 		if (ret) {
-			fprintf(stderr, "failed to zero device end %d\n", ret);
+			btrfs_error("failed to zero device end %d\n", ret);
 			exit(1);
 		}
 	}
@@ -759,7 +759,7 @@ int check_mounted(const char* file)
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0) {
-		fprintf (stderr, "check_mounted(): Could not open %s\n", file);
+		btrfs_error("check_mounted(): Could not open %s\n", file);
 		return -errno;
 	}
 
@@ -824,7 +824,7 @@ void btrfs_register_one_device(char *fname)
 
 	fd = open("/dev/btrfs-control", O_RDONLY);
 	if (fd < 0) {
-		fprintf(stderr, "failed to open /dev/btrfs-control "
+		btrfs_error("failed to open /dev/btrfs-control "
 			"skipping device registration\n");
 		return;
 	}
@@ -867,7 +867,7 @@ again:
 	}
 	dirp = opendir(dirname);
 	if (!dirp) {
-		fprintf(stderr, "Unable to open /sys/block for scanning\n");
+		btrfs_error("Unable to open /sys/block for scanning\n");
 		return -ENOENT;
 	}
 	while(1) {
@@ -883,7 +883,7 @@ again:
 		snprintf(fullpath, pathlen, "%s/%s", dirname, dirent->d_name);
 		ret = lstat(fullpath, &st);
 		if (ret < 0) {
-			fprintf(stderr, "failed to stat %s\n", fullpath);
+			btrfs_error("failed to stat %s\n", fullpath);
 			continue;
 		}
 		if (S_ISLNK(st.st_mode))
@@ -902,7 +902,7 @@ again:
 		}
 		fd = open(fullpath, O_RDONLY);
 		if (fd < 0) {
-			fprintf(stderr, "failed to read %s\n", fullpath);
+			btrfs_error("failed to read %s\n", fullpath);
 			continue;
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
diff --git a/utils.h b/utils.h
index 9dce5b0..06df856 100644
--- a/utils.h
+++ b/utils.h
@@ -19,7 +19,10 @@
 #ifndef __UTILS__
 #define __UTILS__
 
+#include "ctree.h"
+
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
+#define btrfs_error(...) fprintf(stderr, __VA_ARGS__)
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
-- 
1.7.1


--=-/rS7Zs4YBfhLIwTs6HoD--

