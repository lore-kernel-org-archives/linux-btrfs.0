Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4359 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbbJWMrJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Oct 2015 08:47:09 -0400
Date: Fri, 23 Oct 2015 08:47:02 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        btrfs <linux-btrfs@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20151023124702.GA4830@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I have two more small fixes this week in my for-linus-4.3 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.3

Qu's fix avoids unneeded COW during fallocate, and Christian
found a memory leak in the error handling of an earlier fix.

Qu Wenruo (1) commits (+1/-1):
    btrfs: Avoid truncate tailing page if fallocate range doesn't exceed inode size

Christian Engelmayer (1) commits (+4/-1):
    btrfs: fix possible leak in btrfs_ioctl_balance()

Total: (2) commits (+5/-2)

 fs/btrfs/file.c  | 2 +-
 fs/btrfs/ioctl.c | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

