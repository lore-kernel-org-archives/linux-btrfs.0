Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1370DC19F2D
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Aug 2022 19:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbiHFTuL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Aug 2022 15:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbiHFTuJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Aug 2022 15:50:09 -0400
Received: from smtp.smtpout.orange.fr (smtp08.smtpout.orange.fr [80.12.242.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CBD112A96
        for <linux-btrfs@vger.kernel.org>; Sat,  6 Aug 2022 12:50:08 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id KPgyot1A2sKAkKPgyouG6I; Sat, 06 Aug 2022 21:42:36 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 06 Aug 2022 21:42:36 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: Fix a typo in a comment
Date:   Sat,  6 Aug 2022 21:42:34 +0200
Message-Id: <c81a4f359ff8a1443168b9c308dcd621ba24e5c5.1659814948.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add a missing 'r'.
s/qgoup/qgroup/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index db723c0026bd..6d6eebaed730 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -275,7 +275,7 @@ static int __add_relation_rb(struct btrfs_qgroup *member, struct btrfs_qgroup *p
 }
 
 /*
- * Add relation specified by two qgoup ids.
+ * Add relation specified by two qgroup ids.
  *
  * Must be called with qgroup_lock held.
  *
-- 
2.34.1

