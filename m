Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:39559 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3DVNOa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 09:14:30 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 14FE99A0406
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 07:14:30 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id lnhmCCkLp13pl9xJ (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 07:14:29 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't call readahead hook until we have read the entire eb
Date: Mon, 22 Apr 2013 09:14:27 -0400
Message-ID: <1366636467-2187-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald reported a BUG_ON() where we were given a bogus bytenr to
map.  Turns out he is using > PAGESIZE leafsizes.  The readahead stuff is called
every time we do a completion, but we may not have finished reading in all the
pages, so the bytenr we read off the node could be completely bogus.  Fix this
by only calling the readahead hook once all pages have been read in.  Thanks,

Reported-by: Martin Steigerwald <Martin@lichtvoll.de>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fa8438f..f4628c7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -674,10 +674,9 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	if (!ret)
 		set_extent_buffer_uptodate(eb);
 err:
-	if (test_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags)) {
-		clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags);
+	if (reads_done &&
+	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
 		btree_readahead_hook(root, eb, eb->start, ret);
-	}
 
 	if (ret) {
 		/*
-- 
1.7.7.6

