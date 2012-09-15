Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:34785 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab2IOLhY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Sep 2012 07:37:24 -0400
Date: Sat, 15 Sep 2012 07:37:21 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] a btrfs fix
Message-ID: <20120915113721.GI4143@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus branch has one revert in the new quota code:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

We're building up more fixes at etc for the next merge window, but I'm
keeping them out unless they are bigger regressions or have a huge
impact.

Chris Mason (1):
      Revert "Btrfs: fix some error codes in btrfs_qgroup_inherit()"

 fs/btrfs/qgroup.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)
