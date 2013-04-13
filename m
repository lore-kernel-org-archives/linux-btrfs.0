Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46041 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab3DMOSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Apr 2013 10:18:44 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 206A47C068B
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Apr 2013 08:18:44 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Message-ID: <20130413141841.12886.91603@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] One more btrfs
Date: Sat, 13 Apr 2013 10:18:41 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus

My for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Has a recent fix from Josef for our tree log replay code.  It fixes
problems where the inode counter for the number of bytes in the file
wasn't getting updated properly during fsync replay.

The commit did get rebased this morning, but it was only to clean up the
subject line.  The code hasn't changed.

Josef Bacik (1) commits (+42/-6):
    Btrfs: make sure nbytes are right after log replay

Total: (1) commits (+42/-6)

 fs/btrfs/tree-log.c | 48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)
