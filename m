Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9F2C00449
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 10:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DA0520841
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 10:44:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DA0520841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbeJHRzr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 13:55:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:40882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726330AbeJHRzr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 13:55:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00971AF3C
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Oct 2018 10:44:41 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/5] btrfs-progs: check: Detect invalid dev extents and device items
Date:   Mon,  8 Oct 2018 18:44:31 +0800
Message-Id: <20181008104436.19267-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetch from github:
https://github.com/adam900710/btrfs-progs/tree/dev_extents_check

Hans van Kranenburg reported a case where btrfs DUP chunk allocator
could allocate invalid dev extents, either overlaps with existing dev
extents or beyond device boundary.

This patchset enhances the btrfs-progs side to detect such problems.
With hand crafted test image for it.

Link: https://www.spinics.net/lists/linux-btrfs/msg82370.html

Changelog:
v2:
  Fix a bug in the 1st patch which makes lowmem mode never checks
  overlap dev extents.
  Fix test case bug which never passes due to wrong script.

Qu Wenruo (5):
  btrfs-progs: lowmem check: Add check for overlapping dev extents
  btrfs-progs: original check: Add ability to detect bad dev extents
  btrfs-progs: lowmem check: Add dev_item check for used bytes and total
    bytes
  btrfs-progs: original check: Add dev_item check for used bytes and
    total bytes
  btrfs-progs: fsck-tests: Add test image for dev extents beyond device
    boundary

 check/main.c                                  | 105 ++++++++++++++++++
 check/mode-lowmem.c                           |  39 ++++++-
 .../over_dev_boundary.img.xz                  | Bin 0 -> 1640 bytes
 tests/fsck-tests/036-bad-dev-extents/test.sh  |  20 ++++
 4 files changed, 162 insertions(+), 2 deletions(-)
 create mode 100644 tests/fsck-tests/036-bad-dev-extents/over_dev_boundary.img.xz
 create mode 100755 tests/fsck-tests/036-bad-dev-extents/test.sh

-- 
2.19.1

