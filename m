Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:49046 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbbJ0Jlq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 05:41:46 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 27 Oct 2015 19:41:44 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 468F52CE8054
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 20:41:42 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9R9fSuJ25034754
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 20:41:36 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9R9f8pK019450
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 20:41:09 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V7 13/13] Btrfs: Return valid delalloc range when the page does not have PG_Dirty flag set or has been invalidated
Date: Tue, 27 Oct 2015 15:09:46 +0530
Message-Id: <1445938786-12488-14-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1445938786-12488-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1445938786-12488-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index d093643..9c5891a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1794,6 +1794,8 @@ again:
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

