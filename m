Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46763 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab3HPMmT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 08:42:19 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7GCgH8t032728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 12:42:18 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7GCgGeq003879
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 12:42:17 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7GCgGH1025674
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 12:42:16 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] fi show, dev scan and lblkid
Date: Fri, 16 Aug 2013 20:48:20 +0800
Message-Id: <1376657303-14931-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch set is about
  use of lblkid for the btrfs disk scan and
  using this lblkid scan for the fi show and dev scan cli

  This includes the comments from David (to use lblkid)
  and Zach to show (btrfs fi show) info from kernel when
  disk is mounted and from the disks directly when disk
  is unmounted

Anand Jain (3):
  btrfs-progs: move out print in cmd_df to another function
  btrfs-progs: read from the kernel when disk is mounted
  btrfs-progs: use lblkid to scan and filesystem show improvements

 cmds-device.c     |   21 +---
 cmds-filesystem.c |  368 +++++++++++++++++++++++++++++++++++------------------
 ctree.h           |   11 ++
 utils.c           |   54 ++++++++-
 utils.h           |    7 +-
 5 files changed, 315 insertions(+), 146 deletions(-)

