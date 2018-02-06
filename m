Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:37364 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbeBFHCm (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 6 Feb 2018 02:02:42 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 0/3] btrfs-progs: Split original mode check to its own
Date: Tue,  6 Feb 2018 15:02:20 +0800
Message-Id: <20180206070223.28791-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This time, there are 2 patches too large to reach mail list, so please
fetch the whole patchset from github as usual:
https://github.com/adam900710/btrfs-progs/tree/split_check_part2

The branch is based on devel branch, whose HEAD is:
commit 3aa1bbdd89ee9c9c48d260a6192fae08328f1b2f (david/devel)
Author: David Sterba <dsterba@suse.com>
Date:   Sat Feb 3 01:15:42 2018 +0100

    btrfs-progs: mkfs: fix build on musl
    
    Another build failure on musl.
    
    Issue: #90
    Signed-off-by: David Sterba <dsterba@suse.com>


The first patch moves remaining common code to mode-common.c.
Things like transid fix, which is handled in read_tree_block(), get
moved to mode-common.c.
And commented added for exported functions.

The 2nd patch moves the original mode code to mode-original.c.
Unlike lowmem mode, original mode has more functions exported, as things
like bad items repair is integrated into the main funtion.

The last patch moves check/main.c back to cmds-check.c to keep
subcommand hierarchy.

With the split done, we now have a clear view about the check code size:
$ wc -l check/*.[ch] cmds-check.c | sort -h
    67 check/mode-lowmem.h
   137 check/mode-common.h
   308 check/mode-original.h
   661 cmds-check.c
  2062 check/mode-common.c
  4573 check/mode-lowmem.c
  7577 check/mode-original.c

Qu Wenruo (3):
  btrfs-progs: check: Move more shared codes to mode-common.c
  btrfs-progs: Move the remaining original mode code to mode-original.c
  btrfs-progs: Move check/main.c to cmds-check.c to maintain the
    subcommand hierarchy

 Makefile                          |    7 +-
 check/mode-common.c               | 1711 +++++++++
 check/mode-common.h               |   39 +-
 check/{main.c => mode-original.c} | 6954 ++++++++++++-------------------------
 check/mode-original.h             |   32 +-
 cmds-check.c                      |  661 ++++
 6 files changed, 4742 insertions(+), 4662 deletions(-)
 rename check/{main.c => mode-original.c} (76%)
 create mode 100644 cmds-check.c

-- 
2.16.1

