Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46187 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3JLBBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 21:01:36 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C4E4A7C0431
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2013 19:01:35 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <20131012010129.4917.1914@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] Btrfs
Date: Fri, 11 Oct 2013 21:01:29 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We've got more bug fixes in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

One of these fixes another corner of the compression oops from last
time.  Miao nailed down some problems with concurrent snapshot deletion
and drive balancing.

I kept out one of his patches for more testing, but these are all
stable.

Josef Bacik (2) commits (+5/-9):
    Btrfs: limit delalloc pages outside of find_delalloc_range (+4/-8)
    Btrfs: use right root when checking for hash collision (+1/-1)

Miao Xie (2) commits (+20/-12):
    Btrfs: fix oops caused by the space balance and dead roots (+17/-7)
    Btrfs: insert orphan roots into fs radix tree (+3/-5)

Total: (4) commits (+25/-21)

 fs/btrfs/disk-io.c    |  9 +++++----
 fs/btrfs/disk-io.h    | 13 +++++++++++--
 fs/btrfs/extent_io.c  | 12 ++++--------
 fs/btrfs/inode.c      |  2 +-
 fs/btrfs/relocation.c |  2 +-
 fs/btrfs/root-tree.c  |  8 +++-----
 6 files changed, 25 insertions(+), 21 deletions(-)
