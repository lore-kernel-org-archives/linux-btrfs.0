Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BA0175A63
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2026 07:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775891673; cv=none; b=FNHOqOKNweu6AvPAcOwnPgXOLd5nH0CvjQA43G4vHFNs5sBruqiJ3ABUXE1iS7/6XK1LLUGeyyOVEZdsnOHcT3EDC/oEs2fPvdG1X+1ceJ3nhpU5aBbb84vTzwMW1aZDD2M8B+HnnhNZjI7oRnU/IgHrk0XrJckP99fKdD1xQ/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775891673; c=relaxed/simple;
	bh=D4TW3+JEFcyUE3iUrxe+fgTAni9iLSBUsgrClGyHKCc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=P+xdei3OAnaBeuCfazVn6rlgZb8kmxe9546tFf3BM9Kdxjl5gh6BCKOhrMb2TfKwsGL6/kD5++A780TPKucnbZDwybw7wycbxb+zfW+e5/kBRfiQtEq6JdXEKUg03yxMjE+jPl03wgbLrMRAcSohA+1RNeF2jkd5q5AigqfzANQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QxtAmlGD; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QxtAmlGD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QxtAmlGD";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QxtAmlGD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C49465BCE9
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2026 07:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775891669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cEoB25uEqiLPZ3oKUsUb74SmNjS+9Op+1ZZqYDhhBro=;
	b=QxtAmlGDvFFJxRx0EYGwAu+ik+9zZI7U3bRbct+5lFpi0cl52hzHW8n02/eV8g1rKLR3wq
	qirHLIbQPXMNrgNajgzMSiSupixU2SuAnDicAfFgDFF3kDIaSsjsW2Fh7ptlA7XfwLGuio
	TX9zBlt+yigfmvn5uQ+aosbzawWj/Nw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775891669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cEoB25uEqiLPZ3oKUsUb74SmNjS+9Op+1ZZqYDhhBro=;
	b=QxtAmlGDvFFJxRx0EYGwAu+ik+9zZI7U3bRbct+5lFpi0cl52hzHW8n02/eV8g1rKLR3wq
	qirHLIbQPXMNrgNajgzMSiSupixU2SuAnDicAfFgDFF3kDIaSsjsW2Fh7ptlA7XfwLGuio
	TX9zBlt+yigfmvn5uQ+aosbzawWj/Nw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C2F2E4A259
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2026 07:14:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9EQAHNT02WnuKQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Apr 2026 07:14:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: reject writes if the fs has running replace/balance
Date: Sat, 11 Apr 2026 16:44:02 +0930
Message-ID: <0ec0bc8fa6d3a331d0e49d5a1b365d31863e7d66.1775891635.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.77
X-Spam-Level: 
X-Spamd-Result: default: False [-2.77 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.17)[-0.865];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Btrfs-progs never has the ability to handle reloc trees, thus if a btrfs
with running balance is passed to btrfstune, btrfstune will just ignore
all the reloc trees and continue modifying the fs.

This can easily screw up the balance resume on the next RW mount and
corrupt the fs.

For dev-replace it's very similar, we can modify the metadata before the
current replace cursor, causing writes that will not be written to the
dev-replace target device and cause corruption.

Reject those fses with running replace/balance to prevent corruption for
the following tools:

- btrfstune
  All write operations will be rejected.

- btrfs check --clear-space-cache
- btrfs rescue clear-space-cache
- btrfs rescue fix-data-checksum
- btrfs rescue clear-uuid-tree
- btrfs rescue clear-ino-cache
- btrfs check --repair

Some "btrfs rescue" subcommands do not start a new transaction and
directly update the super blocks, thus they are safe from the
replace/balance.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-check.rst   |  3 ++
 Documentation/btrfs-rescue.rst  |  4 +++
 Documentation/btrfstune.rst     |  4 +++
 check/main.c                    | 13 ++++++++
 cmds/rescue-fix-data-checksum.c |  9 ++++++
 cmds/rescue.c                   | 19 +++++++++++
 common/clear-cache.c            | 57 +++++++++++++++++++++++++++++++++
 common/clear-cache.h            |  1 +
 tune/main.c                     | 10 ++++++
 9 files changed, 120 insertions(+)

