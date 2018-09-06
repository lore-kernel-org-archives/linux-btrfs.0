Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56530 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726031AbeIGBzm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 21:55:42 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6711BADDD
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2018 21:18:21 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 0/3] btrfs: trim latency improvements
Date: Thu,  6 Sep 2018 17:18:13 -0400
Message-Id: <20180906211816.12121-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This patch set fixes a few issues with trim.

1) Fix device list iteration.  We're iterating the ->alloc_list while
   holding the device_list_mutex.  The ->alloc_list is protected by
   the chunk mutex and we don't want to hold it across the entire
   trim execution.  Instead, use the ->devices list, which is protected
   by the device_list_mutex.

2) Skip trim on devices that don't support it.  Rather than letting
   the block layer reject it, bounce out early.

3) Don't keep the commit_root_sem locked and the transaction pinned
   across the block layer component of trim.  We only need these to
   ensure the pending chunks list doesn't go away underneath us, so
   it's safe to drop across the trim itself.  Historically, this
   caused issues when fstrim and balance would run at the same time
   since balance would produce lots of transactions and would
   have to wait constantly, causing problems for everything else that
   wanted to start a transaction.

-Jeff
---

Jeff Mahoney (3):
  btrfs: use ->devices list instead of ->alloc_list in btrfs_trim_fs
  btrfs: don't attempt to trim devices that don't support it
  btrfs: keep trim from interfering with transaction commits

 fs/btrfs/extent-tree.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

-- 
2.12.3
