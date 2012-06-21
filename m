Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:51754 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab2FUPrb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 11:47:31 -0400
Date: Thu, 21 Jun 2012 11:47:28 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: <torvalds@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Message-ID: <20120621154728.GF19507@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please grab my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This is a small pull with btrfs fixes.  The biggest of the bunch is
another fix for the new backref walking code.

We're still hammering out one btrfs dio vs buffered reads problem, but
that one will have to wait for the next rc.

Josef Bacik (2) commits (+3/-2):
    Btrfs: delay iput with async extents (+2/-2)
    Btrfs: add a missing spin_lock (+1/-0)

Alexander Block (2) commits (+59/-44):
    Btrfs: don't assume to be on the correct extent in add_all_parents (+52/-42)
    Btrfs: introduce btrfs_next_old_item (+7/-2)

Total: (4) commits (+62/-46)

 fs/btrfs/backref.c |   94 +++++++++++++++++++++++++++++-----------------------
 fs/btrfs/ctree.h   |    9 +++--
 fs/btrfs/disk-io.c |    1 +
 fs/btrfs/inode.c   |    4 +--
 4 files changed, 62 insertions(+), 46 deletions(-)
