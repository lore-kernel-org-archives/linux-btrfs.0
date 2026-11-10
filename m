Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349808;
	b=R+qhpleGAAOG9Hvw5p4/QXY6ulLu+SpYbf2K/04KDQWEv5dbaqmacm244oDV2Rl2IKS4
	 wWpmfpZeBFpOU772gnrRcBV/JwPOCfAoJE5LhA1Bjo6IeON3wnK+36WdBtv1tyYKQj5JT
	 iEqL+8MMIbblPcTGFTMNuQMLCImRU+XdkyGTi8XeIBeLgtjgNrBbeiMaBJ9CHVz+04BVv
	 Q2B0K9LNxpK73BfLyx8JWYLUBfDimJLv0nKkzFAGPMZkhxhQNAmcYeK6+IwD8+q2VLTwp
	 rtvS6IMv/DBOhVAjZ2bgB54aY6G97ZAw/AAdL5r93WC8sYgoI03bZhQJzLzzOu2KpmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349808;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=gKvh92UhlmEgOEXDHsoH1jJQbD7sSaIS6QnAtbcg7EA=;
	b=0WmtXI+yGfheZkMr4btkejZ5+xIdJHuZnOulLfuK4KW17wYCe0S/AeV0mJoAz6yM/peh
	 M5CHKF1Z6LgCh9RrX0IRO6FyrCy3wNtJeKcHzw7jOOyLGPHH0ATRsvJMhpZtI0HyqbIhE
	 lzFMnDAroScZWuT0YeBsj+TPX5v4VERFw8/SxVY0t2H/iV/HXdKmvGUc47fnejc44fpLu
	 nTe+fhAd+pGk+850glKMcSJl8KDRx88pBd8sTxfoGCUtt+e/+juuEfJ8bOvTn57VTg9tO
	 Hk4BSl80B2RefjYSg7R7AU81WKen0Ttyj7kGMlh6+oCGgDiYLXDNI99cMhjgBFvMqeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=F0jy2+r4;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=F0jy2+r4;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D5A606A335
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 22:30:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31D5A606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=F0jy2+r4;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=F0jy2+r4
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3897521EEF;
	Tue, 10 Nov 2026 22:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794349806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gKvh92UhlmEgOEXDHsoH1jJQbD7sSaIS6QnAtbcg7EA=;
	b=F0jy2+r4vvsNRP1oDLsstgbtF+ZywY/Av4Wyd70CrdtGnl5EVPmHiloAUQePMdFYxEWF/i
	IiSotdA3qgVkArNyMRtlCPqZ3KebuEMCsLebUB+kYtDZFxm9JOcJjbb+7TDO3wX/TQph0k
	9C2+OH7B3N4nZ/Mae470+ksOYHkrwl8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=F0jy2+r4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794349806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gKvh92UhlmEgOEXDHsoH1jJQbD7sSaIS6QnAtbcg7EA=;
	b=F0jy2+r4vvsNRP1oDLsstgbtF+ZywY/Av4Wyd70CrdtGnl5EVPmHiloAUQePMdFYxEWF/i
	IiSotdA3qgVkArNyMRtlCPqZ3KebuEMCsLebUB+kYtDZFxm9JOcJjbb+7TDO3wX/TQph0k
	9C2+OH7B3N4nZ/Mae470+ksOYHkrwl8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B20F613693;
	Tue, 10 Nov 2026 22:30:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xcMcGuua82rVCgAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 10 Nov 2026 22:30:03 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Noah Weinberger <NoahWeinberger2003@proton.me>
Subject: [PATCH] btrfs: tree-checker: validate qgroup info and limit items
Date: Wed, 11 Nov 2026 08:59:45 +1030
Message-ID: <6e59a1f7c6493ec2aed4d01d8ee67acb1ae60588.1794349782.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,proton.me:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 3897521EEF

Add tree-checker entries for them. Both items check:

- The key objectid must be 0
  They are always created with (0, QGROUP_INFO/QGROUP_LIMIT, qgroupid),
  the qgroup id is stored in the key offset.

- The item size must be exactly the size of the item structure
  The items are always inserted with that size and there is no extension
  of the structures.

