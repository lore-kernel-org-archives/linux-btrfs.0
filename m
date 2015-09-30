Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:54220 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbbI3KS7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 06:18:59 -0400
Received: from /spool/local
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 30 Sep 2015 15:48:57 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 6F158394005E
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 15:48:55 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8UAIr9Q000320
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 15:48:53 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8UAImLi012092
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2015 15:48:50 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [RFC PATCH V4 13/13] Btrfs: Return valid delalloc range when the page does not have PG_Dirty flag set or has been invalidated
Date: Wed, 30 Sep 2015 15:48:29 +0530
Message-Id: <1443608309-30154-14-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1443608309-30154-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1443608309-30154-1-git-send-email-chandan@linux.vnet.ibm.com>
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

