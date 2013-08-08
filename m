Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37782 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776Ab3HHIDj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 04:03:39 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7883chY027078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:03:38 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7883bLS015822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:03:38 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7883beJ015867
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:03:37 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] scan /dev/mapper in filesystem show and device scan
Date: Thu,  8 Aug 2013 16:09:26 +0800
Message-Id: <1375949368-23798-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch brings the /dev/mapper to be used as the path for
the btrfs kernel through dev scan
1/2 is the preparatory patch

Anand Jain (2):
  btrfs-progs: btrfs_scan_one_dir not to skip links when /dev/mapper is
    provided
  btrfs-progs: scan /dev/mapper in filesystem show and device scan

 cmds-device.c     |  8 +++++++-
 cmds-filesystem.c |  7 +++++--
 man/btrfs.8.in    | 22 ++++++++++++----------
 utils.c           | 22 +++++++++++++++++++---
 utils.h           |  1 +
 5 files changed, 44 insertions(+), 16 deletions(-)

-- 
1.8.1.191.g414c78c

