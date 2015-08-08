Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14621 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992672AbbHHTnL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Aug 2015 15:43:11 -0400
Date: Sat, 8 Aug 2015 15:41:38 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20150808194138.GA8953@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have a btrfs quota regression fix in my for-linus-4.2 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.2

I merged this one on Thursday and have run it through tests against
current master.

Normally I wouldn't have sent this while you were finalizing rc6, but I'm
feeding mosquitoes in the adirondacks next week, so I wanted to get this
one out before leaving.  I'll leave longer tests running and check on
things during the week, but I don't expect any problems.

Qu Wenruo (1) commits (+5/-0):
    btrfs: qgroup: Fix a regression in qgroup reserved space.

Total: (1) commits (+5/-0)

 fs/btrfs/qgroup.c | 5 +++++
 1 file changed, 5 insertions(+)
