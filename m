Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43AF3793AD
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 09:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072000; cv=none; b=fu2LtUBkbYJyu23cMUWEGHIfZzhKeax4BgoQNVKMH97n0gnXoKTG4HpGCwY/upm7+qA1tbCZCcw6ohIpxFOJF5chj/Gq6bwkmTs2BfWGhpTVGqfNkjKnneSGloAMNP15ncJf5EfAB/bTM7J7ZzUCMbzbj1zPQxlXcKZpnivNzrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072000; c=relaxed/simple;
	bh=DCJEQtKBF8NGtrU5bzKPpqjwdilYbAgE3z35TMXDoug=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f93KarrZMaPB4peW7jESTUvhVnecnErjJf0qyFGf/cb9TtiSgxVgI3ifkvJl/pvf29kFgEmgD7iCxX2wQXuLyu1zVVfoFh9bQlUtPH1StmiqNxwcAN+bPICuP4dstPGjIjfO6/eoUxLiACqu+YnakfpHihsn9rBD6EdKwqpii5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GooOOcqy; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GooOOcqy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GooOOcqy";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GooOOcqy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0FED27613E
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 09:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783071997; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kzmnbt6V11rn+Gc85yLTeQt0PCnQFIOg8XlNSl22XE0=;
	b=GooOOcqyun9+H16iWX6IYY2K/SiIokYeIqmo+P8eOW9vB8FV26cgs/kgRanWsljuNW6Obn
	8qFndWNWg+cSumy5K0D0yK3Dvmud7J/AJGHMbDzQaiwts3aYHUrNX8VhM5bR9hdxwFR8sc
	XClm7N1sTVE4lSqp4d7NnL5NTL1AiYQ=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=GooOOcqy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783071997; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kzmnbt6V11rn+Gc85yLTeQt0PCnQFIOg8XlNSl22XE0=;
	b=GooOOcqyun9+H16iWX6IYY2K/SiIokYeIqmo+P8eOW9vB8FV26cgs/kgRanWsljuNW6Obn
	8qFndWNWg+cSumy5K0D0yK3Dvmud7J/AJGHMbDzQaiwts3aYHUrNX8VhM5bR9hdxwFR8sc
	XClm7N1sTVE4lSqp4d7NnL5NTL1AiYQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1830A779AA
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 09:46:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QLvGLvuER2rdBAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2026 09:46:35 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/3] btrfs: add "rescue=usebackuproot" into forced read-only options
Date: Fri,  3 Jul 2026 19:16:06 +0930
Message-ID: <9e06b8bb82b3322d3d5a9a915634c364a8d070d1.1783071857.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783071857.git.wqu@suse.com>
References: <cover.1783071857.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 0FED27613E
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

According to btrfs(5) man page, all rescue options should require a
read-only mount.

But that read-only check is only introduced for newer rescue options,
not for the pre-existing "usebackuproot" one.

Furthermore, a filesystem that requires "rescue=" mount option already
means it's corrupted, even if "rescue=usebackuproot" allowed the fs to
be mounted RW, one should not trust such fs anymore until a
comprehensive btrfs-check run and proper evaluation.

Change the behavior to match the document, and since
"rescue=usebackuproot" is now a full RO mount option, it is no longer a
one-shot option, therefore remove it from btrfs_clear_oneshot_options().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/fs.h    | 3 ++-
 fs/btrfs/super.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index ab5ed7b4f639..cffb9197a1ab 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -289,7 +289,8 @@ enum {
 	 BTRFS_MOUNT_IGNOREBADROOTS |		\
 	 BTRFS_MOUNT_IGNOREDATACSUMS |		\
 	 BTRFS_MOUNT_IGNOREMETACSUMS |		\
-	 BTRFS_MOUNT_IGNORESUPERFLAGS)
+	 BTRFS_MOUNT_IGNORESUPERFLAGS |		\
+	 BTRFS_MOUNT_USEBACKUPROOT)
 
 /*
  * Compat flags that we support.  If any incompat flags are set other than the
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0a6ce6c19d8c..e561c8811d6d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -668,7 +668,6 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
  */
 static void btrfs_clear_oneshot_options(struct btrfs_fs_info *fs_info)
 {
-	btrfs_clear_opt(fs_info->mount_opt, USEBACKUPROOT);
 	btrfs_clear_opt(fs_info->mount_opt, CLEAR_CACHE);
 	btrfs_clear_opt(fs_info->mount_opt, NOSPACECACHE);
 }
@@ -692,7 +691,8 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
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

