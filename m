Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B840392820
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788851776; cv=none; b=dC0FE+WnexcKeiejo1HJMbjhH2krdL52f8qc//LsHC76JjAcOMN5l2aN8vK5zvkvnOhrTsJcYiIkGh2+nrIKrqbU2Ojz9EBS/ujvLHXEBR7QL9EemNS1elzO2bhpXco4cKAzI6y0TMWuVzzTITEjmi9/57RVgNZK7LA3zAducIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788851776; c=relaxed/simple;
	bh=YO86QAN9L2sQxYjaUyWKiLeBdDMHPEs08Am2DOZ6q34=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxfTBgyam1OScTQNtnMXUnjd6zyG16XfPoZGOlslDkQFuqnSxZ+skOY7fLGFStD5NxmpkpjHrRVxpFc/BsqM1KpSuLkI4wP1Bz9fYYGzYCH0FMj/dgo+9N+Pk3brt0gQYsDw4w3H/0qTWfDq9DqRsOoO9tZ40KhawCFNqqMqEpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=J+JiCIid; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kLYMzkGR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="J+JiCIid";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kLYMzkGR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7A380219EC
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788851768; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VyObmekGMEJPeh4ZJJpuSypDnlPMDF957WvZHr7DJvM=;
	b=J+JiCIidSTLwMoWTpz+h9RIbFoES4Q2uEea0Yp8+BbckYWbGwWWZ0DM7+YZUnL7qSUGgRY
	pGluq1E1ZPRcQ358Mc6pT/wgDRl5mkMPYe6IzlotrfH6Fe7F+tzDB2CgofzsIgrSmLzJ9d
	yHPrp4daTCUfIv1hQrV5IhKs/H0FlJQ=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=kLYMzkGR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788851764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VyObmekGMEJPeh4ZJJpuSypDnlPMDF957WvZHr7DJvM=;
	b=kLYMzkGRUpoJzq26VFsB/DmZmYq5Jxm03WpULa7qfG8qT8+El86PJWYVDzpVzYXJjVutTO
	1NS7zZT9WyomdUaOnZsjRH3zE+x+mIujVkUAttWwTuxUfmjeBrZr7jduPY2v7AJSCN4Ypl
	7uimoFC5ygBrby8Etc7OpUaB81Ydyj8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 41DF11368D
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:16:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EJ09ODK2n2qWVAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 07:16:02 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: use kvmalloc() for uncompress_inline()
Date: Tue,  8 Sep 2026 16:45:40 +0930
Message-ID: <9cb5eed5ce0d396bad3f7fdd3d305f091bb434da.1788851649.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788851649.git.wqu@suse.com>
References: <cover.1788851649.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 7A380219EC
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO

Although btrfs doesn't support inlined extents larger than PAGE_SIZE
for bs > ps cases, it's still possible for the experimental bs > ps
support to mount a btrfs created on a system with a much larger page size,
thus can still hit an inlined extent that is way larger than the current
page size.

E.g. a compressed inline extent which has 32K compressed size, is created
on 64K page sized arm64 with 64K sectorsize, then mounted on x86_64 with
the experimental bs > ps support.

In that case, when reading the compressed inline extent, we need to
allocate a buffer that is the same size as the compressed inline extent
(32K).

That kmalloc() call will request physically contiguous memory for that
32K allocation, and if the system has a very fragmented memory space,
such allocation can fail.

But there is really no reason that we require such buffer to be
physically contiguous, so change it to kvmalloc() to reduce the chance
of allocation failure for bs > ps cases.

And for all bs <= ps cases, the kvmalloc() call will just be fulfilled by
kmalloc() so this will not bring any change to the most common cases.
Only bs > ps will get the benefit of less memory allocation failure.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 59e92908c6c5..a85a7c561cf8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7133,7 +7133,7 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	compress_type = btrfs_file_extent_compression(leaf, item);
 	max_size = btrfs_file_extent_ram_bytes(leaf, item);
 	inline_size = btrfs_file_extent_inline_item_len(leaf, path->slots[0]);
-	tmp = kmalloc(inline_size, GFP_NOFS);
+	tmp = kvmalloc(inline_size, GFP_NOFS);
 	if (!tmp)
 		return -ENOMEM;
 	ptr = btrfs_file_extent_inline_start(item);
@@ -7154,7 +7154,7 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 
 	if (max_size < blocksize)
 		folio_zero_range(folio, max_size, blocksize - max_size);
-	kfree(tmp);
+	kvfree(tmp);
 	return ret;
 }
 
-- 
2.55.0

