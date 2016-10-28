Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56026 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1760229AbcJ1OIJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 10:08:09 -0400
Date: Fri, 28 Oct 2016 10:08:04 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20161028140804.leiro4pzw3qrc6sa@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.9 has two fixes in it:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.9

My patch fixes the btrfs list_head abuse that we tracked down during
Dave Jones' memory corruption investigation.  With both Jens and my
patches in place, I'm no longer able to trigger problems.

Filipe is fixing a difficult old bug between snapshots, balance and
send.  Dave is cooking a few more for the next rc, but these are tested
and ready:

Chris Mason (1) commits (+6/-14):
    btrfs: fix races on root_log_ctx lists

Filipe Manana (1) commits (+58/-0):
    Btrfs: fix incremental send failure caused by balance

Total: (2) commits (+64/-14)

 fs/btrfs/send.c     | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/tree-log.c | 20 ++++++------------
 2 files changed, 64 insertions(+), 14 deletions(-)
