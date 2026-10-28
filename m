Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793169071;
	b=t9JbyT/Duo2PYPx06K9W3BAFvyjEnkvOxBNulc08X+tBba/tdCFWiV9UEDPYY3w+iCaw
	 RYRw8+/A+6NxrxCdPQyLVMkPbj0XOZJQlMYojDjzHaShYeXy5O4eIrvk8qKyr3SV0tvb7
	 UK87gjHlnWOpS2U2V2QhYuCKV2tC5TTIH42ksvAIBOJkMI1B/7dUe5fSPF/9sKgutj1a6
	 cPSA/NsBO4uR1vhhHWCTME6CpLCrm4EN5DIdvDH3Tq6DasB2Ko0IOVrvq6RdT1hIuB40X
	 355LWPZQtR7yZub2yiNBG+oML2BjoFg5nAC4GdtAysa+xuCbs0AXM9u71F1zDadLQgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793169071;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=cCJTZFBkm1SFHLBH85GkEUclWzgJq9HcvQiTOd2uu+g=;
	b=FLtbR8R1xYoJZMtqPa2NbZkO9Rl091c5jSmaa5nl+n3015yoFRj0UUqFVQIaZS+1OqCC
	 51J2hdTjnbnvV5rzI1Z5fhM0oW4Qslh1aGvATgJvwiSBnFgXN+bi0xQ8TZhy6awvQDgrp
	 lRj9dwD3hCacojLksDu5r91IWP03Pv4gRb7uWK6VU3SuvM8kvpyB/cLgZBMGeDwdw4SO1
	 oO/qzhKEenzPQ/8yEE3FN3RmTzQwZMK8cDiIteFga2b3TJxEF2EfQ2O0rGeeW5W6YLKTH
	 kBP+ZZ0P0LMoWuvPtg0Eo2fjN7KIUcTFSYkn+Q57BMK0YCrvMG6sYcp68EMPA/kd56w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=P26dOXQF;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=lgTl8Img;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCFA606A320
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:31:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADCFA606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=P26dOXQF;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=lgTl8Img
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EC29F220F3
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793169069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cCJTZFBkm1SFHLBH85GkEUclWzgJq9HcvQiTOd2uu+g=;
	b=P26dOXQFNvI1TxkYaULPWR+cXu7wOVfAfYSBvonEMnsoHq5bnvnLbjkbUizMVgRiBLEaZq
	IGDxj0mAxiCkpPYrKoiFllpCRsyxyiJq2Se6qYR02EA8gRLD6e8WfdzB2mnNe2YaoUruaz
	q2ha0pSHUkKBqZG0A8ne5RU9acSBv1M=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=lgTl8Img
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793169068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cCJTZFBkm1SFHLBH85GkEUclWzgJq9HcvQiTOd2uu+g=;
	b=lgTl8ImgtE8srUG7nDzvg1cLowuAfb07yhGYS4sLQY1Qe+m65qTYWhN9ZkhxUKwKwapON+
	s+a5KfGQzg0SQxOV9fVpraNc4FTdYSV2MHa9IeOpzvT656cRNXf/6G4cEQiCUQb+4x/WMi
	ZNzUrYjEFBf5SBqxuxv6JJ+n+bOHg6w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D090E13419
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:31:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NOeGHKmW4WoiBwAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 06:31:07 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix racy bio_list changes for failed RMW rbio
Date: Wed, 28 Oct 2026 17:00:46 +1030
Message-ID: <5a11091a4fb79de6a37bcec6c70b178467641f28.1793168898.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793168898.git.wqu@suse.com>
References: <cover.1793168898.git.wqu@suse.com>
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCPT_COUNT_ONE(0.00)[1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: EC29F220F3

If an RMW work failed early, e.g. alloc_rbio_parity_pages() failed, it
won't get RBIO_RMW_LOCKED_BIT set, and get rbio_orig_end_io() called.

In that case, there can be a race between bio_list_get() on the rbio,
and new incoming bio merging into the rbio:

 A is the rbio that rbio_orig_end_io() is running on.
 a is the higher layer bio that generated the rbio A.

 B is the new rbio that will be merged into A.
 b is the higher layer bio that generated the rbio B.

   rbio_orig_end_io(A) worker         |       lock_stripe_add(B)
--------------------------------------+---------------------------------
rbio_orig_end_io(A)                   | lock_stripe_add(B)
|- cur = bio_list_get(A)              | |- rbio_can_merge(A, B)
|  |- bio = A->bio_list.head;         | |  which returned true
|  |  which bio a is returned.        | |
|  |                                  | |
|  |- A->bio_list.tail = NULL;        | |
|  |                                  | |
|  |                                  | |- merge_rbio(A, B)
|  |                                  | |  |- bio_list_merge_init()
|  |                                  | |     |- if (A->bio_list.tail)
|  |                                  | |     |  A->bio_list.tail is
|  |                                  | |     |  still NULL
|  |                                  | |     |
|  |                                  | |     |- A->bio_list.head = b
|  |                                  | |     |- A->bio_list.tail = b
|  |- A->bio_list.head = NULL;        | |- return 1;
|  |- return bio;                     |    Caller expect rbio A to
|     which is bio a.                 |    complete bio b.
|
|- extra = bio_list_get()
|  Which is NULL
|
|- rbio_endio_bio_list(cur);
   Which only ends bio a.

In above case, the bio_list race can get bio b lost, and never ended.
Thankfully this race window is very tiny, so not practical in the real
world.

Fix it by setting RBIO_RMW_LOCKED_BIT for error path before calling
rbio_orig_end_io().
And since we're ensuring all RMW rbios have RBIO_RMW_LOCKED_BIT bit set
before calling rbio_orig_end_io(), add two ASSERT()s for that and remove
the old comment.

Fixes: 5eb30ee26fa4 ("btrfs: raid56: introduce the main entrance for RMW path")
Assisted-by: LLM (find and analyze the bug)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/raid56.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 7dd937fa0c26..b24ec362909b 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -874,7 +874,10 @@ static void rbio_endio_bio_list(struct bio *cur, blk_status_t status)
 static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t status)
 {
 	struct bio *cur = bio_list_get(&rbio->bio_list);
-	struct bio *extra;
+
+	/* An RMW rbio must have RBIO_RMW_LOCKED_BIT set. */
+	if (rbio->operation == BTRFS_RBIO_WRITE)
+		ASSERT(test_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags));
 
 	kfree(rbio->csum_buf);
 	bitmap_free(rbio->csum_bitmap);
