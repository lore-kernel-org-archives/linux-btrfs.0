Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55071 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751385AbdGRPlj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 11:41:39 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 298AEAABA
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jul 2017 15:41:38 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Device helper cleanups
Date: Tue, 18 Jul 2017 17:40:23 +0200
Message-Id: <cover.1500391979.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba (4):
  btrfs: merge alloc_device helpers
  btrfs: refactor find_device helper
  btrfs: split write_dev_supers to two functions
  btrfs: use named constant for bdev blocksize

 fs/btrfs/check-integrity.c |   6 +-
 fs/btrfs/disk-io.c         | 136 +++++++++++++++++++++++++--------------------
 fs/btrfs/disk-io.h         |   8 +++
 fs/btrfs/volumes.c         |  61 +++++++++-----------
 4 files changed, 115 insertions(+), 96 deletions(-)

-- 
2.13.0

