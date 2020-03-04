Return-Path: <SRS0=Ri2p=4V=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA798C3F2D1
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6AD5214D8
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgCDH1J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 02:27:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:34092 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbgCDH1J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Mar 2020 02:27:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4E4F3AD78
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Mar 2020 07:27:07 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: check: Detect overlapping csum item
Date:   Wed,  4 Mar 2020 15:26:59 +0800
Message-Id: <20200304072701.38403-1-wqu@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is one report about tree-checker rejecting overlapping csum item.

I haven't yet seen another report, thus the problem doesn't look
widespread, thus maybe some regression in older kernels.

At least let btrfs check to detect such problem.
If we had another report, I'll spending extra time for the repair
functionality (it's not that simple, as it involves a lot of csum item
operation, and unexpected overlapping range).

Qu Wenruo (2):
  btrfs-progs: check: Detect overlap csum items
  btrfs-progs: fsck-tests: Add test image for overlapping csum item

 check/main.c                                  |   9 +++++++++
 .../overlap_csum_item.img.xz                  | Bin 0 -> 2172 bytes
 .../fsck-tests/045-overlap-csum-item/test.sh  |  19 ++++++++++++++++++
 3 files changed, 28 insertions(+)
 create mode 100644 tests/fsck-tests/045-overlap-csum-item/overlap_csum_item.img.xz
 create mode 100755 tests/fsck-tests/045-overlap-csum-item/test.sh

-- 
2.25.1

