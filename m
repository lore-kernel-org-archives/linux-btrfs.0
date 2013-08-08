Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36909 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696Ab3HHIBT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 04:01:19 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7881HnH025312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:01:18 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7881Gal005728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:01:17 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7881GqH016811
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:01:16 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2 v2] introduce btrfs filesystem show --kernel
Date: Thu,  8 Aug 2013 16:07:05 +0800
Message-Id: <1375949227-23729-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch set introduces --kernel option for filesystem show 
for the reason as mentioned in the patch 1/2 below
1/1 is the preparatory patch

Anand Jain (2):
  btrfs-progs: move out print in cmd_df to another function
  btrfs-progs: introduce btrfs filesystem show --kernel

 cmds-filesystem.c | 355 ++++++++++++++++++++++++++++++++++++++++--------------
 ctree.h           |  11 ++
 man/btrfs.8.in    |   5 +-
 3 files changed, 281 insertions(+), 90 deletions(-)

-- 
1.8.1.191.g414c78c

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
