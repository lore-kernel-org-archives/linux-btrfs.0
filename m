Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42012 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754963AbbBJK1X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:23 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQbKr000922
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:37 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/3] Btrfs: qgroup: part-3: bug fixes for deleting subvolume.
Date: Tue, 10 Feb 2015 18:24:02 +0800
Message-ID: <1423563845-9103-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
	This is a part3 for qgroup, it is based on
	Btrfs: qgroup: part-2: bug fixes.

Dongsheng Yang (3):
  btrfs: qgroup: return EINVAL if level of parent is not higher than
    child's.
  btrfs: qgroup: allow to remove qgroup which has parent but no child.
  btrfs: qgroup: fix a wrong parameter of no_quota.

 fs/btrfs/extent-tree.c |  8 ++++++--
 fs/btrfs/qgroup.c      | 35 ++++++++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 7 deletions(-)

-- 
1.8.4.2

