Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:43275 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbeCLHPm (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 12 Mar 2018 03:15:42 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/3] btrfs-progs: Split mode-original code
Date: Mon, 12 Mar 2018 15:15:27 +0800
Message-Id: <20180312071530.8723-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/split_check_for_david

This is the remaining part of the check code split.
After the code split, the old cmds-check.c will return to make every
subcommand have its own cmds-*.c.
And there will be check/mode-original.[ch] and check/mode-lowmem.[ch] to
indicates the supported check mode.

As usual, some patch would be quite big so it won't reach mail list.
Please check github for full change.

Qu Wenruo (3):
  btrfs-progs: check: Move more shared codes to mode-common.c
  btrfs-progs: Move the remaining original mode code to mode-original.c
  btrfs-progs: Move check/main.c to cmds-check.c to maintain the
    subcommand hierarchy

 Makefile                          |    7 +-
 btrfsck.h                         |    1 -
 check/mode-common.c               | 1724 +++++++++
 check/mode-common.h               |   38 +
 check/{main.c => mode-original.c} | 6906 ++++++++++++-------------------------
 check/mode-original.h             |   32 +-
 cmds-check.c                      |  661 ++++
 7 files changed, 4724 insertions(+), 4645 deletions(-)
 rename check/{main.c => mode-original.c} (76%)
 create mode 100644 cmds-check.c

-- 
2.16.2

