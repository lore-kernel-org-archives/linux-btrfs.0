Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794549042;
	b=GrcGRaJoBKvDKGF+XGxBA0xP3Pco7vdYqq24yZcoHS8DK+Mx5SnQunVVnN0VCtNDIJL6
	 EEhCDmCIwJzLvRdjeDm773AAuZwm8CzbVVr8QANIosBdynqgahQsWihoWJisaReYiHJ+e
	 rwYX2GRVMiSWzyIoky8ySw2o/RgsOclRZZgSAa8oSJzhoWj3L3IOXQEB5HyPBoZFM102o
	 8OL25NsHkg7kgz8KHeIUNTjamX7YdxdzOaI5SXnK1s156geIS/+JK4khR9V6ZH8pY/8a2
	 sKUilXW6ijWPAECRgQnubzhXwvITXGkCKBLd4YCJXRYuwgEhEOLRb8dtY8LDKWk713Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794549042;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=wQiqm3cruMMlun/kb1k6VYnZz4DyTVIGA1aAdRMjAEc=;
	b=gsuP714gYFEOgfTlMygsS07bGnPulO0M1rQMVUjBbQtjj054e6yBtCDlChIKPNOf0DRS
	 1KacWZIviZjw1UVJFc+vEHpJa/PgW2X7EJ7X/nqiQX3cp5xRbkLYAbnUOvEPeFKX7ccIC
	 IpoigftdasJKtrS3ILJHuxmUG4jWI4qNBCoRqsVLWi88M6V79MM3hbRUhCvK+ZC5xmw+j
	 PefWzqNVMCSyITC642JNj481WN96LW6DvcrKNPEavpQl1P0clHuKqPYvJy9RYVFlDh1Te
	 KiQnoHWKMt37B3VdONXNWUlKfvhX+bJ8js/jFvlDI22T4qBLICcNQyXgthBAA1a6Q1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NPIuVmPr;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=okYG8YxW;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EE9606A321
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2026 05:50:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5EE9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=NPIuVmPr;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=okYG8YxW
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E84DF2213B;
	Fri, 13 Nov 2026 05:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794549040; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wQiqm3cruMMlun/kb1k6VYnZz4DyTVIGA1aAdRMjAEc=;
	b=NPIuVmPrDTrPvlZYsA/P/idga0HOR6aahNI8E6sxuvt/q4U72JctemhyJ/uI/d/58K7HpN
	RJFeN0QzbX1Qo3mTwo3Ms38Cu872ZywEOl4UbldwfDSe0zg/L5bfi2exsCGvZv+4CDlSFG
	HhjMKXl/AaxL0HYmPU9xx4pq0mwdgaA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794549038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wQiqm3cruMMlun/kb1k6VYnZz4DyTVIGA1aAdRMjAEc=;
	b=okYG8YxWPNeSYAiRwFjoLwUP2oK1ZilrI4iE0x+gYlR4ho4knkJNsY7YfUauN9mZtVATNr
	BabTHqTA3G0Nn82tJXp5gWlXVDKUojO1IXVV7mXHrkqiqZvSzlHUcTuuFwZQlOI2G4wwzV
	GVlBPNxs45Rbvn2XzMyOUuHJTdDsK2k=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7050113511;
	Fri, 13 Nov 2026 05:50:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7LoOLyyl9mpUYgAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 13 Nov 2026 05:50:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2] btrfs: handle errors of btrfs_next_leaf() in create_remap_tree_entries()
Date: Fri, 13 Nov 2026 16:20:18 +1030
Message-ID: <ceaf35a5b7815d33480da620b5b5efe8cd028c70.1794549014.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,sashiko.dev:url,suse.com:email];
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
Changelog:
v2:
- Goto out label after unlocking free_space_lock
  Pointed out by Sashiko
---
 fs/btrfs/relocation.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 94eda599b97b..934bb264cfbf 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4663,6 +4663,9 @@ static int create_remap_tree_entries(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 
 	mutex_unlock(&bg->free_space_lock);
+	if (ret < 0)
+		goto out;
+
 
 	max_entries = extent_count + 2;
 	entries = kmalloc_objs(*entries, max_entries, GFP_NOFS);
-- 
2.56.0

