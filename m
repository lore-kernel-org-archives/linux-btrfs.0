Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56507 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755673AbdCWPJr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Mar 2017 11:09:47 -0400
Date: Thu, 23 Mar 2017 11:09:29 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20170323150929.GA74771@clm-mbp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus

We have a small set of fixes for the next RC:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.11

Zygo tracked down a very old bug with inline compressed extents.
I didn't tag this one for stable because I want to do individual tested 
backports.  It's a little tricky and I'd rather do some extra testing
on it along the way.

Otherwise they are pretty obvious:

Liu Bo (1) commits (+2/-1):
    Btrfs: fix regression in lock_delalloc_pages

Dmitry V. Levin (1) commits (+0/-27):
    btrfs: remove btrfs_err_str function from uapi/linux/btrfs.h

Zygo Blaxell (1) commits (+14/-0):
    btrfs: add missing memset while reading compressed inline extents

Total: (3) commits (+16/-28)

 fs/btrfs/extent_io.c       |  3 ++-
 fs/btrfs/inode.c           | 14 ++++++++++++++
 include/uapi/linux/btrfs.h | 27 ---------------------------
 3 files changed, 16 insertions(+), 28 deletions(-)
