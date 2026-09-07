Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C45637E5D8
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788757724; cv=none; b=ol6WlJvTAgQ5Zj7tL/3Dxjf6sz19QQ78Ifptd6oAyh67C8TMy2XG8jAmkkwGhdZaEitpDJnrqQncK58fstUDgCrdZQASjKm7oznWrB4OvrzShsV6QV+83xyrD4LOuxJkdjLWXNoW5Y+H0vJ1BLPHMTFBkk5PC7mTZyM+4bxWRGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788757724; c=relaxed/simple;
	bh=mZgpBs1nRzw18ht+pcrrgiWSZDkvgPbrT9rL57oLROA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqNf+1CJcY8AjhQz3ewhhVYtA7TqJz42Ja6JNAYouDyBZWa9uEpCdaLPHa53IE+kBJNTIulNbr4qI1VIl+vjVkt6ymjVaPUbaKdS1HXeTIINDNqg+WDlZOYpmgOT6mWsR5qJnEkhu2cHseYDbKo0jKKSqEQK8T+iKd/z6yylfEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dH0MrVr9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rPxnOuO7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dH0MrVr9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rPxnOuO7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 93AD01F45E
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788757710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7tlEjjy3NSi9EJ5/NWuqRvLgHVqqV1HyUxAy2kKOLlw=;
	b=dH0MrVr9WK1t1ZM5hpPYTLQ7hPI1O8zwcKf9393Eb4hVBeO39rkmfeCqJbilPtLozqYwCN
	JQu28IX9jZS6j7mzuUDlDI3N0fXa1oxJGa+lLjSElOikscxCQofPJtWhTyOZ964E+un+ta
	q8ZzL0e7xcdJwAcyMMYuvamYegtlCl4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788757706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7tlEjjy3NSi9EJ5/NWuqRvLgHVqqV1HyUxAy2kKOLlw=;
	b=rPxnOuO79Yo8BDGI+Iu+ymB2uzLcoUvey9rHR6vc4Znn2Tpr16KvuCcw7jif2nN2GAJexg
	LgcMYaGYYcz4bDBXvye9SeGmS27qa7+GA5L2Fg11n0BOUTpTqqD+nyz7Jz2Bxsj1LduPgQ
	Xx9vzffUCFBaphTnqmKn/YN9j7pDmnk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B9D0138A5
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aFIVA8lGnmoDBAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 05:08:25 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs-progs: check: introduce --backup-slot option
Date: Mon,  7 Sep 2026 14:37:55 +0930
Message-ID: <7d6e89441f38b5893b17a03619aa3460c5a5438b.1788743334.git.wqu@suse.com>
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
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

Just like the recent "rescue=usebackuproot_*" mount option, introduce a
similar option for btrfs-check, --backup-slot n.

This will allow the end user to select exact which backup slot to use.

This is inspired by a user report that btrfs-sb-mod is required to use a
specific backup root to fix a corrupted fs.

Previously it's still possible using btrfs-check's --chunk-root and
--tree-root option, but it requires extra dump-super output and manually
passing those bytenrs.

Now it will be much easier to just use a single option to do the same
work.

Link: https://github.com/kdave/btrfs-progs/issues/1162#issuecomment-5475477108
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-check.rst | 12 ++++++--
 check/main.c                  | 58 +++++++++++++++++++++++++++++++++--
 kernel-shared/disk-io.c       | 58 ++++++++++++++++++++++++++---------
 kernel-shared/disk-io.h       |  9 ++++++
 4 files changed, 117 insertions(+), 20 deletions(-)

diff --git a/Documentation/btrfs-check.rst b/Documentation/btrfs-check.rst
index 99fea5ae1d5d..b4a891f951dd 100644
--- a/Documentation/btrfs-check.rst
+++ b/Documentation/btrfs-check.rst
@@ -47,10 +47,16 @@ filesystem, similarly the run time. Check the modes that can also affect that.
 SAFE OR ADVISORY OPTIONS
 ------------------------
 
--b|--backup
-        use the first valid set of backup roots stored in the superblock
+--backup-slot <n>
+	use the *n*-th newest set of backup roots stored in the superblock
 
