Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9565344056
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Mar 2026 22:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773094800; cv=none; b=d4QO3wBjvfEnKGP3IkM4HoPqdpRFJ8eTrH9OL4GPL/vyQn1D56pJVst41jXmNmdxdCev7QrYqgvOqINrpYtHxskqmDVL1pm23XSNay0w+OnUnBySB8m6A0RPS/X7hVmiqKnmQG/asamJOsh9+pZ3rbzUTe6RPXybZMOWpA2DTWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773094800; c=relaxed/simple;
	bh=t8JdavhmZ+e8t5Vw1I1c/spd+EfOa7DDQI5LUF463gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pd1RptJZTuvqTKC8P5SZiddhhzPB0u/YFd7EzqHZGtU/bquVAX/v4hp0+0tXWmjMZ3XgCiGToh964SSUCg47Wz8JxmF2Jz6CtQ9hu3TF0VU40pwzNZiW85Ym5YxA0g/dSyn9pa7uvVUx10s9MzT287tL1UfRStjEy+4j3Q4LelE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uY1UYAH4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uY1UYAH4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uY1UYAH4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uY1UYAH4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C91E65BEA6;
	Mon,  9 Mar 2026 22:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773094796; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MPPU2nlCwJISad9hkmW5pHa+l4k6EbgZy+MeaKvaVLM=;
	b=uY1UYAH4KNk+Gzrd+Ei4136ODpGuSIpIdJDapByg+v6y9pDaWD+oYtb/dF67o5OewKuoQK
	bzSjZ4qkERzDCI4yreT19Ccmzm6D6AYgE3+biFOp3OuFnlJLy9JGjzfg7/lISsV8BDICPf
	W8GwaGmChkUckBN9/6wwsG+fd8pky2A=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=uY1UYAH4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773094796; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MPPU2nlCwJISad9hkmW5pHa+l4k6EbgZy+MeaKvaVLM=;
	b=uY1UYAH4KNk+Gzrd+Ei4136ODpGuSIpIdJDapByg+v6y9pDaWD+oYtb/dF67o5OewKuoQK
	bzSjZ4qkERzDCI4yreT19Ccmzm6D6AYgE3+biFOp3OuFnlJLy9JGjzfg7/lISsV8BDICPf
	W8GwaGmChkUckBN9/6wwsG+fd8pky2A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BC7803F11A;
	Mon,  9 Mar 2026 22:19:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eDS3HotHr2n6LQAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 09 Mar 2026 22:19:55 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: gality369@gmail.com
Subject: [PATCH 2/2] btrfs: tree-checker: introduce checks for FREE_SPACE_EXTENT
Date: Tue, 10 Mar 2026 08:49:26 +1030
Message-ID: <b47f690386fd086fad526c9991cca25479e9df27.1773094579.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773094579.git.wqu@suse.com>
References: <cover.1773094579.git.wqu@suse.com>
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
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FREEMAIL_CC(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C91E65BEA6

Introduce FREE_SPACE_EXTENT checks, which include:

- The key alignment check
  The objectid is the logical bytenr of the free space, and offset is the
  length of the free space, thus they should all be aligned to the fs
  block size.

- The item size check
  The FREE_SPACE_EXTENT item has zero size.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 980e4d52061f..15810902c813 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1970,6 +1970,28 @@ static int check_free_space_info(struct extent_buffer *leaf, struct btrfs_key *k
 	return 0;
 }
 
+static int check_free_space_extent(struct extent_buffer *leaf, struct btrfs_key *key,
+				   int slot)
+{
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
+	const u32 blocksize = fs_info->sectorsize;
+
+	if (unlikely(!IS_ALIGNED(key->objectid, blocksize) ||
+		     !IS_ALIGNED(key->offset, blocksize))) {
+		generic_err(leaf, slot,
+		"free space extent key range is not aligned to %u, has (%llu %u %llu)",
+			    blocksize, key->objectid, key->type, key->offset);
+		return -EUCLEAN;
+	}
+	if (unlikely(btrfs_item_size(leaf, slot) != 0)) {
+		generic_err(leaf, slot,
+		"invalid item size for free space info, has %u expect 0",
+			    btrfs_item_size(leaf, slot));
+		return -EUCLEAN;
+	}
+	return 0;
+}
+
 /*
  * Common point to switch the item-specific validation.
  */
@@ -2036,6 +2058,9 @@ static enum btrfs_tree_block_status check_leaf_item(struct extent_buffer *leaf,
 	case BTRFS_FREE_SPACE_INFO_KEY:
 		ret = check_free_space_info(leaf, key, slot);
 		break;
+	case BTRFS_FREE_SPACE_EXTENT_KEY:
+		ret = check_free_space_extent(leaf, key, slot);
+		break;
 	}
 
 	if (unlikely(ret))
-- 
2.53.0

