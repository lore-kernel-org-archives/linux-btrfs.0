Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333747;
	b=cX1Ym7oaoDiIolbFtGoCkgszk7Rldm4z8IqIQmZtvli4qYuCA2tRK4qJpQUpabiuBHmw
	 ft4H2ykInPKrnWteQc4rC11is5eTA5+Ti9qgHIIptsxaP2GH/5ZYrJfTtEg8yqtPFX8QJ
	 6pM00Qs5SGwm3rnVud2JOnIyK/MnMI/bLf4sddpoLkBSQRfUS9Dg5csh1tTj+UlQS6IwS
	 Y1i7Q7gC+SximWipq0Q4VTSMwCb57FJMFnidegB8diUyKFQfIz77Q0rQlnuwbb7TPsXLT
	 rxDsJe3OI9v3mcZGpC0G1F2SPmfgD3BcqppkffngpjYswnEDA/WzSVnlNsZKixLRHyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333747;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=g42BGvs7RYXF0enbHlGOpZ+UUz4CdDZYa/u+V0FW2AU=;
	b=P7mPqCIejFWGmXBLxKn9zvZDnsAs09/j+ioNHxUKOq5dsb8JvMSXVvKPep9+0suXg4DS
	 tfAcPSJlwWDIv81KedFr3XQV5FvtfFDdiJBg+xZSC7IQJ1F0gnAwxpaxAlADo+3y/sRA3
	 pyIVMSwThpsR4V+PlYFW13lUsSf0YorQWenQDsSX+klmJwXlAHo0X1bAsLaXR5SPcHfnp
	 xVfYgPxT6Mz5Qahatlmsy1HP8i1jls2+QEGas9QliKOlfYK834cIb6Edz/+oh+WRKjG0Q
	 J+9S+uR1uyCV8t9dLi9cNOUQttbx4xm4/J/GZJgfusMlHyaPZmEfSAUcYBpPA1a6QDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=f+D2Eybf;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=f+D2Eybf;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDCD606A323
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FDCD606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=f+D2Eybf;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=f+D2Eybf
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6D0541FCF9
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g42BGvs7RYXF0enbHlGOpZ+UUz4CdDZYa/u+V0FW2AU=;
	b=f+D2EybfRzg9cVC5ATEyHrrMhinZT/tFMKiZQes6Bk4ydciEhcHfJoNOfQX1UUiU4oCWho
	FrwiwNo6qVdk+t1k/8mg+taJLw82RMCH8EsCdaHeFt9y7GTV/mo5DliARH26d+4x495QBn
	DfzzzX/qssG1jpt4qkw/i9xhRbR9RLE=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=f+D2Eybf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g42BGvs7RYXF0enbHlGOpZ+UUz4CdDZYa/u+V0FW2AU=;
	b=f+D2EybfRzg9cVC5ATEyHrrMhinZT/tFMKiZQes6Bk4ydciEhcHfJoNOfQX1UUiU4oCWho
	FrwiwNo6qVdk+t1k/8mg+taJLw82RMCH8EsCdaHeFt9y7GTV/mo5DliARH26d+4x495QBn
	DfzzzX/qssG1jpt4qkw/i9xhRbR9RLE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5978513432
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0uAiEekZ5GrDGwAAD6G6ig:T5
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/12] btrfs-progs: tune: use BTRFS_PATH_AUTO_RELEASE() for on-stack paths
Date: Fri, 30 Oct 2026 14:45:11 +1030
Message-ID: <5af92f33db87f42aec2c3920166183eedc826d75.1793333606.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 6D0541FCF9
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

Convert all on-stack btrfs_path in tune/ to BTRFS_PATH_AUTO_RELEASE(),
and drop the btrfs_release_path() calls that only existed as function
exit cleanup.

Where the path is only used inside one loop (generate_new_data_csums_range(),
delete_old_data_csums(), change_csum_objectids(),
extend_block_group_items()), the variable is declared in the loop body,
so the path is released as early as possible.

This also fixes the path leaks on error paths of:

- get_last_csum_bytenr()
- generate_new_data_csums_range()
- delete_old_data_csums()
- change_meta_csums()
- get_csum_items_range()
- btrfs_change_csum_type() helpers (resume_csum_change())
- extend_block_group_items()
- remove_owner_refs()
- enable_quota()

