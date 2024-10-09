Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E29519DF48
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Oct 2024 14:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728484289; cv=none; b=iEOjWFXZVU3R5qcN8dYFpa/03asc+ax99JtCWlD2lxDRf/r9sIjcMVOD2ihxWhulVGz1+IiGoJnNd7Aoh+VOhUFIyn7WqUv048qqF+wF6J9q2C81B6Rw+BejisaXOio5KLRdWPCdJDb9XtSt9LdjUa9NH2FjOWKWJ1dK8DLJARA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728484289; c=relaxed/simple;
	bh=ZgHDO7lLA7SlKku9xqq+ssEKjYykTVjH9++xFYmXCa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKFV3geAfYAfaWY0KtkkeJBd7938PjNsi0CcKazPlk6nVA3cGjjmE4rC5zbpk+eZGZqASnr1Zn6PfzlE3nbY2ZTr2qTbyuHE57JVoyy7CuQbCQ2f+KRgLAadz50XxsemYXzW1wDVRggC80/d4xPy69ad9R5V/GNdRHuLcvCidhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E852D21F7F;
	Wed,  9 Oct 2024 14:31:25 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1CB9136BA;
	Wed,  9 Oct 2024 14:31:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P1weN72TBmcoRQAAD6G6ig
	(envelope-from <dsterba@suse.com>); Wed, 09 Oct 2024 14:31:25 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 12/25] btrfs: lzo: drop unused paramter level from lzo_alloc_workspace()
Date: Wed,  9 Oct 2024 16:31:25 +0200
Message-ID: <36b7ceef129534b9c0bea96b7f1cb1dde4673b43.1728484021.git.dsterba@suse.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <cover.1728484021.git.dsterba@suse.com>
References: <cover.1728484021.git.dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: E852D21F7F
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 

The LZO compression has only one level, we don't need to pass the
parameter.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 2 +-
 fs/btrfs/compression.h | 2 +-
 fs/btrfs/lzo.c         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 6e9c4a5e0d51..655e3212b409 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -746,7 +746,7 @@ static struct list_head *alloc_workspace(int type, unsigned int level)
 	switch (type) {
 	case BTRFS_COMPRESS_NONE: return alloc_heuristic_ws(level);
 	case BTRFS_COMPRESS_ZLIB: return zlib_alloc_workspace(level);
-	case BTRFS_COMPRESS_LZO:  return lzo_alloc_workspace(level);
+	case BTRFS_COMPRESS_LZO:  return lzo_alloc_workspace();
 	case BTRFS_COMPRESS_ZSTD: return zstd_alloc_workspace(level);
 	default:
 		/*
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index b6563b6a333e..954034086d0d 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -175,7 +175,7 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb);
 int lzo_decompress(struct list_head *ws, const u8 *data_in,
 		struct folio *dest_folio, unsigned long dest_pgoff, size_t srclen,
 		size_t destlen);
-struct list_head *lzo_alloc_workspace(unsigned int level);
+struct list_head *lzo_alloc_workspace(void);
 void lzo_free_workspace(struct list_head *ws);
 
 int zstd_compress_folios(struct list_head *ws, struct address_space *mapping,
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 72856f6775f7..a45bc11f8665 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -80,7 +80,7 @@ void lzo_free_workspace(struct list_head *ws)
 	kfree(workspace);
 }
 
-struct list_head *lzo_alloc_workspace(unsigned int level)
+struct list_head *lzo_alloc_workspace(void)
 {
 	struct workspace *workspace;
 
-- 
2.45.0

