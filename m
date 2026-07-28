Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BDF422532
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229922; cv=none; b=Eqc61p36vx7J1V6bTXHjnVMZmYekx4N8ZzVP8UuANcRS1tUduuNUbROHI1SlNlQCMq52xh+q74+RZHkBMNcN9uWuvjdO8cmjzf8SIBef0eTwce5np1QKpq6OhHcl09/Fx9hWR46Nv7TR8ebWGM0TPqYlSHFankNZWwekGTmN1ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229922; c=relaxed/simple;
	bh=dM/Jv1zoyq2Qal/pZLl16J+yGDG6NRcI6q7cdV7TIb0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oG5iKbZL6Xsm/uS5+SuoTz2nkWs603jUiD+Xwsv2H67KbRekVchu0nY2gpqDHi+l6MyB6ouKFIt0qqs4PL7KleH0qK3yFTi1eLC50LisPZlrZzcJN4/kppo3vG+HzgTHdGzeilWQzDBNYZYTa7F5U4tP4gAVJTCKlvCIizJoeng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OrhQ4PXv; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bP/IhQvY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OrhQ4PXv";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bP/IhQvY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D9D233DFE
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785229910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kneM8Lf9QcauXJa9OwFKRr5uruKsaZFFxgN2UZLUM1k=;
	b=OrhQ4PXv4ByvMjyTChGivAkvb+1z7+QvfLxL3DxMoLRYMPTNI0Ysq4cMeA5FZ5WVzNZRcX
	c85+9HVvAvwS18XhQCKAxaPGU/2Fkn8NgX8gvlgxhVrB+S/ahmL71ujNDj/iQb81o2Nqhd
	t9VBFQ/KxyGjD1hnDiIQ9ELRaPeOa/w=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785229905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kneM8Lf9QcauXJa9OwFKRr5uruKsaZFFxgN2UZLUM1k=;
	b=bP/IhQvYR6+Hiv7OvXJg1f350rbsS5Pzexczu7LAW+oXdu9P04UtpXJ8JGnTyxEFsl2177
	QPZv0dO2Iaw1qhbKbHbW99mlDbrpSTRta38oBqWDh3zqo/yA1akRjvdp9ok/xjLScOXHbu
	7T5ZMF3l2AumNvq00EDGAjI9d52Jq/U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DDF9D779B9
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uCV3I1ByaGpfXQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: use aligned range for locking in extent_fiemap()
Date: Tue, 28 Jul 2026 18:41:22 +0930
Message-ID: <f5f77acc88e5ca314e4b41733a3c60e691fb6aaf.1785229591.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785229591.git.wqu@suse.com>
References: <cover.1785229591.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

The @end parameter for all extent io tree helpers is inclusive, but
the call site in extent_fiemap() is passing an exclusive end into
btrfs_lock_extent(), which will step into the next block unexpectedly.

Fix @range_end to be inclusive, so that btrfs_lock_extent() and
btrfs_unlock_extent() will lock/unlock the correct aligned range.

Fixes: ac3c0d36a2a2 ("btrfs: make fiemap more efficient and accurate reporting extent sharedness")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/fiemap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
index ba6a360074c0..2f2ae0b76799 100644
--- a/fs/btrfs/fiemap.c
+++ b/fs/btrfs/fiemap.c
@@ -657,7 +657,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
 
 restart:
 	range_start = round_down(start, sectorsize);
-	range_end = round_up(start + len, sectorsize);
+	range_end = round_up(start + len, sectorsize) - 1;
 	prev_extent_end = range_start;
 
 	btrfs_lock_extent(&inode->io_tree, range_start, range_end, &cached_state);
@@ -710,7 +710,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
 
 		/* We have in implicit hole (NO_HOLES feature enabled). */
 		if (prev_extent_end < key.offset) {
-			const u64 hole_end = min(key.offset, range_end) - 1;
+			const u64 hole_end = min(key.offset - 1, range_end);
 
 			ret = fiemap_process_hole(inode, fieinfo, &cache,
 						  &delalloc_cached_state,
@@ -812,10 +812,10 @@ static int extent_fiemap(struct btrfs_inode *inode,
 	if (!stopped && prev_extent_end < range_end) {
 		ret = fiemap_process_hole(inode, fieinfo, &cache,
 					  &delalloc_cached_state, backref_ctx,
-					  0, 0, 0, prev_extent_end, range_end - 1);
+					  0, 0, 0, prev_extent_end, range_end);
 		if (ret < 0)
 			goto out_unlock;
-		prev_extent_end = range_end;
+		prev_extent_end = range_end + 1;
 	}
 
 	if (cache.cached && cache.offset + cache.len >= last_extent_end) {
-- 
2.54.0

