Return-Path: <SRS0=4n2k=37=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63EE4C35242
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Feb 2020 05:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48BDD2072C
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Feb 2020 05:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgBKFhu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 00:37:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:49924 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbgBKFhu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Feb 2020 00:37:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ACE50AB92
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2020 05:37:48 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/4] btrfs: relocation: Work around dead relocation stage loop
Date:   Tue, 11 Feb 2020 13:37:29 +0800
Message-Id: <20200211053729.20807-5-wqu@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200211053729.20807-1-wqu@suse.com>
References: <20200211053729.20807-1-wqu@suse.com>
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
 fs/btrfs/relocation.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 3379850d7695..b31d582a2ca1 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4470,6 +4470,11 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
 
 		btrfs_info(fs_info, "found %llu extents, stage: %s",
 			   rc->extents_found, stage_to_string(finishes_stage));
+
+		if (should_cancel_balance(fs_info)) {
+			err = -ECANCELED;
+			goto out;
+		}
 	}
 
 	WARN_ON(rc->block_group->pinned > 0);
-- 
2.25.0

