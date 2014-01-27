Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40733 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaA0InK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 03:43:10 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s0R8h9w8010855
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 08:43:10 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s0R8h9hM002438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 08:43:09 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s0R8h8tF002424
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 08:43:09 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] dump device list as seen by the kernel
Date: Mon, 27 Jan 2014 16:52:49 +0800
Message-Id: <1390812770-11720-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For debugging we need a way to understand what kernel
thinks about the devices under its control mainly 
when device disappear and reappear.

The current btrfs-progs sub commands wouldn't help because
the output from the kernel is greatly fine tuned before
printing on the terminal and in some cases provides 
wrong a view (more on it later) as well.

So here I wrote a code to dump fs_devices for the kernel,
the implementation here uses ioctl rather than
memory dumps, as we need this ioctl to fix btrfs subcommands
as well.


Anand Jain (1):
  btrfs: introduce BTRFS_IOC_GET_DEVS

 fs/btrfs/super.c           |   56 +++++++++++++++++++++++++
 fs/btrfs/volumes.c         |   99 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |    2 +
 include/uapi/linux/btrfs.h |   45 ++++++++++++++++++++
 4 files changed, 202 insertions(+), 0 deletions(-)

