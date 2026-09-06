Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419A5361940
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 05:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788672404; cv=none; b=uke0pt953p4qRoChx3gisVj/5bD1HSaeecGfsfQanJIIfpYNL2K/Khy1WRfQ8hfc5muzZhBSKFEUH9kg+HbnQOaOMEePvz61lFxcLp+u//2IUJR5hx4o7TOSrihKCSmjbQz7s0hbEOtVX09U9gvYVSJJeb0fMfTewIUB7kR+YRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788672404; c=relaxed/simple;
	bh=lRmCyZSJZV+/3rosGKE7QgTYKchKOktScI33cmQR/Hk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEvN+DoNEmUjEIG+nwAbVxLy1lOq/sNNCdTAf/1vlCaF88IO2lmgqiksJph0FFXVgUJWk0Stv8qklPYk05+xHuGuzWazD3kf/wFNVX8R1Pmlfrzk/B8+NX9mt13XS+K1PL/mcz6Ot7pvIdhHzYShvU3wIEZYJMJsiJdHKuZ282I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jPUNpD9f; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=c02HlnOf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jPUNpD9f";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="c02HlnOf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 17F2D2090D
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 05:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788672397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bpzqbRj6isxyocaP748h+CeZR6upOtTGl1gcxMm8UT4=;
	b=jPUNpD9fI0ODUUhG7BZovOf4tydnVqNTjv9mbKXTGi5D9gvPWI04rCQDQDQMiGoJdoYEgw
	3Vf9GEobC8JR7VbdPTwhzxz+A9OokY/76fBt56qDtO7vUR0SSaCsFxBoU0dcb+spPiUdDZ
	yNmR8xm4WeHp6GHyQYJY8ynJ8YMzoew=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=c02HlnOf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788672393; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bpzqbRj6isxyocaP748h+CeZR6upOtTGl1gcxMm8UT4=;
	b=c02HlnOfU6ad4HGgrd5EGJI05nq4NrTNXa2luImZkT6+dLrEYstNC6AR5t9gnk/dR/8gEB
	DeKkz0N89jfCCeNUZkw4HFTQMY5szmAJvSeHc3Tk7JDfRFSR30JbRT+y2ifkhxdlKQVPI9
	RLqo8eDdkrzkMUF2J2HfxN5KLcGRaWo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D70B71368D
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 05:26:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aKxMIYf5nGqVUAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 05:26:31 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: always use the second newest slot for rescue=usebackuproot
Date: Sun,  6 Sep 2026 14:56:06 +0930
Message-ID: <377dbda4759e0c7bd95551a2f2b34098e4e0cb14.1788671975.git.wqu@suse.com>
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
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 17F2D2090D
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO

[RESCUE FAILURE]
There is a bug report that "rescue=usebackuproot" failed to properly
mount the fs, but if using btrfs-mod-sb to use the second newest slot,
then the fs can even pass the full "btrfs check" and be mounted RW.

[CAUSE]
During init_tree_roots(), "rescue=usebackuproot" only makes a difference
if the tree and chunk roots failed to be load.

The loading only requires the root node/leaf to be properly loaded:

- tree root
- extent tree
- block group tree
- device tree
- data reloc tree
- quota tree (optional)
- uuid tree
- raid stripe tree (for RST feature)

And it doesn't really check any child tree blocks, thus for a lot of
cases, "rescue=usebackuproot" won't make a difference.

[ENHANCEMENT]
Instead of trying every slot and settling down on the first passing
backup slot, always use the second newest slot.

The newest slot should always match the root info in the super block,
and if it worked the end user should not even need to bother to use
backup root.

Older backup slots normally have a very low chance to work.

Link: https://github.com/kdave/btrfs-progs/issues/1162#issuecomment-5475477108
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 102 +++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a1d83ad9a4c0..422fda467440 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2709,73 +2709,55 @@ static int __cold init_tree_roots(struct btrfs_fs_info *fs_info)
 	int backup_index = find_newest_super_backup(fs_info);
 	struct btrfs_super_block *sb = fs_info->super_copy;
 	struct btrfs_root *tree_root = fs_info->tree_root;
