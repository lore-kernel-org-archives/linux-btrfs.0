Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055B1368971
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 02:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772160390; cv=none; b=cnnBWCXfHWFr5t59scV8RQ86qTC0wSnkkUm6LqwUUaAUXnERh/gdj/pu8fhQWB99Zxniwj7kPqR+lnbgCz8U45+umtr/gRdhG6dU1uJJLBq1m+UsfSjYzF7LIjftTaue73rOju8p9JuiiU2KVQ+weGNM+8ZcIigWMPSrmZIKl5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772160390; c=relaxed/simple;
	bh=AvUbtZw6PNLcfuLCR4sD/9NJmM0QfdbkWQuClV3FQy8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=renorCsrRya7QdBFAARs/msSByQlFjqxhYDNZ0Vi09Nkl5bkHVpCIYOLs6FSalWBtMRE9FdFjSYPV6PcBhEOHowYyqnbRn+opebpQanHSjQcnumeguGn+UsWGDxLx1Ei/zIdPxARlu9JU1nRjrmGP6OuqNA87mfjlANJ424h4WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RY/BZzzh; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OYrUsj9d; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RY/BZzzh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OYrUsj9d"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E6B663F866
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 02:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772160387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wZxD3U6L9HUSPRvtTifxP2xSm5GgSMOXwQK7bo6L4uQ=;
	b=RY/BZzzhz5QGWKN6m0oyazeJdm6mWfSmap7faRutcy+kveCaGQ3BxzxsPr0xY0r+sp+5tZ
	pH/GSZpqwprHXJPUXecyy8Jk2R6HIom6lG6mvX6GqsWPp93w51UmM3RnALiwZFHPsnrzcu
	D81OQPPipovV+5bi4n6NDT0P4KkG1MA=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=OYrUsj9d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772160386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wZxD3U6L9HUSPRvtTifxP2xSm5GgSMOXwQK7bo6L4uQ=;
	b=OYrUsj9dXQjgXX3445uVI/gnnqi3SQJsVvS7+sdcqUelCR8RcreX4Xy5hOAkCBf3bNn1NB
	2m81tI3dRIxdU8A01UCjvTATDtXxG0cH5rRhyQPHCCNLF7/79ulkDzNMEm9lVmomRt2zE6
	kcrAzi34Wmwv9JAXNTeqJHirFqb4WOE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F51F3EA69
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 02:46:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Kk6eOIEFoWnvBQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 02:46:25 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: extract the max compression chunk size into a macro
Date: Fri, 27 Feb 2026 13:15:53 +1030
Message-ID: <fdeb2bf487d20620a0823d30da0b97f9b25dc5a1.1772160339.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E6B663F866

We have two locations using open-coded 512K size, as the async chunk
size.

For compression we have not only the max size a compressed extent can
represent (128K), but also how large an async chunk can be (512K).

Although we have a macro for the maximum compressed extent size, we do
not have any macro for the async chunk size.

Add such macro and replace the two open-coded SZ_512K.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.h | 3 +++
 fs/btrfs/inode.c       | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 84600b284e1e..973530e9ce6c 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -36,6 +36,9 @@ struct btrfs_ordered_extent;
 #define BTRFS_MAX_COMPRESSED_PAGES	(BTRFS_MAX_COMPRESSED / PAGE_SIZE)
 static_assert((BTRFS_MAX_COMPRESSED % PAGE_SIZE) == 0);
 
+/* The max size for a single worker to compress. */
+#define BTRFS_COMPRESSION_CHUNK_SIZE	(SZ_512K)
+
 /* Maximum size of data before compression */
 #define BTRFS_MAX_UNCOMPRESSED		(SZ_128K)
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9148ec4a1d19..acfef903ac8b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1587,7 +1587,7 @@ static bool run_delalloc_compressed(struct btrfs_inode *inode,
 	struct async_cow *ctx;
 	struct async_chunk *async_chunk;
 	unsigned long nr_pages;
-	u64 num_chunks = DIV_ROUND_UP(end - start, SZ_512K);
+	u64 num_chunks = DIV_ROUND_UP(end - start, BTRFS_COMPRESSION_CHUNK_SIZE);
 	int i;
 	unsigned nofs_flag;
 	const blk_opf_t write_flags = wbc_to_write_flags(wbc);
@@ -1604,7 +1604,7 @@ static bool run_delalloc_compressed(struct btrfs_inode *inode,
 	atomic_set(&ctx->num_chunks, num_chunks);
 
 	for (i = 0; i < num_chunks; i++) {
-		u64 cur_end = min(end, start + SZ_512K - 1);
+		u64 cur_end = min(end, start + BTRFS_COMPRESSION_CHUNK_SIZE - 1);
 
 		/*
 		 * igrab is called higher up in the call chain, take only the
-- 
2.53.0