-        This can be combined with *--super* if some of the superblocks are damaged.
+	If *n* is 0, it means the latest backup roots, which should match the superblock.
+	If *n* is 1/2/3, it means the second/third/fourth(oldest) newest backup roots.
+
+	This option conflicts with *-r|--tree-root* and *--chunk-root* options.
+
+-b|--backup
+	this is an alias to *--backup-slot 1* option
 
 --check-data-csum
         verify checksums of data blocks
diff --git a/check/main.c b/check/main.c
index b96498294645..1f1df04d5354 100644
--- a/check/main.c
+++ b/check/main.c
@@ -10575,6 +10575,36 @@ static bool check_early_critical_roots(void)
 	return ret;
 }
 
+static int parse_backup_slot(const char *optarg, unsigned int *ctree_flags)
+{
+	u64 slot;
+
+	slot = arg_strtou64(optarg);
+	if (slot >= BTRFS_NUM_BACKUP_ROOTS)
+		return -EINVAL;
+
+	/* Clear any existing slot flag first. */
+	*ctree_flags &= ~OPEN_CTREE_BACKUP_SLOT_MASK;
+	switch (slot) {
+	case 0:
+		*ctree_flags |= OPEN_CTREE_BACKUP_SLOT_0;
+		break;
+	case 1:
+		*ctree_flags |= OPEN_CTREE_BACKUP_SLOT_1;
+		break;
+	case 2:
+		*ctree_flags |= OPEN_CTREE_BACKUP_SLOT_2;
+		break;
+	case 3:
+		*ctree_flags |= OPEN_CTREE_BACKUP_SLOT_3;
+		break;
+	default:
+		return -EINVAL;
+	}
+	*ctree_flags |= OPEN_CTREE_BACKUP_ROOT;
+	return 0;
+}
+
 static const char * const cmd_check_usage[] = {
 	"btrfs check [options] <device>",
 	"Check structural integrity of a filesystem (unmounted).",
@@ -10586,7 +10616,8 @@ static const char * const cmd_check_usage[] = {
 	"",
 	"Starting point selection:",
 	OPTLINE("-s, --super NUMBER", "use this superblock copy"),
-	OPTLINE("-b, --backup", "use the first valid backup root copy"),
+	OPTLINE("--backup-slot <n>", "use the <n>th newest backup root copy"),
+	OPTLINE("-b, --backup", "alias to \"--backup-slot 1\""),
 	OPTLINE("-r, --tree-root ", "use the given bytenr for the tree root"),
 	OPTLINE("--chunk-root BYTENR", "use the given bytenr for the chunk tree root"),
 	"",
@@ -10634,6 +10665,7 @@ static int cmd_check(const struct cmd_struct *cmd, int argc, char **argv)
 	bool readonly = false;
 	bool qgroup_report = false;
 	bool force = false;
+	bool backup_slot_set = false;
 	int clear_space_cache = 0;
 	int qgroups_repaired = 0;
 	int qgroup_verify_ret;
@@ -10647,7 +10679,8 @@ static int cmd_check(const struct cmd_struct *cmd, int argc, char **argv)
 			GETOPT_VAL_INIT_EXTENT, GETOPT_VAL_CHECK_CSUM,
 			GETOPT_VAL_READONLY, GETOPT_VAL_CHUNK_TREE,
 			GETOPT_VAL_MODE, GETOPT_VAL_CLEAR_SPACE_CACHE,
-			GETOPT_VAL_FORCE, GETOPT_VAL_SKIP_QGROUP_ACCOUNTING };
+			GETOPT_VAL_FORCE, GETOPT_VAL_SKIP_QGROUP_ACCOUNTING,
+			GETOPT_VAL_BACKUP_SLOT };
 		static const struct option long_options[] = {
 			{ "super", required_argument, NULL, 's' },
 			{ "repair", no_argument, NULL, GETOPT_VAL_REPAIR },
@@ -10661,6 +10694,8 @@ static int cmd_check(const struct cmd_struct *cmd, int argc, char **argv)
 			{ "skip-qgroup-accounting", no_argument, NULL,
 				GETOPT_VAL_SKIP_QGROUP_ACCOUNTING },
 			{ "backup", no_argument, NULL, 'b' },
+			{ "backup-slot", required_argument, NULL,
+				GETOPT_VAL_BACKUP_SLOT },
 			{ "subvol-extents", required_argument, NULL, 'E' },
 			{ "qgroup-report", no_argument, NULL, 'Q' },
 			{ "tree-root", required_argument, NULL, 'r' },
@@ -10681,7 +10716,12 @@ static int cmd_check(const struct cmd_struct *cmd, int argc, char **argv)
 		switch(c) {
 			case 'a': /* ignored */ break;
 			case 'b':
-				ctree_flags |= OPEN_CTREE_BACKUP_ROOT;
+				ret = parse_backup_slot("1", &ctree_flags);
+				if (ret < 0) {
+					error("invalid backup slot, must be 0/1/2/3");
+					exit(1);
+				}
+				backup_slot_set = true;
 				break;
 			case 's':
 				num = arg_strtou64(optarg);
@@ -10755,6 +10795,14 @@ static int cmd_check(const struct cmd_struct *cmd, int argc, char **argv)
 				}
 				ctree_flags |= OPEN_CTREE_WRITES;
 				break;
+			case GETOPT_VAL_BACKUP_SLOT:
+				ret = parse_backup_slot(optarg, &ctree_flags);
+				if (ret < 0) {
+					error("invalid backup slot, must be 0/1/2/3");
+					exit(1);
+				}
+				backup_slot_set = true;
+				break;
 			case GETOPT_VAL_FORCE:
 				force = true;
 				break;
@@ -10786,6 +10834,10 @@ static int cmd_check(const struct cmd_struct *cmd, int argc, char **argv)
 		error("--skip-qgroup-accounting is not compatible with --qgroup-report");
 		exit(1);
 	}
