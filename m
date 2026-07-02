Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D506E3A5E9B
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 23:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783035644; cv=none; b=G1UzyjXybCgbt0fHN7XV/gFlFd1sCsWFOoVr9Cc6haWS9tKtMjobEbwytNaCtOVCLkebUpvDZ8y3p1Bvt+8yH+6ZKwlIinyp6roblkNf2e95V1Gmrqobbdp30F2H/iah/XGMasbZSPJsFGIreU/ryLOqvETYZQy1M0dheduC7zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783035644; c=relaxed/simple;
	bh=6Kyi5BYihmVQ2hdLPp63tq6VxlsvPNkrBRTlcOzw1AU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jr08chWwg8gPrNJGSXN8aW1gXEm7bzjNKoOMQpvBr3Go8vfkL6tZZyy1ZwuLnRn+F50LPkMF75cVBuPxL8qXz3JmbZUXKis7+2HQOFJwL9G9+mSNXWbj1wqmxjpKWI3nVS0/iDNWUzUTo/sZmCewF2AQSRypy70nfEaJbRqGx5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OXEkfoTw; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OXEkfoTw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OXEkfoTw";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OXEkfoTw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 25BEB745B9
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 23:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783035641; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ti8D2rilrzwiUYUaKGpe6DUmqeyn4OvKKVL9aWMQiq4=;
	b=OXEkfoTwbU3ek6zt9djcOtMheKUA8hgJ4Ymz2NKuP1PxPTKe942QyLbWUe6KyCtVe0Vubo
	VGajNaAH8O/XB7WyXVVTRgj8XrP7lG8TceJcLC4Y20tkqXSdxbQs0S66Iq+IpBDhUJgMQQ
	cFlza2pYFAO7K2mI9X9HSNRpa9D7mCg=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783035641; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ti8D2rilrzwiUYUaKGpe6DUmqeyn4OvKKVL9aWMQiq4=;
	b=OXEkfoTwbU3ek6zt9djcOtMheKUA8hgJ4Ymz2NKuP1PxPTKe942QyLbWUe6KyCtVe0Vubo
	VGajNaAH8O/XB7WyXVVTRgj8XrP7lG8TceJcLC4Y20tkqXSdxbQs0S66Iq+IpBDhUJgMQQ
	cFlza2pYFAO7K2mI9X9HSNRpa9D7mCg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2E62C779AA
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 23:40:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aAc0NPf2RmryRgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2026 23:40:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: remove "usebackuproot" mount option
Date: Fri,  3 Jul 2026 09:10:14 +0930
Message-ID: <33cddcc18ea33a5e66259cd141c202a073f75856.1783035512.git.wqu@suse.com>
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
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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

This mount option is marked deprecated since the introduction of
"rescue=" mount option group, in v5.9.

That's already a long long time ago, and it should be safe to completely
remove the old "usebackuproot" mount option now.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/super.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fef9025a2f76..f2b3a85885f7 100644
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

