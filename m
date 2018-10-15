Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD643C71132
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 14:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C25E20881
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 14:04:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C25E20881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbeJOVta (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 17:49:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:39432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726641AbeJOVta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 17:49:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BAA63ACF8
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 14:04:03 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     desterba@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Adjust loop in free_extent_buffer
Date:   Mon, 15 Oct 2018 17:04:01 +0300
Message-Id: <1539612241-14619-1-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1534346817-9108-1-git-send-email-nborisov@suse.com>
References: <1534346817-9108-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The loop construct in free_extent_buffer was added in
242e18c7c1a8 ("Btrfs: reduce lock contention on extent buffer locks")
as means of reducing the times the eb lock is taken, the non-last ref
count is decremented and lock is released. As the special handling
of UNMAPPED extent buffers was removed now there is only one decrement
op which is happening for EXTENT_BUFFER_UNMAPPED case. This commit
modifies the loop condition so that in case of UNMAPPED buffers the
eb's lock is taken only if we are 100% sure the eb is going to be freed
by the current executor of the code. Additionally, remove superfluous 
ref count  ops in btrfs test. 

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

This was tested with xfstest multiple times + unloading of btrfs module to 
ensure no eb leaks are present. 


 fs/btrfs/extent_io.c         | 4 +++-
 fs/btrfs/tests/btrfs-tests.c | 2 --
 fs/btrfs/tests/inode-tests.c | 6 ------
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0e9d4f28379d..544a1a5fd416 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5095,7 +5095,9 @@ void free_extent_buffer(struct extent_buffer *eb)
 
 	while (1) {
 		refs = atomic_read(&eb->refs);
-		if (refs <= 3)
+		if ((!test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags) && refs <= 3)
+		    || (test_bit(EXTENT_BUFFER_UNMAPPED, &eb->bflags) &&
+			refs == 1))
 			break;
 		old = atomic_cmpxchg(&eb->refs, refs, refs - 1);
 		if (old == refs)
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 4cb8fcfd3ec4..8a59597f1883 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -177,8 +177,6 @@ void btrfs_free_dummy_root(struct btrfs_root *root)
 	if (root->node) {
 		/* One for allocate_extent_buffer */
 		free_extent_buffer(root->node);
-		/* One for get_exent_buffer */
-		free_extent_buffer(root->node);
 	}
 	kfree(root);
 }
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 64043f028820..af0c8e30d9e2 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -254,11 +254,6 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 		goto out;
 	}
 
-	/*
-	 * We will just free a dummy node if it's ref count is 2 so we need an
-	 * extra ref so our searches don't accidentally release our page.
-	 */
-	extent_buffer_get(root->node);
 	btrfs_set_header_nritems(root->node, 0);
 	btrfs_set_header_level(root->node, 0);
 	ret = -EINVAL;
@@ -860,7 +855,6 @@ static int test_hole_first(u32 sectorsize, u32 nodesize)
 		goto out;
 	}
 
-	extent_buffer_get(root->node);
 	btrfs_set_header_nritems(root->node, 0);
 	btrfs_set_header_level(root->node, 0);
 	BTRFS_I(inode)->root = root;
-- 
2.7.4

