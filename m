Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbbCQNyD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 09:54:03 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: raffix@web.de, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: fi usage, fix reporting space for degraded mounts
Date: Tue, 17 Mar 2015 14:53:52 +0100
Message-Id: <1426600432-24635-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The total size of devices was summed from raw partition size which is
wrong in two ways:

- if the device is missing, the size is 0 and it mismatches the size
  summed from chunks, leading to bogus numbers like

    Device unallocated:		  16.00EiB
    Used:			   1.88TiB
    Free (estimated):		   8.00EiB	(min: 8.00EiB)

- we should really account the device size that's occupied by btrfs, not
  the real partition size altough it's the same most of the time

The sum of missing devices is now printed in the summary and any missing
device path is replaced with 'missing' instead of blank:

Data,RAID1: Size:972.00GiB, Used:962.15GiB
   	 972.00GiB
   /dev/sdb1	 972.00GiB

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=94911
Reported-by: <raffix@web.de>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-fi-disk_usage.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 27f9a4c8f213..27b989df45f2 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -324,6 +324,7 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 	u64 r_total_chunks = 0;	/* sum of chunks sizes on disk(s) */
 	u64 r_total_used = 0;
 	u64 r_total_unused = 0;
+	u64 r_total_missing = 0;	/* sum of missing devices size */
 	u64 r_data_used = 0;
 	u64 r_data_chunks = 0;
 	u64 l_data_chunks = 0;
@@ -350,8 +351,11 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 	}
 
 	r_total_size = 0;
-	for (i = 0; i < devcount; i++)
-		r_total_size += devinfo[i].device_size;
+	for (i = 0; i < devcount; i++) {
+		r_total_size += devinfo[i].size;
+		if (!devinfo[i].device_size)
+			r_total_missing += devinfo[i].size;
+	}
 
 	if (r_total_size == 0) {
 		fprintf(stderr,
@@ -461,6 +465,8 @@ static int print_filesystem_usage_overall(int fd, struct chunk_info *chunkinfo,
 		pretty_size_mode(r_total_chunks, unit_mode));
 	printf("    Device unallocated:\t\t%*s\n", width,
 		pretty_size_mode(r_total_unused, unit_mode));
+	printf("    Device missing:\t\t%*s\n", width,
+		pretty_size_mode(r_total_missing, unit_mode));
 	printf("    Used:\t\t\t%*s\n", width,
 		pretty_size_mode(r_total_used, unit_mode));
 	printf("    Free (estimated):\t\t%*s\t(",
@@ -538,8 +544,13 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
 		}
 
 		info[ndevs].devid = dev_info.devid;
-		strcpy(info[ndevs].path, (char *)dev_info.path);
-		info[ndevs].device_size = get_partition_size((char *)dev_info.path);
+		if (!dev_info.path[0]) {
+			strcpy(info[ndevs].path, "missing");
+		} else {
+			strcpy(info[ndevs].path, (char *)dev_info.path);
+			info[ndevs].device_size =
+				get_partition_size((char *)dev_info.path);
+		}
 		info[ndevs].size = dev_info.total_bytes;
 		++ndevs;
 	}
-- 
1.8.4.5

