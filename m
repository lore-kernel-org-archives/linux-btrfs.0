Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51677 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbdJIPWr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Oct 2017 11:22:47 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: enadolski@suse.de, bo.li.liu@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 0/3] Cleanup sector_t
Date: Mon,  9 Oct 2017 17:21:02 +0200
Message-Id: <cover.1507562199.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v2:
- update missing message s/sector/physical/
- updated changelogs where the semantics changed
- added reviewed-by

David Sterba (3):
  btrfs: scrub: get rid of sector_t
  btrfs: rename page offset parameter in submit_extent_page
  btrfs: get rid of sector_t and use u64 offset in submit_extent_page

 fs/btrfs/extent_io.c | 31 ++++++++++++++++---------------
 fs/btrfs/scrub.c     | 16 ++++++++--------
 2 files changed, 24 insertions(+), 23 deletions(-)

-- 
2.14.0

