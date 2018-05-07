Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:45666 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752276AbeEGImT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 04:42:19 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 0/2] btrfs fiemap related BUG fix.
Date: Mon,  7 May 2018 16:42:03 +0800
Message-Id: <1525682525-1424-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

This patchset intends to fix btrfs fiemap related bug.

The fiemap has the following problems:

1) fiemap: pass correct bytenr when fm_extent_count is zero
 When user space wants to get the number of file extents,
 set fm_extent_count to 0 to run fiemap and then read fm_mapped_extents.

 In the above example, fiemap will return with fm_mapped_extents set to 4,
 but it should be 1 since there's only one entry in the output.

 Details can refer to "[PATCH v2 1/2] Btrfs: fiemap: pass correct bytenr
 when fm_extent_count is zero"

2) fiemap extent SHARED flag error with range clone
 Currently, only the first extent is checked for shared in extent_map.

 Here we will check each extent with extent map range, if one of them
 is shared, extent map is shared.

 Details can refer to "[PATCH v2 2/2] Btrfs: fix fiemap extent SHARED
 flag error with range clone."

Robbie Ko (2):
  Btrfs: fiemap: pass correct bytenr when fm_extent_count is zero
  Btrfs: fix fiemap extent SHARED flag error with range clone.

 fs/btrfs/extent_io.c | 150 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 132 insertions(+), 18 deletions(-)

-- 
1.9.1

