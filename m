Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B051E89C
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 04:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775709134; cv=none; b=SFiMIzv1zanEY+ICaQ+L1rZyBeMfJI9w1gUGS5WiybtOBSrLPFpmQQgra7J1MpZ5Q/r0Dq1JPT+SQWCJElcJ3UIqibyBEFHjHIHUCiUJ6XHR1+sYI5k3MpggItrxMoINhMZ8BlM2VnptVaUo7gs9aQZnk+8EssScHl/LSzL40Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775709134; c=relaxed/simple;
	bh=Z821u0kwScgfwvNbtpxZPRYcqqEjI2rRCOWhgoAtIHA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baG0BF8Epf3nizvT5zjzGTYrJvY7PmZ0Llw3/yxa7FPl12iivR8c0LNiBcxp9pgRxaunOkH1gD4SfQBe7d1JMFtRr2kko5u1SBDBBNbBv8tysnlvfrnITmPIdjF1z+7+a/cfsw4S4m2KkAKNZy/JNql6/pHsKDETSEKoy2PnojY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=om0dAYj6; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=om0dAYj6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="om0dAYj6";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="om0dAYj6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 038EA5BD00
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 04:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775709121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0vIIFGA1ZI6eoZBllGipVOZ2XGEJi682EpS/CIiespA=;
	b=om0dAYj6XSY/8PA4Jh6W6V3Hx49C+LeZGBtVDhTxeYFQCoNg90XWzyY2r18CwSmYxxzSAF
	Vk/WMswWsOIAVSVZ8uARKNkXtH8FXiKIlKrHITF5eAQBqqFNgrcC0KYPZKp1Mneu5o+T58
	NIaeyyJENEVVqxdPlwr7OIMF5KA0iFY=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=om0dAYj6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775709121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0vIIFGA1ZI6eoZBllGipVOZ2XGEJi682EpS/CIiespA=;
	b=om0dAYj6XSY/8PA4Jh6W6V3Hx49C+LeZGBtVDhTxeYFQCoNg90XWzyY2r18CwSmYxxzSAF
	Vk/WMswWsOIAVSVZ8uARKNkXtH8FXiKIlKrHITF5eAQBqqFNgrcC0KYPZKp1Mneu5o+T58
	NIaeyyJENEVVqxdPlwr7OIMF5KA0iFY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF5F54A0B3
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 04:31:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2PBlJr8r12lLIgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 04:31:59 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 5/5] btrfs-progs: mkfs/rootdir: use st_blocks for size estimation
Date: Thu,  9 Apr 2026 14:01:17 +0930
Message-ID: <eb1e665bebf72404e401080027907f4002afc562.1775708393.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775708393.git.wqu@suse.com>
References: <cover.1775708393.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 038EA5BD00
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

With the new hole detection, the size estimation of the rootdir should
utilize st_blocks instead of st_size, as sparse files will easily
enlarge the resulted image.

Although very unlikely we should still verify that the host fs supports
SEEK_DATA/SEEK_HOLE, and if not we still need to fallback to use
st_size.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/rootdir.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index 5c0bc012a354..bd285990ec2f 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -2058,8 +2058,21 @@ static int ftw_add_entry_size(const char *fpath, const struct stat *st,
 	if (type == FTW_DNR || type == FTW_NS)
 		return -EPERM;
 
-	if (S_ISREG(st->st_mode))
+	if (S_ISREG(st->st_mode)) {
+		int fd;
+		off_t ret;
+
+		fd = open(fpath, O_RDONLY);
+		if (fd < 0)
+			goto fallback;
+		ret = lseek(fd, 0, SEEK_DATA);
+		if (ret < 0 && errno != ENXIO)
+			goto fallback;
+		ftw_data_size += round_up(st->st_blocks << SECTOR_SHIFT, fs_block_size);
+fallback:
 		ftw_data_size += round_up(st->st_size, fs_block_size);
+		close(fd);
+	}
 	ftw_meta_nr_inode++;
 
 	return 0;
-- 
2.53.0