-	bool handle_error = false;
+	bool use_backup = btrfs_test_opt(fs_info, USEBACKUPROOT);
 	int ret = 0;
-	int i;
 
-	for (i = 0; i < BTRFS_NUM_BACKUP_ROOTS; i++) {
-		if (handle_error) {
-			if (!IS_ERR(tree_root->node))
-				free_extent_buffer(tree_root->node);
-			tree_root->node = NULL;
-
-			if (!btrfs_test_opt(fs_info, USEBACKUPROOT))
-				break;
-
-			free_root_pointers(fs_info, 0);
-
-			/*
-			 * Don't use the log in recovery mode, it won't be
-			 * valid
-			 */
-			btrfs_set_super_log_root(sb, 0);
-
-			btrfs_warn(fs_info, "try to load backup roots slot %d", i);
-			ret = read_backup_root(fs_info, i);
-			backup_index = ret;
-			if (ret < 0)
-				return ret;
+	if (use_backup) {
+		ret = read_backup_root(fs_info, 1);
+		if (ret < 0) {
+			btrfs_err(fs_info,
+				  "failed to load backup roots at slot %d", 1);
+			return ret;
 		}
-
-		ret = load_important_roots(fs_info);
-		if (ret) {
-			handle_error = true;
-			continue;
-		}
-
 		/*
-		 * No need to hold btrfs_root::objectid_mutex since the fs
-		 * hasn't been fully initialised and we are the only user
+		 * Don't use the log in recovery mode, it won't be
+		 * valid
 		 */
-		ret = btrfs_init_root_free_objectid(tree_root);
-		if (ret < 0) {
-			handle_error = true;
-			continue;
-		}
-
-		ASSERT(tree_root->free_objectid <= BTRFS_LAST_FREE_OBJECTID);
-
-		ret = btrfs_read_roots(fs_info);
-		if (ret < 0) {
-			handle_error = true;
-			continue;
-		}
-
-		/* All successful */
-		fs_info->generation = btrfs_header_generation(tree_root->node);
-		btrfs_set_last_trans_committed(fs_info, fs_info->generation);
-		fs_info->last_reloc_trans = 0;
-
-		/* Always begin writing backup roots after the one being used */
-		if (backup_index < 0) {
-			fs_info->backup_root_index = 0;
-		} else {
-			fs_info->backup_root_index = backup_index + 1;
-			fs_info->backup_root_index %= BTRFS_NUM_BACKUP_ROOTS;
-		}
-		break;
+		btrfs_set_super_log_root(sb, 0);
+		backup_index = ret;
+		btrfs_warn(fs_info, "loaded backup roots at slot %d", 1);
 	}
 
+	ret = load_important_roots(fs_info);
+	if (ret)
+		return ret;
+
+	/*
+	 * No need to hold btrfs_root::objectid_mutex since the fs
+	 * hasn't been fully initialised and we are the only user
+	 */
+	ret = btrfs_init_root_free_objectid(tree_root);
+	if (ret < 0)
+		return ret;
+
+	ASSERT(tree_root->free_objectid <= BTRFS_LAST_FREE_OBJECTID);
+
+	ret = btrfs_read_roots(fs_info);
+	if (ret < 0)
+		return ret;
+
+	/* All successful */
+	fs_info->generation = btrfs_header_generation(tree_root->node);
+	btrfs_set_last_trans_committed(fs_info, fs_info->generation);
+	fs_info->last_reloc_trans = 0;
+
+	/* Always begin writing backup roots after the one being used */
+	if (backup_index < 0) {
+		fs_info->backup_root_index = 0;
+	} else {
+		fs_info->backup_root_index = backup_index + 1;
+		fs_info->backup_root_index %= BTRFS_NUM_BACKUP_ROOTS;
+	}
 	return ret;
 }
 
-- 
2.55.0

