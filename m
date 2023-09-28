Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D765CE7AF8
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Sep 2023 04:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjI1EHB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 00:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjI1EG6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2023 00:06:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EED610A
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2023 21:06:57 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C823D1F45B
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2023 04:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1695874015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j/oGRpmkiCQIsu4QYFHcUD5Y4FoVFX4CY3hrHVNHFGs=;
        b=iRSLRXwhxEvjvpmxdA8JIpSvCZXWHac3VpT3WnzrOviva1BiWWKjL3Wt6q9oEXP1yVUIq2
        +D1RBKtkOOMgmELfeLkQ0qy11WkAKfFE36PjgGYs35h+WaCrmprkK+5FGCsioxe3PjV5wE
        hwahiGk/KEfSVp/GdvLB5iuWZVyFpjA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0B3DC1377A
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2023 04:06:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uOWML977FGX1RQAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2023 04:06:54 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: fix a variable shadowing when enabling experimental features
Date:   Thu, 28 Sep 2023 13:36:34 +0930
Message-ID: <415b7f162cc3135d53e28d7cccdf3a08380ae4b9.1695873867.git.wqu@suse.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <cover.1695873867.git.wqu@suse.com>
References: <cover.1695873867.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is another variable shadowing problem which can only be exposed
if experimental features are enabled.

Inside the branch of BTRFS_PRINT_TREE_CSUM_HEADERS, we declare another
local variable @csum, shadowing the @csum of print_header_info(), which
is only declared when experimental features are enabled.

Just rename the @csum to @tree_csum to avoid the problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/print-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
index 8511cb1bfd6c..6625b1b6aa80 100644
--- a/kernel-shared/print-tree.c
+++ b/kernel-shared/print-tree.c
@@ -1271,12 +1271,12 @@ static void print_header_info(struct extent_buffer *eb, unsigned int mode)
 	printf("\n");
 	if (fs_info && (mode & BTRFS_PRINT_TREE_CSUM_HEADERS)) {
 		char *tmp = csum_str;
-		u8 *csum = (u8 *)(eb->data + offsetof(struct btrfs_header, csum));
+		u8 *tree_csum = (u8 *)(eb->data + offsetof(struct btrfs_header, csum));
 
 		strcpy(csum_str, " csum 0x");
 		tmp = csum_str + strlen(csum_str);
 		for (i = 0; i < csum_size; i++) {
-			sprintf(tmp, "%02x", csum[i]);
+			sprintf(tmp, "%02x", tree_csum[i]);
 			tmp++;
 			tmp++;
 		}
-- 
2.42.0

