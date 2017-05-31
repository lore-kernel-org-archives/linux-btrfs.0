Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49103 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750898AbdEaPmc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 11:42:32 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E572DABCA
        for <linux-btrfs@vger.kernel.org>; Wed, 31 May 2017 15:42:30 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/3] Update gfp flags in alloc_workspace
Date: Wed, 31 May 2017 17:41:29 +0200
Message-Id: <cover.1496245064.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can cheaply get rid of a few GFP_NOFS, as there are only two contexts,
initializaton (GFP_KERNEL is ok), and potentially a "NOFS", but with
memalloc_nofs it's made safe.

David Sterba (3):
  btrfs: add memalloc_nofs protections around alloc_workspace callback
  btrfs: switch kmallocs to GFP_KERNEL in lzo/zlib alloc_workspace
  btrfs: switch to kvmalloc and GFP_KERNEL in lzo/zlib alloc_workspace

 fs/btrfs/compression.c | 10 ++++++++++
 fs/btrfs/lzo.c         | 16 ++++++++--------
 fs/btrfs/zlib.c        | 10 +++++-----
 3 files changed, 23 insertions(+), 13 deletions(-)

-- 
2.12.0

