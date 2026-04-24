Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E021CEADB
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 00:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776992017; cv=none; b=aMNrkMqvZABaIurZEPnAQKGRVLJlkWy5XlrU7cIyt9LrK5Sa0jyFUcZKd431fnE+bHF//0KY0gzyXhHpDnt5nTK1/uwmCRXBURoiaO2J/rSLk9hy1FGDGzvqcnWMks1TnDsmyva4+wTaISPSYi/sQCuOP4iYbXpIAr5oKqfYrX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776992017; c=relaxed/simple;
	bh=utUi5swq9eNfZMYRb1VjK6mpOP0Ql4WiUuFWWQsd4c0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=E1dB65wD2yWHOfz0Q45zI5wwyPCPF+WjLtFDwoAAh/URlzAOeZvCFEIbrVV+rP2fkP1ID4MNjinpVUMt6PwNM4RCNHeEmEg0TfNyMqaAXpP3J/E6JntN+jcXXCwyaaDpHkoDhk06ZZ/nfvHBX3rZ6RW3QfQX00gH6PiMqp5SYis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HP82iDky; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HP82iDky; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HP82iDky";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HP82iDky"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 72B665BCED
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 00:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776992013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iogfO+9Cy/NlkAyQlUwub6unJ6j0Hm1cs/qp2WvoBBE=;
	b=HP82iDkyhj8hEyRaw0xx/2YcQupHz93CEKB9vJO3lO32b2dSM7vlk2gqN96gFw7FhSE7v1
	w6NcZOPrygNkPlA2mokhC/0eWUKCxrADAoUHuaDIgf3ghbbBxWWVNG9eyXncvlgfB+tN2S
	e4vOpechrVVOHPW51FcGvCPKhyik/xg=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=HP82iDky
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776992013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iogfO+9Cy/NlkAyQlUwub6unJ6j0Hm1cs/qp2WvoBBE=;
	b=HP82iDkyhj8hEyRaw0xx/2YcQupHz93CEKB9vJO3lO32b2dSM7vlk2gqN96gFw7FhSE7v1
	w6NcZOPrygNkPlA2mokhC/0eWUKCxrADAoUHuaDIgf3ghbbBxWWVNG9eyXncvlgfB+tN2S
	e4vOpechrVVOHPW51FcGvCPKhyik/xg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74C4E593AE
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 00:53:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HU0rCQy/6mlEUAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 00:53:32 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: move larger data folios out of experimental features
Date: Fri, 24 Apr 2026 10:23:13 +0930
Message-ID: <1cd9bec514234044fa75a5e1e73575f854331508.1776991780.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
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
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 72B665BCED

This feature was introduced in v6.17 under experimental, and we had
several small bugs related to or exposed by that feature:

 e9e3b22ddfa7 ("btrfs: fix beyond-EOF write handling")
 18de34daa7c6 ("btrfs: truncate ordered extent when skipping writeback past i_size")

Otherwise, the feature has been frequently tested by btrfs developers.

The latest fix only arrived in v6.19. After three releases, I think it's time
to move this feature out of experimental.

And since we're here, also remove the comment about the bitmap size
limit, which is no longer relevant in the context, and will soon be
outdated for the incoming huge folio support.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Fix the defrag failure
  As the defrag support for large folios is also under experimental,
  we need to update that part too.
---
 fs/btrfs/Kconfig       |  2 +-
 fs/btrfs/btrfs_inode.h |  3 ---
 fs/btrfs/defrag.c      | 17 -----------------
 3 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 5d785d010971..694b9489f7e0 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -106,7 +106,7 @@ config BTRFS_EXPERIMENTAL
 
 	  - extent tree v2 - complex rework of extent tracking
 
-	  - large folio and block size (> page size) support
+	  - block size (> page size) support
 
 	  - asynchronous checksum generation for data writes
 
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index a3fcb29e5e59..28281b01688b 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -543,12 +543,9 @@ static inline void btrfs_set_inode_mapping_order(struct btrfs_inode *inode)
 	/* Metadata inode should not reach here. */
 	ASSERT(is_data_inode(inode));
 
-	/* We only allow BITS_PER_LONGS blocks for each bitmap. */
-#ifdef CONFIG_BTRFS_EXPERIMENTAL
 	mapping_set_folio_order_range(inode->vfs_inode.i_mapping,
 				      inode->root->fs_info->block_min_order,
 				      inode->root->fs_info->block_max_order);
-#endif
 }
 
 void btrfs_calculate_block_csum_folio(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index af40ad62009a..f0c6758b7055 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -859,23 +859,6 @@ static struct folio *defrag_prepare_one_folio(struct btrfs_inode *inode, pgoff_t
 	if (IS_ERR(folio))
 		return folio;
 
-	/*
-	 * Since we can defragment files opened read-only, we can encounter
-	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
-	 *
-	 * The IO for such large folios is not fully tested, thus return
-	 * an error to reject such folios unless it's an experimental build.
-	 *
-	 * Filesystem transparent huge pages are typically only used for
-	 * executables that explicitly enable them, so this isn't very
-	 * restrictive.
-	 */
-	if (!IS_ENABLED(CONFIG_BTRFS_EXPERIMENTAL) && folio_test_large(folio)) {
-		folio_unlock(folio);
-		folio_put(folio);
-		return ERR_PTR(-ETXTBSY);
-	}
-
 	ret = set_folio_extent_mapped(folio);
 	if (ret < 0) {
 		folio_unlock(folio);
-- 
2.53.0