@@ -888,21 +891,11 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t status)
 	 */
 	bitmap_clear(&rbio->dbitmap, 0, rbio->stripe_nsectors);
 
-	/*
-	 * At this moment, rbio->bio_list is empty, however since rbio does not
-	 * always have RBIO_RMW_LOCKED_BIT set and rbio is still linked on the
-	 * hash list, rbio may be merged with others so that rbio->bio_list
-	 * becomes non-empty.
-	 * Once unlock_stripe() is done, rbio->bio_list will not be updated any
-	 * more and we can call bio_endio() on all queued bios.
-	 */
 	unlock_stripe(rbio);
-	extra = bio_list_get(&rbio->bio_list);
+	ASSERT(bio_list_empty(&rbio->bio_list));
 	free_raid_bio(rbio);
 
 	rbio_endio_bio_list(cur, status);
-	if (extra)
-		rbio_endio_bio_list(extra, status);
 }
 
 /*
@@ -2464,6 +2457,21 @@ static void rmw_rbio(struct btrfs_raid_bio *rbio)
 		}
 	}
 out:
+	/*
+	 * If we hit an error early, the rbio won't get
+	 * RBIO_RMW_LOCKED_BIT bit set, and can cause unexpected
+	 * merge during rbio_orig_end_io().
+	 *
+	 * So set that flag before calling rbio_orig_end_io(), and
+	 * we have to hold the bio_list_lock, to make sure
+	 * rbio_can_merge() and merge_rbio() are seeing a stable
+	 * flag.
+	 */
+	if (ret < 0) {
+		spin_lock(&rbio->bio_list_lock);
+		set_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags);
+		spin_unlock(&rbio->bio_list_lock);
+	}
 	rbio_orig_end_io(rbio, errno_to_blk_status(ret));
 }
 
-- 
2.56.0

