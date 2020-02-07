Return-Path: <SRS0=EUcM=33=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17F3C35242
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 15:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2AFA246D8
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 15:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgBGPUM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Feb 2020 10:20:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:34818 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgBGPUL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Feb 2020 10:20:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3EC8DAC5C;
        Fri,  7 Feb 2020 15:20:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CFBF3DA790; Fri,  7 Feb 2020 16:19:56 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, anand.jain@oracle.com,
        stable@vger.kernel.org
Subject: [PATCH v2] btrfs: log message when rw remount is attempted with unclean tree-log
Date:   Fri,  7 Feb 2020 16:19:55 +0100
Message-Id: <20200207151955.6647-1-dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
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

* fix typo in fs_info parameter

 fs/btrfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 2bfccc40d0fb..5c16b4bcde9b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1841,6 +1841,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		}
 
 		if (btrfs_super_log_root(fs_info->super_copy) != 0) {
+			btrfs_warn(fs_info,
+		"mount required to replay tree-log, cannot remount read-write");
 			ret = -EINVAL;
 			goto restore;
 		}
-- 
2.25.0

