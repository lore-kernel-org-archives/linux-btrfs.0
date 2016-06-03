Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11630 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161171AbcFCU5s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jun 2016 16:57:48 -0400
Date: Fri, 3 Jun 2016 16:57:43 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160603205743.lcq6jz5mdflzwyit@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.7 branch has some fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.7

I realized as I was prepping this pull that my tip commit still had
Facebook task numbers and other internal metadata in it.  So I had to
reword the description, which is why it is only a few hours old.  Only
the description changed since testing.

The important part of this pull is Filipe's set of fixes for btrfs device
replacement.  Filipe fixed a few issues seen on the list and a number
he found on his own.

Filipe Manana (8) commits (+93/-19):
    Btrfs: fix race setting block group back to RW mode during device replace (+5/-5)
    Btrfs: fix unprotected assignment of the left cursor for device replace (+4/-0)
    Btrfs: fix race setting block group readonly during device replace (+46/-2)
    Btrfs: fix race between device replace and block group removal (+11/-0)
    Btrfs: fix race between device replace and chunk allocation (+9/-12)
    Btrfs: fix race between readahead and device replace/removal (+2/-0)
    Btrfs: fix race between device replace and read repair (+10/-0)
    Btrfs: fix race between device replace and discard (+6/-0)

Chris Mason (1) commits (+12/-1):
    Btrfs: deal with duplciates during extent_map insertion in btrfs_get_extent

Total: (9) commits (+105/-20)

 fs/btrfs/extent-tree.c  |  6 ++++++
 fs/btrfs/extent_io.c    | 10 ++++++++++
 fs/btrfs/inode.c        | 13 ++++++++++++-
 fs/btrfs/ordered-data.c |  6 +++++-
 fs/btrfs/ordered-data.h |  2 +-
 fs/btrfs/reada.c        |  2 ++
 fs/btrfs/scrub.c        | 50 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.c      | 32 +++++++++++++++++++------------
 8 files changed, 103 insertions(+), 18 deletions(-)
