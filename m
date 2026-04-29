Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9E39463
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 05:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777439064; cv=none; b=akf5XHBmgX958G1/2Pdbvo1R7KJ9Zl78r3P0/CdffGtVjIkMwlodMbaGqnxfnss1m4MkwuCJ3EEoU31YErJK+0vx7v8GwZRzxkH18sMAQgGKC8dPgKf9VckSliC7V97UiihElBELLMMogvdSibbYDBOAY8ZQsNEWjg5j4fhnBDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777439064; c=relaxed/simple;
	bh=LiRghTks5YWD/rVC3hnFydqeiWeHfxO0WCh9jewMyr0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzAuu3HLpGoYtc/sl1NUiwOAr+1I6Ijrev143oS9Ufu12u4OAGPnnIDK2jm1ksnBZgdbjB9l+jRwt/dlbAazf7AY/8CRmssDrMei+A96HFND2Hl/pWjMsSZMzduxqHYx0Qbo4V93DvJgqjP8ThbTjZtf9T34rmrf5iN11gGs0UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iVuhUCJt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iVuhUCJt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iVuhUCJt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iVuhUCJt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 934745BD38
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 05:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777439057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/2+BYlUna6qHRxalanyxH1j9kefjfMV7bLOhmtAaeiY=;
	b=iVuhUCJtiVdQt9xpbaTboBkvglPL1myE3Lfj0JJsQKI6ffOqwpy4aBtKsnXUZ0zeMj9GFs
	3FFChs3K8BgQIS7VwqOSnPfaMyesDaS/5V5dH7fUAyLJYKB9dM5+bSFte+ccFIHo73hduu
	kWJEYnR88RoHOh5ChTxV58EObEe69M8=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=iVuhUCJt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777439057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/2+BYlUna6qHRxalanyxH1j9kefjfMV7bLOhmtAaeiY=;
	b=iVuhUCJtiVdQt9xpbaTboBkvglPL1myE3Lfj0JJsQKI6ffOqwpy4aBtKsnXUZ0zeMj9GFs
	3FFChs3K8BgQIS7VwqOSnPfaMyesDaS/5V5dH7fUAyLJYKB9dM5+bSFte+ccFIHo73hduu
	kWJEYnR88RoHOh5ChTxV58EObEe69M8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90272593B0
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 05:04:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EGVsD1CR8WloAgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 05:04:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs: update the out-of-date comments on subpage
Date: Wed, 29 Apr 2026 14:33:49 +0930
Message-ID: <e9dcee90f3db6808406fa05bab2391a685004e99.1777438651.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777438651.git.wqu@suse.com>
References: <cover.1777438651.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid,suse.com:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 934745BD38
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

The comments at the beginning of subpage.c are out-of-date, a lot of the
limits are already resolved.

Update them to reflect the latest status.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/subpage.c | 39 +++++----------------------------------
 1 file changed, 5 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 8a09f34ea31e..10220453b6fa 100644
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
2.53.0

