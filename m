Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10128 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932189AbbLRR2x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Dec 2015 12:28:53 -0500
Date: Fri, 18 Dec 2015 12:28:47 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20151218172847.GA36078@clm-mbp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

A couple of small fixes in my for-linus-4.4 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.4

Chris Mason (2) commits (+19/-7):
    Btrfs: check for empty bitmap list in setup_cluster_bitmaps (+5/-3)
    Btrfs: check prepare_uptodate_page() error code earlier (+14/-4)

Filipe Manana (2) commits (+9/-7):
    Btrfs: fix unprotected list move from unused_bgs to deleted_bgs list (+8/-5)
    Btrfs: fix transaction handle leak in balance (+1/-2)

Holger Hoffstätte (1) commits (+1/-1):
    btrfs: fix misleading warning when space cache failed to load

Total: (5) commits (+29/-15)

 fs/btrfs/extent-tree.c      | 10 +++++++---
 fs/btrfs/file.c             | 18 ++++++++++++++----
 fs/btrfs/free-space-cache.c | 10 ++++++----
 fs/btrfs/transaction.c      |  1 -
 fs/btrfs/transaction.h      |  2 +-
 fs/btrfs/volumes.c          |  3 +--
 6 files changed, 29 insertions(+), 15 deletions(-)
