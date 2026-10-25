Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917744;
	b=nPSQIFIiLf8OMd983fNdzPxuh81njeDiWCr8eWZnId4hw5czDE6Fhf9MmjIdnCAOztLi
	 kqfeXQ8pUBsv+HrLgrIYvqBwFSNOQcBtnYx94vr291ESCd98SHRJAcgupFWFr2LPNGRFq
	 BkIrVEpmuYkif8XmalAVN/H69ZAtvknvrBY3Fs3ruq6+puh4gAzYLVLuqK+lp/8h+eqsW
	 UsRTBKV/jtHPMLrPjVdhLzxgkseFm1omRLwZJ2B2OSNgf53W1sbSFztNuhThHnqsLblUq
	 jeL3+ontrqbUyJLUtj45xgzT9efW6JoN8bD2OX8BHlLHAlFFdcj5JYzITu+dzlJsRzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917744;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=MwhxpCEq0HVclgIlvvHTY3YMRlF4miDFpY6qJFFcUxE=;
	b=vU4g5WPnKkVZ+cywGnlFejmZVRBxNfpXjfyJS+sygtOBHocWVtJhe/JPGUM6DxrOeVQN
	 wU9rRZ0MdKMLBgVJbQVTb7WAvcKeYXgcpbHmhmxeKSV3N7yBXFORP68J02ZoMY9zCstuI
	 khIcZMgjuHnSZoqJPN1wJ5l3c8lvwBOtDQ7H+HibbCym48+XK0XkCDrbfJQJgu6Oj7fwH
	 lxV2OZ2GWyrMZSkAwPmetX3Fn6LpoCKokIvmoznKnEBN9n8SbAGyfucLtZwPC6mP/Ny4+
	 281N6keDVKm8C0kl4wC42s+V23Fe0ngtoSqQft5F9dhjiq6UsYda1rea9gWSc6otV3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ZJrajwES;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ZJrajwES;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7EF606A31E
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D7EF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ZJrajwES;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ZJrajwES
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9BCD61F38A
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MwhxpCEq0HVclgIlvvHTY3YMRlF4miDFpY6qJFFcUxE=;
	b=ZJrajwESSTSrRKjDQO/XLJj/cAKeeIZMStfzdzfEBTJRFk7fHM48VxLAMYJ8yjWAGtFb7u
	47nNUbVh6ptlkdHYRmwFYmf4GwhXIAERf8foTrH29IXL51wrQTUBs0W31M3V49Flp+BjFs
	lcrLwZDQcRuBLXBNjUATvfqOR6JQnYk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MwhxpCEq0HVclgIlvvHTY3YMRlF4miDFpY6qJFFcUxE=;
	b=ZJrajwESSTSrRKjDQO/XLJj/cAKeeIZMStfzdzfEBTJRFk7fHM48VxLAMYJ8yjWAGtFb7u
	47nNUbVh6ptlkdHYRmwFYmf4GwhXIAERf8foTrH29IXL51wrQTUBs0W31M3V49Flp+BjFs
	lcrLwZDQcRuBLXBNjUATvfqOR6JQnYk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 84DFF13314
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mglvH9zA3Wq5HgAAD6G6ig:T11
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:21 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/12] btrfs-progs: image: validate the nritems before reading the content
Date: Sun, 25 Oct 2026 19:11:44 +1030
Message-ID: <70bed4ad16d48a0a5fa5a90badd6bd96b9c4aa41.1792914402.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792914402.git.wqu@suse.com>
References: <cover.1792914402.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

When iterating a header, we read out one 1KiB buffer, then grab the
cluster->header->nritems to grab the number of items stored in the 1K
block.

However if a corrupted or maliciously crafted header is passed in, we
can easily grab a huge number as @nritems, and easily go beyond the 1KiB
buffer.

Fix it by rejecting obviously incorrect nritems before iterating, this
involves 3 call sites:

- build_chunk_tree()
- search_for_chunk_blocks()
- add_cluster()

Assisted-by: LLM (exposing the bug)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/image-restore.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/image/image-restore.c b/image/image-restore.c
index 3f2a7fcf797c..525cdd4d32bc 100644
--- a/image/image-restore.c
+++ b/image/image-restore.c
@@ -1030,6 +1030,12 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres)
 
 		bytenr += IMAGE_BLOCK_SIZE;
 		nritems = get_unaligned_le32(&header->nritems);
+		if (nritems > ITEMS_PER_CLUSTER) {
+			error("invalid nritems, has %u expect <= %zu",
+			      nritems, ITEMS_PER_CLUSTER);
+			ret = -EUCLEAN;
+			goto out;
+		}
 
 		/* Search items for tree blocks in sys chunks */
 		for (i = 0; i < nritems; i++) {
@@ -1138,6 +1144,11 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 
 	mdres->compress_method = header->compress;
 	nritems = get_unaligned_le32(&header->nritems);
+	if (nritems > ITEMS_PER_CLUSTER) {
+		error("invalid nritems, has %u expect <= %zu",
+		      nritems, ITEMS_PER_CLUSTER);
+		return -EUCLEAN;
+	}
 	for (i = 0; i < nritems; i++) {
 		item = &cluster->items[i];
 
@@ -1316,6 +1327,11 @@ static int add_cluster(struct meta_cluster *cluster,
 
 	bytenr = get_unaligned_le64(&header->bytenr) + IMAGE_BLOCK_SIZE;
 	nritems = get_unaligned_le32(&header->nritems);
+	if (nritems > ITEMS_PER_CLUSTER) {
+		error("invalid nritems, has %u expect <= %zu",
+		      nritems, ITEMS_PER_CLUSTER);
+		return -EUCLEAN;
+	}
 	for (i = 0; i < nritems; i++) {
 		item = &cluster->items[i];
 		async = calloc(1, sizeof(*async));
-- 
2.56.0

