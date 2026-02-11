Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38811A58D
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2026 22:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770850182; cv=none; b=ObBBbgnbNwCNsnZPs6gIByjKmnu8sA6ano5Y1gkXmIXZKI+tJlDnbTq5OPSw9yGtqe3p5F80edmMhHUVbgrtU/hwskaecTk87NqE5K8Ngmv7Y/p0VrVVXlKKN18b/N3zw3Tmx3B6nv00u0kVcL+cD9FoldgkVzvSuPwD/qbvojU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770850182; c=relaxed/simple;
	bh=Ji74EMptI56rvsti8R7QVvsAtapWm7BM5/i3K5xNB40=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=IBDfmGe/YIvdIBbGz0myp8j5gEyI9AZifyOhkLyDXM7qgMQX96J2fxd95B6mEVg43tNv26oP/iOWr8e+lAA+XcN9/TU6+QgwVgzWJoVNmN4EOZUNqASht111SO0khTZXRO0VpbbJXvbgs+6IdOo56pfiMpDUxKbTOg3KGduv0cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=B0j1j0op; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=B0j1j0op; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="B0j1j0op";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="B0j1j0op"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 15F9F5BCC9
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2026 22:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770850179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/QvldpNql96Z6ADBaFbCVP0EXWhcr9s77fNW3OgZcns=;
	b=B0j1j0opxKC/9wI1/hIAWua84PyI22N8OhtiRGS9q8zkpchc1wW5y+p16MP2Fg6a3Y05z9
	RfEDIMdMoJ9dZd4fEA8SPSFR28CLmI7y05f/C4mBg1vXxp4nViQ7uhODSjH/+dpf8pro3N
	kWCwnKA1a21ifpQR5Yqwa7qFC1bcApg=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=B0j1j0op
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770850179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/QvldpNql96Z6ADBaFbCVP0EXWhcr9s77fNW3OgZcns=;
	b=B0j1j0opxKC/9wI1/hIAWua84PyI22N8OhtiRGS9q8zkpchc1wW5y+p16MP2Fg6a3Y05z9
	RfEDIMdMoJ9dZd4fEA8SPSFR28CLmI7y05f/C4mBg1vXxp4nViQ7uhODSjH/+dpf8pro3N
	kWCwnKA1a21ifpQR5Yqwa7qFC1bcApg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D9313EA62
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2026 22:49:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7tWGK4EHjWmgTQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2026 22:49:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove the btrfs_inode parameter from btrfs_remove_ordered_extent()
Date: Thu, 12 Feb 2026 09:19:19 +1030
Message-ID: <1a8b542d5058110fdb0f42c1aad03f05c6439d39.1770850152.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 15F9F5BCC9
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

We already have btrfs_ordered_extent::inode, thus there is no need to
pass a btrfs_inode parameter to btrfs_remove_ordered_extent().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c        | 4 ++--
 fs/btrfs/ordered-data.c | 4 ++--
 fs/btrfs/ordered-data.h | 3 +--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 81600abc0297..3af087c81724 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3416,7 +3416,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	 * This needs to be done to make sure anybody waiting knows we are done
 	 * updating everything for this ordered extent.
 	 */
-	btrfs_remove_ordered_extent(inode, ordered_extent);
+	btrfs_remove_ordered_extent(ordered_extent);
 
 	/* once for us */
 	btrfs_put_ordered_extent(ordered_extent);
@@ -8141,7 +8141,7 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
 			if (!freespace_inode)
 				btrfs_lockdep_acquire(root->fs_info, btrfs_ordered_extent);
 
-			btrfs_remove_ordered_extent(inode, ordered);
+			btrfs_remove_ordered_extent(ordered);
 			btrfs_put_ordered_extent(ordered);
 			btrfs_put_ordered_extent(ordered);
 		}
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a17f18673bed..e47c3a3a619a 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -638,9 +638,9 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
  * remove an ordered extent from the tree.  No references are dropped
  * and waiters are woken up.
  */
-void btrfs_remove_ordered_extent(struct btrfs_inode *btrfs_inode,
-				 struct btrfs_ordered_extent *entry)
+void btrfs_remove_ordered_extent(struct btrfs_ordered_extent *entry)
 {
+	struct btrfs_inode *btrfs_inode = entry->inode;
 	struct btrfs_root *root = btrfs_inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct rb_node *node;
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index e178d4a489af..86e69de9e9ff 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -161,8 +161,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent);
 int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
 
 void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry);
-void btrfs_remove_ordered_extent(struct btrfs_inode *btrfs_inode,
-				struct btrfs_ordered_extent *entry);
+void btrfs_remove_ordered_extent(struct btrfs_ordered_extent *entry);
 void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
 				 struct folio *folio, u64 file_offset, u64 len,
 				 bool uptodate);
-- 
2.52.0

