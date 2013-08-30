Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43599 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3H3I3V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 04:29:21 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r7U8TKjk007352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 08:29:21 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7U8TJCf006498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 08:29:20 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r7U8TJfw007257
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 08:29:19 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] v2, fi show, dev scan and lblkid
Date: Fri, 30 Aug 2013 16:35:54 +0800
Message-Id: <1377851756-4009-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

  This patch set is about
  use of lblkid for the btrfs disk scan and
  using this lblkid scan for the fi show and dev scan cli

  This includes the comments from David (to use lblkid)
  and Zach to show (btrfs fi show) info from kernel when
  disk is mounted and from the disks directly when disk
  is unmounted

v2:
  In an effort fix checkpath.pl errors as suggested in
  Wang's review, the two patches as below is merged
  into one

btrfs-progs: read from the kernel when disk is mounted
btrfs-progs: use lblkid to scan and filesystem show improvements

Anand Jain (2):
  btrfs-progs: v4, move out print in cmd_df to another function
  btrfs-progs: use kernel for mounted and lblkid to scan disks

 cmds-device.c     |   21 +---
 cmds-filesystem.c |  361 ++++++++++++++++++++++++++++++++++-------------------
 ctree.h           |   11 ++
 utils.c           |   55 ++++++++-
 utils.h           |    7 +-
 5 files changed, 304 insertions(+), 151 deletions(-)

