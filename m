Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D600EC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF85B217D8
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 10:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbeLRKqw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 05:46:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:38498 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726364AbeLRKqw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 05:46:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 46F15AD82
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2018 10:46:50 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 00/13] btrfs-progs: check: Fix
Date:   Tue, 18 Dec 2018 18:46:33 +0800
Message-Id: <20181218104646.29599-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/file_extents_fixes

The base commit is devel branch:
commit e1e7519c2d225554004b55a5c19eb196db92285a (david/devel)
Author: Qu Wenruo <wqu@suse.com>
Date:   Thu Oct 25 15:35:47 2018 +0800

    btrfs-progs: tests: check: Make 026-bad-dir-item-name verify if btrfs-check can also repair
    
    Just remove the customized 'test.sh', then generic fsck test will do the
    check-repair-check.

Originally for fsck-tests/001-bad-file-extent-bytenr we're going to fix
it by resetting the corrupted file extent, using the disk bytenr from
data backref.

However in real world, extent tree is the most fragile one while fs tree
is more reliable.
This means fixing using extent tree can sometimes be more dangerous, and
causing extra corruption from repair.

Further more, that test case is a big blockage for any later
modification on file extent repair code.

So the goal of this patchset is to change the repair behavior from
rebuilding file extents using data backref, to dropping invalid file
extents and modify extent tree.

Despite above change, we have some small bug fixes for:
- False alert for file extents gap
- Bad data backref -> file extent search in repair mode

The patchset is mostly from Fujitsu guys (Lu, Su Yue, Su Yanjun).
My work here is:
- Solve rebase conflicts
  Mostly with DIR_ITEM hash mismatch patchset

- Commit message/comment update
  Make them a little more reader friendly

- Reorder the patchset
  Make small fixes first.

Lu Fengqi (2):
  btrfs-progs: lowmem: fix false alert about the existence of gaps in
    the check_file_extent
  btrfs-progs: tests: add case for inode lose one file extent

Su Yanjun (4):
  btrfs-progs: Revert "btrfs-progs: Add repair and report function for
    orphan file extent."
  btrfs-progs: Revert "btrfs-progs: Record orphan data extent ref to
    corresponding root."
  btrfs-progs: check: fix wrong @offset used in find_possible_backrefs()
  btrfs-progs: check: Delete file extent item with unaligned disk bytenr

Su Yue (7):
  btrfs-progs: lowmem: add argument path to punch_extent_hole()
  btrfs-progs: lowmem: move nbytes check before isize check
  btrfs-progs: lowmem: fix false alert if extent item has been repaired
  btrfs-progs: lowmem: check unaligned disk_bytenr for extent_data
  btrfs-progs: lowmem: rename delete_extent_tree_item() to delete_item()
  btrfs-progs: lowmem: delete unaligned bytes extent data under repair
  btrfs-progs: fsck-test: enable lowmem repair for case 001

 check/main.c                                  | 584 +++++++++++-------
 check/mode-lowmem.c                           | 293 +++++----
 check/mode-original.h                         |  30 +-
 ctree.h                                       |  10 +-
 disk-io.c                                     |   2 +-
 .../.lowmem_repairable                        |   0
 .../.lowmem_repairable                        |   0
 .../default_case.img                          | Bin 0 -> 3072 bytes
 8 files changed, 543 insertions(+), 376 deletions(-)
 create mode 100644 tests/fsck-tests/001-bad-file-extent-bytenr/.lowmem_repairable
 create mode 100644 tests/fsck-tests/038-missing-one-file-extent/.lowmem_repairable
 create mode 100644 tests/fsck-tests/038-missing-one-file-extent/default_case.img

-- 
2.20.0

