Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42627 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752393AbeEOHg0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 03:36:26 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9F45FAE04
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 07:36:25 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: Enhance btrfs handling compression and
Date: Tue, 15 May 2018 15:36:20 +0800
Message-Id: <20180515073622.18732-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

James Harvey reported one corruption where lzo compressed extent without
data csum is causing "decompress failed" kernel message, and then
serious random kernel memory corruption.

For the "decrompress failed" kernel message, it's indeed corrupted
compressed data.
However we can still harden btrfs lzo callers by do extra check on the
lzo compressed data before really decompress it.
It's done mostly based on the total length recorded in the first 4 bytes
of a compressed extent.

It should catch such corruption early.
However the random kernel memory corruption still can't be reproduced
even with the same binary dump.

On the other hand, even btrfs(5) only specifies that nodatacow or
nodatasum will disable compression, it should also work on the same
inode flags level.
For NODATACOW, it's working as epxected, but for NODATASUM alone, it's
not working properly, the 2nd patch will enhance such check so even for
NODATASUM inode, compressio will also be disabled.

Qu Wenruo (2):
  btrfs: inode: Don't compress if NODATASUM or NODATACOW set
  btrfs: lzo: Avoid decompressing obviously corrupted data

 fs/btrfs/compression.h | 1 +
 fs/btrfs/inode.c       | 8 ++++++++
 fs/btrfs/lzo.c         | 4 ++++
 3 files changed, 13 insertions(+)

-- 
2.17.0

