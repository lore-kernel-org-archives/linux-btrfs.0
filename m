Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA27C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C145216E3
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 02:04:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C145216E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbeI1I0K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 04:26:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:58250 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbeI1I0K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 04:26:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6C0D4ABB1
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 02:04:49 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/6] btrfs-progs: print-tree: Minor enhancement along with --bfs/--dfs options
Date:   Fri, 28 Sep 2018 10:04:40 +0800
Message-Id: <20180928020446.21467-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/dump_tree_enhance

The main point of this patchset is to allow "btrfs ins dump-tree" to
print tree blocks in breadth-first order when level is higher than 2.

The 1st patch is just a minor cleanup, to remove some unused and
meaningless output.

The 2nd patch does a root<->fs_info cleanup, provides the basis for
later btrfs_next_sibling_tree_block().

The 3rd patch implements a new function, btrfs_next_sibling_tree_block()
to find next sibling tree block, other than leaf.

The 4th patch implements BFS as bfs_print_children().

The BFS search itself is implemented using path along with
 path::lowest_level and btrfs_next_sibling_tree_block() to iterate all
sibling tree blocks in a level.

The 5th patch adds --bfs/--dfs options for dump-tree.

The final patch changes @follow type from int to bool.

Changelog:
v2:
  Make bfs/dfs selectable by adding --bfs and --dfs options.
  Still keep dfs as default (although I really don't see any
  compatibility problem)
  Add a new patch to change @follow type.

Qu Wenruo (6):
  btrfs-progs: print-tree: Skip deprecated blockptr / nodesize output
  btrfs-progs: Replace root parameter using fs_info for
    reada_for_search()
  btrfs-progs: Introduce function to find next sibling tree block
  btrfs-progs: print-tree: Introduce breadth-first search
  btrfs-progs: print-tree: Introduce --bfs and --dfs options
  btrfs-progs: print-tree: Use bool for @follow

 Documentation/btrfs-inspect-internal.asciidoc |   4 +
 cmds-inspect-dump-tree.c                      |  31 ++--
 cmds-restore.c                                |   4 +-
 ctree.c                                       |  25 +--
 ctree.h                                       |  19 ++-
 print-tree.c                                  | 146 ++++++++++++++----
 print-tree.h                                  |  14 +-
 7 files changed, 188 insertions(+), 55 deletions(-)

-- 
2.19.0

