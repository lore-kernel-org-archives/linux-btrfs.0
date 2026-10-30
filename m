Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333749;
	b=ANwevKEJQ0s2B/9Ul72uvAvJRM7J3bPxMRj1MMpPnCa6sXlWjrwRSuBwZpt7adVCdaVT
	 eEmG8QXE5TsyLFg0Rhcf5d4Ob58xH/SXrSMbMvYKd947mktP9jEO2pqlSePp+48qPNIDZ
	 aps4g4pu4ujKvPj0vRBfuzKQKK37ti7nSPmVptIQKDh1PolMEIB+NMa7Y9m2KMvqLV/Sb
	 D/0tGfnlfT1/cALZrFdc8/OfMz0APXg4daYnFGUb67s30pbYAx89+KyeBWaf++qpM+2z/
	 qBVcoIEW3xVtCBQ6kW13b2MmRX5m8sVUma+vyf54fXnTYjM0eaNP5axwZvs3PNzce1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333749;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=PlZ8apJTjPySnL1ytLrNL3Y9HyRBnGjiP93OyitJEn4=;
	b=tCbdhrtutc+V8vux9gnGOcyNDbTyaB8J+SCrohDhEy5yUu+EEBan0l7dinKTSB3nnBYv
	 zWVf74yeJ2dAd4dxZEkExwKujALh1coOCeBH8P1sT6wFa6EDuXOfDWNQj1ewXyNsrVK+o
	 Qcmp9cPs2YzPBEky5M8gN7UEgWcUdj0vCYq35MmGax99z3JOLCUvgaAJixFjaWQE1q9Ed
	 OJCG5VyKvRey/B0ZVaz7xQf7g3lRxmMwD86cuG47ITRAqohaBe5lUIYMlhUjTStMFLZ/p
	 2bFd6pyAfJOeZklQdqRUlY+VNwYqBo4mk4BrsHN7rirGMuqG2AcP2fpgP9j0fUxiLOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=b6aIVaDa;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=b6aIVaDa;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06EC606A329
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D06EC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=b6aIVaDa;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=b6aIVaDa
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 59A8D1FCFA
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333747; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PlZ8apJTjPySnL1ytLrNL3Y9HyRBnGjiP93OyitJEn4=;
	b=b6aIVaDa1ufCTKCg3Fs3yawxrAv2J38JbKBLSBfhHRsUGI5klkndH5h9YSlrNxraqbYB3C
	6mB34i7Lz9O5CxtJhOHr0HxWnnPonn52/iM+XpwaHRInWIpr6YDbDCKfgsRGBcCyvW/zM7
	rrtEc0TL/2mCn2Z2/pbsqcujG7BMKMo=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333747; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PlZ8apJTjPySnL1ytLrNL3Y9HyRBnGjiP93OyitJEn4=;
	b=b6aIVaDa1ufCTKCg3Fs3yawxrAv2J38JbKBLSBfhHRsUGI5klkndH5h9YSlrNxraqbYB3C
	6mB34i7Lz9O5CxtJhOHr0HxWnnPonn52/iM+XpwaHRInWIpr6YDbDCKfgsRGBcCyvW/zM7
	rrtEc0TL/2mCn2Z2/pbsqcujG7BMKMo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ECF4F13432
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0uAiEekZ5GrDGwAAD6G6ig:T6
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:45 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/12] btrfs-progs: cmds: use BTRFS_PATH_AUTO_RELEASE() for on-stack paths
Date: Fri, 30 Oct 2026 14:45:12 +1030
Message-ID: <2d1663f34a1c8a069fad17447dec2302b22a7b64.1793333606.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793333606.git.wqu@suse.com>
References: <cover.1793333606.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

Convert the on-stack btrfs_path in cmds/ to BTRFS_PATH_AUTO_RELEASE(), and
drop the btrfs_release_path() calls that only existed as function exit
cleanup.

