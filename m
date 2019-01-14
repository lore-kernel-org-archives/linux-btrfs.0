Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA21C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE7C5206B7
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 13:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547472700;
	bh=1IgkYnH4NoPBt1CFSxWMIPgb+d8cbnUnbUnanGk77hY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=2E5AldRbFdsFaMhy33jxG2Ir/aeUAdPqWQzZrYVOJ3GAK7JM0SASFk70NHjV04jSa
	 MvyquR8zEnW28BdHm3uX6QFjAJYrB5QF2oFv6ujayO6u8CmengIsQUo8sG8A2g9s9s
	 1iVAFkmHrwbABvLQScj7zjHSC1fB1/G2hcc74hj0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfANNbj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:31:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbfANNbj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 08:31:39 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EEBE20651;
        Mon, 14 Jan 2019 13:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547472699;
        bh=1IgkYnH4NoPBt1CFSxWMIPgb+d8cbnUnbUnanGk77hY=;
        h=From:To:Cc:Subject:Date:From;
        b=KaZqizlyegcdvuXuytcjStthytD6QPNFDp2RFSj7y73YhrzgAxn+HSei2ccpznzwI
         iG73fxxnWcp273v7lt0Bq37p62CE+rVHH40rco0QoiIOJvpa6zszlPQDy9AlQZBLe4
         30sEtYRgY4sy4o96z43AGh+0ANnWlVVcsKCG1wGY=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     ddis@suse.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/3] Btrfs-progs: add missing error handling in find_mount_root()
Date:   Mon, 14 Jan 2019 13:31:34 +0000
Message-Id: <20190114133134.18374-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The strdup() function can fail, in which case it returns NULL and sets
errno [1]. Therefore add the missing error check after calling strdup()
at find_mount_root().

[1] - http://man7.org/linux/man-pages/man3/strdup.3p.html

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 utils.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 6616630b..3bc6bc3b 100644
--- a/utils.c
+++ b/utils.c
@@ -2048,7 +2048,7 @@ int find_mount_root(const char *path, char **mount_root)
 	int fd;
 	struct mntent *ent;
 	int len;
-	int ret;
+	int ret = 0;
 	int not_btrfs = 1;
 	int longest_matchlen = 0;
 	char *longest_match = NULL;
@@ -2071,12 +2071,18 @@ int find_mount_root(const char *path, char **mount_root)
 				free(longest_match);
 				longest_matchlen = len;
 				longest_match = strdup(ent->mnt_dir);
+				if (!longest_match) {
+					ret = -errno;
+					break;
+				}
 				not_btrfs = strcmp(ent->mnt_type, "btrfs");
 			}
 		}
 	}
 	endmntent(mnttab);
 
+	if (ret)
+		return ret;
 	if (!longest_match)
 		return -ENOENT;
 	if (not_btrfs) {
-- 
2.11.0

