Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54088 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753487AbdBKNTS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Feb 2017 08:19:18 -0500
Date: Sat, 11 Feb 2017 08:18:50 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20170211131848.GB65294@clm-mbp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.10 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.10

Has two last minute fixes.  The highest priority here is a regression 
fix for the decompression code, but we also fixed up a problem with the 
32 bit compat ioctls.

The decompression bug could hand back the wrong data on big reads when 
zlib was used.  I have a larger cleanup to make the math here less error 
prone, but at this stage in the release Omar's patch is the best choice.

Omar Sandoval (1) commits (+24/-15):
     Btrfs: fix btrfs_decompress_buf2page()

Jeff Mahoney (1) commits (+4/-2):
     btrfs: fix btrfs_compat_ioctl failures on non-compat ioctls

Total: (2) commits (+28/-17)

  fs/btrfs/compression.c | 39 ++++++++++++++++++++++++---------------
  fs/btrfs/ioctl.c       |  6 ++++--
  2 files changed, 28 insertions(+), 17 deletions(-)
