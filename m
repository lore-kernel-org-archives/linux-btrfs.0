Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490CD3612E9
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778647009; cv=none; b=cuRVEUBs/iClrzBdQli7oDV/kmx7rhIBnCDYzjMV/s0J2plSELRS7CP/kGNCg7DOYFMD86r0RQvVBtviZ7sayOdazzwWBtb/OpBq/teLqjLAH29RKcI2kGjllbdf0uWZw8i0eib9dy4GmaLVvw+Xq6jqwgCrqPkPSecrNEsAFVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778647009; c=relaxed/simple;
	bh=FNBKe36vDx/rfxOGGeCIUGl/o8uR9tNBhpHtNGidcCU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcrBnmaTETLNCl6tJgcSkuFBZ1fzysD8tu5JT3E3sp0IYBjC1XW7VIfNAK5crI4/R0znf8chMeDqIxJFOt0cm6vWyqm44GdVVZS4eq7BCXr+kHQUm7Z5ESrXB1aebvYzdGXSm7DzaSy9RFdqjtvUJaKe2osYCZNZuvkmVg/Tevk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=r4TOc39k; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=r4TOc39k; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="r4TOc39k";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="r4TOc39k"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6943462117
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778647005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1hX0pZ0CABACEQZZQeZMsHAak7rNGAuuQ3F8sWkhhFY=;
	b=r4TOc39kwCVqifoJH2itzBezye6pnY6rJeO6mMq/2QcDKOVebCtXZytxsnI33Y5Y8psKF4
	aGfjtLlDF2XHlZ/Af9akBBDDEZ+3Q1bbNy8garp/Q5IR9VwBA5wG7n8760rnQ5mil+klOC
	UkESvVfRPdMPzv3sjNMPKfT4T8EoNn4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=r4TOc39k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778647005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1hX0pZ0CABACEQZZQeZMsHAak7rNGAuuQ3F8sWkhhFY=;
	b=r4TOc39kwCVqifoJH2itzBezye6pnY6rJeO6mMq/2QcDKOVebCtXZytxsnI33Y5Y8psKF4
	aGfjtLlDF2XHlZ/Af9akBBDDEZ+3Q1bbNy8garp/Q5IR9VwBA5wG7n8760rnQ5mil+klOC
	UkESvVfRPdMPzv3sjNMPKfT4T8EoNn4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7A10593A9
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0DWAGtz/A2r1SQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs: update the out-of-date comments on subpage
Date: Wed, 13 May 2026 14:06:18 +0930
Message-ID: <a8e75a11fd44d97dc9246b7b39785cd354ef92af.1778646753.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778646753.git.wqu@suse.com>
References: <cover.1778646753.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 6943462117
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.01

The comments at the beginning of subpage.c are out-of-date, a lot of the
limits are already resolved.

Update them to reflect the latest status.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/subpage.c | 39 +++++----------------------------------
 1 file changed, 5 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 9a178da13153..99ae53656dba 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -10,41 +10,12 @@
  *
  * Limitations:
  *
- * - Only support 64K page size for now
- *   This is to make metadata handling easier, as 64K page would ensure
- *   all nodesize would fit inside one page, thus we don't need to handle
- *   cases where a tree block crosses several pages.
+ * - Metadata must be fully aligned to node size
+ *   So when nodesize <= page size, the metadata can never cross folio boundaries.
  *
- * - Only metadata read-write for now
- *   The data read-write part is in development.
- *
- * - Metadata can't cross 64K page boundary
- *   btrfs-progs and kernel have done that for a while, thus only ancient
- *   filesystems could have such problem.  For such case, do a graceful
- *   rejection.
- *
- * Special behavior:
- *
- * - Metadata
- *   Metadata read is fully supported.
- *   Meaning when reading one tree block will only trigger the read for the
- *   needed range, other unrelated range in the same page will not be touched.
- *
- *   Metadata write support is partial.
- *   The writeback is still for the full page, but we will only submit
- *   the dirty extent buffers in the page.
- *
- *   This means, if we have a metadata page like this:
- *
- *   Page offset
- *   0         16K         32K         48K        64K
- *   |/////////|           |///////////|
- *        \- Tree block A        \- Tree block B
- *
- *   Even if we just want to writeback tree block A, we will also writeback
- *   tree block B if it's also dirty.
- *
- *   This may cause extra metadata writeback which results more COW.
+ * - Only support blocks per folio <= BITS_PER_LONG
+ *   This is to make bitmap copying much easier, a single unsigned long can handle
+ *   one bitmap.
  *
  * Implementation:
  *
-- 
2.54.0

