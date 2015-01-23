Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15410 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbbAWStY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 13:49:24 -0500
Date: Fri, 23 Jan 2015 13:49:18 -0500
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20150123184911.GA17437@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have a few fixes in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Qu Wenruo's batch fix a regression between some our merge window pull
and the inode_cache feature.  The rest are smaller bugs.

Qu Wenruo (2) commits (+11/-1):
    btrfs: Don't call btrfs_start_transaction() on frozen fs to avoid deadlock. (+10/-0)
    btrfs: Fix the bug that fs_info->pending_changes is never cleared. (+1/-1)

Satoru Takeuchi (1) commits (+1/-1):
    btrfs: fix state->private cast on 32 bit machines

David Sterba (1) commits (+2/-2):
    btrfs: sync ioctl, handle errors after transaction start

Filipe Manana (1) commits (+2/-1):
    Btrfs: fix race deleting block group from space_info->ro_bgs list

Tsutomu Itoh (1) commits (+1/-1):
    Btrfs: fix incorrect freeing in scrub_stripe

Total: (6) commits (+17/-6)

 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/extent_io.c   |  2 +-
 fs/btrfs/scrub.c       |  2 +-
 fs/btrfs/super.c       | 14 ++++++++++++--
 fs/btrfs/transaction.c |  2 +-
 6 files changed, 17 insertions(+), 6 deletions(-)
