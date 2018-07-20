Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55968 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731251AbeGTPS5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 11:18:57 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D7D50ADFC
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 14:30:23 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] More structure shrinking and cleanups
Date: Fri, 20 Jul 2018 16:30:15 +0200
Message-Id: <cover.1532096607.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A few more structure member leftovers spotted, and some trivial cleanups.

David Sterba (4):
  btrfs: remove unused member btrfs_root::name
  btrfs: dev-replace: remove unused members of btrfs_dev_replace
  btrfs: constify strings passed to assertion helper
  btrfs: merge free_fs_root helpers

 fs/btrfs/ctree.h   |  5 +----
 fs/btrfs/disk-io.c | 20 +++++---------------
 2 files changed, 6 insertions(+), 19 deletions(-)

-- 
2.18.0

