Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36218 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3FVFdI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Jun 2013 01:33:08 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH 5/5 v2] Btrfs-progs: enhance btrfs-image to restore image onto multiple disks
Date: Sat, 22 Jun 2013 13:32:45 +0800
Message-Id: <1371879165-4993-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1371879165-4993-1-git-send-email-bo.li.liu@oracle.com>
References: <1371879165-4993-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds a 'btrfs-image -m' option, which let us restore an image that
is built from a btrfs of multiple disks onto several disks altogether.

This aims to address the following case,
$ mkfs.btrfs -m raid0 sda sdb
$ btrfs-image sda image.file
$ btrfs-image -r image.file sdc
---------
so we can only restore metadata onto sdc, and another thing is we can
only mount sdc with degraded mode as we don't provide informations of
another disk.  And, it's built as RAID0 and we have only one disk,
so after mount sdc we'll get into readonly mode.

This is just annoying for people(like me) who're trying to restore image
but turn to find they cannot make it work.

So this'll make your life easier, just tap
$ btrfs-image -m image.file sdc sdd
---------
then you get everything about metadata done, the same offset with that of
the originals(of course, you need offer enough disk size, at least the disk
size of the original disks).

Besides, this also works with raid5 and raid6 metadata image.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v1->v2:
- rebase onto the lastest btrfs-progs
- add support to restore data extent

 btrfs-image.c |  309 ++++++++++++++++++++++++++++++++++++++++++++++++---------
 ctree.h       |    1 +
 disk-io.c     |  231 +++++++++++++------------------------------
 disk-io.h     |    6 +
 extent_io.c   |   87 ++++++++++++++++
 extent_io.h   |    2 +
 volumes.c     |  143 ++++++++++++++++++++++++++
 volumes.h     |    5 +
 8 files changed, 571 insertions(+), 213 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index ebd283e..82aa4f3 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -35,6 +35,7 @@
 #include "utils.h"
 #include "version.h"
 #include "volumes.h"
+#include "extent_io.h"
 
 #define HEADER_MAGIC		0xbd5c25e27295668bULL
 #define MAX_PENDING_SIZE	(256 * 1024)
@@ -136,6 +137,9 @@ struct mdrestore_struct {
 	int done;
 	int error;
 	int old_restore;
+	int fixup_offset;
+	int multi_devices;
+	struct btrfs_fs_info *info;
 };
 
 static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
@@ -1589,9 +1593,10 @@ static void *restore_worker(void *data)
 	u8 *outbuf;
 	int outfd;
 	int ret;
+	int compress_size = MAX_PENDING_SIZE * 4;
 
 	outfd = fileno(mdres->out);
