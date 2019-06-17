Return-Path: <SRS0=jqbo=UQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D731C31E44
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Jun 2019 07:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0BF521E6B
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Jun 2019 07:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfFQH7t (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Jun 2019 03:59:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:43826 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725791AbfFQH7s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jun 2019 03:59:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D56DFAE89
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2019 07:59:47 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs-progs: Remove unnecessary fallthrough attribute in test_num_disk_vs_raid()
Date:   Mon, 17 Jun 2019 15:59:35 +0800
Message-Id: <20190617075936.12113-4-wqu@suse.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617075936.12113-1-wqu@suse.com>
References: <20190617075936.12113-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 utils.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/utils.c b/utils.c
index 0b271517551b..2709ced97f97 100644
--- a/utils.c
+++ b/utils.c
@@ -1928,7 +1928,6 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 		__attribute__ ((fallthrough));
 	case 1:
 		allowed |= BTRFS_BLOCK_GROUP_DUP;
-		__attribute__ ((fallthrough));
 	}
 
 	if (dev_cnt > 1 && profile & BTRFS_BLOCK_GROUP_DUP) {
-- 
2.22.0

