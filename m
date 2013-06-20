Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27412 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965343Ab3FTMFq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 08:05:46 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5KBxS8w026458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 11:59:29 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5KC5jh2014077
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:05:45 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5KC5ixp024276
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:05:44 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] Btrfs-progs: exhance btrfs-image to restore image onto multiple disks
Date: Thu, 20 Jun 2013 20:05:30 +0800
Message-Id: <1371729930-22497-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
References: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
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
 btrfs-image.c |  294 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
 ctree.h       |    1 +
 disk-io.c     |   90 +++++++++++++-----
 disk-io.h     |    5 +
 4 files changed, 332 insertions(+), 58 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index e5ff795..6ca4589 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -119,6 +119,9 @@ struct mdrestore_struct {
 	int done;
 	int error;
 	int old_restore;
+	int fixup_offset;
+	int multi_devices;
+	struct btrfs_fs_info *info;
 };
 
 static void csum_block(u8 *buf, size_t len)
@@ -1233,33 +1236,67 @@ static void *restore_worker(void *data)
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
+				ret = fixup_chunk_tree_block(mdres, async,
+							     outbuf, size);
 				if (ret)
 					err = ret;
 			}
-		} else if (!mdres->old_restore) {
-			ret = fixup_chunk_tree_block(mdres, async, outbuf, size);
-			if (ret)
-				err = ret;
 		}
 
