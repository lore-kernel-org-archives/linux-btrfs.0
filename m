Return-Path: <SRS0=mVxD=RJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDCD0C43381
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 01:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EF0520684
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 01:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfCFBrl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 20:47:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:44662 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726069AbfCFBrl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Mar 2019 20:47:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 819D7ACE6
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Mar 2019 01:47:40 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: Free bad extent buffer as soon as possible
Date:   Wed,  6 Mar 2019 09:47:36 +0800
Message-Id: <20190306014736.16601-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
For the new multiple -b parameter supporting, we could hit this bug on a
16K node sized btrfs:
  $ ./btrfs inspect dump-tree -b 1024 -b 2048 -b 4096 -b 8192 zimg
  btrfs-progs v4.20.2
  ERROR: tree block bytenr 1024 is not aligned to sectorsize 4096
  ERROR: tree block bytenr 2048 is not aligned to sectorsize 4096
  Couldn't map the block 4096
  Invalid mapping for 4096-20480, got 13631488-22020096
  Couldn't map the block 4096
  bad tree block 4096, bytenr mismatch, want=4096, have=0
  ERROR: failed to read tree block 4096
  extent_io.c:665: free_extent_buffer_internal: BUG_ON `eb->refs < 0`
  triggered, value 1
  ./btrfs[0x426e57]
  ./btrfs(free_extent_buffer+0xe)[0x427701]
  ./btrfs(alloc_extent_buffer+0x3f)[0x427872]
  ./btrfs(btrfs_find_create_tree_block+0xf)[0x415b3c]
  ./btrfs(read_tree_block+0x5c)[0x4171b5]
  ./btrfs(cmd_inspect_dump_tree+0x587)[0x46fb75]
  ./btrfs(handle_command_group+0x44)[0x40df89]
  ./btrfs(cmd_inspect+0x15)[0x44b569]
  ./btrfs(main+0x8b)[0x40e032]
  /lib64/libc.so.6(__libc_start_main+0xeb)[0x7f2001a54b7b]
  ./btrfs(_start+0x2a)[0x40dd1a]
  Aborted (core dumped)

This is not only limited to multiple ins dump-tree -b parameter support,
but also to possible overlapping bad tree blocks.

[CAUSE]
Btrfs delay extent freeing to improve performance.

However for the "-b 4096 -b 8192" case, the first -b 4096 will cause an
extent buffer start=4096 len=16384 refs=0 in the cached extent tree.

Then the incoming -b 8192 will hit the cache and reuse the cached extent
buffer.
And since the cached extent buffer doesn't match the bytenr, its refs
won't get increased, and we're going to free that eb again.

Since the bad cached eb already has a ref number 0, calling
free_extent_buffer() on it again will trigger the assert.

[FIX]
So for bad extent buffer we failed to read, just delete them
immediately.
This will free them from extent buffer cache, so later extent buffer
allocation will not hit the stale one, and prevent the bug from
happening.

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
To David:

I'm not sure if this patch is suitbale to be merged with ins dump-tree
multiple -b parameter support.
As it looks to be the cause of serveral reported 'refs < 0' bug.
It's pretty lucky that multiple -b parameters could trigger it reliably.

Anyway your perdiction of small fix is very correct.

Thanks,
Qu
---
 disk-io.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index 797b9b79ea3c..509e242b5614 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -392,7 +392,11 @@ struct extent_buffer* read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 			continue;
 		}
 	}
-	free_extent_buffer(eb);
+	/*
+	 * We failed to read this tree block, it be should deleted right now
+	 * to avoid stale cache populate the cache.
+	 */
+	free_extent_buffer_nocache(eb);
 	return ERR_PTR(ret);
 }
 
-- 
2.21.0

