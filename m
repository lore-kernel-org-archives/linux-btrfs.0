Return-Path: <SRS0=mU8m=PA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1E5C43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 09:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 074E2218FD
	for <linux-btrfs@archiver.kernel.org>; Sun, 23 Dec 2018 09:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbeLWJeD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 23 Dec 2018 04:34:03 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44319
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727313AbeLWJeC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Dec 2018 04:34:02 -0500
X-IronPort-AV: E=Sophos;i="5.56,386,1539640800"; 
   d="scan'208";a="289991776"
Received: from palace.lip6.fr ([132.227.105.202])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/AES128-SHA256; 23 Dec 2018 10:33:54 +0100
From:   Julia Lawall <Julia.Lawall@lip6.fr>
To:     Chris Mason <clm@fb.com>
Cc:     kernel-janitors@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/20] Btrfs: drop useless LIST_HEAD
Date:   Sun, 23 Dec 2018 09:57:06 +0100
Message-Id: <1545555435-24576-12-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Drop LIST_HEAD where the variable it declares is never used.

The uses were removed in 3fd0a5585eb9 ("Btrfs: Metadata ENOSPC
handling for balance"), but not the declaration.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
@@
- LIST_HEAD(x);
  ... when != x
// </smpl>

Fixes: 3fd0a5585eb9 ("Btrfs: Metadata ENOSPC handling for balance")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Successfully 0-day tested on 151 configurations.

 fs/btrfs/relocation.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 272b287f8cf0..de802ba35a34 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2128,7 +2128,6 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 					       struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
-	LIST_HEAD(inode_list);
 	struct btrfs_key key;
 	struct btrfs_key next_key;
 	struct btrfs_trans_handle *trans = NULL;

