Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F99042589A
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791190910; cv=none; b=ULlfq6ij2j2NDOlx9+5PQHuZxngkYmM9eSK4LZSiEfuQTu3fRKeLujAyjIGn6/MubLMEgpZCjEHz/mJDCa73m6tmYHLOkOFk+uLIuazZZhXC+TvunRWumO5LEgdWwvOalI7MIAwMpS0EOviL8Aw7Z7SSSSiXg9ciY7sCA0SsJIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791190910; c=relaxed/simple;
	bh=EGZkKDLqLZQGVYZKjWBngPbeRcHK3cxbz1ghYalz3Mo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+Hr4XvKfRup87hu6dkv+ie701sTokzP/WENrh51U+MFS/uB4hSCszQV2ADOMbzLZyGVpQ+2Jv6bo3jhd1/zD+ihbFaOLnR1WpuX9w0twbsqaDthli7ULgxdssQg4cKaPjApw7ZK0jZIxL2T54kGz/r/T6SGZpzg9F8T71wENFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IMp3IrKM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Yfqlg63r; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IMp3IrKM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Yfqlg63r"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A8AF81F7A8
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791190902; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xPx+csm1DAmdzZdhW2CnwXp39T4TsnsMIB6RGXSFzO0=;
	b=IMp3IrKM4uZcUvzSEi6PLpbR0cRlzhzYCGej1DMUZPV1Pq6TaJhFvJzagt8CsSOtfYtKjV
	OqI6tggqz4quUO0rymvJ1gWDAgnKRkoCOfWFmHtvJBb+ZpJQ/K3xLot1SGS6kJO6edGaiG
	T80FgguYoYPlVVI79iYz1Tat/y3ckp8=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Yfqlg63r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791190898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xPx+csm1DAmdzZdhW2CnwXp39T4TsnsMIB6RGXSFzO0=;
	b=Yfqlg63rV0nBTl4D1ete+1nbR/Ijbuk/G0RxTFrBpzeV55IS2YIZpP7YhsXLLrwJ5XZ5gS
	njpfzqwIibsZPva+yc/2iWk0V6TjhD0+m6LQQg+6XFrA6hiBUlidw5XU67N9nMJCQmjfA4
	wIK/7UWOxBNR5ncMTXMHt5jeueNjQPw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DB0C13A1E
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 09:01:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ngyMK2tnw2qpRwAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2026 09:01:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs-progs: check: refactor load_quota_info()
Date: Mon,  5 Oct 2026 19:31:12 +1030
Message-ID: <c07ad63df2f3f6e5a98d0861349aaff92c45b659.1791190852.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791190852.git.wqu@suse.com>
References: <cover.1791190852.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A8AF81F7A8
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Modernize that function by:

- Use btrfs_key when possible
  The structure btrfs_disk_key is only for on-disk usage, every
  in-memory operation is based on btrfs_key.

  This includes the function alloc_count(), which now also accepts
  btrfs_key as a parameter.

- Enhance the error handling
  The path is not released when we hit an error.

- Use an dedicated helper to scan one leaf
  Instead of nested loops, which is bug-prone for continue/break calls.

- Remove the unnecessary double loop
  There is a local variable @search_relations, which has caused a long
  existing bug before.

  The idea is to skip all the QGROUP_LIMIT items, but we can skip them
  very quickly, and it's way better for one's mental health just to do a
  full tree iteration.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/qgroup-verify.c | 153 +++++++++++++++++++++---------------------
 1 file changed, 75 insertions(+), 78 deletions(-)

diff --git a/check/qgroup-verify.c b/check/qgroup-verify.c
index 433d89b47d3a..63902ffa6f5b 100644
--- a/check/qgroup-verify.c
+++ b/check/qgroup-verify.c
@@ -853,7 +853,7 @@ static struct qgroup_count *find_count(u64 qgroupid)
 	return NULL;
 }
 
