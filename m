Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758189AbaD2QCd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 12:02:33 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1DD3BAC4F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 16:02:33 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 09/14] btrfs-progs: add section of overall filesystem usage
Date: Tue, 29 Apr 2014 18:02:30 +0200
Message-Id: <f654600bbcbf756d6f6584768808ab2e669cb6eb.1398786620.git.dsterba@suse.cz>
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The 'fi usage' lacks an overall report, this used to be in the enhanced
df command. Add it back.

Sample:
Overall:
    Device size:                  35.00GiB
    Device allocated:              8.07GiB
    Device unallocated:           26.93GiB
    Used:                          1.12MiB
    Free (Estimated):             17.57GiB      (Max: 30.98GiB, min: 17.52GiB)
    Data to device ratio:             50 %
...

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-fi-disk_usage.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 7d0334086dbd..d76fa3552136 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -302,8 +302,6 @@ static struct btrfs_ioctl_space_args *load_space_info(int fd, char *path)
 	return sargs;
 }
 
-/* Not used, keep for later */
-#if 0
 /*
  * This function computes the space occuped by a *single* RAID5/RAID6 chunk.
  * The computation is performed on the basis of the number of stripes
@@ -331,7 +329,6 @@ static int get_raid56_used(int fd, u64 *raid5_used, u64 *raid6_used)
 	free(info_ptr);
 
 	return 0;
-
 }
 
 static int _cmd_disk_free(int fd, char *path, int mode)
@@ -416,22 +413,24 @@ static int _cmd_disk_free(int fd, char *path, int mode)
 	else
 		width = 18;
 
-	printf("Disk size:\t\t%*s\n", width,
+	printf("Overall:\n");
+
+	printf("    Device size:\t\t%*s\n", width,
 		df_pretty_sizes(total_disk, mode));
-	printf("Disk allocated:\t\t%*s\n", width,
+	printf("    Device allocated:\t\t%*s\n", width,
 		df_pretty_sizes(total_chunks, mode));
-	printf("Disk unallocated:\t%*s\n", width,
+	printf("    Device unallocated:\t\t%*s\n", width,
 		df_pretty_sizes(total_disk-total_chunks, mode));
-	printf("Used:\t\t\t%*s\n", width,
+	printf("    Used:\t\t\t%*s\n", width,
 		df_pretty_sizes(total_used, mode));
-	printf("Free (Estimated):\t%*s\t(",
+	printf("    Free (Estimated):\t\t%*s\t(",
 		width,
 		df_pretty_sizes((u64)(K*total_disk-total_used), mode));
 	printf("Max: %s, ",
 		df_pretty_sizes(total_disk-total_chunks+total_free, mode));
 	printf("min: %s)\n",
 		df_pretty_sizes((total_disk-total_chunks)/2+total_free, mode));
-	printf("Data to disk ratio:\t%*.0f %%\n",
+	printf("    Data to device ratio:\t%*.0f %%\n",
 		width-2, K*100);
 
 exit:
@@ -441,7 +440,6 @@ exit:
 
 	return ret;
 }
-#endif
 
 /*
  *  Helper to sort the device_info structure
@@ -826,8 +824,6 @@ int cmd_filesystem_usage(int argc, char **argv)
 	for (i = optind; i < argc ; i++) {
 		int r, fd;
 		DIR	*dirstream = NULL;
-		if (more_than_one)
-			printf("\n");
 
 		fd = open_file_or_dir(argv[i], &dirstream);
 		if (fd < 0) {
@@ -835,6 +831,11 @@ int cmd_filesystem_usage(int argc, char **argv)
 				argv[1]);
 			return 12;
 		}
+		if (more_than_one)
+			printf("\n");
+
+		r = _cmd_disk_free(fd, argv[i], flags);
+		printf("\n");
 		r = _cmd_filesystem_usage(fd, argv[i], flags, tabular);
 		close_file_or_dir(fd, dirstream);
 
-- 
1.9.0

