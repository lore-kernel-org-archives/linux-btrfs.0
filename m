Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2955ECAAD8
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Sep 2022 12:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbiIWMGi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 08:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiIWMES (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2022 08:04:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5528572B45
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2022 05:00:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0D339219FB
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2022 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663934406; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=no4HX1Cau5Jr7627H2ksfzfHlZVVF0FIXBd0DcjnJSk=;
        b=UB1RZL5reWr3QG8XdHdR9cmLTQUD0tiEy1vl/Xwnb1yue/3mYDewnDDDD05N2LECuSSAsl
        Y+ZhkG7UZJAvNI1msMl5bazt9L2ZG54p/Iz+hRzzYWO3H7+tGpWOqprJuqt8iCvXO0rBk1
        pYiXgPLCkcQN9Rx30Rpe9tcJL27TK14=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5326113A00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2022 12:00:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wImlBsWfLWMqaAAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2022 12:00:05 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: remove unused function extent_io_tree_init_cache_max()
Date:   Fri, 23 Sep 2022 19:59:44 +0800
Message-Id: <e2a81fbfc234d3967f4505ff7e4f57cb5b3cfc6a.1663934243.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1663934243.git.wqu@suse.com>
References: <cover.1663934243.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The function is introduced by commit a5ce5d219822 ("btrfs-progs:
extent-cache: actually cache extent buffers") but never got utilized.

Thus we can just remove it.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/extent_io.c | 7 -------
 kernel-shared/extent_io.h | 2 --
 2 files changed, 9 deletions(-)

diff --git a/kernel-shared/extent_io.c b/kernel-shared/extent_io.c
index 48bcf2cf2f96..a34616c9e783 100644
--- a/kernel-shared/extent_io.c
+++ b/kernel-shared/extent_io.c
@@ -43,13 +43,6 @@ void extent_io_tree_init(struct extent_io_tree *tree)
 	tree->max_cache_size = (u64)total_memory() / 4;
 }
 
-void extent_io_tree_init_cache_max(struct extent_io_tree *tree,
-				   u64 max_cache_size)
-{
-	extent_io_tree_init(tree);
-	tree->max_cache_size = max_cache_size;
-}
-
 static struct extent_state *alloc_extent_state(void)
 {
 	struct extent_state *state;
diff --git a/kernel-shared/extent_io.h b/kernel-shared/extent_io.h
index 2148a8112428..ccdf768c1e5d 100644
--- a/kernel-shared/extent_io.h
+++ b/kernel-shared/extent_io.h
@@ -97,8 +97,6 @@ static inline void extent_buffer_get(struct extent_buffer *eb)
 }
 
 void extent_io_tree_init(struct extent_io_tree *tree);
-void extent_io_tree_init_cache_max(struct extent_io_tree *tree,
-				   u64 max_cache_size);
 void extent_io_tree_cleanup(struct extent_io_tree *tree);
 int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end, int bits);
 int clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end, int bits);
-- 
2.37.3

