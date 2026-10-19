Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEF944F558
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392047; cv=none; b=dZMJwJccgLboFHu25pEeJGItJ1UYTF/z8ZM1j5nOnlx7RnWVZO33dGXhVu6TsCp3iniCyzgR0qA6DRirorpakAkJSoe3ZXBlIOdxHhHLfhsSquGvOpO+ra/esODi4V+4hTMP/tmJN7sLhDIinBmXS6/8MlEfSOh0/Wb+OvX2Fms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392047; c=relaxed/simple;
	bh=1dd2W0Dpn1nFPB0sZoUzkPwyjHf+CBdly3i+p8qhAqQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJ+zTv03SN5YHKPnoxr78knptIOdpFfwCyjfpf0tFUHoUX0HbO8cyjhfhjCpECR0NpkXaKViH6Mh5Fw/TqykR2x+j4Z1z6UfYVkjQBbnpKi/W8qRL1T3dHQHSvr5ugLYZdH9iMjNKKK1CMsK0/o+FOiB7y/MmRHT/b7/oNut9jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BYvGd3WF; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BYvGd3WF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BYvGd3WF";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BYvGd3WF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0CFA61F821
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EIrUfzEGco8ajkOPvw+YCgfwLWgp2LcYufuAlqB11YQ=;
	b=BYvGd3WFfDCDDHqpipNNY6D0gOFk8fPHUq3oa9cwIyGfWXcYhnywEZsbaox6zsIwZ0J+AM
	mqBbIQit9OWwa6CMiZpRxGDT47F6YKkcJxcOShlqijd/50+Zm7Xe7I9t6eSN7Ruw4XScmi
	UeEfmp8SKaldHtPCFWZduIShiAURkiw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=BYvGd3WF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EIrUfzEGco8ajkOPvw+YCgfwLWgp2LcYufuAlqB11YQ=;
	b=BYvGd3WFfDCDDHqpipNNY6D0gOFk8fPHUq3oa9cwIyGfWXcYhnywEZsbaox6zsIwZ0J+AM
	mqBbIQit9OWwa6CMiZpRxGDT47F6YKkcJxcOShlqijd/50+Zm7Xe7I9t6eSN7Ruw4XScmi
	UeEfmp8SKaldHtPCFWZduIShiAURkiw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3929E1375D
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 09jKA1i71WpsbgAAD6G6ig:T10
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:41 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9] btrfs: introduce extra limits on btrfs_chunk::stripe_len
Date: Mon, 19 Oct 2026 17:10:05 +1030
Message-ID: <371fea59c3e0fbf0b2a21ce228eca8ed24c98e80.1792391732.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792391732.git.wqu@suse.com>
References: <cover.1792391732.git.wqu@suse.com>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Level: 
X-Rspamd-Queue-Id: 0CFA61F821
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

The new limits are:

- Stripe_len must be no smaller than sectorsize
  As sectorsize is still the minimal unit.

- Stripe_len must be no larger than BTRFS_STRIPE_LEN
  We still have a lot of things requiring on BTRFS_STRIPE_LEN alignment,
  e.g. dev extent and chunk allocation.
  A stripe_len larger than BTRFS_STRIPE_LEN will cause problems for the
  existing chunk allocator.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tree-checker.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 503b6be90dda..61ea8f42c9f2 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1044,7 +1044,18 @@ int btrfs_check_chunk_valid(const struct btrfs_fs_info *fs_info,
 			  logical, length);
 		return -EUCLEAN;
 	}
-	if (unlikely(!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN)) {
+
+	/*
+	 * For now the "stripe_len != BTRFS_STRIPE_LEN" will cover all cases,
+	 * but the power_of_2 and stripe_len >= sectorsize and
+	 * stripe_len <= BTRFS_STRIPE_LEN are the requirements for future
+	 * stripe_len support.
+	 *
+	 * In the future, "stripe_len != BTRFS_STRIPE_LEN" will be removed.
+	 */
+	if (unlikely(stripe_len != BTRFS_STRIPE_LEN ||
+		     !is_power_of_2(stripe_len) || stripe_len < sectorsize ||
+		     stripe_len > BTRFS_STRIPE_LEN)) {
 		chunk_err(fs_info, leaf, chunk, logical,
 			  "invalid chunk stripe length: %llu",
 			  stripe_len);
-- 
2.56.0

