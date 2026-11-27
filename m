Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770587;
	b=0g13qjXFbvMQOOAYHDsBGWWwuy0yjay6E4QysO5H6Y7llayjZGpH4mhQRK8jpEJaWq7C
	 dhwspHLI9Hu6UGkt3dTe6BSU/Yw/PQJDZmzpE3JVL+b4ZV+/WcqVs3luXSZiebFxaUtec
	 JUxOgGnoK8ybgiWEgABcibqg6BfUIOtgNbaUiPH4yjL8tBWQBYGMWLWSVffN/1UqmjMGI
	 8tUSAR/4/OLMnty/SYlzDn2PLVOfquGW0MTOcBvglPC9vt5+RGErDGnZ7lTOfx42Hn3C3
	 qk+STdZVy88BEMjBMCNDl2xTHbq9CW4fR+8CnR4cuOQJqDiJ/WfS3F464XudA0wCM/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770587;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=QrnO63YMlwPCWlZ9s1b3sNtshT1btT4grgWOHVp4EB8=;
	b=MTab+rwCmgJmYMWDvh647ik7EItp/wiuN8rbVxo6zgbCOE2rDKWD/NW+OgI6ejbSKMUk
	 PsiDnktEgc4XUwo9ZH7nH07qo0pMZ9QbhayFFQRUPQ++xiSs9kZHiV5nKz4i9K6ivEGyK
	 5TFDX1Q9jbUd9+niWHJw0PGmjjhlQuZ9Th90cPRWZBqtfYaMidK8E7AQONdzVDPdy1Cns
	 8cjYtm3VQv4MtTqEss1J0jJsKZcqa7r9117i21Cvyz9BSKDEKG10wocrUcJK3+a5PbG6r
	 ao/dgpMxFEhdi+g6bbb0750BErb6iOyhMiMAMN1TJ+Mf3XVUDulecYCQuWiqNAsnoTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=XeuRYBPQ;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=XeuRYBPQ;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771C3606A31E
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 771C3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=XeuRYBPQ;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=XeuRYBPQ
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 17832227F2
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795770579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QrnO63YMlwPCWlZ9s1b3sNtshT1btT4grgWOHVp4EB8=;
	b=XeuRYBPQAjEPc0oJMG2N35S+c+6RohOsV/fHEbbmuNrxB5+dygzvNrCFi6J0a3lPgrVr6z
	Oj3PGC/CazfheZnyuuuhnaVN6PIJjzircTt6pIo/6wN8Uc0PwuQ3B21Au7cmg14B1ODFdm
	hZ4rD+V7nlM6tJQURUh2B86qGGziNoc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795770579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QrnO63YMlwPCWlZ9s1b3sNtshT1btT4grgWOHVp4EB8=;
	b=XeuRYBPQAjEPc0oJMG2N35S+c+6RohOsV/fHEbbmuNrxB5+dygzvNrCFi6J0a3lPgrVr6z
	Oj3PGC/CazfheZnyuuuhnaVN6PIJjzircTt6pIo/6wN8Uc0PwuQ3B21Au7cmg14B1ODFdm
	hZ4rD+V7nlM6tJQURUh2B86qGGziNoc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F33F7134E8
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KmCXKM9ICWu6BwAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/3] btrfs: fix an ASSERT() race with async csum generation
Date: Fri, 27 Nov 2026 19:39:15 +1030
Message-ID: <f513d23254f26c0ec02e5fcc58bafa0e7c1e31b4.1795770362.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <cover.1795770362.git.wqu@suse.com>
References: <cover.1795770362.git.wqu@suse.com>
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
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,sashiko.dev:url];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

If CONFIG_BTRFS_EXPERIMENTAL is enabled, btrfs will submit a data write
bio before its checksum can be generated.

However this introduce a race with zoned devices that can trigger the
ASSERT() inside csum_one_bio_work():

 CPU0                            | CPU1 (kworker)
 --------------------------------+-----------------------------------
 btrfs_submit_chunk()
 |-btrfs_bio_csum()
 | \-btrfs_csum_one_bio()
 |   \-queue_work(..., &bbio->csum_work)
 \-btrfs_submit_bio()
   \-btrfs_submit_dev_bio()
     |-bio->bi_opf &= ~REQ_OP_WRITE;
     |                             csum_one_bio_work()
     |                             \-ASSERT(btrfs_op(&bbio->bio) ==
     |                                      BTRFS_MAP_WRITE);
     |                               ^^^ sees REQ_OP_READ (0), BUG()
     \-bio->bi_opf |= REQ_OP_ZONE_APPEND;

Fix it by moving the ASSERT() into btrfs_csum_one_bio(), so at that time
the bi_opf is not yet updated and can always be trusted.

Fixes: dd57c78aec39 ("btrfs: introduce btrfs_bio::async_csum")
Link: https://sashiko.dev/#/patchset/cover.1794261158.git.wqu%40suse.com
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/file-item.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index ff8f8cad00fc..e19d4c1c754a 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -807,7 +807,6 @@ static void csum_one_bio_work(struct work_struct *work)
 {
 	struct btrfs_bio *bbio = container_of(work, struct btrfs_bio, csum_work);
 
-	ASSERT(btrfs_op(&bbio->bio) == BTRFS_MAP_WRITE);
 	csum_one_bio(bbio);
 	bio_endio(&bbio->bio);
 }
@@ -824,6 +823,8 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
 	struct btrfs_ordered_sum *sums;
 	unsigned nofs_flag;
 
+	ASSERT(btrfs_op(&bbio->bio) == BTRFS_MAP_WRITE);
+
 	nofs_flag = memalloc_nofs_save();
 	sums = kvzalloc(btrfs_ordered_sum_size(fs_info, bio->bi_iter.bi_size),
 		       GFP_KERNEL);
-- 
2.56.1

