Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51887 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbbKIK7p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:59:45 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9AxhCl016111
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:59:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id tA9Axhne010216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:59:43 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tA9Axh24004263
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:59:43 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs-progs: Hot spare and Auto replace
Date: Mon,  9 Nov 2015 18:58:35 +0800
Message-Id: <1447066719-3880-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Depends on the kernel patch set
  [PATCH 00/15] btrfs: Hot spare and Auto replace

This is btrfs-progs side of the patch set.

Anand Jain (4):
  btrfs-progs: Introduce BTRFS_FEATURE_INCOMPAT_SPARE_DEV SB flags
  btrfs-progs: Introduce btrfs spare subcommand
  btrfs-progs: add fi show for spare
  btrfs-progs: add global spare device list to filesystem show

 Android.mk         |   2 +-
 Makefile.in        |   2 +-
 btrfs-show-super.c |   3 +-
 btrfs.c            |   1 +
 cmds-filesystem.c  |   9 ++
 cmds-spare.c       | 291 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 commands.h         |   2 +
 ctree.h            |   4 +-
 utils.h            |   1 +
 volumes.c          |   4 +
 volumes.h          |   2 +
 11 files changed, 317 insertions(+), 4 deletions(-)
 create mode 100644 cmds-spare.c

-- 
2.4.1

