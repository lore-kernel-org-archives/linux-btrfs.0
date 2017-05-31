Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39433 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750998AbdEaRuU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 13:50:20 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 31D86AAB6
        for <linux-btrfs@vger.kernel.org>; Wed, 31 May 2017 17:50:19 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/5] More vmalloc cleanups
Date: Wed, 31 May 2017 19:49:18 +0200
Message-Id: <cover.1496252765.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All vmalloc/vzalloc calls should be addressed, in this or the currently pending
patches.

David Sterba (5):
  btrfs: replace opencoded kvzalloc with the helper
  btrfs: send: use kvmalloc in iterate_dir_item
  btrfs: scrub: add memalloc_nofs protection around init_ipath
  btrfs: use GFP_KERNEL in init_ipath
  btrfs: adjust includes after vmalloc removal

 fs/btrfs/backref.c         | 10 +++++-----
 fs/btrfs/check-integrity.c | 11 ++++-------
 fs/btrfs/ctree.c           |  2 +-
 fs/btrfs/ioctl.c           |  4 ++--
 fs/btrfs/raid56.c          | 11 ++++-------
 fs/btrfs/scrub.c           |  9 +++++++++
 fs/btrfs/send.c            | 11 ++++-------
 7 files changed, 29 insertions(+), 29 deletions(-)

-- 
2.12.0

