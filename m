Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37965 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030746Ab2K3Pmx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 10:42:53 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qAUFgq37010414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2012 15:42:53 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qAUFgpmI022335
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2012 15:42:52 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qAUFgpn2029964
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2012 09:42:51 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] Add subvol and snapshot attribute label
Date: Fri, 30 Nov 2012 23:47:59 +0800
Message-Id: <1354290482-5324-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

This patch set creates the attribute user.label in the root
space, for the subvol and snapshots. Command to use will be
	btrfs subvol label <subvol> [label]
This patch is only for your kind review. And to evaluate both
the approaches, as found during the survey.
Thanks

Anand Jain (3):
  Btrfs-progs: move open_file_or_dir() to utils.c
  Btrfs-progs: add attribute label for subvol and snapshot
  Btrfs-progs: cmd option to show or set the subvol label

 Makefile         |    4 ++--
 btrfsctl.c       |    7 ++++---
 btrfslabel.c     |   38 ++++++++++++++++++++++++++++++++++++++
 btrfslabel.h     |    4 +++-
 cmds-balance.c   |    1 +
 cmds-inspect.c   |    1 +
 cmds-qgroup.c    |    1 +
 cmds-quota.c     |    1 +
 cmds-subvolume.c |   38 ++++++++++++++++++++++++++++++++++++++
 commands.h       |    3 ---
 common.c         |   46 ----------------------------------------------
 ctree.h          |    1 +
 man/btrfs.8.in   |    6 ++++++
 utils.c          |   30 ++++++++++++++++++++++++++++--
 utils.h          |    3 +++
 15 files changed, 127 insertions(+), 57 deletions(-)
 delete mode 100644 common.c

