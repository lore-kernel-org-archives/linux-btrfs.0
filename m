Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56431 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752086AbdK3QK4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 11:10:56 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 025C3AE74
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 16:10:55 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Minor compression cleanups
Date: Thu, 30 Nov 2017 17:08:57 +0100
Message-Id: <cover.1512058075.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Factor opencoded switches for compression algos to helpers.

David Sterba (4):
  btrfs: compression: add helper for type to string conversion
  btrfs: SETFLAGS ioctl: use helper for compression type conversion
  btrfs: prop: use common helper for type to string conversion
  btrfs: show options: use helper to convert compression type string

 fs/btrfs/compression.c | 15 +++++++++++++++
 fs/btrfs/compression.h |  2 ++
 fs/btrfs/ioctl.c       | 10 ++++------
 fs/btrfs/props.c       |  6 +++---
 fs/btrfs/super.c       |  9 ++-------
 5 files changed, 26 insertions(+), 16 deletions(-)

-- 
2.15.0

