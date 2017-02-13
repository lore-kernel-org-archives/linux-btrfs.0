Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40371 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750853AbdBMOaj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 09:30:39 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 51D67AD45
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 14:30:37 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/7] Qgroup cleanups
Date: Mon, 13 Feb 2017 15:30:07 +0100
Message-Id: <cover.1486995885.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've spotted some cleanup-ready code while going through the file, so here it
is. There are no changes to the core qgoups code, just the support and
framework code. For 4.11.

David Sterba (7):
      btrfs: qgroups: make __del_qgroup_relation static
      btrfs: ulist: make the finalization function public
      btrfs: embed extent_changeset::range_changed to the structure
      btrfs: check quota status earlier and don't do unnecessary frees
      btrfs: remove unnecessary mutex lock in qgroup_account_snapshot
      btrfs: qgroups: opencode qgroup_free helper
      btrfs: remove pointless rcu protection from btrfs_qgroup_inherit

 fs/btrfs/extent_io.c   |  2 +-
 fs/btrfs/extent_io.h   |  2 +-
 fs/btrfs/qgroup.c      | 51 ++++++++++++++++++++++----------------------------
 fs/btrfs/transaction.c |  6 +-----
 fs/btrfs/ulist.c       |  2 +-
 fs/btrfs/ulist.h       |  1 +
 6 files changed, 27 insertions(+), 37 deletions(-)
