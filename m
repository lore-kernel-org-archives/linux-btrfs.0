Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6110C3822BA
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775724762; cv=none; b=GUYMeSmPxuk+92mmlTSDXg5fXF/Uyef58CLf2wscU+sQBdnYBdLVfD24oraogXPEUHFP11nz8z3hvJLRQHhikxz50COSjziO9r5UcbqHlh3uMWB8/HGCcoshAYbvHZ9vJufAKf20gso02foA5qqE3AZtZWsEgf3BeTFUkjbrjU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775724762; c=relaxed/simple;
	bh=assGR6wosI5nPPgd35/z4BXNdpoAe0AUw4PfCHWQa6A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSucWEPBjHwihgJXiVMf18VojH5jTUs1PuBC4nKQUhkq/hEPUVUMDtPiGUy+nhJ28uo7H6ITJh8iEAeFaajjhdkYbp7xsWP1U0ILgkFVAzvgEl5nk/CZd2FDucPKgeOofXgR/ThU05jXEk4kJShblnT2zPWF3GJmbeiMkL35bDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PJjW+SwA; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PJjW+SwA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PJjW+SwA";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PJjW+SwA"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B19E95BD1E
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775724752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rIH83U/7nSfMc5p+2vtOuN2gMrxoY78yHn4lZrS7SAE=;
	b=PJjW+SwASgez1PXI2EUCCwFknPKYPU9Vvey0kvSQgI5YlU5BUDQnegn8WBQHaQzqpg85aV
	cspvVeUwWzFqNQwidslMUlgkpPMVbuu0IcqHZpr1uXzSOrVT7alWCisaeSvE7NbrY1VJT7
	mbBurirHzZzYOV7IWQN13GbuAV4ATT0=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775724752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rIH83U/7nSfMc5p+2vtOuN2gMrxoY78yHn4lZrS7SAE=;
	b=PJjW+SwASgez1PXI2EUCCwFknPKYPU9Vvey0kvSQgI5YlU5BUDQnegn8WBQHaQzqpg85aV
	cspvVeUwWzFqNQwidslMUlgkpPMVbuu0IcqHZpr1uXzSOrVT7alWCisaeSvE7NbrY1VJT7
	mbBurirHzZzYOV7IWQN13GbuAV4ATT0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE5764A0B3
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gOHDFs9o12lUJwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 08:52:31 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 5/5] btrfs-progs: mkfs/rootdir: use st_blocks for size estimation
Date: Thu,  9 Apr 2026 18:22:04 +0930
Message-ID: <a549b82a45737c1f7595d11a6d4142248eace409.1775724568.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775724568.git.wqu@suse.com>
References: <cover.1775724568.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

With the new hole detection, the size estimation of the rootdir should
utilize st_blocks instead of st_size, as sparse files will easily
enlarge the resulted image.

Although very unlikely we should still verify that the host fs supports
SEEK_DATA/SEEK_HOLE, and if not we still need to fallback to use
st_size.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/rootdir.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 5c0bc012a354..62ee23588a64 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -2048,6 +2048,24 @@ int btrfs_mkfs_fill_dir(struct btrfs_trans_handle *trans, const char *source_dir
 	return 0;
 }
 
+static void add_data_size(const char *fpath, const struct stat *st)
+{
+	int fd;
+	off_t ret;
+
+	fd = open(fpath, O_RDONLY);
+	if (fd < 0)
+		goto fallback;
+	ret = lseek(fd, 0, SEEK_DATA);
+	if (ret < 0 && errno != ENXIO)
+		goto fallback;
+	ftw_data_size += round_up(st->st_blocks << SECTOR_SHIFT, fs_block_size);
+	close(fd);
+	return;
+fallback:
+	ftw_data_size += round_up(st->st_size, fs_block_size);
+	close(fd);
+}
 static int ftw_add_entry_size(const char *fpath, const struct stat *st,
 			      int type, struct FTW *ftwbuf)
 {
@@ -2059,7 +2077,7 @@ static int ftw_add_entry_size(const char *fpath, const struct stat *st,
 		return -EPERM;
 
 	if (S_ISREG(st->st_mode))
-		ftw_data_size += round_up(st->st_size, fs_block_size);
+		add_data_size(fpath, st);
 	ftw_meta_nr_inode++;
 
 	return 0;
-- 
2.53.0

