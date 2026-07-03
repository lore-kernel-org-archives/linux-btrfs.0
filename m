Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B1F36F8EF
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 08:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783068118; cv=none; b=mGNozkWFIBiDPc/FmOev+A75aOOPmoeuzOdwJl8lhgAVaa8Je7FDoY+T3VzfUG92y287KIgJ5C0C3ea0Z/fvM+lcCi1Vf7i1q3XQ9gj9AAl/lC7bJYdJAFjIi5m+XcJh+nI1KLHnCA75xxSfGWT6MFkc9CJGnp1TjXdRSX8YWqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783068118; c=relaxed/simple;
	bh=gyfr5p1SYhM6vqG8gujE+RNmJFkbtD8PaFELG7hYqlU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NY6xgryAyDfYrhLb+ZsiyTGJ/vUEwkxflKuSWNGpb3zUHp4O0+GKwKjKUHBFxrTKHuGQlzMeABXEXomRL4LQJQ7pRd14NHVFwGYhR2zBKx+h37CoyZZGfXSV1gU63F/rs6e/hvwIIRKo1Orea5z6zjcfndCj0VdU5IcM8GHzHzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ek3NIGCr; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ek3NIGCr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ek3NIGCr";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ek3NIGCr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7FF3E7627E
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 08:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783068107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WMJzjP0RMxZ/Rwx/xzXFuXIwX50Kp3lOFIOO5isEVoU=;
	b=Ek3NIGCr6QPsSz3DQ7fcNPz9FADTxilz3YhY2667n/vnp1k71yud3TItIyTSS3CVmt8xH4
	xmM37Rez7ycag1Cz1cyBsPTNCW3OTlTVustmY75ew5LOscv0XnmkJPtNG6aFtSYdgrZ/iC
	0d3Qh8gSSQbfc0EVQ1eIVheSO0Hw9HM=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Ek3NIGCr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783068107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WMJzjP0RMxZ/Rwx/xzXFuXIwX50Kp3lOFIOO5isEVoU=;
	b=Ek3NIGCr6QPsSz3DQ7fcNPz9FADTxilz3YhY2667n/vnp1k71yud3TItIyTSS3CVmt8xH4
	xmM37Rez7ycag1Cz1cyBsPTNCW3OTlTVustmY75ew5LOscv0XnmkJPtNG6aFtSYdgrZ/iC
	0d3Qh8gSSQbfc0EVQ1eIVheSO0Hw9HM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 89C9C779AA
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 08:41:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gB3qDsp1R2p6RAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2026 08:41:46 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: add "rescue=usebackuproot" into "rescue=all" shortcut
Date: Fri,  3 Jul 2026 18:11:15 +0930
Message-ID: <086c4903d40c9b70ea3be0a738992c650915d57f.1783068013.git.wqu@suse.com>
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
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
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
X-Rspamd-Queue-Id: 7FF3E7627E
X-Spam-Score: -3.01

The mount option "rescue=all" should be a shortcut to include all
"rescue=" mount options. but unfortunately "rescue=usebackuproot" is not
include.

Include that option so "rescue=all" have a better chance to mount a
corrupted fs.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index fef9025a2f76..742f646ec12c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -620,6 +620,7 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			btrfs_set_opt(ctx->mount_opt, IGNORESUPERFLAGS);
 			btrfs_set_opt(ctx->mount_opt, IGNOREBADROOTS);
 			btrfs_set_opt(ctx->mount_opt, NOLOGREPLAY);
+			btrfs_set_opt(ctx->mount_opt, USEBACKUPROOT);
 			break;
 		default:
 			btrfs_info(NULL, "unrecognized rescue option '%s'",
-- 
2.54.0

