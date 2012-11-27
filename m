Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17494 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab2K0SYR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Nov 2012 13:24:17 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qARIOGW0021641
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2012 18:24:16 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qARIOFrT028422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2012 18:24:16 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qARIOFRc030644
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2012 12:24:15 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [Request for review v3] [RFC] Add label support for snapshots and subvols
Date: Wed, 28 Nov 2012 02:29:16 +0800
Message-Id: <1354040960-31522-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

v2->v3:
	Changes are in the btrfs kernel patch only, which accepts
	review comments by Miao.
v1->v2:
	This v2 patch accepts the review comments on the btrfs
	kernel changes by Jan. and
	Moved the get and set subvol label to under subvol sub-cmd
	eg:
		btrfs subvolume label /btrfs/ss5
		btrfs su la /btrfs/ss5 "ss5-label"
		btrfs su la /btrfs/ss5
		ss5-label

v1:
 (This patch is for the review/test not yet for the integration).

 Here is an implementation of the feature to add label to the
 subvolume and snapshots. Which would help sysadmin to better manager
 the subvol and snapshots.

 This can be done in two ways, one - using attr which is user land
 only changes but drawback is able to change the label using the
 non btrfs cli. And the other way is to add a member to
 btrfs_root_item in the btrfs kernel to hold the label info for
 each snapshot and subvol. The drawback here is having to introduce
 V3 version of this structure. If there is any better way pls do share.
 The patch code is for the review.

Any comments/suggestion welcome.

Below is a demo of this new feature.
------------
 btrfs fi label -t /btrfs/sv1 "Prod-DB"

 btrfs fi label -t /btrfs/sv1
Prod-DB

 btrfs su snap /btrfs/sv1 /btrfs/snap1-sv1
Create a snapshot of '/btrfs/sv1' in '/btrfs/snap1-sv1'
 btrfs fi label -t /btrfs/snap1-sv1

 btrfs fi label -t /btrfs/snap1-sv1 "Prod-DB-sand-box-testing"
 
 btrfs fi label -t /btrfs/snap1-sv1
Prod-DB-sand-box-testing
----------------

Anand Jain (3):
  Btrfs-progs: move open_file_or_dir() to utils.c
  Btrfs-progs: add feature to label subvol and snapshot
  Btrfs-progs: cmd option to show or set the subvol label

 Makefile         |    4 ++--
 btrfsctl.c       |    7 ++++---
 btrfslabel.c     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 btrfslabel.h     |    4 +++-
 cmds-balance.c   |    1 +
 cmds-inspect.c   |    1 +
 cmds-qgroup.c    |    1 +
 cmds-quota.c     |    1 +
 cmds-subvolume.c |   38 ++++++++++++++++++++++++++++++++++++++
 commands.h       |    3 ---
 common.c         |   46 ----------------------------------------------
 ctree.h          |    4 +++-
 ioctl.h          |    2 ++
 man/btrfs.8.in   |    6 ++++++
 print-tree.c     |    2 ++
 utils.c          |   30 ++++++++++++++++++++++++++++--
 utils.h          |    3 +++
 17 files changed, 140 insertions(+), 58 deletions(-)
 delete mode 100644 common.c

