Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11888 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932080AbaISTrY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 15:47:24 -0400
Message-ID: <541C8845.4080101@fb.com>
Date: Fri, 19 Sep 2014 15:47:17 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have two more fixes for pulling:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

I've got a  revert to fix a regression with btrfs device registration,
and Filipe has part two of his fsync fix from last week.

Chris Mason (1) commits (+6/-7):
    Revert "Btrfs: device_list_add() should not update list when mounted"

Filipe Manana (1) commits (+13/-14):
    Btrfs: set inode's logged_trans/last_log_commit after ranged fsync

Total: (2) commits (+19/-21)

 fs/btrfs/btrfs_inode.h | 13 +++++++++++--
 fs/btrfs/tree-log.c    | 14 ++------------
 fs/btrfs/volumes.c     | 13 ++++++-------
 3 files changed, 19 insertions(+), 21 deletions(-)
