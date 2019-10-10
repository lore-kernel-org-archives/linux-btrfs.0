Return-Path: <SRS0=z0ck=YD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E54F7C47404
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Oct 2019 02:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7E9521848
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Oct 2019 02:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732611AbfJJCjf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 22:39:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:41160 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726621AbfJJCjf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Oct 2019 22:39:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 04251AF87
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Oct 2019 02:39:34 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/3] btrfs: block-group: Fix a memory leak due to missing btrfs_put_block_group()
Date:   Thu, 10 Oct 2019 10:39:26 +0800
Message-Id: <20191010023928.24586-2-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010023928.24586-1-wqu@suse.com>
References: <20191010023928.24586-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In btrfs_read_block_groups(), if we have an invalid block group which
has mixed type (DATA|METADATA) while the fs doesn't have MIX_BGS
feature, we error out without freeing the block group cache.

This patch will add the missing btrfs_put_block_group() to prevent
memory leak.

Fixes: 49303381f19a ("Btrfs: bail out if block group has different mixed flag")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/block-group.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index bf7e3f23bba7..c906a2b6c2cf 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1762,6 +1762,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 "bg %llu is a mixed block group but filesystem hasn't enabled mixed block groups",
 				  cache->key.objectid);
 			ret = -EINVAL;
+			btrfs_put_block_group(cache);
 			goto error;
 		}
 
-- 
2.23.0

