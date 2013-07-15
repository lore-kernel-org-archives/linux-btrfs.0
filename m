Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39951 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3GOFaa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 01:30:30 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6F5UTdf011491
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 05:30:29 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6F5USk6023593
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 05:30:28 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6F5USIG010123
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jul 2013 05:30:28 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: misc trivial fixes
Date: Mon, 15 Jul 2013 13:35:25 +0800
Message-Id: <1373866527-10604-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Anand Jain (2):
  btrfs-progs: fix the long lines
  btrfs-progs: close_all_devices() declared in multiple files

 btrfs-find-root.c |   17 +----------------
 cmds-replace.c    |   17 ++++++++++-------
 disk-io.c         |    3 +--
 disk-io.h         |    1 +
 4 files changed, 13 insertions(+), 25 deletions(-)

-- 
1.7.7.6