-	buffer = malloc(MAX_PENDING_SIZE * 2);
+	buffer = malloc(compress_size);
 	if (!buffer) {
 		fprintf(stderr, "Error allocing buffer\n");
 		pthread_mutex_lock(&mdres->mutex);
@@ -1619,7 +1624,7 @@ static void *restore_worker(void *data)
 		pthread_mutex_unlock(&mdres->mutex);
 
 		if (mdres->compress_method == COMPRESS_ZLIB) {
-			size = MAX_PENDING_SIZE * 2;
+			size = compress_size; 
 			ret = uncompress(buffer, (unsigned long *)&size,
 					 async->buffer, async->bufsize);
 			if (ret != Z_OK) {
@@ -1633,44 +1638,60 @@ static void *restore_worker(void *data)
 			size = async->bufsize;
 		}
 
-		if (async->start == BTRFS_SUPER_INFO_OFFSET) {
-			if (mdres->old_restore) {
-				update_super_old(outbuf);
-			} else {
-				ret = update_super(outbuf);
+		if (!mdres->multi_devices) {
+			if (async->start == BTRFS_SUPER_INFO_OFFSET) {
+				if (mdres->old_restore) {
+					update_super_old(outbuf);
+				} else {
+					ret = update_super(outbuf);
+					if (ret)
+						err = ret;
+				}
+			} else if (!mdres->old_restore) {
+				ret = fixup_chunk_tree_block(mdres, async, outbuf, size);
 				if (ret)
 					err = ret;
 			}
-		} else if (!mdres->old_restore) {
-			ret = fixup_chunk_tree_block(mdres, async, outbuf, size);
-			if (ret)
-				err = ret;
 		}
 
-		while (size) {
-			u64 chunk_size = size;
-			bytenr = logical_to_physical(mdres,
-						     async->start + offset,
-						     &chunk_size);
-			ret = pwrite64(outfd, outbuf+offset, chunk_size,
-				       bytenr);
-			if (ret < chunk_size) {
-				if (ret < 0) {
-					fprintf(stderr, "Error writing to "
-						"device %d\n", errno);
-					err = errno;
-					break;
-				} else {
-					fprintf(stderr, "Short write\n");
-					err = -EIO;
-					break;
+		if (!mdres->fixup_offset) {
+			while (size) {
+				u64 chunk_size = size;
+				if (!mdres->multi_devices)
+					bytenr = logical_to_physical(mdres,
+								     async->start + offset,
+								     &chunk_size);
+				else
+					bytenr = async->start + offset;
+
+				ret = pwrite64(outfd, outbuf+offset, chunk_size,
+					       bytenr);
+				if (ret != chunk_size) {
+					if (ret < 0) {
+						fprintf(stderr, "Error writing to "
+							"device %d\n", errno);
+						err = errno;
+						break;
+					} else {
+						fprintf(stderr, "Short write\n");
+						err = -EIO;
+						break;
+					}
 				}
+				size -= chunk_size;
+				offset += chunk_size;
+			}
+		} else if (async->start != BTRFS_SUPER_INFO_OFFSET) {
+			ret = write_data_to_disk(mdres->info, outbuf, async->start, size, 0);
+			if (ret) {
+				printk("Error write data\n");
+				exit(1);
 			}
-			size -= chunk_size;
-			offset += chunk_size;
 		}
 
-		if (async->start == BTRFS_SUPER_INFO_OFFSET)
+
+		/* backup super blocks are already there at fixup_offset stage */
+		if (!mdres->multi_devices && async->start == BTRFS_SUPER_INFO_OFFSET)
 			write_backup_supers(outfd, outbuf);
 
 		pthread_mutex_lock(&mdres->mutex);
@@ -1714,7 +1735,8 @@ static void mdrestore_destroy(struct mdrestore_struct *mdres)
 
 static int mdrestore_init(struct mdrestore_struct *mdres,
 			  FILE *in, FILE *out, int old_restore,
-			  int num_threads)
+			  int num_threads, int fixup_offset,
+			  struct btrfs_fs_info *info, int multi_devices)
 {
 	int i, ret = 0;
 
@@ -1726,6 +1748,9 @@ static int mdrestore_init(struct mdrestore_struct *mdres,
 	mdres->out = out;
 	mdres->old_restore = old_restore;
 	mdres->chunk_tree.rb_node = NULL;
+	mdres->fixup_offset = fixup_offset;
+	mdres->info = info;
+	mdres->multi_devices = multi_devices;
 
 	if (!num_threads)
 		return 0;
@@ -2186,12 +2211,14 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 	return search_for_chunk_blocks(mdres, chunk_root_bytenr, 0);
 }
 
-static int restore_metadump(const char *input, FILE *out, int old_restore,
-			    int num_threads)
+static int __restore_metadump(const char *input, FILE *out, int old_restore,
+			      int num_threads, int fixup_offset,
+			      const char *target, int multi_devices)
 {
 	struct meta_cluster *cluster = NULL;
 	struct meta_cluster_header *header;
 	struct mdrestore_struct mdrestore;
+	struct btrfs_fs_info *info = NULL;
 	u64 bytenr = 0;
 	FILE *in = NULL;
 	int ret = 0;
@@ -2206,26 +2233,36 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 		}
 	}
 
+	/* NOTE: open with write mode */
+	if (fixup_offset) {
+		BUG_ON(!target);
+		info = open_ctree_fs_info_restore(target, 0, 0, 1, 1);
+		if (!info) {
+			fprintf(stderr, "%s: open ctree failed\n", __func__);
+			ret = -EIO;
+			goto failed_open;
+		}
+	}
+
 	cluster = malloc(BLOCK_SIZE);
 	if (!cluster) {
 		fprintf(stderr, "Error allocating cluster\n");
-		if (in != stdin)
-			fclose(in);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto failed_info;
 	}
 
-	ret = mdrestore_init(&mdrestore, in, out, old_restore, num_threads);
+	ret = mdrestore_init(&mdrestore, in, out, old_restore, num_threads,
+			     fixup_offset, info, multi_devices);
 	if (ret) {
 		fprintf(stderr, "Error initing mdrestore %d\n", ret);
-		if (in != stdin)
-			fclose(in);
-		free(cluster);
-		return ret;
+		goto failed_cluster;
 	}
 
-	ret = build_chunk_tree(&mdrestore, cluster);
-	if (ret)
-		goto out;
+	if (!multi_devices) {
+		ret = build_chunk_tree(&mdrestore, cluster);
+		if (ret)
+			goto out;
+	}
 
 	if (in != stdin && fseek(in, 0, SEEK_SET)) {
 		fprintf(stderr, "Error seeking %d\n", errno);
@@ -2259,12 +2296,123 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 	}
 out:
 	mdrestore_destroy(&mdrestore);
+failed_cluster:
 	free(cluster);
+failed_info:
+	if (fixup_offset && info)
+		close_ctree(info->chunk_root);
+failed_open:
 	if (in != stdin)
 		fclose(in);
 	return ret;
 }
 
+static int restore_metadump(const char *input, FILE *out, int old_restore,
+			    int num_threads, int multi_devices)
+{
+	return __restore_metadump(input, out, old_restore, num_threads, 0, NULL,
+				  multi_devices);
+}
+
+static int fixup_metadump(const char *input, FILE *out, int num_threads,
+			  const char *target)
+{
+	return __restore_metadump(input, out, 0, num_threads, 1, target, 1);
+}
+
+static int update_disk_super_on_device(struct btrfs_fs_info *info,
+				       const char *other_dev, u64 cur_devid)
+{
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	struct btrfs_path path;
+	struct btrfs_dev_item *dev_item;
+	struct btrfs_super_block *disk_super;
+	char dev_uuid[BTRFS_UUID_SIZE];
+	char fs_uuid[BTRFS_UUID_SIZE];
+	u64 devid, type, io_align, io_width;
+	u64 sector_size, total_bytes, bytes_used;
+	char *buf;
+	int fp;
+	int ret;
+
+	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
+	key.type = BTRFS_DEV_ITEM_KEY;
+	key.offset = cur_devid;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, info->chunk_root, &key, &path, 0, 0); 
+	if (ret) {
+		fprintf(stderr, "search key fails\n");
+		exit(1);
+	}
+
+	leaf = path.nodes[0];
+	dev_item = btrfs_item_ptr(leaf, path.slots[0],
+				  struct btrfs_dev_item);
+
+	devid = btrfs_device_id(leaf, dev_item);
+	if (devid != cur_devid) {
+		printk("devid %llu mismatch with %llu\n", devid, cur_devid);
+		exit(1);
+	}
+
+	type = btrfs_device_type(leaf, dev_item);
+	io_align = btrfs_device_io_align(leaf, dev_item);
+	io_width = btrfs_device_io_width(leaf, dev_item);
+	sector_size = btrfs_device_sector_size(leaf, dev_item);
+	total_bytes = btrfs_device_total_bytes(leaf, dev_item);
+	bytes_used = btrfs_device_bytes_used(leaf, dev_item);
+	read_extent_buffer(leaf, dev_uuid, (unsigned long)btrfs_device_uuid(dev_item), BTRFS_UUID_SIZE);
+	read_extent_buffer(leaf, fs_uuid, (unsigned long)btrfs_device_fsid(dev_item), BTRFS_UUID_SIZE);
+
+	btrfs_release_path(info->chunk_root, &path);
+
+	printk("update disk super on %s devid=%llu\n", other_dev, devid);
+
+	/* update other devices' super block */
+	fp = open(other_dev, O_CREAT | O_RDWR, 0600);
+	if (fp < 0) {
+		fprintf(stderr, "could not open %s\n", other_dev);
+		exit(1);
+	}
+
+	buf = malloc(BTRFS_SUPER_INFO_SIZE);
+	if (!buf) {
+		ret = -ENOMEM;
+		exit(1);
+	}
+
+	memcpy(buf, info->super_copy, BTRFS_SUPER_INFO_SIZE);
+
+	disk_super = (struct btrfs_super_block *)buf;
+	dev_item = &disk_super->dev_item;
+
+	btrfs_set_stack_device_type(dev_item, type);
+	btrfs_set_stack_device_id(dev_item, devid);
+	btrfs_set_stack_device_total_bytes(dev_item, total_bytes);
+	btrfs_set_stack_device_bytes_used(dev_item, bytes_used);
+	btrfs_set_stack_device_io_align(dev_item, io_align);
+	btrfs_set_stack_device_io_width(dev_item, io_width);
+	btrfs_set_stack_device_sector_size(dev_item, sector_size);
+	memcpy(dev_item->uuid, dev_uuid, BTRFS_UUID_SIZE);
+	memcpy(dev_item->fsid, fs_uuid, BTRFS_UUID_SIZE);
+	csum_block((u8 *)buf, BTRFS_SUPER_INFO_SIZE);
+
+	ret = pwrite64(fp, buf, BTRFS_SUPER_INFO_SIZE, BTRFS_SUPER_INFO_OFFSET);
+	if (ret != BTRFS_SUPER_INFO_SIZE) {
+		ret = -EIO;
+		goto out;
+	}
+
+	write_backup_supers(fp, (u8 *)buf);
+
+out:
+	free(buf);
+	close(fp);
+	return 0;
+}
+
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfs-image [options] source target\n");
@@ -2286,12 +2434,14 @@ int main(int argc, char *argv[])
 	int create = 1;
 	int old_restore = 0;
 	int walk_trees = 0;
+	int multi_devices = 0;
 	int ret;
 	int sanitize = 0;
+	int dev_cnt = 0;
 	FILE *out;
 
 	while (1) {
-		int c = getopt(argc, argv, "rc:t:osw");
+		int c = getopt(argc, argv, "rc:t:oswm");
 		if (c < 0)
 			break;
 		switch (c) {
@@ -2317,17 +2467,26 @@ int main(int argc, char *argv[])
 		case 'w':
 			walk_trees = 1;
 			break;
+		case 'm':
+			create = 0;
+			multi_devices = 1;
+			break;
 		default:
 			print_usage();
 		}
 	}
 
-	if (old_restore && create)
+	if ((old_restore) && create)
 		print_usage();
 
 	argc = argc - optind;
-	if (argc != 2)
+	dev_cnt = argc - 1;
+
+	if (multi_devices && dev_cnt < 2)
+		print_usage();
+	if (!multi_devices && dev_cnt != 1)
 		print_usage();
+
 	source = argv[optind];
 	target = argv[optind + 1];
 
@@ -2351,8 +2510,60 @@ int main(int argc, char *argv[])
 		ret = create_metadump(source, out, num_threads,
 				      compress_level, sanitize, walk_trees);
 	else
-		ret = restore_metadump(source, out, old_restore, 1);
+		ret = restore_metadump(source, out, old_restore, 1,
+				       multi_devices);
+	if (ret) {
+		printk("%s failed (%s)\n", (create) ? "create" : "restore",
+		       strerror(errno));
+		goto out;
+	}
+
+	 /* extended support for multiple devices */
+	if (!create && multi_devices) {
+		struct btrfs_fs_info *info;
+		u64 total_devs;
+		int i;
+
+		info = open_ctree_fs_info_restore(target, 0, 0, 0, 1);
+		if (!info) {
+			int e = errno;
+			fprintf(stderr, "unable to open %s error = %s\n",
+				target, strerror(e));
+			return 1;
+		}
+
+		total_devs = btrfs_super_num_devices(info->super_copy);
+		if (total_devs != dev_cnt) {
+			printk("it needs %llu devices but has only %d\n",
+				total_devs, dev_cnt);
+			close_ctree(info->chunk_root);
+			goto out;
+		}
 
+		/* update super block on other disks */
+		for (i = 2; i <= dev_cnt; i++) {
+			ret = update_disk_super_on_device(info,
+					argv[optind + i], (u64)i);
+			if (ret) {
+				printk("update disk super failed devid=%d (error=%d)\n",
+					i, ret);
+				close_ctree(info->chunk_root);
+				exit(1);
+			}
+		}
+
+		close_ctree(info->chunk_root);
+
+		/* fix metadata block to map correct chunk */
+		ret = fixup_metadump(source, out, 1, target);
+		if (ret) {
+			fprintf(stderr, "fix metadump failed (error=%d)\n",
+				ret);
+			exit(1);
+		}
+	}
+
+out:
 	if (out == stdout)
 		fflush(out);
 	else
diff --git a/ctree.h b/ctree.h
index 3fe14b0..6f086bf 100644
--- a/ctree.h
+++ b/ctree.h
@@ -949,6 +949,7 @@ struct btrfs_fs_info {
 	struct list_head space_info;
 	int system_allocs;
 	int readonly;
+	int on_restoring;
 	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
diff --git a/disk-io.c b/disk-io.c
index 9cfd003..f60bb69 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -182,7 +182,7 @@ out:
 }
 
 
-static int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirror)
+int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirror)
 {
 	unsigned long offset = 0;
 	struct btrfs_multi_bio *multi = NULL;
@@ -193,26 +193,40 @@ static int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, i
 
 	while (bytes_left) {
 		read_len = bytes_left;
-		ret = btrfs_map_block(&info->mapping_tree, READ,
-				      eb->start + offset, &read_len, &multi,
-				      mirror, NULL);
-		if (ret) {
-			printk("Couldn't map the block %Lu\n", eb->start + offset);
-			kfree(multi);
-			return -EIO;
-		}
-		device = multi->stripes[0].dev;
+		device = NULL;
+
+		if (!info->on_restoring) {
+			ret = btrfs_map_block(&info->mapping_tree, READ,
+					      eb->start + offset, &read_len, &multi,
+					      mirror, NULL);
+			if (ret) {
+				printk("Couldn't map the block %Lu\n", eb->start + offset);
+				kfree(multi);
+				return -EIO;
+			}
+			device = multi->stripes[0].dev;
 
-		if (device->fd == 0) {
+			if (device->fd == 0) {
+				kfree(multi);
+				return -EIO;
+			}
+
+			eb->fd = device->fd;
+			device->total_ios++;
+			eb->dev_bytenr = multi->stripes[0].physical;
 			kfree(multi);
-			return -EIO;
-		}
+			multi = NULL;
+		} else {
+			/* special case for restore metadump */
+			list_for_each_entry(device, &info->fs_devices->devices, dev_list) {
+				if (device->devid == 1)
+					break;
+			}
 
-		eb->fd = device->fd;
-		device->total_ios++;
-		eb->dev_bytenr = multi->stripes[0].physical;
-		kfree(multi);
-		multi = NULL;
+			eb->fd = device->fd;
+			eb->dev_bytenr = eb->start;
+			device->total_ios++;
+		}
 
 		if (read_len > bytes_left)
 			read_len = bytes_left;
@@ -281,149 +295,6 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 	return NULL;
 }
 
-static int rmw_eb(struct btrfs_fs_info *info,
-		  struct extent_buffer *eb, struct extent_buffer *orig_eb)
-{
-	int ret;
-	unsigned long orig_off = 0;
-	unsigned long dest_off = 0;
-	unsigned long copy_len = eb->len;
-
-	ret = read_whole_eb(info, eb, 0);
-	if (ret)
-		return ret;
-
-	if (eb->start + eb->len <= orig_eb->start ||
-	    eb->start >= orig_eb->start + orig_eb->len)
-		return 0;
-	/*
-	 * | ----- orig_eb ------- |
-	 *         | ----- stripe -------  |
-	 *         | ----- orig_eb ------- |
-	 *              | ----- orig_eb ------- |
-	 */
-	if (eb->start > orig_eb->start)
-		orig_off = eb->start - orig_eb->start;
-	if (orig_eb->start > eb->start)
-		dest_off = orig_eb->start - eb->start;
-
-	if (copy_len > orig_eb->len - orig_off)
-		copy_len = orig_eb->len - orig_off;
-	if (copy_len > eb->len - dest_off)
-		copy_len = eb->len - dest_off;
-
-	memcpy(eb->data + dest_off, orig_eb->data + orig_off, copy_len);
-	return 0;
-}
-
-static void split_eb_for_raid56(struct btrfs_fs_info *info,
-				struct extent_buffer *orig_eb,
-			       struct extent_buffer **ebs,
-			       u64 stripe_len, u64 *raid_map,
-			       int num_stripes)
-{
-	struct extent_buffer *eb;
-	u64 start = orig_eb->start;
-	u64 this_eb_start;
-	int i;
-	int ret;
-
-	for (i = 0; i < num_stripes; i++) {
-		if (raid_map[i] >= BTRFS_RAID5_P_STRIPE)
-			break;
-
-		eb = malloc(sizeof(struct extent_buffer) + stripe_len);
-		if (!eb)
-			BUG();
-		memset(eb, 0, sizeof(struct extent_buffer) + stripe_len);
-
-		eb->start = raid_map[i];
-		eb->len = stripe_len;
-		eb->refs = 1;
-		eb->flags = 0;
-		eb->fd = -1;
-		eb->dev_bytenr = (u64)-1;
-
-		this_eb_start = raid_map[i];
-
-		if (start > this_eb_start ||
-		    start + orig_eb->len < this_eb_start + stripe_len) {
-			ret = rmw_eb(info, eb, orig_eb);
-			BUG_ON(ret);
-		} else {
-			memcpy(eb->data, orig_eb->data + eb->start - start, stripe_len);
-		}
-		ebs[i] = eb;
-	}
-}
-
-static int write_raid56_with_parity(struct btrfs_fs_info *info,
-				    struct extent_buffer *eb,
-				    struct btrfs_multi_bio *multi,
-				    u64 stripe_len, u64 *raid_map)
-{
-	struct extent_buffer *ebs[multi->num_stripes], *p_eb = NULL, *q_eb = NULL;
-	int i;
-	int j;
-	int ret;
-	int alloc_size = eb->len;
-
-	if (stripe_len > alloc_size)
-		alloc_size = stripe_len;
-
-	split_eb_for_raid56(info, eb, ebs, stripe_len, raid_map,
-			    multi->num_stripes);
-
-	for (i = 0; i < multi->num_stripes; i++) {
-		struct extent_buffer *new_eb;
-		if (raid_map[i] < BTRFS_RAID5_P_STRIPE) {
-			ebs[i]->dev_bytenr = multi->stripes[i].physical;
-			ebs[i]->fd = multi->stripes[i].dev->fd;
-			multi->stripes[i].dev->total_ios++;
-			BUG_ON(ebs[i]->start != raid_map[i]);
-			continue;
-		}
-		new_eb = kmalloc(sizeof(*eb) + alloc_size, GFP_NOFS);
-		BUG_ON(!new_eb);
-		new_eb->dev_bytenr = multi->stripes[i].physical;
-		new_eb->fd = multi->stripes[i].dev->fd;
-		multi->stripes[i].dev->total_ios++;
-		new_eb->len = stripe_len;
-
-		if (raid_map[i] == BTRFS_RAID5_P_STRIPE)
-			p_eb = new_eb;
-		else if (raid_map[i] == BTRFS_RAID6_Q_STRIPE)
-			q_eb = new_eb;
-	}
-	if (q_eb) {
-		void *pointers[multi->num_stripes];
-		ebs[multi->num_stripes - 2] = p_eb;
-		ebs[multi->num_stripes - 1] = q_eb;
-
-		for (i = 0; i < multi->num_stripes; i++)
-			pointers[i] = ebs[i]->data;
-
-		raid6_gen_syndrome(multi->num_stripes, stripe_len, pointers);
-	} else {
-		ebs[multi->num_stripes - 1] = p_eb;
-		memcpy(p_eb->data, ebs[0]->data, stripe_len);
-		for (j = 1; j < multi->num_stripes - 1; j++) {
-			for (i = 0; i < stripe_len; i += sizeof(unsigned long)) {
-				*(unsigned long *)(p_eb->data + i) ^=
-					*(unsigned long *)(ebs[j]->data + i);
-			}
-		}
-	}
-
-	for (i = 0; i < multi->num_stripes; i++) {
-		ret = write_extent_to_disk(ebs[i]);
-		BUG_ON(ret);
-		if (ebs[i] != eb)
-			kfree(ebs[i]);
-	}
-	return 0;
-}
-
 int write_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		     struct extent_buffer *eb)
 {
@@ -435,6 +306,7 @@ int write_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 	if (check_tree_block(root, eb))
 		BUG();
+
 	if (!btrfs_buffer_uptodate(eb, trans->transid))
 		BUG();
 
@@ -801,7 +673,7 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 					     u64 sb_bytenr,
 					     u64 root_tree_bytenr, int writes,
-					     int partial)
+					     int partial, int restore)
 {
 	u32 sectorsize;
 	u32 nodesize;
@@ -822,6 +694,12 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	u64 total_devs;
 	u64 features;
 
+	memset(tree_root, 0, sizeof(struct btrfs_root));
+	memset(extent_root, 0, sizeof(struct btrfs_root));
+	memset(chunk_root, 0, sizeof(struct btrfs_root));
+	memset(dev_root, 0, sizeof(struct btrfs_root));
+	memset(csum_root, 0, sizeof(struct btrfs_root));
+
 	if (sb_bytenr == 0)
 		sb_bytenr = BTRFS_SUPER_INFO_OFFSET;
 
@@ -853,6 +731,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 	if (!writes)
 		fs_info->readonly = 1;
+	if (restore)
+		fs_info->on_restoring = 1;
 
 	extent_io_tree_init(&fs_info->extent_cache);
 	extent_io_tree_init(&fs_info->free_space_cache);
@@ -1046,6 +926,29 @@ out:
 	return NULL;
 }
 
+struct btrfs_fs_info *open_ctree_fs_info_restore(const char *filename,
+					 u64 sb_bytenr, u64 root_tree_bytenr,
+					 int writes, int partial)
+{
+	int fp;
+	struct btrfs_fs_info *info;
+	int flags = O_CREAT | O_RDWR;
+	int restore = 1;
+
+	if (!writes)
+		flags = O_RDONLY;
+
+	fp = open(filename, flags, 0600);
+	if (fp < 0) {
+		fprintf (stderr, "Could not open %s\n", filename);
+		return NULL;
+	}
+	info = __open_ctree_fd(fp, filename, sb_bytenr, root_tree_bytenr,
+			       writes, partial, restore);
+	close(fp);
+	return info;
+}
+
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
 					 int writes, int partial)
