Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34997 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753225AbeB0OvJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 09:51:09 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 51EABACED
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 14:51:08 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Minor xattr handler cleanups
Date: Tue, 27 Feb 2018 15:48:50 +0100
Message-Id: <cover.1519742886.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Renames, declearation updates.

David Sterba (4):
  btrfs: drop underscores from exported xattr functions
  btrfs: drop extern from function declarations
  btrfs: adjust return type of btrfs_getxattr
  btrfs: move btrfs_listxattr prototype to xattr.h

 fs/btrfs/acl.c       |  6 +++---
 fs/btrfs/ctree.h     |  3 ---
 fs/btrfs/extent_io.h |  4 ++--
 fs/btrfs/props.c     |  6 +++---
 fs/btrfs/xattr.c     | 12 ++++++------
 fs/btrfs/xattr.h     |  7 ++++---
 6 files changed, 18 insertions(+), 20 deletions(-)

-- 
2.16.2

