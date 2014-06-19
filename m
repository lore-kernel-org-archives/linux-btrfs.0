Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965705AbaFSVuq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 17:50:46 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 0/2] btrfs: qgroup fixes for btrfs_drop_snapshot
Date: Thu, 19 Jun 2014 14:49:25 -0700
Message-Id: <1403214567-3137-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, the following patches try to fix a long outstanding issue with qgroups
and snapshot deletion. The core problem is that btrfs_drop_snapshot will
skip shared extents during it's tree walk. This results in an inconsistent
qgroup state once the drop is processed.

The first patch adds some tracing which I found very useful in debugging
qgroup operations. The second patch is an actual fix to the problem.

Even with this patch series, we still have some inconsistency in qgroups
when a snapshot is deleted.  As far as I can tell this is because shared
subtree roots are not completely skipped and may get passed to the qgroup
subsystem via a number of ref operations that happen during drop snapshot. 
I am working on a fix for that issue, but feel that what I have here gets us
90% of the way to a full fix.

Please review, thanks. Diffstat follows,
	--Mark

 fs/btrfs/extent-tree.c       |  234 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.c            |  169 +++++++++++++++++++++++++++++--
 fs/btrfs/qgroup.h            |    1 
 fs/btrfs/super.c             |    1 
 include/trace/events/btrfs.h |   57 ++++++++++
 5 files changed, 456 insertions(+), 6 deletions(-)
