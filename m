Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793093715;
	b=k+3G2X6uQys/HbEYeMZhvodAf0N8v8uev2kxSO8y7ndqhUU1e781iWNDCX25QzjGxeyb
	 XvJU9x3lcpTPJkRXvaIsNJpzpAFNIlaeoh4HxHwIfjup5HpzRsrPlZVZX5/enlqnCOfAv
	 Lz5p4hS6EDjyM9Nf9w2qVOZstl5paA0twIPS2sYMPuJypbcNNTP4WcLSv9cVUn67/j5SE
	 VThM04xU8Lt5zolb7lw2fGfsTvQ51NxgZ9ck++f5mHu+iRMTG7roL9H1VpLf8QQ65bt9O
	 hBHq8ua+egUzK8uAT9nWBxoiEZPF2zt4FJ6U3XdI4q7TrwWS2WLDwPuGMd+HnSUKlIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793093715;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=ITMy8kB39N/ZIcx7DylbUHM81nVAV40VjM++X/M/13U=;
	b=DKePS6EZ0DHvfuG5vqNRzK+JYW1Q+3yWaNX0UQAzLJeO4J/AjTK3JArvzFKQxo89zhXY
	 pduiFqUjWMpR/hjNVWIYWE33O7qAhuDs8xf8uE6X2Haphp19tU8VKN/O3OVrdrm9tfGI0
	 sBFWDtOJ4vSFKeyOi0qc/VvHycLsrGa9w+KDfGtSWXLc0iLKc/b8yggRKL20FX8gRbc3u
	 C+9IBD3dqV2QpYBY75AlurFWQIO1pkbSLxAmt4zzNtoMkzNSM2A4EK6EN4b2odxKwmaM0
	 59V2LtUcYQAmUj18TY0gq3vlUp6+yDoa8eL5iM/fq4zwXPPiZaewmoHFSLNWQRKUDfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=CQlj2ufF;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=CQlj2ufF;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72D9606A325
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 09:35:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D72D9606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=CQlj2ufF;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=CQlj2ufF
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 09BB921FDA;
	Tue, 27 Oct 2026 09:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793093713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ITMy8kB39N/ZIcx7DylbUHM81nVAV40VjM++X/M/13U=;
	b=CQlj2ufFvs4gj6hPlWMSlj3PAPahopRpok0flCIYSWD7IkWc4KizMdjF1cWRzeuQc6tPFk
	/4LCHDmArNBzvVbWqPAIoOnU6IZlso7JUh0h1taXDmzw4+K3I/dLJCyYXObRAKMOpGHmvz
	v6z4aGxmoWjAFN2mvTmMIFZVaIABdeo=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=CQlj2ufF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793093713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ITMy8kB39N/ZIcx7DylbUHM81nVAV40VjM++X/M/13U=;
	b=CQlj2ufFvs4gj6hPlWMSlj3PAPahopRpok0flCIYSWD7IkWc4KizMdjF1cWRzeuQc6tPFk
	/4LCHDmArNBzvVbWqPAIoOnU6IZlso7JUh0h1taXDmzw4+K3I/dLJCyYXObRAKMOpGHmvz
	v6z4aGxmoWjAFN2mvTmMIFZVaIABdeo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96AF413319;
	Tue, 27 Oct 2026 09:35:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RUo5FE1w4Gr8VgAAD6G6ig:T2
	(envelope-from <wqu@suse.com>); Tue, 27 Oct 2026 09:35:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Daniel Vacek <neelx@suse.com>
Subject: [PATCH v2 1/2] btrfs-progs: remove set but unused variables
Date: Tue, 27 Oct 2026 20:04:50 +1030
Message-ID: <5d60c6639a4e4c71e20afe6d3ffa7ed65fed76dc.1793093611.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793093611.git.wqu@suse.com>
References: <cover.1793093611.git.wqu@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 09BB921FDA

If using clang to compile btrfs-progs, two warnings will be reported:

 cmds/rescue-fix-data-checksum.c:73:12: warning: variable 'global_repair_mode' set but not used [-Wunused-but-set-global]
    73 | static int global_repair_mode;
       |            ^
 1 warning generated.
 cmds/inspect-tree-stats.c:43:12: warning: variable 'verbose' set but not used [-Wunused-but-set-global]
    43 | static int verbose = 0;
       |            ^
 1 warning generated.

Both are correct reports, so just remove them.

Reviewed-by: Daniel Vacek <neelx@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/inspect-tree-stats.c       | 3 ---
 cmds/rescue-fix-data-checksum.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/cmds/inspect-tree-stats.c b/cmds/inspect-tree-stats.c
index c6907bb0cd78..b45416fd16b7 100644
--- a/cmds/inspect-tree-stats.c
+++ b/cmds/inspect-tree-stats.c
@@ -40,8 +40,6 @@
 #include "common/units.h"
 #include "cmds/commands.h"
 
-static int verbose = 0;
-
 struct seek {
 	u64 distance;
 	u64 count;
@@ -462,7 +460,6 @@ static int cmd_inspect_tree_stats(const struct cmd_struct *cmd,
 	while ((opt = getopt(argc, argv, "vbt:")) != -1) {
 		switch (opt) {
 		case 'v':
-			verbose++;
 			break;
 		case 'b':
 			unit_mode = UNITS_RAW;
diff --git a/cmds/rescue-fix-data-checksum.c b/cmds/rescue-fix-data-checksum.c
index 3925d5170627..121fb0b46ca8 100644
--- a/cmds/rescue-fix-data-checksum.c
+++ b/cmds/rescue-fix-data-checksum.c
@@ -70,7 +70,6 @@ static const struct fix_data_checksum_action {
 	},
 };
 
-static int global_repair_mode;
 LIST_HEAD(corrupted_blocks);
 
 static int add_corrupted_block(struct btrfs_fs_info *fs_info, u64 logical,
@@ -486,7 +485,6 @@ int btrfs_recover_fix_data_checksum(const char *path, enum btrfs_fix_data_checks
 		return -EBUSY;
 	}
 
-	global_repair_mode = mode;
 	oca.filename = path;
 	oca.flags = OPEN_CTREE_WRITES;
 	fs_info = open_ctree_fs_info(&oca);
-- 
2.56.0

