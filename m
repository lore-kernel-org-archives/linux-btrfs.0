Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42847 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751745AbdEPRLS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:11:18 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7DBDFAB5F
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:11:17 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 00/10] Btrfs, minor scrub code cleanups
Date: Tue, 16 May 2017 19:10:20 +0200
Message-Id: <cover.1494954480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A bunch of minor cleanups in the scrub code. For 4.13.

David Sterba (10):
  btrfs: scrub: inline helper scrub_setup_wr_ctx
  btrfs: scrub: inline helper scrub_free_wr_ctx
  btrfs: scrub: simplify cleanup of wr_ctx in scrub_free_ctx
  btrfs: scrub: embed scrub_wr_ctx into scrub context
  btrfs: scrub: remove pages_per_wr_bio from scrub context
  btrfs: scrub: use bool for flush_all_writes
  btrfs: scrub: use fs_info::sectorsize and drop it from scrub context
  btrfs: scrub: clean up division in __scrub_mark_bitmap
  btrfs: scrub: clean up division in scrub_find_csum
  btrfs: scrub: simplify srrub worker initialization

 fs/btrfs/scrub.c | 181 +++++++++++++++++++++----------------------------------
 1 file changed, 70 insertions(+), 111 deletions(-)

-- 
2.12.0

