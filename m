Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25810 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3DEFxp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:45 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355ri7T032385
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:45 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355ric8001371
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:44 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355riwd017062
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:53:44 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/9] a bunch of miscellaneous bug fixes
Date: Fri,  5 Apr 2013 13:54:54 +0800
Message-Id: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David, all

        kindly review/accept this patch set to fix various
	bugs as in the patch.
	This patch set is on top David's integration-20130321
	branch and would apply nicely on top the backup sb
	fixes which was sent separately.

Thanks
Anand

Anand Jain (9):
  btrfs-progs: root_item generation_v2 is out of sync after btrfsck
  btrfs-progs: no pending balance is not an error
  btrfs-progs: mkfs should first check all disks before writing to a
    disk
  btrfs-progs: check if btrfs kernel module is loaded
  btrfs-progs: delete unused function get_mountpt
  btrfs-progs: mkfs stdout print to match chronology
  btrfs-progs: cmd replace should check target-dev fully
  btrfs-progs: btrfs-select-super output is confusing when it fails
  btrfs-progs: fix btrfs scrub start help

 btrfs-select-super.c |   6 +-
 cmds-balance.c       |   6 +-
 cmds-device.c        |  56 +++++++++----
 cmds-replace.c       |  24 +-----
 cmds-scrub.c         |   2 +-
 mkfs.c               | 216 +++++++++++----------------------------------------
 root-tree.c          |  13 ++++
 utils.c              | 178 +++++++++++++++++++++++++++++++++---------
 utils.h              |   2 +
 9 files changed, 260 insertions(+), 243 deletions(-)

-- 
1.8.1.227.g44fe835

