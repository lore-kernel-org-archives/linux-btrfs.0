Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbaJGRHr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Oct 2014 13:07:47 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B865FAB07
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Oct 2014 17:07:45 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: rework calculations of fi usage
Date: Tue,  7 Oct 2014 19:07:44 +0200
Message-Id: <1412701664-31275-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch reworks the basic calculations of 'fi usage'. It does not address
all problems but should make the code more prepared to do so.

The original code tries to estimate the free space that could lead to negative
numbers for some raid profiles:

Data, RAID1: total=147.00GiB, used=141.92GiB
System, RAID1: total=32.00MiB, used=36.00KiB
Metadata, RAID1: total=2.00GiB, used=1.17GiB
GlobalReserve, single: total=404.00MiB, used=0.00B

Overall:
    Device size:                 279.46GiB
    Device allocated:            298.06GiB
    Device unallocated:           16.00EiB
    Used:                        286.18GiB
    Free (estimated):              8.00EiB      (min: 8.00EiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              404.00MiB      (used: 0.00B)

Eg. "Device size" - "Device allocated" = negative number or a very large
positive, hence the EiB values.

There are logical and raw numbers multiplied by ratios mixed together,
so the new code makes it explicit which kind is being used. The data and
metadata ratios are calculated separately.

Output after this patch will look like:

Overall:
    Device size:                 558.92GiB
    Device allocated:            298.06GiB
    Device unallocated:          260.86GiB
    Used:                        286.18GiB
    Free (estimated):            135.51GiB      (min: 135.51GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              404.00MiB      (used: 0.00B)

Data,RAID1: Size:147.00GiB, Used:141.92GiB
   /dev/sdc      147.00GiB
   /dev/sdd      147.00GiB

Metadata,RAID1: Size:2.00GiB, Used:1.17GiB
   /dev/sdc        2.00GiB
   /dev/sdd        2.00GiB

System,RAID1: Size:32.00MiB, Used:36.00KiB
   /dev/sdc       32.00MiB
   /dev/sdd       32.00MiB

Unallocated:
   /dev/sdc      130.43GiB
   /dev/sdd      130.43GiB

Changes:
* Device size is now the raw size, same for the following three
* Free is the logical size
* Max/min were reduced to just min

Filesystem      Size  Used Avail Use% Mounted on
/dev/sdc        280G  144G  141G  51% /mnt/sdc

The difference between Avail and Free is there because userspace tool does a
different guesswork than kernel.

Issues not addressed by this patch:
* RAID56 profiles are not handled
* mixed profiles are not handled

Signed-off-by: David Sterba <dsterba@suse.cz>
---

Fixing the space accounting is currently the blocker for the 3.17 release.

 cmds-fi-disk_usage.c | 151 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 103 insertions(+), 48 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index b30bd308df55..79db79a8c4a6 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -306,6 +306,7 @@ static void get_raid56_used(int fd, struct chunk_info *chunks, int chunkcount,
 	}
 }
 
+#define	MIN_UNALOCATED_THRESH	(16 * 1024 * 1024)
 static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		int chunkcount, struct device_info *devinfo, int devcount,
 		char *path, int mode)
@@ -313,16 +314,33 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 	struct btrfs_ioctl_space_args *sargs = 0;
 	int i;
 	int ret = 0;
-	int e, width;
-	u64 total_disk;		/* filesystem size == sum of
-				   device sizes */
-	u64 total_chunks;	/* sum of chunks sizes on disk(s) */
-	u64 total_used;		/* logical space used */
-	u64 total_free;		/* logical space un-used */
-	double K;
-	u64 raid5_used, raid6_used;
-	u64 global_reserve;
-	u64 global_reserve_used;
+	int width = 10;		/* default 10 for human units */
+	/*
+	 * r_* prefix is for raw data
+	 * l_* is for logical
+	 */
+	u64 r_total_size = 0;	/* filesystem size, sum of device sizes */
+	u64 r_total_chunks = 0;	/* sum of chunks sizes on disk(s) */
+	u64 r_total_used = 0;
+	u64 r_total_unused = 0;
+	u64 r_data_used = 0;
+	u64 r_data_chunks = 0;
+	u64 l_data_chunks = 0;
+	u64 r_metadata_used = 0;
+	u64 r_metadata_chunks = 0;
+	u64 l_metadata_chunks = 0;
+	u64 r_system_used = 0;
+	u64 r_system_chunks = 0;
+	double data_ratio;
+	double metadata_ratio;
+	/* logical */
+	u64 raid5_used = 0;
+	u64 raid6_used = 0;
+	u64 l_global_reserve = 0;
+	u64 l_global_reserve_used = 0;
+	u64 free_estimated = 0;
+	u64 free_min = 0;
+	int max_data_ratio = 1;
 
 	sargs = load_space_info(fd, path);
 	if (!sargs) {
@@ -330,27 +348,22 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		goto exit;
 	}
 
-	total_disk = disk_size(path);
-	e = errno;
-	if (total_disk == 0) {
+	r_total_size = 0;
+	for (i = 0; i < devcount; i++)
+		r_total_size += devinfo[i].device_size;
+
+	if (r_total_size == 0) {
 		fprintf(stderr,
 			"ERROR: couldn't get space info on '%s' - %s\n",
-			path, strerror(e));
+			path, strerror(errno));
 
 		ret = 1;
 		goto exit;
 	}
 	get_raid56_used(fd, chunkinfo, chunkcount, &raid5_used, &raid6_used);
 
