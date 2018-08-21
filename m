Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55894 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726627AbeHUME5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 08:04:57 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0742B062
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 08:44:31 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/4] btrfs: Refactor find_free_extent()
Date: Tue, 21 Aug 2018 16:44:22 +0800
Message-Id: <20180821084426.7858-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can be fetched from github:
https://github.com/adam900710/linux/tree/refactor_find_free_extent

Which is based on v4.18-rc5, with one extra cleanup commit b0f2261e077b
("btrfs: extent-tree: Remove dead alignment check").

extent-tree.c::find_free_extent() could be one of the most
ill-structured functions, it has at least 6 non-exit tags and jumps
between them.

Refactor it into 4 parts:

1) find_free_extent()
   The main entrance, does the main work of block group iteration and
   block group selection.
   Now this function doesn't care nor handles free extent search by
   itself.

2) find_free_extent_clustered()
   Do clustered free extent search.
   May try to build/re-fill cluster.

3) find_free_extent_unclustered()
   Do unclustered free extent search.
   May try to fill free space cache.

4) find_free_extent_update_loop()
   Do the loop based black magic.
   May allocate new chunk.

With this patch, at least we should make find_free_extent() a little
easier to read, and provides the basis for later work on this function.

Current refactor is trying not to touch the original functionality, thus
the helper structure find_free_extent_ctrl still contains a lot of
unrelated members.
But it should not change how find_free_extent() works at all.

changelog:
v2:
  Split into 4 patches.
  Minor comment newline change.

Qu Wenruo (4):
  btrfs: Introduce find_free_extent_ctrl structure for later rework
  btrfs: Refactor clustered extent allocation into
    find_free_extent_clustered()
  btrfs: Refactor unclustered extent allocation into
    find_free_extent_unclustered()
  btrfs: Refactor find_free_extent() loops update into
    find_free_extent_update_loop()

 fs/btrfs/extent-tree.c | 695 +++++++++++++++++++++++------------------
 1 file changed, 397 insertions(+), 298 deletions(-)

-- 
2.18.0
