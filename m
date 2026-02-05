Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD284235BE2
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Feb 2026 00:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770336014; cv=none; b=HkDfcu7k7OZHrhmNHMvE8k3/3lhnXzkLsbEny2ck+ZgkKlxGZix509lsuwxZWeaNAcKhswRPjJTDyrCEzKJLDzzwqzJR3zvJRedZYAWGlx0bfvPV7YD5TqhvYlb81erAsurvm1lsvpmQcIBAVmXqaC5hg9q5h2OEjK8l9/FZ/BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770336014; c=relaxed/simple;
	bh=gJzpiIXRO9/+XlxF0DBLRTZx0K1FsJbAp+7vd/sGSuY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddNWKmi/1d4trg9U5TqLDrFhzVso5/Yue2xcMjDM4wNSwmMFq6w+S06L7PZo6C0ZmV/4Xp04tKLm2ueSME9CRakEKRZmZUd1Kiucr668d37Dmy1AAaq7lr3RUxgAPtXUgKUUHEOOqQ5r/u/+ZoepzDbQiQvI0vbJawoo9GzK1Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VCFc7gQl; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VCFc7gQl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VCFc7gQl";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VCFc7gQl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 844373E6D7
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Feb 2026 00:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770336004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pUil802vgffTwNAHnFOT5wuR6v4j25+zrOU8HCoPH/o=;
	b=VCFc7gQlulaJkYwHk8Py5Y93037Dw/ahB0WyZpCiyAumcuL8N3D9HbpMkEdQtnPKJTWl5a
	4yYhZRrBpuQ9fYoXIDgXj18FWG4n0k4XA3iTLjiWT7INyKo1BV2ChCWn2BTJrIleQHMfyE
	uldKjd3a7hmUG3smu9LuRQdqf+YYLhY=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=VCFc7gQl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770336004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pUil802vgffTwNAHnFOT5wuR6v4j25+zrOU8HCoPH/o=;
	b=VCFc7gQlulaJkYwHk8Py5Y93037Dw/ahB0WyZpCiyAumcuL8N3D9HbpMkEdQtnPKJTWl5a
	4yYhZRrBpuQ9fYoXIDgXj18FWG4n0k4XA3iTLjiWT7INyKo1BV2ChCWn2BTJrIleQHMfyE
	uldKjd3a7hmUG3smu9LuRQdqf+YYLhY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B35D83EA63
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Feb 2026 00:00:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wD5sHAMvhWlzOQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 06 Feb 2026 00:00:03 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: check: add repair support for orphan fst entry
Date: Fri,  6 Feb 2026 10:29:42 +1030
Message-ID: <becdec428e6f68de24c385bce59166509de326ca.1770335913.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1770335913.git.wqu@suse.com>
References: <cover.1770335913.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 844373E6D7
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

Although we're pushing for the kernel auto fix, it may still take some
time.
Meanwhile having a proper way to fix it in progs will never hurt.

The repair itself is a little more complex than the kernel one, which
only needs to bother the entries before the first block group.

This progs version in theory is able to handle orphan entries at any
location, but for now it's only for the entries before the first bg.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/clear-cache.c | 131 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 130 insertions(+), 1 deletion(-)

diff --git a/common/clear-cache.c b/common/clear-cache.c
index 47d5751ff2c9..69e91e5e7796 100644
--- a/common/clear-cache.c
+++ b/common/clear-cache.c
@@ -29,6 +29,7 @@
 #include "kernel-shared/volumes.h"
 #include "kernel-shared/transaction.h"
 #include "kernel-shared/file-item.h"
+#include "kernel-shared/print-tree.h"
 #include "common/internal.h"
 #include "common/messages.h"
 #include "common/clear-cache.h"
@@ -132,6 +133,128 @@ close_out:
 	return ret;
 }
 
