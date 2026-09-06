Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326A4327BFC
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 07:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788678261; cv=none; b=rinOo85gO1TnNS1/U/gSYLZdZQFuYjb0KijnAQFahNw+5fmTU4NrW2/mI2mO07Yrvb4vQgz4+eNQiiBdD5XHNf/ZgEQ5nlo4uLBOzB+ojl2JG0PFoGpA+PcEKcDNyHZsKz31DRmY52ySfuM9hd3wuPwZudhW0WBtghY+Ub4PxZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788678261; c=relaxed/simple;
	bh=8E1rYiG/7pKIiqHTJSj5zdaRGhPsQnDYbC6mlHFEIVo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3HvK6NRfHhiJKFG/9t5Ucgrs3vtXnb5X36Yslc5NG+0hUStcxRuu+ynpSUrFHJJGWsDunVwrlSYGd6jKozsQGqMZ8sxGjHuV247Q9gVXRE3wE1IRsPagoRPJJucXSwnwSIlLf5GsKFbxZT+rJuWi0e0RaSJdvuMIOmHnSNwBtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=k2EkGSVN; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=st5QrKsn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="k2EkGSVN";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="st5QrKsn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E3C2B1F766
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 07:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788678254; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KrtV8nRYog8CoTqhGN4kxuqx4NjzGgHVcxKkHAiD+Bg=;
	b=k2EkGSVN5G7w3MstYSHv4KM8AVE/BQMfazjsO4Z5SYksoiqnsVXn79K9UxfoDu+LEQv2/D
	4VJHjtwOChxgHE5oRzsZ2gf5u9DZVDZVusLzQ1zHlA0x9HNONCNMHY7AVLHOpPwhdOPoIH
	8uIrBfqkgUzT9gD8xc3Dh4j639cW+xg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788678249; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KrtV8nRYog8CoTqhGN4kxuqx4NjzGgHVcxKkHAiD+Bg=;
	b=st5QrKsnZ7ew6t2kZugarfQVzRhqteK+SfAFDYuwWg7NrvXRplDtuX5qv3f2sHbRgpx/lC
	129KOy7A32qR20ILNQxAK1pkiylPQ8aScz5c+DauP4H+ZK1QiaGo7Z9c5Otfwdfo8DnKPi
	SLpRsG4OJN9mAJubQISHU45Pha/aUjU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ABF3A13712
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 07:04:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MKbWFmgQnWpUMAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 07:04:08 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: introduce more accurate usebackuproot options
Date: Sun,  6 Sep 2026 16:33:38 +0930
Message-ID: <9c907c139ede11a4b3026bd15b310de034690bc6.1788678078.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788678078.git.wqu@suse.com>
References: <cover.1788678078.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Previously we had no way to tell btrfs to use which backup slot, but
always use the newest backup, and retry until all backup roots are
exhausted.

This doesn't give any control to the end user, even if the end user
wants to use a specific backup slot.

To address this problem, allow more fine-control on usebackuproot rescue
option by introducing the following 4 rescue mount options:

- rescue=usebackuproot_0
- rescue=usebackuproot_1
- rescue=usebackuproot_2
- rescue=usebackuproot_3

The number 0 means the newest slot, which should be the same as the one
recorded in the super block and no need to load any backup root.

1/2/3 means the second/third/fourth(oldest) backup slot to use.

The existing "rescue=usebackuproot" is just an alias of
"rescue=usebackuproot_1".

This will allow users to choose which backup root to use, thus can have
a better control than blindly choose any slot that can pass the very
basic root node checks.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 12 +++++++++---
 fs/btrfs/fs.h      |  1 +
 fs/btrfs/super.c   | 28 ++++++++++++++++++++++++++--
 3 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 422fda467440..406c46d1fba1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2713,10 +2713,14 @@ static int __cold init_tree_roots(struct btrfs_fs_info *fs_info)
 	int ret = 0;
 
 	if (use_backup) {
-		ret = read_backup_root(fs_info, 1);
+		ASSERT(fs_info->use_backup_slot >= 0 &&
+		       fs_info->use_backup_slot < BTRFS_NUM_BACKUP_ROOTS);
+
+		ret = read_backup_root(fs_info, fs_info->use_backup_slot);
 		if (ret < 0) {
 			btrfs_err(fs_info,
-				  "failed to load backup roots at slot %d", 1);
+				  "failed to load backup roots at slot %d",
+				  fs_info->use_backup_slot);
 			return ret;
 		}
 		/*
@@ -2725,7 +2729,8 @@ static int __cold init_tree_roots(struct btrfs_fs_info *fs_info)
 		 */
 		btrfs_set_super_log_root(sb, 0);
 		backup_index = ret;
-		btrfs_warn(fs_info, "loaded backup roots at slot %d", 1);
+		btrfs_warn(fs_info, "loaded backup roots at slot %d",
+			   fs_info->use_backup_slot);
 	}
 
 	ret = load_important_roots(fs_info);
@@ -2896,6 +2901,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	init_waitqueue_head(&fs_info->async_submit_wait);
 	init_waitqueue_head(&fs_info->delayed_iputs_wait);
 
