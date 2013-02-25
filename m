Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24484 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab3BYFbv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 00:31:51 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r1P5Vo95029691
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 05:31:51 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r1P5VohN013612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 05:31:50 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r1P5VnRZ015067
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Feb 2013 23:31:49 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4] Btrfs: Add support for subvol label
Date: Mon, 25 Feb 2013 13:31:44 +0800
Message-Id: <1361770305-1206-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the btrfs kernel changes to add supprt for the
subvol label.

The related (v4) Btrfs-progs patches are 

  Btrfs-progs: add feature to label subvol and snapshot
  Btrfs-progs: cmd option to show or set the subvol label

v4: rebased to Josef Bacik btrfs-next

Anand Jain (1):
  Btrfs: ability to add label to snapshot and subvol

 fs/btrfs/ctree.h           | 12 +++++++++-
 fs/btrfs/ioctl.c           | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.c     |  1 +
 include/uapi/linux/btrfs.h |  2 ++
 4 files changed, 72 insertions(+), 1 deletion(-)

-- 
1.8.1.227.g44fe835