@@ -1063,7 +966,7 @@ struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 		return NULL;
 	}
 	info = __open_ctree_fd(fp, filename, sb_bytenr, root_tree_bytenr,
-			       writes, partial);
+			       writes, partial, 0);
 	close(fp);
 	return info;
 }
@@ -1082,7 +985,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				 int writes)
 {
 	struct btrfs_fs_info *info;
-	info = __open_ctree_fd(fp, path, sb_bytenr, 0, writes, 0);
+	info = __open_ctree_fd(fp, path, sb_bytenr, 0, writes, 0, 0);
 	if (!info)
 		return NULL;
 	return info->fs_root;
diff --git a/disk-io.h b/disk-io.h
index c29ee8e..0158d17 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -35,10 +35,13 @@ static inline u64 btrfs_sb_offset(int mirror)
 
 struct btrfs_device;
 
+int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirror);
 struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				      u32 blocksize, u64 parent_transid);
 int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			 u64 parent_transid);
+int write_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		     struct extent_buffer *eb);
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						   u64 bytenr, u32 blocksize);
 
@@ -50,6 +53,9 @@ int clean_tree_block(struct btrfs_trans_handle *trans,
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes);
 struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				 int writes);
+struct btrfs_fs_info *open_ctree_fs_info_restore(const char *filename,
+					 u64 sb_bytenr, u64 root_tree_bytenr,
+					 int writes, int partial);
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
 					 int writes, int partial);
