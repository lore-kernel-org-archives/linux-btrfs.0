Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F76C293C4E
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 23:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783035647; cv=none; b=IteQTJRPI4eK57CapgOU2Xtw7tyFkGNC4aVZUqQuDA1nhI0niVezSJY5Il6qq/PYI7/1tcWYEjIRTjNx2aVbxRGK+EQJSV6FLq7rKyV+soEhstULQRagSaIsqugHEh+S6bLJUV8MvQ0Y39ei/WfqC9EG7qJj3vr+/z7CdUyc+qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783035647; c=relaxed/simple;
	bh=feA1IGTnC+gnvMDqQm+hwUqj97TK7ocKhG8FQOYMgC8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCNd3tWuz7pjWGWk09UjetLqpFkT2elxX+WAIzpkoTAO8UulWLrxLqsv1uKZWgJt2OgLaiE+HU+Wmy2fKataDgb4lhg4rXwodD+p1rmEm1YRgQwsZf75MMybnGXwpglHcUt4LlW2G7lZxUHCClB0xcdNbB86nZwPvx1bgav0i9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Zz2ACGkW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Zz2ACGkW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Zz2ACGkW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Zz2ACGkW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8DAE175B17
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 23:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783035639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6XdR8asKhpKH5P/bYqH7FDKopr0yHSHkgGvYbCkrF/E=;
	b=Zz2ACGkWLkFxKb0M9rLCCxosQhDWN0a7IO/CA+2ydZrNvJi5GX/OUg1teUDA+aXIt/E830
	b0VkbDFEMhZvxafYNdz+QEF4ZrrX+7wzo1rEltuvFmrK/9+uOjERkm4jBoH1dqqMABQrQz
	KOE50XzoESMx4qha+dsU1bmosh4RZX8=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783035639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6XdR8asKhpKH5P/bYqH7FDKopr0yHSHkgGvYbCkrF/E=;
	b=Zz2ACGkWLkFxKb0M9rLCCxosQhDWN0a7IO/CA+2ydZrNvJi5GX/OUg1teUDA+aXIt/E830
	b0VkbDFEMhZvxafYNdz+QEF4ZrrX+7wzo1rEltuvFmrK/9+uOjERkm4jBoH1dqqMABQrQz
	KOE50XzoESMx4qha+dsU1bmosh4RZX8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96F59779AA
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 23:40:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MIwiEvb2RmryRgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2026 23:40:38 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: add "rescue=usebackuproot" into forced read-only options
Date: Fri,  3 Jul 2026 09:10:13 +0930
Message-ID: <dc5a344a2f4fcb63f78cb3e95beb1efbee9928f4.1783035512.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783035512.git.wqu@suse.com>
References: <cover.1783035512.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

According to btrfs(5) man page, all rescue options should require an
read-only mount.

But that read-only check is only introduced for newer rescue options,
not for the pre-existing "usebackuproot" one.

Unify the behavior to match the document.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0a6ce6c19d8c..fef9025a2f76 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -692,7 +692,8 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
 	bool ret = true;
 
 	if (!(flags & SB_RDONLY) &&
-	    (check_ro_option(info, *mount_opt, BTRFS_MOUNT_NOLOGREPLAY, "nologreplay") ||
+	    (check_ro_option(info, *mount_opt, BTRFS_MOUNT_USEBACKUPROOT, "usebackuproot") ||
+	     check_ro_option(info, *mount_opt, BTRFS_MOUNT_NOLOGREPLAY, "nologreplay") ||
 	     check_ro_option(info, *mount_opt, BTRFS_MOUNT_IGNOREBADROOTS, "ignorebadroots") ||
 	     check_ro_option(info, *mount_opt, BTRFS_MOUNT_IGNOREDATACSUMS, "ignoredatacsums") ||
 	     check_ro_option(info, *mount_opt, BTRFS_MOUNT_IGNOREMETACSUMS, "ignoremetacsums") ||
-- 
2.54.0

