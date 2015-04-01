Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62923 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752431AbbDAHZY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 03:25:24 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t317OID0008074
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Apr 2015 15:24:18 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/3] Use list to replace rb_tree in btrfs_delayed_ref_head->ref_roots.
Date: Wed, 1 Apr 2015 15:25:17 +0800
Message-ID: <1427873120-440-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The old rbtree implement of ref_head->ref_root sacrificed the insert
order to do better delayed_ref_node merging.
However the out of order behavior makes btrfs_find_all_roots() unable to
find correct root, since it needs the insert order to skip later
delayed_nodes.

Without such ability, qgroup can never be accurate (although it is never
accurate anyway, :-( ).

This patchset first fix a small but deadly (only for qgroup) bug in
backref, which will cause btrfs_find_all_roots() return result less than
expected one.

And the second patch do migrate from rb_tree implement to new list
implement, and still maintain the ability to merge delayed_ref_nodes.

The last patch will cleanup the unused rb_tree implement only functions.

The new list implement is in a simpler logic and code base (removes
about 200 lines).

Qu Wenruo (3):
  btrfs: backref: Don't merge refs which are not for same block.
  btrfs: delayed-ref: Use list to replace the ref_root in ref_head.
  btrfs: delayed-ref: Cleanup the unneeded functions.

 fs/btrfs/backref.c     |  15 +--
 fs/btrfs/delayed-ref.c | 311 ++++++++++++-------------------------------------
 fs/btrfs/delayed-ref.h |  18 ++-
 fs/btrfs/disk-io.c     |   8 +-
 fs/btrfs/extent-tree.c |  46 ++------
 5 files changed, 108 insertions(+), 290 deletions(-)

-- 
2.3.4

