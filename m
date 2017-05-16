Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43447 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751665AbdEPRSX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 13:18:23 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F3E82AB5F
        for <linux-btrfs@vger.kernel.org>; Tue, 16 May 2017 17:18:21 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/4] Btrfs, remove unused structure members
Date: Tue, 16 May 2017 19:17:25 +0200
Message-Id: <cover.1494954874.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With some help of coccinelle and coccigrep I found a few stucture members that
are completely unused, we can remove them and reduce structure sizes.

David Sterba (4):
  btrfs: remove unused member err from reada_extent
  btrfs: remove unused member list from async_submit_bio
  btrfs: remove unused members dir_path from recorded_ref
  btrfs: remove unused member list from btrfs_end_io_wq

 fs/btrfs/disk-io.c | 2 --
 fs/btrfs/reada.c   | 1 -
 fs/btrfs/send.c    | 8 --------
 3 files changed, 11 deletions(-)

-- 
2.12.0

