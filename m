Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808AE1A682E
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 04:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786680336; cv=none; b=AhjFyxOdz0Ky0RFEvUNlJ7H76m2iQP9YjeUJ06n3BtToyBVSxC3nmJgU4Ftcl6Bufe4O1VC7jxkyRlxc+siASYbfFbOzRaaQRldfzESL2lMrPSUTKnYrSgn6Ew586teQ99oCxUR8vimt09FO2ldcZ4q7D08Fq7g9I7mWNsrbpoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786680336; c=relaxed/simple;
	bh=zeMMYkplPsBcyJKpLZMtrSt/v/5zPV5NIU/WkWZiqys=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=KYvCHr64fIRFh7hmEgNkmr7Q6+dQBgBGhpOLHS8lc3uhKqzcz3vT2FDoO6NC2mMc6RZEx6C8fSPk1tpEbY/wXwg8Pga9gdiR/Ne1uJDEMfLsXBrz7tOFCjak4EXXMIVPShPVdDdR6yQwQ+RAcNdF7eUm4sgl2l5XMO7xZAZSGtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bHGOphbv; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=auKiZJwi; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bHGOphbv";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="auKiZJwi"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5E79E82C2D
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 04:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786680328; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=M0BiGXkm8I2owFtHdXgoPDczhzlh6RKwTuzScGvr/yA=;
	b=bHGOphbv1Q3RFHapQfmJbDI7Vqy9JRf2T5boO4i0utSIRxWzaixzfCH67cHj4d+LSllT8c
	J2heqyt9lBLMhYDPdKHsJ5cF4MfPYsdb5U2DqQJ73e/q6r106pdCXwGqlDQFUbWmhyqOz8
	JTmk9MV3FA1zKbKAU/DreXxPCE0ahIw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786680324; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=M0BiGXkm8I2owFtHdXgoPDczhzlh6RKwTuzScGvr/yA=;
	b=auKiZJwi5C3BXl9F6UzmE3CJHk8grStx0BWk1JlCuodmnbz/dxRe5Ao7LCq0VFkad62KTU
	LVj79fXGP9a8Cowmjt/jNgYN02f4C9IKvQQZfGwT9SOseYt7D0VLq9l78wrxA2DQnOig+i
	mCjb1O3s8OD3SRz8ccalHi7l4zN9NDM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7EF8F781A0
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 04:05:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2InxDQOUfmo4PwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 04:05:23 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: do not insert dir index if there is a conflicting dir item name
Date: Fri, 14 Aug 2026 13:35:05 +0930
Message-ID: <3cc8583892db7e3d03c0e252a31a8b0565ae2d30.1786680299.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

Inside btrfs_insert_dir_item(), if we hit an -EEXIST error from
insert_with_overflow(), we continue to second_insert label, which will
insert the corresponding dir index.

However insert_with_overflow() does not return -EEXIST just because there
is a hash conflict, but only when there is a completely same name in the
existing dir item.

So when we got -EEXIST insert_with_overflow(), it really means there is
an conflicting name, and we should not continue.

If we continue to the second_insert label, we will create another dir
index for an existing name, which will corrupt the fs.

For the existing callers, the btrfs_add_link() is already properly
handling the -EEXIST error without aborting (unless the inode ref is
unable to be reverted).

The only call site that aborts is from create_pending_snapshot(), but
that's the expected behavior as we have no way to revert the created
subvolume.

This bug is reported by Sashiko while reviewing a patch touching code
around the offending location.
But since it's an existing bug, it's not shown in the summary page.

Link: https://sashiko.dev/#/patchset/20260811-btrfs-enomem-v3-0-46a993fc3fe5%40kernel.org
Fixes: e06afa839e72 ("Btrfs: rename")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/dir-item.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 30ddafaf8d3d..a6bd69be522b 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -149,8 +149,6 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 					name->name, name->len);
 	if (IS_ERR(dir_item)) {
 		ret = PTR_ERR(dir_item);
-		if (ret == -EEXIST)
-			goto second_insert;
 		goto out_free_prealloc;
 	}
 
@@ -167,7 +165,6 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 
 	write_extent_buffer(leaf, name->name, name_ptr, name->len);
 
-second_insert:
 	if (!need_delayed_index) {
 		ret = 0;
 		goto out_free_prealloc;
-- 
2.54.0

