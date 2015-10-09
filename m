Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62815 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933417AbbJIRmf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Oct 2015 13:42:35 -0400
Date: Fri, 9 Oct 2015 13:42:13 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20151009174213.GA25218@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I have a few fixes in my for-linus-4.3 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.3

These are small and assorted.  Neil's is the oldest, I dropped the ball
thinking he was going to send it in.

Filipe Manana (3) commits (+26/-12):
    Btrfs: update fix for read corruption of compressed and shared extents (+11/-8)
    Btrfs: send, fix corner case for reference overwrite detection (+5/-3)
    Btrfs: fix deadlock when finalizing block group creation (+10/-1)

NeilBrown (1) commits (+5/-5):
    BTRFS: support NFSv2 export

chandan (1) commits (+4/-0):
    Btrfs: open_ctree: Fix possible memory leak

Total: (5) commits (+35/-17)

 fs/btrfs/disk-io.c     |  4 ++++
 fs/btrfs/export.c      | 10 +++++-----
 fs/btrfs/extent-tree.c |  9 ++++++++-
 fs/btrfs/extent_io.c   | 19 +++++++++++--------
 fs/btrfs/send.c        |  8 +++++---
 fs/btrfs/transaction.c |  1 +
 fs/btrfs/transaction.h |  1 +
 7 files changed, 35 insertions(+), 17 deletions(-)
