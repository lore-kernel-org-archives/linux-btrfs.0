Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:41774 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab3JRXYz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Oct 2013 19:24:55 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 3D9757C041C
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Oct 2013 17:24:55 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <20131018232447.4917.74376@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] Btrfs
Date: Fri, 18 Oct 2013 19:24:47 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus branch has a one line fix:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Sage hit a deadlock with ceph on btrfs, and Josef tracked it down to a
regression in our initial rc1 pull.  When doing nocow writes we were
sometimes starting a transaction with locks held.

Josef Bacik (1) commits (+1/-0):
    Btrfs: release path before starting transaction in can_nocow_extent

Total: (1) commits (+1/-0)

 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)
