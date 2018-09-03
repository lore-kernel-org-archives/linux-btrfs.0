Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:49718 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbeICQGW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2018 12:06:22 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Mon,  3 Sep 2018 13:46:23 +0200
Message-Id: <20180903114623.14683-1-kilobyte@angband.pl>
In-Reply-To: <c47c376f-68c6-c00c-80eb-0a6dd95d5ac1@suse.com>
References: <c47c376f-68c6-c00c-80eb-0a6dd95d5ac1@suse.com>
MIME-Version: 1.0
Subject: [PATCH v3] btrfs-progs: defrag: open files RO on new enough kernels
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Defragging an executable conflicts both way with it being run, resulting in
ETXTBSY.  This either makes defrag fail or prevents the program from being
executed.

Kernels 4.19-rc1 and later allow defragging files you could have possibly
opened rw, even if the passed descriptor is ro (commit 616d374efa23).

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
v2: more eloquent description; root can't defrag RO on old kernels (unlike
dedupe)
v3: more eloquentier description; s/defrag_ro/defrag_open_mode/

 cmds-filesystem.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 06c8311b..99e2aec0 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -26,6 +26,7 @@
 #include <ftw.h>
 #include <mntent.h>
 #include <linux/limits.h>
+#include <linux/version.h>
 #include <getopt.h>
 
 #include <btrfsutil.h>
@@ -39,12 +40,14 @@
 #include "list_sort.h"
 #include "disk-io.h"
 #include "help.h"
+#include "fsfeatures.h"
 
 /*
  * for btrfs fi show, we maintain a hash of fsids we've already printed.
  * This way we don't print dups if a given FS is mounted more than once.
  */
 static struct seen_fsid *seen_fsid_hash[SEEN_FSID_HASH_SIZE] = {NULL,};
+static mode_t defrag_open_mode = O_RDONLY;
 
 static const char * const filesystem_cmd_group_usage[] = {
 	"btrfs filesystem [<group>] <command> [<args>]",
@@ -877,7 +880,7 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
 	if ((typeflag == FTW_F) && S_ISREG(sb->st_mode)) {
 		if (defrag_global_verbose)
 			printf("%s\n", fpath);
-		fd = open(fpath, O_RDWR);
+		fd = open(fpath, defrag_open_mode);
 		if (fd < 0) {
 			goto error;
 		}
@@ -914,6 +917,9 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 	int compress_type = BTRFS_COMPRESS_NONE;
 	DIR *dirstream;
 
+	if (get_running_kernel_version() < KERNEL_VERSION(4,19,0))
+		defrag_open_mode = O_RDWR;
+
 	/*
 	 * Kernel has a different default (256K) that is supposed to be safe,
 	 * but it does not defragment very well. The 32M will likely lead to
@@ -1014,7 +1020,7 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 		int defrag_err = 0;
 
 		dirstream = NULL;
-		fd = open_file_or_dir(argv[i], &dirstream);
+		fd = open_file_or_dir3(argv[i], &dirstream, defrag_open_mode);
 		if (fd < 0) {
 			error("cannot open %s: %m", argv[i]);
 			ret = -errno;
-- 
2.19.0.rc1
