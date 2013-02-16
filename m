Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:48577 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3BPBzm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 20:55:42 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 509CE9A0689
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2013 18:55:41 -0700 (MST)
Date: Fri, 15 Feb 2013 20:55:36 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Message-ID: <20130216015536.GG28851@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

If you're doing another RC, please grab these two.  Otherwise I'll send
them off to -stable.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This fixes a long standing problem where the btrfs scan ioctl was racing
with mkfs.btrfs and dropping dirty pages created by mkfs.  It also fixes
a crash during tree log replay with quota enabled.

David Sterba (1) commits (+64/-6):
    btrfs: access superblock via pagecache in scan_one_device

Arne Jansen (1) commits (+1/-1):
    Btrfs: fix crash in log replay with qgroups enabled

Total: (2) commits (+65/-7)

 fs/btrfs/ctree.c   |  2 +-
 fs/btrfs/volumes.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 65 insertions(+), 7 deletions(-)

