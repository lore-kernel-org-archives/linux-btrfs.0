Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:32622 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab2JLFRe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 01:17:34 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9C5HXhq031191
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 05:17:34 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9C5HWkP015378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 05:17:33 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9C5HWlD024712
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 00:17:32 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 0/4] Add show sub command to btrfs subvolume
Date: Fri, 12 Oct 2012 13:20:50 +0800
Message-Id: <1350019254-22036-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

This set of patch will add show sub-command to 
btrfs subvolume, which is to show more information
about a given subvol or snapshot. At present it shows
3 info, I hope this will be further useful if enhanced
as needed.

eg:
# btrfs su show /btrfs/sssv3
/btrfs/sssv3
	uuid: 		c5d646b5-a749-c646-b082-6d9a3ca870be
	Parent uuid: 	34bc8edd-113f-5141-a814-f6dfae069b01
	Creation time: 	2012-10-12 11:37:00


Thanks

Anand Jain (4):
  Btrfs-progs: introduce btrfs_get_subvols function
  Btrfs-progs: need struct root_info to be accesible
  Btrfs-progs: method to fetch root info for subvol
  Btrfs-progs: add btrfs subvol show cli

 btrfs-list.c     |  119 ++++++++++++++++++++++++++---------------------------
 btrfs-list.h     |   49 ++++++++++++++++++++++-
 cmds-subvolume.c |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++
 man/btrfs.8.in   |    6 +++
 4 files changed, 225 insertions(+), 62 deletions(-)

