Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11889 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbcBLQo5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 11:44:57 -0500
Date: Fri, 12 Feb 2016 11:43:16 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160212164316.x2svnvzckxeorpkz@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus-4.5 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.5

This has a few fixes from Filipe, along with a readdir fix from Dave
that we've been testing for some time.

Filipe Manana (4) commits (+115/-68):
    Btrfs: remove no longer used function extent_read_full_page_nolock() (+12/-42)
    Btrfs: fix hang on extent buffer lock caused by the inode_paths ioctl (+6/-4)
    Btrfs: fix page reading in extent_same ioctl leading to csum errors (+21/-8)
    Btrfs: fix invalid page accesses in extent_same (dedup) ioctl (+76/-14)

David Sterba (1) commits (+16/-3):
    btrfs: properly set the termination value of ctx->pos in readdir

Total: (5) commits (+131/-71)

 fs/btrfs/backref.c       |  10 ++--
 fs/btrfs/compression.c   |   6 +--
 fs/btrfs/delayed-inode.c |   3 +-
 fs/btrfs/delayed-inode.h |   2 +-
 fs/btrfs/extent_io.c     |  45 +++++-------------
 fs/btrfs/extent_io.h     |   3 --
 fs/btrfs/inode.c         |  14 +++++-
 fs/btrfs/ioctl.c         | 119 ++++++++++++++++++++++++++++++++++++++---------
 8 files changed, 131 insertions(+), 71 deletions(-)
