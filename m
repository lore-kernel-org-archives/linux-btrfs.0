Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44182 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070Ab3FTMFl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 08:05:41 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5KC5eAh017116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:05:40 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5KC5dWr028076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:05:39 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5KC5dhX001568
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 12:05:39 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] multiple disks restore support of btrfs-image
Date: Thu, 20 Jun 2013 20:05:26 +0800
Message-Id: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1-3 are bug fixes for several places.

Patch 4 adds btrfs-image support of multiple disks restore.

Liu Bo (4):
  Btrfs-progs: fix misuse of skinny metadata in btrfs-image
  Btrfs-progs: skip open devices which is missing
  Btrfs-progs: delete fs_devices itself from fs_uuid list before
    freeing
  Btrfs-progs: exhance btrfs-image to restore image onto multiple disks

 btrfs-image.c |  298 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
 ctree.h       |    1 +
 disk-io.c     |   91 +++++++++++++-----
 disk-io.h     |    5 +
 volumes.c     |    4 +
 5 files changed, 339 insertions(+), 60 deletions(-)

-- 
1.7.7

