Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11885 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751237AbaKWPRH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Nov 2014 10:17:07 -0500
Date: Sun, 23 Nov 2014 10:14:45 -0500
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs deadlock fix
Message-ID: <20141123151439.GA16816@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Has a fix for a long standing deadlock that we've been trying to nail
down for a while.  It ended up being a bad interaction with the fair
reader/writer locks and the order btrfs reacquires locks in the btree.

Chris Mason (1) commits (+25/-15):
    btrfs: fix lockups from btrfs_clear_path_blocking

Total: (1) commits (+25/-15)

 fs/btrfs/ctree.c   | 14 ++------------
 fs/btrfs/locking.c | 24 +++++++++++++++++++++---
 fs/btrfs/locking.h |  2 ++
 3 files changed, 25 insertions(+), 15 deletions(-)
