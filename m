Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268319;
	b=wtTrHyygOMWJ5OfSGEfNhZGhbFqZHNuZi4F12qNSTsNAv5a3BZyCJtNO/DgiRC1g6RRq
	 CXN6lUhrUQpDbaIoiXWBEy9pnjAEF/r40Z9JCZe9oHsY9gvw25CvokDm69qg0a92D7LC/
	 8KPU/GwxzcHIyUMHId2CsvOk9KM0kvYsFVBLgolbKowOGlHAAYk0bLxVXXVNxta5VCk1v
	 8Cn/2c8AK5+3CzP4USC+ee43CQkDYOB3RGs0h/rRoH0CWK2JT5ApZhRZLqdjFVE3y4FTV
	 vl7t3lTnwa4/3tHPwzPhkqJuhEpgDi0kCv0T/KfMiv3qGEShYENCbohJwI7nBbklfNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268319;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=DXDMPCAzaQnHTDUcWRuDgq5UQpR5zcO1MaafAdJM9Vo=;
	b=UrrFXLYCn1kDlL5SCnUGM1vKbMhJ43KXfU063QBR/8M48m8IUaRiQWb6mC96aYHoU597
	 Qu0eqRFTuNN9DU/5JOHIr1oB/WcMblOcSLwjDRLyqe7/k1pt3OYx4SldO8wJq2kp6fQzT
	 aiLMMpz97r+GILoI5/ShgaseZbyY0G6sFbRpoCQQ0CNVd9zdpYbwvAWxJH3PC7iqstEiv
	 Zss4FoGZmmjz5BU5COXpjRmV5/rlNWDHEJSQde8BCXyjRxr9zET+WMt9byMwby3udDzkF
	 kigp5ammlKJvZLXIwBddR7FdOnVRFufsxQD5F2IBkkPESLGIX/HxcApasJmtB8ilckw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="So/YxFz1";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="So/YxFz1";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9FD606A320
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED9FD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=So/YxFz1;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=So/YxFz1
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 556D21F7B3
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793268317; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DXDMPCAzaQnHTDUcWRuDgq5UQpR5zcO1MaafAdJM9Vo=;
	b=So/YxFz1qWS+qJHWTQEicifnBsQc6fBAYLUHm4jTVRE6f8cCDIH4nG7YRRlzIQiwTkfZdZ
	yUXZyQD05UEKJxhXrSG6cUAW3SWMm2pWLThlF2BIMywn6aa7i5nVeMqRTKj1lnLHnV9DOr
	/GAzg74BMGpuwc65aizRGW7gkmcG2MY=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="So/YxFz1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793268317; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DXDMPCAzaQnHTDUcWRuDgq5UQpR5zcO1MaafAdJM9Vo=;
	b=So/YxFz1qWS+qJHWTQEicifnBsQc6fBAYLUHm4jTVRE6f8cCDIH4nG7YRRlzIQiwTkfZdZ
	yUXZyQD05UEKJxhXrSG6cUAW3SWMm2pWLThlF2BIMywn6aa7i5nVeMqRTKj1lnLHnV9DOr
	/GAzg74BMGpuwc65aizRGW7gkmcG2MY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42E2D13419
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 380rJ1Ma42qwKgAAD6G6ig:T6
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:15 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/5] btrfs-progs: fix several memory bugs in btrfs-corrupt-block
Date: Thu, 29 Oct 2026 20:34:41 +1030
Message-ID: <0986b72bdae74dd95b86bae519ef402ee3f2ef9f.1793268211.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793268211.git.wqu@suse.com>
References: <cover.1793268211.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 556D21F7B3
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

These involves several call sites:

- BTRFS_METADATA_BLOCK_GENERATION branch of corrupt_metadata_block()

- BTRFS_METADATA_BLOCK_SHIFT_ITEMS branch of corrupt_metadata_block()

- if (chunk_rec) branch of main()

The bugs are:

- Use-after-free if write_data_to_disk() failed in
  BTRFS_METADATA_BLOCK_GENERATION branch
  Fix it by saving @eb->start and use that saved value for error
  message.

- Path leak in the successful path
  Fix it by using BTRFS_PATH_AUTO_FREE() and remove all existing
  btrfs_free_path().

- Path held after btrfs_commit_transaction()
  This is minor, but still release the path before
  btrfs_commit_transaction() to follow the kernel behavior.

- Missing error message and code if btrfs_commit_transaction failed
  Just add the missing error message and save the error code from it.

- Wrong value in the error message if btrfs_read_fs_root() failed
  Fix it by printing root_key.objectid.

- Missing error code if early failures happened in chunk_rec branch
  Fix it by setting @ret to -ENOMEM or -ENOENT respectively.

Behavior changes:

