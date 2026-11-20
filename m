Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795165743;
	b=vzBWyewQX4LIcvq+Jm6rf4PPdtQKwCr+wZk9TwQHhcbR3BOJIXIBemmN5SEb/X2jlxsu
	 WlIT6Y2s2KlSJekF/YwlZ+awA4QA1TkVDl7+1Pp7rMRMEczsi0Ubi4lR55I8WTsg9tHsB
	 nZSJuN87LCIxuomEEg8KfDUXJNocF5DSFxmsVDZYTbOp92kU/+t3yg1RNCxRJ/aWwIFpx
	 tOYAeqbk2peqv4p78s7pLXbdvcROWP3SpGAoWnoJRQDCPsbpRJr/Y1Hle7BsdGqiqVpcU
	 E4NTWrWvItVpUgZcILOt8vKVFVENEQzEZkQjLhMBfm8rx4hjRgfymC0BjqRd0e+cKsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795165743;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=ZZ7+XTz7lh1uK0u+jzggrqj2wLx3RyEVuUvjCWPd5Rg=;
	b=e/p4O7Wx3iEHtLk9nldCVMa3yliZQ3g/8qrAufFrsJ2l4hAxxzkgsdd24TCccKuyok+Y
	 BF2JUdNW63qQPGRiLWUFZ/V9RIKu0H2wE3KGXbsrz9pRdKTsaHxCfS6kcajec4FDWLThM
	 nNz4vxR3Y+oqW9fFCr2P/J61XfLLx/ncbF8Scr10yhJP+F5SkCmNE4TMJmIv8bkdkxlWH
	 K4LcqJ+7C+lxSQE6wgqVDWjRjN750NAZdpUaVcJ+straWJYiROPoJ9/EnYaUS0bjBwqsp
	 RHTJG8yje1LazA2BuZGhob0GPHZmZC55wBp4TAungapMK2wBmSP1cDEDm+reG2FXSbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uDehBSmM;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uDehBSmM;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36607606A320
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:09:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36607606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uDehBSmM;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uDehBSmM
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 276312260C
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795165741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZ7+XTz7lh1uK0u+jzggrqj2wLx3RyEVuUvjCWPd5Rg=;
	b=uDehBSmMPv/BQ5UecjgJGhYytaF8MkEORUTjHStP6vCGKdxCh6LJHhNcP9Df6y6qIgghok
	SrZdt4LXPTC0hjIqYc5NUzmUaabylMYJFiYsoLtI2i7/li8NyqY4/jv2G7vlT00emh6hOS
	9dI3zjYhZlddladC0q+/9fE9FKmHZ6s=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795165741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZ7+XTz7lh1uK0u+jzggrqj2wLx3RyEVuUvjCWPd5Rg=;
	b=uDehBSmMPv/BQ5UecjgJGhYytaF8MkEORUTjHStP6vCGKdxCh6LJHhNcP9Df6y6qIgghok
	SrZdt4LXPTC0hjIqYc5NUzmUaabylMYJFiYsoLtI2i7/li8NyqY4/jv2G7vlT00emh6hOS
	9dI3zjYhZlddladC0q+/9fE9FKmHZ6s=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 04A7B134F6
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:08:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7jwnOScOAGsJYwAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:08:59 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: qgroup: ensure the qgroup rescan messages are always shown
Date: Fri, 20 Nov 2026 19:38:36 +1030
Message-ID: <0de834dc726392804b83031be495d34db0cb1c8b.1795165635.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795165635.git.wqu@suse.com>
References: <cover.1795165635.git.wqu@suse.com>
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

In btrfs_qgroup_rescan_worker(), if by somehow the transaction is
aborted halfway, later we can not start a new transaction.

This marks @trans variable always to be NULL, which later skips the
qgroup scan related messages, this can be a little confusing for end
users.

Fix it by only end the transaction if we have a valid trans handle,
other than returning from btrfs_qgroup_rescan_worker().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9f3886d128d3..afac7402af36 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3986,10 +3986,8 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	complete_all(&fs_info->qgroup_rescan_completion);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
-	if (!trans)
-		return;
-
-	btrfs_end_transaction(trans);
+	if (trans)
+		btrfs_end_transaction(trans);
 
 	if (stopped) {
 		btrfs_info(fs_info, "qgroup scan paused");
-- 
2.56.0