diff --git a/extent_io.c b/extent_io.c
index 5093aeb..592acd6 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -747,6 +747,93 @@ int read_data_from_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
 	return 0;
 }
 
+int write_data_to_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
+		      u64 bytes, int mirror)
+{
+	struct btrfs_multi_bio *multi = NULL;
+	struct btrfs_device *device;
+	u64 bytes_left = bytes;
+	u64 this_len;
+	u64 total_write = 0;
+	u64 *raid_map = NULL;
+	u64 dev_bytenr;
+	int dev_nr;
+	int ret = 0;
+
+	while (bytes_left > 0) {
+		this_len = bytes_left;
+		dev_nr = 0;
+
+		ret = btrfs_map_block(&info->mapping_tree, WRITE, offset,
+				      &this_len, &multi, mirror, &raid_map);
+		if (ret) {
+			fprintf(stderr, "Couldn't map the block %Lu\n",
+				offset);
+			return -EIO;
+		}
+
+		if (raid_map) {
+			struct extent_buffer *eb;
+			u64 stripe_len = this_len;
+
+			this_len = min(this_len, bytes_left);
+			this_len = min(this_len, (u64)info->tree_root->leafsize);
+
+			eb = malloc(sizeof(struct extent_buffer) + this_len);
+			BUG_ON(!eb);
+
+			memset(eb, 0, sizeof(struct extent_buffer) + this_len);
+			eb->start = offset;
+			eb->len = this_len;
+
+			memcpy(eb->data, buf + total_write, this_len);
+			ret = write_raid56_with_parity(info, eb, multi,
+						       stripe_len, raid_map);
+			BUG_ON(ret);
+
+			free(eb);
+			kfree(raid_map);
+			raid_map = NULL;
+		} else while (dev_nr < multi->num_stripes) {
+			device = multi->stripes[dev_nr].dev;
+			if (device->fd == 0) {
+				kfree(multi);
+				return -EIO;
+			}
+
+			dev_bytenr = multi->stripes[dev_nr].physical;
+			this_len = min(this_len, bytes_left);
+			dev_nr++;
+
+			ret = pwrite(device->fd, buf + total_write, this_len, dev_bytenr);
+			if (ret != this_len) {
+				if (ret < 0) {
+					fprintf(stderr, "Error writing to "
+						"device %d\n", errno);
+					ret = errno;
+					kfree(multi);
+					return ret;
+				} else {
+					fprintf(stderr, "Short write\n");
+					kfree(multi);
+					return -EIO;
+				}
+			}
+		}
+
+		BUG_ON(bytes_left < this_len);
+
+		bytes_left -= this_len;
+		offset += this_len;
+		total_write += this_len;
+
+		kfree(multi);
+		multi = NULL;
+	}
+	return 0;
+}
+
+
 int set_extent_buffer_uptodate(struct extent_buffer *eb)
 {
 	eb->flags |= EXTENT_UPTODATE;
diff --git a/extent_io.h b/extent_io.h
index a0308a9..bef7fe5 100644
--- a/extent_io.h
+++ b/extent_io.h
@@ -126,4 +126,6 @@ int set_extent_buffer_dirty(struct extent_buffer *eb);
 int clear_extent_buffer_dirty(struct extent_buffer *eb);
 int read_data_from_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
 			u64 bytes, int mirror);
