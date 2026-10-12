Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C104457D5
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791796230; cv=none; b=UYg4NimGVFqAa6Bi2T82Wy8mE0kV8vjI1jtb5NIDV/pREVgQqDaUc4USALKxtX5YN+gFxLd13OkorRdXJliviThCbf3pjJqGBH381aeIwi+BcHnwIIrs7wRf/wN3tdROeOW0dx+gapuU8Ign8Ce+Dq8nfR85nvdy4e5MR+Kv8ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791796230; c=relaxed/simple;
	bh=WjVPIMrHzBdnHU1SKVMahbQSriz13OpwZ11bPX3djZg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Zlg5L6+1fPNJsnlRibwYsh7ZH7Di4AollNK2FjE/kVJLG6nFVauwhpqhGIzWJwb22wrl9EXY7GrnJWUevCl/MXtGLCt4JJcFt/7/2l786lqcLR4pfyeKRrmkkzLKt8kBPA98bRydsycez+wMbriGa4f/n91rNLm3WiDj1sRqjqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sDkKoUBg; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PHzjZi8R; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sDkKoUBg";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PHzjZi8R"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C3B3C1F7B6
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791796227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=C+9x/oTURySE8L7V4eva1uTG+RU0dSWz4gvM+4hZuxw=;
	b=sDkKoUBgxmUEaJ2dOxzGHEh7H1HAqIxj5ZSZ7FjxkJK2BkjhVl2iOopx9mnvb4w5qp58zO
	dI2Abp+h30y+/tvSks/NqtOAFgSTnoQnX1qodzAoqE0VsG6So42tT8SNMhprBiy0jcRIV8
	JoqJ0bEduh+pKbwauPd4t7StejlYhUg=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=PHzjZi8R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791796225; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=C+9x/oTURySE8L7V4eva1uTG+RU0dSWz4gvM+4hZuxw=;
	b=PHzjZi8R686e1uoiTaQypOWmzYneezJWMvp7RerZpr44yaAmhyVX3EJ0brFtQwYEdIJG9I
	iC2er5tPAWQq7HBmVUUSuJ/XMV16Eed650kWhQlLr/SZzaPdKm6lde1l1qZN2GnDdH19Hj
	eXmX+eeP/sbOEP2l1AAmPvj8gyq3bs0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A6E2E13408
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:10:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rOZRAgCkzGpRUwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:10:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: slightly loosen the balance reject condition
Date: Mon, 12 Oct 2026 19:40:06 +1030
Message-ID: <c201d00d2ade293894cbe61d439cd77607694ddd.1791796159.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Level: 
X-Rspamd-Queue-Id: C3B3C1F7B6
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

Since commit dde71e2be9bd ("btrfs-progs: reject writes if the fs has
running replace/balance"), btrfs-progs will reject any writable
operation to the fs if there is a balance item in the root tree.

However there is a report that such rejection is too strict, as the user
had a corruption in the extent tree only, for which no reloc tree should
exist, and the corruption can be repaired.

Furthermore, the reloc tree in that image has refs 0, meaning it has
already been merged, thus it's safe to modify the fs.

Instead of the overly strict balance item checks, do a kernel-like reloc
tree search, and only reject the write if there is a valid reloc tree
whose refs are not 0.

If there is no such valid reloc tree, still allow writable operations.

Issue: #1182
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/clear-cache.c | 88 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 78 insertions(+), 10 deletions(-)

diff --git a/common/clear-cache.c b/common/clear-cache.c
index 478bc97b4491..c8dbea6b4b74 100644
--- a/common/clear-cache.c
+++ b/common/clear-cache.c
@@ -98,6 +98,81 @@ int btrfs_clear_v1_cache(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+/*
+ * Checking the balance item can be a little overkill, as if there
+ * is no reloc tree, we are still safe to modify the fs.
+ *
+ * Return 0 if there is no valid reloc tree found.
+ * Return >0 if there is any valid reloc tree found.
+ * Return <0 for critical errors.
+ */
+static int has_reloc_trees(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_path path = { 0 };
+	struct btrfs_key key;
+	unsigned int found = 0;
+	int ret;
+
+	key.objectid = BTRFS_TREE_RELOC_OBJECTID;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(NULL, tree_root, &key, &path, 0, 0);
+	if (ret < 0)
+		goto out;
+	/*
+	 * This is impossible, as we should not have a tree with (u64)-1 as
+	 * tree id.
+	 */
+	if (unlikely(ret == 0)) {
+		ret = -EUCLEAN;
+		error("invalid reloc tree found, has invalid root key (%llu %u %llu)",
+		      key.objectid, key.type, key.offset);
+		goto out;
+	}
+
+	while (1) {
+		struct btrfs_root_item *ri;
+		struct btrfs_key found_key;
+		struct btrfs_key fs_key;
+		struct btrfs_root *fs_root;
+
+		ret = btrfs_previous_item(tree_root, &path,
+					  BTRFS_TREE_RELOC_OBJECTID, BTRFS_ROOT_ITEM_KEY);
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+		if (ret < 0)
+			goto out;
+		btrfs_item_key_to_cpu(path.nodes[0], &found_key, path.slots[0]);
+		ri = btrfs_item_ptr(path.nodes[0], path.slots[0], struct btrfs_root_item);
+		/* Already dropped reloc tree. */
+		if (btrfs_disk_root_refs(path.nodes[0], ri) == 0)
+			continue;
+		fs_key.objectid = found_key.offset;
+		fs_key.type = BTRFS_ROOT_ITEM_KEY;
+		fs_key.offset = (u64)-1;
+		fs_root = btrfs_read_fs_root_no_cache(fs_info, &fs_key);
+		if (IS_ERR(fs_root)) {
+			ret = PTR_ERR(fs_root);
+			if (ret != -ENOENT)
+				goto out;
+			continue;
+		}
+		btrfs_free_fs_root(fs_root);
+		found++;
+		break;
+	}
+
+out:
+	btrfs_release_path(&path);
+	if (ret < 0)
+		return ret;
+	return found;
+}
+
 /*
  * Check running replace or balance.
  *
@@ -107,7 +182,6 @@ int btrfs_clear_v1_cache(struct btrfs_fs_info *fs_info)
  */
 int has_running_replace_or_balance(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_root *dev_root = fs_info->dev_root;
 	struct btrfs_path path = { 0 };
 	struct btrfs_key key;
@@ -115,16 +189,10 @@ int has_running_replace_or_balance(struct btrfs_fs_info *fs_info)
 	u64 replace_state;
 	int ret;
 
-	key.objectid = BTRFS_BALANCE_OBJECTID;
-	key.type = BTRFS_TEMPORARY_ITEM_KEY;
-	key.offset = 0;
-
-	ret = btrfs_search_slot(NULL, tree_root, &key, &path, 0, 0);
-	btrfs_release_path(&path);
-	if (ret < 0)
+	ret = has_reloc_trees(fs_info);
+	/* Either <0 for error, or >0 for any found reloc tree. */
+	if (ret != 0)
 		return ret;
-	if (ret == 0)
-		return 1;
 
 	key.objectid = 0;
 	key.type = BTRFS_DEV_REPLACE_KEY;
-- 
2.56.0