-		ret = pwrite64(outfd, outbuf, size, async->start);
-		if (ret < size) {
-			if (ret < 0) {
-				fprintf(stderr, "Error writing to device %d\n",
-					errno);
-				err = errno;
-			} else {
-				fprintf(stderr, "Short write\n");
-				err = -EIO;
+		if (!mdres->fixup_offset) {
+			ret = pwrite64(outfd, outbuf, size, async->start);
+			if (ret != size) {
+				if (ret < 0) {
+					fprintf(stderr, "Error writing to device %d\n",
+						errno);
+					err = errno;
+				} else {
+					fprintf(stderr, "Short write\n");
+					err = -EIO;
+				}
+			}
+		} else if (async->start != BTRFS_SUPER_INFO_OFFSET) {
+			u64 cur_off;
+			size_t cur_size;
+			struct extent_buffer *eb;
+
+			cur_size = size;
+			cur_off = 0;
+			while (cur_size > 0) {
+				eb = read_tree_block(mdres->info->chunk_root,
+						     async->start + cur_off,
+						     mdres->leafsize, 0);
+				BUG_ON(!eb); /* we should have eb now */
+
+				if (memcmp(eb->data, outbuf + cur_off,
+				           mdres->leafsize)) {
+					printk("%s: eb %llu NOT same with outbuf\n", __func__, eb->start);
+					free_extent_buffer(eb);
+					exit(1);
+				}
+
+				write_tree_block(NULL, mdres->info->chunk_root,
+						 eb);
+
+				free_extent_buffer(eb);
+
+				cur_size -= mdres->leafsize;
+				cur_off += mdres->leafsize;
 			}
 		}
 
-		if (async->start == BTRFS_SUPER_INFO_OFFSET)
+		/* backup super blocks are already there at fixup_offset stage */
+		if (!mdres->fixup_offset && async->start == BTRFS_SUPER_INFO_OFFSET)
 			write_backup_supers(outfd, outbuf);
 
 		pthread_mutex_lock(&mdres->mutex);
@@ -1294,7 +1331,8 @@ static void mdrestore_destroy(struct mdrestore_struct *mdres)
 
 static int mdrestore_init(struct mdrestore_struct *mdres,
 			  FILE *in, FILE *out, int old_restore,
-			  int num_threads)
+			  int num_threads, int fixup_offset,
+			  struct btrfs_fs_info *info, int multi_devices)
 {
 	int i, ret = 0;
 
@@ -1305,6 +1343,9 @@ static int mdrestore_init(struct mdrestore_struct *mdres,
 	mdres->in = in;
 	mdres->out = out;
 	mdres->old_restore = old_restore;
+	mdres->fixup_offset = fixup_offset;
+	mdres->info = info;
+	mdres->multi_devices = multi_devices;
 
 	if (!num_threads)
 		return 0;
@@ -1450,12 +1491,14 @@ static int wait_for_worker(struct mdrestore_struct *mdres)
 	return ret;
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
@@ -1470,21 +1513,29 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
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
 
 	while (1) {
@@ -1514,12 +1565,123 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 	}
 
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
+	csum_block((u8 *)buf, 4096);
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
@@ -1528,6 +1690,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-t value\tnumber of threads (1 ~ 32)\n");
 	fprintf(stderr, "\t-o      \tdon't mess with the chunk tree when restoring\n");
 	fprintf(stderr, "\t-w      \twalk all trees instead of using extent tree, do this if your extent tree is broken\n");
+	fprintf(stderr, "\t-m      \trestore metadump image when btrfs has two or more devices\n");
 	exit(1);
 }
 
@@ -1540,11 +1703,13 @@ int main(int argc, char *argv[])
 	int create = 1;
 	int old_restore = 0;
 	int walk_trees = 0;
+	int multi_devices = 0;
 	int ret;
+	int dev_cnt;
 	FILE *out;
 
 	while (1) {
-		int c = getopt(argc, argv, "rc:t:ow");
+		int c = getopt(argc, argv, "rc:t:owm");
 		if (c < 0)
 			break;
 		switch (c) {
@@ -1567,17 +1732,26 @@ int main(int argc, char *argv[])
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
 
@@ -1601,8 +1775,60 @@ int main(int argc, char *argv[])
 		ret = create_metadump(source, out, num_threads,
 				      compress_level, walk_trees);
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
 
+		total_devs = btrfs_super_num_devices(info->super_copy);
+		if (total_devs != dev_cnt) {
+			printk("it needs %llu devices but has only %d\n",
+				total_devs, dev_cnt);
+			close_ctree(info->chunk_root);
+			goto out;
+		}
+
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
index bbbb411..2eabf3e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -951,6 +951,7 @@ struct btrfs_fs_info {
 	struct list_head space_info;
 	int system_allocs;
 	int readonly;
+	int on_restoring;
 	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
diff --git a/disk-io.c b/disk-io.c
index 2892300..0debfe7 100644
--- a/disk-io.c
+++ b/disk-io.c
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
+
+			if (device->fd == 0) {
+				kfree(multi);
+				return -EIO;
+			}
 
-		if (device->fd == 0) {
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
@@ -435,11 +449,14 @@ int write_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 	if (check_tree_block(root, eb))
 		BUG();
-	if (!btrfs_buffer_uptodate(eb, trans->transid))
-		BUG();
 
-	btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
-	csum_tree_block(root, eb, 0);
+	if (trans) {
+		if (!btrfs_buffer_uptodate(eb, trans->transid))
+			BUG();
+
+		btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
+		csum_tree_block(root, eb, 0);
+	}
 
 	dev_nr = 0;
 	length = eb->len;
@@ -798,7 +815,7 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 					     u64 sb_bytenr,
 					     u64 root_tree_bytenr, int writes,
-					     int partial)
+					     int partial, int restore)
 {
 	u32 sectorsize;
 	u32 nodesize;
@@ -850,6 +867,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 	if (!writes)
 		fs_info->readonly = 1;
+	if (restore)
+		fs_info->on_restoring = 1;
 
 	extent_io_tree_init(&fs_info->extent_cache);
 	extent_io_tree_init(&fs_info->free_space_cache);
@@ -1043,6 +1062,29 @@ out:
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
@@ -1060,7 +1102,7 @@ struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 		return NULL;
 	}
 	info = __open_ctree_fd(fp, filename, sb_bytenr, root_tree_bytenr,
-			       writes, partial);
+			       writes, partial, 0);
 	close(fp);
 	return info;
 }
@@ -1079,7 +1121,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				 int writes)
 {
 	struct btrfs_fs_info *info;
-	info = __open_ctree_fd(fp, path, sb_bytenr, 0, writes, 0);
+	info = __open_ctree_fd(fp, path, sb_bytenr, 0, writes, 0, 0);
 	if (!info)
 		return NULL;
 	return info->fs_root;
diff --git a/disk-io.h b/disk-io.h
index c29ee8e..ffebb70 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -39,6 +39,8 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				      u32 blocksize, u64 parent_transid);
 int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			 u64 parent_transid);
+int write_tree_block(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		     struct extent_buffer *eb);
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						   u64 bytenr, u32 blocksize);
 
@@ -50,6 +52,9 @@ int clean_tree_block(struct btrfs_trans_handle *trans,
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes);
 struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				 int writes);
+struct btrfs_fs_info *open_ctree_fs_info_restore(const char *filename,
+					 u64 sb_bytenr, u64 root_tree_bytenr,
+					 int writes, int partial);
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
 					 int writes, int partial);
-- 
1.7.7

