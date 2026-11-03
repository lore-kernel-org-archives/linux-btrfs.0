Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701232;
	b=O59P3zsnzQATLjUnYGcSSgbIsemo/y+GHwENTG8h5iWfCi65BBGuevSB7/0NoGE6ZbRe
	 Ffar5ffq1r/E7pyvjlyuC1egUMZy25jAtTbxjTc0qZLGdpmfWDJhLqTs2gYXlsD5cZyF7
	 dtO2t94kGB+KhCTepp1O1mQUY7iU/iXk9Zq83FC3ur0doOAOk1NIf1tJVPUXOB43HxaUw
	 hAQLcsy6BljRPmCeEomyQ/UPJKWhft+D+I2iIFNe6JFzDTFlYcaQje160LJ0E3KUinyzG
	 f95T2NXNaO/KrCWwoEGUhksxh42mYu5SGM65+KveBp4QiqJwbnkBh5VB+W3YQex0EFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701232;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=SXI6MOV3ed1lx0RWnBYE2ioQsna7SLiALWLrWNKw+qI=;
	b=mbRmVTs6LaSRqnGB1bRQExBWQHGFiKV/g+RqZxgip7kELDUnwcwTBm5HvQ2mwgh/sIH+
	 tsw0AkfIHOfSFBUbiDgshjkth1YUaPEG2O7T6v+jO2B1H+eDCmwz4kqPZ/LdGYS8roagp
	 6qrJGdScFpvG/TGeuCGYHcxNoQZnoSww17x86YBF/C1Y3tYS54IkXJCEAUA1EHuccKTTI
	 g8WEKNZj/7Tp3snJn6JbAKPD5/69VnPNYCqQcR61yuMCTdc7Qe8sR9D2/D5rYCenJKPlq
	 heKYOYmyyObIX6YefNVGM2lMHwtZ84PQp6Z0UZoK6rtJyKIe3bMtPG8GWTiI7L4OYMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=VEt9gh+C;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=of6lopLx;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26C4606BFAF
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 10:20:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A26C4606BFAF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=VEt9gh+C;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=of6lopLx
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EBEB6222F0;
	Tue,  3 Nov 2026 10:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793701230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SXI6MOV3ed1lx0RWnBYE2ioQsna7SLiALWLrWNKw+qI=;
	b=VEt9gh+CgsHdvlXX1J0UIyoPhg9N5D7mft6zdiP5Ru3E3bGXIThjk//6V/q5R9UTDJVcH6
	sUSw1BzFwgpRZ3JJfwpI+gNiRz2Jjno0/3tSi27cW4bhMdCaWBcjpaIPVr99Dngp+IcGmZ
	US9YzcuHUTX5yt5usiEgLhJQUqHeOzo=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793701228; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SXI6MOV3ed1lx0RWnBYE2ioQsna7SLiALWLrWNKw+qI=;
	b=of6lopLxPvBtHLvJIkgLKuy8RhVA97QB3c01H9E8IztyxtaNBVJJQzmlasJzr4LSxsPKA4
	vXHX4hBmgU5boKz8ds1yWMXAJUWzUlAZKcgo/Fb3uUVAwjbyaSBnPZc1QXTAMsYmvFTLH9
	4TcmT6jLkMw8YWJ4e+m71Nymke+HTEM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D77D1350A;
	Tue,  3 Nov 2026 10:20:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LthdKme16WpgfAAAD6G6ig:T3
	(envelope-from <wqu@suse.com>); Tue, 03 Nov 2026 10:20:27 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Thai Duong <thai@calif.io>
Subject: [PATCH 2/3] btrfs-progs: fix root_item reads which can cause memory bugs
Date: Tue,  3 Nov 2026 20:50:04 +1030
Message-ID: <082f06c31808104e2a7f43dc4ec7748692e54d7e.1793701174.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793701174.git.wqu@suse.com>
References: <cover.1793701174.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,calif.io:email,imap1.dmz-prg2.suse.org:helo];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

Currently we read out a root item by the following pattern for most
cases:

	struct btrfs_root_item ri;

	read_extent_buffer(leaf, &ri, btrfs_item_ptr_offset(leaf, slot),
			   sizeof(ri));

