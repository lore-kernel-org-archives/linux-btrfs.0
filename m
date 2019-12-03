Return-Path: <SRS0=ifAh=ZZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF431C432C0
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 06:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D21BB2073B
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 06:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfLCGnF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 01:43:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:44680 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726521AbfLCGnE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Dec 2019 01:43:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 111B2ADB5
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Dec 2019 06:43:03 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs: relocation: Work around dead relocation stage loop
Date:   Tue,  3 Dec 2019 14:42:54 +0800
Message-Id: <20191203064254.22683-5-wqu@suse.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203064254.22683-1-wqu@suse.com>
References: <20191203064254.22683-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are some reports of dead relocation stage loop, where dmesg is
flooded by "Found X extents".

The root cause of it is still uncertain, but we can work around such bug
by checking cancelling request so user can at least cancel such dead
loop.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 161d66f70190..23aa630f04c9 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4417,6 +4417,10 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
 
 		btrfs_info(fs_info, "found %llu extents", rc->extents_found);
 
+		if (should_cancel_balance(fs_info)) {
+			err = -ECANCELED;
+			goto out;
+		}
 	}
 
 	WARN_ON(rc->block_group->pinned > 0);
-- 
2.24.0

