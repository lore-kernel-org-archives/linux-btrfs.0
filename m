Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726B1C282D4
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 07:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 491A82087F
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 07:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbfA3HkF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 02:40:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:44152 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725819AbfA3HkF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 02:40:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F410BB013
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 07:40:03 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: Speedup chunk allocation for large fs
Date:   Wed, 30 Jan 2019 15:39:58 +0800
Message-Id: <20190130074000.16638-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/falloc_speedup

Which is based on v5.0-rc1 tag, with another enospc debug patch.

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

Qu Wenruo (2):
  btrfs: Don't search devid for every verify_one_dev_extent() call
  btrfs: Introduce free dev extent hint to speed up chunk allocation

 fs/btrfs/volumes.c | 49 ++++++++++++++++++++++++++++-----------
 fs/btrfs/volumes.h | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+), 13 deletions(-)

-- 
2.20.1

