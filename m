Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E6CC388F7
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 412A0206D9
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:53:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XEzOhPL3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgKMMxT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 07:53:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:47968 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbgKMMxT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Nov 2020 07:53:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605271998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AJ5FDgM+IJav9Rao+mHDPtw0VBKfmTYwhA7oZlDtzyQ=;
        b=XEzOhPL3xs0+G9oN75LIBrNtaYGmbx4y5Z9GYu0x9Sn7NskVwQpBwxuoOpWOjLnNZ7LeTG
        JXwZHJrqBPTvATQMRWVx1G1ALbfJyAAT73ATstnU26ZznBUXjMVo/nnaKYcv456hI2ikqi
        rQ50wQaYYcF05ycHuizhaILfV/nonkA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 379EAABD1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2020 12:53:18 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 24/24] btrfs: extent_io: Use detach_page_private() for alloc_extent_buffer()
Date:   Fri, 13 Nov 2020 20:51:49 +0800
Message-Id: <20201113125149.140836-25-wqu@suse.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201113125149.140836-1-wqu@suse.com>
References: <20201113125149.140836-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In alloc_extent_buffer(), after we got a page from btree inode, we check
if that page has private pointer attached.

If attached, we check if the existing extent buffer has a proper refs.
If not (the eb is being freed), we will detach that private eb pointer.

The point here is, we are detaching that eb pointer by calling:
- ClearPagePrivate()
- put_page()

The put_page() here is especially confusing, as it's decreaing the ref
caused by attach_page_private().
Without knowing that, it looks like the put_page() is for the
find_or_create_page() call, confusing the read.

Since we're always modifing page private with attach_page_private() and
detach_page_private(), the only open-coded detach_page_private() here is
really confusing.

Fix it by calling detach_page_private().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f305777ee1a3..55115f485d09 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5310,14 +5310,13 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 				goto free_eb;
 			}
 			exists = NULL;
+			WARN_ON(PageDirty(p));
 
 			/*
 			 * Do this so attach doesn't complain and we need to
 			 * drop the ref the old guy had.
 			 */
-			ClearPagePrivate(p);
-			WARN_ON(PageDirty(p));
-			put_page(p);
+			detach_page_private(page);
 		}
 		attach_extent_buffer_page(eb, p);
 		spin_unlock(&mapping->private_lock);
-- 
2.29.2

