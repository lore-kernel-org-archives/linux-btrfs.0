Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54796 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751140AbaJFKRv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Oct 2014 06:17:51 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <Anand.Jain@oracle.com>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2 3/3] btrfs-progs: fix device missing of btrfs fi show with seed devices
Date: Mon, 6 Oct 2014 18:16:46 +0800
Message-ID: <1412590606-5804-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <541A74A6.1010109@oracle.com>
References: <541A74A6.1010109@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

*Note*
this handles the problem under umounted state, the similar problem
under mounted state is already fixed by Anand.

Steps to reproduce:
        # mkfs.btrfs -f /dev/sda1
        # btrfstune -S 1 /dev/sda1
        # mount /dev/sda1 /mnt
        # btrfs dev add /dev/sda2 /mnt
        # umount /mnt                   <== (umounted)
        # btrfs fi show /dev/sda2
result:
        Label: none  uuid: XXXXXXXXXXXXXXXXXX
        Total devices 2 FS bytes used 368.00KiB
        devid    2 size 9.31GiB used 1.25GiB path /dev/sda2
        *** Some devices missing
        Btrfs v3.16-67-g69f54ea-dirty

It is because @btrfs_scan_lblkid() won't establish mappinig
between the seed and sprout devices. So seeding devices are missing.
We could use @open_ctree_* to detect all seed/sprout mappings
for each fs scanned after @btrfs_scan_lblkid().

sth worthes mention:
o If there are multi-level of seeds, all devices in them will be shown
  in the ascending order of @devid
o If device replace is execed on a sprout fs with a device in a seed fs,
  the replaced device still exist in the seed fs together with
  the replacing device in the sprout fs, so we only keep the latest device
  with the newest generation

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog
	v1->v2: o add multi-level of seeds handle
		o add dev replace handle
---
 cmds-filesystem.c | 294 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 volumes.c         |   1 +
 volumes.h         |   2 +
 3 files changed, 271 insertions(+), 26 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index dc5185e..6cb67f7 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -268,10 +268,71 @@ static int cmp_device_id(void *priv, struct list_head *a,
 		da->devid > db->devid ? 1 : 0;
 }
 
+static void splice_device_list(struct list_head *seed_devices,
+			       struct list_head *all_devices)
+{
+	struct btrfs_device *in_all, *next_all;
+	struct btrfs_device *in_seed, *next_seed;
+
+	list_for_each_entry_safe(in_all, next_all, all_devices, dev_list) {
+		list_for_each_entry_safe(in_seed, next_seed, seed_devices,
+								dev_list) {
+			if (in_all->devid == in_seed->devid) {
+				/*
+				 * When do dev replace in a sprout fs
+				 * to a dev in its seed fs, the replacing
+				 * dev will reside in the sprout fs and
+				 * the replaced dev will still exist
+				 * in the seed fs.
+				 * So pick the latest one when showing
+				 * the sprout fs.
+				 */
+				if (in_all->generation
+						< in_seed->generation) {
+					list_del(&in_all->dev_list);
+					free(in_all);
+				} else if (in_all->generation
+						> in_seed->generation) {
+					list_del(&in_seed->dev_list);
+					free(in_seed);
+				}
+				break;
+			}
+		}
+	}
+
+	list_splice(seed_devices, all_devices);
+}
+
+static void print_devices(struct btrfs_fs_devices *fs_devices,
+			  u64 *devs_found)
+{
+	struct btrfs_device *device;
+	struct btrfs_fs_devices *cur_fs;
+	struct list_head *all_devices;
+
+	all_devices = &fs_devices->devices;
+	cur_fs = fs_devices->seed;
+	/* add all devices of seed fs to the fs to be printed */
+	while (cur_fs) {
+		splice_device_list(&cur_fs->devices, all_devices);
+		cur_fs = cur_fs->seed;
+	}
+
+	list_sort(NULL, all_devices, cmp_device_id);
+	list_for_each_entry(device, all_devices, dev_list) {
+		printf("\tdevid %4llu size %s used %s path %s\n",
+		       (unsigned long long)device->devid,
+		       pretty_size(device->total_bytes),
+		       pretty_size(device->bytes_used), device->name);
+
+		(*devs_found)++;
+	}
+}
+
 static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 {
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
-	struct list_head *cur;
 	struct btrfs_device *device;
 	u64 devs_found = 0;
 	u64 total;
@@ -287,23 +348,13 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 	else
 		printf("Label: none ");
 
-
 	total = device->total_devs;
 	printf(" uuid: %s\n\tTotal devices %llu FS bytes used %s\n", uuidbuf,
 	       (unsigned long long)total,
 	       pretty_size(device->super_bytes_used));
 
-	list_sort(NULL, &fs_devices->devices, cmp_device_id);
-	list_for_each(cur, &fs_devices->devices) {
-		device = list_entry(cur, struct btrfs_device, dev_list);
+	print_devices(fs_devices, &devs_found);
 
-		printf("\tdevid %4llu size %s used %s path %s\n",
-		       (unsigned long long)device->devid,
-		       pretty_size(device->total_bytes),
-		       pretty_size(device->bytes_used), device->name);
-
-		devs_found++;
-	}
 	if (devs_found < total) {
 		printf("\t*** Some devices missing\n");
 	}
@@ -489,6 +540,194 @@ out:
 	return ret;
 }
 
