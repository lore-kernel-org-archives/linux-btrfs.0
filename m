Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A034C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 13:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55AC520693
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 13:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfDONPc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 09:15:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:40824 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727389AbfDONPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 09:15:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C7A1BAEE2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 13:15:30 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/2] btrfs: trace: Trace events for btrfs tree locking
Date:   Mon, 15 Apr 2019 21:15:23 +0800
Message-Id: <20190415131525.20274-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This branch can be fetched from github:
https://github.com/adam900710/linux/tree/trace_locking
Which is based on v5.1-rc4 tag.

This patchset will introduce the following trace events for corresponding
functions:
  btrfs_tree_lock			(sleepable)
  btrfs_tree_unlock
  btrfs_tree_read_lock			(sleepable)
  btrfs_tree_read_unlock
  btrfs_tree_read_unlock_blocking
  btrfs_set_lock_blocking_read
  btrfs_set_lock_blocking_write
  btrfs_clear_lock_blocking_read
  btrfs_clear_lock_blocking_write
  btrfs_try_tree_read_lock
  btrfs_try_tree_write_lock
  btrfs_tree_read_lock_atomic

The two sleepable ones will have extra info like start_ns, end_ns,
diff_ns.
Those two can be specially useful for tree lock wait time.
There is tool to utilize those two events already:
https://github.com/adam900710/btrfs-profiler/blob/master/tree_lock_wait.py

The non-sleepable can be useful for possible user space based lock
leakage/dead lock detector.

Changelog:
v2:
- Hide all ktime_get_ns() call out of trace events
  So there will be no overhead if trace events are not enabled.

v3:
- More output for human to take a glance
- More trace events for later bcc usage
  Like lock leakage and deadlock detection.

Qu Wenruo (2):
  btrfs: trace: Introduce trace events for sleepable tree lock
  btrfs: trace: Introduce trace events for all btrfs tree locking events

 fs/btrfs/locking.c           | 22 +++++++++
 include/trace/events/btrfs.h | 86 ++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)

-- 
2.21.0

