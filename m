Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793090160;
	b=TfKLn/8jVCjpIPeT7JNTGQMYUDqpdlVIfJRkDItyLkv7cRk95Oj+8hAEYuiSt4tp0GKK
	 xsqBRlBiDql0VEsUiqrQ7d3n2GyZcWWZKorYBUp72HUhigP69p4Ah8b8NbNeC/2bpbAlG
	 FEN5rmFqrLwoiUjrnOtJW9IJwZiOKBA4UpWNjV3ftgErBNGlvePv/IE2xJ2uIY+rLxyl4
	 jf+MOmsPFAEby32Jq2cnPUKhLy7GE2nizaehSQzQQHLTDPMplv3r8ON7MzHDJEre7Ttz1
	 dMvjDEeYtcYZHLQjI2FUgMzITRVJsCuHsbOKp+A5P8bSCZcroXEFWnUy+1/3E04mg0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090160;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=CMSF/Jt4sTgkEV3CSLvnIFRjrWuzlesQYWcS0vRngv0=;
	b=0FjwkF5xYGt89doAAYuJBeCg82lH7i2OwCwHLuKUQOlK3/dCule6QSwlTJR1XLWTQ2Ei
	 uVqTqi+NnbmYEtPP7gyiJ/WJfoRvR2ZTsxE52nRsmTvKaeD60ng54NQ/5mxxvinHraC2y
	 D1VsXVMa/QqAJeBzf48yWEvhvtVq3TTLU+b3WIfrqaH0mNDXaHDZDl1QBiS+bsVqpvFSM
	 KjXTYgLeuKOfDRf3aCPKr8AwNgt8+TVINZzv8TAs7MalaaPjXvVVKn6XppoyWUOOs0Tna
	 Ykf0E0SCYgeltIlzUcu36yXb/Y4CFG6W5DAx/naH2gjcORBLZ8UKvufGr4s14Q91gUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JvIqXovB;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JvIqXovB;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7AD606A324
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 08:35:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F7AD606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JvIqXovB;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JvIqXovB
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B3BF82294A
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 08:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793090157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CMSF/Jt4sTgkEV3CSLvnIFRjrWuzlesQYWcS0vRngv0=;
	b=JvIqXovBjxh0tBx0C6KmBWsa02pY0K+ewaAVDyCsR3iSBv89h3lHRyQy562/fVNmVS4M47
	5TEbKoHxTrR6We+q65QtaCKcDPIYG7BG0WUuBZeyXblaK8FZf5aDWLk5k0RiygaAkZwatl
	3HA9F4PbWhdMGXgzpRVdepzBs25n3aM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793090157; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CMSF/Jt4sTgkEV3CSLvnIFRjrWuzlesQYWcS0vRngv0=;
	b=JvIqXovBjxh0tBx0C6KmBWsa02pY0K+ewaAVDyCsR3iSBv89h3lHRyQy562/fVNmVS4M47
	5TEbKoHxTrR6We+q65QtaCKcDPIYG7BG0WUuBZeyXblaK8FZf5aDWLk5k0RiygaAkZwatl
	3HA9F4PbWhdMGXgzpRVdepzBs25n3aM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 958EA13419
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 08:35:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bsDdEGpi4GqbGgAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 08:35:56 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: remove set but unused variables
Date: Tue, 27 Oct 2026 19:05:31 +1030
Message-ID: <c6f4910af35bae312954f65abe096b08f2e09a41.1793090084.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793090084.git.wqu@suse.com>
References: <cover.1793090084.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

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