+	if (backup_slot_set && (chunk_root_bytenr || tree_root_bytenr)) {
+		error("--backup|--backup-slot is not compatible with --chunk-root|--tree-root");
+		exit(1);
+	}
 
 	if (opt_check_repair && !force) {
 		int delay = 10;
diff --git a/kernel-shared/disk-io.c b/kernel-shared/disk-io.c
index 195d9e5df688..12737e9cc238 100644
--- a/kernel-shared/disk-io.c
+++ b/kernel-shared/disk-io.c
@@ -1184,26 +1184,45 @@ out:
 	return ret;
 }
 
+static unsigned int find_target_backup_index(const struct btrfs_super_block *sb,
+					     unsigned int flags)
+{
+	u64 gen = 0;
+	u64 newest_index = 0;
+
+	for (int i = 0; i < BTRFS_NUM_BACKUP_ROOTS; i++) {
+		const struct btrfs_root_backup *backup = sb->super_roots + i;
+
+		if (btrfs_backup_tree_root_gen(backup) > gen) {
+			newest_index = i;
+			gen = btrfs_backup_tree_root_gen(backup);
+		}
+	}
+
+	if (!(flags & OPEN_CTREE_BACKUP_SLOT_MASK))
+		flags |= OPEN_CTREE_BACKUP_SLOT_1;
+
+	if (flags & OPEN_CTREE_BACKUP_SLOT_0)
+		return newest_index;
+	if (flags & OPEN_CTREE_BACKUP_SLOT_1)
+		return (newest_index + BTRFS_NUM_BACKUP_ROOTS - 1) %
+			BTRFS_NUM_BACKUP_ROOTS;
+	if (flags & OPEN_CTREE_BACKUP_SLOT_2)
+		return (newest_index + BTRFS_NUM_BACKUP_ROOTS - 2) %
+			BTRFS_NUM_BACKUP_ROOTS;
+	return (newest_index + BTRFS_NUM_BACKUP_ROOTS - 3) %
+		BTRFS_NUM_BACKUP_ROOTS;
+}
+
 static int load_important_roots(struct btrfs_fs_info *fs_info,
 				u64 root_tree_bytenr, unsigned flags)
 {
 	struct btrfs_super_block *sb = fs_info->super_copy;
-	struct btrfs_root_backup *backup = NULL;
 	struct btrfs_root *root;
 	u64 bytenr, gen;
 	int level;
-	int index = -1;
 	int ret;
 
-	if (flags & OPEN_CTREE_BACKUP_ROOT) {
-		index = find_best_backup_root(sb);
-		if (index >= BTRFS_NUM_BACKUP_ROOTS) {
-			fprintf(stderr, "Invalid backup root number\n");
-			return -EIO;
-		}
-		backup = sb->super_roots + index;
-	}
-
 	if (!btrfs_fs_compat_ro(fs_info, BLOCK_GROUP_TREE) &&
 	    !(btrfs_super_flags(fs_info->super_copy) &
 	      BTRFS_SUPER_FLAG_CHANGING_BG_TREE)) {
@@ -1231,7 +1250,10 @@ tree_root:
 		level = btrfs_header_level(eb);
 		gen = btrfs_header_generation(eb);
 		free_extent_buffer(eb);
-	} else if (backup) {
+	} else if (flags & OPEN_CTREE_BACKUP_ROOT) {
+		unsigned int index = find_target_backup_index(sb, flags);
+		struct btrfs_root_backup *backup = sb->super_roots + index;
+
 		bytenr = btrfs_backup_tree_root(backup);
 		gen = btrfs_backup_tree_root_gen(backup);
 		level = btrfs_backup_tree_root_level(backup);
@@ -1490,7 +1512,8 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 }
 
 static int setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
-					   u64 chunk_root_bytenr)
+					   u64 chunk_root_bytenr,
+					   unsigned int flags)
 {
 	struct btrfs_super_block *sb = fs_info->super_copy;
 	u64 generation;
@@ -1525,6 +1548,13 @@ static int setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
 		}
 		level = btrfs_header_level(eb);
 		free_extent_buffer(eb);
