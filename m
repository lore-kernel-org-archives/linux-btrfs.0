Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41413 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754909AbbBJK1H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:07 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQKwV000894
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:20 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/4] Btrfs: qgroup: part-2: bug fixes for qgroup reservation.
Date: Tue, 10 Feb 2015 18:23:44 +0800
Message-ID: <1423563828-9053-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
	This is part2 for qgroup. It is based on 
	[PATCH 0/9] Btrfs: qgroup: part-1: bug fixes.

[1/4] is reviewed-by Josef.

[2/4] - [4/4] are trying to solve a problem in qgroup reservation.
It would be weired I introduce a may_use in 2/4 and delete it in 4/4.

Yes, I am glad to rebase and squash them, here I am keeping this history
of the problem for reviewing. I have explained the problem and sent the
[2/4] out. Josef give me a looks good at that time. But in the later, I
found another problem and solved it with [4/4]. So they are trying to
solve different problems at different timing. When the all patches are
reviewed by you guys, I am okey to squash them if you request.

Thanx.

Dongsheng Yang (4):
  Btrfs: qgroup: free reserved in exceeding quota.
  Btrfs: qgroup: Introduce a may_use to account
    space_info->bytes_may_use.
  Btrfs: qgroup, Account data space in more proper timings.
  btrfs: qgroup: do a reservation in a higher level.

 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/extent-tree.c | 25 +++++++++++--------------
 fs/btrfs/file.c        | 13 ++-----------
 fs/btrfs/inode.c       |  3 ++-
 fs/btrfs/qgroup.c      | 10 ++++------
 fs/btrfs/relocation.c  |  2 +-
 6 files changed, 21 insertions(+), 34 deletions(-)

-- 
1.8.4.2