Where the path is only used inside one loop (clear_uuid_tree(),
rebuild_block_group()), the variable is declared in the loop body, so the
path is released as early as possible.

This also fixes the path leaks on error paths of:

- clear_uuid_tree()
- iterate_csum_root()
- cmd_inspect_dump_tree()

Explicit releases which are not at function exit are kept, including the
one before close_ctree() in cmd_inspect_dump_tree(), as the path must not
outlive the extent buffer cache.

calc_root_size() in inspect-tree-stats.c is intentionally left untouched:
its path only borrows the extent buffers without holding a reference, thus
releasing it would drop references it never took.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/device.c                   |  11 +--
 cmds/inspect-dump-tree.c        |  10 +--
 cmds/rescue-chunk-recover.c     |  43 ++++-------
 cmds/rescue-fix-data-checksum.c |  10 +--
 cmds/rescue.c                   |   7 +-
 cmds/restore.c                  | 126 +++++++++++++-------------------
 6 files changed, 78 insertions(+), 129 deletions(-)

diff --git a/cmds/device.c b/cmds/device.c
index 8d33569816f4..20e4d79a5fa9 100644
--- a/cmds/device.c
+++ b/cmds/device.c
@@ -712,7 +712,7 @@ static int get_device_stats_offline(struct btrfs_fs_info *fs_info, u64 devid,
 				    struct btrfs_ioctl_get_dev_stats *stats_args)
 {
 	int ret = 0;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_dev_stats_item *stats_item;
 
@@ -721,11 +721,10 @@ static int get_device_stats_offline(struct btrfs_fs_info *fs_info, u64 devid,
 	key.offset = devid;
 	ret = btrfs_search_slot(NULL, fs_info->dev_root, &key, &path, 0, 0);
 	if (ret < 0)
-		goto out;
+		return ret;
 	if (ret > 0) {
 		pr_debug("no device stats found for devid %llu\n", devid);
-		ret = 0;
-		goto out;
+		return 0;
 	}
 
 	memset(stats_args->values, 0, stats_args->nr_items * sizeof(u64));
@@ -742,9 +741,7 @@ static int get_device_stats_offline(struct btrfs_fs_info *fs_info, u64 devid,
 	stats_args->values[BTRFS_DEV_STAT_GENERATION_ERRS] =
 		btrfs_dev_stats_value(path.nodes[0], stats_item, BTRFS_DEV_STAT_GENERATION_ERRS);
 
-out:
-	btrfs_release_path(&path);
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/cmds/inspect-dump-tree.c b/cmds/inspect-dump-tree.c
index 424c7ec292b3..09ac9e181376 100644
--- a/cmds/inspect-dump-tree.c
+++ b/cmds/inspect-dump-tree.c
@@ -272,7 +272,7 @@ static int cmd_inspect_dump_tree(const struct cmd_struct *cmd,
 {
 	struct btrfs_root *root;
 	struct btrfs_fs_info *info;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_root_item ri;
 	struct extent_buffer *leaf;
@@ -364,7 +364,7 @@ static int cmd_inspect_dump_tree(const struct cmd_struct *cmd,
 			block_bytenr = arg_strtou64(optarg);
 			ret = dump_add_tree_block(&block_root, block_bytenr);
 			if (ret < 0)
-				goto out;
+				return !!ret;
 			break;
 		case 't':
 			ret = parse_tree_id(optarg, &tree_id);
@@ -412,7 +412,7 @@ static int cmd_inspect_dump_tree(const struct cmd_struct *cmd,
 	info = open_ctree_fs_info(&oca);
 	if (!info) {
 		error("unable to open %s", argv[optind]);
-		goto out;
+		return !!ret;
 	}
 
 	print_mode = follow | traverse | csum_mode;
@@ -426,7 +426,7 @@ static int cmd_inspect_dump_tree(const struct cmd_struct *cmd,
 	root = info->fs_root;
 	if (!root) {
 		error("unable to open %s", argv[optind]);
-		goto out;
+		return !!ret;
 	}
 
 	if (!(extent_only || uuid_tree_only || tree_id)) {
@@ -698,8 +698,8 @@ no_node:
 	uuid_unparse(info->super_copy->fsid, uuidbuf);
 	pr_default("uuid %s\n", uuidbuf);
 close_root:
+	btrfs_release_path(&path);
 	ret = close_ctree(root);
-out:
 	return !!ret;
 }
 DEFINE_SIMPLE_COMMAND(inspect_dump_tree, "dump-tree");
diff --git a/cmds/rescue-chunk-recover.c b/cmds/rescue-chunk-recover.c
index e00ec66791e2..e879208c462b 100644
--- a/cmds/rescue-chunk-recover.c
+++ b/cmds/rescue-chunk-recover.c
@@ -584,7 +584,7 @@ static int check_chunk_by_metadata(struct recover_control *rc,
 	int ret;
 	int i;
 	int slot;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_root *dev_root;
 	struct stripe *stripe;
@@ -607,14 +607,12 @@ static int check_chunk_by_metadata(struct recover_control *rc,
 		if (ret < 0) {
 			fprintf(stderr, "Search device extent failed(%d)\n",
 				ret);
-			btrfs_release_path(&path);
 			return ret;
 		} else if (ret > 0) {
 			if (rc->verbose)
 				fprintf(stderr,
 					"No device extent[%llu, %llu]\n",
 					stripe->devid, stripe->offset);
-			btrfs_release_path(&path);
 			return -ENOENT;
 		}
 		l = path.nodes[0];
@@ -629,7 +627,6 @@ static int check_chunk_by_metadata(struct recover_control *rc,
 								dev_extent),
 					btrfs_dev_extent_length(l, dev_extent),
 					chunk->offset, chunk->length);
-			btrfs_release_path(&path);
 			return -ENOENT;
 		}
 		btrfs_release_path(&path);
@@ -645,13 +642,11 @@ bg_check:
 				0, 0);
 	if (ret < 0) {
 		fprintf(stderr, "Search block group failed(%d)\n", ret);
-		btrfs_release_path(&path);
 		return ret;
 	} else if (ret > 0) {
 		if (rc->verbose)
 			fprintf(stderr, "No block group[%llu, %llu]\n",
 				key.objectid, key.offset);
-		btrfs_release_path(&path);
 		return -ENOENT;
 	}
 
@@ -664,10 +659,8 @@ bg_check:
 				"Chunk[%llu, %llu]'s type(%llu) is different with Block Group's type(%llu)\n",
 				chunk->offset, chunk->length, chunk->type_flags,
 				btrfs_block_group_flags(l, bg_ptr));
-		btrfs_release_path(&path);
 		return -ENOENT;
 	}
-	btrfs_release_path(&path);
 	return 0;
 }
 
@@ -1028,7 +1021,7 @@ static int block_group_remove_all_extent_items(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	u64 start = bg->objectid;
 	u64 end = bg->objectid + bg->offset;
@@ -1046,7 +1039,7 @@ static int block_group_remove_all_extent_items(struct btrfs_trans_handle *trans,
 again:
 	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
 	if (ret < 0)
-		goto err;
+		return ret;
 	else if (ret > 0)
 		ret = 0;
 
@@ -1054,22 +1047,19 @@ again:
 	nitems = btrfs_header_nritems(leaf);
 	if (!nitems) {
 		/* The tree is empty. */
-		ret = 0;
-		goto err;
+		return 0;
 	}
 
 	if (path.slots[0] >= nitems) {
 		ret = btrfs_next_leaf(root, &path);
 		if (ret < 0)
-			goto err;
-		if (ret > 0) {
-			ret = 0;
-			goto err;
-		}
+			return ret;
+		if (ret > 0)
+			return 0;
 		leaf = path.nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, 0);
 		if (key.objectid >= end)
-			goto err;
+			return ret;
 		btrfs_release_path(&path);
 		goto again;
 	}
@@ -1106,7 +1096,7 @@ again:
 	if (del_nr) {
 		ret = btrfs_del_items(trans, root, &path, del_s, del_nr);
 		if (ret)
-			goto err;
+			return ret;
 	}
 
 	if (key.objectid < end) {
@@ -1118,8 +1108,6 @@ again:
 		btrfs_release_path(&path);
 		goto again;
 	}
-err:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1425,7 +1413,6 @@ static int rebuild_block_group(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct chunk_record *chunk_rec;
 	struct btrfs_key search_key;
-	struct btrfs_path path = { 0 };
 	u64 used = 0;
 	int ret = 0;
 
@@ -1433,13 +1420,15 @@ static int rebuild_block_group(struct btrfs_trans_handle *trans,
 		return 0;
 
 	list_for_each_entry(chunk_rec, &rc->rebuild_chunks, list) {
+		BTRFS_PATH_AUTO_RELEASE(path);
+
 		search_key.objectid = chunk_rec->offset;
 		search_key.type = BTRFS_EXTENT_ITEM_KEY;
 		search_key.offset = 0;
 		root = btrfs_extent_root(fs_info, chunk_rec->offset);
 		ret = btrfs_search_slot(NULL, root, &search_key, &path, 0, 0);
 		if (ret < 0)
-			goto out;
+			return ret;
 		ret = calculate_bg_used(root, chunk_rec, &path, &used);
 		/*
 		 * Extent tree is damaged, better to rebuild the whole extent
@@ -1458,10 +1447,8 @@ static int rebuild_block_group(struct btrfs_trans_handle *trans,
 		btrfs_release_path(&path);
 		ret = __insert_block_group(trans, chunk_rec, root, used);
 		if (ret < 0)
-			goto out;
+			return ret;
 	}
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -2008,7 +1995,7 @@ static int rebuild_raid_data_chunk_stripes(struct recover_control *rc,
 	int i;
 	int ret = 0;
 	int slot;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key prev_key;
 	struct btrfs_key key;
 	struct btrfs_root *csum_root;
@@ -2131,7 +2118,6 @@ next_csum:
 		num_unordered = count_devext_records(&unordered);
 		if (chunk->type_flags & BTRFS_BLOCK_GROUP_RAID6
 					&& num_unordered == 2) {
-			btrfs_release_path(&path);
 			ret = fill_chunk_up(chunk, &unordered, rc);
 			return ret;
 		}
@@ -2186,7 +2172,6 @@ fail_out:
 	ret = !!ret || (list_empty(&unordered) ? 0 : 1);
 	list_splice_init(&candidates, &chunk->dextents);
 	list_splice_init(&unordered, &chunk->dextents);
-	btrfs_release_path(&path);
 
 	return ret;
 }
diff --git a/cmds/rescue-fix-data-checksum.c b/cmds/rescue-fix-data-checksum.c
index 121fb0b46ca8..b5927280b190 100644
--- a/cmds/rescue-fix-data-checksum.c
+++ b/cmds/rescue-fix-data-checksum.c
@@ -190,7 +190,7 @@ static int print_filenames(u64 ino, u64 offset, u64 rootid, void *ctx)
 	struct btrfs_root *root;
 	struct btrfs_key key;
 	struct inode_fs_paths *ipath;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int ret;
 
 	key.objectid = rootid;
@@ -230,7 +230,7 @@ out:
 
 static int iterate_csum_root(struct btrfs_fs_info *fs_info, struct btrfs_root *csum_root)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -263,7 +263,6 @@ next:
 			error("failed to get next csum item: %m");
 		}
 	}
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -333,7 +332,7 @@ static int update_csum_item(struct btrfs_fs_info *fs_info, u64 logical,
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *csum_root = btrfs_csum_root(fs_info, logical);
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_csum_item *citem;
 	u64 read_len = fs_info->sectorsize;
 	u8 csum[BTRFS_CSUM_SIZE] = { 0 };
@@ -378,7 +377,6 @@ static int update_csum_item(struct btrfs_fs_info *fs_info, u64 logical,
 		logical, mirror);
 out:
 	free(buf);
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -387,7 +385,7 @@ static void report_corrupted_blocks(struct btrfs_fs_info *fs_info,
 				    unsigned int mirror)
 {
 	struct corrupted_block *entry;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	enum fix_data_checksum_action_value action;
 
 	if (list_empty(&corrupted_blocks)) {
diff --git a/cmds/rescue.c b/cmds/rescue.c
index d10dea393a59..a03b0bd537b1 100644
--- a/cmds/rescue.c
+++ b/cmds/rescue.c
@@ -374,7 +374,6 @@ static int clear_uuid_tree(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *uuid_root = fs_info->uuid_root;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_path path = {};
 	struct btrfs_key key = {};
 	int ret;
 
@@ -387,6 +386,7 @@ static int clear_uuid_tree(struct btrfs_fs_info *fs_info)
 		return PTR_ERR(trans);
 
 	while (1) {
+		BTRFS_PATH_AUTO_RELEASE(path);
 		int nr;
 
 		ret = btrfs_search_slot(trans, uuid_root, &key, &path, -1, 1);
@@ -396,13 +396,10 @@ static int clear_uuid_tree(struct btrfs_fs_info *fs_info)
 		UASSERT(path.slots[0] == 0);
 
 		nr = btrfs_header_nritems(path.nodes[0]);
-		if (nr == 0) {
-			btrfs_release_path(&path);
+		if (nr == 0)
 			break;
-		}
 
 		ret = btrfs_del_items(trans, uuid_root, &path, 0, nr);
-		btrfs_release_path(&path);
 		if (ret < 0)
 			goto out;
 	}
diff --git a/cmds/restore.c b/cmds/restore.c
index b982f2de4699..77de65bf1528 100644
--- a/cmds/restore.c
+++ b/cmds/restore.c
@@ -488,7 +488,7 @@ static int set_file_xattrs(struct btrfs_root *root, u64 inode,
 			   int fd, const char *file_name)
 {
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_dir_item *di;
 	u32 name_len = 0;
@@ -574,7 +574,6 @@ static int set_file_xattrs(struct btrfs_root *root, u64 inode,
 	}
 	ret = 0;
 out:
-	btrfs_release_path(&path);
 	free(name);
 	free(data);
 
@@ -584,7 +583,7 @@ out:
 static int copy_metadata(struct btrfs_root *root, int fd,
 		struct btrfs_key *key)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_inode_item *inode_item;
 	int ret;
 
@@ -600,13 +599,13 @@ static int copy_metadata(struct btrfs_root *root, int fd,
 				btrfs_inode_gid(path.nodes[0], inode_item));
 		if (ret) {
 			error("failed to change owner: %m");
-			goto out;
+			return ret;
 		}
 
 		ret = fchmod(fd, btrfs_inode_mode(path.nodes[0], inode_item));
 		if (ret) {
 			error("failed to change mode: %m");
-			goto out;
+			return ret;
 		}
 
 		bts = btrfs_inode_atime(inode_item);
@@ -620,11 +619,9 @@ static int copy_metadata(struct btrfs_root *root, int fd,
 		ret = futimens(fd, times);
 		if (ret) {
 			error("failed to set times: %m");
-			goto out;
+			return ret;
 		}
 	}
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -632,7 +629,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		     const char *file)
 {
 	struct extent_buffer *leaf;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_inode_item *inode_item;
 	struct btrfs_timespec *bts;
@@ -659,11 +656,11 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 			ret = fchown(fd, btrfs_inode_uid(path.nodes[0], inode_item),
 					btrfs_inode_gid(path.nodes[0], inode_item));
 			if (ret && !ignore_errors)
-				goto out;
+				return ret;
 
 			ret = fchmod(fd, btrfs_inode_mode(path.nodes[0], inode_item));
 			if (ret && !ignore_errors)
-				goto out;
+				return ret;
 
 			bts = btrfs_inode_atime(inode_item);
 			times[0].tv_sec = btrfs_timespec_sec(path.nodes[0], bts);
@@ -683,7 +680,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 	ret = btrfs_search_slot(NULL, root, key, &path, 0, 0);
 	if (ret < 0) {
 		error("searching extent data returned %d", ret);
-		goto out;
+		return ret;
 	}
 
 	leaf = path.nodes[0];
@@ -691,11 +688,10 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		ret = next_leaf(root, &path);
 		if (ret < 0) {
 			error("cannot get next leaf: %d", ret);
-			goto out;
+			return ret;
 		} else if (ret > 0) {
 			/* No more leaves to search */
-			ret = 0;
-			goto out;
+			return 0;
 		}
 		leaf = path.nodes[0];
 	}
@@ -706,7 +702,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 				ret = next_leaf(root, &path);
 				if (ret < 0) {
 					error("search to next leaf failed: %d", ret);
-					goto out;
+					return ret;
 				} else if (ret) {
 					/* No more leaves to search */
 					btrfs_release_path(&path);
@@ -728,8 +724,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		if (compression >= BTRFS_NR_COMPRESS_TYPES) {
 			warning("compression type %d not supported",
 				compression);
-			ret = -1;
-			goto out;
+			return -1;
 		}
 
 		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC)
@@ -737,12 +732,12 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 			ret = copy_one_inline(root, fd, &path, found_key.offset);
 			if (ret)
-				goto out;
+				return ret;
 		} else if (extent_type == BTRFS_FILE_EXTENT_REG) {
 			ret = copy_one_extent(root, fd, leaf, fi,
 					      found_key.offset);
 			if (ret)
-				goto out;
+				return ret;
 		} else {
 			warning("weird extent type %d", extent_type);
 		}
@@ -768,9 +763,6 @@ set_size:
 			return ret;
 	}
 	return 0;
-
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -809,7 +801,7 @@ static int overwrite_ok(const char * path)
 static int copy_symlink(struct btrfs_root *root, struct btrfs_key *key,
 		     const char *file)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_file_extent_item *extent_item;
 	struct btrfs_inode_item *inode_item;
@@ -836,13 +828,12 @@ static int copy_symlink(struct btrfs_root *root, struct btrfs_key *key,
 	key->offset = 0;
 	ret = btrfs_search_slot(NULL, root, key, &path, 0, 0);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	leaf = path.nodes[0];
 	if (!leaf) {
 		error("failed to get leaf for symlink '%s'", file);
-		ret = -1;
-		goto out;
+		return -1;
 	}
 
 	extent_item = btrfs_item_ptr(leaf, path.slots[0],
@@ -852,8 +843,7 @@ static int copy_symlink(struct btrfs_root *root, struct btrfs_key *key,
 	if (len >= PATH_MAX) {
 		error("symlink '%s' target length %d is longer than PATH_MAX",
 				fs_name, len);
-		ret = -1;
-		goto out;
+		return -1;
 	}
 
 	name_offset = (unsigned long) extent_item
@@ -866,7 +856,7 @@ static int copy_symlink(struct btrfs_root *root, struct btrfs_key *key,
 		ret = symlink(symlink_target, path_name);
 		if (ret < 0) {
 			error("failed to restore symlink '%s': %m", path_name);
-			goto out;
+			return ret;
 		}
 	}
 
@@ -875,7 +865,7 @@ static int copy_symlink(struct btrfs_root *root, struct btrfs_key *key,
 
 	ret = 0;
 	if (!restore_metadata)
-		goto out;
+		return ret;
 
 	/*
 	 * Symlink metadata operates differently than files/directories, so do
@@ -889,7 +879,7 @@ static int copy_symlink(struct btrfs_root *root, struct btrfs_key *key,
 	ret = btrfs_lookup_inode(NULL, root, &path, key, 0);
 	if (ret) {
 		error("failed to lookup inode for '%s'", file);
-		goto out;
+		return ret;
 	}
 
 	inode_item = btrfs_item_ptr(path.nodes[0], path.slots[0],
@@ -900,7 +890,7 @@ static int copy_symlink(struct btrfs_root *root, struct btrfs_key *key,
 				   AT_SYMLINK_NOFOLLOW);
 	if (ret) {
 		error("failed to change owner of '%s': %m", file);
-		goto out;
+		return ret;
 	}
 
 	bts = btrfs_inode_atime(inode_item);
@@ -914,8 +904,6 @@ static int copy_symlink(struct btrfs_root *root, struct btrfs_key *key,
 	ret = utimensat(AT_FDCWD, file, times, AT_SYMLINK_NOFOLLOW);
 	if (ret)
 		error("failed to set times for '%s': %m", file);
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -923,7 +911,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		      const char *output_rootdir, const char *in_dir,
 		      const regex_t *mreg)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_dir_item *dir_item;
 	struct btrfs_key found_key, location;
@@ -939,7 +927,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 	ret = btrfs_search_slot(NULL, root, key, &path, 0, 0);
 	if (ret < 0) {
 		error("search for next directory entry failed: %d", ret);
-		goto out;
+		return ret;
 	}
 
 	ret = 0;
@@ -950,12 +938,11 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		ret = next_leaf(root, &path);
 		if (ret < 0) {
 			error("search for next leaf failed: %d", ret);
-			goto out;
+			return ret;
 		} else if (ret > 0) {
 			/* No more leaves to search */
 			pr_info("Reached the end of the tree looking for the directory\n");
-			ret = 0;
-			goto out;
+			return 0;
 		}
 		leaf = path.nodes[0];
 	}
@@ -966,12 +953,11 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 				ret = next_leaf(root, &path);
 				if (ret < 0) {
 					error("search for next leaf failed: %d", ret);
-					goto out;
+					return ret;
 				} else if (ret > 0) {
 					/* No more leaves to search */
 					pr_info("Reached the end of the tree searching the directory\n");
-					ret = 0;
-					goto out;
+					return 0;
 				}
 				leaf = path.nodes[0];
 			} while (!leaf);
@@ -1001,7 +987,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		ret = path_cat_out(fs_name, in_dir, filename);
 		if (ret < 0) {
 			error("invalid file path %s/%s", in_dir, filename);
-			goto out;
+			return ret;
 		}
 
 		if (mreg && REG_NOMATCH == regexec(mreg, fs_name, 0, NULL, 0))
@@ -1011,7 +997,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		ret = path_cat_out(path_name, output_rootdir, fs_name);
 		if (ret < 0) {
 			error("invalid full path %s%s", output_rootdir, fs_name);
-			goto out;
+			return ret;
 		}
 
 		/*
@@ -1029,8 +1015,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 				error("creating '%s' failed: %m", path_name);
 				if (ignore_errors)
 					goto next;
-				ret = -1;
-				goto out;
+				return -1;
 			}
 			ret = copy_file(root, fd, &location, path_name);
 			close(fd);
@@ -1038,7 +1023,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 				error("copying data for %s failed", path_name);
 				if (ignore_errors)
 					goto next;
-				goto out;
+				return ret;
 			}
 		} else if (type == BTRFS_FT_DIR) {
 			struct btrfs_root *search_root = root;
@@ -1046,8 +1031,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 
 			if (!dir) {
 				error_mem(NULL);
-				ret = -ENOMEM;
-				goto out;
+				return -ENOMEM;
 			}
 
 			if (location.type == BTRFS_ROOT_ITEM_KEY) {
@@ -1070,8 +1054,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 						path_name, PTR_ERR(search_root));
 					if (ignore_errors)
 						goto next;
-					ret = PTR_ERR(search_root);
-					goto out;
+					return PTR_ERR(search_root);
 				}
 
 				/*
@@ -1099,8 +1082,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 				error("failed mkdir %s: %m", path_name);
 				if (ignore_errors)
 					goto next;
-				ret = -1;
-				goto out;
+				return -1;
 			}
 			ret = search_dir(search_root, &location,
 					 output_rootdir, dir, mreg);
@@ -1110,7 +1092,7 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 					path_name, ret);
 				if (ignore_errors)
 					goto next;
-				goto out;
+				return ret;
 			}
 		} else if (type == BTRFS_FT_SYMLINK) {
 			if (restore_symlinks)
@@ -1118,7 +1100,6 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 			if (ret < 0) {
 				if (ignore_errors)
 					goto next;
-				btrfs_release_path(&path);
 				return ret;
 			}
 		}
@@ -1130,16 +1111,14 @@ next:
 		ret = path_cat_out(path_name, output_rootdir, in_dir);
 		if (ret < 0) {
 			error("invalid path %s%s", output_rootdir, in_dir);
-			goto out;
+			return ret;
 		}
 		fd = open(path_name, O_RDONLY);
 		if (fd < 0) {
 			error("failed to access '%s' to restore metadata/xattrs: %m",
 					path_name);
-			if (!ignore_errors) {
-				ret = -1;
-				goto out;
-			}
+			if (!ignore_errors)
+				return -1;
 		} else {
 			/*
 			 * Set owner/mode/time on the directory as well
@@ -1149,7 +1128,7 @@ next:
 				ret = copy_metadata(root, fd, key);
 				if (ret && !ignore_errors) {
 					close(fd);
-					goto out;
+					return ret;
 				}
 			}
 
@@ -1162,13 +1141,11 @@ next:
 			}
 			close(fd);
 			if (ret && !ignore_errors)
-				goto out;
+				return ret;
 		}
 	}
 
 	pr_info("Done searching %s\n", in_dir);
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1177,7 +1154,7 @@ static int do_list_roots(struct btrfs_root *root)
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_disk_key disk_key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_root_item ri;
 	unsigned long offset;
@@ -1192,7 +1169,6 @@ static int do_list_roots(struct btrfs_root *root)
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 	if (ret < 0) {
 		error("failed search next root item: %d", ret);
-		btrfs_release_path(&path);
 		return -1;
 	}
 
@@ -1222,7 +1198,6 @@ static int do_list_roots(struct btrfs_root *root)
 		       btrfs_root_level(&ri));
 		path.slots[0]++;
 	}
-	btrfs_release_path(&path);
 
 	return 0;
 }
@@ -1306,7 +1281,7 @@ static struct btrfs_root *open_fs(const char *dev, u64 root_location,
 
 static int find_first_dir(struct btrfs_root *root, u64 *objectid)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key found_key;
 	struct btrfs_key key;
 	int ret = -1;
@@ -1318,12 +1293,12 @@ static int find_first_dir(struct btrfs_root *root, u64 *objectid)
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 	if (ret < 0) {
 		error("searching next directory entry failed: %d", ret);
-		goto out;
+		return ret;
 	}
 
 	if (!path.nodes[0]) {
 		error("no leaf when looking for directory");
-		goto out;
+		return ret;
 	}
 again:
 	for (i = path.slots[0];
@@ -1335,24 +1310,21 @@ again:
 		printf("Using objectid %llu for first dir\n",
 		       found_key.objectid);
 		*objectid = found_key.objectid;
-		ret = 0;
-		goto out;
+		return 0;
 	}
 	do {
 		ret = next_leaf(root, &path);
 		if (ret < 0) {
 			error("search for next leaf failed: %d", ret);
-			goto out;
+			return ret;
 		} else if (ret > 0) {
 			error("no more leaves to search");
-			goto out;
+			return ret;
 		}
 	} while (!path.nodes[0]);
 	if (path.nodes[0])
 		goto again;
 	printf("Couldn't find a dir index item\n");
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
-- 
2.56.0

