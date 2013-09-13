Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31787 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3IMLZU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 07:25:20 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/2 v3] fi show, dev scan and lblkid
Date: Fri, 13 Sep 2013 19:32:21 +0800
Message-Id: <1379071943-27543-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

  This patch set is about
  use of lblkid for the btrfs disk scan and
  using this lblkid scan for the fi show and dev scan cli

  This includes the comments from David (to use lblkid)
  and Zach to show (btrfs fi show) info from kernel when
  disk is mounted and from the disks directly when disk
  is unmounted by default

v3:
  rebase on to 20130909
  accepts Davids review comments

v2:
  In an effort fix checkpath.pl errors as suggested in
  Wang's review, the two patches as below is merged
  into one

  btrfs-progs: read from the kernel when disk is mounted
  btrfs-progs: use lblkid to scan and filesystem show improvements


Anand Jain (2):
  btrfs-progs: move out print in cmd_df to another function
  btrfs-progs: use kernel for mounted and lblkid to scan disks

 cmds-device.c     |  19 ++-
 cmds-filesystem.c | 354 ++++++++++++++++++++++++++++++++++++++----------------
 ctree.h           |  11 ++
 man/btrfs.8.in    |  17 +--
 utils.c           |  55 ++++++++-
 utils.h           |   5 +
 6 files changed, 338 insertions(+), 123 deletions(-)

-- 
1.8.4.rc4.1.g0d8beaa

