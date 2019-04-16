Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8602C10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E4FC2073F
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfDPHPd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 03:15:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:46204 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725865AbfDPHPd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 03:15:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EB403ACD0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 07:15:31 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: Remove the dead branch in btrfs_run_delayed_refs()
Date:   Tue, 16 Apr 2019 15:15:24 +0800
Message-Id: <20190416071526.3576-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190416071526.3576-1-wqu@suse.com>
References: <20190416071526.3576-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

cleanup_ref_head() will only return 0 or 1, no way to return minutes
value.

So remove the dead branch.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 extent-tree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 8c9cdeff3b02..b7ece0ccc237 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -4235,8 +4235,6 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans, unsigned long nr)
 				/* We dropped our lock, we need to loop. */
 				ret = 0;
 				continue;
-			} else if (ret) {
-				return ret;
 			}
 			locked_ref = NULL;
 			continue;
-- 
2.21.0

