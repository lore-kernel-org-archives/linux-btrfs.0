From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs-progs: add btrfsctl -i to print space info
Date: Wed, 13 Jan 2010 13:21:23 -0500
Message-ID: <20100113182123.GB2774@dhcp231-156.rdu.redhat.com>
References: <20100112203157.GB13414@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100112203157.GB13414@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 12, 2010 at 03:31:57PM -0500, Josef Bacik wrote:
> This goes along with the new space info ioctl.  This will spit out the space
> info all nice and pretty with the type, it's flags (DUP, RAID) and how much
> space is in that group and how much is in use.  Thanks,
> 

Here is an updated patch with u64 flags.  Thanks,

Josef


>From 8cb701c685ca1c3285f916c92564d6e966c614f9 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@redhat.com>
Date: Wed, 13 Jan 2010 13:06:06 -0500
Subject: [PATCH] Btrfs-progs: add btrfsctl -i to print space info

This goes along with the new space info ioctl.  This will spit out the space
info all nice and pretty with the type, it's flags (DUP, RAID) and how much
space is in that group and how much is in use.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 btrfsctl.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h    |   15 +++++++++-
 2 files changed, 102 insertions(+), 1 deletions(-)

diff --git a/btrfsctl.c b/btrfsctl.c
index 81d2a30..4a516fd 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -61,6 +61,8 @@ static void print_usage(void)
 	printf("\t-l file: listing snapshot/subvolume under a subvolume\n");
 	printf("\t-m [tree id] directory: set the default mounted subvolume"
 	       " to the [tree id] or the directory\n");
+	printf("\t-i dir: print out detailed space usage information on the"
+	       " volume\n");
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	exit(1);
 }
@@ -213,6 +215,88 @@ int btrfs_show_subvolume(struct list_head *list_top, char *path,
 	return 0;
 }
 
+int btrfs_print_space_info(int fd)
+{
+	struct btrfs_ioctl_space_args *sargs;
+	u64 count = 0, i;
+	int ret;
+
+	sargs = malloc(sizeof(struct btrfs_ioctl_space_args));
+	if (!sargs)
+		return -ENOMEM;
+
+	sargs->space_slots = 0;
+	sargs->total_spaces = 0;
+
+	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
+	if (ret) {
+		free(sargs);
+		return ret;
+	}
+
+	if (!sargs->total_spaces)
+		return 0;
+
+	count = sargs->total_spaces;
+
+	sargs = realloc(sargs, sizeof(struct btrfs_ioctl_space_args) +
+			(count * sizeof(struct btrfs_ioctl_space_info)));
+	if (!sargs)
+		return -ENOMEM;
+
+	sargs->space_slots = count;
+	sargs->total_spaces = 0;
+
+	ret = ioctl(fd, BTRFS_IOC_SPACE_INFO, sargs);
+	if (ret) {
+		free(sargs);
+		return ret;
+	}
+
+	for (i = 0; i < sargs->total_spaces; i++) {
+		char description[80];
+		char *total_bytes;
+		char *used_bytes;
+		int written = 0;
+		u64 flags = sargs->spaces[i].flags;
+
+		memset(description, 0, 80);
+
+		if (flags & BTRFS_BLOCK_GROUP_DATA) {
+			snprintf(description, 5, "%s", "Data");
+			written += 4;
+		} else if (flags & BTRFS_BLOCK_GROUP_SYSTEM) {
+			snprintf(description, 7, "%s", "System");
+			written += 6;
+		} else if (flags & BTRFS_BLOCK_GROUP_METADATA) {
+			snprintf(description, 9, "%s", "Metadata");
+			written += 8;
+		}
+
+		if (flags & BTRFS_BLOCK_GROUP_RAID0) {
+			snprintf(description+written, 8, "%s", ", RAID0");
+			written += 7;
+		} else if (flags & BTRFS_BLOCK_GROUP_RAID1) {
+			snprintf(description+written, 8, "%s", ", RAID1");
+			written += 7;
+		} else if (flags & BTRFS_BLOCK_GROUP_DUP) {
+			snprintf(description+written, 6, "%s", ", DUP");
+			written += 5;
+		} else if (flags & BTRFS_BLOCK_GROUP_RAID10) {
+			snprintf(description+written, 9, "%s", ", RAID10");
+			written += 8;
+		}
+
+		total_bytes = pretty_sizes(sargs->spaces[i].total_bytes);
+		used_bytes = pretty_sizes(sargs->spaces[i].used_bytes);
+		printf("%s: total=%s, used=%s\n", description, total_bytes,
+		       used_bytes);
+	}
+
+	free(sargs);
+
+	return 0;
+}
 
 int btrfs_list_subvolumes(int fd, unsigned long command)
 {
@@ -394,6 +478,8 @@ int main(int ac, char **av)
 					exit(1);
 				}
 			}
+		} else if (strcmp(av[i], "-i") == 0) {
+			command = BTRFS_IOC_SPACE_INFO;
 		}
 	}
 	if (command == 0) {
@@ -427,6 +513,8 @@ int main(int ac, char **av)
 	} else if (command == BTRFS_IOC_DEFAULT_SUBVOL) {
 		printf("objectid is %llu\n", objectid);
 		ret = ioctl(fd, command, &objectid);
+	} else if (command == BTRFS_IOC_SPACE_INFO) {
+		ret = btrfs_print_space_info(fd);
 	} else
 		ret = ioctl(fd, command, &args);
 	if (ret < 0) {
diff --git a/ioctl.h b/ioctl.h
index 70fc15d..ee369e2 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -57,6 +57,18 @@ struct btrfs_ioctl_subvol_leaf {
 	struct btrfs_ioctl_subvol_items items[];
 };
 
+struct btrfs_ioctl_space_info {
+	u64 flags;
+	u64 total_bytes;
+	u64 used_bytes;
+};
+
+struct btrfs_ioctl_space_args {
+	u64 space_slots;
+	u64 total_spaces;
+	struct btrfs_ioctl_space_info spaces[0];
+};
+
 #define BTRFS_SUBVOL_LEAF_SIZE_MIN sizeof(struct btrfs_ioctl_subvol_leaf) + \
 	sizeof(struct btrfs_ioctl_subvol_items)
 
@@ -92,5 +104,6 @@ struct btrfs_ioctl_subvol_leaf {
 #define BTRFS_IOC_SNAP_LISTING _IOWR(BTRFS_IOCTL_MAGIC, 16, \
 				   struct btrfs_ioctl_subvol_args)
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 17, u64)
-
+#define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 18, \
+				    struct btrfs_ioctl_space_args)
 #endif
-- 
1.5.4.3

