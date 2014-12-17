Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:55465 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaLQUND (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 15:13:03 -0500
Received: by mail-wg0-f54.google.com with SMTP id l2so21450459wgh.27
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Dec 2014 12:13:01 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 7/8] Print the summary
Date: Wed, 17 Dec 2014 21:14:11 +0100
Message-Id: <1418847252-14184-8-git-send-email-kreijack@inwind.it>
In-Reply-To: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch prints the summary of the filesystem after the creation.
The main fileds printed are:
- devices list with their uuid, devid, path and size
- raid profile (dup,single,raid0...)
- leafsize/nodesize/sectorsize
- filesystem features (raid56, extref, mixed-bg)
- chunk size and type

If the '-v' switched is passed, the output is more verbose; if the '-q'
switched is passed, only the errors are printed.


Below an example:

#mkfs.btrfs -L btrfs-test -f -M -m raid5 -d raid5 /dev/vd[b-k]"
BTRFS filesystem summary:
  Label:		btrfs-test
  UUID:			14ae8a88-98ac-4f22-8441-79f76ec622f7

  Node size:		4096
  Leaf size:		4096
  Sector size:		4096
  Initial chunks:
    Data+Metadata:	9.01GiB
    System:		18.06MiB
  Metadata profile:	RAID5
  Data profile:		RAID5
  Mixed mode:		YES
  SSD detected:		NO
  Incompat features:	mixed-bg, extref, raid56
  Number of devices:	10
    UUID                                  ID    SIZE    PATH
    ------------------------------------  --  --------- -----------
    df1c7f50-1980-4da2-8bc9-7ee6ffb0b554   1   50.00GiB /dev/vdb
    32c808a0-cd7b-4497-a2c0-1d77a9854af9   2   50.00GiB /dev/vdc
    3159782e-d108-40bc-9e15-090ecac160b4   3   50.00GiB /dev/vdd
    db7eaf0c-beb8-4093-a9d0-b9c25c146305   4   50.00GiB /dev/vde
    c367ca04-1f71-49c0-a331-11fc0b87e9fc   5   50.00GiB /dev/vdf
    e9b73c86-4058-4b3a-90ac-18741a276e70   6   50.00GiB /dev/vdg
    c4298b7a-ad41-4690-bf10-bf748b319413   7   50.00GiB /dev/vdh
    1cf048c8-af8a-4225-b09a-5d12e9b217fa   8    2.00GiB /dev/vdi
    7e157869-768a-4725-bad5-82e6bd05fd17   9    2.00GiB /dev/vdj
    2c9431ac-c7f0-45a5-8529-cef8cf6e4033  10    2.00GiB /dev/vdk

  Total devices size:                         356.01GiB


Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 mkfs.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 87 insertions(+), 12 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 2d7b2ca..30a79df 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1251,6 +1251,21 @@ static void process_fs_features(u64 flags)
 	}
 }
 
+static void print_fs_features(u64 flags)
+{
+	int i;
+	int first = 1;
+
+	for (i = 0; i < ARRAY_SIZE(mkfs_features); i++) {
+		if (flags & mkfs_features[i].flag) {
+			if (!first)
+				printf(", %s",mkfs_features[i].name);
+			else
+				printf("%s",mkfs_features[i].name);
+			first=0;
+		}
+	}
+}
 
 /*
  * Return NULL if all features were parsed fine, otherwise return the name of
@@ -1271,13 +1286,43 @@ static char* parse_fs_features(char *namelist, u64 *flags)
 	return NULL;
 }
 
+static void list_all_devices(struct btrfs_root *root)
+{
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_device *device;
+	int number_of_devices = 0;
+	u64 total_block_count = 0;
+
+	fs_devices = root->fs_info->fs_devices;
+
+	list_for_each_entry(device, &fs_devices->devices, dev_list)
+		number_of_devices++;
+
+	printf("  Number of devices:\t%d\n", number_of_devices);
+	printf("    UUID                                  ID    SIZE    PATH\n");
+	printf("    ------------------------------------  --  --------- -----------\n");
+	list_for_each_entry_reverse(device, &fs_devices->devices, dev_list) {
+		char dev_uuid[BTRFS_UUID_UNPARSED_SIZE];
+
+		uuid_unparse(device->uuid, dev_uuid);
+		printf("    %s %3llu %10s %s\n",
+			dev_uuid, device->devid,
+			pretty_size(device->total_bytes),
+			device->name);
+		total_block_count += device->total_bytes;
+	}
+
+	printf("\n");
+	printf("  Total devices size:                        %10s\n",
+		pretty_size(total_block_count));
+}
+
 int main(int ac, char **av)
 {
 	char *file;
 	struct btrfs_root *root;
 	struct btrfs_trans_handle *trans;
 	char *label = NULL;
-	char *first_file;
 	u64 block_count = 0;
 	u64 dev_block_count = 0;
 	u64 blocks[7];
@@ -1532,9 +1577,11 @@ int main(int ac, char **av)
 		exit(1);
 	}
 
-	/* if we are here that means all devs are good to btrfsify */
-	printf("%s\n", BTRFS_BUILD_VERSION);
-	printf("See http://btrfs.wiki.kernel.org for more information.\n\n");
+	if (verbose) {
+		/* if we are here that means all devs are good to btrfsify */
+		printf("%s\n", BTRFS_BUILD_VERSION);
+		printf("See http://btrfs.wiki.kernel.org for more information.\n\n");
+	}
 
 	dev_cnt--;
 
