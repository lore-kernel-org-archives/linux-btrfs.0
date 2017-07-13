Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59591 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750947AbdGMIhs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 04:37:48 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D382DABDE
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 08:37:46 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Cleanup volume.c of unused parameters/variables
Date: Thu, 13 Jul 2017 11:37:40 +0300
Message-Id: <1499935063-24401-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here are 3 cleanup patches which remove unused variables, parameters and 
kill a dummy function. 

Nikolay Borisov (3):
  btrfs: Remove unused variables
  btrfs: Remove unused parameters from volume.c functions
  btrfs: Remove find_raid56_stripe_len

 fs/btrfs/extent-tree.c |  6 ++----
 fs/btrfs/extent_io.c   |  2 +-
 fs/btrfs/volumes.c     | 44 ++++++++++----------------------------------
 fs/btrfs/volumes.h     |  3 +--
 4 files changed, 14 insertions(+), 41 deletions(-)

-- 
2.7.4

