Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917743;
	b=uezZADgSv4pYWYV0tLi8BnY5n7vgve4JnUwOsZL4G+RzOao6l+xoPQ45hLbTFmQrS4Jx
	 c0Knt/FzynGUzRJpA27+EEufMAZcgM41QjUB6rHgnIQ8o85fvBk/kpkBxV3KZ4SQqtf6a
	 qSr++eq9rA2FtRtE1cyJ/ZIJgeYR4pdvKxgMSu1aIFxCjc/GHJ9F4owGh0EzsE7gkicj/
	 oTv0PRx3LqSOEikwm1qZIr5l4VVN27/j4w1Hti+w5hJJ0Ws33tWhJ4HoTBATDVAQx2Doe
	 mhTyYFbl/2ltpep7FL9PXd1kHHXaH9prVHlBP+s1rmuif79VctiOKyMkyAUC5G4u8vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917743;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=8+WaKHQfuI6LEJ3DwFqPybAbvLLVJX9Uwl8Rt59is50=;
	b=qV4uLmagtxNAmOOSyxjm9e0qg5T/b0nL1vcQINhwCemniQYDml8tvsJbyPufizOg2uIh
	 dSnO2QItmDZnlvtRxqjIQns7tXcvUKG+Z1so6srwXExwuTwJhj2DOwnvkHut1Nnpau4i8
	 xNYJyRN8oz+HznZhRczdRL8qn7HfmcMMwZ1T7wtpKObVjJucZlI2UIhPcDqv7wQeQjSzC
	 uBvf0anFlTs8oR7qqtnGK+ZPQAUeQyfH3Csjqeo0sRqnsAhADYRqMYaVpGGsx9wsrDtsr
	 EQyESR/G9J2pZn+k+yIdC1WWGd/ugkHWjejhW3FtK0GWVThqzI2LZQI3BpbvitSlOKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=AzzGhUw5;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=D3ka4HP5;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C95606A31A
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88C95606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=AzzGhUw5;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=D3ka4HP5
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F3DE022252
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8+WaKHQfuI6LEJ3DwFqPybAbvLLVJX9Uwl8Rt59is50=;
	b=AzzGhUw50Zyg7a5si+Lom1f6RpBViRqDMOjteMHbg7EOzOV8mqc0fNbWoXbajXrrBQKjmK
	M+HARU91S5EQH16lYWCJDzd+JhCCTy7K5L1jtuvPED6MufcvCDEFf8noktbu6viZYe1z45
	M5giNlNg/xofE8EeEPjku+lU2R+O2hE=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=D3ka4HP5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8+WaKHQfuI6LEJ3DwFqPybAbvLLVJX9Uwl8Rt59is50=;
	b=D3ka4HP5YYk4cZZ8Yw3tC/g7J7wGjPkDTRsUsIjeGkUj0RG6Rqvg0H0JZanrfKrSRfk7w9
	/SMst9w4FylIqwhT1NXQPAY5OIWueEhe4DA45jV0Ntjm9HSH+b/oC04UEYJKGGC7RqMDY/
	YqJriVVDMQtweRZ8pqWs4nc904fAcqw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE69E13314
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mglvH9zA3Wq5HgAAD6G6ig:T10
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:19 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/12] btrfs-progs: image: fix overwritten ret in restore_metadump()
Date: Sun, 25 Oct 2026 19:11:43 +1030
Message-ID: <513c0c3dcc4813415afb2b58060c24febb4a3fd3.1792914402.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: F3DE022252
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
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

In the "while(!mdrestore.error) {}" loop if we got a bad header or
add_cluster() failed, we break the loop.

But immediately after breaking out the loop, we call wait_for_worker(),
which overwrites @ret, and also continue to open_ctree().

Fix the problem by directly jumping to out label.
Also for bad header case, update the error code to -EUCLEAN.

Assisted-by: LLM (exposing the bug)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/image-restore.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/image/image-restore.c b/image/image-restore.c
index 4929beeb697e..3f2a7fcf797c 100644
--- a/image/image-restore.c
+++ b/image/image-restore.c
@@ -1852,13 +1852,13 @@ int restore_metadump(const char *input, FILE *out, int old_restore,
 		if (get_unaligned_le64(&header->magic) != current_version->magic_cpu ||
 		    get_unaligned_le64(&header->bytenr) != bytenr) {
 			error("bad header in metadump image");
-			ret = -EIO;
-			break;
+			ret = -EUCLEAN;
+			goto out;
 		}
 		ret = add_cluster(cluster, &mdrestore, &bytenr);
 		if (ret) {
 			error("failed to add cluster: %d", ret);
-			break;
+			goto out;
 		}
 	}
 	ret = wait_for_worker(&mdrestore);
-- 
2.56.0

