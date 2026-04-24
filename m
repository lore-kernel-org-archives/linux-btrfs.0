Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C385A13AF2
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 00:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776992211; cv=none; b=ptPeMZFOlXsADMs19NWvMwG9QCE3Inj3rrKJ9ugrgJpqjdhzntRcA2aQ2yFqoFZlJEQipISOWRJnfuZYGaRqq2JnQSGbBdUdaFKivSDCon3v8ZocvOKNDzdjn4Gdl0ahnhR5xiJbW681fl3dyH5aQXiCL0F5N4LbOc5NpGB8pWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776992211; c=relaxed/simple;
	bh=utUi5swq9eNfZMYRb1VjK6mpOP0Ql4WiUuFWWQsd4c0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Bw99Grj++Bxq5Mv4oG1woyqdSYBIZtmc+/ar1S3ues3RS5xTpQHxQAWeO5UsZ9pNKUjHnjAbxBp0fBrPsK2yWlfPJ9M44COiUcC79wbLnqW2n6mAPBMlARAhQzr2kwBj/WzijStkZeCGR3+ONefwML1f8oVDlK8HbIXSgq3CyeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ceizVEfF; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ceizVEfF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ceizVEfF";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ceizVEfF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C454E5BCFF
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 00:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776991844; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iogfO+9Cy/NlkAyQlUwub6unJ6j0Hm1cs/qp2WvoBBE=;
	b=ceizVEfFkRj3jBumGcaKraHKqUl+WJsvyFFYirIV2V4G+ARkqOdTs6emrMDX1eS3wiZeca
	iWeOIN6I957S+NBwZwLPNgVN4Ly9kduSmMOClxVMUm75N7LtZ2FNtKhgPtS5M40j87denV
	PKnWhKuY44zYLa1PRB61qu2cUpudXzs=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776991844; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iogfO+9Cy/NlkAyQlUwub6unJ6j0Hm1cs/qp2WvoBBE=;
	b=ceizVEfFkRj3jBumGcaKraHKqUl+WJsvyFFYirIV2V4G+ARkqOdTs6emrMDX1eS3wiZeca
	iWeOIN6I957S+NBwZwLPNgVN4Ly9kduSmMOClxVMUm75N7LtZ2FNtKhgPtS5M40j87denV
	PKnWhKuY44zYLa1PRB61qu2cUpudXzs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C055C593AE
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 00:50:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xyIpG2O+6mnyTQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 00:50:43 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: move larger data folios out of experimental features
Date: Fri, 24 Apr 2026 10:20:25 +0930
Message-ID: <1cd9bec514234044fa75a5e1e73575f854331508.1776991780.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.19)[-0.957];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
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
X-Spam-Flag: NO
X-Spam-Score: -2.79
X-Spam-Level: 
Message-ID: <20260424005025.Kqhh1MqnKL1oalmqhrBBaicdTcdoF4JSLsO2qzMK2Ro@z>

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

