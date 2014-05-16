Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49492 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbaEPOAk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 10:00:40 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s4GE0c3T010206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 14:00:39 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4GE0bpI018528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 14:00:38 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s4GE0bew014860
	for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 14:00:37 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/1 not for integration] btrfs-devlist
Date: Fri, 16 May 2014 22:03:21 +0800
Message-Id: <1400249003-23140-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-devlist: Dumps kernel fs_devices for debug purpose

(This is not for integration, use it until we have a
replacement tool)

Anand Jain (1):
  btrfs: introduce BTRFS_IOC_GET_DEVS

 fs/btrfs/super.c           |   86 ++++++++++++++++++++++++++
 fs/btrfs/volumes.c         |  142 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |    2 +
 include/uapi/linux/btrfs.h |   51 ++++++++++++++++
 4 files changed, 281 insertions(+), 0 deletions(-)

Anand Jain (1):
  btrfs-progs: introduce btrfs-devlist

 .gitignore      |    1 +
 Makefile        |    4 +-
 btrfs-devlist.c |  266 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h         |   51 +++++++++++
 4 files changed, 320 insertions(+), 2 deletions(-)
 create mode 100644 btrfs-devlist.c
