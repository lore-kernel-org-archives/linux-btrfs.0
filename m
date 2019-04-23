Return-Path: <SRS0=kwY/=SZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261CCC10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 11:48:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F102D20811
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 11:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfDWLsU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Apr 2019 07:48:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:47354 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727643AbfDWLsT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Apr 2019 07:48:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9C234ACEF
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2019 11:48:18 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Return EBUSY in case btrfs_start_write_no_snapshotting fails
Date:   Tue, 23 Apr 2019 14:48:16 +0300
Message-Id: <20190423114816.8304-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If btrfs_start_write_no_snapshotting fails (returns 0) it means there
is snapshot in progress hence resource is busy and not that we are
out of space. Change the return value to correctly reflect this.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 2030b9bcb977..ce1dec51ff92 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1547,7 +1547,7 @@ static noinline int check_can_nocow(struct btrfs_inode *inode, loff_t pos,
 
 	ret = btrfs_start_write_no_snapshotting(root);
 	if (!ret)
-		return -ENOSPC;
+		return -EBUSY;
 
 	lockstart = round_down(pos, fs_info->sectorsize);
 	lockend = round_up(pos + *write_bytes,
-- 
2.17.1

