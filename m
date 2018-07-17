Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727481AbeGQGqb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 02:46:31 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D5A62AD61
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jul 2018 06:15:34 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: completion: Small fixes to make debug simpler
Date: Tue, 17 Jul 2018 14:15:30 +0800
Message-Id: <20180717061532.11857-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For developer, it's pretty common to use "btrfs check" or "btrfs ins
dump-tree" on raw dumps.

However "btrfs check" can only complete real block devices, and
"btrfs inspect dump-tree" can only complete dir.

Make them to use _filedir() so any filename can be completed and save us
developer a little time and nerve hitting that holy tab.

Qu Wenruo (2):
  btrfs-progs: completion: Use _filedir() to replace _btrfs_devs()
  btrfs-progs: completion: Let dump-tree/dump-super/inode-resolve to
    accept any file

 btrfs-completion | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
2.18.0

