Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39395 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934600AbdBQQ2J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 11:28:09 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 782E3AB9A
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 16:28:07 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Const char cleanups
Date: Fri, 17 Feb 2017 17:27:37 +0100
Message-Id: <cover.1487348702.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A handful of char -> const char changes spotted during other cleanups.

David Sterba (4):
      btrfs: constify device path passed to relevant helpers
      btrfs: constify input buffer of btrfs_csum_data
      btrfs: constify buffers used by compression helpers
      btrfs: constify name of subvolume in creation helpers

 fs/btrfs/compression.c |  2 +-
 fs/btrfs/compression.h |  2 +-
 fs/btrfs/dev-replace.c |  5 +++--
 fs/btrfs/dev-replace.h |  5 +++--
 fs/btrfs/disk-io.c     |  4 ++--
 fs/btrfs/disk-io.h     |  2 +-
 fs/btrfs/ioctl.c       |  6 +++---
 fs/btrfs/lzo.c         |  2 +-
 fs/btrfs/volumes.c     | 18 ++++++++++--------
 fs/btrfs/volumes.h     | 12 ++++++------
 10 files changed, 31 insertions(+), 27 deletions(-)
