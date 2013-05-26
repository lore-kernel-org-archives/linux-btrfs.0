Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47014 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3EZNvT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 May 2013 09:51:19 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4QDpHA4017064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:18 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4QDpGMK009869
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:17 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4QDpGTR006653
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:16 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] cleanup and fix
Date: Sun, 26 May 2013 21:50:26 +0800
Message-Id: <1369576231-17836-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1 is a NULL pointer fix.

Patch 2-4 are cleanups.

Patch 5 is an enhancement for the file clone ioctl.

Liu Bo (5):
  Btrfs: fix use-after-free bug in umount
  Btrfs: update new flags for tracepoint
  Btrfs: kill replicate code in replay_one_buffer
  Btrfs: remove unused code in btrfs_del_root
  Btrfs: allow file data clone within a file

 fs/btrfs/disk-io.c           |    4 ++--
 fs/btrfs/ioctl.c             |   26 +++++++++++++++++++-------
 fs/btrfs/root-tree.c         |    4 ----
 fs/btrfs/tree-log.c          |    9 ++-------
 include/trace/events/btrfs.h |   35 +++++++++++++++++++++++------------
 5 files changed, 46 insertions(+), 32 deletions(-)

-- 
1.7.7

