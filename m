Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54011 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbbE3Oy7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 May 2015 10:54:59 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YyiA3-0008Nt-3D
	for linux-btrfs@vger.kernel.org; Sat, 30 May 2015 16:54:55 +0200
Received: from host-78-149-208-209.as13285.net ([78.149.208.209])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2015 16:54:55 +0200
Received: from samtygier by host-78-149-208-209.as13285.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2015 16:54:55 +0200
To: linux-btrfs@vger.kernel.org
From: sam tygier <samtygier@yahoo.co.uk>
Subject: [PATCH v2] btrfs-progs: check metadata redundancy
Date: Sat, 30 May 2015 15:54:48 +0100
Message-ID: <mkcivp$l8b$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently BTRFS allows you to make bad choices of data and 
metadata levels. For example -d raid1 -m raid0 means you can
only use half your total disk space, but will loose everything
if 1 disk fails. It should give a warning in these cases.

When making a filesystem check that metadata mode is at least
as redundant as the data mode. For example give warning when:
	-d raid1 -m raid0

V1 -> V2 Downgrade from error to warning as requested by David
Sterba.

Signed-off-by: Sam Tygier <samtygier@yahoo.co.uk>

>From fdfcb5f733ff5ed48562366bda6f1a9c740b031a Mon Sep 17 00:00:00 2001
From: Sam Tygier <samtygier@yahoo.co.uk>
Date: Sat, 30 May 2015 15:37:37 +0100
Subject: [PATCH] When making a filesystem check that metadata mode is at least
 as redundant as the data mode. For example give warning when:
   -d raid1 -m raid0

---
 mkfs.c  |  6 ++++++
 utils.c | 18 ++++++++++++++++++
 utils.h |  1 +
 3 files changed, 25 insertions(+)

diff --git a/mkfs.c b/mkfs.c
index 14e0fed..938840d 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1367,6 +1367,12 @@ int main(int ac, char **av)
 		exit(1);
 	}
 
+	if (group_profile_max_safe_loss(metadata_profile) <
+		group_profile_max_safe_loss(data_profile)){
+		fprintf(stderr,
+			"Warning: metatdata has lower redundancy than data\n");
+	}
+
 	/* if we are here that means all devs are good to btrfsify */
 	printf("%s\n", PACKAGE_STRING);
 	printf("See %s for more information.\n\n", PACKAGE_URL);
diff --git a/utils.c b/utils.c
index 4b8a826..ba35b34 100644
--- a/utils.c
+++ b/utils.c
@@ -2354,6 +2354,24 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	return 0;
 }
 
+int group_profile_max_safe_loss(u64 flag)
+{
+	switch (flag & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
+	case 0: /* single */
+	case BTRFS_BLOCK_GROUP_DUP:
+	case BTRFS_BLOCK_GROUP_RAID0:
+		return 0;
+	case BTRFS_BLOCK_GROUP_RAID1:
+	case BTRFS_BLOCK_GROUP_RAID5:
+	case BTRFS_BLOCK_GROUP_RAID10:
+		return 1;
+	case BTRFS_BLOCK_GROUP_RAID6:
+		return 2;
+	default:
+		return -1;
+	}
+}
+
 /* Check if disk is suitable for btrfs
  * returns:
  *  1: something is wrong, estr provides the error
diff --git a/utils.h b/utils.h
index 5657c74..98fd812 100644
--- a/utils.h
+++ b/utils.h
@@ -144,6 +144,7 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
 int get_label_mounted(const char *mount_path, char *labelp);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, char *estr);
+int group_profile_max_safe_loss(u64 flag);
 int is_vol_small(char *file);
 int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			   int verify);
-- 
2.1.4