For the qgroup info item there is one more check:

- The generation must not exceed the super block generation + 1

All of them are always satisfied by items created by the kernel, so there
is no compatibility concern.

The limit flags and values are not checked intentionally, the reasons are:

- The kernel has no runtime rejection for invalid limit flags
  So some one can use qgroup inherit to intentionally pass some invalid
  values. If we apply strict checks before runtime validation, this can
  easily flips the fs RO, causing a DoS attack.

- The mkfs.btrfs is generating garbage for limit item
  Because we didn't zero the limit item, all kinds of garbage can be
  there if using "mkfs.btrfs -O quota".
  That will be fixed, but we can not reject such fses yet.

Reported-by: Noah Weinberger <NoahWeinberger2003@proton.me>
Link: https://lore.kernel.org/linux-btrfs/B_lvw-WNI1mnHnK011Sfk_ZNaL0eg5uOfD2T3q-vOfWv8426VwPA4NPpWaAcHxRZf3OrzGzwZjckHqKEKUS7UQJk6TEN_7xD1SkwM5q8hsw=@proton.me/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 59 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index f021ac14babf..5f1c7622f07a 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -2117,6 +2117,59 @@ static int check_qgroup_status_item(const struct extent_buffer *leaf, int slot)
 	return 0;
 }
 
+static int check_qgroup_info_item(const struct extent_buffer *leaf,
+				  const struct btrfs_key *key, int slot)
+{
+	const u32 item_size = btrfs_item_size(leaf, slot);
+	const u64 super_gen = btrfs_super_generation(leaf->fs_info->super_copy);
+	struct btrfs_qgroup_info_item *ptr;
+	u64 generation;
+
+	if (unlikely(key->objectid != 0)) {
+		generic_err(leaf, slot,
+		"invalid key objectid for qgroup info item, have %llu expect 0",
+			    key->objectid);
+		return -EUCLEAN;
+	}
+	if (unlikely(item_size != sizeof(struct btrfs_qgroup_info_item))) {
+		generic_err(leaf, slot,
+		"invalid item size for qgroup info item, have %u expect %zu",
+			    item_size, sizeof(struct btrfs_qgroup_info_item));
+		return -EUCLEAN;
+	}
+
+	ptr = btrfs_item_ptr(leaf, slot, struct btrfs_qgroup_info_item);
+	/* Use super block generation + 1 to cover the transaction being committed. */
+	generation = btrfs_qgroup_info_generation(leaf, ptr);
+	if (unlikely(generation > super_gen + 1)) {
+		generic_err(leaf, slot,
+		"invalid qgroup info generation, have %llu expect no more than %llu",
+			    generation, super_gen + 1);
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
+static int check_qgroup_limit_item(const struct extent_buffer *leaf,
+				   const struct btrfs_key *key, int slot)
+{
+	const u32 item_size = btrfs_item_size(leaf, slot);
+
+	if (unlikely(key->objectid != 0)) {
+		generic_err(leaf, slot,
+		"invalid key objectid for qgroup limit item, have %llu expect 0",
+			    key->objectid);
+		return -EUCLEAN;
+	}
+	if (unlikely(item_size != sizeof(struct btrfs_qgroup_limit_item))) {
+		generic_err(leaf, slot,
+		"invalid item size for qgroup limit item, have %u expect %zu",
+			    item_size, sizeof(struct btrfs_qgroup_limit_item));
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 static int check_remap_key(const struct extent_buffer *leaf,
 			   const struct btrfs_key *key, int slot)
 {
@@ -2512,6 +2565,12 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_QGROUP_STATUS_KEY:
 		ret = check_qgroup_status_item(leaf, slot);
 		break;
+	case BTRFS_QGROUP_INFO_KEY:
+		ret = check_qgroup_info_item(leaf, key, slot);
+		break;
+	case BTRFS_QGROUP_LIMIT_KEY:
+		ret = check_qgroup_limit_item(leaf, key, slot);
+		break;
 	case BTRFS_IDENTITY_REMAP_KEY:
 	case BTRFS_REMAP_KEY:
 	case BTRFS_REMAP_BACKREF_KEY:
-- 
2.56.0