Explicit releases which are not at function exit are kept.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tune/change-csum.c        | 50 +++++++++++----------------------------
 tune/change-uuid.c        | 38 ++++++++++-------------------
 tune/convert-remap-tree.c | 12 ++++------
 tune/quota.c              | 19 +++++++--------
 4 files changed, 39 insertions(+), 80 deletions(-)

diff --git a/tune/change-csum.c b/tune/change-csum.c
index 1efb6fd60758..1e01a983ea17 100644
--- a/tune/change-csum.c
+++ b/tune/change-csum.c
@@ -40,7 +40,7 @@ static int check_csum_change_requreiment(struct btrfs_fs_info *fs_info, u16 new_
 {
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_root *dev_root = fs_info->dev_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -73,7 +73,6 @@ static int check_csum_change_requreiment(struct btrfs_fs_info *fs_info, u16 new_
 	key.offset = 0;
 	ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
 	if (ret < 0) {
-		btrfs_release_path(&path);
 		errno = -ret;
 		error("failed to check the dev-replace status: %m");
 		return ret;
@@ -86,7 +85,6 @@ static int check_csum_change_requreiment(struct btrfs_fs_info *fs_info, u16 new_
 		state = btrfs_dev_replace_replace_state(path.nodes[0], ptr);
 		if (state == BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED ||
 		    state == BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED) {
-			btrfs_release_path(&path);
 			error(
 	"running/suspended dev-replace detected, please finish or cancel it");
 			return -EINVAL;
@@ -105,7 +103,7 @@ static int check_csum_change_requreiment(struct btrfs_fs_info *fs_info, u16 new_
 static int get_last_csum_bytenr(struct btrfs_fs_info *fs_info, u64 *result)
 {
 	struct btrfs_root *csum_root = btrfs_csum_root(fs_info, 0);
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -127,13 +125,11 @@ static int get_last_csum_bytenr(struct btrfs_fs_info *fs_info, u64 *result)
 	 */
 	if (ret > 0) {
 		*result = 0;
-		btrfs_release_path(&path);
 		return 0;
 	}
 	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 	*result = key.offset + btrfs_item_size(path.nodes[0], path.slots[0]) /
 			       fs_info->csum_size * fs_info->sectorsize;
-	btrfs_release_path(&path);
 	return 0;
 }
 
@@ -239,7 +235,6 @@ static int generate_new_data_csums_range(struct btrfs_fs_info *fs_info, u64 star
 	const unsigned int nr_items = calc_csum_change_nr_items(fs_info, new_csum_type);
 	struct btrfs_root *csum_root = btrfs_csum_root(fs_info, 0);
 	struct btrfs_trans_handle *trans;
-	struct btrfs_path path = { 0 };
 	struct btrfs_key key;
 	void *csum_buffer;
 	u64 converted_bytes = 0;
@@ -266,6 +261,7 @@ static int generate_new_data_csums_range(struct btrfs_fs_info *fs_info, u64 star
 	}
 
 	while (cur < last_csum) {
+		BTRFS_PATH_AUTO_RELEASE(path);
 		u64 csum_start;
 		u64 len;
 		u32 item_size;
@@ -282,13 +278,10 @@ static int generate_new_data_csums_range(struct btrfs_fs_info *fs_info, u64 star
 			ret = btrfs_next_leaf(csum_root, &path);
 			if (ret > 0) {
 				ret = 0;
-				btrfs_release_path(&path);
 				break;
 			}
-			if (ret < 0) {
-				btrfs_release_path(&path);
+			if (ret < 0)
 				goto out;
-			}
 		}
 		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 		UASSERT(key.offset >= cur);
@@ -333,7 +326,7 @@ static int generate_new_data_csums(struct btrfs_fs_info *fs_info, u16 new_csum_t
 {
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -376,7 +369,6 @@ static int delete_old_data_csums(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *csum_root = btrfs_csum_root(fs_info, 0);
 	struct btrfs_trans_handle *trans = 0;
-	struct btrfs_path path = { 0 };
 	struct btrfs_key last_key;
 	unsigned int deleted_leaves = 0;
 	int ret;
@@ -386,6 +378,7 @@ static int delete_old_data_csums(struct btrfs_fs_info *fs_info)
 	last_key.offset = (u64)-1;
 
 	while (true) {
+		BTRFS_PATH_AUTO_RELEASE(path);
 		int start_slot;
 		int nr;
 
@@ -444,10 +437,8 @@ static int delete_old_data_csums(struct btrfs_fs_info *fs_info)
 			error("failed to delete items: %m");
 			break;
 		}
-		btrfs_release_path(&path);
 		deleted_leaves++;
 	}
-	btrfs_release_path(&path);
 	if (ret < 0)
 		btrfs_abort_transaction(trans, ret);
 	ret = btrfs_commit_transaction(trans, csum_root);
@@ -464,7 +455,6 @@ static int change_csum_objectids(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *csum_root = btrfs_csum_root(fs_info, 0);
 	struct btrfs_trans_handle *trans = NULL;
-	struct btrfs_path path = { 0 };
 	struct btrfs_key last_key;
 	unsigned int changed_leaves = 0;
 	u64 super_flags;
@@ -475,6 +465,7 @@ static int change_csum_objectids(struct btrfs_fs_info *fs_info)
 	last_key.offset = (u64)-1;
 
 	while (true) {
+		BTRFS_PATH_AUTO_RELEASE(path);
 		struct btrfs_key found_key;
 		int nr;
 
@@ -527,10 +518,8 @@ static int change_csum_objectids(struct btrfs_fs_info *fs_info)
 			path.slots[0] = i;
 			btrfs_set_item_key_safe(fs_info, &path, &found_key);
 		}
-		btrfs_release_path(&path);
 	}
 out:
-	btrfs_release_path(&path);
 	if (ret < 0) {
 		btrfs_abort_transaction(trans, ret);
 		return ret;
@@ -610,7 +599,7 @@ out:
 static int change_meta_csums(struct btrfs_fs_info *fs_info, u16 new_csum_type)
 {
 	struct btrfs_root *extent_root = btrfs_extent_root(fs_info, 0);
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	u64 super_flags;
 	int ret;
@@ -754,7 +743,7 @@ static int get_csum_items_range(struct btrfs_fs_info *fs_info,
 				u32 *last_item_size)
 {
 	struct btrfs_root *csum_root = btrfs_csum_root(fs_info, 0);
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -773,17 +762,14 @@ static int get_csum_items_range(struct btrfs_fs_info *fs_info,
 		if (ret < 0) {
 			errno = -ret;
 			error("failed to search csum tree: %m");
-			btrfs_release_path(&path);
 			return ret;
 		}
 		/*
 		 * There is no next leaf, meaning we didn't find any csum item
 		 * with given objectid.
 		 */
-		if (ret > 0) {
-			btrfs_release_path(&path);
+		if (ret > 0)
 			return ret;
-		}
 	}
 
 	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
@@ -808,16 +794,12 @@ static int get_csum_items_range(struct btrfs_fs_info *fs_info,
 	if (ret < 0) {
 		errno = -ret;
 		error("failed to search csum tree: %m");
-		btrfs_release_path(&path);
 		return ret;
 	}
-	if (ret > 0) {
-		btrfs_release_path(&path);
+	if (ret > 0)
 		return 1;
-	}
 	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 	*last_item_size = btrfs_item_size(path.nodes[0], path.slots[0]);
-	btrfs_release_path(&path);
 	*last_ret = key.offset;
 	return 0;
 }
@@ -834,7 +816,7 @@ static int determine_csum_type(struct btrfs_fs_info *fs_info, u64 logical,
 			       u16 csum_type)
 {
 	struct btrfs_root *csum_root = btrfs_csum_root(fs_info, logical);
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	u16 csum_size = btrfs_csum_type_size(csum_type);
 	u8 csum_expected[BTRFS_CSUM_SIZE];
@@ -851,7 +833,6 @@ static int determine_csum_type(struct btrfs_fs_info *fs_info, u64 logical,
 	if (ret < 0) {
 		errno = -ret;
 		error("failed to search csum tree: %m");
-		btrfs_release_path(&path);
 		return ret;
 	}
 
@@ -859,10 +840,8 @@ static int determine_csum_type(struct btrfs_fs_info *fs_info, u64 logical,
 	 * The csum item size is smaller than expected csum size, no
 	 * more need to check.
 	 */
-	if (btrfs_item_size(path.nodes[0], path.slots[0]) < csum_size) {
-		btrfs_release_path(&path);
+	if (btrfs_item_size(path.nodes[0], path.slots[0]) < csum_size)
 		return 1;
-	}
 	read_extent_buffer(path.nodes[0], csum_expected,
 			   btrfs_item_ptr_offset(path.nodes[0], path.slots[0]),
 			   csum_size);
@@ -1009,7 +988,7 @@ static int resume_csum_change(struct btrfs_fs_info *fs_info, u16 new_csum_type)
 {
 	const u64 super_flags = btrfs_super_flags(fs_info->super_copy);
 	struct btrfs_root *tree_root = fs_info->tree_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -1039,7 +1018,6 @@ static int resume_csum_change(struct btrfs_fs_info *fs_info, u16 new_csum_type)
 	if (ret < 0) {
 		errno = -ret;
 		error("failed to locate the csum change item: %m");
-		btrfs_release_path(&path);
 		return ret;
 	}
 	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
diff --git a/tune/change-uuid.c b/tune/change-uuid.c
index c24cba7080bf..db63e446ac8f 100644
--- a/tune/change-uuid.c
+++ b/tune/change-uuid.c
@@ -84,7 +84,7 @@ static int change_buffer_header_uuid(struct extent_buffer *eb, uuid_t new_fsid)
 static int change_extent_tree_uuid(struct btrfs_fs_info *fs_info, uuid_t new_fsid)
 {
 	struct btrfs_root *root = btrfs_extent_root(fs_info, 0);
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key = {0, 0, 0};
 	int ret = 0;
 
@@ -94,7 +94,7 @@ static int change_extent_tree_uuid(struct btrfs_fs_info *fs_info, uuid_t new_fsi
 	 */
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	while (1) {
 		struct btrfs_extent_item *ei;
@@ -117,29 +117,22 @@ static int change_extent_tree_uuid(struct btrfs_fs_info *fs_info, uuid_t new_fsi
 		eb = read_tree_block(fs_info, bytenr, &check);
 		if (IS_ERR(eb)) {
 			error("failed to read tree block: %llu", bytenr);
-			ret = PTR_ERR(eb);
-			goto out;
+			return PTR_ERR(eb);
 		}
 		ret = change_buffer_header_uuid(eb, new_fsid);
 		free_extent_buffer(eb);
 		if (ret < 0) {
 			error("failed to change uuid of tree block: %llu",
 				bytenr);
-			goto out;
+			return ret;
 		}
 next:
 		ret = btrfs_next_item(root, &path);
 		if (ret < 0)
-			goto out;
-		if (ret > 0) {
-			ret = 0;
-			goto out;
-		}
+			return ret;
+		if (ret > 0)
+			return 0;
 	}
-
-out:
-	btrfs_release_path(&path);
-	return ret;
 }
 
 static int change_device_uuid(struct extent_buffer *eb, int slot,
@@ -164,14 +157,14 @@ static int change_device_uuid(struct extent_buffer *eb, int slot,
 
 static int change_chunk_tree_uuid(struct btrfs_root *root, uuid_t new_fsid)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key = {0, 0, 0};
 	int ret = 0;
 
 	/* No transaction again */
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	while (1) {
 		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
@@ -181,19 +174,14 @@ static int change_chunk_tree_uuid(struct btrfs_root *root, uuid_t new_fsid)
 		ret = change_device_uuid(path.nodes[0], path.slots[0],
 					 new_fsid);
 		if (ret < 0)
-			goto out;
+			return ret;
 next:
 		ret = btrfs_next_item(root, &path);
 		if (ret < 0)
-			goto out;
-		if (ret > 0) {
-			ret = 0;
-			goto out;
-		}
+			return ret;
+		if (ret > 0)
+			return 0;
 	}
-out:
-	btrfs_release_path(&path);
-	return ret;
 }
 
 static int change_fsid_done(struct btrfs_fs_info *fs_info)
diff --git a/tune/convert-remap-tree.c b/tune/convert-remap-tree.c
index 21f1f4e2ffc5..6bc8f14fd7e7 100644
--- a/tune/convert-remap-tree.c
+++ b/tune/convert-remap-tree.c
@@ -98,7 +98,6 @@ static int create_remap_tree(struct btrfs_trans_handle *trans)
 static int extend_block_group_items(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_path path = { 0 };
 	struct btrfs_key key = { 0 };
 	struct extent_buffer *leaf;
 	struct btrfs_block_group_item_v2 *bgi;
@@ -106,6 +105,8 @@ static int extend_block_group_items(struct btrfs_trans_handle *trans)
 	u32 size;
 
 	while (true) {
+		BTRFS_PATH_AUTO_RELEASE(path);
+
 		ret = btrfs_search_slot(trans, fs_info->block_group_root, &key,
 					&path, -1, 1);
 		if (ret < 0)
@@ -113,10 +114,8 @@ static int extend_block_group_items(struct btrfs_trans_handle *trans)
 
 		leaf = path.nodes[0];
 
-		if (path.slots[0] >= btrfs_header_nritems(leaf)) {
-			btrfs_release_path(&path);
+		if (path.slots[0] >= btrfs_header_nritems(leaf))
 			break;
-		}
 
 		while (path.slots[0] < btrfs_header_nritems(leaf)) {
 			btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
@@ -143,8 +142,6 @@ static int extend_block_group_items(struct btrfs_trans_handle *trans)
 
 		key.objectid++;
 		key.offset = 0;
-
-		btrfs_release_path(&path);
 	}
 
 	return 0;
@@ -154,7 +151,7 @@ int convert_to_remap_tree(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_super_block *sb = fs_info->super_copy;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int ret;
 
@@ -166,7 +163,6 @@ int convert_to_remap_tree(struct btrfs_fs_info *fs_info)
 		return ret;
 
 	if (!ret) {
-		btrfs_release_path(&path);
 		error("cannot convert filesystem that has balance already in progress");
 		return -EINVAL;
 	}
diff --git a/tune/quota.c b/tune/quota.c
index 746c0ef0a258..a5f7fb40c73f 100644
--- a/tune/quota.c
+++ b/tune/quota.c
@@ -86,7 +86,7 @@ static int remove_owner_refs(struct btrfs_fs_info *fs_info)
 	struct btrfs_root *extent_root;
 	struct btrfs_key key;
 	struct extent_buffer *leaf;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	int slot;
 	int ret;
 
@@ -170,7 +170,7 @@ static int create_qgroup(struct btrfs_fs_info *fs_info,
 			 struct btrfs_trans_handle *trans,
 			 u64 qgroupid)
 {
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_root *quota_root = fs_info->quota_root;
 	struct btrfs_key key;
 	int ret;
@@ -195,7 +195,6 @@ static int create_qgroup(struct btrfs_fs_info *fs_info,
 	key.offset = qgroupid;
 	ret = btrfs_insert_empty_item(trans, quota_root, &path, &key,
 				      sizeof(struct btrfs_qgroup_limit_item));
-	btrfs_release_path(&path);
 
 	printf("created qgroup for %llu\n", qgroupid);
 	return ret;
@@ -209,7 +208,7 @@ static int create_qgroups(struct btrfs_fs_info *fs_info,
 		.type = BTRFS_ROOT_REF_KEY,
 		.offset = 0,
 	};
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct extent_buffer *leaf;
 	int slot;
 	struct btrfs_root *tree_root = fs_info->tree_root;
@@ -218,11 +217,11 @@ static int create_qgroups(struct btrfs_fs_info *fs_info,
 
 	ret = create_qgroup(fs_info, trans, BTRFS_FS_TREE_OBJECTID);
 	if (ret)
-		goto out;
+		return ret;
 
 	ret = btrfs_search_slot_for_read(tree_root, &key, &path, 1, 0);
 	if (ret)
-		goto out;
+		return ret;
 
 	while (1) {
 		slot = path.slots[0];
@@ -231,19 +230,17 @@ static int create_qgroups(struct btrfs_fs_info *fs_info,
 		if (key.type == BTRFS_ROOT_REF_KEY) {
 			ret = create_qgroup(fs_info, trans, key.offset);
 			if (ret)
-				goto out;
+				return ret;
 		}
 		ret = btrfs_next_item(tree_root, &path);
 		if (ret < 0) {
 			error("failed to advance to next item");
-			goto out;
+			return ret;
 		}
 		if (ret)
 			break;
 	}
 
-out:
-	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -254,7 +251,7 @@ int enable_quota(struct btrfs_fs_info *fs_info, bool simple)
 	int super_flags = btrfs_super_incompat_flags(sb);
 	struct btrfs_qgroup_status_item *qsi;
 	struct btrfs_root *quota_root;
-	struct btrfs_path path = { 0 };
+	BTRFS_PATH_AUTO_RELEASE(path);
 	struct btrfs_key key;
 	int flags;
 	int ret;
-- 
2.56.0

