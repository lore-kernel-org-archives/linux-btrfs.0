Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3302 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbaLSOkd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 09:40:33 -0500
Date: Fri, 19 Dec 2014 09:40:28 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs pull part two
Message-ID: <20141219144028.GA29009@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

It has part two of our merge window patches.  These are all from Filipe,
and fix some really hard to find races that can cause corruptions.  Most
of them involved block group removal (balance) or discard.

Filipe Manana (4) commits (+20/-25):
    Btrfs: fix fs corruption on transaction abort if device supports discard (+6/-10)
    Btrfs: always clear a block group node when removing it from the tree (+3/-0)
    Btrfs: remove non-sense btrfs_error_discard_extent() function (+6/-12)
    Btrfs: ensure deletion from pinned_chunks list is protected (+5/-3)

Total: (4) commits (+20/-25)

 fs/btrfs/ctree.h            |  4 ++--
 fs/btrfs/disk-io.c          |  6 ------
 fs/btrfs/extent-tree.c      | 23 +++++++++++------------
 fs/btrfs/free-space-cache.c | 12 +++++++-----
 4 files changed, 20 insertions(+), 25 deletions(-)
