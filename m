Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:20713 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752213AbbJCQak (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Oct 2015 12:30:40 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t93GTsAc017028
	for <linux-btrfs@vger.kernel.org>; Sun, 4 Oct 2015 00:29:54 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3 0/2] btrfs: Fix lost-data-profile caused by auto removing bg and balance bg
Date: Sun, 4 Oct 2015 00:28:38 +0800
Message-ID: <cover.1443889301.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for sending v3 late for I'm in my holiday(until 10/7).

But it is necessary to send out in time because I wish to
end this bug in v4.3 release.

Changelog v2->v3:
1: Use list_is_singular() instead of
   block_group->list.next == block_group->list.prev
   Suggested-by: Jeff Mahoney <jeffm@suse.com>
2: Add Reviewed-by: Filipe Manana <fdmanana@suse.com>

Zhao Lei (2):
  btrfs: Fix lost-data-profile caused by auto removing bg
  btrfs: Fix lost-data-profile caused by balance bg

 fs/btrfs/extent-tree.c | 12 +++++++++++-
 fs/btrfs/volumes.c     | 24 ++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

-- 
1.8.5.1

