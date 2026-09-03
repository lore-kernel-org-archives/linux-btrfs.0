Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C2438239F;
	Thu,  3 Sep 2026 06:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788416616; cv=none; b=UmS6XCnWtK362+jUMXw/iIS9ozyx3u3abIwvmFN/XHVuSky0rXsju8APFQ7+2tj1C37RzwB5/+uibUHEj1NOUdmzNIXhPIVYZyNj6J6M6y7n1FoJJapv7Qjd3mj+OqSpzmmV2UFkJIDYwCfEY7xywCkwOMrOYZznXsUcu2hVzR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788416616; c=relaxed/simple;
	bh=O0cVIWf4avJOs+FgyAmC/vpb1u2Py8iQ8gxPX2Pp9iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuChVvld5BcPznkLJG3jgh7dchbTzO9yswRKNJW4iSPIz+iqZj7OAb+T1zKhsMi4UcKxtlwOf0+mSVA+nxcSK8ZFPqK+xbtz4ep6jCnZlNfluNx+LGzYbIKxLN8i11n5iBswYMsaO6tjaY9XkCBNgdp5vKNmknlLG8k+choRl9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fk0f2JtE; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oS69zHaO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fk0f2JtE";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oS69zHaO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8891D21E86;
	Thu,  3 Sep 2026 06:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788416608; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kDYF+bA8W2P21A53YU1WTOJcp0b2M/FDnDwv/bnunBQ=;
	b=fk0f2JtEJJvp2wW/kkmeNnXJrEcGzBpR4v83XpqwvC9On/V1HnaF6nbjd5nMD+IepA8Quh
	/Omh5j9BLaSiDL526mjfKa3TvWGsyKrW+78WwMusGhTLrtPYdia3PFB/IFuBCOE6G8MwjU
	OvX6IOyzP9Feh3YvzDAuDQucpXOaotc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788416604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kDYF+bA8W2P21A53YU1WTOJcp0b2M/FDnDwv/bnunBQ=;
	b=oS69zHaO+n5b1PKxb87HbG3JSZXxcJ6hfZQgsufM3BCPlErGSJSOR1EyW9Y+afBBWnAYT7
	/OR0O7treh0z0d+4EvgIeBX2zLxzf90Sks9Ei0PpvqDw0EYI9MgWkTuUKLdERr7uro1QOq
	KKIQrICzMtf97SUjmETomBaU7Dl074E=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 398BC13869;
	Thu,  3 Sep 2026 06:23:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UAF5DVwSmWoVKwAAD6G6ig
	(envelope-from <neelx@suse.com>); Thu, 03 Sep 2026 06:23:24 +0000
From: Daniel Vacek <neelx@suse.com>
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: Daniel Vacek <neelx@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>
Subject: [PATCH v2 3/3] btrfs: promote async checksumming out of EXPERIMENTAL
Date: Thu,  3 Sep 2026 08:23:16 +0200
Message-ID: <20260903062317.3928665-4-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260903062317.3928665-1-neelx@suse.com>
References: <20260903062317.3928665-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -6.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[]

There was no issue with this feature since it's introduction in
dd57c78aec398 ("btrfs: introduce btrfs_bio::async_csum").
No need for hiding it.

Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v2: Introduced this change.
---
 fs/btrfs/bio.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 771b7d598aee..db426ee6e587 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -569,11 +569,7 @@ static int btrfs_bio_csum(struct btrfs_bio *bbio)
 {
 	if (bbio->bio.bi_opf & REQ_META)
 		return btree_csum_one_bio(bbio);
-#ifdef CONFIG_BTRFS_EXPERIMENTAL
 	return btrfs_csum_one_bio(bbio, true);
-#else
-	return btrfs_csum_one_bio(bbio, false);
-#endif
 }
 
 /*
-- 
2.53.0

