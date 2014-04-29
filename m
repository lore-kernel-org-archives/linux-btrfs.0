Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758180AbaD2QC0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 12:02:26 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E436AAC4F
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 16:02:25 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 08/14] btrfs-progs: compare unallocated space against the correct value
Date: Tue, 29 Apr 2014 18:02:24 +0200
Message-Id: <06385d073f7fc2cee8dfb8d00ca47bf14bc6638c.1398786620.git.dsterba@suse.cz>
In-Reply-To: <cover.1398786620.git.dsterba@suse.cz>
References: <cover.1398786620.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The device may not be fully occupied by the filesystem, the value of
Unallocated should not be calculated against the device size but the
size provided by DEV_INFO.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-device.c        | 6 ++----
 cmds-fi-disk_usage.c | 9 ++++-----
 cmds-fi-disk_usage.h | 2 +-
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 519725f83e8c..d7889f93d343 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -450,10 +450,8 @@ static int _cmd_device_usage(int fd, char *path, int mode)
 		printf("%s, ID: %llu\n", device_info_ptr[i].path,
 				device_info_ptr[i].devid);
 		print_device_sizes(fd, &device_info_ptr[i], mode);
-		print_device_chunks(fd, device_info_ptr[i].devid,
-				device_info_ptr[i].size,
-				info_ptr, info_count,
-				mode);
+		print_device_chunks(fd, &device_info_ptr[i],
+				info_ptr, info_count, mode);
 		printf("\n");
 	}
 
diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index ddb064cc4c66..7d0334086dbd 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -500,7 +500,7 @@ int load_device_info(int fd, struct device_info **device_info_ptr,
 		info[ndevs].devid = dev_info.devid;
 		strcpy(info[ndevs].path, (char *)dev_info.path);
 		info[ndevs].device_size = get_partition_size((char *)dev_info.path);
-		info[ndevs].size = dev_info.total_size;
+		info[ndevs].size = dev_info.total_bytes;
 		++ndevs;
 	}
 
@@ -847,7 +847,7 @@ int cmd_filesystem_usage(int argc, char **argv)
 	return 0;
 }
 
-void print_device_chunks(int fd, u64 devid, u64 total_size,
+void print_device_chunks(int fd, struct device_info *devinfo,
 		struct chunk_info *chunks_info_ptr,
 		int chunks_info_count, int mode)
 {
@@ -860,7 +860,7 @@ void print_device_chunks(int fd, u64 devid, u64 total_size,
 		u64 flags;
 		u64 size;
 
-		if (chunks_info_ptr[i].devid != devid)
+		if (chunks_info_ptr[i].devid != devinfo->devid)
 			continue;
 
 		flags = chunks_info_ptr[i].type;
@@ -879,7 +879,7 @@ void print_device_chunks(int fd, u64 devid, u64 total_size,
 	}
 	printf("   Unallocated: %*s%10s\n",
 		(int)(20 - strlen("Unallocated")), "",
-		df_pretty_sizes(total_size - allocated, mode));
+		df_pretty_sizes(devinfo->size - allocated, mode));
 }
 
 void print_device_sizes(int fd, struct device_info *devinfo, int mode)
@@ -890,5 +890,4 @@ void print_device_sizes(int fd, struct device_info *devinfo, int mode)
 	printf("   FS occuppied:%*s%10s\n",
 		(int)(20 - strlen("FS occupied")), "",
 		df_pretty_sizes(devinfo->size, mode));
-	}
 }
diff --git a/cmds-fi-disk_usage.h b/cmds-fi-disk_usage.h
index 79cc2a115bc5..dbc2a10f31eb 100644
--- a/cmds-fi-disk_usage.h
+++ b/cmds-fi-disk_usage.h
@@ -50,7 +50,7 @@ int load_device_info(int fd, struct device_info **device_info_ptr,
 		int *device_info_count);
 int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count);
 char *df_pretty_sizes(u64 size, int mode);
-void print_device_chunks(int fd, u64 devid, u64 total_size,
+void print_device_chunks(int fd, struct device_info *devinfo,
 		struct chunk_info *chunks_info_ptr,
 		int chunks_info_count, int mode);
 void print_device_sizes(int fd, struct device_info *devinfo, int mode);
-- 
1.9.0

