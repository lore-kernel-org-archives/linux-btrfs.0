Return-Path: <SRS0=Vq+E=5J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CD3C10DCE
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Mar 2020 03:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73A73206F8
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Mar 2020 03:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgCXDJC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 23:09:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:44818 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgCXDJB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Mar 2020 23:09:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0E61BABCE
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2020 03:09:00 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: check/lowmem: Fix access on uninitialized memory
Date:   Tue, 24 Mar 2020 11:08:55 +0800
Message-Id: <20200324030855.29245-1-wqu@suse.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
There are some reports on fsck/001 test segfault failure with lowmem mode.

While I failed to reproduce it, valgrind still catches it with the
following output:

  Delete backref in extent [12845056 1048576]
  ERROR: file extent [257, 0] has unaligned disk bytenr: 755944791, should be aligned to 4096
  ERROR: file extent[257 0] root 5 owner 5 backref lost
  Deleted root 5 item[257, 108, 0]
  ==29080== Conditional jump or move depends on uninitialised value(s)
  ==29080==    at 0x1A81D7: btrfs_release_path (ctree.c:97)
  ==29080==    by 0x192C33: repair_extent_data_item (mode-lowmem.c:3330)
  ==29080==    by 0x1962FF: check_leaf_items (mode-lowmem.c:4696)
  ==29080==    by 0x196ABF: walk_down_tree (mode-lowmem.c:4858)
  ==29080==    by 0x197762: check_btrfs_root (mode-lowmem.c:5157)
  ==29080==    by 0x198335: check_chunks_and_extents_lowmem (mode-lowmem.c:5450)
  ==29080==    by 0x166414: do_check_chunks_and_extents (main.c:8829)
  ==29080==    by 0x169CF7: cmd_check (main.c:10313)
  ==29080==    by 0x11CDC6: cmd_execute (commands.h:125)
  ==29080==    by 0x11D712: main (btrfs.c:386)
  ==29080==

[CAUSE]
In repair_extent_data_item() if we find unaligned file extent, we just
delete it and kick in hole punch procedure.

The problem is, file extent deletion is done before initializing @path.
And when the deletion is done without problem, we will goto out tag,
which will release @path, containing uninitialized values, and
triggering segfault.

[FIX]
Don't try to abort trans nor free path if we're going through file
extent deletion routine.

Fixes: 0617bde3bc15 ("btrfs-progs: lowmem: delete unaligned bytes extent data under repair")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 7f734f974d02..1b3f24a397ea 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -3253,7 +3253,7 @@ static int repair_extent_data_item(struct btrfs_root *root,
 		ret = delete_item(root, pathp);
 		if (!ret)
 			err = 0;
-		goto out;
+		goto out_no_release;
 	}
 
 	/* now repair only adds backref */
@@ -3328,6 +3328,7 @@ out:
 	if (trans)
 		btrfs_commit_transaction(trans, root);
 	btrfs_release_path(&path);
+out_no_release:
 	if (ret)
 		error("can't repair root %llu extent data item[%llu %llu]",
 		      root->objectid, disk_bytenr, num_bytes);
-- 
2.25.2