diff --git a/Documentation/btrfs-check.rst b/Documentation/btrfs-check.rst
index 176639e71d73..cdcc603fe815 100644
--- a/Documentation/btrfs-check.rst
+++ b/Documentation/btrfs-check.rst
@@ -110,6 +110,9 @@ DANGEROUS OPTIONS
                 *--force* to give users a chance to think twice before running repair, the
                 warnings in documentation have shown to be insufficient.
 
+	.. note::
+		Please finish/cancel the running replace/balance before using this command.
+
 --init-csum-tree
         create a new checksum tree and recalculate checksums in all files
 
diff --git a/Documentation/btrfs-rescue.rst b/Documentation/btrfs-rescue.rst
index b4070714f56b..f8de733d1800 100644
--- a/Documentation/btrfs-rescue.rst
+++ b/Documentation/btrfs-rescue.rst
@@ -12,6 +12,10 @@ DESCRIPTION
 A set of commands that are targeting to fix a specific problem and may not
 suitable for :doc`btrfs-check`.
 
+.. note::
+   All the subcommands can not handle an ongoing replace/balance, please finish/cancel
+   the replace/balance before using this command.
+
 SUBCOMMAND
 ----------
 
diff --git a/Documentation/btrfstune.rst b/Documentation/btrfstune.rst
index c7d592bcaca2..6811851f92bf 100644
--- a/Documentation/btrfstune.rst
+++ b/Documentation/btrfstune.rst
@@ -21,6 +21,10 @@ complete list of features and kernel version of their introduction at
 Some of the features could be also enabled on a mounted filesystem by other
 means.  Please refer to the *FILESYSTEM FEATURES* in :doc:`btrfs-man5`.
 
+.. note::
+   :command:`btrfstune` requires the target fs to have no running replace nor balance.
+   Please finish/cancel the running replace/balance before using :command:`btrfstune`.
+
 OPTIONS
 -------
 
diff --git a/check/main.c b/check/main.c
index a16423103529..daddd5e05f82 100644
--- a/check/main.c
+++ b/check/main.c
@@ -10825,6 +10825,19 @@ static int cmd_check(const struct cmd_struct *cmd, int argc, char **argv)
 		err |= !!ret;
 		goto err_out;
 	}
+	if (opt_check_repair) {
+		ret = has_running_replace_or_balance(gfs_info);
+		if (ret < 0) {
+			err |= !!ret;
+			goto close_out;
+		}
+		if (ret > 0) {
+			error("please finish/cacnel the running replace/balance before running this command");
+			ret = -EINVAL;
+			err |= !!ret;
+			goto close_out;
+		}
+	}
 
 	root = gfs_info->fs_root;
 	uuid_unparse(gfs_info->super_copy->fsid, uuidbuf);
diff --git a/cmds/rescue-fix-data-checksum.c b/cmds/rescue-fix-data-checksum.c
index cee187e9b83e..a4bf4c066088 100644
--- a/cmds/rescue-fix-data-checksum.c
+++ b/cmds/rescue-fix-data-checksum.c
@@ -24,6 +24,7 @@
 #include "kernel-shared/file-item.h"
 #include "common/messages.h"
 #include "common/open-utils.h"