@@ -1550,7 +1597,6 @@ int main(int ac, char **av)
 				strerror(errno));
 			exit(1);
 		}
-		first_file = file;
 		ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count,
 					   block_count, &mixed, discard);
 		if (ret) {
@@ -1568,7 +1614,6 @@ int main(int ac, char **av)
 			exit(1);
 		}
 
-		first_file = file;
 		source_dir_size = size_sourcedir(source_dir, sectorsize,
 					     &num_of_meta_chunks, &size_of_data);
 		if(block_count < source_dir_size)
@@ -1606,7 +1651,8 @@ int main(int ac, char **av)
 		features |= BTRFS_FEATURE_INCOMPAT_RAID56;
 	}
 
-	process_fs_features(features);
+	if (verbose)
+		process_fs_features(features);
 
 	ret = make_btrfs(fd, file, label, fs_uuid, blocks, dev_block_count,
 			 nodesize, leafsize,
@@ -1687,11 +1733,6 @@ raid_groups:
 	ret = create_data_reloc_tree(trans, root);
 	BUG_ON(ret);
 
-	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
-	    "sectorsize %u size %s\n",
-	    label, first_file, nodesize, leafsize, sectorsize,
-	    pretty_size(btrfs_super_total_bytes(root->fs_info->super_copy)));
-
 	btrfs_commit_transaction(trans, root);
 
 	if (source_dir_set) {
@@ -1706,6 +1747,40 @@ raid_groups:
 		BUG_ON(ret);
 	}
 
+	if (!quiet) {
+		printf("BTRFS filesystem summary:\n");
+		printf("  Label:\t\t%s\n", label);
+		printf("  UUID:\t\t\t%s\n", fs_uuid);
+		printf("\n");
+
+		printf("  Node size:\t\t%u\n", nodesize);
+		printf("  Leaf size:\t\t%u\n", leafsize);
+		printf("  Sector size:\t\t%u\n", sectorsize);
+		printf("  Initial chunks:\n");
+		if (allocation.data)
+			printf("    Data:\t\t%s\n",
+				pretty_size(allocation.data));
+		if (allocation.metadata)
+			printf("    Metadata:\t\t%s\n",
+				pretty_size(allocation.metadata));
+		if (allocation.mixed)
+			printf("    Data+Metadata:\t%s\n",
+				pretty_size(allocation.mixed));
+		printf("    System:\t\t%s\n",
+			pretty_size(allocation.system));
+		printf("  Metadata profile:\t%s\n",
+			group_profile_str(metadata_profile));
+		printf("  Data profile:\t\t%s\n",
+			group_profile_str(data_profile));
+		printf("  Mixed mode:\t\t%s\n", mixed ? "YES" : "NO");
+		printf("  SSD detected:\t\t%s\n", ssd ? "YES" : "NO");
+		printf("  Incompat features:\t");
+		print_fs_features(features);
+		printf("\n");
+
+		list_all_devices(root);
+	}
+
 	ret = close_ctree(root);
 	BUG_ON(ret);
 	free(label);
-- 
2.1.3

