Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C29336CDE0
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 08:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783068125; cv=none; b=aI1Vsn1OeelZdnhXO/DY/7VEhQIG9uWVj4e7KfXIWCC3Qs1Wx73fUNNHLFx2j/0kXzgBKNz+qCw6d8y0UbwyuFaxsCCDsx2MzP5+eP9b1Z/PnprlMg4nsKd+ULs/ZYlOhh06X80vt1QS1TVYHaS5Uk+M7w/6WYeAyHlYALfiEcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783068125; c=relaxed/simple;
	bh=6c/GC/6YAbMqEp1Da1kaAQUeC1gVZkJ/25IvdR/wUBc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPujwAfuVeYeCg94gXiVXNOT/jal0PgO/gYEjmOzFEoNW8UDPNmvmq3bWn9CHEp7cRfgndHBZulZUbKen3Yppe/TOyyrs/X8D1Qb1jj68Y7aAfwVuirrbWUt8VIbTwOE84uUSUL/x5kI+sXtZR+In2rwzabU1wcZo556aukFTmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sOJAwsA+; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sOJAwsA+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sOJAwsA+";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sOJAwsA+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 19F16762B3
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 08:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783068109; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yw8LKMrd1o+HKZdbBmI1G+JIoLiRej9rEjWzs35TAlE=;
	b=sOJAwsA+1rR0PoBgcnix4bq/bCTFOpkC6r6KE9qPW97aEveOyopOzHVvLp35IyHCD5hBgI
	1+X9ALaCVY14QDS5xrVbjjslnvxKHILuVJfULNvzAwU/lEvNkn4UTQMBGKWS24ht3o3WPC
	R4/lepaGfRFIU56JAfUr3IBLsNpXjN0=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783068109; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yw8LKMrd1o+HKZdbBmI1G+JIoLiRej9rEjWzs35TAlE=;
	b=sOJAwsA+1rR0PoBgcnix4bq/bCTFOpkC6r6KE9qPW97aEveOyopOzHVvLp35IyHCD5hBgI
	1+X9ALaCVY14QDS5xrVbjjslnvxKHILuVJfULNvzAwU/lEvNkn4UTQMBGKWS24ht3o3WPC
	R4/lepaGfRFIU56JAfUr3IBLsNpXjN0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 21676779AA
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 08:41:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aCgCMct1R2p6RAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2026 08:41:47 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: remove "usebackuproot" mount option
Date: Fri,  3 Jul 2026 18:11:16 +0930
Message-ID: <7d88c119203678c74174a8960b0e3cf00a1296ba.1783068013.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid];
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

This mount option is marked deprecated since the introduction of
"rescue=" mount option group, in v5.9.

That's already a long long time ago, and it should be safe to completely
remove the old "usebackuproot" mount option now.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/super.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 742f646ec12c..2558801f483c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -128,7 +128,6 @@ enum {
 
 	/* Rescue options */
 	Opt_rescue,
-	Opt_usebackuproot,
 
 	/* Debugging options */
 	Opt_enospc_debug,
@@ -248,8 +247,6 @@ static const struct fs_parameter_spec btrfs_fs_parameters[] = {
 
 	/* Rescue options. */
 	fsparam_enum("rescue", Opt_rescue, btrfs_parameter_rescue),
-	/* Deprecated, with alias rescue=usebackuproot */
-	__fsparam(NULL, "usebackuproot", Opt_usebackuproot, fs_param_deprecated, NULL),
 	/* For compatibility only, alias for "rescue=nologreplay". */
 	fsparam_flag("norecovery", Opt_norecovery),
 
@@ -560,14 +557,6 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		else
 			btrfs_set_opt(ctx->mount_opt, AUTO_DEFRAG);
 		break;
-	case Opt_usebackuproot:
-		btrfs_warn(NULL,
-			   "'usebackuproot' is deprecated, use 'rescue=usebackuproot' instead");
-		btrfs_set_opt(ctx->mount_opt, USEBACKUPROOT);
-
-		/* If we're loading the backup roots we can't trust the space cache. */
-		btrfs_set_opt(ctx->mount_opt, CLEAR_CACHE);
-		break;
 	case Opt_skip_balance:
 		btrfs_set_opt(ctx->mount_opt, SKIP_BALANCE);
 		break;
-- 
2.54.0

