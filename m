Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794520661;
	b=2WRO7oHqLv04SQZNvWF/g82xQB5pwEQgt3pAxoiy4I6FR3jK+K14h+Ar5IvtRlEJAk1t
	 myW6TVAh/mmF7z5/13trghh93gEY+Lwm9GMACm+AT2LmcEqLnC0grQ3vIwZIrFjByAIZo
	 a61mPNJUdrWaT63m9EI1g4x206vg4BsFnjxlctrMJ2/9zz84FQto2/su0DotX41nZ32Xt
	 J6sHSR3kTue4glUEBaUrw8n6jSVsu/+jBKWQLK/6vo1Bf0/u74gdqdDFVlEFajJe5rC7h
	 lcKxG3/In2PEc+BNnsfWzEACesP0TKpPU337AzaThaSlrHv10r1x6DEPHpEZU5o31wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794520661;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=Z9HwCqT0BnCcOkys/blVtOoOY1C3PBAP7XOFkUJysIY=;
	b=Nq7Zbs+mjd4+BEv+P8EfZQ7VLtzCMDc8sJsxXI9SYPtZqNH5z+FRKBmvqqtgLNwkbaZ1
	 xZD5CETeCtSChm/n3ROvhv5QUnhifUtqiSR5iDdsGlatbUjmY3ZxirCWxw5zVDO/jkBgY
	 J1kGxcAqIWKqRKaIvFUr5j8d50voPIpn/cIG0VVtHDM3/6VihI1+eec4/RiQbe/ENSRqg
	 tEV96Kil5OH4Hr7xjGwmp7eEq9ZVf7A3BkzR/xn7njFEkm2mHRlvyIdvkX2Xtovo5ABdp
	 Op5bfi+V7YURZu76UuFj9IjDoydoYXKMaE8+guE6kM6xV07lpYXFAQm2Cn1Jk8uYRNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=LdSBQ9HX;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=IHVKhwed;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1935606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 21:57:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1935606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=LdSBQ9HX;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=IHVKhwed
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D0262220F9;
	Thu, 12 Nov 2026 21:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794520659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Z9HwCqT0BnCcOkys/blVtOoOY1C3PBAP7XOFkUJysIY=;
	b=LdSBQ9HX+oSjmVo5TGX33VYEROlyeAkxtYwk4o6floPdzjYGGDoGVkyBOurgjV1Iggubmu
	UdCA0LgS7RbBsZSKhQ7+Muhe5wDt7la/c0QDTWK3RqTtOP3UziueSaG4jz4FHzdNpJVBTx
	2jBnfDsIOPKLryzRJM5QmEmHcZ2LD1I=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794520658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Z9HwCqT0BnCcOkys/blVtOoOY1C3PBAP7XOFkUJysIY=;
	b=IHVKhwedV6YS/He/V97MYuqUoyAA9y4+G3xsqXxSF+uD3AkCs65Qe2Ks5+gMwKY/KHWUDE
	s2OVYkf2N1iNKFTCrMFJ/nYin7+ncL+qYexZsu07aEYuptfiR3JSk6Vo/IEW1eaL/LMXEt
	SD+pjO6xBuxuimJeyFzaV/b+29J6zrw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57211134A0;
	Thu, 12 Nov 2026 21:57:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cGrVKFA29mpUDAAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 12 Nov 2026 21:57:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] btrfs: relocation: release path on copy failure in move_existing_remap()
Date: Fri, 13 Nov 2026 08:27:14 +1030
Message-ID: <ea3810fb56f15af9878aafcf4632eb82d2245003.1794520632.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

All other error exits in move_existing_remap() release the path before
jumping to the end label, but the copy_remapped_data() failure doesn't.
The remap root leaf stays write locked until the caller frees the path,
across the transaction abort.

Release the path before jumping to the error path like the others.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/bug/linux-a9bb6565-ee24-429b-a2d7-ab427317fa57
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 9af207446848..94eda599b97b 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4345,8 +4345,10 @@ static int move_existing_remap(struct btrfs_fs_info *fs_info,
 	}
 
 	ret = copy_remapped_data(fs_info, new_addr, dest_addr, dest_length);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		btrfs_release_path(path);
 		goto end;
+	}
 
 	/* Change data of old remap entry. */
 	leaf = path->nodes[0];
-- 
2.56.0

