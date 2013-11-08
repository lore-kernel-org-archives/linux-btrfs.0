Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:44987 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab3KHWBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 17:01:43 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E59109A06DB
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Nov 2013 15:01:42 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Eric Sandeen <sandeen@redhat.com>
Message-ID: <20131108220135.3802.39092@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: progs integration branch moved to master (new default leafsize)
Date: Fri, 8 Nov 2013 17:01:35 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

This patch is now the tip of the master branch for btrfs-progs, which
has been updated to include most of the backlogged progs patches.
Please take a look and give it a shake.  This was based on Dave's
integration tree (many thanks Dave!) minus the patches for online dedup.
I've pulled in the coverity fixes and a few others from the list as
well.

The patch below switches our default mkfs leafsize up to 16K.  This
should be a better choice in almost every workload, but now is your
chance to complain if it causes trouble.

--------------------------------
16KB is faster and leads to less metadata fragmentation in almost all
workloads.  It does slightly increase lock contention on the root nodes
in some workloads, but that is best dealt with by adding more subvolumes
(for now).

This uses 16KB or the page size, whichever is bigger.  If you're doing a
mixed block group mkfs, it uses the sectorsize instead.

Since the kernel refuses to mount a mixed block group FS where the
metadata leaf size doesn't match the data sectorsize, this also adds a
similar check during mkfs.

Signed-off-by: Chris Mason <chris.mason@fusionio.com>
---
 mkfs.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index bf8a831..cd0af9e 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -46,6 +46,8 @@
 
 static u64 index_cnt = 2;
 
+#define DEFAULT_MKFS_LEAF_SIZE 16384
+
 struct directory_name_entry {
 	char *dir_name;
 	char *path;
@@ -1222,7 +1224,7 @@ int main(int ac, char **av)
 	u64 alloc_start = 0;
 	u64 metadata_profile = 0;
 	u64 data_profile = 0;
-	u32 leafsize = sysconf(_SC_PAGESIZE);
+	u32 leafsize = max_t(u32, sysconf(_SC_PAGESIZE), DEFAULT_MKFS_LEAF_SIZE);
 	u32 sectorsize = 4096;
 	u32 nodesize = leafsize;
 	u32 stripesize = 4096;
@@ -1232,6 +1234,7 @@ int main(int ac, char **av)
 	int ret;
 	int i;
 	int mixed = 0;
+	int leaf_forced = 0;
 	int data_profile_opt = 0;
 	int metadata_profile_opt = 0;
 	int discard = 1;
@@ -1269,6 +1272,7 @@ int main(int ac, char **av)
 			case 'n':
 				nodesize = parse_size(optarg);
 				leafsize = parse_size(optarg);
+				leaf_forced = 1;
 				break;
 			case 'L':
 				label = parse_label(optarg);
@@ -1386,8 +1390,21 @@ int main(int ac, char **av)
 				BTRFS_BLOCK_GROUP_RAID0 : 0; /* raid0 or single */
 		}
 	} else {
+		u32 best_leafsize = max_t(u32, sysconf(_SC_PAGESIZE), sectorsize);
 		metadata_profile = 0;
 		data_profile = 0;
+
+		if (!leaf_forced) {
+			leafsize = best_leafsize;
+			nodesize = best_leafsize;
+			if (check_leaf_or_node_size(leafsize, sectorsize))
+				exit(1);
+		}
+		if (leafsize != sectorsize) {
+			fprintf(stderr, "Error: mixed metadata/data block groups "
+				"require metadata blocksizes equal to the sectorsize\n");
+			exit(1);
+		}
 	}
 
 	ret = test_num_disk_vs_raid(metadata_profile, data_profile,
-- 
1.8.2

