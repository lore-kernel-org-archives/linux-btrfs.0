Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49604 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755940AbdLGPtB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Dec 2017 10:49:01 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0B1B0AE11
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Dec 2017 15:49:00 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Cleanups for extent_page_data
Date: Thu,  7 Dec 2017 16:47:00 +0100
Message-Id: <cover.1512661509.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba (4):
  btrfs: merge two flush_write_bio helpers
  btrfs: sink flush_fn to extent_write_cache_pages
  btrfs: sink writepage parameter to extent_write_cache_pages
  btrfs: unify extent_page_data type passed as void

 fs/btrfs/extent_io.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

-- 
2.15.1

