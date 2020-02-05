Return-Path: <SRS0=o+mG=3Z=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B34C3F68F
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Feb 2020 16:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 259D121D7D
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Feb 2020 16:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgBEQMn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 11:12:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:56434 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726973AbgBEQMn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Feb 2020 11:12:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CE673ADAB;
        Wed,  5 Feb 2020 16:12:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4EDF8DA7E6; Wed,  5 Feb 2020 17:12:29 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: log message when rw remount is attempted with unclean tree-log
Date:   Wed,  5 Feb 2020 17:12:28 +0100
Message-Id: <20200205161228.24378-1-dsterba@suse.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

A remount to a read-write filesystem is not safe when there's tree-log
to be replayed. Files that could be opened until now might be affected
by the changes in the tree-log.

A regular mount is needed to replay the log so the filesystem presents
the consistent view with the pending changes included.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 580ba7db67e5..a2554c651548 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1834,6 +1834,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		}
 
 		if (btrfs_super_log_root(fs_info->super_copy) != 0) {
+			btrfs_warn(f_info,
+		"mount required to replay tree-log, cannot remount read-write");
 			ret = -EINVAL;
 			goto restore;
 		}
-- 
2.24.0