And in print-tree.c it's the worst case

	struct btrfs_root_item root_item;

	read_extent_buffer(leaf, &root_item,
			   btrfs_item_ptr_offset(leaf, slot),
			   btrfs_item_size(leaf, slot));

These all have their problems:

- Can read beyond the item boundary for very old fses
  The structure btrfs_root_item has gone through one expansion.

  So for very old btrfses, the on-disk root item can be smaller than
  btrfs_root_item.

  Reading using sizeof(struct btrfs_root_item) can cause btrfs to read
  beyond the item size.
  For the worst case, if the root item is at the end of the leaf, such
  read can even read beyond the allocated heap memory.

- Overflow the on-stack memory for print-tree.c
  If the on-disk item is corrupted to have a much larger size than the
  btrfs_root_item, it can easily overflow the on-stack memory.

  This call site also doesn't check if the root item has newer members
  or not.

Fix the problem by introduce read_extent_buffer_root_item(), which will
reject too small items first, then do the read size clamping to handle
older btrfs_root_items.

Also fix the unconditional new member output for print_root_item().

Unfortunately this will bring a minor regression that too small root
items will directly reject btrfs-check.
Unfortunately I do not have any better idea to address this.

Reported-by: Thai Duong <thai@calif.io>
Link: https://lore.kernel.org/linux-btrfs/CADdoe42S7PceeJtXg1zm6Zn0g5GK90JnS0PoCtY2YUF5wp6+sw@mail.gmail.com/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c               | 46 +++++++++++++++++++++++++++-----------
 cmds/inspect-dump-tree.c   | 12 ++++++----
 cmds/restore.c             | 16 ++++++++-----
 kernel-shared/disk-io.c    | 21 +++++++++++------
 kernel-shared/extent_io.c  | 34 ++++++++++++++++++++++++++++
 kernel-shared/extent_io.h  |  3 +++
 kernel-shared/print-tree.c | 16 ++++++++++---
 kernel-shared/root-tree.c  |  8 +++++--
 8 files changed, 122 insertions(+), 34 deletions(-)

