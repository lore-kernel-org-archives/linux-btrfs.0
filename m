Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5906 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738AbaBITLZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Feb 2014 14:11:25 -0500
Message-ID: <52F7D377.7010302@fb.com>
Date: Sun, 9 Feb 2014 14:13:59 -0500
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This is a small collection of fixes

Josef Bacik (2) commits (+4/-5):
    Btrfs: don't loop forever if we can't run because of the tree mod log (+1/-0)
    Btrfs: fix assert screwup for the pending move stuff (+3/-5)

David Sterba (1) commits (+1/-1):
    btrfs: reserve no transaction units in btrfs_ioctl_set_features

Filipe David Borba Manana (1) commits (+2/-0):
    Btrfs: fix data corruption when reading/updating compressed extents

Jeff Mahoney (1) commits (+2/-2):
    btrfs: commit transaction after setting label and features

Total: (5) commits (+9/-8)

 fs/btrfs/compression.c | 2 ++
 fs/btrfs/extent-tree.c | 1 +
 fs/btrfs/ioctl.c       | 6 +++---
 fs/btrfs/send.c        | 8 +++-----
 4 files changed, 9 insertions(+), 8 deletions(-)
