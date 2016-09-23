Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41489 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757894AbcIWUBq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 16:01:46 -0400
Date: Fri, 23 Sep 2016 16:01:42 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160923200142.uhpsw5hhcvneebcm@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have two fixes in my for-linus-4.8 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.8

Josef is fixing a problem when quotas are enabled with his latest ENOSPC
rework, and Jeff is adding more checks into the subvol ioctls to avoid
tripping up lookup_one_len

Josef Bacik (1) commits (+3/-6):
    Btrfs: handle quota reserve failure properly

Jeff Mahoney (1) commits (+12/-0):
    btrfs: ensure that file descriptor used with subvol ioctls is a dir

Total: (2) commits (+15/-6)

 fs/btrfs/extent-tree.c |  9 +++------
 fs/btrfs/ioctl.c       | 12 ++++++++++++
 2 files changed, 15 insertions(+), 6 deletions(-)
