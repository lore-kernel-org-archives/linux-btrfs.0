Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44519 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750762AbeE3Ek1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 00:40:27 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0507BADD3
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 04:40:26 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH REBASED 0/2] btrfs: Delay block group auto removal to avoid interfering qgroups
Date: Wed, 30 May 2018 12:40:21 +0800
Message-Id: <20180530044023.9192-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can be fetched from github:
https://github.com/adam900710/linux/tree/delayed_bg_removal

It's based on David's misc-next branch, HEAD is:
commit c77a75861d82a497bd1a26054588cd9af59eb5db (david/misc-next)
Author: Ethan Lien <ethanlien@synology.com>
Date:   Mon May 28 13:48:20 2018 +0800

    btrfs: balance dirty metadata pages in btrfs_finish_ordered_io


This bug is reported from SUSE openQA, although it's pretty hard to hit
in real world (even real world VM), it's believed block group auto
removal (anyway, there isn't much thing can remove a chunk mapping in
btrfs) could interfere with qgroup's search on commit root.

Full details can be found in the 2rd patch.

The patchset uses 1 submitted cleanup/refactor patches as basis, and the
2nd patch will ensure unused block group will only be deleted after
current transaction is done.


Qu Wenruo (2):
  btrfs: Use btrfs_mark_bg_unused() to replace open code
  btrfs: Delayed empty block group auto removal to next transaction

 fs/btrfs/ctree.h       |  2 ++
 fs/btrfs/extent-tree.c | 62 +++++++++++++++++++++++++++++-------------
 fs/btrfs/scrub.c       |  9 +-----
 fs/btrfs/transaction.c |  7 +++++
 fs/btrfs/transaction.h | 10 +++++++
 5 files changed, 63 insertions(+), 27 deletions(-)

-- 
2.17.0

