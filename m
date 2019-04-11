Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22164C10F13
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 05:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4C1C2133D
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 05:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbfDKFaU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 01:30:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:57616 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726104AbfDKFaU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 01:30:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B218B048
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Apr 2019 05:30:19 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Don't BUG_ON() when write_dev_supers() fails
Date:   Thu, 11 Apr 2019 13:30:15 +0800
Message-Id: <20190411053015.5857-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
Since commit "btrfs-progs: disk-io: Flush to ensure super block write is
FUA" mkfs-tests/017 will fail like:

  ====== RUN MUSTFAIL /home/adam/btrfs-progs/mkfs.btrfs -K -f /dev/mapper/btrfs-progs-thin-vol
  ERROR: failed to write super block for devid 1: flush error: Input/output error
  disk-io.c:1810: write_all_supers: BUG_ON `ret` triggered, value -5
  /home/adam/btrfs-progs/mkfs.btrfs(+0x1e5c1)[0x557a2c83e5c1]
  /home/adam/btrfs-progs/mkfs.btrfs(+0x1e65f)[0x557a2c83e65f]
  /home/adam/btrfs-progs/mkfs.btrfs(write_all_supers+0x1ce)[0x557a2c843a8a]
  /home/adam/btrfs-progs/mkfs.btrfs(write_ctree_super+0x12d)[0x557a2c843be2]
  /home/adam/btrfs-progs/mkfs.btrfs(btrfs_commit_transaction+0x250)[0x557a2c887c56]
  /home/adam/btrfs-progs/mkfs.btrfs(+0xc0b1)[0x557a2c82c0b1]
  /home/adam/btrfs-progs/mkfs.btrfs(main+0x1049)[0x557a2c82e929]
  /usr/lib/libc.so.6(__libc_start_main+0xf3)[0x7f6689e99223]
  /home/adam/btrfs-progs/mkfs.btrfs(_start+0x2e)[0x557a2c82b86e]
  failed (expected): /home/adam/btrfs-progs/mkfs.btrfs -K -f /dev/mapper/btrfs-progs-thin-vol

[CAUSE]
Just one BUG_ON() in write_all_supers().

[FIX]
Just remove the BUG_ON(). Callers of write_all_supers() are already
checking the return value.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index 10550151c5bb..3517de3d8672 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1807,7 +1807,8 @@ int write_all_supers(struct btrfs_fs_info *fs_info)
 		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
 
 		ret = write_dev_supers(fs_info, sb, dev);
-		BUG_ON(ret);
+		if (ret < 0)
+			return ret;
 	}
 	return 0;
 }
-- 
2.21.0

