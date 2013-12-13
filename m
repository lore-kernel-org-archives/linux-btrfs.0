Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42944 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3LMJQh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 04:16:37 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBD9Gamw026149
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 09:16:37 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBD9GaiU026959
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 09:16:36 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBD9GZuF016480
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 09:16:35 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] Btrfs: inode cache fixes
Date: Fri, 13 Dec 2013 17:16:20 +0800
Message-Id: <1386926183-18325-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The first patch aims to fix the bug of repeatly building inode cache.
The next two patches fix problems with the first one applied.

For better review, I decided to have three patches instead of folding them into
one.

Liu Bo (3):
  Btrfs: avoid building inode cache repeatly
  Btrfs: don't build inode cache for orphan root
  Btrfs: fix EEXIST error when creating new file in subvolume/snapshot

 fs/btrfs/disk-io.c   |  9 +++++----
 fs/btrfs/inode-map.c | 21 +++++++++++++++++----
 2 files changed, 22 insertions(+), 8 deletions(-)

-- 
1.8.2.1

