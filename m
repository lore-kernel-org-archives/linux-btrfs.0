Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6442 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbbGQTiP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jul 2015 15:38:15 -0400
Date: Fri, 17 Jul 2015 15:38:10 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20150717193810.GC8274@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have some fixes in my for-linus-4.2 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.2

These are all from Filipe, and cover a few problems we've had reported
on the list recently (along with ones he found on his own).

Filipe Manana (5) commits (+34/-6):
    Btrfs: fix shrinking truncate when the no_holes feature is enabled (+2/-3)
    Btrfs: fix file corruption after cloning inline extents (+14/-0)
    Btrfs: fix list transaction->pending_ordered corruption (+2/-2)
    Btrfs: fix order by which delayed references are run (+13/-0)
    Btrfs: fix memory leak in the extent_same ioctl (+3/-1)

Total: (5) commits (+34/-6)

 fs/btrfs/extent-tree.c | 13 +++++++++++++
 fs/btrfs/inode.c       |  5 ++---
 fs/btrfs/ioctl.c       | 18 +++++++++++++++++-
 fs/btrfs/transaction.c |  4 ++--
 4 files changed, 34 insertions(+), 6 deletions(-)
