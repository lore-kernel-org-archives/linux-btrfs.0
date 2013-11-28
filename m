Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38903 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab3K1Ffi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 00:35:38 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rAS5ZNXl008146
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Nov 2013 13:35:34 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/4] btrfs-progs: add chunk-recover raid0/5/6 data stripes rebuild routine
Date: Thu, 28 Nov 2013 13:32:51 +0800
Message-Id: <1385616772-13222-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1385616772-13222-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1385616772-13222-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Decide the raid0/5/6 data stripes' order using checksums.
For one chunk, fetch each 64k logical stripe
	1. search its checksum in the csum tree
	2. read the physical stripe data on each device
	3. calc the data checksums
	4. if one checksum matches the value from the csum tree,
	   then the logical stripe resides in that device,
	   the stripe order index can be calculated.
	5. if more than one checksums match,
	   then use the successive csum in the tree to compare again.
	6. if equal stripes are encountered, just fetch next stripe.
	7. if some devices' order are still not decided, then they
	   can not be recovered.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 chunk-recover.c | 371 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 371 insertions(+)

diff --git a/chunk-recover.c b/chunk-recover.c
index 45d6eae..ac2a437 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1566,6 +1566,371 @@ static int btrfs_rebuild_chunk_stripes(struct recover_control *rc,
 	return ret;
 }
 
