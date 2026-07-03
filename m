Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE48A360ECF
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 08:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783068111; cv=none; b=KZpDVYvtjpHPdwWGaeAgksj+J42DOdI9aqqEzubXaz0T6noo6HxrLzyF6pd9qSNheYVuHja8k/I/JN59b0y9XnZD4NPVF0wuKrLa7xAJwCcQV5EVgoRAK97fapKg9imjVR3+iPVju/BotUnWEd4zjKpuqvzJt24Tt30iGY0rVaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783068111; c=relaxed/simple;
	bh=feA1IGTnC+gnvMDqQm+hwUqj97TK7ocKhG8FQOYMgC8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnh4FWmg+hlTkAJaWZ9ewK0BaXQCgpF7O+UcpqTHKlLoHTFNQp/m5PO2p4XwQqP+61i6aFT/0Cd8Yle1ublJ5qTT59IeIIcaT5zy3VcxjWz+sSAyYm+qCtrMBvYlD6c8b+YrMcCnuNVW0NZEHGAv0UHA4+GbOE0PF9q+llEcEXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GJnOR5CD; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PZob3WLR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GJnOR5CD";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PZob3WLR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E8E2B76241
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 08:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783068106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6XdR8asKhpKH5P/bYqH7FDKopr0yHSHkgGvYbCkrF/E=;
	b=GJnOR5CD844/bfHbUo6oXyMKmFybWBl6bhiN3hSEFOxMFhxvCZfSex4bcUHyTWiFjzTISr
	Evl682AYVveW4i45zErYf64WI/YwjB/qfZ1fvHLdStCEq17v5erwnHOIZpERV4DMYLwRgD
	KBrwikQeNTTeamXtaN9etiNRXD7gyE0=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=PZob3WLR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783068105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6XdR8asKhpKH5P/bYqH7FDKopr0yHSHkgGvYbCkrF/E=;
	b=PZob3WLR+FQQKReqJ1vHyB232I14sLj7/dtlx/X/BONdV6N6O/ncHA7fESQCLEvFGT5LdO
	oMXMDTxBidr6AXVEfbrkYJVJNCePl9cstWZE6UJACkbCd1g24N7Cxx/FPYeF4BX4y3xdX6
	tyQ4dUFFL70AIiGzeh48JSofaeveyFk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F24FC779AA
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 08:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AJZuKMh1R2p6RAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2026 08:41:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: add "rescue=usebackuproot" into forced read-only options
Date: Fri,  3 Jul 2026 18:11:14 +0930
Message-ID: <dc5a344a2f4fcb63f78cb3e95beb1efbee9928f4.1783068013.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783068013.git.wqu@suse.com>
References: <cover.1783068013.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E8E2B76241
X-Spam-Score: -3.01

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

