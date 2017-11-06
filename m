Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932304AbdKFTcf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 14:32:35 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CE74CABED
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 19:32:33 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 00/10] Cleanup unnecessary get_extent parameters
Date: Mon,  6 Nov 2017 20:30:42 +0100
Message-Id: <cover.1509996091.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are several functions that take a generic get_extent parameter, but not
all of them use it to distinguish between btree_get_exnent (for metadata) and
btrfs_get_extent (for data). This is namely extent_read_full_page and
__do_readpage.

The rest can be cleaned up so that the desired get_extent callback is used
directly. The patchset does that incrementally so each change is clear.

The difference in binary code size is not that impressive:
  text    data     bss     dec     hex filename
985353   75124   18560 1079037  1076fd pre/btrfs.ko
985193   75124   18560 1078877  10765d post/btrfs.ko

but the estimated stack consumption savings are about 64 bytes, and it could be
more if we calculate cummulative effect when more than one reduced function is
in the callchain:

-extent_io.c:btree_write_cache_pages                      288 static
+extent_io.c:btree_write_cache_pages                      280 static
-extent_io.c:extent_fiemap                                264 dynamic,bounded
+extent_io.c:extent_fiemap                                256 dynamic,bounded
-extent_io.c:extent_readpages                             264 dynamic,bounded
+extent_io.c:extent_readpages                             248 dynamic,bounded
-extent_io.c:extent_write_full_page                       56 static
+extent_io.c:extent_write_full_page                       48 static
-extent_io.c:extent_write_locked_range                    200 static
+extent_io.c:extent_write_locked_range                    192 static
-extent_io.c:extent_writepages                            56 static
+extent_io.c:extent_writepages                            48 static
-extent_io.c:get_extent_skip_holes                        64 static
+extent_io.c:get_extent_skip_holes                        56 static

(calculated with gcc -fstack-usage)

David Sterba (10):

  btrfs: sink get_extent parameter to extent_writepages
  btrfs: sink get_extent parameter to extent_write_locked_range
  btrfs: sink get_extent parameter to extent_write_full_page
  btrfs: drop get_extent from extent_page_data
  btrfs: sink get_extent parameter to extent_fiemap
  btrfs: sink get_extent parameter to get_extent_skip_holes
  btrfs: sink get_extent parameter to extent_readpages
  btrfs: sink get_extent parameter to __extent_readpages
  btrfs: sink get_extent parameter to __do_contiguous_readpages
  btrfs: sink get_extent parameter to read_extent_buffer_pages

 fs/btrfs/disk-io.c   |  8 ++++----
 fs/btrfs/disk-io.h   |  3 +++
 fs/btrfs/extent_io.c | 55 ++++++++++++++++++++--------------------------------
 fs/btrfs/extent_io.h | 12 ++++--------
 fs/btrfs/inode.c     | 10 ++++------
 5 files changed, 36 insertions(+), 52 deletions(-)

-- 
2.14.3