diff --git a/check/main.c b/check/main.c
index 194d04ce017f..baf4c283527f 100644
--- a/check/main.c
+++ b/check/main.c
@@ -9029,7 +9029,6 @@ static int parse_tree_roots(struct list_head *normal_trees,
 	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_key found_key;
-	struct btrfs_root_item ri;
 	struct extent_buffer *leaf;
 	int slot;
 	int ret = 0;
@@ -9052,12 +9051,18 @@ static int parse_tree_roots(struct list_head *normal_trees,
 		}
 		btrfs_item_key_to_cpu(leaf, &found_key, path.slots[0]);
 		if (found_key.type == BTRFS_ROOT_ITEM_KEY) {
-			unsigned long offset;
+			struct btrfs_root_item ri;
 			u64 last_snapshot;
 			u8 level;
 
-			offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
-			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
+			ret = read_extent_buffer_root_item(path.nodes[0], &ri,
+							   path.slots[0]);
+			if (ret < 0) {
+				error("bad root item size for key (%llu %u %llu)",
+				      found_key.objectid, found_key.type,
+				      found_key.offset);
+				break;
+			}
 			last_snapshot = btrfs_root_last_snapshot(&ri);
 			level = btrfs_root_level(&ri);
 			if (btrfs_disk_key_objectid(&ri.drop_progress) == 0) {
@@ -9563,11 +9568,13 @@ static struct extent_buffer *btrfs_fsck_clear_root(
 	ret = btrfs_insert_empty_item(trans, gfs_info->tree_root, path, key,
 				      sizeof(ri));
 	if (ret == -EEXIST) {
-		read_extent_buffer(path->nodes[0], &ri,
-				   btrfs_item_ptr_offset(path->nodes[0],
-							 path->slots[0]),
-				   sizeof(ri));
-	} else if (ret) {
+		ret = read_extent_buffer_root_item(path->nodes[0], &ri,
+						   path->slots[0]);
+		if (ret < 0)
+			error("bad root item size for key (%llu %u %llu)",
+			      key->objectid, key->type, key->offset);
+	}
+	if (ret) {
 		btrfs_free_path(path);
 		free_extent_buffer(c);
 		return ERR_PTR(ret);
@@ -10153,9 +10160,16 @@ static int load_log_root(u64 root_id, struct btrfs_path *path, struct btrfs_root
 	btrfs_setup_root(tmp_root, gfs_info, root_id);
 
 	leaf = path->nodes[0];
-	read_extent_buffer(leaf, &tmp_root->root_item,
-			   btrfs_item_ptr_offset(leaf, path->slots[0]),
-			   sizeof(tmp_root->root_item));
+	ret = read_extent_buffer_root_item(leaf, &tmp_root->root_item,
+					   path->slots[0]);
+	if (ret < 0) {
+		struct btrfs_key key;
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		error("bad root item size for key (%llu %u %llu)",
+		      key.objectid, key.type, key.offset);
+		return ret;
+	}
 
 	tmp_root->root_key.objectid = root_id;
 	tmp_root->root_key.type = BTRFS_ROOT_ITEM_KEY;
@@ -10403,6 +10417,7 @@ static int maybe_repair_root_item(struct btrfs_path *path,
 	struct root_item_info *rii;
 	struct btrfs_root_item ri;
 	unsigned long offset;
+	int ret;
 
 	entry = lookup_cache_extent(roots_info_cache, root_id, 1);
 	if (!entry) {
@@ -10424,7 +10439,12 @@ static int maybe_repair_root_item(struct btrfs_path *path,
 	}
 
 	offset = btrfs_item_ptr_offset(path->nodes[0], path->slots[0]);
-	read_extent_buffer(path->nodes[0], &ri, offset, sizeof(ri));
+	ret = read_extent_buffer_root_item(path->nodes[0], &ri, path->slots[0]);
+	if (ret < 0) {
+		error("bad root item size for key (%llu %u %llu)",
+		      root_key->objectid, root_key->type, root_key->offset);
+		return ret;
+	}
 
 	if (btrfs_root_bytenr(&ri) != rii->bytenr ||
 	    btrfs_root_level(&ri) != rii->level ||
diff --git a/cmds/inspect-dump-tree.c b/cmds/inspect-dump-tree.c
index a9b369b4aba2..3df9ee27b4ab 100644
--- a/cmds/inspect-dump-tree.c
+++ b/cmds/inspect-dump-tree.c
@@ -274,7 +274,6 @@ static int cmd_inspect_dump_tree(const struct cmd_struct *cmd,
 	struct btrfs_fs_info *info;
 	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
-	struct btrfs_root_item ri;
 	struct extent_buffer *leaf;
 	struct btrfs_disk_key disk_key;
 	struct btrfs_key found_key;
@@ -539,15 +538,20 @@ again:
 		btrfs_item_key(leaf, &disk_key, path.slots[0]);
 		btrfs_disk_key_to_cpu(&found_key, &disk_key);
 		if (found_key.type == BTRFS_ROOT_ITEM_KEY) {
-			unsigned long offset;
+			struct btrfs_root_item ri;
 			struct extent_buffer *buf;
 			struct btrfs_tree_parent_check check = {
 				.owner_root = key.objectid,
 			};
 			bool skip = (extent_only || device_only || uuid_tree_only);
 
-			offset = btrfs_item_ptr_offset(leaf, slot);
-			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
+			ret = read_extent_buffer_root_item(leaf, &ri, slot);
+			if (ret < 0) {
+				error("bad root item size for key (%llu %u %llu)",
+				      found_key.objectid, found_key.type,
+				      found_key.offset);
+				goto next;
+			}
 			buf = read_tree_block(info, btrfs_root_bytenr(&ri), &check);
 			if (!extent_buffer_uptodate(buf))
 				goto next;
diff --git a/cmds/restore.c b/cmds/restore.c
index ac00faac1d02..f61a1c0847e3 100644
--- a/cmds/restore.c
+++ b/cmds/restore.c
@@ -1156,9 +1156,6 @@ static int do_list_roots(struct btrfs_root *root)
 	struct btrfs_disk_key disk_key;
 	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
-	struct btrfs_root_item ri;
-	unsigned long offset;
-	int slot;
 	int ret;
 
 	root = root->fs_info->tree_root;
@@ -1175,6 +1172,9 @@ static int do_list_roots(struct btrfs_root *root)
 	leaf = path.nodes[0];
 
 	while (1) {
+		struct btrfs_root_item ri;
+		int slot;
+
 		slot = path.slots[0];
 		if (slot >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(root, &path);
@@ -1190,8 +1190,14 @@ static int do_list_roots(struct btrfs_root *root)
 			continue;
 		}
 
-		offset = btrfs_item_ptr_offset(leaf, slot);
-		read_extent_buffer(leaf, &ri, offset, sizeof(ri));
+		ret = read_extent_buffer_root_item(leaf, &ri, slot);
+		if (ret < 0) {
+			error("bad root item size for key (%llu %u %llu)",
+			      found_key.objectid, found_key.type,
+			      found_key.offset);
+			break;
+		}
+
 		printf(" tree ");
 		btrfs_print_key(&disk_key);
 		printf(" %llu level %d\n", btrfs_root_bytenr(&ri),
diff --git a/kernel-shared/disk-io.c b/kernel-shared/disk-io.c
index 385b74bbac3c..aeda71171ff2 100644
--- a/kernel-shared/disk-io.c
+++ b/kernel-shared/disk-io.c
@@ -644,9 +644,12 @@ struct btrfs_root *btrfs_read_fs_root_no_cache(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 	l = path->nodes[0];
-	read_extent_buffer(l, &root->root_item,
-	       btrfs_item_ptr_offset(l, path->slots[0]),
-	       sizeof(root->root_item));
+	ret = read_extent_buffer_root_item(l, &root->root_item, path->slots[0]);
+	if (ret < 0) {
+		error("bad root item size for key (%llu %u %llu)",
+		      location->objectid, location->type, location->offset);
+		goto out;
+	}
 	memcpy(&root->root_key, location, sizeof(*location));
 	ret = 0;
 out:
@@ -1083,10 +1086,14 @@ static int load_global_roots_objectid(struct btrfs_fs_info *fs_info,
 		}
 
 		btrfs_setup_root(root, fs_info, objectid);
-		read_extent_buffer(path->nodes[0], &root->root_item,
-				   btrfs_item_ptr_offset(path->nodes[0],
-							 path->slots[0]),
-				   sizeof(root->root_item));
+		ret = read_extent_buffer_root_item(path->nodes[0],
+				&root->root_item, path->slots[0]);
+		if (ret < 0) {
+			error("bad root item size for key (%llu %u %llu)",
+			      key.objectid, key.type, key.offset);
+			kfree(root);
+			break;
+		}
 		memcpy(&root->root_key, &key, sizeof(key));
 		ret = read_root_or_create_block(fs_info, root,
 				btrfs_root_bytenr(&root->root_item),
diff --git a/kernel-shared/extent_io.c b/kernel-shared/extent_io.c
index 7f74126327c2..2c090bad94ae 100644
--- a/kernel-shared/extent_io.c
+++ b/kernel-shared/extent_io.c
@@ -624,6 +624,40 @@ void read_extent_buffer(const struct extent_buffer *eb, void *dst,
 	memcpy(dst, eb->data + start, len);
 }
 
+/*
+ * The version with extra helper to read the buffer with a size check.
+ *
+ * @min_size:	The minimal size the structure should have.
+ *		If @len is smaller than this, the read is rejected.
+ * @max_size:	Max size of the structure. Any data beyond that will
+ *		be discarded.
+ */
+static int read_eb_structure(const struct extent_buffer *eb,
+			void *dst, size_t min_size, size_t max_size,
+			unsigned long start, unsigned long len)
+{
+	if (unlikely(len < min_size))
+		return -EIO;
+	/*
+	 * We still allow an item larger than expected, but the read
+	 * will be trucnated to the max size.
+	 *
+	 * It shouldn't cause overflow as the length is truncated, and will
+	 * handle future structure expansion well.
+	 */
+	read_extent_buffer(eb, dst, start, min_t(unsigned long, len, max_size));
+	return 0;
+}
+
+int read_extent_buffer_root_item(const struct extent_buffer *leaf,
+				 struct btrfs_root_item *ri, int slot)
+{
+	memset(ri, 0, sizeof(*ri));
+	return read_eb_structure(leaf, ri, btrfs_legacy_root_item_size(),
+			sizeof(*ri), btrfs_item_ptr_offset(leaf, slot),
+			btrfs_item_size(leaf, slot));
+}
+
 void write_extent_buffer_fsid(struct extent_buffer *eb, const void *src)
 {
 	write_extent_buffer(eb, src, btrfs_header_fsid(), BTRFS_FSID_SIZE);
diff --git a/kernel-shared/extent_io.h b/kernel-shared/extent_io.h
index 9be4ccfc2d7a..776cdba4f293 100644
--- a/kernel-shared/extent_io.h
+++ b/kernel-shared/extent_io.h
@@ -54,6 +54,7 @@ static inline int le_test_bit(int nr, const u8 *addr)
 
 struct btrfs_fs_info;
 struct btrfs_trans_handle;
+struct btrfs_root_item;
 
 struct extent_buffer {
 	struct cache_extent cache_node;
@@ -109,6 +110,8 @@ int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
 			 unsigned long start, unsigned long len);
 void read_extent_buffer(const struct extent_buffer *eb, void *dst,
 			unsigned long start, unsigned long len);
+int read_extent_buffer_root_item(const struct extent_buffer *eb,
+				 struct btrfs_root_item *ri, int slot);
 void write_extent_buffer_fsid(struct extent_buffer *eb, const void *src);
 void write_extent_buffer_chunk_tree_uuid(struct extent_buffer *eb,
 		const void *src);
diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
index 832ce0678e71..3ce525b6e546 100644
--- a/kernel-shared/print-tree.c
+++ b/kernel-shared/print-tree.c
@@ -657,12 +657,16 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
 	char flags_str[32] = {0};
 	struct btrfs_key drop_key;
+	int ret;
+
+	ret = read_extent_buffer_root_item(leaf, &root_item, slot);
+	if (ret < 0) {
+		printf("\t\tbad root item size, skipping\n");
+		return;
+	}
 
 	ri = btrfs_item_ptr(leaf, slot, struct btrfs_root_item);
 	len = btrfs_item_size(leaf, slot);
-
-	memset(&root_item, 0, sizeof(root_item));
-	read_extent_buffer(leaf, &root_item, (unsigned long)ri, len);
 	root_flags_to_str(btrfs_root_flags(&root_item), flags_str);
 
 	printf("\t\tgeneration %llu root_dirid %llu bytenr %llu byte_limit %llu bytes_used %llu\n",
@@ -681,6 +685,12 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 	btrfs_print_key(&root_item.drop_progress);
 	printf(" drop_level %hhu\n", root_item.drop_level);
 
+	/* Skip newer members for older root item. */
+	if (len < sizeof(root_item)) {
+		printf("\t\tlevel %hhu\n", btrfs_root_level(&root_item));
+		return;
+	}
+
 	printf("\t\tlevel %hhu generation_v2 %llu\n",
 		btrfs_root_level(&root_item), root_item.generation_v2);
 
diff --git a/kernel-shared/root-tree.c b/kernel-shared/root-tree.c
index 39c3f9027b68..03140ceaf097 100644
--- a/kernel-shared/root-tree.c
+++ b/kernel-shared/root-tree.c
@@ -62,8 +62,12 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
 		ret = -ENOENT;
 		goto out;
 	}
-	read_extent_buffer(l, item, btrfs_item_ptr_offset(l, slot),
-			   sizeof(*item));
+	ret = read_extent_buffer_root_item(l, item, slot);
+	if (ret < 0) {
+		error("bad root item size for key (%llu %u %llu)",
+		      found_key.objectid, found_key.type, found_key.offset);
+		goto out;
+	}
 	memcpy(key, &found_key, sizeof(found_key));
 	ret = 0;
 out:
-- 
2.56.0

