Return-Path: <SRS0=/Od+=EE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C090AC55178
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Oct 2020 12:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6469F20796
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Oct 2020 12:03:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ip4hgmUK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgJ2MDH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 08:03:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:32918 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgJ2MDG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Oct 2020 08:03:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603972985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2jX9TjrxdwKzScRzPloaORj52El/0xtri51cBPmpZz4=;
        b=ip4hgmUKqpGfzjBNkIRaTpe3iR7RvcM4MVQER0N239UjGuFg3vqVvY1rLE/qoE+kUFahX+
        3JVBjrkCC9HbC6wzRR0p3RCEOzSnYfZIwVPQ2x9uX4CcXypzH1g+OtwCCptaRWssi+OGBG
        cf9ef9ALxYS5am4qlutT62Tw+OvwdwQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B7B4FAF16;
        Thu, 29 Oct 2020 12:03:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B4C81DA7E9; Thu, 29 Oct 2020 13:01:30 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 5/8] btrfs: use root_item helpers for limit and flags in btrfs_create_tree
Date:   Thu, 29 Oct 2020 13:01:30 +0100
Message-Id: <ad746e2f4c212bb582810bf6e2fb7cf08d610acb.1603972767.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1603972767.git.dsterba@suse.com>
References: <cover.1603972767.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For consistency use the available helpers to set flags and limit.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 42465b8728dd..21f7034945a0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1166,8 +1166,8 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	root->commit_root = btrfs_root_node(root);
 	set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
 
-	root->root_item.flags = 0;
-	root->root_item.byte_limit = 0;
+	btrfs_set_root_flags(&root->root_item, 0);
+	btrfs_set_root_limit(&root->root_item, 0);
 	btrfs_set_root_bytenr(&root->root_item, leaf->start);
 	btrfs_set_root_generation(&root->root_item, trans->transid);
 	btrfs_set_root_level(&root->root_item, 0);
-- 
2.25.0

