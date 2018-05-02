Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44523 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751480AbeEBVMG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 May 2018 17:12:06 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EC21FADC6
        for <linux-btrfs@vger.kernel.org>; Wed,  2 May 2018 21:12:04 +0000 (UTC)
From: jeffm@suse.com
To: dsterba@suse.com, linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH v3 0/3] btrfs: qgroup rescan races (part 1)
Date: Wed,  2 May 2018 17:11:53 -0400
Message-Id: <20180502211156.9460-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Hi Dave -

Here's the updated patchset for the rescan races.  This fixes the issue
where we'd try to start multiple workers.  It introduces a new "ready"
bool that we set during initialization and clear while queuing the worker.
The queuer is also now responsible for most of the initialization.

I have a separate patch set start that gets rid of the racy mess surrounding
the rescan worker startup.  We can handle it in btrfs_run_qgroups and
just set a flag to start it everywhere else.

-Jeff

---

Jeff Mahoney (3):
  btrfs: qgroups, fix rescan worker running races
  btrfs: qgroups, remove unnecessary memset before btrfs_init_work
  btrfs: qgroup, don't try to insert status item after ENOMEM in rescan
    worker

 fs/btrfs/async-thread.c |   1 +
 fs/btrfs/ctree.h        |   2 +
 fs/btrfs/qgroup.c       | 100 +++++++++++++++++++++++++++---------------------
 3 files changed, 60 insertions(+), 43 deletions(-)

-- 
2.12.3