+static int next_csum(struct btrfs_root *root,
+		     struct extent_buffer **leaf,
+		     struct btrfs_path *path,
+		     int *slot,
+		     u64 *csum_offset,
+		     u32 *tree_csum,
+		     u64 end,
+		     struct btrfs_key *key)
+{
+	int ret = 0;
+	struct btrfs_root *csum_root = root->fs_info->csum_root;
+	struct btrfs_csum_item *csum_item;
+	u32 blocksize = root->sectorsize;
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+	int csums_in_item = btrfs_item_size_nr(*leaf, *slot) / csum_size;
+
+	if (*csum_offset >= csums_in_item) {
+		++(*slot);
+		*csum_offset = 0;
+		if (*slot >= btrfs_header_nritems(*leaf)) {
+			ret = btrfs_next_leaf(csum_root, path);
+			if (ret < 0)
+				return -1;
+			else if (ret > 0)
+				return 1;
+			*leaf = path->nodes[0];
+			*slot = path->slots[0];
+		}
+		btrfs_item_key_to_cpu(*leaf, key, *slot);
+	}
+
+	if (key->offset + (*csum_offset) * blocksize >= end)
+		return 2;
+	csum_item = btrfs_item_ptr(*leaf, *slot, struct btrfs_csum_item);
+	csum_item = (struct btrfs_csum_item *)((unsigned char *)csum_item
+					     + (*csum_offset) * csum_size);
+	read_extent_buffer(*leaf, tree_csum,
+			  (unsigned long)csum_item, csum_size);
+	return ret;
+}
+
+static u64 calc_data_offset(struct btrfs_key *key,
+			    struct chunk_record *chunk,
+			    u64 dev_offset,
+			    u64 csum_offset,
+			    u32 blocksize)
+{
+	u64 data_offset;
+	int logical_stripe_nr;
+	int dev_stripe_nr;
+	int nr_data_stripes;
+
+	data_offset = key->offset + csum_offset * blocksize - chunk->offset;
+	nr_data_stripes = chunk->num_stripes;
+
+	if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID5)
+		nr_data_stripes -= 1;
+	else if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID6)
+		nr_data_stripes -= 2;
+
+	logical_stripe_nr = data_offset / chunk->stripe_len;
+	dev_stripe_nr = logical_stripe_nr / nr_data_stripes;
+
+	data_offset -= logical_stripe_nr * chunk->stripe_len;
+	data_offset += dev_stripe_nr * chunk->stripe_len;
+
+	return dev_offset + data_offset;
+}
+
+static int check_one_csum(int fd, u64 start, u32 len, u32 tree_csum)
+{
+	char *data;
+	int ret = 0;
+	u32 csum_result = ~(u32)0;
+
+	data = malloc(len);
+	if (!data)
+		return -1;
+	ret = pread64(fd, data, len, start);
+	if (ret < 0 || ret != len) {
+		ret = -1;
+		goto out;
+	}
+	ret = 0;
+	csum_result = btrfs_csum_data(NULL, data, csum_result, len);
+	btrfs_csum_final(csum_result, (char *)&csum_result);
+	if (csum_result != tree_csum)
+		ret = 1;
+out:
+	free(data);
+	return ret;
+}
+
+static u64 item_end_offset(struct btrfs_root *root, struct btrfs_key *key,
+			   struct extent_buffer *leaf, int slot) {
+	u32 blocksize = root->sectorsize;
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+
+	u64 offset = btrfs_item_size_nr(leaf, slot);
+	offset /= csum_size;
+	offset *= blocksize;
+	offset += key->offset;
+
+	return offset;
+}
+
+static int insert_stripe(struct list_head *devexts,
+			 struct recover_control *rc,
+			 struct chunk_record *chunk,
+			 int index) {
+	struct device_extent_record *devext;
+	struct btrfs_device *dev;
+
+	devext = list_entry(devexts->next, struct device_extent_record,
+			    chunk_list);
+	dev = btrfs_find_device_by_devid(rc->fs_devices, devext->objectid,
+					0);
+	if (!dev)
+		return 1;
+	BUG_ON(btrfs_find_device_by_devid(rc->fs_devices, devext->objectid,
+					1));
+
+	chunk->stripes[index].devid = devext->objectid;
+	chunk->stripes[index].offset = devext->offset;
+	memcpy(chunk->stripes[index].dev_uuid, dev->uuid, BTRFS_UUID_SIZE);
+
+	list_move(&devext->chunk_list, &chunk->dextents);
+
+	return 0;
+}
+
+#define EQUAL_STRIPE (1 << 0)
+
+static int rebuild_raid_data_chunk_stripes(struct recover_control *rc,
+					   struct btrfs_root *root,
+					   struct chunk_record *chunk,
+					   u8 *flags)
+{
+	int i;
+	int ret = 0;
+	int slot;
+	struct btrfs_path path;
+	struct btrfs_key prev_key;
+	struct btrfs_key key;
+	struct btrfs_root *csum_root;
+	struct extent_buffer *leaf;
+	struct device_extent_record *devext;
+	struct device_extent_record *next;
+	struct btrfs_device *dev;
+	u64 start = chunk->offset;
+	u64 end = start + chunk->stripe_len;
+	u64 chunk_end = chunk->offset + chunk->length;
+	u64 csum_offset = 0;
+	u64 data_offset;
+	u32 blocksize = root->sectorsize;
+	u32 tree_csum;
+	int index = 0;
+	int num_unordered = 0;
+	LIST_HEAD(unordered);
+	LIST_HEAD(candidates);
+
+	csum_root = root->fs_info->csum_root;
+	btrfs_init_path(&path);
+	list_splice_init(&chunk->dextents, &candidates);
+again:
+	if (list_is_last(candidates.next, &candidates))
+		goto out;
+
+	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
+	key.type = BTRFS_EXTENT_CSUM_KEY;
+	key.offset = start;
+
+	ret = btrfs_search_slot(NULL, csum_root, &key, &path, 0, 0);
+	if (ret < 0) {
+		fprintf(stderr, "Search csum failed(%d)\n", ret);
+		goto fail_out;
+	}
+	leaf = path.nodes[0];
+	slot = path.slots[0];
+	if (ret > 0) {
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(csum_root, &path);
+			if (ret < 0) {
+				fprintf(stderr,
+					"Walk tree failed(%d)\n", ret);
+				goto fail_out;
+			} else if (ret > 0) {
+				slot = btrfs_header_nritems(leaf) - 1;
+				btrfs_item_key_to_cpu(leaf, &key, slot);
+				if (item_end_offset(root, &key, leaf, slot)
+								> start) {
+					csum_offset = start - key.offset;
+					csum_offset /= blocksize;
+					goto next_csum;
+				}
+				goto next_stripe;
+			}
+			leaf = path.nodes[0];
+			slot = path.slots[0];
+		}
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+		ret = btrfs_previous_item(csum_root, &path, 0,
+					  BTRFS_EXTENT_CSUM_KEY);
+		if (ret < 0)
+			goto fail_out;
+		else if (ret > 0) {
+			if (key.offset >= end)
+				goto next_stripe;
+			else
+				goto next_csum;
+		}
+		leaf = path.nodes[0];
+		slot = path.slots[0];
+
+		btrfs_item_key_to_cpu(leaf, &prev_key, slot);
+		if (item_end_offset(root, &prev_key, leaf, slot) > start) {
+			csum_offset = start - prev_key.offset;
+			csum_offset /= blocksize;
+			btrfs_item_key_to_cpu(leaf, &key, slot);
+		} else {
+			if (key.offset >= end)
+				goto next_stripe;
+		}
+
+		if (key.offset + csum_offset * blocksize > chunk_end)
+			goto out;
+	}
+next_csum:
+	ret = next_csum(root, &leaf, &path, &slot, &csum_offset, &tree_csum,
+			end, &key);
+	if (ret < 0) {
+		fprintf(stderr, "Fetch csum failed\n");
+		goto fail_out;
+	} else if (ret == 1) {
+		list_for_each_entry(devext, &unordered, chunk_list)
+			num_unordered++;
+		if (!(*flags & EQUAL_STRIPE))
+			*flags |= EQUAL_STRIPE;
+		goto out;
+	} else if (ret == 2)
+		goto next_stripe;
+
+	list_for_each_entry_safe(devext, next, &candidates, chunk_list) {
+		data_offset = calc_data_offset(&key, chunk, devext->offset,
+					       csum_offset, blocksize);
+		dev = btrfs_find_device_by_devid(rc->fs_devices,
+						 devext->objectid, 0);
+		if (!dev) {
+			ret = 1;
+			goto fail_out;
+		}
+		BUG_ON(btrfs_find_device_by_devid(rc->fs_devices,
+						  devext->objectid, 1));
+
+		ret = check_one_csum(dev->fd, data_offset, blocksize,
+				     tree_csum);
+		if (ret < 0)
+			goto fail_out;
+		else if (ret > 0)
+			list_move(&devext->chunk_list, &unordered);
+	}
+
+	if (list_empty(&candidates)) {
+		list_for_each_entry(devext, &unordered, chunk_list)
+			num_unordered++;
+		if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID6
+					&& num_unordered == 2) {
+			list_splice_init(&unordered, &chunk->dextents);
+			btrfs_release_path(&path);
+			return 0;
+		} else
+			ret = 1;
+
+		goto fail_out;
+	}
+
+	if (list_is_last(candidates.next, &candidates)) {
+		index = btrfs_calc_stripe_index(chunk,
+			key.offset + csum_offset * blocksize);
+		if (chunk->stripes[index].devid)
+			goto next_stripe;
+		ret = insert_stripe(&candidates, rc, chunk, index);
+		if (ret)
+			goto fail_out;
+	} else {
+		csum_offset++;
+		goto next_csum;
+	}
+next_stripe:
+	start = btrfs_next_stripe_logical_offset(chunk, start);
+	end = min(start + chunk->stripe_len, chunk_end);
+	list_splice_init(&unordered, &candidates);
+	btrfs_release_path(&path);
+	csum_offset = 0;
+	if (end < chunk_end)
+		goto again;
+out:
+	ret = 0;
+	list_splice_init(&candidates, &unordered);
+	list_for_each_entry(devext, &unordered, chunk_list)
+		num_unordered++;
+	if (num_unordered == 1) {
+		for (i = 0; i < chunk->num_stripes; i++) {
+			if (!chunk->stripes[i].devid) {
+				index = i;
+				break;
+			}
+		}
+		ret = insert_stripe(&unordered, rc, chunk, index);
+		if (ret)
+			goto fail_out;
+	} else {
+		if ((num_unordered == 2 && chunk->type_flags
+			& BTRFS_BLOCK_GROUP_RAID5)
+		 || (num_unordered == 3 && chunk->type_flags
+			& BTRFS_BLOCK_GROUP_RAID6)) {
+			for (i = 0; i < chunk->num_stripes; i++) {
+				if (!chunk->stripes[i].devid) {
+					ret = insert_stripe(&unordered, rc,
+							chunk, i);
+					if (ret)
+						break;
+				}
+			}
+		}
+	}
+fail_out:
+	ret = !!ret || (list_empty(&unordered) ? 0 : 1);
+	list_splice_init(&candidates, &chunk->dextents);
+	list_splice_init(&unordered, &chunk->dextents);
+	btrfs_release_path(&path);
+
+	return ret;
+}
+
+static int btrfs_rebuild_ordered_data_chunk_stripes(struct recover_control *rc,
+					   struct btrfs_root *root)
+{
+	struct chunk_record *chunk;
+	struct chunk_record *next;
+	int ret = 0;
+	int err;
+	u8 flags;
+
+	list_for_each_entry_safe(chunk, next, &rc->unrepaired_chunks, list) {
+		if ((chunk->type_flags & BTRFS_BLOCK_GROUP_DATA)
+		 && (chunk->type_flags & BTRFS_ORDERED_RAID)) {
+			flags = 0;
+			err = rebuild_raid_data_chunk_stripes(rc, root, chunk,
+							      &flags);
+			if (err) {
+				list_move(&chunk->list, &rc->bad_chunks);
+				if (flags & EQUAL_STRIPE)
+					fprintf(stderr,
+			"Failure: too many equal stripes in chunk[%llu %llu]\n",
+						chunk->offset, chunk->length);
+				if (!ret)
+					ret = err;
+			} else
+				list_move(&chunk->list, &rc->good_chunks);
+		}
+	}
+	return ret;
+}
+
 static int btrfs_recover_chunks(struct recover_control *rc)
 {
 	struct chunk_record *chunk;
@@ -1703,6 +2068,12 @@ int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 		goto fail_close_ctree;
 	}
 
+	ret = btrfs_rebuild_ordered_data_chunk_stripes(&rc, root);
+	if (ret) {
+		fprintf(stderr, "Failed to rebuild ordered chunk stripes.\n");
+		goto fail_close_ctree;
+	}
+
 	if (!rc.yes) {
 		ret = ask_user("We are going to rebuild the chunk tree on disk, it might destroy the old metadata on the disk, Are you sure?");
 		if (!ret) {
-- 
1.8.0.1

