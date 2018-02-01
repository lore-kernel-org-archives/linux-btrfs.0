Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:43106 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbeBAGpw (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 1 Feb 2018 01:45:52 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v2 0/3] btrfs-progs: Split lowmem mode check to its own
Date: Thu,  1 Feb 2018 14:45:38 +0800
Message-Id: <20180201064541.14603-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As usual, the main part is over 500K so the biggest patch won't reach
mail list.
Please fetch the whole branch from github:
https://github.com/adam900710/btrfs-progs/tree/split_check

This update rebased (the truth is, it's re-created other than rebase)
the branch to David's devel branch, whose head is:

commit cfe255515ae0a27fdd8e612a884b94ffb703acdf (david/devel)
Author: Qu Wenruo <wqu@suse.com>
Date:   Thu Jan 18 16:38:23 2018 +0800

    btrfs-progs: check: Move reset_cached_block_groups to check/common.c
    
    Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
    Signed-off-by: Qu Wenruo <wqu@suse.com>


Despite the update, a new patch is introduced, to address the tons of
BORING errors and warning from checkpatch.pl.

Qu Wenruo (3):
  btrfs-progs: check: Move lowmem check code to its own
    check/lowmem.[ch]
  btrfs-progs: check/lowmem: Cleanup unnecessary _v2 suffix
  btrfs-progs: check: Cleanup all checkpatch error and warning

 Makefile       |     2 +-
 check/lowmem.c |  4579 ++++++++++++++++++++
 check/lowmem.h |     5 +
 check/main.c   | 12772 ++++++++++++++++++-------------------------------------
 4 files changed, 8694 insertions(+), 8664 deletions(-)
 create mode 100644 check/lowmem.c

-- 
2.16.1

