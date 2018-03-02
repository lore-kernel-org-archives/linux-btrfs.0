Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60093 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1947447AbeCBSrQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 13:47:16 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E7F4DAE8B
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Mar 2018 18:47:14 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 3/8] btrfs-progs: constify pathnames passed as arguments
Date: Fri,  2 Mar 2018 13:46:59 -0500
Message-Id: <20180302184704.22399-4-jeffm@suse.com>
In-Reply-To: <20180302184704.22399-1-jeffm@suse.com>
References: <20180302184704.22399-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

It's unlikely we're going to modify a pathname argument, so codify that
and use const.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 chunk-recover.c | 4 ++--
 cmds-device.c   | 2 +-
 cmds-fi-usage.c | 6 +++---
 cmds-rescue.c   | 4 ++--
 send-utils.c    | 4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 705bcf52..1d30db51 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1492,7 +1492,7 @@ out:
 	return ERR_PTR(ret);
 }
 
-static int recover_prepare(struct recover_control *rc, char *path)
+static int recover_prepare(struct recover_control *rc, const char *path)
 {
 	int ret;
 	int fd;
@@ -2296,7 +2296,7 @@ static void validate_rebuild_chunks(struct recover_control *rc)
 /*
  * Return 0 when successful, < 0 on error and > 0 if aborted by user
  */
-int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
+int btrfs_recover_chunk_tree(const char *path, int verbose, int yes)
 {
 	int ret = 0;
 	struct btrfs_root *root = NULL;
diff --git a/cmds-device.c b/cmds-device.c
index 86459d1b..a49c9d9d 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -526,7 +526,7 @@ static const char * const cmd_device_usage_usage[] = {
 	NULL
 };
 
-static int _cmd_device_usage(int fd, char *path, unsigned unit_mode)
+static int _cmd_device_usage(int fd, const char *path, unsigned unit_mode)
 {
 	int i;
 	int ret = 0;
diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index de7ad668..9a1c76ab 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -227,7 +227,7 @@ static int cmp_btrfs_ioctl_space_info(const void *a, const void *b)
 /*
  * This function load all the information about the space usage
  */
-static struct btrfs_ioctl_space_args *load_space_info(int fd, char *path)
+static struct btrfs_ioctl_space_args *load_space_info(int fd, const char *path)
 {
 	struct btrfs_ioctl_space_args *sargs = NULL, *sargs_orig = NULL;
 	int ret, count;
@@ -305,7 +305,7 @@ static void get_raid56_used(struct chunk_info *chunks, int chunkcount,
 #define	MIN_UNALOCATED_THRESH	SZ_16M
 static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		int chunkcount, struct device_info *devinfo, int devcount,
-		char *path, unsigned unit_mode)
+		const char *path, unsigned unit_mode)
 {
 	struct btrfs_ioctl_space_args *sargs = NULL;
 	int i;
@@ -931,7 +931,7 @@ static void _cmd_filesystem_usage_linear(unsigned unit_mode,
 static int print_filesystem_usage_by_chunk(int fd,
 		struct chunk_info *chunkinfo, int chunkcount,
 		struct device_info *devinfo, int devcount,
-		char *path, unsigned unit_mode, int tabular)
+		const char *path, unsigned unit_mode, int tabular)
 {
 	struct btrfs_ioctl_space_args *sargs;
 	int ret = 0;
diff --git a/cmds-rescue.c b/cmds-rescue.c
index c40088ad..c61145bc 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -32,8 +32,8 @@ static const char * const rescue_cmd_group_usage[] = {
 	NULL
 };
 
-int btrfs_recover_chunk_tree(char *path, int verbose, int yes);
-int btrfs_recover_superblocks(char *path, int verbose, int yes);
+int btrfs_recover_chunk_tree(const char *path, int verbose, int yes);
+int btrfs_recover_superblocks(const char *path, int verbose, int yes);
 
 static const char * const cmd_rescue_chunk_recover_usage[] = {
 	"btrfs rescue chunk-recover [options] <device>",
diff --git a/send-utils.c b/send-utils.c
index b5289e76..8ce94de1 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -28,8 +28,8 @@
 #include "ioctl.h"
 #include "btrfs-list.h"
 
-static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
-				      u64 subvol_id);
+static int btrfs_subvolid_resolve_sub(int fd, char *path,
+				      size_t *path_len, u64 subvol_id);
 
 static int btrfs_get_root_id_by_sub_path(int mnt_fd, const char *sub_path,
 					 u64 *root_id)
-- 
2.15.1

