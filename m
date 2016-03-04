Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17198 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbcCDSvM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Mar 2016 13:51:12 -0500
Date: Fri, 4 Mar 2016 13:51:06 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160304185106.kpf4lrko3oqsqsls@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We've got a fix in my for-linus-4.5 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.5

Filipe nailed down a problem where tree log replay would do some work
that orphan code wasn't expecting to be done yet, leading to BUG_ON.

Filipe Manana (1) commits (+9/-1):
    Btrfs: fix loading of orphan roots leading to BUG_ON

Total: (1) commits (+9/-1)

 fs/btrfs/root-tree.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)
