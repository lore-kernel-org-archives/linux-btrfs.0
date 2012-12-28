Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21143 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2L1DGv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 22:06:51 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBS36o75021062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:51 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBS36n5g005871
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:06:50 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBS36nno027217
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 21:06:49 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/8 v2] add show command to the subvol sub command
Date: Fri, 28 Dec 2012 11:12:54 +0800
Message-Id: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

v1->v2: Rebased and merged with the newer patch (which are not yet in
the git), and will now print few more parameters of the subvol.

Anand Jain (8):
  Btrfs-progs: move open_file_or_dir() to utils.c
  Btrfs-progs: Move printing outside of btrfs_list_subvols
  Btrfs-progs: add parent uuid for snapshots
  Btrfs-progs: move struct root_info to btrfs-list.h
  Btrfs-progs: function to get root_info of a subvol
  Btrfs-progs: provide method to check if filter is set
  Btrfs-progs: add method to filter snapshots by parent uuid
  Btrfs-progs: add show command to display detailed information about
    the subvol

 Makefile         |    4 +-
 btrfs-list.c     |  157 +++++++++++++++++++++++++++++++++---------------------
 btrfs-list.h     |   54 ++++++++++++++++++-
 btrfsctl.c       |    7 ++-
 cmds-balance.c   |    1 +
 cmds-inspect.c   |    1 +
 cmds-qgroup.c    |    1 +
 cmds-quota.c     |    1 +
 cmds-subvolume.c |  133 ++++++++++++++++++++++++++++++++++++++++++++-
 commands.h       |    3 -
 common.c         |   46 ----------------
 man/btrfs.8.in   |    6 ++
 utils.c          |   30 ++++++++++-
 utils.h          |    3 +
 14 files changed, 326 insertions(+), 121 deletions(-)
 delete mode 100644 common.c