+int write_data_to_disk(struct btrfs_fs_info *info, void *buf, u64 offset,
+		       u64 bytes, int mirror);
 #endif
diff --git a/volumes.c b/volumes.c
index f9ac2af..e2bb433 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1775,3 +1775,146 @@ struct list_head *btrfs_scanned_uuids(void)
 {
 	return &fs_uuids;
 }
+
+static int rmw_eb(struct btrfs_fs_info *info,
+		  struct extent_buffer *eb, struct extent_buffer *orig_eb)
+{
+	int ret;
+	unsigned long orig_off = 0;
+	unsigned long dest_off = 0;
+	unsigned long copy_len = eb->len;
+
+	ret = read_whole_eb(info, eb, 0);
+	if (ret)
+		return ret;
+
+	if (eb->start + eb->len <= orig_eb->start ||
+	    eb->start >= orig_eb->start + orig_eb->len)
+		return 0;
+	/*
+	 * | ----- orig_eb ------- |
+	 *         | ----- stripe -------  |
+	 *         | ----- orig_eb ------- |
+	 *              | ----- orig_eb ------- |
+	 */
+	if (eb->start > orig_eb->start)
+		orig_off = eb->start - orig_eb->start;
+	if (orig_eb->start > eb->start)
+		dest_off = orig_eb->start - eb->start;
+
+	if (copy_len > orig_eb->len - orig_off)
+		copy_len = orig_eb->len - orig_off;
+	if (copy_len > eb->len - dest_off)
+		copy_len = eb->len - dest_off;
+
+	memcpy(eb->data + dest_off, orig_eb->data + orig_off, copy_len);
+	return 0;
+}
+
+static void split_eb_for_raid56(struct btrfs_fs_info *info,
+				struct extent_buffer *orig_eb,
+			       struct extent_buffer **ebs,
+			       u64 stripe_len, u64 *raid_map,
+			       int num_stripes)
+{
+	struct extent_buffer *eb;
+	u64 start = orig_eb->start;
+	u64 this_eb_start;
+	int i;
+	int ret;
+
+	for (i = 0; i < num_stripes; i++) {
+		if (raid_map[i] >= BTRFS_RAID5_P_STRIPE)
+			break;
+
+		eb = malloc(sizeof(struct extent_buffer) + stripe_len);
+		if (!eb)
+			BUG();
+		memset(eb, 0, sizeof(struct extent_buffer) + stripe_len);
+
+		eb->start = raid_map[i];
+		eb->len = stripe_len;
+		eb->refs = 1;
+		eb->flags = 0;
+		eb->fd = -1;
+		eb->dev_bytenr = (u64)-1;
+
+		this_eb_start = raid_map[i];
+
+		if (start > this_eb_start ||
+		    start + orig_eb->len < this_eb_start + stripe_len) {
+			ret = rmw_eb(info, eb, orig_eb);
+			BUG_ON(ret);
+		} else {
+			memcpy(eb->data, orig_eb->data + eb->start - start, stripe_len);
+		}
+		ebs[i] = eb;
+	}
+}
+
+int write_raid56_with_parity(struct btrfs_fs_info *info,
+			     struct extent_buffer *eb,
+			     struct btrfs_multi_bio *multi,
+			     u64 stripe_len, u64 *raid_map)
+{
+	struct extent_buffer *ebs[multi->num_stripes], *p_eb = NULL, *q_eb = NULL;
+	int i;
+	int j;
+	int ret;
+	int alloc_size = eb->len;
+
+	if (stripe_len > alloc_size)
+		alloc_size = stripe_len;
+
+	split_eb_for_raid56(info, eb, ebs, stripe_len, raid_map,
+			    multi->num_stripes);
+
+	for (i = 0; i < multi->num_stripes; i++) {
+		struct extent_buffer *new_eb;
+		if (raid_map[i] < BTRFS_RAID5_P_STRIPE) {
+			ebs[i]->dev_bytenr = multi->stripes[i].physical;
+			ebs[i]->fd = multi->stripes[i].dev->fd;
+			multi->stripes[i].dev->total_ios++;
+			BUG_ON(ebs[i]->start != raid_map[i]);
+			continue;
+		}
+		new_eb = kmalloc(sizeof(*eb) + alloc_size, GFP_NOFS);
+		BUG_ON(!new_eb);
+		new_eb->dev_bytenr = multi->stripes[i].physical;
+		new_eb->fd = multi->stripes[i].dev->fd;
+		multi->stripes[i].dev->total_ios++;
+		new_eb->len = stripe_len;
+
+		if (raid_map[i] == BTRFS_RAID5_P_STRIPE)
+			p_eb = new_eb;
+		else if (raid_map[i] == BTRFS_RAID6_Q_STRIPE)
+			q_eb = new_eb;
+	}
+	if (q_eb) {
+		void *pointers[multi->num_stripes];
+		ebs[multi->num_stripes - 2] = p_eb;
+		ebs[multi->num_stripes - 1] = q_eb;
+
+		for (i = 0; i < multi->num_stripes; i++)
+			pointers[i] = ebs[i]->data;
+
+		raid6_gen_syndrome(multi->num_stripes, stripe_len, pointers);
+	} else {
+		ebs[multi->num_stripes - 1] = p_eb;
+		memcpy(p_eb->data, ebs[0]->data, stripe_len);
+		for (j = 1; j < multi->num_stripes - 1; j++) {
+			for (i = 0; i < stripe_len; i += sizeof(unsigned long)) {
+				*(unsigned long *)(p_eb->data + i) ^=
+					*(unsigned long *)(ebs[j]->data + i);
+			}
+		}
+	}
+
+	for (i = 0; i < multi->num_stripes; i++) {
+		ret = write_extent_to_disk(ebs[i]);
+		BUG_ON(ret);
+		if (ebs[i] != eb)
+			kfree(ebs[i]);
+	}
+	return 0;
+}
diff --git a/volumes.h b/volumes.h
index 911f788..105179f 100644
--- a/volumes.h
+++ b/volumes.h
@@ -190,4 +190,9 @@ int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 struct btrfs_device *btrfs_find_device_by_devid(struct btrfs_root *root,
                                                 u64 devid, int instance);
+
+int write_raid56_with_parity(struct btrfs_fs_info *info,
+			     struct extent_buffer *eb,
+			     struct btrfs_multi_bio *multi,
+			     u64 stripe_len, u64 *raid_map);
 #endif
-- 
1.7.7

