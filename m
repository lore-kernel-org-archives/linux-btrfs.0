Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239CF175A68
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 00:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791591993; cv=none; b=JEAQrTaD7ucuh5oUZ4fwoTW1vLLZaZ0/Kb7nmXRTEf+vFWM9ioLMORNvwhiGoPHNbE9GOkRtEYi43W4xM42xybNe3XVN3TO3FdgoWbRzdirNOY5SwcSp0oKHBCsedfqPKVtzkVP8TyHHk3mwdibM15yWS8ZPjb22AR55h9YIqUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791591993; c=relaxed/simple;
	bh=/ujP00jxtKa7nYnUGai/1RdKoEMTZSxRp2CDQSQdOlU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P8DVyXw+y7qm3ha/XgpoCB4okcTXDuBb7beIgt4QHbsKkAbzL+y8IxahGwb64O0s1HptpD9oSpESFKlKGTXFJtL+sMv88VCPRrNZ0VcL0n3ATMeOFpgaJxSvYZ5dGSL+KxCeCI0hgkd9XIX7IgC3K9R1JL4rcZ+/ZblDFw475iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IZn1N5Hx; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GbjOAwR4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IZn1N5Hx";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GbjOAwR4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1308E21C49;
	Sat, 10 Oct 2026 00:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791591972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=T8S5m3BWGb4nHrisc5rC4YnHDqeiyXaaE8hkINkk9rE=;
	b=IZn1N5HxpFiLbOy5fOzRRhFz5Qiiv68kIphQjRIs/95LM/Sy65n7N13OT9PJnYYnoC67hk
	ILpHO9+bY9zhUu5+Vxn4KsRQ2JzdSXec26fswoty2fbgv5er0SlZhZ6OVt4CImOAJe2iM0
	v+lzRHHoe5rKRaKSVabXFZiUnHPfP/o=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791591971; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=T8S5m3BWGb4nHrisc5rC4YnHDqeiyXaaE8hkINkk9rE=;
	b=GbjOAwR4yeS0O3l8hwlSKtQ7hgQcPIbIimu9SYBdzqywgEsUgRTr/Cz6BwUI4J++SXrf2k
	DLd8xMjb/agq7PcdHTaNnuMXwn4ontQXbjPymKEirFzG3MjLkv3frZ6zFoOcBctjQIhbtc
	0HHbDdERtyeLEdWjEFA5xQ9xR6hrnoY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6DFD9133A7;
	Sat, 10 Oct 2026 00:26:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r1LyLCCGyWrZCQAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 10 Oct 2026 00:26:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?Roger=20Alas=C3=A0?= <vonbloom@gmail.com>
Subject: [PATCH] btrfs: fix the fsverity callback where unexpected range is verified
Date: Sat, 10 Oct 2026 10:55:50 +1030
Message-ID: <c1cbf7c27ca3685b6440c04c87b70fe779a2535b.1791591949.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO

[BUG]
There is a bug report that on v7.2 kernel, compressed extents with
fsverity enabled can lead to read error.

[CAUSE]
Since v7.2 btrfs has enabled large data folio support, now a folio can
contain multiple blocks even if the page size matches the fs block size.
And even before that, btrfs already has block size < page size support,
thus all involved code should assume a folio can contain multiple
blocks.

However the function btrfs_verify_folio() calls fsverity_verify_folio(),
which verifies the whole folio, even if the read range only covers part
of the folio.

This forces fsverity to verify garbage data that is not yet read from
disk, and causes verification failure.

This is a long-standing bug, but previously it only affected bs < ps
cases which is not that common.
Now with the large folio support, it's much easier to trigger with bs ==
ps cases.

[FIX]
Instead of calling fsverity_verify_folio(), call
fsverity_verify_blocks() to verify only the read range.

Reported-by: Roger Alasà <vonbloom@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAELqY9==Ter2XQPRp=gjW5T75T+7kcZCXpn5roF2L6tY6mQNxw@mail.gmail.com/
Fixes: 146054090b08 ("btrfs: initial fsverity support")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 55e9144d4759..5ff630630490 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -504,7 +504,7 @@ static bool btrfs_verify_folio(struct fsverity_info *vi, struct folio *folio,
 
 	if (!vi || btrfs_folio_test_uptodate(fs_info, folio, start, len))
 		return true;
-	return fsverity_verify_folio(vi, folio);
+	return fsverity_verify_blocks(vi, folio, len, offset_in_folio(folio, start));
 }
 
 static void end_folio_read(struct fsverity_info *vi, struct folio *folio,
-- 
2.56.0

