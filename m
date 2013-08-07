Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23710 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab3HGMFk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 08:05:40 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r77C5d48000788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Aug 2013 12:05:40 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r77C5be2016276
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Aug 2013 12:05:39 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r77C5bDM022723
	for <linux-btrfs@vger.kernel.org>; Wed, 7 Aug 2013 12:05:37 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3 resend] 
Date: Wed,  7 Aug 2013 20:11:22 +0800
Message-Id: <1375877485-12105-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain (3):
  btrfs-progs: let user know that devid can be used if path is missing
  btrfs-progs: cmd_start_replace() to use test_dev_for_mkfs()
  btrfs-progs: avoid write to the disk before sure to create fs

 cmds-replace.c |   33 +++---------------
 mkfs.c         |  104 ++++++++++++++++++++++----------------------------------
 utils.c        |   53 ++++++++++++++++++++++++++++-
 utils.h        |    4 ++
 4 files changed, 102 insertions(+), 92 deletions(-)

