Return-Path: <SRS0=cRuQ=W6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 914DCC3A5A2
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 08:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66F172053B
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 08:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfICIYN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 04:24:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:53106 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726452AbfICIYN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Sep 2019 04:24:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6DB61AE07
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Sep 2019 08:24:12 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs-progs: check: Repair invalid inode mode in subvolume trees
Date:   Tue,  3 Sep 2019 16:24:03 +0800
Message-Id: <20190903082407.13927-1-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Before this patch, btrfs check can only repair bad free space cache
inode mode (as it was the first case detected by tree-checker and reported)

But now what may happen finally happened, we have user reorting bad
inode mode in subvolumes trees.

Although the reported get the fs fixed by removing the offending old
files, it's still a bad thing that "btrfs check" can't fix it.

This patch will bring the repair functionality to all inodes, along with
needed test image.

Qu Wenruo (4):
  btrfs-progs: check/common: Make repair_imode_common() to handle inodes
    in subvolume trees
  btrfs-progs: check/lowmem: Repair bad imode early
  btrfs-progs: check/original: Fix inode mode in subvolume trees
  btrfs-progs: tests/fsck: Add new images for inode mode repair
    functionality

 check/main.c                                  |  32 ++++--
 check/mode-common.c                           |  96 +++++++++++++++---
 check/mode-common.h                           |   2 +
 check/mode-lowmem.c                           |  39 +++++++
 .../039-bad-inode-mode/.lowmem_repairable     |   0
 .../bad_free_space_cache_imode.raw.xz}        | Bin
 .../bad_regular_file_imode.img.xz             | Bin 0 -> 2060 bytes
 7 files changed, 147 insertions(+), 22 deletions(-)
 create mode 100644 tests/fsck-tests/039-bad-inode-mode/.lowmem_repairable
 rename tests/fsck-tests/{039-bad-free-space-cache-inode-mode/test.raw.xz => 039-bad-inode-mode/bad_free_space_cache_imode.raw.xz} (100%)
 create mode 100644 tests/fsck-tests/039-bad-inode-mode/bad_regular_file_imode.img.xz

-- 
2.23.0

