Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:31522 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2HAMCa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2012 08:02:30 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q71C2SpH019156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Aug 2012 12:02:29 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q71C2Sb0012956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Aug 2012 12:02:28 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q71C2SR7019357
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Aug 2012 07:02:28 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand <anand.jain@oracle.com>
Subject: [PATCH] add crtime to the snapshot list
Date: Wed,  1 Aug 2012 20:01:20 +0800
Message-Id: <1343822481-26707-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand <anand.jain@oracle.com>

 This patch adds creation-time to the snapshot list display,
 which would help user to better manage the snapshots when
 number of snapshots grow substantially. This patch is developed
 and on top of the send/receive btrfs and btrfs-progs repo at 
  git://github.com/ablock84/linux-btrfs.git (send-v2)
  git://github.com/ablock84/btrfs-progs.git (send-v2)
 respectively.

 Further this patch has the dependency on the following patches
  Liu Bo:
   [PATCH 2/3 RESEND] Btrfs-progs: show generation in command btrfs subvol list
   [PATCH 3/3] Btrfs-progs: list snapshots by generation

 Eg output:
   #btrfs su list -s 1 /btrfs
   ID 258 gen 39 cgen 6 top level 5 crtime 2012-07-27 17:43:55 path ss1
   ID 260 gen 8 cgen 8 top level 5 crtime 2012-07-27 17:47:51 path ss2
   ID 263 gen 16 cgen 16 top level 5 crtime 2012-07-29 00:50:19 path ss3
   ID 264 gen 25 cgen 25 top level 5 crtime 2012-07-30 09:56:50 path sv1/.snap

Anand Jain (1):
  Btrfs-progs: show crtime in the snapshot list

 btrfs-list.c |   45 ++++++++++++++++++++++++++++++++++++---------
 1 files changed, 36 insertions(+), 9 deletions(-)

