Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726919AbeIMROV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 13:14:21 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 83024AD6A
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 12:05:10 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Misc refactoring of check_file_extent 
Date: Thu, 13 Sep 2018 15:05:04 +0300
Message-Id: <20180913120507.18197-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While looking at check_file_extent I thought that the code might be a bit 
cleaner than it actually is and cleaner as well. The first patch factors out 
the code dealing with inline extents into a separate function aptly named 
check_file_extent_inline. This allows to remove some inline-specific variable 
from check_file_extent. Patch 2 just moves the final check in the new function 
into the already existing branch handling the !compressed case. Finally 
the check which detects unknown extent types is moved first in check_file_extent, 
followed by the code to handle inline extents and finally the existing code to 
handle regular/prealloc extents is left intact. 

This patchset brings no functional changes. 

Nikolay Borisov (3):
  btrfs-progs: check: lowmem: Factor out inline extent checking code in
    its own function
  btrfs-progs: check: lowmem: Refactor extent len test in
    check_file_extent_inline
  btrfs-progs: check: lowmem: Refactor extent type checks in
    check_file_extent

 check/mode-lowmem.c | 151 ++++++++++++++++++++++++++------------------
 1 file changed, 89 insertions(+), 62 deletions(-)

-- 
2.17.1
