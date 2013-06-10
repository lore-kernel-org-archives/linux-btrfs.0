Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51689 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3FJOzd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 10:55:33 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5AEtWN2006256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:55:33 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEtVio021301
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:55:31 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEtV3u014047
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:55:31 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: coalesce of patches
Date: Mon, 10 Jun 2013 22:59:13 +0800
Message-Id: <1370876355-16584-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Anand Jain (2):
  btrfs: device delete to get errors from the kernel
  btrfs: add framework to read fs info and dev info from the kernel

 fs/btrfs/ioctl.c           |  22 ++++----
 fs/btrfs/super.c           | 100 +++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.c         | 125 +++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/volumes.h         |   2 +
 include/uapi/linux/btrfs.h | 103 ++++++++++++++++++++++++++++++++++++-
 5 files changed, 313 insertions(+), 39 deletions(-)

-- 
1.8.1.227.g44fe835

