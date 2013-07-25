Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32582 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab3GYRaM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 13:30:12 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6PHUBt1017830
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:30:12 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6PHUAMI017444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:30:11 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6PHUANj017417
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 17:30:10 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6]
Date: Fri, 26 Jul 2013 01:35:24 +0800
Message-Id: <1374773730-29957-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The below patch set is on top of,

 git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130710

and is for your kind review coment and integration

Thanks

Anand Jain (6):
  btrfs-progs: close_all_devices() in btrfs-find-root.c does nothing
  btrfs-progs: let user know that devid can be used if path is missing
  btrfs-progs: cmd_start_replace() to use test_dev_for_mkfs()
  btrfs-progs: mkfs.c overwrites fd without appropriate close
  btrfs-progs: avoid write to the disk before sure to create fs
  btrfs-progs: don't have to report ENOMEDIUM error during open

 btrfs-find-root.c |   17 +--------
 cmds-replace.c    |   33 ++--------------
 disk-io.c         |    3 +-
 disk-io.h         |    1 +
 mkfs.c            |  107 +++++++++++++++++++++-------------------------------
 utils.c           |   56 +++++++++++++++++++++++++++-
 utils.h           |    2 +
 7 files changed, 107 insertions(+), 112 deletions(-)

