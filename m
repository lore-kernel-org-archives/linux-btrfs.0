Return-Path: <SRS0=NsLk=QI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D5CC282D8
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Feb 2019 13:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5133020869
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Feb 2019 13:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfBANUZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Feb 2019 08:20:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:38686 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726460AbfBANUZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Feb 2019 08:20:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 781BDACA9
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Feb 2019 13:20:23 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     dsterba@suse.cz
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs-progs: Use a single tab for 'leafsize (deprecated)' row
Date:   Fri,  1 Feb 2019 15:20:21 +0200
Message-Id: <20190201132021.14794-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since this row is longer than the rest it's enough to use a single tab
character to delimig the value from caption. Without this patch
output looked like:

nodesize		16384
leafsize (deprecated)		16384

With it:

nodesize		16384
leafsize (deprecated)	16384

No functional changes just making the output a bit neater.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 cmds-inspect-dump-super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 97e9624db8d7..7815c863f2ed 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -410,7 +410,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	       (unsigned long long)btrfs_super_sectorsize(sb));
 	printf("nodesize\t\t%llu\n",
 	       (unsigned long long)btrfs_super_nodesize(sb));
-	printf("leafsize (deprecated)\t\t%u\n",
+	printf("leafsize (deprecated)\t%u\n",
 	       le32_to_cpu(sb->__unused_leafsize));
 	printf("stripesize\t\t%llu\n",
 	       (unsigned long long)btrfs_super_stripesize(sb));
-- 
2.17.1

