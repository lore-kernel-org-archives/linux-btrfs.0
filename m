Return-Path: <SRS0=zDud=5F=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C06C4332D
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Mar 2020 18:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9905D20739
	for <linux-btrfs@archiver.kernel.org>; Fri, 20 Mar 2020 18:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584729833;
	bh=o1Il20ECuK/Q82pQQNyj6Rj7i5tzUYjz9wGiJck2e4s=;
	h=From:To:Subject:Date:List-ID:From;
	b=JeqZiIkDfC3QzbmOL/Q1eJf8Dz8vIJAnYzP9gl4w7pMFb3DTGsz7fmd20v7BCAZ1y
	 MhWC8ZSQ9y+2S9LTLv7C9NU8s6TWuW8zqDq6tsi9R5xdLd8Vxei0n59yHL2dczeaOo
	 uqV6mcbbXOFTfXUiXZCpYTmXiojQa/emQig/lwJM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgCTSnw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 14:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgCTSnw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Mar 2020 14:43:52 -0400
Received: from debian5.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8A5820739
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2020 18:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584729832;
        bh=o1Il20ECuK/Q82pQQNyj6Rj7i5tzUYjz9wGiJck2e4s=;
        h=From:To:Subject:Date:From;
        b=JNabjMONmyCQFMphan9bVgihYBCg3IbVSJ5H1wV98JYnj9TNskxOsk5zLGICtH3ir
         r3ipNVIMwowApW7ePFfBM9plUSiRcww2CKD98FfZ6AKa4Uom0Sn+C3oYIAQisYzdc6
         hiCWCIwoacFPKwoBLt6/htQZrNFXbTRhvqs1SlIM=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix removal of raid[56|1c34} incompat flags after removing block group
Date:   Fri, 20 Mar 2020 18:43:48 +0000
Message-Id: <20200320184348.845248-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

We are incorrectly dropping the raid56 and raid1c34 incompat flags when
there are still raid56 and raid1c34 block groups, not when we do not any
of those anymore. The logic just got unintentionally broken after adding
the support for the raid1c34 modes.

Fix this by clear the flags only if we do not have block groups with the
respective profiles.

Fixes: 9c907446dce3 ("btrfs: drop incompat bit for raid1c34 after last block group is gone")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 7b003a2df79e..b8f39a679064 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -856,9 +856,9 @@ static void clear_incompat_bg_bits(struct btrfs_fs_info *fs_info, u64 flags)
 				found_raid1c34 = true;
 			up_read(&sinfo->groups_sem);
 		}
-		if (found_raid56)
+		if (!found_raid56)
 			btrfs_clear_fs_incompat(fs_info, RAID56);
-		if (found_raid1c34)
+		if (!found_raid1c34)
 			btrfs_clear_fs_incompat(fs_info, RAID1C34);
 	}
 }
-- 
2.25.0