+#include "common/clear-cache.h"
 #include "cmds/rescue.h"
 
 /*
@@ -492,6 +493,14 @@ int btrfs_recover_fix_data_checksum(const char *path, enum btrfs_fix_data_checks
 		error("failed to open btrfs at %s", path);
 		return -EIO;
 	}
+	ret = has_running_replace_or_balance(fs_info);
+	if (ret < 0)
+		goto out_close;
+	if (ret > 0) {
+		error("please finish/cancel the running replace/balance before running this command");
+		ret = -EINVAL;
+		goto out_close;
+	}
 	csum_root = btrfs_csum_root(fs_info, 0);
 	if (!csum_root) {
 		error("failed to get csum root");
diff --git a/cmds/rescue.c b/cmds/rescue.c
index 4af5415d6761..00a4e909a91e 100644
--- a/cmds/rescue.c
+++ b/cmds/rescue.c
@@ -466,7 +466,17 @@ static int cmd_rescue_clear_uuid_tree(const struct cmd_struct *cmd,
 		goto out;
 	}
 
+	ret = has_running_replace_or_balance(fs_info);
+	if (ret < 0)
+		goto out_close;
+	if (ret > 0) {
+		error("please finish/cancel the running replace/balance before running this command");
+		ret = -EINVAL;
+		goto out_close;
+	}
+
 	ret = clear_uuid_tree(fs_info);
+out_close:
 	close_ctree(fs_info->tree_root);
 out:
 	return !!ret;
@@ -511,6 +521,14 @@ static int cmd_rescue_clear_ino_cache(const struct cmd_struct *cmd,
 		ret = -EIO;
 		goto out;
 	}
+	ret = has_running_replace_or_balance(fs_info);
+	if (ret < 0)
+		goto out_close;
+	if (ret > 0) {
+		error("please finish/cancel the running replace/balance before running this command");
+		ret = -EINVAL;
+		goto out_close;
+	}
 	ret = clear_ino_cache_items(fs_info);
 	if (ret < 0) {
 		errno = -ret;
@@ -518,6 +536,7 @@ static int cmd_rescue_clear_ino_cache(const struct cmd_struct *cmd,
 	} else {
 		pr_default("Successfully cleared ino cache\n");
 	}
+out_close:
 	close_ctree(fs_info->tree_root);
 out:
 	return !!ret;
diff --git a/common/clear-cache.c b/common/clear-cache.c
index c90ae738439e..891decd75707 100644
--- a/common/clear-cache.c
+++ b/common/clear-cache.c
@@ -98,10 +98,67 @@ int btrfs_clear_v1_cache(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+/*
+ * Return <0 for critical errors, mostly tree search failure.
+ * Return >0 if there is a running balance or replace.
+ * Return 0 if there is no running balance nor replace.
+ */
+int has_running_replace_or_balance(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_root *dev_root = fs_info->dev_root;
+	struct btrfs_path path = { 0 };
+	struct btrfs_key key;
+	struct btrfs_dev_replace_item *dri;
+	u64 replace_state;
+	int ret;
+
+	key.objectid = BTRFS_BALANCE_OBJECTID;
+	key.type = BTRFS_TEMPORARY_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, tree_root, &key, &path, 0, 0);
+	btrfs_release_path(&path);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return 1;
+
+	key.objectid = 0;
+	key.type = BTRFS_DEV_REPLACE_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
+	if (ret < 0)
+		return ret;
+	if (ret > 0) {
+		btrfs_release_path(&path);
+		return 0;
+	}
+	/*
+	 * We still need to check if the dev_replace item to determine if
+	 * there is a running replace.
+	 */
+	dri = btrfs_item_ptr(path.nodes[0], path.slots[0], struct btrfs_dev_replace_item);
+	replace_state = btrfs_dev_replace_replace_state(path.nodes[0], dri);
+	btrfs_release_path(&path);
+	if (replace_state == BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED ||
+	    replace_state == BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED)
+		return 1;
+	return 0;
+}
+
 int do_clear_free_space_cache(struct btrfs_fs_info *fs_info, int clear_version)
 {
 	int ret = 0;
 
+	ret = has_running_replace_or_balance(fs_info);
+	if (ret < 0)
+		return ret;
+	if (ret > 0) {
+		error("please finish/cancel the running replace/balance before running this command");
+		return -EINVAL;
+	}
 	if (clear_version == 1) {
 		if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
 			warning(
diff --git a/common/clear-cache.h b/common/clear-cache.h
index 1cdf49051244..1e31e2d5b0aa 100644
--- a/common/clear-cache.h
+++ b/common/clear-cache.h
@@ -26,5 +26,6 @@ int do_clear_free_space_cache(struct btrfs_fs_info *fs_info, int clear_version);
 int validate_free_space_cache(struct btrfs_root *root, struct task_ctx *task_ctx);
 int truncate_free_ino_items(struct btrfs_root *root);
 int clear_ino_cache_items(struct btrfs_fs_info *fs_info);
+int has_running_replace_or_balance(struct btrfs_fs_info *fs_info);
 
 #endif
diff --git a/tune/main.c b/tune/main.c
index 32189502f988..3dd110e0dba9 100644
--- a/tune/main.c
+++ b/tune/main.c
@@ -415,6 +415,16 @@ int BOX_MAIN(btrfstune)(int argc, char *argv[])
 	}
 	fs_info = root->fs_info;
 
+	ret = has_running_replace_or_balance(fs_info);
+	if (ret < 0) {
+		ret = 1;
+		goto out;
+	}
+	if (ret > 0) {
+		error("please finish/cancel the running replace/balance before running this command");
+		ret = 1;
+		goto out;
+	}
 	/*
 	 * As we increment the generation number here, it is unlikely that the
 	 * missing device will have a higher generation number, and the kernel
-- 
2.53.0

