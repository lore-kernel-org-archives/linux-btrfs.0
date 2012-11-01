Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30166 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab2KAKmG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 06:42:06 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qA1Ag4cR013369
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 10:42:05 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qA1Ag4ob017001
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 10:42:04 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qA1Ag4ag012239
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 05:42:04 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [Request for review] [RFC] Add label support for snapshots and subvols
Date: Thu,  1 Nov 2012 18:46:07 +0800
Message-Id: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

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




Thanks, Anand
 

Anand Jain (2):
  Btrfs-progs: move open_file_or_dir() to utils.c
  Btrfs-progs: add feature to label subvol and snapshot

 Makefile          |    4 ++--
 btrfsctl.c        |    7 ++++---
 btrfslabel.c      |   40 ++++++++++++++++++++++++++++++++++++++++
 btrfslabel.h      |    4 +++-
 cmds-balance.c    |    1 +
 cmds-filesystem.c |   34 +++++++++++++++++++++++++++++-----
 cmds-inspect.c    |    1 +
 cmds-qgroup.c     |    1 +
 cmds-quota.c      |    1 +
 cmds-subvolume.c  |    1 +
 commands.h        |    3 ---
 common.c          |   46 ----------------------------------------------
 ioctl.h           |    2 ++
 utils.c           |   30 ++++++++++++++++++++++++++++--
 utils.h           |    3 +++
 15 files changed, 116 insertions(+), 62 deletions(-)
 delete mode 100644 common.c


  Btrfs: add label to snapshot and subvol

 fs/btrfs/ctree.h       |   14 ++++++++++++++
 fs/btrfs/ioctl.c       |   32 ++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h       |    2 ++
 fs/btrfs/root-tree.c   |   44 +++++++++++++++++++++++---------------------
 fs/btrfs/transaction.c |    1 +
 5 files changed, 72 insertions(+), 21 deletions(-)


