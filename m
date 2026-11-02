Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793611745;
	b=uqW6Z6arGRPx8wpcp8y+N8mmC1Z27or7ghiky2vR1qBI2JSCcGAqs9mcycrvQhWGBqCN
	 yIQSbbj2XIiQfoA00GdtxTDMdjSUE1DcGwgEIANvhi65LxMFdZMAD7YVvupXqqHR2DtTK
	 4QD32VHPzVEIS2HGfr7A2s9O8QGKykTKl0YlPPEC4ZPkfX9UqpPYXJKbHqXOsXNxkmJ05
	 T2rxc+ZqkeyWuX4DcOvpYaxtGVToAw0NzPQFdjRu3WFkgRtGBTjMGxd5tq5TE6fwGUaJf
	 Kq4HYcfsKzm9gIOWT2KguQ49L9zEiPjhwRQx6v4WQgm9+W3wVoTlhlU+BlRbBtcAZPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793611745;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=Ez4Yw1igq+J6xr+i8x6xZZKQORECah3FdMzPbVIeFqM=;
	b=K72xMVKMhdEMsYKzRBl0m3Ci5MRU2NBJmOTQXWccmHxcA9vgVd8fcV8RJaVfq2DE6hVr
	 65CbyAms//YdHQXdr1QKgcgBTa7EYdLHIc5xflOTDn3xW7sPXk74hoHhXUohmyrAfdA2R
	 DXo6QOmFcTEpzEERSlO38ApBYen7sV9nXSZZ8pw6Ia60pJI8iXdRO6vuAO59GwUnDDyNA
	 ln9Pt+VA7YeiYZlSKW7G/9cTFgQmUofUgr4VCwYEyUSvDXrQQKtLfCOq/EPB+BCntXXHG
	 RmWrX4eNDn3kRbj/qFS+Trle7mba/56GtmzP3Fp/dWmDIjqRWGgPG2IOXhYMu1k4JYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JvyIwhfS;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JvyIwhfS;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B23606A330
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 09:29:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58B23606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JvyIwhfS;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JvyIwhfS
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ACFCB1F7CD
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 09:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793611743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ez4Yw1igq+J6xr+i8x6xZZKQORECah3FdMzPbVIeFqM=;
	b=JvyIwhfSrxRKVGe+2VOh1oViO78wtpmP8BBZgj8WYU1RdyvtndvBDianZjjGzKB1Ql0hKu
	oRAwDKMNAx72yAF6MhRdNJjYOxVthSG+YLSvIfvtdcyM+jucti8pR2hPQqHaQK36cbYn/y
	tFzXuTqjNDvI9uUKdcY2wOPKTq7EJkc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793611743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ez4Yw1igq+J6xr+i8x6xZZKQORECah3FdMzPbVIeFqM=;
	b=JvyIwhfSrxRKVGe+2VOh1oViO78wtpmP8BBZgj8WYU1RdyvtndvBDianZjjGzKB1Ql0hKu
	oRAwDKMNAx72yAF6MhRdNJjYOxVthSG+YLSvIfvtdcyM+jucti8pR2hPQqHaQK36cbYn/y
	tFzXuTqjNDvI9uUKdcY2wOPKTq7EJkc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 89C84134B3
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 09:29:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R7qPENxX6GprcgAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 09:29:02 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: do not insert the data reloc tree into fs_roots_radix
Date: Mon,  2 Nov 2026 19:58:37 +1030
Message-ID: <737ab44fb9a8821281422f2bcdd6493c79b8853f.1793611601.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793611601.git.wqu@suse.com>
References: <cover.1793611601.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

The reasons not to do so are:

- There is already a global pointer fs_info->data_reloc_root
  And data reloc tree itself has TRACK_DIRTY flag set, thus its treated
  as a COW-only root, not a SHAREABLE root, unlike regular subvolume
  trees.

- 32-bit conflicts
  For 32-bit systems, radix tree index is always truncated to 32 bits.

  This means a subvolume with id 0xfffffff7, will conflict with the
  truncated data reloc tree id (0xfffffffffffffff7 -> 0xfffffff7).

  This will prevent btrfs from reading or creating such subvolume.
  Thankfully this should be very rare, as the subvolume id is reusable,
  and it's very hard to keep so many subvolumes before hitting other
  limits (e.g. anon_dev limits).

