Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59566 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbbAHS25 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Jan 2015 13:28:57 -0500
Date: Thu, 8 Jan 2015 13:28:45 -0500
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20150108182833.GA5005@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have a small queue of btrfs fixes in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

None of these are huge, but my commit does fix a regression from 3.18
that could cause lost files during log replay.

This also adds Dave Sterba to the list of Btrfs maintainers.  It doesn't
mean we're doing things differently, but Dave has really been helping
with the maintainer workload for years.

Chris Mason (2) commits (+9/-0):
    Btrfs: don't delay inode ref updates during log replay (+8/-0)
    Btrfs: add more maintainers (+1/-0)

Wang Shilong (1) commits (+3/-1):
    Btrfs: call inode_dec_link_count() on mkdir error path

Filipe Manana (1) commits (+10/-3):
    Btrfs: correctly get tree level in tree_backref_for_extent

Josef Bacik (1) commits (+6/-6):
    Btrfs: abort transaction if we don't find the block group

Dan Carpenter (1) commits (+1/-1):
    Btrfs, scrub: uninitialized variable in scrub_extent_for_parity()

Total: (6) commits (+29/-11)

 MAINTAINERS              |  1 +
 fs/btrfs/backref.c       | 13 ++++++++++---
 fs/btrfs/delayed-inode.c |  8 ++++++++
 fs/btrfs/extent-tree.c   | 12 ++++++------
 fs/btrfs/inode.c         |  4 +++-
 fs/btrfs/scrub.c         |  2 +-
 6 files changed, 29 insertions(+), 11 deletions(-)