-	total_chunks = 0;
-	total_used = 0;
-	total_free = 0;
-	global_reserve = 0;
-	global_reserve_used = 0;
-
 	for (i = 0; i < sargs->total_spaces; i++) {
-		float ratio = 1;
-		u64 allocated;
+		int ratio;
 		u64 flags = sargs->spaces[i].flags;
 
 		/*
@@ -372,52 +385,94 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		else
 			ratio = 1;
 
+		if (!ratio)
+			fprintf(stderr, "WARNING: RAID56 detected, not implemented\n");
+
+		if (ratio > max_data_ratio)
+			max_data_ratio = ratio;
+
 		if (flags & BTRFS_SPACE_INFO_GLOBAL_RSV) {
-			global_reserve = sargs->spaces[i].total_bytes;
-			global_reserve_used = sargs->spaces[i].used_bytes;
+			l_global_reserve = sargs->spaces[i].total_bytes;
+			l_global_reserve_used = sargs->spaces[i].used_bytes;
+		}
+		if ((flags & (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA))
+			== (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA)) {
+			fprintf(stderr, "WARNING: MIXED blockgroups not handled\n");
 		}
 
-		allocated = sargs->spaces[i].total_bytes * ratio;
+		if (flags & BTRFS_BLOCK_GROUP_DATA) {
+			r_data_used += sargs->spaces[i].used_bytes * ratio;
+			r_data_chunks += sargs->spaces[i].total_bytes * ratio;
+			l_data_chunks += sargs->spaces[i].total_bytes;
+		}
+		if (flags & BTRFS_BLOCK_GROUP_METADATA) {
+			r_metadata_used += sargs->spaces[i].used_bytes * ratio;
+			r_metadata_chunks += sargs->spaces[i].total_bytes * ratio;
+			l_metadata_chunks += sargs->spaces[i].total_bytes;
+		}
+		if (flags & BTRFS_BLOCK_GROUP_SYSTEM) {
+			r_system_used += sargs->spaces[i].used_bytes * ratio;
+			r_system_chunks += sargs->spaces[i].total_bytes * ratio;
+		}
+	}
 
-		total_chunks += allocated;
-		total_used += sargs->spaces[i].used_bytes;
-		total_free += (sargs->spaces[i].total_bytes -
-					sargs->spaces[i].used_bytes);
+	r_total_chunks = r_data_chunks + r_metadata_chunks + r_system_chunks;
+	r_total_used = r_data_used + r_metadata_used + r_system_used;
+	r_total_unused = r_total_size - r_total_chunks;
 
-	}
+	/* Raw / Logical = raid factor, >= 1 */
+	data_ratio = (double)r_data_chunks / l_data_chunks;
+	metadata_ratio = (double)r_metadata_chunks / l_metadata_chunks;
 
+#if 0
 	/* add the raid5/6 allocated space */
 	total_chunks += raid5_used + raid6_used;
+#endif
 
-	K = ((double)total_used + (double)total_free) /	(double)total_chunks;
+	/*
+	 * We're able to fill at least DATA for the unused space
+	 *
+	 * With mixed raid levels, this gives a rough estimate but more
+	 * accurate than just counting the logical free space
+	 * (l_data_chunks - l_data_used)
+	 *
+	 * In non-mixed case there's no difference.
+	 */
+	free_estimated = (r_data_chunks - r_data_used) / data_ratio;
+	free_min = free_estimated;
+
+	/* Chop unallocatable space */
+	/* FIXME: must be applied per device */
+	if (r_total_unused >= MIN_UNALOCATED_THRESH) {
+		free_estimated += r_total_unused / data_ratio;
+		/* Match the calculation of 'df', use the highest raid ratio */
+		free_min += r_total_unused / max_data_ratio;
+	}
 
-	if (mode == UNITS_HUMAN)
-		width = 10;
-	else
+	if (mode != UNITS_HUMAN)
 		width = 18;
 
 	printf("Overall:\n");
 
 	printf("    Device size:\t\t%*s\n", width,
-		pretty_size_mode(total_disk, mode));
+		pretty_size_mode(r_total_size, mode));
 	printf("    Device allocated:\t\t%*s\n", width,
-		pretty_size_mode(total_chunks, mode));
+		pretty_size_mode(r_total_chunks, mode));
 	printf("    Device unallocated:\t\t%*s\n", width,
-		pretty_size_mode(total_disk - total_chunks, mode));
+		pretty_size_mode(r_total_unused, mode));
 	printf("    Used:\t\t\t%*s\n", width,
-		pretty_size_mode(total_used, mode));
-	printf("    Free (Estimated):\t\t%*s\t(",
+		pretty_size_mode(r_total_used, mode));
+	printf("    Free (estimated):\t\t%*s\t(",
 		width,
-		pretty_size_mode((u64)(K * total_disk - total_used), mode));
-	printf("Max: %s, ",
-		pretty_size_mode(total_disk - total_chunks + total_free, mode));
-	printf("min: %s)\n",
-		pretty_size_mode((total_disk-total_chunks) / 2 + total_free, mode));
-	printf("    Data to device ratio:\t%*.0f %%\n",
-		width - 2, K * 100);
+		pretty_size_mode(free_estimated, mode));
+	printf("min: %s)\n", pretty_size_mode(free_min, mode));
+	printf("    Data ratio:\t\t\t%*.2f\n",
+		width, data_ratio);
+	printf("    Metadata ratio:\t\t%*.2f\n",
+		width, metadata_ratio);
 	printf("    Global reserve:\t\t%*s\t(used: %s)\n", width,
-		pretty_size_mode(global_reserve, mode),
-		pretty_size_mode(global_reserve_used, mode));
+		pretty_size_mode(l_global_reserve, mode),
+		pretty_size_mode(l_global_reserve_used, mode));
 
 exit:
 
-- 
2.1.1

