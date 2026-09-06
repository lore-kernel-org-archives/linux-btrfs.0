Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D111335E926
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 05:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788672406; cv=none; b=o7+J5HTasGU8ItclYYCB0gbE6fwSS2kNTo2yXpdE/UZDZgjO61/U5M1b6rvpCf7da2xE4Fd5kK9Tm56oS8tKnjcYIPQJLh/LElanXDge9dWs0U0nAp9EQIcxLUNysPSoxXm6Y8tVlFmX667p3qfuVIQkYmOqXLzi9bi5hpQF3Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788672406; c=relaxed/simple;
	bh=CUwQNTmobTONzIgOs+YKCg5m3Bfprp++nR5IHEZM/7c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5s9R23b+FK/Pr7t9Ii2gw9jCV/iVkwTzlzh1Yt5+yqt/nvV2DA1KHpM4s5nH4BdPqO58zp/pdh1TrczU+iXMl4HvDlRh94Py4F9m/PyVlXUZvmFiZQkPrYwNznM+Yf/1vTRZ+Fsods2a+88M6gm46ygiQswnnLl1IhYxGkiZAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KFz9NrEI; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UxyqJD3f; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KFz9NrEI";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UxyqJD3f"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AEEE52090E
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 05:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788672398; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BVfLpDM8LrECn1lQADQJgPXQ1kNCz1PTeStIbYj2f/E=;
	b=KFz9NrEIzcr3mNGxLDz7K/yKxPzRcsQWFQHKyuYY/FJnY+wOjGFw2qhg2/ok6xNuu2deZl
	iIClvKuppQzmDAMHvyKWZ3Hefqk0zw3ITWDgc3WV2tzI7Js1ioVhLLF2rMOuwTUWH92MMR
	t/0gfh6bYzB3SGXsY65SX9hFyj2m4+Q=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788672394; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BVfLpDM8LrECn1lQADQJgPXQ1kNCz1PTeStIbYj2f/E=;
	b=UxyqJD3fb4dIFGyalVUIk01ptP1ykLupmF8gvHlBkBZu8FKHm73zSxhL6qmpzvFWDAhgJ4
	UtbIQeE3bYiEn4soUvyjEjQCyl0b2d9ENFFyMuFn/twoWnFuL5BPG/gDGuz4Oefz240Uj8
	IutA9h8bqoAAuBDPcJ6eyGs6WFBdlDI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 798D513712
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 05:26:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wA14Con5nGqVUAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 05:26:33 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: introduce more accurate usebackuproot options
Date: Sun,  6 Sep 2026 14:56:07 +0930
Message-ID: <da2ad95fa130801be8f2bc8724baa39a98b2229d.1788671975.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788671975.git.wqu@suse.com>
References: <cover.1788671975.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

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

The number 0 means the newest backup slot, 1/2/3 means the
second/third/fourth(oldest) backup slot to use.

The existing "rescue=usebackuproot" is just an alias of
"rescue=usebackuproot_1".

This will allow users to choose which backup root to use.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 12 +++++++++---
 fs/btrfs/fs.h      |  1 +
 fs/btrfs/super.c   | 20 ++++++++++++++++++++
 3 files changed, 30 insertions(+), 3 deletions(-)

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
index 464129b1b0d4..a9c95cb2ed5c 100644
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
@@ -587,8 +596,16 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_rescue:
 		switch (result.uint_32) {
 		case Opt_rescue_usebackuproot:
+			ctx->use_backup_slot = 1;
 			btrfs_set_opt(ctx->mount_opt, USEBACKUPROOT);
 			break;
+		case Opt_rescue_usebackup_slot_0:
+		case Opt_rescue_usebackup_slot_1:
+		case Opt_rescue_usebackup_slot_2:
+		case Opt_rescue_usebackup_slot_3:
+			btrfs_set_opt(ctx->mount_opt, USEBACKUPROOT);
+			ctx->use_backup_slot = result.uint_32 - Opt_rescue_usebackup_slot_0;
+			break;
 		case Opt_rescue_nologreplay:
 			btrfs_set_opt(ctx->mount_opt, NOLOGREPLAY);
 			break;
@@ -1406,6 +1423,7 @@ static void btrfs_ctx_to_info(struct btrfs_fs_info *fs_info, struct btrfs_fs_con
 	fs_info->mount_opt = ctx->mount_opt;
 	fs_info->compress_type = ctx->compress_type;
 	fs_info->compress_level = ctx->compress_level;
+	fs_info->use_backup_slot = ctx->use_backup_slot;
 }
 
 static void btrfs_info_to_ctx(struct btrfs_fs_info *fs_info, struct btrfs_fs_context *ctx)
@@ -1417,6 +1435,7 @@ static void btrfs_info_to_ctx(struct btrfs_fs_info *fs_info, struct btrfs_fs_con
 	ctx->mount_opt = fs_info->mount_opt;
 	ctx->compress_type = fs_info->compress_type;
 	ctx->compress_level = fs_info->compress_level;
+	ctx->use_backup_slot = fs_info->use_backup_slot;
 }
 
 #define btrfs_info_if_set(fs_info, old_ctx, opt, fmt, args...)			\
@@ -2205,6 +2224,7 @@ static int btrfs_init_fs_context(struct fs_context *fc)
 	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
 		btrfs_info_to_ctx(btrfs_sb(fc->root->d_sb), ctx);
 	} else {
+		ctx->use_backup_slot = -1;
 		ctx->thread_pool_size =
 			min_t(unsigned long, num_online_cpus() + 2, 8);
 		ctx->max_inline = BTRFS_DEFAULT_MAX_INLINE;
-- 
2.55.0

