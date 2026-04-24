Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29E84C6C
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020727; cv=none; b=XKc4vzKoD3NWWHDbpZUeHLDSva67WMrwu7wTesyR4MmUYfJDIX5XRYNTep0fZDp+DhWfF9RX4lab0yllY7XBYT4nam0J947f6bBq9O+uCtB2DuBWwlBb+ZE2c6Uck/4teap+hZkV3q/tNQG/5je21jID9qpEQ8hgd4aLvsgGziY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020727; c=relaxed/simple;
	bh=6Vzpds1JYB/3n3GY5lJz+6zRybWcfDbvUKxW+HQn5WY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKNClH9+TAGa6YDM+FTemWjcJLWnkUR7mpQs2wMCcsIm1/tDiiLEwqYdhG36HPCxWxQ9FIyhxjXjuY1BYiv6k9Fo30U/LWxTlf4/9a6bRDTuDTNtQ6uv8Pxcc7QfDUzWWWl8Q7Qd+8/Tsc8ELHRFJo7JnYI4WAs7YKgbz2FgcTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WQbXCIQn; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WQbXCIQn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WQbXCIQn";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WQbXCIQn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 485D16A8A2
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777020724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dvwKpdgw3JRmTnoHTKk4vThofBYSpitSxFLyxVFUutE=;
	b=WQbXCIQnrs6o6xExK8NjnjPKgg7eiDqPbl8FIvPJ/haKWnFNhgv+jOtUXlhtVXenEpF0k/
	D3ZroAKDCIHZ5XsnhTmiTsXDAZq9uugnhgE947S6Evh95M5LsLEnzxRE2FEx8sEbRmXtj3
	ACykGgGMuzv5jaSV+y4beqnIIb0wGvI=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777020724; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dvwKpdgw3JRmTnoHTKk4vThofBYSpitSxFLyxVFUutE=;
	b=WQbXCIQnrs6o6xExK8NjnjPKgg7eiDqPbl8FIvPJ/haKWnFNhgv+jOtUXlhtVXenEpF0k/
	D3ZroAKDCIHZ5XsnhTmiTsXDAZq9uugnhgE947S6Evh95M5LsLEnzxRE2FEx8sEbRmXtj3
	ACykGgGMuzv5jaSV+y4beqnIIb0wGvI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 44F5B593A4
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gG2xODIv62m2HQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:02 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 1/5] btrfs: update the out-of-date comments on subpage
Date: Fri, 24 Apr 2026 18:21:30 +0930
Message-ID: <3a92a6aacdafccdd288ef5b6c5d65f68d7f40b9f.1777019132.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777019132.git.wqu@suse.com>
References: <cover.1777019132.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

The comments at the beginning of subpage.c is out-of-date, a lot of the
limits are already resolved.

Update them to reflect the latest status.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/subpage.c | 39 +++++----------------------------------
 1 file changed, 5 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 8a09f34ea31e..becaa1dc0001 100644
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
+ * - Only support block per folio <= BITS_PER_LONG
+ *   This is to make bitmap copying much easier, a single unsigned long can handle
+ *   one bitmap.
  *
  * Implementation:
  *
-- 
2.53.0

