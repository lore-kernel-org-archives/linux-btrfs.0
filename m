Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:11839 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab3DMNUN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Apr 2013 09:20:13 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] Btrfs: patches for tree mod log for next rc
Date: Sat, 13 Apr 2013 15:19:52 +0200
Message-Id: <1365859195-8620-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These three fixes for the tree mod log should go into the next rc pull
request to mainline. I suggest adding them to stable as well, as we did
with the previous tree mod log patch.

The first patch fixes logging of root split operations. The second one
fixes access to the root within the tree mod log functions, which
weren't correctly honoring rcu locking. The third is a fix correcting
the order of free and unlock.

With the snapshot aware defrag patches we added in 3.9, these fixes are
also important for users not using qgroups.

Concerning qgroups, there is at least one more issue to be solved: The
qgroup's expectations how tree mod log increases its sequence numbers
doesn't fit with what the tree mod log code is actually doing. Estimated
size of that fix is larger than what should go into the rc commits or
into stable, that one will be coming for 3.10.

With these three patches applied, I've been running my tests for more
than a day without any issues, while without, it takes only minutes to
trigger a BUG_ON or WARN_ON.

Jan Schmidt (3):
  Btrfs: fix tree mod log regression on root split operations
  Btrfs: fix accessing the root pointer in tree mod log functions
  Btrfs: fix unlock after free on rewinded tree blocks

 fs/btrfs/ctree.c |  111 ++++++++++++++++++++++++++++-------------------------
 1 files changed, 59 insertions(+), 52 deletions(-)

