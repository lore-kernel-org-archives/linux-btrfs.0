Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5793 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849AbaGTOd2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 10:33:28 -0400
Message-ID: <53CBD334.7010408@fb.com>
Date: Sun, 20 Jul 2014 10:33:24 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Linus,

We have two more fixes in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

I was hoping to also include a fix for a btrfs deadlock with compression
enabled, but we're still nailing that one down.

Liu Bo (1) commits (+11/-0):
    Btrfs: fix abnormal long waiting in fsync

Eric Sandeen (1) commits (+4/-4):
    btrfs: test for valid bdev before kobj removal in btrfs_rm_device

Total: (2) commits (+15/-4)

 fs/btrfs/ordered-data.c | 11 +++++++++++
 fs/btrfs/volumes.c      |  8 ++++----
 2 files changed, 15 insertions(+), 4 deletions(-)
