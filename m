Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3701C6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1CDA205F4
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 11:43:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1CDA205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbeJZUUM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:20:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:33558 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727583AbeJZUUL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 16:20:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B4641ABDC
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2018 11:43:24 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/5] btrfs: Replace BUG_ON with ASSERT in find_lock_delalloc_range
Date:   Fri, 26 Oct 2018 14:43:21 +0300
Message-Id: <1540554201-11305-6-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1540554201-11305-1-git-send-email-nborisov@suse.com>
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

lock_delalloc_pages should only return 2 values - 0 in case of success
and -EAGAIN if the range of pages to be locked should be shrunk due to
some of gone. Manual inspections confirms that this is
indeed the case since __process_pages_contig is where lock_delalloc_pages
gets its return value. The latter always returns 0  or -EAGAIN so the
invariant holds. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1a9a521aefe5..94bc53472031 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1606,6 +1606,7 @@ static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
 	/* step two, lock all the pages after the page that has start */
 	ret = lock_delalloc_pages(inode, locked_page,
 				  delalloc_start, delalloc_end);
+	ASSERT(!ret || ret == -EAGAIN);
 	if (ret == -EAGAIN) {
 		/* some of the pages are gone, lets avoid looping by
 		 * shortening the size of the delalloc range we're searching
@@ -1621,7 +1622,6 @@ static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
 			goto out_failed;
 		}
 	}
-	BUG_ON(ret); /* Only valid values are 0 and -EAGAIN */
 
 	/* step three, lock the state bits for the whole range */
 	lock_extent_bits(tree, delalloc_start, delalloc_end, &cached_state);
-- 
2.7.4

