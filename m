Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600F63E1222
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 22:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774909346; cv=none; b=qBISLx5LTbOqSEp056pgAQ9kTyfCCA1J5K5mIouclohtGJV3F1C22wirTMGfk3PKX0SVE0B4zxVy+tQvqoWcRn4lpTEAvK5wIDgbOlP3bjhYUpWZnL1XpvFrXskdxNUjoycT7jSewNhxeqp1uU25vCYaD67lVYxTci5A4Ff7/04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774909346; c=relaxed/simple;
	bh=b+TLeYNQPN1rQ82P5PWHY3En9fHY+SqVAzzoUjFr91c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=B5+PTBNFWJgDv7vQT1OVOyw2aEl1HIV0cALO9MmHCIel33tDL3WMn9aTLsIFCrkm3fEtD46ZbJ7xPbMJWPeZVWMzW/4T7JEp+sOqeyI+WTEZk0p6pW2SWwEGlMHAjhUDHpoV5Xq3IUzmHPchYG+fWYko84Gu3QXr1B4wi/TweLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=J4/qiBEb; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=J4/qiBEb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="J4/qiBEb";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="J4/qiBEb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A0EF34D267
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 22:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774909334; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Y85FNtF3K/O3Mbff1fvqiec75KzzTb/zdNztsgCeBYA=;
	b=J4/qiBEbwvgo7s3ilZ/nsH0Fz8tj1nIiuLs83vWJmbGLc3I1RfIF/AIkwUV66Z13zKO/Qj
	Ehsdw2Egz/KkaCqKMLnxkZ3wbdxXWKbThcHCbU8+ck3yKc+RBGzcrANAVlflLU2ba262Ot
	Fs1VsNXiBxCWAaNZ3pflKPD7LE2lCFk=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="J4/qiBEb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774909334; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Y85FNtF3K/O3Mbff1fvqiec75KzzTb/zdNztsgCeBYA=;
	b=J4/qiBEbwvgo7s3ilZ/nsH0Fz8tj1nIiuLs83vWJmbGLc3I1RfIF/AIkwUV66Z13zKO/Qj
	Ehsdw2Egz/KkaCqKMLnxkZ3wbdxXWKbThcHCbU8+ck3yKc+RBGzcrANAVlflLU2ba262Ot
	Fs1VsNXiBxCWAaNZ3pflKPD7LE2lCFk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D3C864A0A2
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 22:22:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NIUoJJX3ymnnNwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 22:22:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: only invalidate btree inode pages after all ebs are released
Date: Tue, 31 Mar 2026 08:51:56 +1030
Message-ID: <90443bccdf0d1d7f93f945c0fc0c64cca438a82b.1774909310.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email]
X-Rspamd-Queue-Id: A0EF34D267
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

In close_ctree(), we call invalidate_inode_pages2() to invalidate all
pages from btree inode.

But the problem is, it never returns 0, but always -EBUSY.

The problem is that we are still holding all the essential tree root
nodes, thus pages hodling those tree blocks can not be invalidated thus
invalidate_inode_pages2() always return -EBUSY.

This is also against the error cleanup path of open_ctree(), which
properly free all root pointers before calling invalidate_inode_pages().

So fix the order by delaying invalidate_inode_pages2() until we have
freed all root pointers.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
In theory we should also check the return value from
invalidate_inode_pages2(), which can still return -EBUSY if we have
pending metadata readahead, but that's a problem Teng Liu is working on
and I don't want to take credit from him.
---
 fs/btrfs/disk-io.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c835141ee384..75f3c6c4c249 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4434,13 +4434,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 
 	btrfs_put_block_group_cache(fs_info);
 
-	/*
-	 * we must make sure there is not any read request to
-	 * submit after we stopping all workers.
-	 */
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
-	btrfs_stop_all_workers(fs_info);
-
 	/* We shouldn't have any transaction open at this point */
 	warn_about_uncommitted_trans(fs_info);
 
@@ -4448,6 +4441,13 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	free_root_pointers(fs_info, true);
 	btrfs_free_fs_roots(fs_info);
 
+	/*
+	 * we must make sure there is not any read request to
+	 * submit after we stopping all workers.
+	 */
+	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	btrfs_stop_all_workers(fs_info);
+
 	/*
 	 * We must free the block groups after dropping the fs_roots as we could
 	 * have had an IO error and have left over tree log blocks that aren't
-- 
2.53.0

