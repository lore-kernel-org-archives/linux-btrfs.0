Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20871 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab2JSGUW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 02:20:22 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9J6KLfC006209
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 06:20:21 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9J6KKCX013284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 06:20:20 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9J6KKH1012284
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 01:20:20 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] filter snapshot(s) by its parent uuid
Date: Fri, 19 Oct 2012 14:23:53 +0800
Message-Id: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

This set of patch will make
btrfs su list -s <subvol>
to list only snapshot(s) of the given subvol.

before:
btrfs su list -s /btrfs/sv1
<nothing>
btrfs su list -s /btrfs
ID 258 gen 6 cgen 6 top level 5 otime 2012-10-18 17:01:56 uuid f648cdda-4efa-6f45-bd6b-041a8ae1538e path ss1
ID 260 gen 8 cgen 8 top level 5 otime 2012-10-18 17:02:20 uuid ea8fdf85-8d3f-8946-b3af-ede510cdcf19 path ss2
ID 261 gen 9 cgen 9 top level 5 otime 2012-10-19 13:37:42 uuid 44560e56-3879-2146-8b24-e9048871892f path ss3

with this patch:
btrfs su list -s /btrfs/sv1
ID 258 gen 6 cgen 6 top level 5 otime 2012-10-18 17:01:56 uuid f648cdda-4efa-6f45-bd6b-041a8ae1538e path ss1
ID 261 gen 9 cgen 9 top level 5 otime 2012-10-19 13:37:42 uuid 44560e56-3879-2146-8b24-e9048871892f path ss3

btrfs su list -s /btrfs
ID 258 gen 6 cgen 6 top level 5 otime 2012-10-18 17:01:56 uuid f648cdda-4efa-6f45-bd6b-041a8ae1538e path ss1
ID 260 gen 8 cgen 8 top level 5 otime 2012-10-18 17:02:20 uuid ea8fdf85-8d3f-8946-b3af-ede510cdcf19 path ss2
ID 261 gen 9 cgen 9 top level 5 otime 2012-10-19 13:37:42 uuid 44560e56-3879-2146-8b24-e9048871892f path ss3

Anand Jain (4):
  Btrfs-progs: provide method to check if filter is set
  Btrfs-progs: fix irrelevant string in the subvol path
  Btrfs-progs: add method to filter snapshots by parent uuid
  Btrfs-progs: list only snapshots of the given subvol

 btrfs-list.c     |   17 +++++++++++++++++
 btrfs-list.h     |    3 +++
 cmds-subvolume.c |   39 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 57 insertions(+), 2 deletions(-)

