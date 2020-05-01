Return-Path: <SRS0=UUkT=6P=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E517C4724C
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 May 2020 06:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79314208C3
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 May 2020 06:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgEAGb6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 May 2020 02:31:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:40082 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728307AbgEAGb5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 May 2020 02:31:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 002E0AE09
        for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2020 06:31:55 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: Remove the unused btrfs_block_group_cache::cache
Date:   Fri,  1 May 2020 14:31:37 +0800
Message-Id: <20200501063138.474044-3-wqu@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501063138.474044-1-wqu@suse.com>
References: <20200501063138.474044-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is no user of that member.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index 308062cfdb24..ea8714ce049c 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1105,7 +1105,6 @@ struct btrfs_space_info {
 };
 
 struct btrfs_block_group_cache {
-	struct cache_extent cache;
 	struct btrfs_space_info *space_info;
 	struct btrfs_free_space_ctl *free_space_ctl;
 	u64 start;
-- 
2.26.2

