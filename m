Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:44721 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2HCJvK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2012 05:51:10 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q739p8Z3032070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Aug 2012 09:51:08 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q739p77q013219
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Aug 2012 09:51:07 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q739p751002049
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Aug 2012 04:51:07 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 0/9 V2] Include otime in the snapshot list
Date: Fri,  3 Aug 2012 17:48:48 +0800
Message-Id: <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1343822481-26707-1-git-send-email-Anand.Jain@oracle.com>
References: <1343822481-26707-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

 Thanks to Alexander Block and Liu Bo for the review.
 Changes from V1 -> V2:
   . renamed crtime to otime
   . included the dependent btrfs-progs and btrfs kernel
      patches as below and in email following this respectively
   . fix bug in the btrfs su list 

 btrfs kernel dependency:
  otime is added by the kernel patch:
    [RFC PATCH 4/7] Btrfs: introduce subvol uuids and times
  this btrfs-progs patch has been unit-tested to work fine
  for both the cases that is snapshots created with and
  without the otime/above-kerne-patch, this patch will
  print the otime and/or "-" in the respective scenarios.

 Eg:
  # btrfs su list -s 1 /btrfs2
  ID 259 gen 8 cgen 8 top level 5 otime - path sv-old-gen1/.snapshot/ss1-old-gen1
  ID 261 gen 13 cgen 13 top level 5 otime - path sv-old-gen1/.snapshot/ss2
  ID 262 gen 18 cgen 18 top level 5 otime 2012-08-03 16:08:59 path sv-old-gen1/.snapshot/ss3-on-new

Alexander Block (1):
  Update ctree.h and ioctl.h for the new uuid+times for subvolumes.

Anand Jain (2):
  Btrfs-progs: add otime to the snapshot list
  Btrfs-progs: fix the btrfs subvol list path last char

Ilya Dryomov (3):
  Btrfs-progs: refactor resolve_root() function a bit
  Btrfs-progs: nuke redundant zeroing in __list_subvol_search()
  Btrfs-progs: bring 'subvol get-default' back in

Liu Bo (3):
  Btrfs-progs: search subvolumes with proper objectid
  Btrfs-progs: show generation in command btrfs subvol list
  Btrfs-progs: list snapshots by generation

 btrfs-list.c     |  378 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 cmds-subvolume.c |   19 ++-
 ctree.h          |   42 ++++++-
 ioctl.h          |   12 ++
 print-tree.c     |   79 +++++++++---
 5 files changed, 476 insertions(+), 54 deletions(-)

