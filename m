Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409F223BD17
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 06:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786428146; cv=none; b=QBb58U9wr51fWNgjnvO8wPUFHLYIdsF1lmPQgo4lG58wAoIlVzaFym2j9MX9Xubh25ANxH6sB6pGEX/ODpQf+yF8+fXFaS6RCxNE5QUqZtQKcrlcS1AwDMX0Npup6Vg+PzgeX/xb/+bqMF1Cl2+h4ZMYAi0l2p7vxNXlrdKKp5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786428146; c=relaxed/simple;
	bh=BI7tGgCWMB+jpyzzGKyvmz6KvUf39P6/CQc2ddOKj18=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=DS0D5yxFentIBh0JfmZw2UgWa75lNAlozxtshZ0AouP579g3AheSuX1UEU7VUPde4gq1VswViS0HsjwRC0vcLS3Ms7ZeofcnT6WWziwmWVwnDrPs9CCRhq5VTUXd8tP9DZxstt+q/YfoW21lPOles6BCKuLJPDo6l1lQWShfBho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sHQIXNXM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iWlQUPGn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sHQIXNXM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iWlQUPGn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 11BF68188F
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 06:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786428138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ce1LRkdfwKw64IT21p0OxQNUD/VvPUv3XCmm6W16L2E=;
	b=sHQIXNXMdaxmyxHJVrmqzIcJ7u8P6yKCCgm+VzveME8OKLiEZFeIQdlqzJPxUnL2IshEU/
	tFGwlN4IoK9+eVO12t0Vmq22TUY/B5mFa9uo9EihgHHMVt38wLp/QUpIGqlxq5yQbtYnHb
	6zGklxZEhtCFMOfJKlblDqcaTgjA7Ro=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786428134; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ce1LRkdfwKw64IT21p0OxQNUD/VvPUv3XCmm6W16L2E=;
	b=iWlQUPGnHPas0wOcMPAGVMUq3UgZ4bq9bPYq/O8VUrpbAiTR2OOpA+87CyEdphVUaLqzKB
	A+h3HMd0QzPyfY3lCeNNcFewRMjaH/PjmwQj8Ki/rh2uuf9ekxf8IXC3vcS548UPxnNhc+
	X8eEBlMSbCpGq1b8iYjdTAYZrg8wwKY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA0F6779B2
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 06:02:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 52MiI+S6emo4NAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 06:02:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tests: do not touch page cache if root/inode allocation failed
Date: Tue, 11 Aug 2026 15:31:49 +0930
Message-ID: <cbfd9452186748c2f0a627a472df3e2948f99cfe.1786428096.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email,sashiko.dev:url];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Inside test_find_delalloc() of extent-io-tests.c, if we failed to
allocate a dummy root or the test inode, we goto out label to clean up.

But at that stage, @inode is still NULL and we will call
process_page_range() to access the page cache of the inode, this will
cause NULL pointer dereference.

This is a very minor bug, as it only affects selftests which are not
compiled in by default for most distros, and very hard to trigger.

Fix it by adding a new out_root_info label to handle root and inode
allocation failure.

This is a pre-existing bug reported by Sashiko while reviewing another
patch.

Link: https://sashiko.dev/#/patchset/cover.1786095309.git.wqu%40suse.com
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tests/extent-io-tests.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index b2aacf846c8b..23459cd4e503 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -133,14 +133,14 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	if (IS_ERR(root)) {
 		test_std_err(TEST_ALLOC_ROOT);
 		ret = PTR_ERR(root);
-		goto out;
+		goto out_root_info;
 	}
 
 	inode = btrfs_new_test_inode();
 	if (!inode) {
 		test_std_err(TEST_ALLOC_INODE);
 		ret = -ENOMEM;
-		goto out;
+		goto out_root_info;
 	}
 	tmp = &BTRFS_I(inode)->io_tree;
 	BTRFS_I(inode)->root = root;
@@ -333,6 +333,7 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 	process_page_range(inode, 0, total_dirty - 1,
 			   PROCESS_UNLOCK | PROCESS_RELEASE);
 	iput(inode);
+out_root_info:
 	btrfs_free_dummy_root(root);
 	btrfs_free_dummy_fs_info(fs_info);
 	return ret;
-- 
2.54.0

