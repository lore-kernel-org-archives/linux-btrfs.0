Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:30341 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab2HNGDK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 02:03:10 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7E638qY024340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 06:03:09 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7E638Dh025834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 06:03:08 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7E638lF009611
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 01:03:08 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH] get uuid of subvol and snapshot
Date: Tue, 14 Aug 2012 14:04:05 +0800
Message-Id: <1344924246-24192-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
References: <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

 This patch is on top the patch-set titled 
 'Include otime in the snapshot list' sent by me before.

 To show the uuid of the subvol and snapshots.

btrfs su list -u /btrfs1
ID 256 gen 6 top level 5 uuid 4b7188e4-7d48-f247-b956-1a260b721e1d path sv1
ID 259 gen 6 top level 5 uuid 3cf8931a-de31-5545-8ede-435d25fe3c3f path sv1/.snapshot/ss1

Anand Jain (1):
  add -u to show subvol uuid

 btrfs-list.c     |  148 ++++++++++++++++++++++++++++++++++++++++++------------
 cmds-subvolume.c |   14 +++--
 2 files changed, 124 insertions(+), 38 deletions(-)

