Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38357 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750758AbeFAFP3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Jun 2018 01:15:29 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 934B4ACD5
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Jun 2018 05:15:28 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH REBASED 0/1] btrfs-progs: dump-tree: allow -b multiple times
Date: Fri,  1 Jun 2018 13:15:25 +0800
Message-Id: <20180601051526.19564-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although just one patch, it needs the extent buffer cleanup code as
basis, so please fetch it from my github repo:
https://github.com/adam900710/btrfs-progs/tree/dump_tree_multi_blocks

It's based on David's devel branch, with HEAD as:
commit ffc7e4f730bd5ec49ba14ae3a13576311d57d4a6 (david/devel)
Author: Axel Burri <axel@tty0.ch>
Date:   Tue May 15 17:22:14 2018 +0200

    btrfs-progs: fix regression preventing send -p with subvolumes mounted on "/"


This patch allow -b to be specified multiple times, and add extra basic
check for them.
For later enhancement (Issue: #113) it needs extra work to handle
special roots.


Qu Wenruo (1):
  btrfs-progs: inspect-dump-tree: Allow '-b|--block' to be specified
    multiple times

 Documentation/btrfs-inspect-internal.asciidoc |   2 +-
 cmds-inspect-dump-tree.c                      | 109 +++++++++++++++---
 2 files changed, 91 insertions(+), 20 deletions(-)

-- 
2.17.1

