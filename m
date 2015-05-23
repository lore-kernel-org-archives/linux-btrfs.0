Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38240 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756562AbbEWBOg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 May 2015 21:14:36 -0400
Date: Fri, 22 May 2015 21:14:30 -0400
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20150523000905.GA16230@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.1 branch has three more fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.1

I fixed up a regression from 4.0 where conversion between different raid
levels would sometimes bail out without converting.

Filipe tracked down a race where it was possible to double allocate
chunks on the drive.

Mark has a fix for fiemap.  All three will get bundled off for stable as
well.

Chris Mason (1) commits (+18/-0):
    Btrfs: fix regression in raid level conversion

Filipe Manana (1) commits (+3/-0):
    Btrfs: fix racy system chunk allocation when setting block group ro

Mark Fasheh (1) commits (+17/-0):
    btrfs: clear 'ret' in btrfs_check_shared() loop

Total: (3) commits

 fs/btrfs/backref.c     | 17 +++++++++++++++++
 fs/btrfs/extent-tree.c | 20 ++++++++++++++++++++
 fs/btrfs/volumes.c     |  1 +
 3 files changed, 38 insertions(+)
