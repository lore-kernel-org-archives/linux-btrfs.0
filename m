Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE27C34A783
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020739; cv=none; b=c4ZDD5/i/LYa17QHGJCGAsvAgWgsZ8y7Hqe1qUsYpcrD0s/kuSnZ2dOQM6VO9N+Rw8QgDXbRos75vz5cF1Gos2IuwNt431wPfIY2kiddqC9ovPS/B1RYozOmu6FPO2LOnabAt5gj1ExCGOXe+z+vMtfr5sA84/VtdMycMs7xBUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020739; c=relaxed/simple;
	bh=r7OcOvNqbeOR+lUMy5sXsfiai3n0FHJ4vr9Wou/QYHk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxlip5zTTrk1kstSwdRz1FDRIMZactpjuE1MtPL4vSsupZtbLQBpdXLmgcF1FbYJP5ZUew3tin5eVHbq/y+9TiVSiEY09YSzgAQnINLGmH2p2irv8QA4uhzpy2tcHZnGvWYaeG/10MKsqYbIMPYVfa96uRmE4ElW4zW6ifRtgmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=H2wUDPfm; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=H2wUDPfm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="H2wUDPfm";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="H2wUDPfm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 43E3F6A8A3
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777020729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0+XkKpWFzSFNd7k1Dfdt6xFAv+nbGCbiOU10rbcnzU=;
	b=H2wUDPfm2vkioZgnyyRAM/TGimL0g2xZuPVyM9mbQX7XZ/lb5vOdXS/Ci6MqK86D/wJAA9
	BqolO7lCq73BkbpCogKjyRTk3jD6HnsdMOgkSWX2hpc2DRlzlwcVHSqlvnTva3j8RM0G6k
	3rMaLxuSHz+Qm8J7Z9SeQWKnr2K77fs=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=H2wUDPfm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777020729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0+XkKpWFzSFNd7k1Dfdt6xFAv+nbGCbiOU10rbcnzU=;
	b=H2wUDPfm2vkioZgnyyRAM/TGimL0g2xZuPVyM9mbQX7XZ/lb5vOdXS/Ci6MqK86D/wJAA9
	BqolO7lCq73BkbpCogKjyRTk3jD6HnsdMOgkSWX2hpc2DRlzlwcVHSqlvnTva3j8RM0G6k
	3rMaLxuSHz+Qm8J7Z9SeQWKnr2K77fs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 400A8593A4
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oAuBNzcv62m2HQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:07 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 4/5] btrfs: remove 2K block size support
Date: Fri, 24 Apr 2026 18:21:33 +0930
Message-ID: <0673de432dd2e64c8d32671247710aab33f7254d.1777019132.git.wqu@suse.com>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 43E3F6A8A3

Originally 2K block size support was introduced to test subpage (block
size < page size) on x86_64 where the page size is exactly the original
minimal block size.

However that 2K block size support has some problems:

- No 2K nodesize support
  This is critical, as there is still no way to exercise the subpage
  metadata routine.

- Very easy to test subpage data path now
  With the currently experimental large folio support, it's very easy to
  test the subpage data folio path already, as when a folio larger than
  4K is encountered on x86_64, we will need all the subpage folio states
  and bitmaps.

  So there is no need to use 2K block size just to verify subpage data
  path even on x86_64.

And with the incoming huge folio (2M on x86_64) support, the 2K block
size will easily double the bitmap size, considering the burden to
maintain and the limited extra coverage, I believe it's time to remove
it for the incoming huge folio support.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/fs.h | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index d69b8ce41912..e99db75dede6 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -50,18 +50,8 @@ struct btrfs_subpage_info;
 struct btrfs_stripe_hash_table;
 struct btrfs_space_info;
 
-/*
- * Minimum data and metadata block size.
- *
- * Normally it's 4K, but for testing subpage block size on 4K page systems, we
- * allow DEBUG builds to accept 2K page size.
- */
-#ifdef CONFIG_BTRFS_DEBUG
-#define BTRFS_MIN_BLOCKSIZE	(SZ_2K)
-#else
+/* Minimum data and metadata block size. */
 #define BTRFS_MIN_BLOCKSIZE	(SZ_4K)
-#endif
-
 #define BTRFS_MAX_BLOCKSIZE	(SZ_64K)
 
 #define BTRFS_MAX_EXTENT_SIZE SZ_128M
-- 
2.53.0