+	} else if (flags & OPEN_CTREE_BACKUP_ROOT) {
+		unsigned int index = find_target_backup_index(sb, flags);
+		struct btrfs_root_backup *backup = sb->super_roots + index;
+
+		chunk_root_bytenr = btrfs_backup_chunk_root(backup);
+		generation = btrfs_backup_chunk_root_gen(backup);
+		level = btrfs_backup_chunk_root_level(backup);
 	} else {
 		chunk_root_bytenr = btrfs_super_chunk_root(sb);
 		generation = btrfs_super_chunk_root_generation(sb);
@@ -1678,7 +1708,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, struct open_ctree_args *oca
 	if (fcntl(fp, F_GETFL) & O_DIRECT)
 		fs_info->zoned = 1;
 
-	ret = setup_chunk_tree_and_device_map(fs_info, oca->chunk_tree_bytenr);
+	ret = setup_chunk_tree_and_device_map(fs_info, oca->chunk_tree_bytenr, flags);
 	if (ret)
 		goto out_chunk;
 
diff --git a/kernel-shared/disk-io.h b/kernel-shared/disk-io.h
index b3e85c89eab7..34ef038b678f 100644
--- a/kernel-shared/disk-io.h
+++ b/kernel-shared/disk-io.h
@@ -113,7 +113,16 @@ enum btrfs_open_ctree_flags {
 	 * Use the superblock of the latest device for the transaction commit.
 	 */
 	OPEN_CTREE_USE_LATEST_BDEV		= (1U << 18),
+
+	/* To use which backup slot. */
+	OPEN_CTREE_BACKUP_SLOT_0		= (1U << 19),
+	OPEN_CTREE_BACKUP_SLOT_1		= (1U << 20),
+	OPEN_CTREE_BACKUP_SLOT_2		= (1U << 21),
+	OPEN_CTREE_BACKUP_SLOT_3		= (1U << 22),
 };
+#define OPEN_CTREE_BACKUP_SLOT_MASK		\
+	(OPEN_CTREE_BACKUP_SLOT_0 | OPEN_CTREE_BACKUP_SLOT_1 |\
+	 OPEN_CTREE_BACKUP_SLOT_2 | OPEN_CTREE_BACKUP_SLOT_3)
 
 /*
  * Modes of superblock access
-- 
2.55.0

