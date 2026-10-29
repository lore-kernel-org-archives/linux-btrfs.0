Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793267207;
	b=16+4KqguGeum47y5ebdkWP39eH9XcwOM8BDMVJCWnK1mQUyM31iOnM8TJNq5vhzq5Yjw
	 wPhWO+QXm165yI829cswRVOILV4n6eIIFhKntL8MLWLZTJyxVN64UO+G9sGh1BHUuYYaO
	 1PtQYNXNcC0SohQbkNgrMshN+8Z6lflU04mvJznkRGJQbNasxGn38TOVfuckvrXlr2ZeM
	 JJM/ufTd74eXFAiXZ59ClFAMlrsEp9lo5qhpCSn6DYSuJtE6DOAf+BSPuuRw8aAazukOl
	 XEsPH2DTW+GeHeqO+oiCnmvsnTU8wuYULd5qWY9NWcke4Ri/dFKD5m7KjvI/v3xaS+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267207;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=HNvLzo95Eww4HJyeriViD5/YrjMc3XMW5/jWDyLYhuU=;
	b=YmKeanu5duwm4CK7hUtKIlg2RCReBPMq2sH46IcO5Um6/Z3LChTNU2s+h4OyqEwzGayB
	 Y+LNckrh3t7HSeCqUgJ0bXDCkuNtOkeW0Y8zZexBBQkA0NZRxtnq23n/Zsg66N1QkCINC
	 V9F5lF11GeiomRC26TurBPh+ZgoMYOUubie4+JDp8syNJouU/plUJecmjzoWmZKkPmDkE
	 rEjMjNtB7kmCsv4u9KCree0qOIN5W+WYX/W1NPEKdnI/f/E3KfAhs7NdIUb2WayuK86NO
	 JGi7OHZe2ZIIoTyiMT1oRXw7MFUTRaddDSHDmjUHtegGKySjd6wLs1LQDQF4vIol/XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=DkEjiB3n;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=DkEjiB3n;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C013606A31D
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C013606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=DkEjiB3n;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=DkEjiB3n
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8BE011FB41
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793267205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HNvLzo95Eww4HJyeriViD5/YrjMc3XMW5/jWDyLYhuU=;
	b=DkEjiB3nLr7Z57krMQLqNAFMR5VM6pTtCB1LCuMfh4BLAvVwklYOyp003a2dczoSO6W6Wq
	dcgPPyjvMilZdQx2BUkrVLguwWaVMyBfdrxIKAqIYaPX3c5YlXQPF8en9DqQky9ZlxU5ox
	3gR86+PWiTpiN/duoSIYvTLcALlqKOY=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=DkEjiB3n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793267205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HNvLzo95Eww4HJyeriViD5/YrjMc3XMW5/jWDyLYhuU=;
	b=DkEjiB3nLr7Z57krMQLqNAFMR5VM6pTtCB1LCuMfh4BLAvVwklYOyp003a2dczoSO6W6Wq
	dcgPPyjvMilZdQx2BUkrVLguwWaVMyBfdrxIKAqIYaPX3c5YlXQPF8en9DqQky9ZlxU5ox
	3gR86+PWiTpiN/duoSIYvTLcALlqKOY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 76FFF13419
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fpy8FP0V42o+FwAAD6G6ig:T5
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] btrfs-progs: fix a path leak in alloc_reserved_tree_block()
Date: Thu, 29 Oct 2026 20:16:14 +1030
Message-ID: <37f68586fb0ecc7eb144d8cf6441fe6a7f7388e6.1793266694.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793266694.git.wqu@suse.com>
References: <cover.1793266694.git.wqu@suse.com>
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 8BE011FB41

If btrfs_insert_empty_item() failed with -EEXIST, the path is not
released by btrfs_insert_empty_item().

But the function returns without freeing @path, causing a leak.

This function has lagged behind kernel quite some, so here I just fix
the path leak by utilizing BTRFS_PATH_AUTO_FREE() inside the if ()
branch.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shared/extent-tree.c b/kernel-shared/extent-tree.c
index 64479e6e43f1..bac44654eab8 100644
--- a/kernel-shared/extent-tree.c
+++ b/kernel-shared/extent-tree.c
@@ -2403,7 +2403,6 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	struct btrfs_extent_inline_ref *iref;
 	struct btrfs_space_info *sinfo;
 	struct extent_buffer *leaf;
-	struct btrfs_path *path;
 	struct btrfs_key ins;
 	u32 size = sizeof(*extent_item) + sizeof(*iref);
 	u64 start, end;
@@ -2415,6 +2414,8 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	ins.objectid = node->bytenr;
 
 	if (ref->root != BTRFS_REMAP_TREE_OBJECTID) {
+		BTRFS_PATH_AUTO_FREE(path);
+
 		if (skinny_metadata) {
 			ins.type = BTRFS_METADATA_ITEM_KEY;
 			ins.offset = ref->level;
@@ -2462,7 +2463,6 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 		btrfs_set_extent_inline_ref_offset(leaf, iref, ref->root);
 
 		btrfs_mark_buffer_dirty(leaf);
-		btrfs_free_path(path);
 	}
 
 	ret = remove_from_free_space_tree(trans, ins.objectid, fs_info->nodesize);
-- 
2.56.0

