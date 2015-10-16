Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60779 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754344AbbJPRe2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 13:34:28 -0400
Date: Fri, 16 Oct 2015 13:34:01 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20151016173401.GD6874@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I have two more in my for-linus-4.3 branch

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.3

My commit fixes a bug we hit last week at FB, a combination of lots of
hard links and an admin command to resolve inode numbers.

Dave is adding checks to make sure balance on current kernels ignores
filters it doesn't understand.  The penalty for being wrong is just
doing more work (not crashing etc), but it's a good fix.

Chris Mason (1) commits (+3/-5):
    btrfs: fix use after free iterating extrefs

David Sterba (1) commits (+13/-0):
    btrfs: check unsupported filters in balance arguments

Total: (2) commits (+16/-5)

 fs/btrfs/backref.c | 8 +++-----
 fs/btrfs/ioctl.c   | 5 +++++
 fs/btrfs/volumes.h | 8 ++++++++
 3 files changed, 16 insertions(+), 5 deletions(-)
