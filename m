Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21825 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2LOLq3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Dec 2012 06:46:29 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBFBkSLK020464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 11:46:29 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBFBkRdH016528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 11:46:28 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBFBkR0c002642
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 05:46:27 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] add tree format display for btrfs subvol list subcommand
Date: Sat, 15 Dec 2012 19:52:03 +0800
Message-Id: <1355572328-32281-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

This will add new option -x to the btrfs subvol list
sub-command to display subvol-snapshot relation in tree
format with appropriate indentation.

Anand Jain (5):
  Btrfs-progs: add parent uuid for snapshots
  Btrfs-progs: maintain similar case in heading prefix
  Btrfs-progs: Move printing outside of btrfs_list_subvols
  Btrfs-progs: make provision to print subvol list tree format
  Btrfs-progs: Add -x option to btrfs subvol list to display snapshots
    in tree format

 btrfs-list.c     |  227 +++++++++++++++++++++++++++++++++++++++++++++++------
 btrfs-list.h     |    3 +-
 cmds-subvolume.c |   20 ++++--
 man/btrfs.8.in   |    4 +-
 4 files changed, 220 insertions(+), 34 deletions(-)

