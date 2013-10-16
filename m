Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760237Ab3JPTxM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 15:53:12 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B8904A5879
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 21:53:11 +0200 (CEST)
Message-ID: <525EEEA5.3080300@suse.com>
Date: Wed, 16 Oct 2013 15:53:09 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-filesystem: report size of global metadata reservation
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With the introduction of the global metadata reservation, the
simple difference between total and used is no longer enough
to determine what amount of usable space is free for new objects
to use. This results in bug reports that can be a pain to track
down since there's no real other way to gather the info.

This patch uses the new BTRFS_IOC_GLOBAL_RSV ioctl to gather
and publish the size of the reservation. It's displayed as
associated with the first space_info that has the metadata
bit set as that is also how it's associated in the kernel.

Example output:
Metadata, DUP: total=1.00GB, used=673.20MB, reserved=226.00MB

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 cmds-filesystem.c | 29 +++++++++++++++++++++++++++--
 ioctl.h           |  1 +
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..ddc3635 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -47,7 +47,7 @@ static const char * const cmd_df_usage[] = {
 static int cmd_df(int argc, char **argv)
 {
 	struct btrfs_ioctl_space_args *sargs, *sargs_orig;
-	u64 count = 0, i;
+	u64 count = 0, i, reserved = ~0ULL;
 	int ret;
 	int fd;
 	int e;
@@ -109,6 +109,20 @@ static int cmd_df(int argc, char **argv)
 		return ret;
 	}
 
+	ret = ioctl(fd, BTRFS_IOC_GLOBAL_RSV, &reserved);
+	e = errno;
+	if (ret && e == ENOTTY)
+		ret = 0;
+
+	if (ret) {
+		fprintf(stderr,
+			"ERROR: couldn't get size of global metadata reservation on '%s' - %s\n",
+			path, strerror(e));
+		close(fd);
+		free(sargs);
+		return ret;
+	}
+
 	for (i = 0; i < sargs->total_spaces; i++) {
 		char description[80];
 		char *total_bytes;
@@ -157,8 +171,19 @@ static int cmd_df(int argc, char **argv)
 
 		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
 		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
-		printf("%s: total=%s, used=%s\n", description, total_bytes,
+		printf("%s: total=%s, used=%s", description, total_bytes,
 		       used_bytes);
+
+		if ((flags & BTRFS_BLOCK_GROUP_METADATA) && reserved != ~0ULL) {
+			char *reserved_bytes = pretty_sizes(reserved);
+			reserved = ~0ULL;
+			printf(", reserved=%s", reserved_bytes);
+			free(reserved_bytes);
+		}
+
+		printf("\n");
+		free(total_bytes);
+		free(used_bytes);
 	}
 	close(fd);
 	free(sargs);
diff --git a/ioctl.h b/ioctl.h
index abe6dd4..03fe5cb 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -487,6 +487,7 @@ struct btrfs_ioctl_clone_range_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_GLOBAL_RSV _IOR(BTRFS_IOCTL_MAGIC, 20, __u64)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_SUBVOL_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 24, \

