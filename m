Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C79B1B4F0A
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2026 04:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792297503; cv=none; b=lGR+tX8eqjhGe2PdeoA1Fx27FJyrTcfITSgMx7gVv535Kqzf0fIlXSxIjyvCIhRJmwWtNKEujSSOB1j8/5qtP5F/RLX1IQ5Jod7OAsNDtzjmIENj3eoxfc0A1LBl4fMENImYTgn8R5nwR5J3kEMANHeq7UdNftaaNv5YGXJ63iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792297503; c=relaxed/simple;
	bh=d+rQL4SjJMGJteNiinMCH7cVDv9U14htpoHIsgnrOw4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ePmRCtBU8+XHFQyfudYHUN9mGOsA10LgUTRA0o5Dr9OU2w6mpcZIIvn0/4K9PZbl5ityjBJ6oFyWUK8Zvnfg1VSe30IiZ+00gmJuMxHm9NmTsVqaYH1uvcEsJJfhTSSAYkGpsZZuziqUHO88hUpDR8mVOZeiJGNX+K8A1dpoy/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tsbvba/V; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=k4UddmgX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tsbvba/V";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="k4UddmgX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0C8E521CCD
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2026 04:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792297047; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4I6Pgm200Z7/NG0rZV9ZHYrPrZ30oiB8ixE85JedUZg=;
	b=tsbvba/V+yZUB9JoLoQk3vpqnNsk2OpkzgZV6cZuwJ+q1vXkZJG+4BwjcJq/bCJ8JcbFb9
	cHncQljnLI9DZENznPRD9GRGCWvMnz5/Y3w+QG5EuTTZA4pGbhyVfeTOh+aahTEVAl8V3N
	2pb07tgL5fPt7lH7Qy1znqb8nYMvagE=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=k4UddmgX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792297046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=4I6Pgm200Z7/NG0rZV9ZHYrPrZ30oiB8ixE85JedUZg=;
	b=k4UddmgXrwJA9nuaSbPNQBFNYOIe+kmIjTBhjcRYVfuqtjeOmDyBzhWWxsdfID54VA+wTP
	ayOGiBupevzVfemVAea9MuJQF4kaZiL1JuSA+XjdZcJcg9yvR2L1RecLI1pEnTmo1kRvLm
	eZRU3E9shSOwfGsExPQni7C5F2Jg4lo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA1C5132D3
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2026 04:17:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jdzOBFRI1GoVSgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2026 04:17:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: make chunk size validation to be simpler
Date: Sun, 18 Oct 2026 14:47:02 +1030
Message-ID: <bd4a247e970e35e3adc140c5417da14bfab2f4f8.1792296994.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Level: 
X-Rspamd-Queue-Id: 0C8E521CCD
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

Commit 6ded22c1bfe6 ("btrfs: reduce div64 calls by limiting the number
of stripes of a chunk to u32") introduced a chunk size limit check, but
it is using a wrong result in the comment:

  U32_MAX << BTRFS_STRIPE_LEN_SHIFT results 256T, not 256G.

Instead of calculating the size limit, using an immediate number
(SZ_256G).

This has the following benefit:

- Still large enough for future expansion
  Although the check is 1024 times more strict, I don't think we will
  allow 256G chunk anytime soon.

  And we have higher chance (10 more bits) to catch a bitflip in the
  high bits.

- Much harder to diverge from the comment
  We don't need to calculate the number anymore.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 9cd79d97b9b5..503b6be90dda 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1051,17 +1051,19 @@ int btrfs_check_chunk_valid(const struct btrfs_fs_info *fs_info,
 		return -EUCLEAN;
 	}
 	/*
-	 * We artificially limit the chunk size, so that the number of stripes
-	 * inside a chunk can be fit into a U32.  The current limit (256G) is
-	 * way too large for real world usage anyway, and it's also much larger
-	 * than our existing limit (10G).
+	 * We artificially limit the chunk size, the current limit is 10G.
 	 *
-	 * Thus it should be a good way to catch obvious bitflips.
+	 * But we don't want to follow that 10G limit too strict, as if we
+	 * relax the requirement one day, we will need a dedicated flag to
+	 * prevent rejecting such new chunks.
+	 *
+	 * Here use 256G as a sane threshold, which should be large enough
+	 * and also a good way to catch obvious bitflips.
 	 */
-	if (unlikely(length >= btrfs_stripe_nr_to_offset(U32_MAX))) {
+	if (unlikely(length > SZ_256G)) {
 		chunk_err(fs_info, leaf, chunk, logical,
 			  "chunk length too large: have %llu limit %llu",
-			  length, btrfs_stripe_nr_to_offset(U32_MAX));
+			  length, SZ_256G);
 		return -EUCLEAN;
 	}
 	if (unlikely(type & ~BTRFS_BLOCK_GROUP_VALID)) {
-- 
2.56.0

