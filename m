Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:41118 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3KOPUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 10:20:05 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C08087C06F7
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 08:20:04 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Message-ID: <20131115151958.3802.1019@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] Btrfs
Date: Fri, 15 Nov 2013 10:19:58 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

This pull fixes the empty_zero_page bug that Heiko reported, and
includes one more cleanup from Al Viro.   Please grab my for-linus:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Chris Mason (1) commits (+7/-2):
    btrfs: fix empty_zero_page misusage

Al Viro (1) commits (+4/-9):
    btrfs: get rid of fdentry()

Total: (2) commits (+11/-11)

 fs/btrfs/ctree.h |  5 -----
 fs/btrfs/ioctl.c | 17 +++++++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)
