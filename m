Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A03CC43332
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Jan 2021 16:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BB7222B3B
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Jan 2021 16:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390229AbhAZIhQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 03:37:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:54956 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729409AbhAZIgM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jan 2021 03:36:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611650077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RwmTXdlxYy4Mp9tw9NVf4mZQW+bcQd25JUReFusnWZQ=;
        b=BCrGXspdQyWJ7X1BHiYIt3aVzJI3BrQPYh6FVu3zGpgLr3lxjJePQ8TZjZIAbUJY5qPpkH
        9UAPL2898vESqeVp6JFy5TcZPHi7hWxg+OueEuKI0BLRiitN8oYUZeZtfcqxuiT1LepqZ/
        mlk+feEm08pCKFpoKKz3QajPWZskcmE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4C966AF4C;
        Tue, 26 Jan 2021 08:34:37 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH v5 07/18] btrfs: attach private to dummy extent buffer pages
Date:   Tue, 26 Jan 2021 16:33:51 +0800
Message-Id: <20210126083402.142577-8-wqu@suse.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210126083402.142577-1-wqu@suse.com>
References: <20210126083402.142577-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are locations where we allocate dummy extent buffers for temporary
usage, like in tree_mod_log_rewind() or get_old_root().

These dummy extent buffers will be handled by the same eb accessors, and
if they don't have page::private subpage eb accessors could fail.

To address such problems, make __alloc_dummy_extent_buffer() attach
page private for dummy extent buffers too.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 118874926179..7ee28d94bae9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5183,9 +5183,14 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 
 	num_pages = num_extent_pages(eb);
 	for (i = 0; i < num_pages; i++) {
+		int ret;
+
 		eb->pages[i] = alloc_page(GFP_NOFS);
 		if (!eb->pages[i])
 			goto err;
+		ret = attach_extent_buffer_page(eb, eb->pages[i], NULL);
+		if (ret < 0)
+			goto err;
 	}
 	set_extent_buffer_uptodate(eb);
 	btrfs_set_header_nritems(eb, 0);
@@ -5193,8 +5198,10 @@ struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 
 	return eb;
 err:
-	for (; i > 0; i--)
+	for (; i > 0; i--) {
+		detach_extent_buffer_page(eb, eb->pages[i - 1]);
 		__free_page(eb->pages[i - 1]);
+	}
 	__free_extent_buffer(eb);
 	return NULL;
 }
-- 
2.30.0

