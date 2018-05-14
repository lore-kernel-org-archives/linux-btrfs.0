Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751362AbeENBiQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 May 2018 21:38:16 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E260FACBC
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 01:38:14 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: qgroup rescan fixes part 1
Date: Mon, 14 May 2018 09:38:11 +0800
Message-Id: <20180514013813.30763-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset is mainly focused on fixing qgroup rescan corruption.

Since the whole btrfs qgroup is based on the modification between 2
transactions, it only has correct qgroup delta.
While if the rescan can't provide a correct result from the very
beginning, qgroup numbers are corrupted.

The patchset is fixing two types of qgroup corruption which could happen
by looping btrfs/017 with some possibility.

1) Not accounting tree blocks
   Caused by the fact that qgroup rescan only searches commit root for
   backref, while we're passing current extent root to search.
   Fix it by also passing commit extent root.

2) Double accounting tree blocks
   Caused by wrong rescan exit condition.
   Currently qgroup only exit when it can't find any leaves beyond
   rescan progress.
   However it could cause problem when new transaction happens after
   last rescan, and old leaves CoWed to new location, and double
   accounting could happen.
   Fix it by checking and leave qgroup rescan if we have hit last leaf,
   instead of leaving it to next leaf rescan.


Changelog:
v2:
  Remove unused tree_mod_seq_elem for the 1st patch.
  Fix double unlock in 2nd patch.
  Thanks Jeff for the update.

Qu Wenruo (2):
  btrfs: qgroup: Search commit root for rescan to avoid missing extent
  btrfs: qgroup: Finish rescan when hit the last leaf of extent tree

 fs/btrfs/qgroup.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

-- 
2.17.0

