Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37686 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829AbbEOTPf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 15:15:35 -0400
Date: Fri, 15 May 2015 15:11:51 -0400
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20150515191142.GA13342@ret.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I have a few more fixes in my for-linus-4.1 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.1

The first commit is a fix from Filipe for a very old extent buffer reuse
race that triggered a BUG_ON.  It hasn't come up often, I looked through
old logs at FB and we hit it a handful of times over the last year.

The rest are other corners he hit during testing

Filipe Manana (4) commits (+68/-10):
    Btrfs: fix race when reusing stale extent buffers that leads to BUG_ON (+19/-0)
    Btrfs: fix race between block group creation and their cache writeout (+27/-4)
    Btrfs: fix panic when starting bg cache writeout after IO error (+10/-4)
    Btrfs: fix crash after inode cache writeback failure (+12/-2)

Total: (4) commits

 fs/btrfs/extent-tree.c      | 31 +++++++++++++++++++++++++++----
 fs/btrfs/extent_io.c        | 19 +++++++++++++++++++
 fs/btrfs/free-space-cache.c | 14 ++++++++++++--
 fs/btrfs/ordered-data.c     | 14 ++++++++++----
 4 files changed, 68 insertions(+), 10 deletions(-)
