Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794538489;
	b=QUe4T6BdpUZ6fW5alN40L4WgCKAMqvlEdd/q/4C8iK0ixKYmy8S8FhRKkiF7GCEyr9Sy
	 Hh3/SBlaD9P0bWCO1scK4/O2SRTJOi4OHG6ICEEvMbCC3p/hYReg15AtMq5PRhHb+gz5N
	 +0JyM94qUdRXdiO2zlVJAZDfbcGFsfs4wPl5GCT8qazpuuenkfllkFAnxCg4kv5TgUmZE
	 4dUwaAEuNWA7HrUPC8v6zcM3HuzofTucsRNOfkoS1Y17czKRtRxqezbqMmGgQqQmjCLu5
	 AhvitVqf9qModbAY/DGG00Cdyt+fN6pfqbCI6Eti5s3mWkc6cMTSfaRHSASrxU3brHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794538489;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=ZGJ8x4RIIEQHk3b07Ecp9/HVOj5NdirMWwnNx0GsiiU=;
	b=H7CGbVSB4ZfbxIeAqvPYAfEcBqiXIyy1NpE5tvOr16T+Ei5WnUp1I/y2bxIV3ZPQ3OUy
	 G0XVvjY8NzXUgNEWKUr16gkykVtoqspItQwUH06kJIMkjaK7OEnYZpMrBYAzzm/1hdcYP
	 0zcp6XQ0DEhVrbAQwg8Z5WqsVHuyQzdg5IPeLAXmybs9m6C5u7K9baR1vULMzI8JaRnau
	 MBTYTt8cA9v8m0mhgkdIOXAFNpQDTSpQKpQrVyIxptQPNT3mAJFjJhcN9AbQF4/PXGkp/
	 79R4SNQq75tGcJab4E9aYCAM52IoXOSr5e7M6yzyq+Qt4fQTzVq90jldhTFWYFj7E2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=QfF6PTK3;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="Q/NujWUB";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35DC606A323
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 02:54:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C35DC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=QfF6PTK3;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Q/NujWUB
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CACFB2210D;
	Fri, 13 Nov 2026 02:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794538487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZGJ8x4RIIEQHk3b07Ecp9/HVOj5NdirMWwnNx0GsiiU=;
	b=QfF6PTK3T/ToMUB7fhvxvuOIQyLod75c+0SXj5LgbDqBH4A5jsxqKhvHg6gc1s4lgoKh02
	LMaCckfqmxRgd3Igqmf0wNZexb/qhKPeOFvfCR2YIKqItl2LN2Au6/eqIfFraCmIVwoUI+
	GSkmq9X8+8LdfxNJBOYohvlWucX6oBY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794538486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ZGJ8x4RIIEQHk3b07Ecp9/HVOj5NdirMWwnNx0GsiiU=;
	b=Q/NujWUBe6oXqj1LNalWdj3aaG1sf7L0J2F2KqsI+dRq6inBrTJJ1gWR+Blbz3X7Wp2L6N
	NoCzvWg7RxK4ns5ChveZhPEQhtG8xxxC1sIbp8zsBQwOFZzaors42R2ShYMxmBtdAf9yry
	5xhSqHJA8uUVjDXbtpVkjJiKpju3ouU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 344F4134C3;
	Fri, 13 Nov 2026 02:54:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a8ohH/R79moDNgAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 13 Nov 2026 02:54:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] btrfs: handle errors of btrfs_next_leaf() in create_remap_tree_entries()
Date: Fri, 13 Nov 2026 13:24:26 +1030
Message-ID: <f07172047d96c93a23d74289dc9dc5b00092feed.1794538460.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:email,sashiko.dev:url];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,suse.com:email];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

In create_remap_tree_entries(), if the btrfs_next_leaf() returned an
error, it only breaks the loop iterating the free space tree.

Later we call "ret = add_remap_tree_entries();", which will overwrite
the existing error code, silently hide the error.

Fix it by adding a "if (ret < 0) goto out;" check after the free space
tree iteration is finished, so the error can be caught and abort the
transaction.

Fixes: b56f35560b82 ("btrfs: handle setting up relocation of block group with remap-tree")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/bug/linux-93f4c09d-07d1-4919-b201-2d46f70adf3d
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 94eda599b97b..2b5f5e7705cf 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4661,6 +4661,8 @@ static int create_remap_tree_entries(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_release_path(path);
+	if (ret < 0)
+		goto out;
 
 	mutex_unlock(&bg->free_space_lock);
 
-- 
2.56.0

