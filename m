Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C833B42DC
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 07:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395297; cv=none; b=F1UviK0k4lQgXD1VIkx5Ujdb3p9HxyA6lD7SN46WdGtQUsBYszfvWsWYBanwcJQhK3V0EBm0juy/Qv7w/7YhtxvYNtiTsv0/qoPzXODsd5Urq5KfiflgO3XSpFAmg1HcMYZbGZyAuqOyJlKsX6PMias8dwu0uNAGWNEyNQdXBX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395297; c=relaxed/simple;
	bh=lKxbCxiC/mXrR1MPYlTQCTZ+5ySrrAKoQyM85P7dwZA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Nnx618XepnrekEz8DUdzo7Hh2xmba93wjjwHFzoPwa5aNcXXYWPjOn7SAkfTiZjD9dJEgJhan8bQfpYMURhd8fH9LTIc/6igbEN1D/ItmhCw8UD/5VxrAk7SEhSMtW3DLNo5cHEFQ3MfnFyvyfOCawfHftlLy7TK0tfq3W9S4+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aIMbTdWO; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Evl5Gdyr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aIMbTdWO";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Evl5Gdyr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 815FF3E21
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 07:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785395283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=C5F6W/Nsrin+eU8uE3eHzDyJJlP32yylKDjIdc2ufp0=;
	b=aIMbTdWOTMH1bbox7RJ+/HYnQqy4UZB+Vls5WBY9CxNfrMKWyj1FksRpaRXZfb1wlOejQz
	apTc7mVSiKsa+yeoas5fzs7lMyKlUN8HbNb1covC9Aiqxt7wcSHLXjwaNuNE3ab0iBfKQn
	6qJ+oiivYkDvVezDESA9vSHZHFrcqvU=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Evl5Gdyr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785395279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=C5F6W/Nsrin+eU8uE3eHzDyJJlP32yylKDjIdc2ufp0=;
	b=Evl5Gdyrz3L6tu9lZ0QiLUY0moAqyE6mv833whBNU3vN36szNUMq4MTDkQxVKlsmkBoxik
	T6C8fncSMhm5nF6Il8dS3mHsXvzj9fjkofkhCBgXnothEvl/g76dNgOv7i0psuYlo1XYHy
	72dwy0K1eppth9nZqGcOy3NjDU6WNns=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 870DC779CC
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 07:07:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eCQKDk74amp8aAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2026 07:07:58 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: disable bs > ps support if no transparent hugepage support
Date: Thu, 30 Jul 2026 16:37:39 +0930
Message-ID: <7a79cac71ca43f63cdcf21ee9bba95be05f16230.1785395252.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 815FF3E21
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Btrfs relies one mapping_set_folio_order_range() to set the minimal
folio order for all its data inodes, but that function will be nop if
transparent hugepage is not enabled.

Guard the bs > ps support behind CONFIG_TRANSPARENT_HUGEPAGE, just like
all other filesystems.

Fixes: 98077f7f2180 ("btrfs: enable experimental bs > ps support")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/Kconfig | 3 ++-
 fs/btrfs/fs.c    | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 9de04c37e11a..4b10d78ed99b 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -106,7 +106,8 @@ config BTRFS_EXPERIMENTAL
 
 	  - extent tree v2 - complex rework of extent tracking
 
-	  - block size > page size support
+	  - block size > page size support - needs transparent huge page and
+					     non-HIGHMEM system
 
 	  - huge folios for data - folios can be as large as 2MiB now
 
diff --git a/fs/btrfs/fs.c b/fs/btrfs/fs.c
index 5015d0148841..77544ee5e6db 100644
--- a/fs/btrfs/fs.c
+++ b/fs/btrfs/fs.c
@@ -155,8 +155,12 @@ bool __attribute_const__ btrfs_supported_blocksize(u32 blocksize)
 	 *
 	 * Considering HIGHMEM is such a pain to deal with and it's going
 	 * to be deprecated eventually, just reject HIGHMEM && bs > ps cases.
+	 *
+	 * Finally, for bs > ps cases, we need to set the minimal folio order,
+	 * which requires transparent hugepage.
 	 */
-	if (IS_ENABLED(CONFIG_HIGHMEM) && blocksize > PAGE_SIZE)
+	if (blocksize > PAGE_SIZE &&
+	    (IS_ENABLED(CONFIG_HIGHMEM) || !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)))
 		return false;
 	return true;
 #endif
-- 
2.54.0

