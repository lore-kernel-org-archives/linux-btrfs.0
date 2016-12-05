Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48545 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751993AbcLEJMW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 04:12:22 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/4] Lowmem fsck false alert fixes
Date: Mon,  5 Dec 2016 17:07:52 +0800
Message-Id: <20161205090756.7960-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs-progs test case 023 will cause assert and a lot of false alerts
for lowmem mode.

The problems are caused by several reasons, from bad handler for tree
reloc root(calling btrfs_read_fs_root on tree reloc tree) to too
restrict check.

Fix the lowmem mode bugs.

There is another bug which affects both original mode and lowmem mode,
it seems to be caused by this commit:
commit 00e769d04c2c83029d6c71fbded133597d93ad55
Author: Goldwyn Rodrigues <rgoldwyn@suse.com>
Date:   Tue Nov 29 10:24:52 2016 -0600

    btrfs-progs: Correct value printed by assertions/BUG_ON/WARN_ON

Informed Goldwyn to fix it.
So the fix for the common assert is not included in this patchset.

Qu Wenruo (4):
  btrfs-progs: check: Fix assert when using lowmem on fs with tree reloc
    tree
  btrfs-progs: check: Fix lowmem mode stack overflow caused by fsck/023
  btrfs-progs: check: Fix lowmem false alert on tree reloc tree
  btrfs-progs: check: Fix false alert on generation mismatch for tree
    reloc tree

 cmds-check.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 56 insertions(+), 15 deletions(-)

-- 
2.10.2



