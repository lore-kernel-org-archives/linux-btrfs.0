Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1938BC432BE
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Jul 2021 21:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 019C960BD3
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Jul 2021 21:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhG0VT2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:19:28 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48686 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbhG0VRx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jul 2021 17:17:53 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8220E22274;
        Tue, 27 Jul 2021 21:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627420672; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zp9QHZTHlySlM4NbUf634gCV7sA9Fjtxj5yGsb/PmnE=;
        b=q9q4SjoYFedaTBkEcwGfrR50c5xTIuBbquyFfkw1UG3oyiWxSt7pM81oKYQFgthw7/j2jN
        pmPzbHCRnIXfguTWJJEEQ7oEoGZJ4r0ep2JsB4SFc92M7BeKphkrzTsrmzSPAUmhExRtOP
        IUGtl763x2u/UPrT1Anh2G7VkJcW0tA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627420672;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zp9QHZTHlySlM4NbUf634gCV7sA9Fjtxj5yGsb/PmnE=;
        b=JS4cB70fkdyC5e4TE/OcqUK9MFa4DNeP0CUX3pY60Xu7aLdRRPHrhp9JpxSWwKp0+j1vk4
        YK5C6wxugcw6/BDg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id E3EE7133DE;
        Tue, 27 Jul 2021 21:17:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id GmphLf93AGF3dQAAGKfGzw
        (envelope-from <rgoldwyn@suse.de>); Tue, 27 Jul 2021 21:17:51 +0000
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 2/7] btrfs: Allocate file_ra_state on stack
Date:   Tue, 27 Jul 2021 16:17:26 -0500
Message-Id: <2bb91af815d028ed3231910fcc5d8c6779ebf79c.1627418762.git.rgoldwyn@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627418762.git.rgoldwyn@suse.com>
References: <cover.1627418762.git.rgoldwyn@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Instead of allocating file_ra_state using kmalloc, allocate on stack.
sizeof(struct readahead) = 32 bytes

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/free-space-cache.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2131ae5b9ed7..8eeb65278ac0 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -344,19 +344,13 @@ int btrfs_truncate_free_space_cache(struct btrfs_trans_handle *trans,
 
 static void readahead_cache(struct inode *inode)
 {
-	struct file_ra_state *ra;
+	struct file_ra_state ra;
 	unsigned long last_index;
 
-	ra = kzalloc(sizeof(*ra), GFP_NOFS);
-	if (!ra)
-		return;
-
-	file_ra_state_init(ra, inode->i_mapping);
+	file_ra_state_init(&ra, inode->i_mapping);
 	last_index = (i_size_read(inode) - 1) >> PAGE_SHIFT;
 
-	page_cache_sync_readahead(inode->i_mapping, ra, NULL, 0, last_index);
-
-	kfree(ra);
+	page_cache_sync_readahead(inode->i_mapping, &ra, NULL, 0, last_index);
 }
 
 static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
-- 
2.32.0

