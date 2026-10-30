Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333755;
	b=hknME9hfaC8UcrFRP2DggqP3uWX5LcUsM/rZUfP721oUNpg6RF+PeiV6V5MuZPEIZZis
	 S5m1wB2mBejPaHxLtkfnNhKii8DiZDeGlgG+/LFjPEAoFXSxwUbqLqMHmUq2gD585DuiC
	 Mls7bNPId9GKyJbVPMalvbTLRsfAuxTlsYP0TuZ6d1ID32hZqbqchUYo5dDhIHhOgPKeM
	 IIP9b2HD3nlRlPS2tMe0gjfo9UWz0K1j0Q15IcBvRP4ClrOcCOOjULNM8ESl1bMf+2ehQ
	 cBhoP2p9bccKy/a/ICK1zZbputo4m/VSmY836C6txiwYtQgsDmrOpqGWvPOLcdSpjTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333755;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=ziHR8iOcRkZnILDHku94xvRSbPkrox1TzgxHyy8koM4=;
	b=2yRGU13LmE4pvOH/lzvOCGdoJqR+9Id7lf/ch7q5mWipWv6+43SrPPojGK6R5OlGxRf6
	 OhuXrM/R/S4N3oiGIYoqag04QmzF94b2DeS+z/jAmwBKKZXpDtxxcB0opFIIMqywkngaZ
	 dc/aeaHhxgiOuJ9A3i8if0uZw8udtO1Z81zZu1hLHTCs20wrqHLvFL4MBBMmr8sNFYsmD
	 AssGKiTcneZzjuy1AJaoNgq9PNZVR0/dCKbaTbJs4W+/HfHW9MxTqrb3yOEG6m3WI8j7+
	 25NwIgUZ2PICOhPbCafWdrKLN9DfjF6t7iJQ7j7CaOUv+uA8LnCieeZf5SoV2RU8knQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=J5s3dKID;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=J5s3dKID;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617D6606A322
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 617D6606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=J5s3dKID;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=J5s3dKID
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BEC471FCFA
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ziHR8iOcRkZnILDHku94xvRSbPkrox1TzgxHyy8koM4=;
	b=J5s3dKID20rcBnUpmepPtV4XZm97KOMPO16/fhTus3c5iljo2ptl7U+ItDTQqj5+ScIsRC
	LlIAQZW89UTeEB12j9jSNdvkxT4UPSvj9pdkRiNla2+rnUHnGwV9kCFkoc0r4PHtYAuZZa
	bq7jo2/QB09bBwe7LmNSJoayb1sRwn0=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ziHR8iOcRkZnILDHku94xvRSbPkrox1TzgxHyy8koM4=;
	b=J5s3dKID20rcBnUpmepPtV4XZm97KOMPO16/fhTus3c5iljo2ptl7U+ItDTQqj5+ScIsRC
	LlIAQZW89UTeEB12j9jSNdvkxT4UPSvj9pdkRiNla2+rnUHnGwV9kCFkoc0r4PHtYAuZZa
	bq7jo2/QB09bBwe7LmNSJoayb1sRwn0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE9E713432
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0uAiEekZ5GrDGwAAD6G6ig:T10
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:52 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/12] btrfs-progs: check: fix fixup_extent_flags() retry path
Date: Fri, 30 Oct 2026 14:45:16 +1030
Message-ID: <f6a6419ea42eb942bc31deeb5ce60012da21b9a3.1793333606.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793333606.git.wqu@suse.com>
References: <cover.1793333606.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
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

If the skinny metadata item can't be found, fixup_extent_flags() jumps back
to the retry label to search for the non-skinny extent item.

But this retry path has two problems:

- The path is not released before the next search
  Thus the tree blocks held by the path are leaked.

- A new transaction is started while the previous one is still running
  btrfs_start_transaction() refuses to start a transaction over an
  already running one, thus the retry always fails with -EINVAL.

Fix both by starting the transaction before the retry label, and releasing
the path before jumping back.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/check/main.c b/check/main.c
index b3641cd39169..194d04ce017f 100644
--- a/check/main.c
+++ b/check/main.c
@@ -7963,6 +7963,14 @@ static int fixup_extent_flags(struct extent_record *rec)
 
 	if (!btrfs_fs_incompat(gfs_info, SKINNY_METADATA))
 		metadata_item = false;
+
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		errno = -ret;
+		error_msg(ERROR_MSG_START_TRANS, "%m");
+		return ret;
+	}
 retry:
 	key.objectid = rec->start;
 	if (metadata_item) {
@@ -7973,14 +7981,6 @@ retry:
 		key.offset = rec->max_size;
 	}
 
-	trans = btrfs_start_transaction(root, 0);
-	if (IS_ERR(trans)) {
-		ret = PTR_ERR(trans);
-		errno = -ret;
-		error_msg(ERROR_MSG_START_TRANS, "%m");
-		return ret;
-	}
-
 	ret = btrfs_search_slot(trans, root, &key, &path, 0, 1);
 	if (ret < 0) {
 		btrfs_release_path(&path);
@@ -7989,6 +7989,7 @@ retry:
 	} else if (ret) {
 		if (key.type == BTRFS_METADATA_ITEM_KEY) {
 			metadata_item = false;
+			btrfs_release_path(&path);
 			goto retry;
 		}
 		fprintf(stderr, "Didn't find extent for %llu\n", rec->start);
-- 
2.56.0

