Return-Path: <SRS0=H1hn=QQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC56FC282C4
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 05:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE21520869
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 05:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfBIFYm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Feb 2019 00:24:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:60230 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725919AbfBIFYl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Feb 2019 00:24:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BA4A3AF5B
        for <linux-btrfs@vger.kernel.org>; Sat,  9 Feb 2019 05:24:40 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: Speedup chunk allocation for large fs
Date:   Sat,  9 Feb 2019 13:24:35 +0800
Message-Id: <20190209052437.24020-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/falloc_speedup

Which is based on misc-next branch, with the following commit as base:
commit eb3e579e28f1c58e79176fbf5afe1cf3ee227190
Author: Anand Jain <anand.jain@oracle.com>
Date:   Fri Feb 8 15:39:37 2019 +0800

    btrfs: fix comment its device list mutex not volume lock

Btrfs falloc can be slower and slower when there are more and more block
groups.

One cause of this problem is find_free_dev_extent(), as it always search
from device offset 0, and if there are thousands existing dev extents
btrfs will search leaf by leaf until it reaches a free slot.

This is super slow and inefficient.

This patchset will introduce a new member,
btrfs_device::hint_free_dev_extent to give some hint for
find_free_dev_extent().

The full cause analyse and benchmark can be found in the 2nd patch.

Changelog:
v2:
- Fix the false ENOSPC __btrfs_alloc_chunk() return caused by unhandled
  search_hint value
- Rebase to misc-next to co-operate with seed device related code
- Add reviewed-by tags for the first patch

Qu Wenruo (2):
  btrfs: Don't search devid for every verify_one_dev_extent() call
  btrfs: Introduce free dev extent hint to speed up chunk allocation

 fs/btrfs/volumes.c | 58 ++++++++++++++++++++++++++++++++++------------
 fs/btrfs/volumes.h | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+), 15 deletions(-)

-- 
2.20.1

