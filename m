Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EF52773CA
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 02:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776133301; cv=none; b=ZNTQZVkYyztuVaDoFaWtkW0VlDoTXwTav4dSmz4bMQsLUm5ZP4RV2kG+CUczFEj6Kr/n+qJFj0toUk8jmJt9fu/GPuOF1BrXUDJxSf8U00Ynu+PX2fkIPPDcvr+6YWy5IUE6yLszM6P5RMdUziKx2aeUzO6+1q7QtYAcDR7RLNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776133301; c=relaxed/simple;
	bh=R0tA0/v2xaKILs5LbL3OnhQZKEnVAlQVfc3+JJcWBiU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YFT9jQcW5GHa9ZByzOsW59QVmoi/5z+JUpDhZByi6uceobhlhMU0EruX9PUa12LMsNC1VXKqXeqjhigJZ+E1Cz8DRd3QqQ1cqxhuzDbWRGcM+y1EwQKG3r85o9Y+ZNQMhk6ItjK3uKBkFWhRENPfaOZummN4DjbVxgDPnwGzCQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=u1SaFWTv; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=u1SaFWTv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="u1SaFWTv";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="u1SaFWTv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4F8E95BCDB
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 02:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776133298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=N4RkqUNkvm/7oCTJseHYMwaKy+ymsWjP+qN1GOmWDCo=;
	b=u1SaFWTvWSkQBuXWXBN10rU4afmyabmeBJ3xEkhFSSn2ip+Mvb06mBbNC3AMQgf3DHk3sP
	qV9D+Cx5ooSEMzS0omkrBlr0cCsrjBfPgrc+bqE1wHXoaeVvBjCgntCzC0YuGJHoEIx7Ul
	Pv80MPRhMMAuXC1SEZ85AuK7GDsBCZk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776133298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=N4RkqUNkvm/7oCTJseHYMwaKy+ymsWjP+qN1GOmWDCo=;
	b=u1SaFWTvWSkQBuXWXBN10rU4afmyabmeBJ3xEkhFSSn2ip+Mvb06mBbNC3AMQgf3DHk3sP
	qV9D+Cx5ooSEMzS0omkrBlr0cCsrjBfPgrc+bqE1wHXoaeVvBjCgntCzC0YuGJHoEIx7Ul
	Pv80MPRhMMAuXC1SEZ85AuK7GDsBCZk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EE964B1E3
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 02:21:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /OGXFLGk3WmXLQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 02:21:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: enable shutdown ioctl for non-experimental builds
Date: Tue, 14 Apr 2026 11:51:15 +0930
Message-ID: <f818123ba52a15913ea862aba75eacdbf4c06aeb.1776133240.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
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

Although commit 304076527c38 ("btrfs: move shutdown and remove_bdev
callbacks out of experimental features") tries to move both shutdown and
remove_bdev out of experimental features, that commit has only addressed
the super block operation callback, the ioctl one is left untouched.

Fix that missing aspect by also moving shutdown ioctl out of
experimental features.

Since we're here, also add unknown flag detection to reject any
unsupported shutdown flags.

Fixes: 304076527c38 ("btrfs: move shutdown and remove_bdev callbacks out of experimental features")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ioctl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b2e447f5005c..a39460bf68a7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5102,7 +5102,6 @@ static int btrfs_ioctl_subvol_sync(struct btrfs_fs_info *fs_info, void __user *a
 	return 0;
 }
 
-#ifdef CONFIG_BTRFS_EXPERIMENTAL
 static int btrfs_ioctl_shutdown(struct btrfs_fs_info *fs_info, unsigned long arg)
 {
 	int ret = 0;
@@ -5134,10 +5133,12 @@ static int btrfs_ioctl_shutdown(struct btrfs_fs_info *fs_info, unsigned long arg
 	case BTRFS_SHUTDOWN_FLAGS_NOLOGFLUSH:
 		btrfs_force_shutdown(fs_info);
 		break;
+	default:
+		ret = -EINVAL;
+		break;
 	}
 	return ret;
 }
-#endif
 
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
@@ -5294,10 +5295,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 #endif
 	case BTRFS_IOC_SUBVOL_SYNC_WAIT:
 		return btrfs_ioctl_subvol_sync(fs_info, argp);
-#ifdef CONFIG_BTRFS_EXPERIMENTAL
 	case BTRFS_IOC_SHUTDOWN:
 		return btrfs_ioctl_shutdown(fs_info, arg);
-#endif
 	}
 
 	return -ENOTTY;
-- 
2.53.0

