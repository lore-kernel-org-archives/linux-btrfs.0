Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56795 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932551AbeDWXGO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 19:06:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C7C0FAC92
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 23:06:13 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/3] Simplify counting of extent buffer pages
Date: Tue, 24 Apr 2018 01:03:40 +0200
Message-Id: <cover.1524523681.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some low-hanging cleanup fruit. The argument bloat-o-meter shows some
improvements:

extent_io.c:cache_state_if_flags.part.27       -8 (8 -> 0)
extent_io.c:cache_state.part.28                -8 (8 -> 0)
extent_io.c:check_buffer_tree_ref.part.31     -24 (24 -> 0)
extent_io.c:mark_extent_buffer_accessed        -8 (40 -> 32)
extent_io.c:alloc_extent_state_atomic.part.35  -8 (8 -> 0)
extent_io.c:flush_write_bio.isra.40           -16 (16 -> 0)
extent_io.c:set_page_extent_mapped.part.49     -8 (8 -> 0)
extent_io.c:extent_buffer_under_io.part.50     -8 (8 -> 0)
extent_io.c:__unlock_for_delalloc.isra.38      -8 (8 -> 0)
extent_io.c:merge_state.part.45               -48 (48 -> 0)
extent_io.c:repair_eb_io_failure               -8 (72 -> 64)
extent_io.c:set_extent_buffer_dirty            -8 (40 -> 32)
extent_io.c:__alloc_dummy_extent_buffer        +8 (32 -> 40)
extent_io.c:write_one_eb                      +16 (152 -> 168)

David Sterba (3):
  btrfs: simplify counting number of eb pages
  btrfs: pass only eb to num_extent_pages
  btrfs: switch types to int when counting eb pages

 fs/btrfs/extent_io.c | 68 ++++++++++++++++++++++++++--------------------------
 fs/btrfs/extent_io.h |  5 ++--
 2 files changed, 36 insertions(+), 37 deletions(-)

-- 
2.16.2