So change the code to not insert data reloc tree into fs_roots_radix:

- Load the tree with a dedicated helper
  The new helper, read_data_reloc_root() will call
  btrfs_read_tree_root(), with refs check, then call
  btrfs_init_fs_root().

  It skips the fs_roots_radix tree insert completely.

- Grab data_reloc_tree as a global root

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 51 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6afcd6ca2a8a..c47ac4eff28d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1169,6 +1169,8 @@ static struct btrfs_root *btrfs_get_global_root(struct btrfs_fs_info *fs_info,
 		return btrfs_grab_root(fs_info->stripe_root);
 	case BTRFS_REMAP_TREE_OBJECTID:
 		return btrfs_grab_root(fs_info->remap_root);
+	case BTRFS_DATA_RELOC_TREE_OBJECTID:
+		return btrfs_grab_root(fs_info->data_reloc_root);
 	default:
 		return NULL;
 	}
@@ -1304,8 +1306,13 @@ static struct btrfs_root *btrfs_get_root_ref(struct btrfs_fs_info *fs_info,
 	 *
 	 * This is namely for free-space-tree and quota tree, which can change
 	 * at runtime and should only be grabbed from fs_info.
+	 *
+	 * The data reloc tree is also such a tree.  It is loaded at mount time
+	 * by read_data_reloc_root() and never inserted into the radix tree, as
+	 * its objectid is truncated to the radix tree index on 32-bit systems
+	 * and can conflict with a real subvolume.
 	 */
-	if (!btrfs_is_fstree(objectid) && objectid != BTRFS_DATA_RELOC_TREE_OBJECTID)
+	if (!btrfs_is_fstree(objectid))
 		return ERR_PTR(-ENOENT);
 again:
 	root = btrfs_lookup_fs_root(fs_info, objectid);
@@ -1409,6 +1416,39 @@ struct btrfs_root *btrfs_get_new_fs_root(struct btrfs_fs_info *fs_info,
 	return btrfs_get_root_ref(fs_info, objectid, anon_dev, true);
 }
 
+/* Read and initialize the data reloc tree. */
+static struct btrfs_root *read_data_reloc_root(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_key key = {
+		.objectid = BTRFS_DATA_RELOC_TREE_OBJECTID,
+		.type = BTRFS_ROOT_ITEM_KEY,
+		.offset = (u64)-1,
+	};
+	struct btrfs_root *root;
+	int ret;
+
+	root = btrfs_read_tree_root(fs_info->tree_root, &key);
+	if (IS_ERR(root))
+		return root;
+
+	if (btrfs_root_refs(&root->root_item) == 0) {
+		ret = -ENOENT;
+		goto fail;
+	}
+
+	/*
+	 * This tree can share blocks with some other fs tree during
+	 * relocation and we need a proper setup by btrfs_init_fs_root().
+	 */
+	ret = btrfs_init_fs_root(root, 0);
+	if (ret)
+		goto fail;
+	return root;
+fail:
+	btrfs_put_root(root);
+	return ERR_PTR(ret);
+}
+
 /*
  * Return a root for the given objectid.
  *
@@ -2275,12 +2315,7 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
 				   PTR_ERR(root));
 		}
 	} else {
-		/*
-		 * This tree can share blocks with some other fs tree during
-		 * relocation and we need a proper setup by btrfs_get_fs_root().
-		 */
-		root = btrfs_get_fs_root(tree_root->fs_info,
-					 BTRFS_DATA_RELOC_TREE_OBJECTID, true);
+		root = read_data_reloc_root(fs_info);
 		if (IS_ERR(root)) {
 			if (!btrfs_test_opt(fs_info, IGNOREBADROOTS)) {
 				location.objectid = BTRFS_DATA_RELOC_TREE_OBJECTID;
@@ -3815,8 +3850,6 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	btrfs_put_block_group_cache(fs_info);
 
 fail_tree_roots:
-	if (fs_info->data_reloc_root)
-		btrfs_drop_and_free_fs_root(fs_info, fs_info->data_reloc_root);
 	free_root_pointers(fs_info, true);
 	invalidate_and_check_btree_folios(fs_info);
 
-- 
2.56.0

