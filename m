Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36758 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751311AbdGQSrQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 14:47:16 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 66AE7AAB6
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Jul 2017 18:47:15 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Compression
Date: Mon, 17 Jul 2017 20:46:01 +0200
Message-Id: <cover.1500317040.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An improved version of patch https://patchwork.kernel.org/patch/9838439/ after
Anand's comment that the change also affects properties, this time it addresses
the core problem first and then changes the defrag priority over nocompress.

David Sterba (4):
  btrfs: rename variable holding per-inode compression type
  btrfs: separate defrag and property compression
  btrfs: defrag: cleanup checking for compression status
  btrfs: allow defrag compress to override NOCOMPRESS attribute

 fs/btrfs/btrfs_inode.h |  9 +++++++--
 fs/btrfs/inode.c       | 16 +++++++++++-----
 fs/btrfs/ioctl.c       | 16 ++++++++--------
 fs/btrfs/props.c       |  6 +++---
 4 files changed, 29 insertions(+), 18 deletions(-)

-- 
2.13.0

