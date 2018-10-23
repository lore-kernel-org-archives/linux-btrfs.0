Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F93C46475
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D19D20665
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D19D20665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbeJWR5N (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:57:13 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2023 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728020AbeJWR5M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 13:57:12 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46602824"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Oct 2018 17:34:36 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C1C584B710E7
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 17:34:34 +0800 (CST)
Received: from archlinux.g08.fujitsu.local (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Oct 2018 17:34:40 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 00/13] btrfs-progs: fixes of file extent in original and lowmem check
Date:   Tue, 23 Oct 2018 17:41:34 +0800
Message-ID: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: C1C584B710E7.A9AB0
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from my repo:
https://github.com/Damenly/btrfs-progs/tree/file_extent_fixes
which is based on kdave/devel whose HEAD is:
commit 4f20c27ab33aab3efffe13cdae1b8837c821d0d7 (kdave/devel)
Author: Nikolay Borisov <nborisov@suse.com>
Date:   Fri Jun 15 07:13:50 2018 +0000

    btrfs-progs: tests: test for FST corruption detection/repair

This set fixes bugs of checking unaligned disk_bytenr extent_data and
orphan extent. Lowmem part patches can be used in common, so I put
this two fixes together.

For unaligned disk_bytenr extent_data, now original and lowmem check
both delete the corrupted part and punch a hole.

For orphan extent, lowmem mode has no change here.
Original mode discards function of detect and repair orphan extents
according extent items. Because as corruptions the community reported,
extent tree is more problematic than fs trees.

patch[1-2] fix minor bugs in lowmem repair.
patch[3] fixes false alert about repaired extent item in lowmem mode.
patch[4] fixes annoying alerts about gap in file extent in lowmem mode.
patch[5,6,7] enable check and repair unaligned disk_bytenr file extent
	     in lowmem mode.
patch[8,9] revert support for orphan extent in original mode.
patch[10] fixes bug about finding right backrefs in original mode.
patch[11] adds support to detect and delete unaligned file extents
	       in original.
patch[12] adds a test image which lacks of a file extent.
patch[13] enables lowmem repair of test case fsck-tests/001 which has
	  	  unaligned disk_bytenr file extent.


Lu Fengqi (2):
  btrfs-progs: lowmem: fix false alert about the existence of gaps in
    the check_file_extent
  btrfs-progs: tests: add case for inode lose one file extent

Su Yanjun (4):
  btrfs-progs: Revert "btrfs-progs: Add repair and report function for
    orphan file extent."
  btrfs-progs: Revert "btrfs-progs: Record orphan data extent ref to
    corresponding root."
  btrfs-progs: check: fix bug in find_possible_backrefs
  btrfs-progs: check: Delete file extent item with unaligned extent
    backref

Su Yue (7):
  btrfs-progs: lowmem: add argument path to punch_extent_hole()
  btrfs-progs: lowmem: move nbytes check before isize check
  btrfs-progs: lowmem: fix false alert if extent item has been repaired
  btrfs-progs: lowmem: check unaligned disk_bytenr for extent_data
  btrfs-progs: lowmem: rename delete_extent_tree_item() to delete_item()
  btrfs-progs: lowmem: delete unaligned bytes extent data under repair
  btrfs-progs: fsck-test: enable lowmem repair for case 001

 check/main.c                                  | 581 +++++++++++-------
 check/mode-lowmem.c                           | 272 ++++----
 check/mode-original.h                         |  30 +-
 ctree.h                                       |  10 +-
 disk-io.c                                     |   2 +-
 .../.lowmem_repairable                        |   0
 .../.lowmem_repairable                        |   0
 .../default_case.img                          | Bin 0 -> 3072 bytes
 8 files changed, 538 insertions(+), 357 deletions(-)
 create mode 100644 tests/fsck-tests/001-bad-file-extent-bytenr/.lowmem_repairable
 create mode 100644 tests/fsck-tests/038-missing-one-file-extent/.lowmem_repairable
 create mode 100644 tests/fsck-tests/038-missing-one-file-extent/default_case.img

-- 
2.19.1



