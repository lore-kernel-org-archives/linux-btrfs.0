Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333753;
	b=Ld7vU1RFz/YQqPD4a/MPcLGgz4289HrubfaLw6hEx4udkIHsNz/cUIrHT4oo6WEQHXd4
	 ORMopLgEnXgVHVCA4w37GJWlpaAm30OXLQJ7X8yjm0KeUYmUeKgUBetkMSuPP2RGRzP7V
	 1k3ktJK2orGV6TLEFNMTHIG7qNuMnA1eogZ7XNNN0Jj5tNeeESm2SAI6Q5w+1dQdFXlKR
	 zqgWnQwptqZ7JO5ewN55Hs2rvgqUdatAuZzpphxnCfC6+jb3b2/v5F9VwSiV1GkAxfHc9
	 d+gWm/roKZBGBTnPFLteUm0sq21X8Dpeqn5FB2STixqEq7WUDCnPFdIpn0SG68rwENQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333753;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=HqFXjNkKyxP/6weH775E2nOMP7LSJ12HzeAZYGgKpes=;
	b=BJJKg108Qf/kG4HM6QkPgx9q22Kwc6tUgFOEh9DRdcVhyz4SN9m/tB5OoGoRExh4y5Zz
	 4mecCR4jJWwz1fy0AU1oUeKBhmEpYT35MJ8J0RczsL5bNb3n5pZiYZOmZ/TOeBCQlHGXQ
	 e80rh0LZ3dQcjBQbS/ks5a3TynaIglFwmefW8VXN9jen0wo2ghu517bx1ohWY3gR3fDCw
	 yH9Pl1v5Qln+1nAaszrb2a5lJ3cTnexKy5FNv1e/lfol9KSfF5eJl7FHLwHLayEokQL4r
	 H2eP8oColFlQOrWbt+SjRhr1Mb5rXiOweabQZTtlVWlXDndMutzKovdBgEEkmnp5ACg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NquvY5CB;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NquvY5CB;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDA2606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DDA2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NquvY5CB;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NquvY5CB
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8E81B1FCFA
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HqFXjNkKyxP/6weH775E2nOMP7LSJ12HzeAZYGgKpes=;
	b=NquvY5CBulNWPPqiJM4j0JigzK6x5qCs6HA1/kZ5nWdujY8qtZAX5E5y+aEYgOitUIYser
	SDa03B2utR92RM3XtcyxUv3pqzOiaC1erhJidcoBB2j89ZRdnz25UjeZItTeKUWnaYnYep
	F2Wopvfdnp1iD2i/+bo1oP8npRt+pfs=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=NquvY5CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HqFXjNkKyxP/6weH775E2nOMP7LSJ12HzeAZYGgKpes=;
	b=NquvY5CBulNWPPqiJM4j0JigzK6x5qCs6HA1/kZ5nWdujY8qtZAX5E5y+aEYgOitUIYser
	SDa03B2utR92RM3XtcyxUv3pqzOiaC1erhJidcoBB2j89ZRdnz25UjeZItTeKUWnaYnYep
	F2Wopvfdnp1iD2i/+bo1oP8npRt+pfs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7BAE413432
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0uAiEekZ5GrDGwAAD6G6ig:T8
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:49 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/12] btrfs-progs: check: use BTRFS_PATH_AUTO_RELEASE() for lowmem mode
Date: Fri, 30 Oct 2026 14:45:14 +1030
Message-ID: <c91ea3918133804eb7483d4e84c6943cd5a03274.1793333606.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 8E81B1FCFA

Convert all on-stack btrfs_path in check/mode-lowmem.c to
BTRFS_PATH_AUTO_RELEASE(), and drop the btrfs_release_path() calls that
only existed as function exit cleanup.

This also fixes the path leak on the search failure path of
find_dir_index().

