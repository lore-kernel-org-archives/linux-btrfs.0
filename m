Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:42576 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758396Ab2HIQB2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Aug 2012 12:01:28 -0400
Date: Thu, 9 Aug 2012 12:01:26 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL 2/2] Btrfs merge fix
Message-ID: <20120809160126.GA32103@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus-3.6 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-3.6

It fixes a merging error in rc1.  The calls to mnt_want_write should
have been removed.

Alexander Block (1):
      Btrfs: remove mnt_want_write call in btrfs_mksubvol

 fs/btrfs/ioctl.c | 5 -----
 1 file changed, 5 deletions(-)
