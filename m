Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:35098 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbbJRMGu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Oct 2015 08:06:50 -0400
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sun, 18 Oct 2015 22:06:47 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id DCC3F3578054
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 23:06:44 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9IC6OUl29950184
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 23:06:32 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9IC6BH5029658
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 23:06:12 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V6 13/13] Btrfs: Return valid delalloc range when the page does not have PG_Dirty flag set or has been invalidated
Date: Sun, 18 Oct 2015 17:35:03 +0530
Message-Id: <1445169903-13915-14-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1445169903-13915-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1445169903-13915-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following issue was observed when running generic/095 test on
subpagesize-blocksize patchset.

Assume that we are trying to write a dirty page that is mapping file offset
range [159744, 163839].

writepage_delalloc()
  find_lock_delalloc_range(*start = 159744, *end = 0)
    find_delalloc_range()
      Returns range [X, Y] where (X > 163839)
    lock_delalloc_pages()
      One of the pages in range [X, Y] has dirty flag cleared;
      Loop once more restricting the delalloc range to span only
      PAGE_CACHE_SIZE bytes;
    find_delalloc_range()
      Returns range [356352, 360447];
    lock_delalloc_pages()
      The page [356352, 360447] has dirty flag cleared;
    Returns with *start = 159744 and *end = 0;
  *start = *end + 1;
  find_lock_delalloc_range(*start = 1, *end = 0)
    Finds and returns delalloc range [1, 12288];
  cow_file_range()
    Clears delalloc range [1, 12288]
    Create ordered extent for range [1, 12288]

The ordered extent thus created above breaks the rule that extents have to be
aligned to the filesystem's block size.

In cases where lock_delalloc_pages() fails (either due to PG_dirty flag being
cleared or the page no longer being a member of the inode's page cache), this
patch sets and returns the delalloc range that was found by
find_delalloc_range().

Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0ee486a..3912d1f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1731,6 +1731,8 @@ again:
 			goto again;
 		} else {
 			found = 0;
+			*start = delalloc_start;
+			*end = delalloc_end;
 			goto out_failed;
 		}
 	}
-- 
2.1.0

