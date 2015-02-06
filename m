Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7936 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932069AbbBFUQ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Feb 2015 15:16:29 -0500
Date: Fri, 6 Feb 2015 15:16:05 -0500
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fix
Message-ID: <20150206201558.GA16241@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Forrest Liu tracked down a missing blk_finish_plug in the btrfs logging
code. This isn't a new bug, and it's hard to hit.  But, it's safe enough
for inclusion now, and in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

I missed the cc: stable, but I'll send it along to them as well.

Forrest Liu (1) commits (+1/-0):
    Btrfs: add missing blk_finish_plug in btrfs_sync_log()

Total: (1) commits (+1/-0)

 fs/btrfs/tree-log.c | 1 +
 1 file changed, 1 insertion(+)

