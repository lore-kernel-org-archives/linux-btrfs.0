Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726799AbeHCHpF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 03:45:05 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 232C5AF76
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 05:50:26 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] btrfs-progs: Variant fixes for fuzz-tests
Date: Fri,  3 Aug 2018 13:50:16 +0800
Message-Id: <20180803055022.9816-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/fixes_for_fuzz_test

The base HEAD is:
commit d7a1b84756157d544a9ddc399ef48c6132eaafcf (david/devel)
Author: Qu Wenruo <wqu@suse.com>
Date:   Thu Jul 5 15:37:31 2018 +0800

    btrfs-progs: check/original: Don't overwrite return value when we failed to repair


Thanks for the already merged fixes for fuzz/003, the remaining part is
pretty small now, +20/-7.

Mostly of the fixes are for fuzz/003, just a small bunch of BUG_ON()
removal. (Patch 1~3 and 5)

There is also a fix for fuzz/003 dead loop. (Patch 4)

Finally we have a fix for fuzz/007, the bug is a segfault triggered by
accessing poisoned list_head, caused by double list freeing. (Patch 6)

Now fuzz-test should finally work without problem.

Qu Wenruo (6):
  btrfs-progs: Exit gracefully if we hit ENOSPC when allocating tree
    block
  btrfs-progs: Exit gracefully when failed to repair root dir item
  btrfs-progs: Don't report dirty leaked eb using BUG_ON
  btrfs-progs: Fix infinite loop when failed to repair bad key order
  btrfs-progs: Exit gracefull when we failed to alloc dev extent
  btrfs-progs: rescue-super: Don't double free fs_devices

 check/main.c    | 10 +++++++++-
 extent-tree.c   |  5 ++++-
 extent_io.c     |  6 +++++-
 super-recover.c |  3 ---
 volumes.c       |  3 ++-
 5 files changed, 20 insertions(+), 7 deletions(-)

-- 
2.18.0

