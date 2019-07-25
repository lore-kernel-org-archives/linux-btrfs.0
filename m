Return-Path: <SRS0=fwWV=VW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57002C7618B
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 09:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 279E22084D
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 09:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403824AbfGYJeY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Jul 2019 05:34:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:52352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403773AbfGYJeL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jul 2019 05:34:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D6B5AEFF
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2019 09:34:09 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [RFC PATCH 08/17] btrfs-progs: cache csum_type in recover_control
Date:   Thu, 25 Jul 2019 11:33:55 +0200
Message-Id: <9f3f9dd60d4c7dbfc854ad98e6133914bb47f7dc.1564046972.git.jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <cover.1564046812.git.jthumshirn@suse.de>
References: <cover.1564046812.git.jthumshirn@suse.de>
In-Reply-To: <cover.1564046812.git.jthumshirn@suse.de>
References: <cover.1564046812.git.jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Cache the super-block's checksum type field in 'struct recover_control'.
This will be needed for further refactoring the checksum handling.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 cmds/rescue-chunk-recover.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/cmds/rescue-chunk-recover.c b/cmds/rescue-chunk-recover.c
index 608af9d49407..308731ea5ea6 100644
--- a/cmds/rescue-chunk-recover.c
+++ b/cmds/rescue-chunk-recover.c
@@ -47,6 +47,7 @@ struct recover_control {
 	int yes;
 
 	u16 csum_size;
+	u16 csum_type;
 	u32 sectorsize;
 	u32 nodesize;
 	u64 generation;
@@ -1530,6 +1531,7 @@ static int recover_prepare(struct recover_control *rc, const char *path)
 	rc->generation = btrfs_super_generation(sb);
 	rc->chunk_root_generation = btrfs_super_chunk_root_generation(sb);
 	rc->csum_size = btrfs_super_csum_size(sb);
+	rc->csum_type = btrfs_super_csum_type(sb);
 
 	/* if seed, the result of scanning below will be partial */
 	if (btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_SEEDING) {
-- 
2.16.4

