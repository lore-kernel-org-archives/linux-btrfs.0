Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:56248 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751482AbeDFGMT (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 6 Apr 2018 02:12:19 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/1] btrfs-progs: dump-tree: allow -b multiple times
Date: Fri,  6 Apr 2018 14:12:01 +0800
Message-Id: <20180406061202.6529-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although just one patch, it needs the extent buffer cleanup code as
basis, so please fetch it from my github repo:
https://github.com/adam900710/btrfs-progs/tree/dump_tree_multi_blocks

This patch allow -b to be specified multiple times, and add extra basic
check for them.
For later enhancement (Issue: #113) it needs extra work to handle
special roots.

Qu Wenruo (1):
  btrfs-progs: inspect-dump-tree: Allow '-b|--block' to be specified
    multiple times

 Documentation/btrfs-inspect-internal.asciidoc |   2 +-
 cmds-inspect-dump-tree.c                      | 108 ++++++++++++++----
 2 files changed, 89 insertions(+), 21 deletions(-)

-- 
2.17.0

