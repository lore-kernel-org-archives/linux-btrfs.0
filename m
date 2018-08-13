Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59360 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726345AbeHMInc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Aug 2018 04:43:32 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B8A91AE4F
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Aug 2018 06:02:48 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs-progs: completion: Small fixes to make debug simpler
Date: Mon, 13 Aug 2018 14:02:42 +0800
Message-Id: <20180813060244.8795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For developer, it's pretty common to use "btrfs check" or "btrfs ins
dump-tree" on raw dumps.
Even for end user, they may hit case where they need to run "btrfs check"
on raw images.

However "btrfs check" can only complete real block devices, and
"btrfs inspect dump-tree" can only complete dir.

Make them to use _filedir() so any filename can be completed and save us
developer a little time and nerve hitting that holy tab.

changelog:
v2:
  Discard _btrfs_dev() macro completely.

Qu Wenruo (2):
  btrfs-progs: completion: Use _filedir() to replace _btrfs_devs()
  btrfs-progs: completion: Let dump-tree/dump-super/inode-resolve to
    accept any file

 btrfs-completion | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

-- 
2.18.0
