Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47534 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3JERhG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Oct 2013 13:37:06 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 35DEA9A06A4
	for <linux-btrfs@vger.kernel.org>; Sat,  5 Oct 2013 11:37:06 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <20131005173659.12433.93614@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] Btrfs
Date: Sat, 5 Oct 2013 13:36:59 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

I've merged my for-linus up to 3.12-rc3 because the top commit is only
meant for 3.12.  The rest of the fixes are also available in my master
branch on top of my last 3.11 based pull.

This is a small collection of fixes, including a regression fix from Liu
Bo that solves rare crashes with compression on.

Ilya Dryomov (2) commits (+28/-11):
    Btrfs: fix a use-after-free bug in btrfs_dev_replace_finishing (+7/-5)
    Btrfs: eliminate races in worker stopping code (+21/-6)

Darrick J. Wong (1) commits (+8/-0):
    btrfs: Fix crash due to not allocating integrity data for a bioset

Liu Bo (1) commits (+1/-1):
    Btrfs: fix crash of compressed writes

Josef Bacik (1) commits (+2/-5):
    Btrfs: fix transid verify errors when recovering log tree

Total: (5) commits (+39/-17)

 fs/btrfs/async-thread.c | 25 +++++++++++++++++++------
 fs/btrfs/async-thread.h |  2 ++
 fs/btrfs/dev-replace.c  |  5 +----
 fs/btrfs/extent_io.c    | 10 +++++++++-
 fs/btrfs/transaction.c  |  7 ++-----
 fs/btrfs/volumes.c      |  7 ++++++-
 6 files changed, 39 insertions(+), 17 deletions(-)
