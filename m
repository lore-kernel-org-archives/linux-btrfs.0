Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37378 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752740AbaG2JWY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 05:22:24 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6T9MJAg002817
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 17:22:19 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 00/12] Implement the data repair function for direct read
Date: Tue, 29 Jul 2014 17:23:58 +0800
Message-ID: <1406625850-32168-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset implement the data repair function for the direct read, it
is implemented like buffered read:
1.When we find the data is not right, we try to read the data from the other
  mirror.
2.When the io on the mirror ends, we will insert the endio work into the
  system workqueue, not btrfs own endio workqueue, because the original
  endio work is still blocked in the btrfs endio workqueue, if we insert
  the endio work of the io on the mirror into that workqueue, deadlock
  would happen.
3.If We get right data, we write it back to repair the corrupted mirror.
4.If the data on the new mirror is still corrupted, we will try next
  mirror until we read right data or all the mirrors are traversed.
5.After the above work, we set the uptodate flag according to the result.

The difference is that the direct read may be splited to several small io,
in order to get the number of the mirror on which the io error happens. we
have to do data check and repair on the end IO function of those sub-IO
request.

Besides that, we also fixed some bugs of direct io.

Changelog v1 -> v2:
- Fix the warning which was triggered by __GFP_ZERO in the 2nd patch

We can pull this patchset from the URL

  https://github.com/miaoxie/linux-btrfs.git for-Chris

Thanks
Miao
---
Miao Xie (12):
  Btrfs: fix put dio bio twice when we submit dio bio fail
  Btrfs: load checksum data once when submitting a direct read io
  Btrfs: cleanup similar code of the buffered data data check and dio
    read data check
  Btrfs: do file data check by sub-bio's self
  Btrfs: fix missing error handler if submiting re-read bio fails
  Btrfs: Cleanup unused variant and argument of IO failure handlers
  Btrfs: split bio_readpage_error into several functions
  Btrfs: modify repair_io_failure and make it suit direct io
  Btrfs: modify clean_io_failure and make it suit direct io
  Btrfs: Set real mirror number for read operation on RAID0/5/6
  Btrfs: implement repair function when direct read fails
  Btrfs: cleanup the read failure record after write or when the inode
    is freeing

 fs/btrfs/btrfs_inode.h |  10 +-
 fs/btrfs/ctree.h       |   3 +-
 fs/btrfs/disk-io.c     |  43 +++--
 fs/btrfs/disk-io.h     |   1 +
 fs/btrfs/extent_io.c   | 254 ++++++++++++++++++----------
 fs/btrfs/extent_io.h   |  38 ++++-
 fs/btrfs/file-item.c   |  14 +-
 fs/btrfs/inode.c       | 451 ++++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/scrub.c       |   4 +-
 fs/btrfs/volumes.c     |   5 +
 fs/btrfs/volumes.h     |   5 +-
 11 files changed, 622 insertions(+), 206 deletions(-)

-- 
1.9.3

