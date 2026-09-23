Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64D43DDAE2
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142312; cv=none; b=KUfX1d9Z9uLxUzV2eLTUTkuiTtBm03LGTZWXO9KUJ1K1aqEzbLBxnslChid/lP7obugcTD5Mkb5t9jbJ3FqdWINWFGXMq0dMQBJbov9/Ve6a8VGKBZFZxWcIuv3bjrf+kWa/YtF9k2sR+3FoFh7Uz+m8YqjHL6bIAVhc0+6qKPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142312; c=relaxed/simple;
	bh=UPnD3RFalFn7Adl6Qofd+6EG5Gdh+wyNM2VlEFPjJ+s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRb0bnamJzgTQ9W4HVQ3GPtlL8cRcTqM+X1I7R6Hmv+VNDQjZmxM9kD9/3kUzFC7hnIRp7sH7u5Kj+8xGou69eJlenBQqTERlYJXFq17XSX8OJ9/P9nOQ92nWHuNaMaKROdJuu/YDjH9iKhMU4/2sO1VS7SNmBZXVshBdwb10To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oVzTKQfE; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YwUjH1MM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oVzTKQfE";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YwUjH1MM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 910E521D70
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790142304; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t6NPrSb/zDgzwg4RDtaaDwNFDC848JoJ9r9JOGBEw34=;
	b=oVzTKQfEkoO33RAd417eMTsqk4VjUOvAkM5AKq0p5PRHUPwYI5hSEK0kOdZ6Edw+X5pAcR
	Dm92DPG30nHJyERv6h2WTb6CyH4CA619lIy4tDnUG+2GiXJBaFZMCzIZRum/AqnNrikXoE
	lzgfSR1TO2X6b+RxaHO8AgpFAcAsmHo=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790142300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t6NPrSb/zDgzwg4RDtaaDwNFDC848JoJ9r9JOGBEw34=;
	b=YwUjH1MMU8Js0wS3dANpG0NCd+nEglUeGDVDcSxtrqsp9qLSMTLh3A+4884D+FjMcAcx0A
	sNVCxT0ilHSBPGQLTDKJtNJStWD+jLQtSpnDaoIjCaO3wi4a5DhP39dyGTHeUjSOGCx3l+
	VnYZGfmUHypYPGPvJdHOGfjJwlLfl7U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F9E5139EB
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:44:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 40aCMlVns2o/dgAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:44:59 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: use kvmalloc() inside test_eb_bitmaps()
Date: Wed, 23 Sep 2026 15:14:27 +0930
Message-ID: <bd4addf8c965e59cfbd1d7dbadb797810d9a6932.1790142027.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790142027.git.wqu@suse.com>
References: <cover.1790142027.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

The reference bitmap has the same size as nodesize, and the selftests
use nodesize as large as 64K, so the kmalloc() may fail if the available
memory is fragmented.

However this should be very rare. Firstly this requires
CONFIG_BTRFS_FS_RUN_SANITY_TESTS, which is only enabled for developers.

Secondly for most users the btrfs module is loaded at boot time, thus
there should be more than enough available space to fulfill that
kmalloc() call.

Secondly for most users the btrfs module is loaded at boot time, so there
should be more than enough available memory.

Use kvmalloc() to reduce the chance of allocation failure.

Assisted-by: LLM (finding callsites doing multi-page kmalloc)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tests/extent-io-tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index cd045778400d..0a8d65df0eba 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -507,7 +507,7 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb)
 static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 {
 	struct btrfs_fs_info *fs_info;
-	unsigned long AUTO_KFREE(bitmap);
+	unsigned long AUTO_KVFREE(bitmap);
 	struct extent_buffer *eb = NULL;
 	int ret;
 
@@ -519,7 +519,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 		return -ENOMEM;
 	}
 
-	bitmap = kmalloc(nodesize, GFP_KERNEL);
+	bitmap = kvmalloc(nodesize, GFP_KERNEL);
 	if (!bitmap) {
 		test_err("couldn't allocate test bitmap");
 		ret = -ENOMEM;
-- 
2.55.0

