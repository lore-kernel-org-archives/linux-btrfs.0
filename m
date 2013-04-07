Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17406 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584Ab3DGNPX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 09:15:23 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r37DFLB6018682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 7 Apr 2013 13:15:22 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r37DFLG4011172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Sun, 7 Apr 2013 13:15:21 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r37DFLu6011166
	for <linux-btrfs@vger.kernel.org>; Sun, 7 Apr 2013 13:15:21 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2 RFC] Online data deduplication
Date: Sun,  7 Apr 2013 21:12:47 +0800
Message-Id: <1365340369-23537-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the first attempt for online data deduplication.

NOTE: This leads to a FORMAT CHANGE, DO NOT use it on real data!

Data deduplication is a specialized data compression technique for eliminating
duplicate copies of repeating data.[1]

This patch set is also related to "Content based storage" in project ideas[2].

For more implementation details, please refer to PATCH 1.

PATCH 2 is a hang fix when deduplication is on.

======
HOW To turn deduplication on:

There are 2 steps you need to do before using it,
1) mount with option "-o dedup"
2) then run 'btrfs filesystem sync /mnt_of_your_btrfs'
(Because I hack 'btrfs fi sync' to enable deduplication...)

Here is an example:
1) mkfs.btrfs /dev/sdb1
2) mount /dev/sdb1 /mnt/btrfs -o dedup
3) btrfs filesystem sync /mnt/btrfs
4) btrfs fi df /mnt/btrfs
   Data: total=8.00MB, used=256.00KB
   System, DUP: total=8.00MB, used=4.00KB
   System: total=4.00MB, used=0.00
   Metadata, DUP: total=1.00GB, used=28.00KB
   Metadata: total=8.00MB, used=0.00

5) dd if=/dev/zero of=/mnt/btrfs/foo bs=4K count=1; sync
6) dd if=/dev/zero of=/mnt/btrfs/foo bs=1M count=10; sync
   Data: total=1.01GB, used=260.00KB
   System, DUP: total=8.00MB, used=4.00KB
   System: total=4.00MB, used=0.00
   Metadata, DUP: total=1.00GB, used=432.00KB
   Metadata: total=8.00MB, used=0.00

So 4K+10M has been written, but used=256.00KB -> used=260.00KB,
only 4KB is used!

=====================
TODO:
1) a bit-to-bit comparison callback.
2) support for alternative blocksize larger than PAGESIZE

I just tested it with simple cases like above, and not even with xfstests, which
is what I'm going to do.

Any comments are welcome!


[1]: http://en.wikipedia.org/wiki/Data_deduplication
[2]: https://btrfs.wiki.kernel.org/index.php/Project_ideas#Content_based_storage

Liu Bo (2):
  Btrfs: online data deduplication
  Btrfs: skip merge part for delayed data refs

 fs/btrfs/ctree.h        |   53 ++++++++
 fs/btrfs/delayed-ref.c  |    7 +
 fs/btrfs/disk-io.c      |   33 +++++-
 fs/btrfs/extent-tree.c  |   22 +++-
 fs/btrfs/extent_io.c    |    8 +-
 fs/btrfs/extent_io.h    |   11 ++
 fs/btrfs/file-item.c    |  184 ++++++++++++++++++++++++++
 fs/btrfs/file.c         |    6 +-
 fs/btrfs/inode.c        |  327 +++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/ioctl.c        |   34 +++++-
 fs/btrfs/ordered-data.c |   25 +++-
 fs/btrfs/ordered-data.h |    9 ++
 fs/btrfs/print-tree.c   |    6 +-
 fs/btrfs/super.c        |    7 +-
 14 files changed, 687 insertions(+), 45 deletions(-)

-- 
1.7.7

