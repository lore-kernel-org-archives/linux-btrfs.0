Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792662001;
	b=f/sz6vszBuw0v0hyTbGbpi/B7v4kyjyImQjr2G63f3laW4NAMQqw64HebH07VUg08ycW
	 CAwBgd6rnqoKqDx3f1fa2hohjyI7/9zHdwXajT3vtE6BFPUOeX0G1FJas6obYj0G1QV3x
	 QfOwjkYsmsZVynpV5HUX6bWWDxl90SV5uMew1OHc1Sy6H2CBFisg1iCTYjhOXW5WW8uk1
	 65M9fnv4nvjADD/avYsvPCvN7+INibRyMrLZ8lfCdPrSoXVfR3Kpz3PH/dlAad2gbUDR2
	 yp5FgSxn7Hv1o1ikRBahM0pwBmF5/Q1eyMaK31P/Oj2bV9MUb8BPXseriZRRtDPGu0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792662001;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=pqJ/c+ad9IdCo9/ZdHN4WoMYymoGlIruXnklcNpM6Qc=;
	b=h6QVShTNgxe1usV+qD4G4MjEL7WdCoxAMgLx05oGusyibqMJSFP1VtCGZma2pio7HKSg
	 XnXmhK43GXaFjJTSJO2ZfSI8xOVPk7LIpjnsr/ZUN1vx/47wsKT1rCsIQ8y3B8xWAXBHZ
	 nEBx/lprmwoUZq9uFSL3GIXTdKTOF6odjPjEu7vKAhCbd+eBtf/ENQsF/K44ZW9lYgW9w
	 T8p0yaQTYKR0Adj+9ECyUBXU/l7F7w9cl52BXGw3Uxd21oBr8FvGOddr7IBaH0Csb40R1
	 rnhLOZiTXNBnLy80zMrntRgCUIy/GPK2ABnA8gIjdgeA/GDOm3WHP63UjgdCylYGn6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=o2MmsmIO;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=o2MmsmIO;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1993B60A2626
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:40:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1993B60A2626
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=o2MmsmIO;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=o2MmsmIO
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 486F11FCD5
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792661998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pqJ/c+ad9IdCo9/ZdHN4WoMYymoGlIruXnklcNpM6Qc=;
	b=o2MmsmIOo3QV5B3Fu1GTcAwCGDuJJjGWT8Nri4kGwvlZOXOK4QSjNnzgW2MfgMQAsRE6L/
	//I525pGnbzeNhke3tumKpITsWDzgqQrrRq9coHo3o38Ge6ObYLfjybQp2AwJ1sPDwTqfR
	mxGkMmxsgqyeaHF1lpvHQeZZsWdHhg4=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=o2MmsmIO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792661998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pqJ/c+ad9IdCo9/ZdHN4WoMYymoGlIruXnklcNpM6Qc=;
	b=o2MmsmIOo3QV5B3Fu1GTcAwCGDuJJjGWT8Nri4kGwvlZOXOK4QSjNnzgW2MfgMQAsRE6L/
	//I525pGnbzeNhke3tumKpITsWDzgqQrrRq9coHo3o38Ge6ObYLfjybQp2AwJ1sPDwTqfR
	mxGkMmxsgqyeaHF1lpvHQeZZsWdHhg4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2FDD7134E9
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sUAVLufZ2Wp7dQAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 09:39:56 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: add stripe_len < PAGE_SIZE support for alloc_rbio_*_pages()
Date: Thu, 22 Oct 2026 20:09:29 +1030
Message-ID: <537e80067fc55362a47b06404295b7777c0c27b6.1792661955.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792661955.git.wqu@suse.com>
References: <cover.1792661955.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 486F11FCD5
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
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
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.01

The functions alloc_rbio_parity_pages() and alloc_rbio_data_pages()
didn't support stripe_len < PAGE_SIZE cases, and fallback to
alloc_rbio_pages() instead.

That's mostly to avoid the case where both data and P/Q blocks can exist
in the same page.

However even in that case, it's not a big deal, the existing
infrastructures like index_stripe_sectors() can handle it correctly.

Update those functions to support stripe_len < PAGE_SIZE cases, with two
points to note:

- Extra atttention needed for the round direction
  For alloc_rbio_data_pages() we need to round up, so the last data page
  gets allocated.

  For alloc_rbio_parity_pages() we need to round down, so the first
  P/Q page get allocated.

- Mixed page allocation
  We can call alloc_rbio_parity_pages() first, then
  alloc_rbio_data_pages().

  In that case, it's alloc_pages_bulk() saving us, which always skips
  allocated slot. Thus we're still safe.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/raid56.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index c81f7a0297e4..7dd937fa0c26 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1061,22 +1061,21 @@ static int alloc_rbio_pages(struct btrfs_raid_bio *rbio)
 	return 0;
 }
 
-/* only allocate pages for p/q stripes */
+/*
+ * Allocate pages that cover P/Q blocks.
+ *
+ * For stripe_len < PAGE_SIZE case, we can allocate a page that cover both
+ * data and P/Q blocks.
+ */
 static int alloc_rbio_parity_pages(struct btrfs_raid_bio *rbio)
 {
-	int data_pages;
+	const unsigned int first_pq_page = round_down(rbio->nr_data *
+					rbio->bioc->stripe_len, PAGE_SIZE) >>
+					PAGE_SHIFT;
 	int ret;
 
-	/*
-	 * Page size larger than stripe size, we can not only allocate
-	 * pages for P/Q stripes.
-	 */
-	if (rbio->bioc->stripe_len < PAGE_SIZE)
-		return alloc_rbio_pages(rbio);
-
-	data_pages = rbio->nr_data * (rbio->bioc->stripe_len >> PAGE_SHIFT);
-	ret = btrfs_alloc_page_array(rbio->nr_pages - data_pages,
-				     rbio->stripe_pages + data_pages, GFP_NOFS);
+	ret = btrfs_alloc_page_array(rbio->nr_pages - first_pq_page,
+				     rbio->stripe_pages + first_pq_page, GFP_NOFS);
 	if (ret < 0)
 		return ret;
 
@@ -1653,13 +1652,10 @@ static void submit_read_wait_bio_list(struct btrfs_raid_bio *rbio,
 
 static int alloc_rbio_data_pages(struct btrfs_raid_bio *rbio)
 {
-	int data_pages;
+	const unsigned int data_pages = round_up(rbio->nr_data *
+			rbio->bioc->stripe_len, PAGE_SIZE) >> PAGE_SHIFT;
 	int ret;
 
-	if (rbio->bioc->stripe_len < PAGE_SIZE)
-		return alloc_rbio_pages(rbio);
-
-	data_pages = rbio->nr_data * (rbio->bioc->stripe_len >> PAGE_SHIFT);
 	ret = btrfs_alloc_page_array(data_pages, rbio->stripe_pages, GFP_NOFS);
 	if (ret < 0)
 		return ret;
-- 
2.56.0

