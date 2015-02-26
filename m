Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35584 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752450AbbBZCBR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 21:01:17 -0500
Date: Wed, 25 Feb 2015 21:01:11 -0500
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20150226020104.GA7569@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I'm still testing more fixes, but I wanted to get out the fix for the
btrfs raid5/6 memory corruption I mentioned in my merge window pull.

Please pull my for-linus:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Chris Mason (1) commits (+8/-1):
    Btrfs: fix allocation size calculations in alloc_btrfs_bio

Total: (1) commits (+8/-1)

 fs/btrfs/volumes.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)
