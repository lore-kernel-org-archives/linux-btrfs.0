Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8382EC46475
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 07:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 392E92054F
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 07:44:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 392E92054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbeJYQQ1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 12:16:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:58206 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726465AbeJYQQ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 12:16:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3D603AE02
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 07:44:53 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs-progs: check: Add repair support for mismatch dir item hash
Date:   Thu, 25 Oct 2018 15:44:45 +0800
Message-Id: <20181025074449.32469-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/repair_bad_dir_item_hash

This is still based on the latest stable v4.17.1 branch (which is already a
little old now)

We have report from suse bugzilla where user report latest kernel refuse
to mount the fs.

The problem turns out to be that some old kernel (around Jan 2017) has a
bug that could leads to corrupted dir item with mismatch hash.

This patchset will allow btrfs check --repair to repair such problem.

Qu Wenruo (4):
  btrfs-progs: lowmem check: Add ability to repair dir item with
    mismatch hash
  btrfs-progs: original check: Use mismatch_dir_hash_record to record
    bad dir items
  btrfs-progs: original check: Add ability to repair dir item with
    invalid hash
  btrfs-progs: fsck-tests: Make 026-bad-dir-item-name test case to
    verify if btrfs-check can also repair it

 check/main.c                                  | 121 +++++++++++++++++-
 check/mode-common.c                           |  51 ++++++++
 check/mode-common.h                           |   5 +-
 check/mode-lowmem.c                           |  46 ++++++-
 check/mode-lowmem.h                           |   1 +
 check/mode-original.h                         |  14 ++
 ctree.h                                       |   3 +
 dir-item.c                                    |   6 +-
 .../026-bad-dir-item-name/description.txt     |  41 ++++++
 .../fsck-tests/026-bad-dir-item-name/test.sh  |  13 --
 10 files changed, 272 insertions(+), 29 deletions(-)
 create mode 100644 tests/fsck-tests/026-bad-dir-item-name/description.txt
 delete mode 100755 tests/fsck-tests/026-bad-dir-item-name/test.sh

-- 
2.19.1