Explicit releases which are not at function exit are kept, including the
ones in check_fs_first_inode() and check_dev_extent_item() which must
happen before the repair routines modify the trees.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 202 +++++++++++++++-----------------------------
 1 file changed, 66 insertions(+), 136 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index e5c4c4ab39b7..7d0fad9c557f 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -284,7 +284,7 @@ static int modify_block_groups_cache(u64 flags, int cache)
 {
 	struct btrfs_root *root = btrfs_block_group_root(gfs_info);
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_block_group *bg_cache;
 	struct btrfs_block_group_item *bi;
 	struct btrfs_block_group_item bg_item;
@@ -300,7 +300,7 @@ static int modify_block_groups_cache(u64 flags, int cache)
 	if (ret < 0) {
 		errno = -ret;
 		error("fail to search block groups due to %m");
-		goto out;
+		return ret;
 	}
 
 	while (1) {
@@ -308,10 +308,8 @@ static int modify_block_groups_cache(u64 flags, int cache)
 		slot = path.slots[0];
 		btrfs_item_key_to_cpu(eb, &key, slot);
 		bg_cache = btrfs_lookup_block_group(gfs_info, key.objectid);
-		if (!bg_cache) {
-			ret = -ENOENT;
-			goto out;
-		}
+		if (!bg_cache)
+			return -ENOENT;
 
 		bi = btrfs_item_ptr(eb, slot, struct btrfs_block_group_item);
 		read_extent_buffer(eb, &bg_item, (unsigned long)bi,
@@ -320,17 +318,11 @@ static int modify_block_groups_cache(u64 flags, int cache)
 			modify_block_group_cache(bg_cache, cache);
 
 		ret = btrfs_next_item(root, &path);
-		if (ret > 0) {
-			ret = 0;
-			goto out;
-		}
+		if (ret > 0)
+			return 0;
 		if (ret < 0)
-			goto out;
+			return ret;
 	}
-
-out:
-	btrfs_release_path(&path);
-	return ret;
 }
 
 static int mark_block_groups_full(u64 flags)
@@ -432,7 +424,7 @@ err:
  */
 static int is_chunk_almost_full(u64 start)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_root *root = btrfs_block_group_root(gfs_info);
 	struct btrfs_block_group_item *bi;
@@ -452,22 +444,19 @@ static int is_chunk_almost_full(u64 start)
 	if (!ret)
 		ret = -EIO;
 	if (ret < 0)
-		goto out;
+		return ret;
 	ret = btrfs_previous_item(root, &path, start,
 				  BTRFS_BLOCK_GROUP_ITEM_KEY);
 	if (ret) {
 		error("failed to find block group %llu", start);
-		ret = -ENOENT;
-		goto out;
+		return -ENOENT;
 	}
 
 	eb = path.nodes[0];
 	slot = path.slots[0];
 	btrfs_item_key_to_cpu(eb, &key, slot);
-	if (key.objectid != start) {
-		ret = -ENOENT;
-		goto out;
-	}
+	if (key.objectid != start)
+		return -ENOENT;
 
 	total = key.offset;
 	bi = btrfs_item_ptr(eb, slot, struct btrfs_block_group_item);
@@ -485,8 +474,6 @@ static int is_chunk_almost_full(u64 start)
 		ret = 0;
 	else
 		ret = 1;
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -638,7 +625,7 @@ static int repair_tree_block_ref(struct btrfs_root *root,
 {
 	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_root *extent_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_extent_item *ei;
 	struct btrfs_tree_block_info *bi;
 	struct btrfs_key key;
@@ -763,7 +750,6 @@ static int repair_tree_block_ref(struct btrfs_root *root,
 out:
 	if (trans)
 		btrfs_commit_transaction(trans, extent_root);
-	btrfs_release_path(&path);
 	if (ret) {
 		errno = -ret;
 		error(
@@ -820,7 +806,7 @@ static int find_dir_index(struct btrfs_root *root, u64 dirid, u64 location_id,
 			  u64 *index_ret, char *namebuf, u32 name_len,
 			  u8 file_type)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *node;
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
@@ -851,7 +837,7 @@ loop:
 	if (ret) {
 		ret = -ENOENT;
 		*index_ret = (64)-1;
-		goto out;
+		return ret;
 	}
 	/* Check whether inode_id/filetype/name match */
 	node = path.nodes[0];
@@ -882,17 +868,13 @@ loop:
 
 		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 		*index_ret = key.offset;
-		ret = 0;
-		goto out;
+		return 0;
 next:
 		len += sizeof(*di) + data_len;
 		di = (struct btrfs_dir_item *)((char *)di + len);
 		cur += len;
 	}
 	goto loop;
-
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -918,7 +900,7 @@ static int find_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 			 struct btrfs_key *location_key, char *name,
 			 u32 namelen, u8 file_type)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *node;
 	struct btrfs_dir_item *di;
 	struct btrfs_key location;
@@ -945,7 +927,7 @@ static int find_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 	if (ret) {
 		ret = key->type == BTRFS_DIR_ITEM_KEY ? DIR_ITEM_MISSING :
 			DIR_INDEX_MISSING;
-		goto out;
+		return ret;
 	}
 
 	/* Check whether inode_id/filetype/name match */
@@ -983,16 +965,13 @@ static int find_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 		if (len != namelen || strncmp(namebuf, name, len))
 			goto next;
 
-		ret = 0;
-		goto out;
+		return 0;
 next:
 		len += sizeof(*di) + data_len;
 		di = (struct btrfs_dir_item *)((char *)di + len);
 		cur += len;
 	}
 
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1347,7 +1326,7 @@ static int find_inode_ref(struct btrfs_root *root, struct btrfs_key *key,
 			  char *name, int namelen, u64 *index_ret)
 
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_inode_ref *ref;
 	struct btrfs_inode_extref *extref;
 	struct extent_buffer *node;
@@ -1408,8 +1387,7 @@ static int find_inode_ref(struct btrfs_root *root, struct btrfs_key *key,
 			goto next_ref;
 
 		*index_ret = ref_index;
-		ret = 0;
-		goto out;
+		return 0;
 next_ref:
 		len = sizeof(*ref) + ref_namelen;
 		ref = (struct btrfs_inode_ref *)((char *)ref + len);
@@ -1420,7 +1398,7 @@ extref:
 
 	/* Skip if not support EXTENDED_IREF feature */
 	if (!btrfs_fs_incompat(gfs_info, EXTENDED_IREF))
-		goto out;
+		return ret;
 
 	btrfs_release_path(&path);
 
@@ -1429,10 +1407,8 @@ extref:
 	key->offset = btrfs_extref_hash(dir_id, name, namelen);
 
 	ret = btrfs_search_slot(NULL, root, key, &path, 0, 0);
-	if (ret) {
-		ret = INODE_REF_MISSING;
-		goto out;
-	}
+	if (ret)
+		return INODE_REF_MISSING;
 
 	node = path.nodes[0];
 	slot = path.slots[0];
@@ -1471,8 +1447,7 @@ extref:
 			goto next_extref;
 
 		*index_ret = ref_index;
-		ret = 0;
-		goto out;
+		return 0;
 
 next_extref:
 		len = sizeof(*extref) + ref_namelen;
@@ -1480,8 +1455,6 @@ next_extref:
 		cur += len;
 
 	}
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1505,7 +1478,7 @@ static int repair_inode_item_missing(struct btrfs_root *root, u64 ino,
 {
 	struct btrfs_key key;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int ret;
 
 	key.objectid = ino;
@@ -1531,7 +1504,6 @@ out:
 	if (ret)
 		error("failed to repair root %llu INODE ITEM[%llu] missing",
 		      root->objectid, ino);
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1570,7 +1542,7 @@ static int lowmem_delete_corrupted_dir_item(struct btrfs_root *root,
 static int try_repair_imode(struct btrfs_root *root, u64 ino)
 {
 	struct btrfs_inode_item *iitem;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -1582,7 +1554,7 @@ static int try_repair_imode(struct btrfs_root *root, u64 ino)
 	if (ret > 0)
 		ret = -ENOENT;
 	if (ret < 0)
-		goto out;
+		return ret;
 	iitem = btrfs_item_ptr(path.nodes[0], path.slots[0],
 			       struct btrfs_inode_item);
 	if (!is_valid_imode(btrfs_inode_mode(path.nodes[0], iitem))) {
@@ -1590,8 +1562,6 @@ static int try_repair_imode(struct btrfs_root *root, u64 ino)
 	} else {
 		ret = -ENOTTY;
 	}
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -2259,7 +2229,7 @@ static int __count_dir_isize(struct btrfs_root *root, u64 ino, int type,
 		u64 *size_ret)
 {
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	u32 len;
 	struct btrfs_dir_item *di;
 	int ret;
@@ -2274,10 +2244,8 @@ static int __count_dir_isize(struct btrfs_root *root, u64 ino, int type,
 	key.offset = (u64)-1;
 
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
-	if (ret < 0) {
-		ret = -EIO;
-		goto out;
-	}
+	if (ret < 0)
+		return -EIO;
 	/* If found, go to special case. */
 	if (ret == 0)
 		goto special_case;
@@ -2285,10 +2253,8 @@ static int __count_dir_isize(struct btrfs_root *root, u64 ino, int type,
 loop:
 	ret = btrfs_previous_item(root, &path, ino, type);
 
-	if (ret) {
-		ret = 0;
-		goto out;
-	}
+	if (ret)
+		return 0;
 
 special_case:
 	di = btrfs_item_ptr(path.nodes[0], path.slots[0], struct btrfs_dir_item);
@@ -2307,10 +2273,6 @@ special_case:
 		cur += len;
 	}
 	goto loop;
-
-out:
-	btrfs_release_path(&path);
-	return ret;
 }
 
 static int count_dir_isize(struct btrfs_root *root, u64 ino, u64 *size)
@@ -2588,7 +2550,7 @@ out:
 
 static bool has_orphan_item(struct btrfs_root *root, u64 ino)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -3094,7 +3056,7 @@ static int check_tree_block_ref(struct btrfs_root *root,
 {
 	struct btrfs_key key;
 	struct btrfs_root *extent_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_extent_item *ei;
 	struct btrfs_extent_inline_ref *iref;
 	struct extent_buffer *leaf;
@@ -3283,7 +3245,6 @@ static int check_tree_block_ref(struct btrfs_root *root,
 	if (!found_ref)
 		err |= BACKREF_MISSING;
 out:
-	btrfs_release_path(&path);
 	if (nrefs && strict &&
 	    level < root_level && nrefs->full_backref[level + 1])
 		parent = nrefs->bytenr[level + 1];
@@ -3313,7 +3274,7 @@ static int repair_extent_data_item(struct btrfs_root *root,
 	struct btrfs_key fi_key;
 	struct btrfs_key key;
 	struct btrfs_extent_item *ei;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_root *extent_root;
 	struct extent_buffer *eb;
 	u64 size;
@@ -3353,7 +3314,7 @@ static int repair_extent_data_item(struct btrfs_root *root,
 		ret = delete_item(root, pathp);
 		if (!ret)
 			err = 0;
-		goto out_no_release;
+		goto out;
 	}
 
 	/* now repair only adds backref */
@@ -3427,8 +3388,6 @@ static int repair_extent_data_item(struct btrfs_root *root,
 out:
 	if (trans)
 		btrfs_commit_transaction(trans, root);
-	btrfs_release_path(&path);
-out_no_release:
 	if (ret)
 		error("can't repair root %llu extent data item[%llu %llu]",
 		      root->objectid, disk_bytenr, num_bytes);
@@ -3438,7 +3397,7 @@ out_no_release:
 static int read_inode_item(struct btrfs_root *root,
 			   u64 ino, struct btrfs_inode_item *ret_ii)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key = {
 		.objectid = ino,
 		.type = BTRFS_INODE_ITEM_KEY,
@@ -3450,13 +3409,11 @@ static int read_inode_item(struct btrfs_root *root,
 	if (ret > 0)
 		ret = -ENOENT;
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	read_extent_buffer(path.nodes[0], ret_ii,
 			   btrfs_item_ptr_offset(path.nodes[0], path.slots[0]),
 			   sizeof(*ret_ii));
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -3472,7 +3429,7 @@ static int check_extent_data_item(struct btrfs_root *root,
 {
 	struct btrfs_file_extent_item *fi;
 	struct extent_buffer *eb = pathp->nodes[0];
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_root *extent_root;
 	struct btrfs_key fi_key;
 	struct btrfs_key dbref_key;
@@ -3664,7 +3621,6 @@ static int check_extent_data_item(struct btrfs_root *root,
 out:
 	if (!found_dbackref)
 		err |= BACKREF_MISSING;
-	btrfs_release_path(&path);
 	if (err & BACKREF_MISSING) {
 		error(
 		"file extent[%llu %llu] root %llu owner %llu backref lost",
@@ -3683,7 +3639,7 @@ static int check_block_group_item(struct extent_buffer *eb, int slot)
 	struct btrfs_root *chunk_root = gfs_info->chunk_root;
 	struct btrfs_block_group_item *bi;
 	struct btrfs_block_group_item bg_item;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key bg_key;
 	struct btrfs_key chunk_key;
 	struct btrfs_key extent_key;
@@ -3789,8 +3745,6 @@ next:
 	}
 
 out:
-	btrfs_release_path(&path);
-
 	total_used += used;
 
 	if (total != used) {
@@ -3811,7 +3765,7 @@ static int query_tree_block_level(u64 bytenr)
 {
 	struct btrfs_root *extent_root;
 	struct extent_buffer *eb;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_extent_item *ei;
 	struct btrfs_tree_parent_check check = { 0 };
@@ -3829,23 +3783,19 @@ static int query_tree_block_level(u64 bytenr)
 	extent_root = btrfs_extent_root(gfs_info, bytenr);
 	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
 	if (ret < 0)
-		goto release_out;
+		return ret;
 	ret = btrfs_previous_extent_item(extent_root, &path, bytenr);
 	if (ret < 0)
-		goto release_out;
-	if (ret > 0) {
-		ret = -ENOENT;
-		goto release_out;
-	}
+		return ret;
+	if (ret > 0)
+		return -ENOENT;
 
 	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 	ei = btrfs_item_ptr(path.nodes[0], path.slots[0],
 			    struct btrfs_extent_item);
 	flags = btrfs_extent_flags(path.nodes[0], ei);
-	if (!(flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)) {
-		ret = -ENOENT;
-		goto release_out;
-	}
+	if (!(flags & BTRFS_EXTENT_FLAG_TREE_BLOCK))
+		return -ENOENT;
 
 	/* Get transid for later read_tree_block() check */
 	transid = btrfs_extent_generation(path.nodes[0], ei);
@@ -3874,10 +3824,6 @@ static int query_tree_block_level(u64 bytenr)
 	if (header_level != backref_level)
 		return -EIO;
 	return header_level;
-
-release_out:
-	btrfs_release_path(&path);
-	return ret;
 }
 
 /*
@@ -3889,7 +3835,7 @@ static int check_tree_block_backref(u64 root_id, u64 bytenr, int level)
 {
 	struct btrfs_root *root;
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *eb;
 	struct extent_buffer *node;
 	struct btrfs_tree_parent_check check = {
@@ -3943,7 +3889,7 @@ static int check_tree_block_backref(u64 root_id, u64 bytenr, int level)
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 	if (ret < 0) {
 		err |= REFERENCER_MISSING;
-		goto release_out;
+		goto out;
 	}
 
 	node = path.nodes[level];
@@ -3962,8 +3908,6 @@ static int check_tree_block_backref(u64 root_id, u64 bytenr, int level)
 		err |= REFERENCER_MISMATCH;
 	}
 
-release_out:
-	btrfs_release_path(&path);
 out:
 	if (err & REFERENCER_MISSING) {
 		if (level < 0)
@@ -4063,7 +4007,7 @@ static int has_inline_shared_backref(u64 data_bytenr, u64 data_len, u64 parent)
 	struct btrfs_root *extent_root = btrfs_extent_root(gfs_info, data_bytenr);
 	struct btrfs_extent_inline_ref *iref;
 	struct btrfs_extent_item *ei;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
 	unsigned long ptr;
@@ -4131,7 +4075,6 @@ next:
 	}
 
 out:
-	btrfs_release_path(&path);
 	if (ret < 0)
 		return ret;
 	return found;
@@ -4140,7 +4083,7 @@ out:
 static int has_keyed_shared_backref(u64 data_bytenr, u64 parent)
 {
 	struct btrfs_root *extent_root = btrfs_extent_root(gfs_info, data_bytenr);
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -4198,7 +4141,7 @@ static int check_extent_data_backref(u64 root_id, u64 objectid, u64 offset,
 	struct btrfs_root *root;
 	struct btrfs_root *extent_root;
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_file_extent_item *fi;
 	u32 found_count = 0;
@@ -4299,7 +4242,6 @@ next:
 			break;
 	}
 out:
-	btrfs_release_path(&path);
 	if (found_count != count) {
 		error(
 "extent[%llu, %llu] referencer count mismatch (root: %llu, owner: %llu, offset: %llu) wanted: %u, have: %u",
@@ -4732,7 +4674,7 @@ static int check_dev_extent_item(struct extent_buffer *eb, int slot)
 {
 	struct btrfs_root *chunk_root = gfs_info->chunk_root;
 	struct btrfs_dev_extent *ptr;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key chunk_key;
 	struct btrfs_key devext_key;
 	struct btrfs_chunk *chunk;
@@ -4799,7 +4741,7 @@ static int check_dev_item(struct extent_buffer *eb, int slot,
 {
 	struct btrfs_root *dev_root = gfs_info->dev_root;
 	struct btrfs_dev_item *dev_item;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_dev_extent *ptr;
 	struct btrfs_device *dev;
@@ -4833,7 +4775,6 @@ static int check_dev_item(struct extent_buffer *eb, int slot,
 		btrfs_item_key_to_cpu(eb, &key, slot);
 		error("cannot find any related dev extent for dev[%llu, %u, %llu]",
 			key.objectid, key.type, key.offset);
-		btrfs_release_path(&path);
 		return REFERENCER_MISSING;
 	}
 
@@ -4867,7 +4808,6 @@ static int check_dev_item(struct extent_buffer *eb, int slot,
 "dev extent devid %llu offset %llu len %llu overlap with previous dev extent end %llu",
 			      devid, physical_offset, physical_len,
 			      prev_dev_ext_end);
-			btrfs_release_path(&path);
 			return ACCOUNTING_MISMATCH;
 		}
 		if (physical_offset + physical_len > total_bytes) {
@@ -4875,7 +4815,6 @@ static int check_dev_item(struct extent_buffer *eb, int slot,
 "dev extent devid %llu offset %llu len %llu is beyond device boundary %llu",
 			      devid, physical_offset, physical_len,
 			      total_bytes);
-			btrfs_release_path(&path);
 			return ACCOUNTING_MISMATCH;
 		}
 		prev_devid = devid;
@@ -4978,7 +4917,7 @@ out:
 static int check_chunk_item(struct extent_buffer *eb, int slot)
 {
 	struct btrfs_root *dev_root = gfs_info->dev_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key chunk_key;
 	struct btrfs_key devext_key;
 	struct btrfs_chunk *chunk;
@@ -5005,7 +4944,7 @@ static int check_chunk_item(struct extent_buffer *eb, int slot)
 			error("chunk[%llu %llu) is not fully aligned to BTRFS_STRIPE_LEN (%u)",
 				chunk_key.offset, length, BTRFS_STRIPE_LEN);
 			err |= BYTES_UNALIGNED;
-			goto out;
+			return err;
 		}
 		warning("chunk[%llu %llu) is not fully aligned to BTRFS_STRIPE_LEN (%u)",
 			chunk_key.offset, length, BTRFS_STRIPE_LEN);
@@ -5015,7 +4954,7 @@ static int check_chunk_item(struct extent_buffer *eb, int slot)
 		error("chunk[%llu %llu) is invalid", chunk_key.offset,
 			chunk_end);
 		err |= BYTES_UNALIGNED | UNKNOWN_TYPE;
-		goto out;
+		return err;
 	}
 	type = btrfs_chunk_type(eb, chunk);
 
@@ -5053,8 +4992,6 @@ not_match_dev:
 			chunk_key.objectid, chunk_end, i);
 		continue;
 	}
-	btrfs_release_path(&path);
-out:
 	return err;
 }
 
@@ -5427,7 +5364,7 @@ static int repair_fs_first_inode(struct btrfs_root *root, int err)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key key;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int filetype = BTRFS_FT_DIR;
 	int ret = 0;
 
@@ -5473,7 +5410,6 @@ trans_fail:
 out:
 	if (ret)
 		error("fail to repair first inode");
-	btrfs_release_path(&path);
 	return err;
 }
 
@@ -5486,7 +5422,7 @@ out:
  */
 static int check_fs_first_inode(struct btrfs_root *root)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_inode_item *ii;
 	u64 index;
@@ -5557,7 +5493,7 @@ out:
  */
 static int check_btrfs_root(struct btrfs_root *root, int check_all)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct node_refs nrefs;
 	struct btrfs_root_item *root_item = &root->root_item;
 	u64 super_generation = btrfs_super_generation(gfs_info->super_copy);
@@ -5628,7 +5564,7 @@ static int check_btrfs_root(struct btrfs_root *root, int check_all)
 		path.lowest_level = level;
 		ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 		if (ret < 0)
-			goto out;
+			return ret;
 		ret = 0;
 	}
 
@@ -5652,8 +5588,6 @@ static int check_btrfs_root(struct btrfs_root *root, int check_all)
 		}
 	}
 
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -5682,7 +5616,7 @@ static int check_fs_root(struct btrfs_root *root)
 static int check_root_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
 			  struct extent_buffer *node, int slot)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct btrfs_root_ref *ref;
 	struct btrfs_root_ref *backref;
@@ -5726,7 +5660,7 @@ static int check_root_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
 		      ref_key->type == BTRFS_ROOT_REF_KEY ?
 		      "ROOT_REF" : "ROOT_BACKREF",
 		      ref_key->objectid, ref_key->offset);
-		goto out;
+		return err;
 	}
 
 	backref = btrfs_item_ptr(path.nodes[0], path.slots[0],
@@ -5756,8 +5690,6 @@ static int check_root_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
 		      "ROOT_REF" : "ROOT_BACKREF",
 		      ref_key->objectid, ref_key->offset);
 	}
-out:
-	btrfs_release_path(&path);
 	return err;
 }
 
@@ -5773,7 +5705,7 @@ int check_fs_roots_lowmem(void)
 {
 	struct btrfs_root *tree_root = gfs_info->tree_root;
 	struct btrfs_root *cur_root = NULL;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	struct extent_buffer *node;
 	int slot;
@@ -5869,7 +5801,6 @@ next:
 	}
 
 out:
-	btrfs_release_path(&path);
 	if (found_free_ino_cache)
 		pr_default("deprecated inode cache can be removed by 'btrfs rescue clear-ino-cache'\n");
 	return err;
@@ -5880,7 +5811,7 @@ out:
  */
 int check_chunks_and_extents_lowmem(void)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key old_key;
 	struct btrfs_key key;
 	struct btrfs_root *root;
@@ -5964,6 +5895,5 @@ out:
 			err &= ~(BG_ACCOUNTING_ERROR | SUPER_BYTES_USED_ERROR);
 	}
 
-	btrfs_release_path(&path);
 	return err;
 }
-- 
2.56.0

