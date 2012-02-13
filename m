From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: convert: set label or copy from origin
Date: Tue, 14 Feb 2012 00:56:46 +0100
Message-ID: <1329177406-3538-1-git-send-email-dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 convert.c |   46 ++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/convert.c b/convert.c
index 13f3ece..3e74108 100644
--- a/convert.c
+++ b/convert.c
@@ -2332,7 +2332,8 @@ err:
 	return ret;
 }
 
-int do_convert(const char *devname, int datacsum, int packing, int noxattr)
+int do_convert(const char *devname, int datacsum, int packing, int noxattr,
+	       int copylabel, const char *fslabel)
 {
 	int i, fd, ret;
 	u32 blocksize;
@@ -2424,6 +2425,17 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 		fprintf(stderr, "error during create_ext2_image %d\n", ret);
 		goto fail;
 	}
+	memset(root->fs_info->super_copy.label, 0, BTRFS_LABEL_SIZE);
+	if (copylabel == 1) {
+		strncpy(root->fs_info->super_copy.label,
+				ext2_fs->super->s_volume_name, 16);
+		fprintf(stderr, "copy label '%s'\n",
+				root->fs_info->super_copy.label);
+	} else if (copylabel == -1) {
+		strncpy(root->fs_info->super_copy.label, fslabel, BTRFS_LABEL_SIZE);
+		fprintf(stderr, "set label to '%s'\n", fslabel);
+	}
+
 	printf("cleaning up system chunk.\n");
 	ret = cleanup_sys_chunk(root, ext2_root);
 	if (ret) {
@@ -2812,11 +2824,13 @@ fail:
 
 static void print_usage(void)
 {
-	printf("usage: btrfs-convert [-d] [-i] [-n] [-r] device\n");
-	printf("\t-d disable data checksum\n");
-	printf("\t-i ignore xattrs and ACLs\n");
-	printf("\t-n disable packing of small files\n");
-	printf("\t-r roll back to ext2fs\n");
+	printf("usage: btrfs-convert [-d] [-i] [-n] [-r] [-l label] [-L] device\n");
+	printf("\t-d           disable data checksum\n");
+	printf("\t-i           ignore xattrs and ACLs\n");
+	printf("\t-n           disable packing of small files\n");
+	printf("\t-r           roll back to ext2fs\n");
+	printf("\t-l LABEL     set filesystem label\n");
+	printf("\t-L           use label from converted fs\n");
 }
 
 int main(int argc, char *argv[])
@@ -2826,9 +2840,12 @@ int main(int argc, char *argv[])
 	int noxattr = 0;
 	int datacsum = 1;
 	int rollback = 0;
+	int copylabel = 0;
 	char *file;
+	char *fslabel = NULL;
+
 	while(1) {
-		int c = getopt(argc, argv, "dinr");
+		int c = getopt(argc, argv, "dinrl:L");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -2844,6 +2861,19 @@ int main(int argc, char *argv[])
 			case 'r':
 				rollback = 1;
 				break;
+			case 'l':
+				copylabel = -1;
+				fslabel = strdup(optarg);
+				if (strlen(fslabel) > BTRFS_LABEL_SIZE) {
+					fprintf(stderr,
+						"warning: label too long, trimmed to %d bytes\n",
+						BTRFS_LABEL_SIZE);
+					fslabel[BTRFS_LABEL_SIZE]=0;
+				}
+				break;
+			case 'L':
+				copylabel = 1;
+				break;
 			default:
 				print_usage();
 				return 1;
@@ -2864,7 +2894,7 @@ int main(int argc, char *argv[])
 	if (rollback) {
 		ret = do_rollback(file, 0);
 	} else {
-		ret = do_convert(file, datacsum, packing, noxattr);
+		ret = do_convert(file, datacsum, packing, noxattr, copylabel, fslabel);
 	}
 	if (ret)
 		return 1;
-- 
1.7.6.233.gd79bc

