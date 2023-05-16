Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C83C77B7F
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 May 2023 11:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjEPL3R (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 May 2023 07:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjEPL3Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2023 07:29:16 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AC110CE
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2023 04:29:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3D26221BEF
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2023 11:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1684236553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9JCkt3FaD7YoNPjCwGodHfldiv+ApL/5fbdsLfJj19Y=;
        b=U4A85t5a9xcK78xNaihsOqzChB7tIt4H3cafKQRWDqa5TwLSq6vUOjnDkYvyNwRZN08ttQ
        GWoqzK+TBh6uBMdgau1fXouUZveVnhJ2gECrI0usX7ZlBnYOtelAeFlOy+QRz2G0gH4czc
        9hydkeJM80r4H+AmWwRNM1Qra7jjuYI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 86EEE138F5
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2023 11:29:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qDxREwhpY2RJCwAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2023 11:29:12 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: dump-tree: skip tree-checker when dumpping tree blocks
Date:   Tue, 16 May 2023 19:28:54 +0800
Message-Id: <a6b4198481004f1ddcdbac00f8559c787646557e.1684236530.git.wqu@suse.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since commit c8593f65cbf3 ("btrfs-progs: sync tree-checker.[ch] from
kernel"), btrfs-progs can do the kernel level tree block checks, which
is not really sutiable for dump-tree.

Under a lot of cases, we're using dump-tree tool to debug to collect the
details from end users.
If it's a bitflip causing a rejection, we would be unable to determine
the cause.

So this patch would add OPEN_CTREE_SKIP_LEAF_ITEM_CHECKS for dump-tree.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/inspect-dump-tree.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/cmds/inspect-dump-tree.c b/cmds/inspect-dump-tree.c
index 7c524b04d6f7..bfc0fff148dd 100644
--- a/cmds/inspect-dump-tree.c
+++ b/cmds/inspect-dump-tree.c
@@ -342,8 +342,12 @@ static int cmd_inspect_dump_tree(const struct cmd_struct *cmd,
 	 * Use NO_BLOCK_GROUPS here could also speedup open_ctree() and allow us
 	 * to inspect fs with corrupted extent tree blocks, and show as many good
 	 * tree blocks as possible.
+	 *
+	 * And we want to avoid tree-checker, which can rejects the target tree
+	 * block completely, while we may be debugging the problem.
 	 */
-	open_ctree_flags = OPEN_CTREE_PARTIAL | OPEN_CTREE_NO_BLOCK_GROUPS;
+	open_ctree_flags = OPEN_CTREE_PARTIAL | OPEN_CTREE_NO_BLOCK_GROUPS |
+			   OPEN_CTREE_SKIP_LEAF_ITEM_CHECKS;
 	cache_tree_init(&block_root);
 	optind = 0;
 	while (1) {
-- 
2.40.1

