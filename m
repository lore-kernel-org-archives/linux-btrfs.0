Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F3D30F80C
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 05:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786943667; cv=none; b=neA9aMjrHajiRPMhi4WcE0lfYm/hjsgmv/Gy/vMsFK83icj0aCMXcXhEI8FVdCPNXObbKCXRgrwasxr/9Z3TAh/GNskp9cXBJv+Zq9VqtNY5TDNHIuPIchDNXVu6/UuI8sjElyst2Qzfer7Q555Q3iADjqCcjseLU9JDbM8GSvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786943667; c=relaxed/simple;
	bh=IYqYWaUoCBSFU+hL64jqVOrv2JHmImELX0TmHcU4hso=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvH1zk0PutQnME5Cdh6WaVlmIF4dJlIUO/BlfASZxC7R7sH9JquQCqyspXMf4CPM5jp8Hy82gDR8ENXNhl2qreD+HhCxyZhzKy4TdVrI9T55+vwQwauYNJcLe55MZRwIhEWKlXA+4wxMrzWNZ4bWR3jBFNkK7/vd9jZxdnOiIP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=E6KK8k8l; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=joyJO/+i; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="E6KK8k8l";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="joyJO/+i"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 029293E0F
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 05:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786943660; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2EYbUeHBf7tBR6dJmPLrLiX9Iw04ez9lsg7ZJKuze8k=;
	b=E6KK8k8lcce/hj44q/l52kmhfjqQBl/ZvG2pRCidmnL8zKSTCzK9oj1gWLhY3fKDijkDIK
	DmRaGTjhpbflndrZr1rJu3dMIpRu8cYugONxdgyUhQIqUWIDqSq3S6SgrJGSr+cScoNi7H
	3dSco0WsDT0foattDB3wJdSnMXHrDXc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="joyJO/+i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786943656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2EYbUeHBf7tBR6dJmPLrLiX9Iw04ez9lsg7ZJKuze8k=;
	b=joyJO/+iU+0dlYsBviDlvbNMfAWiTThd7DCYAJ58ndID48y+pW0f6odvV4sQDo7WumqNFh
	n8R9XC5hiIZATG/eg2XXz2ntKGhKPuRoRRwVzh1QKDCv2PP8mTYwu63uK5hH4XxrHry2q8
	DQ0siQ9nRVEkxbGzPKzHQpCOwyFNmjs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC27E792C3
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 05:14:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CMZ6IKaYgmoDSgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 05:14:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix the possible bioc_list memory leak during error
Date: Mon, 17 Aug 2026 14:43:53 +0930
Message-ID: <ed763ed884102ef12aa18bd9e2669a6e8d9f92d9.1786943382.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1786943382.git.wqu@suse.com>
References: <cover.1786943382.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,sashiko.dev:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 029293E0F
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

There are two possible ways to leak bioc memory on
btrfs_ordered_extent::bioc_list:

- An error occurred for btrfs_insert_one_raid_extent()
  Then the function btrfs_insert_raid_extent() immediately return
  without freeing any bioc in the bioc_list.

- An ordered extent hit an IO error
  In that case the ordered extent will have BTRFS_ORDERED_IOERR set, and
  skip the call on btrfs_insert_raid_extent() completely.

Fix the problem by:

- Introduce a new helper, btrfs_cleanup_ordered_bioc_list()
  Which will remove all bioc from the bioc_list, and release the bioc.

- Call the above helper for btrfs_insert_raid_extent()
  So that the cleanup helper is always called no matter what.

- Call the above helper for btrfs_finish_one_ordered()
  This is called just before the final release on the ordered extent.

This is reported by Sashiko when reviewing another patch.

Link: https://sashiko.dev/#/patchset/20260817021512.3010812-1-shuangpeng.kernel%40gmail.com
Fixes: 02c372e1f016 ("btrfs: add support for inserting raid stripe extents")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c            |  3 +++
 fs/btrfs/raid-stripe-tree.c | 18 ++++++++++++------
 fs/btrfs/raid-stripe-tree.h |  1 +
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8a9b52848fbc..b896358678ab 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3436,6 +3436,9 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	 */
 	btrfs_remove_ordered_extent(ordered_extent);
 
+	/* Cleanup any remaining biocs attached to the OE. */
+	btrfs_cleanup_ordered_bioc_list(ordered_extent);
+
 	/* once for us */
 	btrfs_put_ordered_extent(ordered_extent);
 	/* once for the tree */
diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 89e259a47d8d..6291775dbe0e 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -373,7 +373,7 @@ int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_ordered_extent *ordered_extent)
 {
 	struct btrfs_io_context *bioc;
-	int ret;
+	int ret = 0;
 
 	if (!btrfs_fs_incompat(trans->fs_info, RAID_STRIPE_TREE))
 		return 0;
@@ -381,17 +381,23 @@ int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 	list_for_each_entry(bioc, &ordered_extent->bioc_list, rst_ordered_entry) {
 		ret = btrfs_insert_one_raid_extent(trans, bioc);
 		if (ret)
-			return ret;
+			break;
 	}
 
-	while (!list_empty(&ordered_extent->bioc_list)) {
-		bioc = list_first_entry(&ordered_extent->bioc_list,
+	btrfs_cleanup_ordered_bioc_list(ordered_extent);
+	return ret;
+}
+
+void btrfs_cleanup_ordered_bioc_list(struct btrfs_ordered_extent *ordered)
+{
+	while (!list_empty(&ordered->bioc_list)) {
+		struct btrfs_io_context *bioc;
+
+		bioc = list_first_entry(&ordered->bioc_list,
 					typeof(*bioc), rst_ordered_entry);
 		list_del(&bioc->rst_ordered_entry);
 		btrfs_put_bioc(bioc);
 	}
-
-	return 0;
 }
 
 int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/raid-stripe-tree.h b/fs/btrfs/raid-stripe-tree.h
index 69942ad43140..eb02cf48511b 100644
--- a/fs/btrfs/raid-stripe-tree.h
+++ b/fs/btrfs/raid-stripe-tree.h
@@ -28,6 +28,7 @@ int btrfs_get_raid_extent_offset(struct btrfs_fs_info *fs_info,
 				 u32 stripe_index, struct btrfs_io_stripe *stripe);
 int btrfs_insert_raid_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_ordered_extent *ordered_extent);
+void btrfs_cleanup_ordered_bioc_list(struct btrfs_ordered_extent *ordered);
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
-- 
2.54.0

