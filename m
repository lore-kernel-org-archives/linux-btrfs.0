Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:57162 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab2LTUWA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 15:22:00 -0500
Date: Thu, 20 Dec 2012 15:21:58 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Two btrfs reverts
Message-ID: <20121220202158.GE15740@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I had missed that for two of the patches in my last pull, we had
included different fixes during 3.7.  My for-linus has them reverted:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Chris Mason (2) commits (+6/-8):
    Revert "Btrfs: MOD_LOG_KEY_REMOVE_WHILE_MOVING never change node's nritems" (+2/-2)
    Revert "Btrfs: reorder tree mod log operations in deleting a pointer" (+4/-6)

Total: (2) commits (+6/-8)

 fs/btrfs/ctree.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)