+/*
+ * Return 0 if we found an fst entry in range [start, start + length), @path will
+ * be updated to pointing to that entry.
+ *
+ * Return >0 if we found no more fst entry in range [start, start + length).
+ *
+ * Return <0 for error.
+ */
+static int find_first_fst_entry(struct btrfs_root *root, struct btrfs_path *path,
+				u64 start, u64 length)
+{
+	struct btrfs_key key = { .objectid = start };
+	int ret;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (unlikely(ret < 0))
+		goto out;
+	if (unlikely(ret == 0)) {
+		ret = -EUCLEAN;
+		error("unexpected key found in slot %u\n", path->slots[0]);
+		btrfs_print_leaf(path->nodes[0]);
+		goto out;
+	}
+	while (true) {
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret)
+				goto out;
+		}
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+		/* Beyond the range. No more entry. */
+		if (key.objectid >= start + length) {
+			ret = 1;
+			goto out;
+		}
+		/* In the range, return this one. */
+		if (key.objectid >= start && key.objectid < start + length)
+			break;
+
+		/* The current key is small than our range, continue searching. */
+		path->slots[0]++;
+	}
+
+	/* We found a key in our range. */
+	UASSERT(path->nodes[0]);
+	return 0;
+out:
+	UASSERT(ret != 0);
+	btrfs_release_path(path);
+	return ret;
+}
+
+static int remove_free_space_entries(struct btrfs_root *root, struct btrfs_path *path,
+				     const struct btrfs_key *space_info_key)
+{
+	struct btrfs_trans_handle *trans = NULL;
+	u64 start = space_info_key->objectid;
+	const u64 end = start + space_info_key->offset - 1;
+	u64 cur = start;
+	int ret;
+
+	while (cur <= end) {
+		struct btrfs_key found_key;
+		int found_slot;
+		int last_slot;
+
+		ret = find_first_fst_entry(root, path, cur, end + 1 - cur);
+		if (ret < 0)
+			goto error;
+		if (ret > 0)
+			break;
+
+		btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
+		btrfs_release_path(path);
+
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			error_msg(ERROR_MSG_START_TRANS, "remove orphan fst entry");
+			return PTR_ERR(trans);
+		}
+		ret = btrfs_search_slot(trans, root, &found_key, path, -1, 1);
+		if (ret > 0)
+			ret = -ENOENT;
+		if (ret < 0)
+			goto error;
+
+		found_slot = path->slots[0];
+
+		/*
+		 * @last_slot will be the next slot of the last item which matches
+		 * our range.
+		 */
+		for (last_slot = found_slot + 1;
+		     last_slot < btrfs_header_nritems(path->nodes[0]); last_slot++){
+			btrfs_item_key_to_cpu(path->nodes[0], &found_key, last_slot);
+			if (found_key.objectid >= start && found_key.objectid <= end)
+				cur = found_key.objectid;
+			else
+				break;
+		}
+		ret = btrfs_del_items(trans, root, path, found_slot,
+				      last_slot - found_slot);
+		if (ret < 0)
+			goto error;
+		btrfs_release_path(path);
+		ret = btrfs_commit_transaction(trans, root);
+		trans = NULL;
+		if (ret < 0) {
+			error_msg(ERROR_MSG_START_TRANS, "remove orphan fst entry");
+			goto error;
+		}
+	}
+	printf("deleted orphan fst entries for range [%llu, %llu)\n",
+		start, end + 1);
+	return 0;
+error:
+	btrfs_release_path(path);
+	if (trans)
+		btrfs_abort_transaction(trans, ret);
+	return ret;
+}
+
 static int check_free_space_tree(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -167,10 +290,16 @@ static int check_free_space_tree(struct btrfs_root *root)
 
 		bg = btrfs_lookup_block_group(fs_info, key.objectid);
 		if (!bg) {
+			btrfs_release_path(&path);
 			fprintf(stderr,
 "Space key logical %llu length %llu has no corresponding block group\n",
 				key.objectid, key.offset);
-			found_orphan = true;
+			if (opt_check_repair)
+				ret = remove_free_space_entries(root, &path, &key);
+			else
+				ret = -EINVAL;
+			if (ret < 0)
+				found_orphan = true;
 		}
 
 		btrfs_release_path(&path);
-- 
2.52.0

