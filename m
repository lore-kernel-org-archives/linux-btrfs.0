Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D6B318ECD
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 09:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020098; cv=none; b=j2beu+j7CHqVI+AJy+Rwaj9yphIaNd7s2f0+MliFVdnme+COLc2zvG2td8SK0wDMLkemdMxUy+CfVnUqRWPQwYb2a1DmoepwMVUMkC4vBxDjiqQ5TVJdAKXNACFkz2O8mnAfZwQ4TjtjSHUCKugt75T8N82VcpFk22ULinSD5QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020098; c=relaxed/simple;
	bh=NJo7MlhG03XZ95eyKjganVgYCzFt7x8XxLl5h68wULA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dTh8xfTKN01GlRDPGx/ORsQqkTTOnhxnPYND+Xka+DXM/TGwofdgDRdBE6tPddnf2eWNOAD+X3gFC75Anv3aeHD24WPbalYos32Poei2sIr+o+4V5LxG63r/2u1Q0iEg1qvRGzqFOw6T6SP0oXFgzd/IPx9uEyIPmrYbKX29JSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qA7XEVE8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qA7XEVE8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qA7XEVE8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qA7XEVE8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2264D3E0A;
	Tue, 14 Jul 2026 09:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784020093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fp0ZRjg/oOEFcNQzC5Wgr2V0kNXwMTWRpG8kllYk3QQ=;
	b=qA7XEVE8kmjnmUDq8BmivtXUnyPhaZNTv/iAqzG5Lm89s6HEKbobpr98IA+tfPvh9hkN41
	WXr+fcSQg6KJDfwxAKL1tngtv7oOn4/+InK5jO1k/YDfbRtDeOJpq4WJbVAVbGBsH6dR5C
	hlLFAA4n8Qz5EQh/BfPvaNRFYBUt6jo=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784020093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fp0ZRjg/oOEFcNQzC5Wgr2V0kNXwMTWRpG8kllYk3QQ=;
	b=qA7XEVE8kmjnmUDq8BmivtXUnyPhaZNTv/iAqzG5Lm89s6HEKbobpr98IA+tfPvh9hkN41
	WXr+fcSQg6KJDfwxAKL1tngtv7oOn4/+InK5jO1k/YDfbRtDeOJpq4WJbVAVbGBsH6dR5C
	hlLFAA4n8Qz5EQh/BfPvaNRFYBUt6jo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D607779AE;
	Tue, 14 Jul 2026 09:08:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zsPjM3v8VWrXVQAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 14 Jul 2026 09:08:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH] block: do not warn when doing greedy allocation in folio_alloc_greedy()
Date: Tue, 14 Jul 2026 18:37:39 +0930
Message-ID: <d10571445ee505d95ba6eaad7558fc1f556d2921.1784020005.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

[WARNING]
During one of my local btrfs fstests runs, folio_alloc() inside
folio_alloc_greedy() triggered an allocation failure report when trying
to allocate an order-4 folio.

The kernel is from the latest development branch, which is utilizing
the IOMAP_DIO_BOUNCE flag for direct writes when the inode requires
checksum.

Unfortunately I didn't save the full log, only the function and the
order.

[CAUSE]
When the IOMAP_DIO_BOUNCE flag is utilized, we will hit the following call
chain:

 bio_iov_iter_bounce_write()
 |- folio_alloc_greedy()
    |- folio_alloc(gfp | __GFP_NORETRY, get_order(*size));

However __GFP_NORETRY will still emit an allocation failure report
when it fails.

And folio_alloc_greedy() will retry with a smaller order anyway, there
is no point in emitting that allocation failure report.

[FIX]
Append the __GFP_NOWARN flag to folio_alloc() for the larger-order folio
attempts.

Fixes: 8dd5e7c75d7b ("block: add helpers to bounce buffer an iov_iter into bios")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 block/bio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index f2a5f4d0a967..5ac954c70dd0 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1285,7 +1285,8 @@ static struct folio *folio_alloc_greedy(gfp_t gfp, size_t *size,
 	struct folio *folio;
 
 	while (*size > minsize) {
-		folio = folio_alloc(gfp | __GFP_NORETRY, get_order(*size));
+		folio = folio_alloc(gfp | __GFP_NORETRY | __GFP_NOWARN,
+				    get_order(*size));
 		if (folio)
 			return folio;
 		*size = rounddown_pow_of_two(*size - 1);
-- 
2.54.0

