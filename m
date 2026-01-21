Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB755346A01
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 23:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769036921; cv=none; b=rj8so5qjqtW4uB2+tr8oSSixNtWJmNoQJU32NgY/4rgaTopoh4gOcjLVlNGX/y/rBzVH9H+Ni/cPO4Q36+earwshUNcCy3lQ+WVN//Q9d3pUEsE89pSauUOFqowxzvE0pHHLm3B9xzd4yLZ95aAy73oS9dxJrvwSJF6j2C9vC5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769036921; c=relaxed/simple;
	bh=71/kSxDNu8J6zdBoGIrt4kJUTZwKgfoSDz0c6wKgkBI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVBgwK85ljYK7krCBuval9WwywdSMqx6iXb083dd3F13SgLtiSD6iN+UYs9peUSOWs6DsWSXg450ZNKb9+/LsDrIk4Q8tnjYXc8CBIVC6cruzJYUlI02F48JYGlFVjWSWUBmBwIvi7nEXvt2vHvcy2IJOet9d42eDlQd1DfakRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lQiXH8Wp; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lQiXH8Wp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lQiXH8Wp";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lQiXH8Wp"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C5564336C0
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 23:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769036905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l5ODZnRqoenP7UzL5XKOkeQrs1u286PFOWV92fOtTS8=;
	b=lQiXH8WpalT3FY2DQovPn8nD5pMUon6xFUuDj471POkivg/6SlSA3AiYUPxzUHIFGHVOr5
	DS7xKUESphrUHbqIUuamu6N7TJnbcYNu5rNFce4fdY97OxqXM8Pjje8L7qb6dWIt+JUllN
	zH2zV9PvJRi1wvVPaMsCf4+Riz1YaaU=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769036905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l5ODZnRqoenP7UzL5XKOkeQrs1u286PFOWV92fOtTS8=;
	b=lQiXH8WpalT3FY2DQovPn8nD5pMUon6xFUuDj471POkivg/6SlSA3AiYUPxzUHIFGHVOr5
	DS7xKUESphrUHbqIUuamu6N7TJnbcYNu5rNFce4fdY97OxqXM8Pjje8L7qb6dWIt+JUllN
	zH2zV9PvJRi1wvVPaMsCf4+Riz1YaaU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C20053EA63
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 23:08:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AIaVG2hccWkiXgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2026 23:08:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: add strict extent map alignment checks
Date: Thu, 22 Jan 2026 09:38:00 +1030
Message-ID: <c6516d85b86019021f22942e7d4c94e7d4fbc846.1769036831.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769036831.git.wqu@suse.com>
References: <cover.1769036831.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Currently we do not check the alignment of extent_map structure.

The reasons are the inode and extent-map tests use unaligned values
for start offsets and lengths.

Thankfully those legacy problems are properly addressed by previous
patches, now we can finally put the alignment checks into
validate_extent_map().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_map.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 7e38c23a0c1c..095a561d733f 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -319,8 +319,15 @@ static void dump_extent_map(struct btrfs_fs_info *fs_info, const char *prefix,
 /* Internal sanity checks for btrfs debug builds. */
 static void validate_extent_map(struct btrfs_fs_info *fs_info, struct extent_map *em)
 {
+	const u32 blocksize = fs_info->sectorsize;
+
 	if (!IS_ENABLED(CONFIG_BTRFS_DEBUG))
 		return;
+
+	if (!IS_ALIGNED(em->start, blocksize) ||
+	    !IS_ALIGNED(em->len, blocksize))
+		dump_extent_map(fs_info, "unaligned start offset or length members", em);
+
 	if (em->disk_bytenr < EXTENT_MAP_LAST_BYTE) {
 		if (em->disk_num_bytes == 0)
 			dump_extent_map(fs_info, "zero disk_num_bytes", em);
@@ -334,6 +341,11 @@ static void validate_extent_map(struct btrfs_fs_info *fs_info, struct extent_map
 			dump_extent_map(fs_info,
 		"ram_bytes mismatch with disk_num_bytes for non-compressed em",
 					em);
+		if (!IS_ALIGNED(em->disk_bytenr, blocksize) ||
+		    !IS_ALIGNED(em->disk_num_bytes, blocksize) ||
+		    !IS_ALIGNED(em->offset, blocksize) ||
+		    !IS_ALIGNED(em->ram_bytes, blocksize))
+			dump_extent_map(fs_info, "unaligned members", em);
 	} else if (em->offset) {
 		dump_extent_map(fs_info, "non-zero offset for hole/inline", em);
 	}
-- 
2.52.0

