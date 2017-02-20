Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45178 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750920AbdBTSby (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 13:31:54 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0105FAAB2
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 18:31:53 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Cleanups in extent_io callbacks
Date: Mon, 20 Feb 2017 19:31:21 +0100
Message-Id: <cover.1487615195.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some of the checks for extent_io callbacks can be safely dropped as they're
always defined, plus some dummy callback additions so more checks can be
dropped. There's more potential for the same cleanup in other callbacks but
this would need more evaluation wheather dummy callbacks vs existence checks
are really worth it.

David Sterba (4):
      btrfs: let writepage_end_io_hook return void
      btrfs: document existence of extent_io ops callbacks
      btrfs: drop checks for mandatory extent_io_ops callbacks
      btrfs: add dummy callback for readpage_io_failed and drop checks

 fs/btrfs/disk-io.c   |  7 +++++--
 fs/btrfs/extent_io.c | 18 +++++++-----------
 fs/btrfs/extent_io.h | 25 +++++++++++++++++--------
 fs/btrfs/inode.c     | 20 ++++++++++++++------
 4 files changed, 43 insertions(+), 27 deletions(-)
