Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51525 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3LPH0Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 02:26:16 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBG7QFCB027181
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 07:26:16 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBG7QE95018627
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 07:26:15 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBG7QE3l018618
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 07:26:14 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] Btrfs: inode cache fixes
Date: Mon, 16 Dec 2013 15:25:32 +0800
Message-Id: <1387178735-30832-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The first patch aims to fix the bug of repeatly building inode cache.
The next two patches fix problems with the first one applied.

Liu Bo (3):
  Btrfs: avoid building inode cache repeatly
  Btrfs: don't build inode cache for orphan root
  Btrfs: fix EEXIST error when creating new file in subvolume/snapshot

 fs/btrfs/disk-io.c   |  3 +++
 fs/btrfs/inode-map.c | 25 +++++++++++++++++++++----
 fs/btrfs/inode-map.h |  1 +
 fs/btrfs/root-tree.c |  3 +++
 4 files changed, 28 insertions(+), 4 deletions(-)

-- 
1.8.2.1

