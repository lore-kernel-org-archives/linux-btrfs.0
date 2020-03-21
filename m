Return-Path: <SRS0=NQJ8=5G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD88BC4332B
	for <linux-btrfs@archiver.kernel.org>; Sat, 21 Mar 2020 01:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E21720722
	for <linux-btrfs@archiver.kernel.org>; Sat, 21 Mar 2020 01:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgCUBDI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 20 Mar 2020 21:03:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:44144 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbgCUBDI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Mar 2020 21:03:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 09FEDADCD
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Mar 2020 01:03:07 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: check/lowmem: Fix a false alert caused by hole beyond isize check
Date:   Sat, 21 Mar 2020 09:03:03 +0800
Message-Id: <20200321010303.124708-1-wqu@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit 91a12c0ddb00 ("btrfs-progs: fix lowmem check's handling of
holes") makes lowmem mode check to skip hole detection after isize.

However it also skipped the extent end update if the extent ends just at
isize.

This caused fsck-test/001 to fail with false hole error report.

Fix it by updating the @end parameter if we have an extent ends at inode
size.

Fixes: 91a12c0ddb00 ("btrfs-progs: fix lowmem check's handling of holes")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
David, please fold the fix into the original patch.
---
 check/mode-lowmem.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 7f734f974d02..1d2df349a9bf 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2165,8 +2165,12 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
 		}
 	}
 
-	if (fkey.offset + extent_num_bytes < isize)
-		*end = fkey.offset + extent_num_bytes;
+	/*
+	 * Don't update extent end beyond rounded up isize. As holes
+	 * after isize is not considered as missing holes.
+	 */
+	*end = min(round_up(isize, root->fs_info->sectorsize),
+		   fkey.offset + extent_num_bytes);
 	if (!is_hole)
 		*size += extent_num_bytes;
 
-- 
2.25.1

