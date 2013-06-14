Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:33743 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3FNB3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Jun 2013 21:29:55 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 394047C069C
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Jun 2013 19:29:55 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: <torvalds@linux-foundation.org>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <20130614012953.4914.58775@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] Btrfs
Date: Thu, 13 Jun 2013 21:29:53 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This is an assortment of crash fixes:

Josef Bacik (3) commits (+9/-8):
    Btrfs: don't delete fs_roots until after we cleanup the transaction (+1/-1)
    Btrfs: init relocate extent_io_tree with a mapping (+5/-4)
    Btrfs: stop all workers before cleaning up roots (+3/-3)

Liu Bo (1) commits (+2/-2):
    Btrfs: fix use-after-free bug during umount

Naohiro Aota (1) commits (+3/-0):
    btrfs: Drop inode if inode root is NULL

Total: (5) commits (+14/-10)

 fs/btrfs/disk-io.c    | 10 +++++-----
 fs/btrfs/inode.c      |  3 +++
 fs/btrfs/relocation.c |  9 +++++----
 3 files changed, 13 insertions(+), 9 deletions(-)
