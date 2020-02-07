Return-Path: <SRS0=EUcM=33=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE66FC35247
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 01:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8871021775
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 01:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgBGB7t (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 20:59:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:35016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727799AbgBGB7s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Feb 2020 20:59:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 48450AD7B;
        Fri,  7 Feb 2020 01:59:47 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] fstests: btrfs/022 fixes
Date:   Fri,  7 Feb 2020 09:59:39 +0800
Message-Id: <20200207015942.9079-1-wqu@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since now fsstress can create new subvolumes, it causes new problem for
btrfs/022.

First two patches will fix the problem by:
- Enhance _btrfs_get_subvolid()
  So it can catch correct subvolid

- Use proper qgroupid for grep
  This solves the random failure even after _btrfs_get_subvolid
  enhancement.

The last patch will add extra debug output for btrfs/022 to make our
lives easier.

Qu Wenruo (3):
  fstests: btrfs: Use word mathcing for _btrfs_get_subvolid()
  fstests: btrfs/022: Match qgroup id more correctly
  fstests: btrfs/022: Add debug output

 common/btrfs    |  2 +-
 tests/btrfs/022 | 19 +++++++++++++------
 2 files changed, 14 insertions(+), 7 deletions(-)

-- 
2.23.0

