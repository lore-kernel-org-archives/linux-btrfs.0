Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34433 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030273AbcBSTIk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Feb 2016 14:08:40 -0500
Date: Fri, 19 Feb 2016 14:08:34 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160219190834.ptb7qryaunhsl6d5@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.5 branch has a btrfs DIO error passing fix.  I know how
much you love DIO, so I'm going to suggest against reading it.  We'll
follow up with a patch to drop the error arg from dio_end_io in the
next merge window.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.5

Filipe Manana (1) commits (+2/-0):
    Btrfs: fix direct IO requests not reporting IO error to user space

Total: (1) commits (+2/-0)

 fs/btrfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)
