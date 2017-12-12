Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34041 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752452AbdLLVDw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 16:03:52 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 84D53ADBF
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 21:03:51 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] More unnecessary argument cleanups
Date: Tue, 12 Dec 2017 22:01:51 +0100
Message-Id: <cover.1513112255.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Another step peeling off the unnecessary arguments, this time the
unlock_extent*.

David Sterba (2):
  btrfs: add separate helper for unlock_extent_cached with GFP_ATOMIC
  btrfs: sink unlock_extent parameter gfp_flags

 fs/btrfs/disk-io.c          |  2 +-
 fs/btrfs/extent_io.c        | 12 +++++-------
 fs/btrfs/extent_io.h        | 11 +++++++++--
 fs/btrfs/file.c             | 15 +++++++--------
 fs/btrfs/free-space-cache.c |  5 ++---
 fs/btrfs/inode.c            | 26 ++++++++++++--------------
 fs/btrfs/ioctl.c            |  7 +++----
 fs/btrfs/scrub.c            |  3 +--
 8 files changed, 40 insertions(+), 41 deletions(-)

-- 
2.15.1

