Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795561168;
	b=sCc4J+5P1YpZWoa+NcT5nXo+fM5Ge11FE+ULMZ9VKKlM1sSH0D/m8muSJZzYjhzUwKnX
	 8mQNIxTC0ujKBN1TAbQIasyGPHnemz37JomDPu2Vq7Jwj3NSfpESlqhKuXTHa4FfjSL1P
	 ymZfOnfn7ETMYFTGGbX2roRlZOrji29Cvq2crrzW8Gpnu69jvjmHigzY6UdQe6TLYQxjU
	 9jeXmO93ouMH/bPKOSZY33RqzlutvaXpsDL6BzJ2l4JYgarpi7Y1xxLeWZZq+aUyW6j4T
	 h6w61QJ0PA7R7DFaxuyFYNiZhn7WnrqEUxFUfugZTBlXtF9pgg/RxTEjPIBMsNk4sYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795561168;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=si/Oo/0Xgr7herAl49rr1Ho9qjcn0FucVciAYabLPoo=;
	b=C8vLks1fSvGXI8G3J0bgLXbfovl9GCiCeEHAfJNT1hokm0jwdODgHKerU/NRNjZs8lzf
	 3Aqzr83eQZNMq5h1XSxM4KpXWR054jXZIOnAHgurUFlSU81CkfEBIswU2nEbbLhH6dAQm
	 xrVNhifkkNOZgUTTorAAIFUZihNDsanZKWEvnjzyIWOACvWocieY6479Nq/P5G0Uz6RSN
	 mYX+DRWxWsSZ/uZwk/XZ4Cf5yZI8F6lf4HGeEZd+cMaDkWzKQR6g0k3MnCN3rjEI4rmLs
	 gmxQTsxt5WA+J/FvcPep1tf8HHN0okjLJj7YeDhDGdOwZtANP/oXL1JGIMAZtRuM3SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OO5fSYRg;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OO5fSYRg;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C7D606A31E
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2026 22:59:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88C7D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OO5fSYRg;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OO5fSYRg
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AF3C41F38F
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2026 22:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795561165; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=si/Oo/0Xgr7herAl49rr1Ho9qjcn0FucVciAYabLPoo=;
	b=OO5fSYRg9qr3t93vyPtPHT1Yk22mQNKbuahghcqcv70+TaKwd8dJLFUeYbwjixM/JASJQ7
	MmGpZ3QX8v8xcGL+ypbOD3tO+Mnr7bPb82Lm3rgIDitkXCnvyItjQLlx/grbDikMFyrPyY
	xuUiadhLwiGTwsi5EBmw2Lk91a8bXec=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795561165; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=si/Oo/0Xgr7herAl49rr1Ho9qjcn0FucVciAYabLPoo=;
	b=OO5fSYRg9qr3t93vyPtPHT1Yk22mQNKbuahghcqcv70+TaKwd8dJLFUeYbwjixM/JASJQ7
	MmGpZ3QX8v8xcGL+ypbOD3tO+Mnr7bPb82Lm3rgIDitkXCnvyItjQLlx/grbDikMFyrPyY
	xuUiadhLwiGTwsi5EBmw2Lk91a8bXec=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 86EE613505
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2026 22:59:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wUAsNMsWBmvfMwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2026 22:59:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: abort the transaction to avoid half deleted qgroup relationship
Date: Wed, 25 Nov 2026 09:29:01 +1030
Message-ID: <4d1b2d669194cb324213637bc6c6d38a2ecdb7d6.1795561094.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

In __del_qgroup_relation(), if the relationship item for (src, dst) was
deleted successfully, but the item for (dst, src) failed to be deleted
due to other reasons (EIO, ENOMEM etc), we just return the error without
updating the in-memory relationship.

This can lead to minor inconsistency between in-memory structures and
on-disk metadata.

E.g. the second deletion failed with ENOMEM, but the on-disk metadata
has no such item. In this particular case we can continue deleting
in-memory structure.

Fix it by aborting the transaction if the first deletion succeeded, and
the second deletion failed for reasons other than ENOENT.

By this we still keep the best-effert deletion attempt. E.g if one
relationship item is not found, we can still continue delete whatever
left and remove the relationship completely.

Link: https://sashiko.dev/#/bug/linux-8878868a-a948-4f35-a459-2ba8be379061
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index ab382f41957f..eef012d340fe 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1688,8 +1688,15 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	if (ret < 0 && ret != -ENOENT)
 		return ret;
 	ret2 = del_qgroup_relation_item(trans, dst, src);
-	if (ret2 < 0 && ret2 != -ENOENT)
+	if (ret2 < 0 && ret2 != -ENOENT) {
+		/*
+		 * Abort to avoid inconsistency caused by
+		 * half deleted relationship.
+		 */
+		if (unlikely(!ret))
+			btrfs_abort_transaction(trans, ret2);
 		return ret2;
+	}
 
 	/* At least one deletion succeeded, return 0 */
 	if (!ret || !ret2)
-- 
2.56.1