- Abort the transaction if corrupt_item_nocow() failed in chunk_rec
  branch
  Previously we would still commit the transaction after a failed
  corrupt_item_nocow(), which is meaningless for a failed operation.
  Now we abort the transaction and exit through out_close, without
  committing.

Cleanup:

- Remove the dead "eb = path->nodes[level]" assignment in SHIFT_ITEMS
  branch
  @eb is not used after that, and it was already freed earlier.

Assisted-by: LLM (generate the commit message with human modification)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 btrfs-corrupt-block.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 94815221a32d..0fc2c42e7ffa 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -910,6 +910,7 @@ static int corrupt_metadata_block(struct btrfs_fs_info *fs_info, u64 block,
 		{
 		u64 orig = btrfs_header_generation(eb);
 		u64 bogus = generate_u64(orig);
+		const u64 start = eb->start;
 
 		btrfs_set_header_generation(eb, bogus);
 		csum_tree_block_size(eb, fs_info->csum_size, 0,
@@ -919,7 +920,7 @@ static int corrupt_metadata_block(struct btrfs_fs_info *fs_info, u64 block,
 		if (ret < 0) {
 			errno = -ret;
 			error("failed to write extent buffer at %llu: %m",
-				eb->start);
+			      start);
 			return ret;
 		}
 		break;
@@ -928,7 +929,7 @@ static int corrupt_metadata_block(struct btrfs_fs_info *fs_info, u64 block,
 		{
 		struct btrfs_trans_handle *trans;
 		struct btrfs_root *root;
-		struct btrfs_path *path;
+		BTRFS_PATH_AUTO_FREE(path);
 		struct btrfs_key key, root_key;
 		u64 root_objectid;
 		u8 level;
@@ -947,7 +948,7 @@ static int corrupt_metadata_block(struct btrfs_fs_info *fs_info, u64 block,
 
 		root = btrfs_read_fs_root(fs_info, &root_key);
 		if (IS_ERR(root)) {
-			error("couldn't find owner root %llu", key.objectid);
+			error("couldn't find owner root %llu", root_key.objectid);
 			return PTR_ERR(root);
 		}
 
@@ -957,7 +958,6 @@ static int corrupt_metadata_block(struct btrfs_fs_info *fs_info, u64 block,
 
 		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans)) {
-			btrfs_free_path(path);
 			ret = PTR_ERR(trans);
 			errno = -ret;
 			error_msg(ERROR_MSG_START_TRANS, "%m");
@@ -968,14 +968,17 @@ static int corrupt_metadata_block(struct btrfs_fs_info *fs_info, u64 block,
 		ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 		if (ret < 0) {
 			error("error searching to node %d", ret);
-			btrfs_free_path(path);
 			btrfs_abort_transaction(trans, ret);
 			return ret;
 		}
-		eb = path->nodes[level];
 		shift_items(root, path->nodes[level]);
 		btrfs_mark_buffer_dirty(path->nodes[level]);
-		btrfs_commit_transaction(trans, root);
+		btrfs_release_path(path);
+		ret = btrfs_commit_transaction(trans, root);
+		if (ret < 0) {
+			errno = -ret;
+			error_msg(ERROR_MSG_COMMIT_TRANS, "%m");
+		}
 		break;
 		}
 	default:
@@ -1502,7 +1505,7 @@ int main(int argc, char **argv)
 	}
 	if (chunk_rec) {
 		struct btrfs_trans_handle *trans;
-		struct btrfs_path *path;
+		BTRFS_PATH_AUTO_FREE(path);
 		int del;
 
 		if (logical == (u64)-1)
@@ -1511,21 +1514,30 @@ int main(int argc, char **argv)
 		path = btrfs_alloc_path();
 		if (!path) {
 			error_mem(NULL);
+			ret = -ENOMEM;
 			goto out_close;
 		}
 
 		if (find_chunk_offset(root->fs_info->chunk_root, path,
 				      logical) != 0) {
-			btrfs_free_path(path);
+			ret = -ENOENT;
 			goto out_close;
 		}
 		trans = btrfs_start_transaction(root, 1);
 		BUG_ON(IS_ERR(trans));
 		ret = corrupt_item_nocow(trans, root->fs_info->chunk_root,
 					 path, del);
-		if (ret < 0)
+		btrfs_release_path(path);
+		if (ret < 0) {
 			error("failed to corrupt chunk record");
-		btrfs_commit_transaction(trans, root);
+			btrfs_abort_transaction(trans, ret);
+			goto out_close;
+		}
+		ret = btrfs_commit_transaction(trans, root);
+		if (ret < 0) {
+			errno = -ret;
+			error_msg(ERROR_MSG_COMMIT_TRANS, "%m");
+		}
 		goto out_close;
 	}
 	if (chunk_tree) {
-- 
2.56.0