-static struct qgroup_count *alloc_count(struct btrfs_disk_key *key,
+static struct qgroup_count *alloc_count(struct btrfs_key *key,
 					struct extent_buffer *leaf,
 					struct btrfs_qgroup_info_item *disk)
 {
@@ -861,7 +861,7 @@ static struct qgroup_count *alloc_count(struct btrfs_disk_key *key,
 	struct qgroup_info *item;
 
 	if (c) {
-		c->qgroupid = btrfs_disk_key_offset(key);
+		c->qgroupid = key->offset;
 
 		item = &c->diskinfo;
 		item->referenced = btrfs_qgroup_info_rfer(leaf, disk);
@@ -928,30 +928,80 @@ static void read_qgroup_status(struct btrfs_fs_info *info, struct extent_buffer
 	ct->scan_progress = btrfs_qgroup_status_rescan(eb, status_item);
 }
 
+static int load_one_quota_leaf(struct extent_buffer *leaf)
+{
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
+	const u32 nr_items = btrfs_header_nritems(leaf);
+
+	for (int i = 0; i < nr_items; i++) {
+		struct qgroup_count *qc;
+		struct btrfs_qgroup_info_item *qii;
+		struct btrfs_key key;
+		struct btrfs_key root_key;
+		struct btrfs_root *subv_root;
+		int ret;
+
+		btrfs_item_key_to_cpu(leaf, &key, i);
+
+		if (key.type == BTRFS_QGROUP_RELATION_KEY) {
+			ret = add_qgroup_relation(key.objectid,
+						  key.offset);
+			if (ret) {
+				errno = -ret;
+				error(
+	"failed to add qgroup relation, member=%llu parent=%llu: %m",
+				      key.objectid, key.offset);
+				return ret;
+			}
+			continue;
+		}
+
+		if (key.type == BTRFS_QGROUP_STATUS_KEY) {
+			read_qgroup_status(fs_info, leaf, i, &counts);
+			continue;
+		}
+
+		/*
+		 * At this point, we can ignore anything that
+		 * isn't a qgroup info.
+		 */
+		if (key.type != BTRFS_QGROUP_INFO_KEY)
+			continue;
+
+		qii = btrfs_item_ptr(leaf, i, struct btrfs_qgroup_info_item);
+
+		qc = alloc_count(&key, leaf, qii);
+		if (!qc) {
+			ret = ENOMEM;
+			error_mem(NULL);
+			return ret;
+		}
+
+		root_key.objectid = key.offset;
+		root_key.type = BTRFS_ROOT_ITEM_KEY;
+		root_key.offset = (u64)-1;
+		subv_root = btrfs_read_fs_root_no_cache(fs_info, &root_key);
+		if (!IS_ERR(subv_root)) {
+			qc->subvol_exists = 1;
+			btrfs_free_fs_root(subv_root);
+		}
+	}
+	return 0;
+}
+
 static int load_quota_info(struct btrfs_fs_info *info)
 {
 	int ret;
 	struct btrfs_root *root = info->quota_root;
-	struct btrfs_root *tmproot;
 	struct btrfs_path path = { 0 };
 	struct btrfs_key key;
-	struct btrfs_key root_key;
-	struct btrfs_disk_key disk_key;
 	struct extent_buffer *leaf;
-	struct btrfs_qgroup_info_item *item;
-	struct qgroup_count *count;
-	int i, nr;
-	int search_relations = 0;
 
 	if (btrfs_fs_incompat(info, SIMPLE_QUOTA))
 		counts.simple = 1;
-loop:
-	/*
-	 * Do 2 passes, the first allocates group counts and reads status
-	 * items. The 2nd pass picks up relation items and glues them to their
-	 * respective count structures.
-	 */
-	key.objectid = search_relations ? BTRFS_QGROUP_RELATION_KEY : 0;
+
+	/* Go through all qgroup leaves, and load qgroups and relationship items. */
+	key.objectid = 0;
 	key.type = 0;
 	key.offset = 0;
 
@@ -964,72 +1014,19 @@ loop:
 	while (1) {
 		leaf = path.nodes[0];
 
-		nr = btrfs_header_nritems(leaf);
-		for(i = 0; i < nr; i++) {
-			btrfs_item_key(leaf, &disk_key, i);
-			btrfs_disk_key_to_cpu(&key, &disk_key);
-
-			if (search_relations) {
-				if (key.type == BTRFS_QGROUP_RELATION_KEY) {
-					ret = add_qgroup_relation(key.objectid,
-								  key.offset);
-					if (ret) {
-						errno = -ret;
-						error(
-		"failed to add qgroup relation, member=%llu parent=%llu: %m",
-						      key.objectid, key.offset);
-						goto out;
-					}
-				}
-				continue;
-			}
-
-			if (key.type == BTRFS_QGROUP_STATUS_KEY) {
-				read_qgroup_status(info, leaf, i, &counts);
-				continue;
-			}
-
-			/*
-			 * At this point, we can ignore anything that
-			 * isn't a qgroup info.
-			 */
-			if (key.type != BTRFS_QGROUP_INFO_KEY)
-				continue;
-
-			item = btrfs_item_ptr(leaf, i,
-					      struct btrfs_qgroup_info_item);
-
-			count = alloc_count(&disk_key, leaf, item);
-			if (!count) {
-				ret = ENOMEM;
-				error_mem(NULL);
-				goto out;
-			}
-
-			root_key.objectid = key.offset;
-			root_key.type = BTRFS_ROOT_ITEM_KEY;
-			root_key.offset = (u64)-1;
-			tmproot = btrfs_read_fs_root_no_cache(info, &root_key);
-			if (tmproot && !IS_ERR(tmproot)) {
-				count->subvol_exists = 1;
-				btrfs_free_fs_root(tmproot);
-			}
-		}
-
+		ret = load_one_quota_leaf(leaf);
+		if (ret < 0)
+			goto out;
 		ret = btrfs_next_leaf(root, &path);
-		if (ret != 0)
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			ret = 0;
 			break;
+		}
 	}
-
-	ret = 0;
-	btrfs_release_path(&path);
-
-	if (!search_relations) {
-		search_relations = 1;
-		goto loop;
-	}
-
 out:
+	btrfs_release_path(&path);
 	return ret;
 }
 
-- 
2.55.0