+	fs_info->use_backup_slot = -1;
 	/* Usable values until the real ones are cached from the superblock */
 	fs_info->nodesize = 4096;
 	fs_info->sectorsize = 4096;
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 3eba8438593c..649623c603e8 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -857,6 +857,7 @@ struct btrfs_fs_info {
 
 	/* Next backup root to be overwritten */
 	int backup_root_index;
+	int use_backup_slot;
 
 	/* Device replace state */
 	struct btrfs_dev_replace dev_replace;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 464129b1b0d4..b5c1ff357aaf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -87,6 +87,7 @@ struct btrfs_fs_context {
 	unsigned long long mount_opt;
 	unsigned long compress_type:4;
 	int compress_level;
+	int use_backup_slot;
 	refcount_t refs;
 };
 
@@ -175,6 +176,10 @@ static const struct constant_table btrfs_parameter_space_cache[] = {
 
 enum {
 	Opt_rescue_usebackuproot,
+	Opt_rescue_usebackup_slot_0,
+	Opt_rescue_usebackup_slot_1,
+	Opt_rescue_usebackup_slot_2,
+	Opt_rescue_usebackup_slot_3,
 	Opt_rescue_nologreplay,
 	Opt_rescue_ignorebadroots,
 	Opt_rescue_ignoredatacsums,
@@ -185,6 +190,10 @@ enum {
 
 static const struct constant_table btrfs_parameter_rescue[] = {
 	{ "usebackuproot", Opt_rescue_usebackuproot },
+	{ "usebackuproot_0", Opt_rescue_usebackup_slot_0},
+	{ "usebackuproot_1", Opt_rescue_usebackup_slot_1},
+	{ "usebackuproot_2", Opt_rescue_usebackup_slot_2},
+	{ "usebackuproot_3", Opt_rescue_usebackup_slot_3},
 	{ "nologreplay", Opt_rescue_nologreplay },
 	{ "ignorebadroots", Opt_rescue_ignorebadroots },
 	{ "ibadroots", Opt_rescue_ignorebadroots },
@@ -588,6 +597,14 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		switch (result.uint_32) {
 		case Opt_rescue_usebackuproot:
 			btrfs_set_opt(ctx->mount_opt, USEBACKUPROOT);
+			ctx->use_backup_slot = 1;
+			break;
+		case Opt_rescue_usebackup_slot_0:
+		case Opt_rescue_usebackup_slot_1:
+		case Opt_rescue_usebackup_slot_2:
+		case Opt_rescue_usebackup_slot_3:
+			btrfs_set_opt(ctx->mount_opt, USEBACKUPROOT);
+			ctx->use_backup_slot = result.uint_32 - Opt_rescue_usebackup_slot_0;
 			break;
 		case Opt_rescue_nologreplay:
 			btrfs_set_opt(ctx->mount_opt, NOLOGREPLAY);
@@ -611,6 +628,7 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			btrfs_set_opt(ctx->mount_opt, IGNOREBADROOTS);
 			btrfs_set_opt(ctx->mount_opt, NOLOGREPLAY);
 			btrfs_set_opt(ctx->mount_opt, USEBACKUPROOT);
+			ctx->use_backup_slot = 1;
 			break;
 		default:
 			btrfs_info(NULL, "unrecognized rescue option '%s'",
@@ -1089,8 +1107,11 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",notreelog");
 	if (btrfs_test_opt(info, NOLOGREPLAY))
 		print_rescue_option(seq, "nologreplay", &printed);
-	if (btrfs_test_opt(info, USEBACKUPROOT))
-		print_rescue_option(seq, "usebackuproot", &printed);
+	if (btrfs_test_opt(info, USEBACKUPROOT)) {
+		seq_printf(seq, "%susebackuproot_%d", printed ? ":" : ",rescue=",
+			   info->use_backup_slot);
+		printed = true;
+	}
 	if (btrfs_test_opt(info, IGNOREBADROOTS))
 		print_rescue_option(seq, "ignorebadroots", &printed);
 	if (btrfs_test_opt(info, IGNOREDATACSUMS))
@@ -1406,6 +1427,7 @@ static void btrfs_ctx_to_info(struct btrfs_fs_info *fs_info, struct btrfs_fs_con
 	fs_info->mount_opt = ctx->mount_opt;
 	fs_info->compress_type = ctx->compress_type;
 	fs_info->compress_level = ctx->compress_level;
+	fs_info->use_backup_slot = ctx->use_backup_slot;
 }
 
 static void btrfs_info_to_ctx(struct btrfs_fs_info *fs_info, struct btrfs_fs_context *ctx)
@@ -1417,6 +1439,7 @@ static void btrfs_info_to_ctx(struct btrfs_fs_info *fs_info, struct btrfs_fs_con
 	ctx->mount_opt = fs_info->mount_opt;
 	ctx->compress_type = fs_info->compress_type;
 	ctx->compress_level = fs_info->compress_level;
+	ctx->use_backup_slot = fs_info->use_backup_slot;
 }
 
 #define btrfs_info_if_set(fs_info, old_ctx, opt, fmt, args...)			\
@@ -2205,6 +2228,7 @@ static int btrfs_init_fs_context(struct fs_context *fc)
 	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
 		btrfs_info_to_ctx(btrfs_sb(fc->root->d_sb), ctx);
 	} else {
+		ctx->use_backup_slot = -1;
 		ctx->thread_pool_size =
 			min_t(unsigned long, num_online_cpus() + 2, 8);
 		ctx->max_inline = BTRFS_DEFAULT_MAX_INLINE;
-- 
2.55.0

