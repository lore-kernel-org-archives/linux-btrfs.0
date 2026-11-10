Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794291176;
	b=NZ1Qnsm4giKN/bsuZ4PQpVPVKnvbjfjdeJOTszBsd/nOse22s+a4pE7kUZvKE7h2i2Mi
	 H1I8qeoNt1mBuUgQRXkUfjvK2B1T1bARm5IDDLsnEB47Xm9Uo1Cl7e+zpbu2w14YO6fSQ
	 ipSZx2dczF872j4q6guIpEAW9YyA5eACZPj9wbeS1t9ZjxJZntXLOA2kZgLRGJ/fky+/K
	 t2y5aFZr7Oov8NsZejOVhV/Y2dsjCJfa6F5DeZm1Dc8XWQiUoENJV6jNOG+HS2iMhrAaG
	 +XHikC/XVdwMA695BBtbG6SdPKnIpFcgf+qjRqnklxfYAr7R1NMNwWr2Y0mXQCodJog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794291176;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=IQ1/O29RWR8qaJV77ybHSat/5gaBVGe5r61j/pwqeaM=;
	b=owZUFRmlWKhzOxHuMqkz+e4/3Qs5+TRBh3whTzM3wYKhPSoQVMCYGs1AA10YWtKGxpX7
	 UtLMAj52J1ahMSvzxjiJ59jyhHYNpQ9eH0nx0cTZgqLtOXbBPOa7DD/Pua7eX11pNSvD2
	 0j5jxx7g1Hwle1eymEon1+E39ftsWTrBfcY5MHUXtppWStAuk8ljstnwpZ20evz55hwQV
	 wSKbFljZqxQOVm3J2ErPDUV5m7DkwOK+/BvRpy99lu0rVIPcrNb8GjiKgE1j/FNKHp3LN
	 ZbL3C64IpbJ5yY/t4xBRW1YY2lw9P8yVTfUtJmDz9xvsxHNc4vzHMyBFeXjZ/dk6Qzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=tzK7UHAK;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=tzK7UHAK;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210CE606A321
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:12:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 210CE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=tzK7UHAK;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=tzK7UHAK
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 56D981F441
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794291174; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IQ1/O29RWR8qaJV77ybHSat/5gaBVGe5r61j/pwqeaM=;
	b=tzK7UHAK8SGAKvm58OS8iDa/puHGP/y/axRJ/kQ5XQvmHyO2fZ/D/d0NqKtqX+Vrifr8Za
	2+1nF3c8s5ZTPHPHW8X8Em6NvUGtRYrbH4NViilHd8OWn28aGBorgcwaLjPAppKxm2zT00
	sVv734BHrE8vG0m7KsJvbcGghBCH60Y=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=tzK7UHAK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794291174; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IQ1/O29RWR8qaJV77ybHSat/5gaBVGe5r61j/pwqeaM=;
	b=tzK7UHAK8SGAKvm58OS8iDa/puHGP/y/axRJ/kQ5XQvmHyO2fZ/D/d0NqKtqX+Vrifr8Za
	2+1nF3c8s5ZTPHPHW8X8Em6NvUGtRYrbH4NViilHd8OWn28aGBorgcwaLjPAppKxm2zT00
	sVv734BHrE8vG0m7KsJvbcGghBCH60Y=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3745413479
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:12:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id no3bCeG18mreJQAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:12:52 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/4] btrfs: fix an ASSERT() race with async csum generation
Date: Tue, 10 Nov 2026 16:42:25 +1030
Message-ID: <d4df77a622e06440903e71d07276791e00393056.1794290876.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794290876.git.wqu@suse.com>
References: <cover.1794290876.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 56D981F441

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
2.56.0

