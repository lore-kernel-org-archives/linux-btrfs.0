Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33996 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbeBIHov (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 9 Feb 2018 02:44:51 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v2 04/10] btrfs-progs: Introduce btrfs_raid_array and related infrastructures
Date: Fri,  9 Feb 2018 15:44:22 +0800
Message-Id: <20180209074428.29187-6-wqu@suse.com>
In-Reply-To: <20180209074428.29187-1-wqu@suse.com>
References: <20180209074428.29187-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As part of the effort to unify code and behavior between btrfs-progs and
kernel, copy the btrfs_raid_array from kernel to btrfs-progs.

So later we can use the btrfs_raid_array[] to get needed raid info other
than manually do if-else branches.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h   | 12 +++++++++++-
 volumes.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 volumes.h | 30 +++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index 17cdac76c58c..c76849d8deb7 100644
--- a/ctree.h
+++ b/ctree.h
@@ -958,7 +958,17 @@ struct btrfs_csum_item {
 #define BTRFS_BLOCK_GROUP_RAID5    	(1ULL << 7)
 #define BTRFS_BLOCK_GROUP_RAID6    	(1ULL << 8)
 #define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
-#define BTRFS_NR_RAID_TYPES             7
+
+enum btrfs_raid_types {
+	BTRFS_RAID_RAID10,
+	BTRFS_RAID_RAID1,
+	BTRFS_RAID_DUP,
+	BTRFS_RAID_RAID0,
+	BTRFS_RAID_SINGLE,
+	BTRFS_RAID_RAID5,
+	BTRFS_RAID_RAID6,
+	BTRFS_NR_RAID_TYPES
+};
 
 #define BTRFS_BLOCK_GROUP_TYPE_MASK	(BTRFS_BLOCK_GROUP_DATA |    \
 					 BTRFS_BLOCK_GROUP_SYSTEM |  \
diff --git a/volumes.c b/volumes.c
index a9dc8c939dc5..b47ff1f392b5 100644
--- a/volumes.c
+++ b/volumes.c
@@ -30,6 +30,72 @@
 #include "utils.h"
 #include "kernel-lib/raid56.h"
 
+const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
+	[BTRFS_RAID_RAID10] = {
+		.sub_stripes	= 2,
+		.dev_stripes	= 1,
+		.devs_max	= 0,	/* 0 == as many as possible */
+		.devs_min	= 4,
+		.tolerated_failures = 1,
+		.devs_increment	= 2,
+		.ncopies	= 2,
+	},
+	[BTRFS_RAID_RAID1] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 2,
+		.devs_min	= 2,
+		.tolerated_failures = 1,
+		.devs_increment	= 2,
+		.ncopies	= 2,
+	},
+	[BTRFS_RAID_DUP] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 2,
+		.devs_max	= 1,
+		.devs_min	= 1,
+		.tolerated_failures = 0,
+		.devs_increment	= 1,
+		.ncopies	= 2,
+	},
+	[BTRFS_RAID_RAID0] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 0,
+		.devs_min	= 2,
+		.tolerated_failures = 0,
+		.devs_increment	= 1,
+		.ncopies	= 1,
+	},
+	[BTRFS_RAID_SINGLE] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 1,
+		.devs_min	= 1,
+		.tolerated_failures = 0,
+		.devs_increment	= 1,
+		.ncopies	= 1,
+	},
+	[BTRFS_RAID_RAID5] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 0,
+		.devs_min	= 2,
+		.tolerated_failures = 1,
+		.devs_increment	= 1,
+		.ncopies	= 2,
+	},
+	[BTRFS_RAID_RAID6] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 0,
+		.devs_min	= 3,
+		.tolerated_failures = 2,
+		.devs_increment	= 1,
+		.ncopies	= 3,
+	},
+};
+
 struct stripe {
 	struct btrfs_device *dev;
 	u64 physical;
diff --git a/volumes.h b/volumes.h
index 7bbdf615d31a..612a0a7586f4 100644
--- a/volumes.h
+++ b/volumes.h
@@ -108,6 +108,36 @@ struct map_lookup {
 	struct btrfs_bio_stripe stripes[];
 };
 
+struct btrfs_raid_attr {
+	int sub_stripes;	/* sub_stripes info for map */
+	int dev_stripes;	/* stripes per dev */
+	int devs_max;		/* max devs to use */
+	int devs_min;		/* min devs needed */
+	int tolerated_failures; /* max tolerated fail devs */
+	int devs_increment;	/* ndevs has to be a multiple of this */
+	int ncopies;		/* how many copies to data has */
+};
+
+extern const struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES];
+
+static inline enum btrfs_raid_types btrfs_bg_flags_to_raid_index(u64 flags)
+{
+	if (flags & BTRFS_BLOCK_GROUP_RAID10)
+		return BTRFS_RAID_RAID10;
+	else if (flags & BTRFS_BLOCK_GROUP_RAID1)
+		return BTRFS_RAID_RAID1;
+	else if (flags & BTRFS_BLOCK_GROUP_DUP)
+		return BTRFS_RAID_DUP;
+	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
+		return BTRFS_RAID_RAID0;
+	else if (flags & BTRFS_BLOCK_GROUP_RAID5)
+		return BTRFS_RAID_RAID5;
+	else if (flags & BTRFS_BLOCK_GROUP_RAID6)
+		return BTRFS_RAID_RAID6;
+
+	return BTRFS_RAID_SINGLE; /* BTRFS_BLOCK_GROUP_SINGLE */
+}
+
 #define btrfs_multi_bio_size(n) (sizeof(struct btrfs_multi_bio) + \
 			    (sizeof(struct btrfs_bio_stripe) * (n)))
 #define btrfs_map_lookup_size(n) (sizeof(struct map_lookup) + \
-- 
2.16.1

