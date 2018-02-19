Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54126 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752906AbeBSQ0b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Feb 2018 11:26:31 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8D91DAC12
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Feb 2018 16:26:30 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Function annotations
Date: Mon, 19 Feb 2018 17:24:13 +0100
Message-Id: <cover.1519057258.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add some more annotations, inspired by the __init.

The 2nd patches gives roughly -800 delta in object size, but nothing too
significant.

   text    data     bss     dec     hex filename
1238987   75977   18520 1333484  1458ec pre/btrfs.ko
1238199   75977   18520 1332696  1455d8 post/btrfs.ko

David Sterba (2):
  btrfs: add (the only possible) __exit annotation
  btrfs: add more __cold annotations

 fs/btrfs/backref.c       | 2 +-
 fs/btrfs/backref.h       | 2 +-
 fs/btrfs/compression.c   | 2 +-
 fs/btrfs/compression.h   | 2 +-
 fs/btrfs/ctree.h         | 9 +++++----
 fs/btrfs/delayed-inode.c | 2 +-
 fs/btrfs/delayed-inode.h | 2 +-
 fs/btrfs/delayed-ref.c   | 2 +-
 fs/btrfs/delayed-ref.h   | 2 +-
 fs/btrfs/disk-io.c       | 2 +-
 fs/btrfs/disk-io.h       | 2 +-
 fs/btrfs/extent_io.c     | 2 +-
 fs/btrfs/extent_io.h     | 2 +-
 fs/btrfs/extent_map.c    | 2 +-
 fs/btrfs/extent_map.h    | 2 +-
 fs/btrfs/file.c          | 2 +-
 fs/btrfs/inode.c         | 2 +-
 fs/btrfs/ordered-data.c  | 2 +-
 fs/btrfs/ordered-data.h  | 2 +-
 fs/btrfs/super.c         | 2 +-
 fs/btrfs/sysfs.c         | 2 +-
 fs/btrfs/tree-checker.c  | 3 +++
 fs/btrfs/volumes.c       | 2 +-
 fs/btrfs/volumes.h       | 2 +-
 24 files changed, 30 insertions(+), 26 deletions(-)

-- 
2.16.1

