Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52495 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1030589AbdD1A0h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2017 20:26:37 -0400
Date: Thu, 27 Apr 2017 20:26:22 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20170428002622.GA67008@clm-mbp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have one more for btrfs:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.11

This is dropping a new WARN_ON from rc1 that ended up making more noise 
than we really want.  The larger fix for the underflow got delayed a bit 
and it's better for now to put it under CONFIG_BTRFS_DEBUG.

David Sterba (1) commits (+7/-4):
    btrfs: qgroup: move noisy underflow warning to debugging build

Total: (1) commits (+7/-4)

 fs/btrfs/qgroup.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)
