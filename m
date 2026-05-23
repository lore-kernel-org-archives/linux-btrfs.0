Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF13C31E83E
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 16:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779554029; cv=none; b=pT6gxUR4sMg2Iz8qAzTK0xP7oYZD+JnMHc7kOjRaNvqZBq9nn1qz67ShghASUJfEKvzNudD21wP/8vObShh3VK7fYqFHS9cA5vYZ/OrgqgOOOc/p40fQ1jHFXWBlJUjFxcuXSsU2vMm1ekQ/4yySWrOqKZHPtyQIF0S2DGxFiJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779554029; c=relaxed/simple;
	bh=73BBpuvJFeMU7B4Vo/FJpC+Sc10TQBW33LLQbQdPpQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jgEQ3q67Gd3O7BSVEmfeRr940gVLS6IcXg5OGxTMP6fviAu2/XjklA8rn2Bu0Yim9q7kkKFt/btll0OPClPyJpgG+emryNvKhZWsECiz6p0q/qn64p8gtPclnfX/vyc+HcowFWpRIv6c+yiwCFUBCzL7xqYxeSXbMX93KkjzWec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=u+Ftires; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=u+Ftires; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="u+Ftires";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="u+Ftires"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0E76668451;
	Sat, 23 May 2026 16:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779554026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LsCcA9kbZOs8cI/YxQJWtR7S6BXwNuj370CwysRPQEI=;
	b=u+FtiresE4/iyP9bxoN8T5pEL76coUncEKYnTEw1HTtFecKX3Cs1qTDpjnqGcwNQbRNqRr
	XX5PgDvuvM7y8fxUy7N8UiYWvUK4FzZtvqqliMW5CRZfA04fszLqq1UDsCkWw6L4vH0G4M
	EEI/na/O8AkXtIAYJx/af1FwPPWDEQw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779554026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LsCcA9kbZOs8cI/YxQJWtR7S6BXwNuj370CwysRPQEI=;
	b=u+FtiresE4/iyP9bxoN8T5pEL76coUncEKYnTEw1HTtFecKX3Cs1qTDpjnqGcwNQbRNqRr
	XX5PgDvuvM7y8fxUy7N8UiYWvUK4FzZtvqqliMW5CRZfA04fszLqq1UDsCkWw6L4vH0G4M
	EEI/na/O8AkXtIAYJx/af1FwPPWDEQw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0373F593A8;
	Sat, 23 May 2026 16:33:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4DVlAOrWEWqXJgAAD6G6ig
	(envelope-from <dsterba@suse.com>); Sat, 23 May 2026 16:33:45 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: add message format for qgroupid
Date: Sat, 23 May 2026 18:33:41 +0200
Message-ID: <20260523163341.243653-1-dsterba@suse.com>
X-Mailer: git-send-email 2.54.0
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

The qgroupid has a specific format, add common format specifier, similar
to what we have for checksums and keys.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/fs.h     |  4 ++++
 fs/btrfs/qgroup.c | 25 ++++++++++---------------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index d3b439fd611f78..a0d4eb3d5ad22e 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -79,6 +79,10 @@ static_assert(sizeof(struct btrfs_super_block) == BTRFS_SUPER_INFO_SIZE);
 #define BTRFS_KEY_FMT			"(%llu %u %llu)"
 #define BTRFS_KEY_FMT_VALUE(key)	(key)->objectid, (key)->type, (key)->offset
 
