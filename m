Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28718 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbcDAWsS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 18:48:18 -0400
Date: Fri, 1 Apr 2016 18:45:22 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160401224522.phn6qtiljgt4d52f@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.6 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.6

Has a few fixes Dave Sterba had queued up.  These are all pretty small,
but since they were tested I decided against waiting for more:

Alex Lyakas (2) commits (+18/-10):
    btrfs: do not write corrupted metadata blocks to disk (+13/-2)
    btrfs: csum_tree_block: return proper errno value (+5/-8)

Jiri Kosina (2) commits (+7/-10):
    btrfs: cleaner_kthread() doesn't need explicit freeze (+1/-1)
    btrfs: transaction_kthread() is not freezable (+6/-9)

Total: (4) commits (+25/-20)

 fs/btrfs/disk-io.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)
