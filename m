Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2224037E2EB
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 09:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072006; cv=none; b=EBc+3WOYfcV7UsT+oIkqKMEqLUcS1v2buTtg92nipk20lre0cZYs/hi+r/xbvW2WZcidQFT0n1O1C4J+W0E4XwbVF1e6+0JMpjN0LatbVHFX+T+OALyqRGDPIiTrWglFh1wkhn5lsiqQgs5tmIaGyeOh9qFW/LZOWpNIZPlAPa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072006; c=relaxed/simple;
	bh=0RyMkxHY57nbYBUNo7EsCPPExh+XkExUXb6umKQiU1s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPKSpmCuoktDmr0EUbOOeOI84yDIUbUg2Efe437mr1j+F6bqwSodRc0x4xOc2L4ha9X+AOWNrVQ54AIpop7nKPOtliVJPsjJ/1LUOaZiMRwkwb8sYTXAeb1xW8UhTt19uYeiBOm89MV9Rp/g3P6wsbu2YGI0t0tVbxnO7yB4u1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g72QIHh0; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g72QIHh0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g72QIHh0";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g72QIHh0"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9D0DD76231
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 09:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783071998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zJMERwFqgJnL5lBJ2s0ak5dfDBegJTM2T1zQ2JmLD9s=;
	b=g72QIHh0T/OOjwl5QSueL4vF1LSUBRmkKNxVwqimNW7bJ2EsBqxm+Js15YBmTkPeXQa7I2
	gHhx28LNHK/Io+O0Mz0ouC/TDrnaeSm3g0lBRM1+SlHc0JnwS1DXeZ1kzpaH3xsN25IChh
	DJSHCKt+oxm9VjlepfYuwHY7QnrRhBY=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783071998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zJMERwFqgJnL5lBJ2s0ak5dfDBegJTM2T1zQ2JmLD9s=;
	b=g72QIHh0T/OOjwl5QSueL4vF1LSUBRmkKNxVwqimNW7bJ2EsBqxm+Js15YBmTkPeXQa7I2
	gHhx28LNHK/Io+O0Mz0ouC/TDrnaeSm3g0lBRM1+SlHc0JnwS1DXeZ1kzpaH3xsN25IChh
	DJSHCKt+oxm9VjlepfYuwHY7QnrRhBY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A51C2779AA
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Jul 2026 09:46:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8OmNFf2ER2rdBAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2026 09:46:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/3] btrfs: add "rescue=usebackuproot" into "rescue=all" shortcut
Date: Fri,  3 Jul 2026 19:16:07 +0930
Message-ID: <4d93b2f36b84d9fa86a4efd54683379e956f92de.1783071857.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.984];
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

The mount option "rescue=all" should be a shortcut to include all
"rescue=" mount options. But unfortunately "rescue=usebackuproot" is not
included.

Include that option so "rescue=all" has a better chance to mount a
corrupted fs.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e561c8811d6d..e52e80fd9e1f 100644
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

