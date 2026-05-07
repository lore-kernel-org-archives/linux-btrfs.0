Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB82732E6B4
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 05:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778131808; cv=none; b=JWSgufWp9XdsShikG1U+VBWvGhxYEF1j+RtlUkQ0PKKsXgkn+og/E+2AnCyky11NQ2O+O0G/dZ9bxLIPrGgknWRkOtOUcEDcfBKDIdzAQRy7kCbSzcvUwlFOrkHzMPlt7pUkSWDNraInIPmCj3OWhTdykgLe2xyE9LASEV6zLHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778131808; c=relaxed/simple;
	bh=meOZlVD1M9c3HJ2Y45R6ZZ9Won3Vf1riN+ZI42Erncw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBE+QbzyD8qz9mjkHuH5G+rVstA8BCakh0UkuUWSfdTTdv9wd6ChMzY8hTSXFBkxnP+lsRalRepj3aa8jURxnFGQZCdy1rF75S4dhC0IaBl9SkT1/gYFRkAu4a2JxBvabOi8/9dvwcL3C4tTcFHVgAsPc8xpf9dBGN4NMkKUayI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=o29TerOE; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=o29TerOE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="o29TerOE";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="o29TerOE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 946BD5CF90
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 05:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778131785; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L/ph9DspUVLylI5lB5g+Ex+QbvY1ldx5pizDbcGKOmQ=;
	b=o29TerOEeAGqV3bINEkyRW0S5cYFA2u/nIupzocr6c9aWqSp/xMM8v8lFqZf6DwbiwUTh9
	IGED+6lEsLVxivk3p0VwDIVr048Dxs6kGG6hpCTRze5xLrKYPIj0MHTJBnrHjApDl5npqK
	qEHkajbg0UYzQ8bqnQe6Q+UmlzhtPkw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778131785; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L/ph9DspUVLylI5lB5g+Ex+QbvY1ldx5pizDbcGKOmQ=;
	b=o29TerOEeAGqV3bINEkyRW0S5cYFA2u/nIupzocr6c9aWqSp/xMM8v8lFqZf6DwbiwUTh9
	IGED+6lEsLVxivk3p0VwDIVr048Dxs6kGG6hpCTRze5xLrKYPIj0MHTJBnrHjApDl5npqK
	qEHkajbg0UYzQ8bqnQe6Q+UmlzhtPkw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC86C593A7
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 05:29:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6Kz3Ikgj/GmvEgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2026 05:29:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] btrfs: remove folio_test_ordered() usage
Date: Thu,  7 May 2026 14:59:20 +0930
Message-ID: <714acd8f149581186a4c2f0fb52245fa666e0d3a.1778131118.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778131118.git.wqu@suse.com>
References: <cover.1778131118.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

This involves:

- The ASSERT() inside end_bbio_data_write()
  It's only an ASSERT() and it has never been triggered as far as I
  know.

- btrfs_migrate_folio()
  Since all folio_test_ordered() usage will be removed, there is no need to
  copy the folio ordered flag.

- The ASSERT() inside btrfs_invalidate_folio()
  This one has its usefulness as it indeed caught some bugs during
  development.
  But that's the last user and will not be worth the folio flag or the
  subpage bitmap.

This will allow btrfs to finally remove the ordered flags.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c |  1 -
 fs/btrfs/inode.c     | 12 ------------
 2 files changed, 13 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b307b26014c6..fdd94a5244e2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -531,7 +531,6 @@ static void end_bbio_data_write(struct btrfs_bio *bbio)
 		u32 len = fi.length;
 
 		bio_size += len;
-		ASSERT(btrfs_folio_test_ordered(fs_info, folio, start, len));
 		btrfs_folio_clear_ordered(fs_info, folio, start, len);
 		btrfs_folio_clear_writeback(fs_info, folio, start, len);
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index eaae344804f2..61cec1a66baf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7499,12 +7499,6 @@ static int btrfs_migrate_folio(struct address_space *mapping,
 
 	if (ret)
 		return ret;
-
-	if (folio_test_ordered(src)) {
-		folio_clear_ordered(src);
-		folio_set_ordered(dst);
-	}
-
 	return 0;
 }
 #else
@@ -7672,12 +7666,6 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 	}
 	btrfs_folio_clear_dirty(fs_info, folio, page_start, folio_size(folio));
 	btrfs_clear_folio_dirty_tag(folio);
-	/*
-	 * We have iterated through all ordered extents of the page, the page
-	 * should not have Ordered anymore, or the above iteration
-	 * did something wrong.
-	 */
-	ASSERT(!folio_test_ordered(folio));
 	if (!inode_evicting)
 		__btrfs_release_folio(folio, GFP_NOFS);
 	clear_folio_extent_mapped(folio);
-- 
2.54.0