+#define BTRFS_QGROUP_FMT		"%hu/%llu"
+#define BTRFS_QGROUP_FMT_VALUE(qgroup)	btrfs_qgroup_level((qgroup)->qgroupid), \
+					btrfs_qgroup_subvolid((qgroup)->qgroupid)
+
 /*
  * Number of metadata items necessary for an unlink operation:
  *
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 384622bd786997..502fb4a55cb227 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -373,10 +373,9 @@ static bool squota_check_parent_usage(struct btrfs_fs_info *fs_info, struct btrf
 		    parent->excl_cmpr != excl_cmpr_sum || parent->rfer_cmpr != rfer_cmpr_sum);
 
 	WARN(mismatch,
-	     "parent squota qgroup %hu/%llu has mismatched usage from its %d members. "
+	     "parent squota qgroup " BTRFS_QGROUP_FMT " has mismatched usage from its %d members. "
 	     "%llu %llu %llu %llu vs %llu %llu %llu %llu\n",
-	     btrfs_qgroup_level(parent->qgroupid),
-	     btrfs_qgroup_subvolid(parent->qgroupid), nr_members, parent->excl,
+	     BTRFS_QGROUP_FMT_VALUE(parent), nr_members, parent->excl,
 	     parent->rfer, parent->excl_cmpr, parent->rfer_cmpr, excl_sum,
 	     rfer_sum, excl_cmpr_sum, rfer_cmpr_sum);
 	return mismatch;
@@ -652,9 +651,8 @@ bool btrfs_check_quota_leak(const struct btrfs_fs_info *fs_info)
 			if (qgroup->rsv.values[i]) {
 				ret = true;
 				btrfs_warn(fs_info,
-		"qgroup %hu/%llu has unreleased space, type %d rsv %llu",
-				   btrfs_qgroup_level(qgroup->qgroupid),
-				   btrfs_qgroup_subvolid(qgroup->qgroupid),
+		"qgroup " BTRFS_QGROUP_FMT " has unreleased space, type %d rsv %llu",
+				   BTRFS_QGROUP_FMT_VALUE(qgroup),
 				   i, qgroup->rsv.values[i]);
 			}
 		}
@@ -1863,9 +1861,8 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 		     qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS])) {
 		DEBUG_WARN();
 		btrfs_warn_rl(fs_info,
-"to be deleted qgroup %u/%llu has non-zero numbers, data %llu meta prealloc %llu meta pertrans %llu",
-			      btrfs_qgroup_level(qgroup->qgroupid),
-			      btrfs_qgroup_subvolid(qgroup->qgroupid),
+"to be deleted qgroup " BTRFS_QGROUP_FMT " has non-zero numbers, data %llu meta prealloc %llu meta pertrans %llu",
+			      BTRFS_QGROUP_FMT_VALUE(qgroup),
 			      qgroup->rsv.values[BTRFS_QGROUP_RSV_DATA],
 			      qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC],
 			      qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS]);
@@ -1883,9 +1880,8 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 			     qgroup->rfer_cmpr || qgroup->excl_cmpr)) {
 			DEBUG_WARN();
 			qgroup_mark_inconsistent(fs_info,
-				"to be deleted qgroup %u/%llu has non-zero numbers, rfer %llu rfer_cmpr %llu excl %llu excl_cmpr %llu",
-				btrfs_qgroup_level(qgroup->qgroupid),
-				btrfs_qgroup_subvolid(qgroup->qgroupid),
+"to be deleted qgroup " BTRFS_QGROUP_FMT " has non-zero numbers, rfer %llu rfer_cmpr %llu excl %llu excl_cmpr %llu",
+				BTRFS_QGROUP_FMT_VALUE(qgroup),
 				qgroup->rfer, qgroup->rfer_cmpr,
 				qgroup->excl, qgroup->excl_cmpr);
 		}
@@ -4971,9 +4967,8 @@ int btrfs_record_squota_delta(struct btrfs_fs_info *fs_info,
 		ASSERT(qg->excl == qg->rfer);
 		if (WARN_ON_ONCE(sign < 0 && qg->excl < num_bytes)) {
 			btrfs_warn(fs_info,
-				   "squota underflow qg %hu/%llu excl %llu num_bytes %llu",
-				   btrfs_qgroup_level(qg->qgroupid),
-				   btrfs_qgroup_subvolid(qg->qgroupid),
+				   "squota underflow qg " BTRFS_QGROUP_FMT " excl %llu num_bytes %llu",
+				   BTRFS_QGROUP_FMT_VALUE(qg),
 				   qg->excl, num_bytes);
 			qg->excl = 0;
 			qg->rfer = 0;
-- 
2.54.0

