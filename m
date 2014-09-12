Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3539 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751903AbaILQfe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 12:35:34 -0400
Message-ID: <541320D0.4060603@fb.com>
Date: Fri, 12 Sep 2014 12:35:28 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs for rc5
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Linus,

My for-linus branch has some fixes for the next rc:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Filipe is doing a careful pass through fsync problems, and these are the
fixes so far.  I'll have one more for rc6 that we're still testing.

My big commit is fixing up some inode hash races that Al Viro found
(thanks Al).

Filipe Manana (3) commits (+75/-21):
    Btrfs: fix corruption after write/fsync failure + fsync + log recovery (+9/-3)
    Btrfs: fix fsync data loss after a ranged fsync (+64/-17)
    Btrfs: fix crash while doing a ranged fsync (+2/-1)

Chris Mason (2) commits (+113/-70):
    Btrfs: use insert_inode_locked4 for inode creation (+109/-67)
    Btrfs: fix autodefrag with compression (+4/-3)

Dan Carpenter (1) commits (+15/-10):
    Btrfs: kfree()ing ERR_PTRs

Total: (6) commits (+203/-101)

 fs/btrfs/file.c     |   2 +-
 fs/btrfs/inode.c    | 191 +++++++++++++++++++++++++++++++++-------------------
 fs/btrfs/ioctl.c    |  32 +++++----
 fs/btrfs/tree-log.c |  77 ++++++++++++++++-----
 fs/btrfs/tree-log.h |   2 +
 5 files changed, 203 insertions(+), 101 deletions(-)
