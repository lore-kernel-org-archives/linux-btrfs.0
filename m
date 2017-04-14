Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35911 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754741AbdDNS3M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Apr 2017 14:29:12 -0400
Date: Fri, 14 Apr 2017 11:28:37 -0700
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20170414182832.GA52628@clm-mbp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus

Dave Sterba collected a few more fixes for the last rc:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.11

These aren't marked for stable, but I'm putting them in with a batch 
were testing/sending by hand for this release.

Liu Bo (3) commits (+11/-13):
    Btrfs: fix invalid dereference in btrfs_retry_endio (+4/-10)
    Btrfs: fix potential use-after-free for cloned bio (+1/-1)
    Btrfs: fix segmentation fault when doing dio read (+6/-2)

Adam Borowski (1) commits (+3/-0):
    btrfs: drop the nossd flag when remounting with -o ssd

Total: (4) commits (+14/-13)

 fs/btrfs/inode.c   | 22 ++++++++++------------
 fs/btrfs/super.c   |  3 +++
 fs/btrfs/volumes.c |  2 +-
 3 files changed, 14 insertions(+), 13 deletions(-)
