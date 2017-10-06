Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41065 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751807AbdJFMbh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 08:31:37 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 0/3] Cleanup sector_t
Date: Fri,  6 Oct 2017 14:29:53 +0200
Message-Id: <cover.1507292872.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba (3):
  btrfs: scrub: get rid of sector_t
  btrfs: rename page offset parameter in submit_extent_page
  btrfs: get rid of sector_t and use u64 offset in submit_extent_page

 fs/btrfs/extent_io.c | 31 ++++++++++++++++---------------
 fs/btrfs/scrub.c     | 14 +++++++-------
 2 files changed, 23 insertions(+), 22 deletions(-)

-- 
2.14.0

