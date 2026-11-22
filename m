Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795385590;
	b=YjgY/BCyhlOyuVjvNIEJmpeFtPwwqp1y4wa5kCbh0rtEBjyD4Cs9mF91bsBsRJDsG44f
	 YtXGcMPiB0gveCfCffJ+VeqwXgVX+p1KrCxFh+0hlNvAoQ7Q0iiqBbdMtRow3G0lF4Vsb
	 kQvC/6VCMUV5r8ov95ZDuTkk4YqfR1N+iOZIhbITQeA4seN//N6dER7Ds83hwNJefKy1/
	 JiwWI7SiRMoF+SzmtWk6oC7/GpV6O67huhDhz87ttOhKsXgLTclZCQJ1/Hu7SgkA0EEBd
	 wl+J9PWfjWuKNStI6zKY+BEaCdNSsoA3CaXgNLT/IryyAhxp2PY5BxOxharlds4sVkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795385590;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=3Z40jRB2yovCJMIP73Hl9CJym6m4Mp2kYkCEEFzVCj4=;
	b=oBTpRim4GvkotFCGGiM1BUcYvGX2z4+4m/iG7dbQnvoIiH8zft4oH5356/w/iM1fpdtu
	 ydrEjbXVJxVUS6Zp7sXgR18Re+T3lJTtSZmUQY5Gghb0+HYtQktlG1OuDHhVjFTwcTE9O
	 hN6P2p0eNSz95HiP48itRSkPEswy6bKyEf5BGxF7qBcIM99FlOuaT9/TZT3iIyloRsgyU
	 gyoMgfhqzijb0ifwat8WFZ0mD53M+ZGqzN5fEXcjHHo26Enml84wcj2jV0VLhpKkUAASs
	 eU09Py0sppZl1yhJ8jbgjqfItHIw1hsVHeqDVoBu3AqUrXMZcwe2F8Pyn/YgHWlLPaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=rN4z8Alv;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=eBQWh0Bm;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A9B606A31A
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 22:13:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5A9B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=rN4z8Alv;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=eBQWh0Bm
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D919322174
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 22:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795385588; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3Z40jRB2yovCJMIP73Hl9CJym6m4Mp2kYkCEEFzVCj4=;
	b=rN4z8AlvSHGv0VTJbos/4jiedNCApzRc0xrJK2ZqpCCcbRjPv8PxrLRMy/IP7Ugq2fiz4i
	RAGkFWfqk1FGAYCXJaT/xWpJnGF11zGQpnTPwX1vgxWE264pGbkxSkx/xy6w2yUP/g4IPl
	qI7s6xCYpcoN2OHz81dLQiHeBu4zua4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795385587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3Z40jRB2yovCJMIP73Hl9CJym6m4Mp2kYkCEEFzVCj4=;
	b=eBQWh0BmZXNOwdNKd/ycI8e5Xk/DirnDom1rquFzterKRO2NHTnqZMfCHPMXF5iqKIV8kD
	6LjJfzRlxoB5+9YMFc7uFIpZeej06/RjxWVp+DXQ9OtQh9WQtjeBzSi7kWfncT+s4cJ01E
	MsuUWPyCzfIgKX3auhH7pf84pwj6hcM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 505401342D
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 22:13:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id D1RUGfFoA2suEQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 22:13:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove btrfs_is_free_space_inode()
Date: Mon, 23 Nov 2026 08:42:44 +1030
Message-ID: <4d3a1d10aff29e6b65ee681cbd7e82e306e69d6e.1795385532.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

Since we have disabled v1 space cache, there is no need to maintain that
function.

Remove it along with the BTRFS_INODE_FREE_SPACE_INODE flag.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/btrfs_inode.h |  7 -------
 fs/btrfs/inode.c       | 19 +++----------------
 2 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index fbcf8ca05fb7..5ffe89279f15 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -85,8 +85,6 @@ enum {
 	 * on the same file.
 	 */
 	BTRFS_INODE_VERITY_IN_PROGRESS,
-	/* Set when this inode is a free space inode. */
-	BTRFS_INODE_FREE_SPACE_INODE,
 	/* Set when there are no capabilities in XATTs for the inode. */
 	BTRFS_INODE_NO_CAP_XATTR,
 	/*
@@ -394,11 +392,6 @@ static inline void btrfs_i_size_write(struct btrfs_inode *inode, u64 size)
 	inode->disk_i_size = size;
 }
 
-static inline bool btrfs_is_free_space_inode(const struct btrfs_inode *inode)
-{
-	return test_bit(BTRFS_INODE_FREE_SPACE_INODE, &inode->runtime_flags);
-}
-
 static inline bool is_data_inode(const struct btrfs_inode *inode)
 {
 	return btrfs_ino(inode) != BTRFS_BTREE_INODE_OBJECTID;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 40dd87276cc9..47d5da483d11 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3930,8 +3930,6 @@ static int btrfs_init_file_extent_tree(struct btrfs_inode *inode)
 		return 0;
 	if (!S_ISREG(inode->vfs_inode.i_mode))
 		return 0;
-	if (btrfs_is_free_space_inode(inode))
-		return 0;
 
 	inode->file_extent_tree = kmalloc_obj(struct extent_io_tree);
 	if (!inode->file_extent_tree)
@@ -4287,14 +4285,9 @@ int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	int ret;
 
 	/*
-	 * If the inode is a free space inode, we can deadlock during commit
-	 * if we put it into the delayed code.
-	 *
-	 * The data relocation inode should also be directly updated
-	 * without delay
+	 * The data relocation inode should be directly updated without delay.
 	 */
-	if (!btrfs_is_free_space_inode(inode)
-	    && !btrfs_is_data_reloc_root(root)
+	if (!btrfs_is_data_reloc_root(root)
 	    && !test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags)) {
 		btrfs_update_root_times(trans, root);
 
@@ -5602,8 +5595,7 @@ void btrfs_evict_inode(struct inode *inode)
 
 	if (inode->i_nlink &&
 	    ((btrfs_root_refs(&root->root_item) != 0 &&
-	      btrfs_root_id(root) != BTRFS_ROOT_TREE_OBJECTID) ||
-	     btrfs_is_free_space_inode(BTRFS_I(inode))))
+	      btrfs_root_id(root) != BTRFS_ROOT_TREE_OBJECTID)))
 		goto out;
 
 	if (is_bad_inode(inode))
@@ -5872,11 +5864,6 @@ static int btrfs_init_locked_inode(struct inode *inode, void *p)
 
 	btrfs_set_inode_number(BTRFS_I(inode), args->ino);
 	BTRFS_I(inode)->root = btrfs_grab_root(args->root);
-
-	if (args->root && args->root == args->root->fs_info->tree_root &&
-	    args->ino != BTRFS_BTREE_INODE_OBJECTID)
-		set_bit(BTRFS_INODE_FREE_SPACE_INODE,
-			&BTRFS_I(inode)->runtime_flags);
 	return 0;
 }
 
-- 
2.56.1

