Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9E833E347
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 04:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787631184; cv=none; b=ehP/O4nAT6Lh1ZtBekha5Qf4kJF11dd6Ptbu1bnyc3RXyF+H602N/03Q1XfVCkgCmcU2NXXtNfltoLqLHqvHlCgxUuSnd9HaUMkdhJQe6FnX3Sw3UlgpQWsBTfMF8hhxJfXzbcciBuo988+9py94O+1b/IxPxU4ZSeEl1UdZG8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787631184; c=relaxed/simple;
	bh=JVO76VIl7vWmGRmbR0A8ccTjfaXi1xzhlhKAAaZ9RNc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4GGwG5A/n8Q6SCfhs9iCvQf3XHLD2ktqA4Ea+Atowo2hewx5QP8i+3VtInVff/kevhJgHp8+mteCsvfrOEiIvxjpXAGd3be53OpC+ugs2RCkXA9HQcaCph+yYNhXrFe09lRHfrqSUMyEiFoi59cbNSlaOmIepcEsw5BR0/acUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kFDDrXUn; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RyaehWUX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kFDDrXUn";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RyaehWUX"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2FEFB86CA5
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 04:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787631177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7VCdE73zBLMiJl9YfonFQTGXDIK4O670v+1W7lU7hXw=;
	b=kFDDrXUnkibBgSmFh01Fbv3934N21g33mLZ7KkgUDvtE0jrvGEbu03SDd31ND33sF5lpd7
	KKZjYRYmIM5CSGbI+bIhIgR0Qv49JsjnahorajDiLCwDJ+qmhAKEJ58XmGn1iQZujC/531
	xyyOOfrzeBc0OU9Z4K4kJRmoDqzCCbo=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787631173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7VCdE73zBLMiJl9YfonFQTGXDIK4O670v+1W7lU7hXw=;
	b=RyaehWUX12ZDW8K63lBVPBclsIb/tJMlhguYc+3no674X/ltxQXhaXcJKhPRz3wbQOb7RO
	JeVtPLbtp9TTcW5EmWNRH7wrqkEcnKoMUv075Yab9bJ6f9QfDw+9BncTNo7YTt+8Rht3Si
	IGkc06paPZ/HDpXBNh9qnUOx8QRsCVc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2636E13335
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 04:12:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UGcNMUMWjWodGQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2026 04:12:51 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: remove the unused variable @flags from btrfs_read_qgroup_config()
Date: Tue, 25 Aug 2026 13:42:30 +0930
Message-ID: <e10ddad1d2f58c5325ff9199abd4037707b58183.1787631065.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787631065.git.wqu@suse.com>
References: <cover.1787631065.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.79
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.19)[-0.970];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

Since commit e562a8bdf652 ("btrfs: introduce
BTRFS_QGROUP_RUNTIME_FLAG_CANCEL_RESCAN"), that @flags variable is no
longer utilized.

Just remove it.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f68b696b4bf7..f3685cbb8f2e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -426,7 +426,6 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 	struct extent_buffer *l;
 	int slot;
 	int ret = 0;
-	u64 flags = 0;
 	u64 rescan_progress = 0;
 
 	if (!fs_info->quota_root)
@@ -609,7 +608,6 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 	}
 out:
 	btrfs_free_path(path);
-	fs_info->qgroup_flags |= flags;
 	if (ret >= 0) {
 		if (fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON)
 			set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
-- 
2.55.0

