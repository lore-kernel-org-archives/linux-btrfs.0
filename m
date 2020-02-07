Return-Path: <SRS0=EUcM=33=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9203C2D0B1
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 05:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B3CA222C2
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 05:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgBGFi1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Feb 2020 00:38:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:34690 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgBGFi1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Feb 2020 00:38:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BD0F5AB95
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Feb 2020 05:38:25 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: qgroup: Fix deadlock where btrfs_qgroup_wait_for_completion() waits for never-queued work
Date:   Fri,  7 Feb 2020 13:38:19 +0800
Message-Id: <20200207053821.25643-1-wqu@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is a long existing report about btrfs hangs at unmount time,
waiting for qgroup.

Jeff has submitted a patch for that, but never merged.
https://patchwork.kernel.org/patch/10376585/

After re-digging the case, although Jeff's fix can solve the problem,
the racy cause doesn't look correct to me.

After all, close_ctree() wait for qgroup rescan before destroying
related work queues. Thus as long as the work is queued, we can finish
the wait without problem.

Further digging into the bug, it looks like the deadlock is possible,
and Jeff is right about the wait-for-never-queued-work part.
But the racy part doesn't look possible, thus it should only happen
when something wrong happened.

Now with a proper cause analyse, we can craft a much smaller thus better
fix (anyway I'm the guy to backport, smaller is always better).

Changelog:
v2:
- Change the subject
  It's not about race. I got confused by the initial patch.

- Change the cause analyse
  No need for any race. Also add analyse for all qgroup_rescan_init()
  callers to ensure no missing fixes.
  BTW, qgroup_rescan_init() uses BTRFS_QGROUP_STATUS_FLAG_RESCAN flag to
  determine if there is a conflicting rescan, thus it's not affected by
  the timing change.

- Split the spinlock cleanup into another patch

Qu Wenruo (2):
  btrfs: qgroup: Ensure qgroup_rescan_running is only set when the
    worker is at least queued
  btrfs: qgroup: Remove the unnecesaary spin lock for
    qgroup_rescan_running|queued

 fs/btrfs/qgroup.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

-- 
2.25.0

