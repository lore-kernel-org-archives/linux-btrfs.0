Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554025;
	b=riCT7UUt8r3Jl/b4INecr4YEr2q34KeuAb9AjoLQccd+RqdV9gH/ASzld0205j4dYv/1
	 WWjMZiAjYyCcDFozUQYiTjmB91CS/64uVtsXeH57GS2AkrLD1/8cOtaTPQGObrhLtAzB7
	 LtoPbEJ9PaxU+9nNzFHHIg5XYMQNK098D3eQSYdAa1IRFUlkD4cVOYHZm61IG4Id7ojVi
	 PYoEjarfW9eL4TrKBmZyPLJsd1fokAPKd/JxjkwS1NoOPMfU/7wv19GjB6T9vmOGQXjur
	 hQfJcS5lfx2b87ZgETwnpg5IeKxNdvZ5AVY6KU+nIzxbDdy9amHk+J4WCbxmX7j/KoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554025;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Spamd-Result;
	bh=lUIMoYBaZKoV4kgH8kODxNMCqLXH9sASoiHZY9vgLBc=;
	b=yc2ZkMxhrbhjjtgA/GJSyekrP20x4m+hsopR4IK6v1hF2OSmTMjyZZ19Isb+9jzz1Va9
	 FKOdrCG/PeA2hn15ao9Fuf0XCV3J533rpDIbsV3hA5Rar25vvAdW4+T94fz7055e8TUjq
	 4qoOWhqPqcfEU6PrBY1xss7CwsB7/m2mkiM8aqDoz/Zq8Uy6qEUOCvjWiAiGaFQKBRLr/
	 ZhttBqlnuKzquxWMn85ZbhHCc9RUWrpN8oV+cqqfYCgZHaYnyguymXMSk2hxysDEhZ3T0
	 Erf1okvYRZU/deIdO3ar3MfBsy+Ghq0KtAsYf8BkwsMmFRNIq+VkFBJALEn8FL/mxOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="sk/kvwQN";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="sk/kvwQN";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870B9606A330
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 870B9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=sk/kvwQN;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=sk/kvwQN
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 000501F7E9;
	Wed, 21 Oct 2026 03:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lUIMoYBaZKoV4kgH8kODxNMCqLXH9sASoiHZY9vgLBc=;
	b=sk/kvwQNQ1c3GdQsa/Gb4zvFO2XW85fKrTioy5j6yIy02je21IGVvSYsTdadS6Yf4Z1YWf
	XZLbJCZc6JtivGFKmsuuR02uWb0jWOIqsQBoFOcMDUTnfMQioLPDL3iR4g0Nz9hMT8pimx
	IqGXMDf4Qs8ih5R9/lAHvOT4myEVvlg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lUIMoYBaZKoV4kgH8kODxNMCqLXH9sASoiHZY9vgLBc=;
	b=sk/kvwQNQ1c3GdQsa/Gb4zvFO2XW85fKrTioy5j6yIy02je21IGVvSYsTdadS6Yf4Z1YWf
	XZLbJCZc6JtivGFKmsuuR02uWb0jWOIqsQBoFOcMDUTnfMQioLPDL3iR4g0Nz9hMT8pimx
	IqGXMDf4Qs8ih5R9/lAHvOT4myEVvlg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 91D8D134A5;
	Wed, 21 Oct 2026 03:40:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4EIhJRU02GpeeQAAD6G6ig:T10
	(envelope-from <wqu@suse.com>); Wed, 21 Oct 2026 03:40:21 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 9/9] btrfs: introduce extra limits on btrfs_chunk::stripe_len
Date: Wed, 21 Oct 2026 14:09:43 +1030
Message-ID: <0d2cdb855f5858b4b0b242853dc7d8acb612ff21.1792553748.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792553748.git.wqu@suse.com>
References: <cover.1792553748.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,wdc.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,wdc.com:email];
	RCVD_TLS_ALL(0.00)[]

The new limits are:

- Stripe_len must be no smaller than sectorsize
  As sectorsize is still the minimal unit.

- Stripe_len must be no larger than BTRFS_STRIPE_LEN
  We still have a lot of things requiring on BTRFS_STRIPE_LEN alignment,
  e.g. dev extent and chunk allocation.
  A stripe_len larger than BTRFS_STRIPE_LEN will cause problems for the
  existing chunk allocator.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

