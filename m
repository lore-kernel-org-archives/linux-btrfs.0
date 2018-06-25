Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52968 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751469AbeFYIYy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 04:24:54 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8DF5BAC56
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2018 08:24:53 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/2] Remove v0 extent support 
Date: Mon, 25 Jun 2018 11:24:48 +0300
Message-Id: <1529915090-11095-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's unlikely there is anyone using that or even if they are they have bigger 
problems than this patchset :). After all, v0 was introduced 9 years ago and 
it was already conditionally compiled by the time BTRFS was merged in the
upstream kernel. The patches themselves are really simple - patch 1 removes 
all the code within ifdef guards. Patch 2, in turn, ads graceful handling by 
aborting transaction where it makes sense or calling btrfs_handle_fs_error and 
printing an informative error message. 

Nikolay Borisov (2):
  btrfs: Remove V0 extent support
  btrfs: Add graceful handling of V0 extents

 fs/btrfs/ctree.c       |   6 +-
 fs/btrfs/ctree.h       |   2 -
 fs/btrfs/extent-tree.c | 239 +++++++------------------------------------------
 fs/btrfs/print-tree.c  |  35 ++------
 fs/btrfs/relocation.c  | 181 ++++++-------------------------------
 5 files changed, 70 insertions(+), 393 deletions(-)

-- 
2.7.4

