Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E30E34B669
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788757721; cv=none; b=qsC6Tqnk2WJW88iZCTKt2WxoqTfcYEydgTwCtTv+AIKDF2SUqbJnvEwsD9NQBa4B/jGLumRWSF28jUQQnvG6nO67fPldYdmj0Nf2POfNfeAjT5zTY3aWdIOkAX6Ks+9IdsUrIwZMg3mZr22e0/ulu+a6ieHClegDiJUGOgmgGy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788757721; c=relaxed/simple;
	bh=q9qHYLpqdSEcgGvxI5GxO2ojTYCmwH3c5ZinjpMLlW0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdcjMfWlEa0oL95XQdaJUWT3CI10+QhSEE0CBHy2lnDGbEnmFhyb8xQzyL20oDgSN/BEhXP3ooUXAM98yzpO4OaKIFue6uA/Wp+3N6xCfZ4HEOMJ54mB1syawPIaUk14YWxoQ+Fwhywk2oZkHtLuHy+GOh+XNtBaeyJfg59lxDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ie76fmGc; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=umRa2XKN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ie76fmGc";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="umRa2XKN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EF48821AED
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788757709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bydeazfyNMwKQ/2TMNRo9QaujJADwaO4iTAJiYLTgnc=;
	b=Ie76fmGcDAQ8xTZcgX7w9kMxuEKDWifvZzA5P6/4VvGho1HO006B+DGx0xQTqvmR5y0/64
	h4HXb+qk3SPoOiek5wAxVhcwopzp8k6Bj9L0eR6T4+REI+gIdEhRIBXj27aWpm7ToUeUpN
	bI36lxKRO6STwmqGBly8NsocRNKg9zw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788757704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bydeazfyNMwKQ/2TMNRo9QaujJADwaO4iTAJiYLTgnc=;
	b=umRa2XKNoXOdt8r1Gs+3tyDTRwAgx+x1K912Ri6TaGBAmradAaVge54MtFrTl35FAwrbYB
	AuahXKFTGx3QLyYTboswMVgQs3bpdJbO2/1+mMmJ4cnuUsmha5HXq8Bm6f5F1xIuc433qK
	OS3aruPeosYKudz66M1A+etU8imTHDI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8247137CA
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +N+uGcdGnmoDBAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 05:08:23 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs-progs: check: use correct generation when -r option is provided
Date: Mon,  7 Sep 2026 14:37:54 +0930
Message-ID: <17a30897f8886c136ea0597b747f8d3b2adfa6aa.1788743334.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788743334.git.wqu@suse.com>
References: <cover.1788743334.git.wqu@suse.com>
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

[MINOR WARNING]
When using "-r|--tree-root <bytenr>" option, even if a completely valid
tree root (e.g. from backup root) is provided, btrfs check will still
give warning on the transid mismatch:

 Opening filesystem to check...
 parent transid verify failed on 30605312 wanted 9 found 8
 parent transid verify failed on 30605312 wanted 9 found 8
 parent transid verify failed on 30605312 wanted 9 found 8
 Ignoring transid failure
 Checking filesystem on test.img

[CAUSE]
When using "-r|--tree-root <bytenr>" option, btrfs-check is still using
the generation/level from the super block, thus it will always cause
transid mismatch warning.

On the other hand, "--chunk-root <bytenr>" option will properly read out
the tree block and use the tree block's level/generation to avoid such
warning.

[ENHANCEMENT]
Follow the handling of "--chunk-root" option, by reading out the tree
block and use its generation/level for later read verification.

With this fixed, now btrfs check no longer gives transid mismatch
warning:

 Opening filesystem to check...
 Checking filesystem on /home/adam/test.img
 UUID: 7d1773d5-9f1f-4109-9736-a2c996d1bcae
 ...

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/disk-io.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/kernel-shared/disk-io.c b/kernel-shared/disk-io.c
index 2b1f6c7f6cad..195d9e5df688 100644
--- a/kernel-shared/disk-io.c
+++ b/kernel-shared/disk-io.c
@@ -1216,15 +1216,27 @@ static int load_important_roots(struct btrfs_fs_info *fs_info,
 	btrfs_setup_root(root, fs_info, BTRFS_BLOCK_GROUP_TREE_OBJECTID);
 
 tree_root:
-	if (backup) {
+	if (root_tree_bytenr) {
+		struct extent_buffer *eb;
+		struct btrfs_tree_parent_check check = { 0 };
+
+		eb = read_tree_block(fs_info, root_tree_bytenr, &check);
+		if (IS_ERR(eb)) {
+			ret = PTR_ERR(eb);
+			errno = -ret;
+			error("unable to read tree block at %llu: %m", root_tree_bytenr);
+			return ret;
+		}
+		bytenr = root_tree_bytenr;
+		level = btrfs_header_level(eb);
+		gen = btrfs_header_generation(eb);
+		free_extent_buffer(eb);
+	} else if (backup) {
 		bytenr = btrfs_backup_tree_root(backup);
 		gen = btrfs_backup_tree_root_gen(backup);
 		level = btrfs_backup_tree_root_level(backup);
 	} else {
-		if (root_tree_bytenr)
-			bytenr = root_tree_bytenr;
-		else
-			bytenr = btrfs_super_root(sb);
+		bytenr = btrfs_super_root(sb);
 		gen = btrfs_super_generation(sb);
 		level = btrfs_super_root_level(sb);
 	}
-- 
2.55.0