+static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
+{
+	struct btrfs_fs_devices *cur_seed, *next_seed;
+	struct btrfs_device *device;
+
+	while (!list_empty(&fs_devices->devices)) {
+		device = list_entry(fs_devices->devices.next,
+					struct btrfs_device, dev_list);
+		list_del(&device->dev_list);
+
+		free(device->name);
+		free(device->label);
+		free(device);
+	}
+
+	/* free seed fs chain */
+	cur_seed = fs_devices->seed;
+	fs_devices->seed = NULL;
+	while (cur_seed) {
+		next_seed = cur_seed->seed;
+		free(cur_seed);
+
+		cur_seed = next_seed;
+	}
+
+	list_del(&fs_devices->list);
+	free(fs_devices);
+}
+
+static int copy_device(struct btrfs_device *dst,
+		       struct btrfs_device *src)
+{
+	dst->devid = src->devid;
+	memcpy(dst->uuid, src->uuid, BTRFS_UUID_SIZE);
+	if (src->name == NULL)
+		dst->name = NULL;
+	else {
+		dst->name = strdup(src->name);
+		if (!dst->name)
+			return -ENOMEM;
+	}
+	if (src->label == NULL)
+		dst->label = NULL;
+	else {
+		dst->label = strdup(src->label);
+		if (!dst->label) {
+			free(dst->name);
+			return -ENOMEM;
+		}
+	}
+	dst->total_devs = src->total_devs;
+	dst->super_bytes_used = src->super_bytes_used;
+	dst->total_bytes = src->total_bytes;
+	dst->bytes_used = src->bytes_used;
+	dst->generation = src->generation;
+
+	return 0;
+}
+
+static int copy_fs_devices(struct btrfs_fs_devices *dst,
+			   struct btrfs_fs_devices *src)
+{
+	struct btrfs_device *cur_dev, *dev_copy;
+	int ret = 0;
+
+	memcpy(dst->fsid, src->fsid, BTRFS_FSID_SIZE);
+	INIT_LIST_HEAD(&dst->devices);
+	dst->seed = NULL;
+
+	list_for_each_entry(cur_dev, &src->devices, dev_list) {
+		dev_copy = malloc(sizeof(*dev_copy));
+		if (!dev_copy) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		ret = copy_device(dev_copy, cur_dev);
+		if (ret) {
+			free(dev_copy);
+			break;
+		}
+
+		list_add(&dev_copy->dev_list, &dst->devices);
+		dev_copy->fs_devices = dst;
+	}
+
+	return ret;
+}
+
+static int find_and_copy_seed(struct btrfs_fs_devices *seed,
+			      struct btrfs_fs_devices *copy,
+			      struct list_head *fs_uuids) {
+	struct btrfs_fs_devices *cur_fs;
+
+	list_for_each_entry(cur_fs, fs_uuids, list)
+		if (!memcmp(seed->fsid, cur_fs->fsid, BTRFS_FSID_SIZE))
+			return copy_fs_devices(copy, cur_fs);
+
+	return 1;
+}
+
+static int map_seed_devices(struct list_head *all_uuids,
+			    char *search, int *found)
+{
+	struct btrfs_fs_devices *cur_fs, *cur_seed;
+	struct btrfs_fs_devices *fs_copy, *seed_copy;
+	struct btrfs_fs_devices *opened_fs;
+	struct btrfs_device *device;
+	struct btrfs_fs_info *fs_info;
+	struct list_head *fs_uuids;
+	int ret = 0;
+
+	fs_uuids = btrfs_scanned_uuids();
+
+	/*
+	 * The fs_uuids list is global, and open_ctree_* will
+	 * modify it, make a private copy here
+	 */
+	list_for_each_entry(cur_fs, fs_uuids, list) {
+		/* don't bother handle all fs, if search target specified */
+		if (search) {
+			if (uuid_search(cur_fs, search) == 0)
+				continue;
+			*found = 1;
+		}
+
+		fs_copy = malloc(sizeof(*fs_copy));
+		if (!fs_copy) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		ret = copy_fs_devices(fs_copy, cur_fs);
+		if (ret) {
+			free(fs_copy);
+			goto out;
+		}
+
+		list_add(&fs_copy->list, all_uuids);
+	}
+
+	list_for_each_entry(cur_fs, all_uuids, list) {
+		device = list_first_entry(&cur_fs->devices,
+						struct btrfs_device, dev_list);
+		if (!device)
+			continue;
+		/*
+		 * open_ctree_* detects seed/sprout mapping
+		 */
+		fs_info = open_ctree_fs_info(device->name, 0, 0,
+						OPEN_CTREE_PARTIAL);
+		if (!fs_info)
+			continue;
+
+		/*
+		 * copy the seed chain under the opened fs
+		 */
+		opened_fs = fs_info->fs_devices;
+		cur_seed = cur_fs;
+		while (opened_fs->seed) {
+			seed_copy = malloc(sizeof(*seed_copy));
+			if (!seed_copy) {
+				ret = -ENOMEM;
+				goto fail_out;
+			}
+			ret = find_and_copy_seed(opened_fs->seed, seed_copy,
+						 fs_uuids);
+			if (ret) {
+				free(seed_copy);
+				goto fail_out;
+			}
+
+			cur_seed->seed = seed_copy;
+
+			opened_fs = opened_fs->seed;
+			cur_seed = cur_seed->seed;
+		}
+
+		close_ctree(fs_info->chunk_root);
+	}
+
+out:
+	return ret;
+fail_out:
+	close_ctree(fs_info->chunk_root);
+	goto out;
+}
+
 static const char * const cmd_show_usage[] = {
 	"btrfs filesystem show [options] [<path>|<uuid>|<device>|label]",
 	"Show the structure of a filesystem",
@@ -500,9 +739,8 @@ static const char * const cmd_show_usage[] = {
 
 static int cmd_show(int argc, char **argv)
 {
-	struct list_head *all_uuids;
+	LIST_HEAD(all_uuids);
 	struct btrfs_fs_devices *fs_devices;
-	struct list_head *cur_uuid;
 	char *search = NULL;
 	int ret;
 	int where = -1; // default, search both kernel and udev
@@ -607,24 +845,28 @@ devs_only:
 		fprintf(stderr, "ERROR: %d while scanning\n", ret);
 		return 1;
 	}
-	
-	all_uuids = btrfs_scanned_uuids();
-	list_for_each(cur_uuid, all_uuids) {
-		fs_devices = list_entry(cur_uuid, struct btrfs_fs_devices,
-					list);
-		if (search && uuid_search(fs_devices, search) == 0)
-			continue;
 
-		print_one_uuid(fs_devices);
-		found = 1;
+	/*
+	 * scan_for_btrfs() don't build seed/sprout mapping,
+	 * do mapping build for each scanned fs here
+	 */
+	ret = map_seed_devices(&all_uuids, search, &found);
+	if (ret) {
+		fprintf(stderr,
+			"ERROR: %d while mapping seed devices\n", ret);
+		return 1;
 	}
+
+	list_for_each_entry(fs_devices, &all_uuids, list)
+		print_one_uuid(fs_devices);
+
 	if (search && !found)
 		ret = 1;
 
-	while (!list_empty(all_uuids)) {
-		fs_devices = list_entry(all_uuids->next,
+	while (!list_empty(&all_uuids)) {
+		fs_devices = list_entry(all_uuids.next,
 					struct btrfs_fs_devices, list);
-		btrfs_close_devices(fs_devices);
+		free_fs_devices(fs_devices);
 	}
 out:
 	printf("%s\n", BTRFS_BUILD_VERSION);
diff --git a/volumes.c b/volumes.c
index 266a474..eaf3f9f 100644
--- a/volumes.c
+++ b/volumes.c
@@ -116,6 +116,7 @@ static int device_list_add(const char *path,
 		}
 		device->fd = -1;
 		device->devid = devid;
+		device->generation = found_transid;
 		memcpy(device->uuid, disk_super->dev_item.uuid,
 		       BTRFS_UUID_SIZE);
 		device->name = kstrdup(path, GFP_NOFS);
diff --git a/volumes.h b/volumes.h
index 447dd4b..221ef34 100644
--- a/volumes.h
+++ b/volumes.h
@@ -39,6 +39,8 @@ struct btrfs_device {
 	u64 total_devs;
 	u64 super_bytes_used;
 
+	u64 generation;
+
 	/* the internal btrfs device id */
 	u64 devid;
 
-- 
1.8.1.4

