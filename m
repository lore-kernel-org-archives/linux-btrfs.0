Return-Path: <SRS0=HdJy=TO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D380C04AB6
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 May 2019 13:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7866B20881
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 May 2019 13:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfENNZi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 14 May 2019 09:25:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:48142 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725980AbfENNZh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 May 2019 09:25:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2C3BADD2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2019 13:25:36 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3 3/3] btrfs-progs: completion: wire-up dump-csum
Date:   Tue, 14 May 2019 15:25:32 +0200
Message-Id: <20190514132532.16934-4-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190514132532.16934-1-jthumshirn@suse.de>
References: <20190514132532.16934-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add the new 'dump-csum' command to inspect-internal.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 btrfs-completion | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-completion b/btrfs-completion
index 6ae57d1b752b..a381036886f0 100644
--- a/btrfs-completion
+++ b/btrfs-completion
@@ -29,7 +29,7 @@ _btrfs()
 	commands_device='scan add delete remove ready stats usage'
 	commands_scrub='start cancel resume status'
 	commands_rescue='chunk-recover super-recover zero-log'
-	commands_inspect_internal='inode-resolve logical-resolve subvolid-resolve rootid min-dev-size dump-tree dump-super tree-stats'
+	commands_inspect_internal='inode-resolve logical-resolve subvolid-resolve rootid min-dev-size dump-tree dump-super tree-stats dump-csum'
 	commands_property='get set list'
 	commands_quota='enable disable rescan'
 	commands_qgroup='assign remove create destroy show limit'
@@ -128,7 +128,7 @@ _btrfs()
 						_btrfs_mnts
 						return 0
 						;;
-					dump-tree|dump-super|rootid|inode-resolve)
+					dump-tree|dump-super|rootid|inode-resolve|dump-csum)
 						_filedir
 						return 0
 						;;
-- 
2.16.4

