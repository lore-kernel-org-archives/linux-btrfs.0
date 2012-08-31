Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20380 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2HaFie (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 01:38:34 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q7V5cXTE025882
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:38:34 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q7V5cWFY026009
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 05:38:33 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q7V5cWRF023908
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 00:38:32 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] bug-fixes and cleanup
Date: Fri, 31 Aug 2012 13:36:53 +0800
Message-Id: <1346391419-4278-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liub.liubo@gmail.com>

This is a collection of some posted patches.

It is also available in
	git://github.com/liubogithub/btrfs-work.git

Liu Bo (5):
  Btrfs: fix a bug of per-file nocow
  Btrfs: update delayed ref's tracepoints to show sequence
  Btrfs: fix a bug in parsing return value in logical resolve
  Btrfs: use helper for logical resolve
  Btrfs: use larger limit for translation of logical to inode

liubo (1):
  Btrfs: cleanup for unused ref cache stuff

 fs/btrfs/backref.c           |   26 +++++++++++++++++---------
 fs/btrfs/backref.h           |    3 ++-
 fs/btrfs/ctree.h             |    3 ---
 fs/btrfs/disk-io.c           |    5 -----
 fs/btrfs/inode.c             |    3 +--
 fs/btrfs/ioctl.c             |   24 +++++++-----------------
 fs/btrfs/scrub.c             |   14 ++++++++------
 fs/btrfs/send.c              |    7 ++++---
 include/trace/events/btrfs.h |   14 ++++++++++----
 9 files changed, 49 insertions(+), 50 deletions(-)

-- 
1.7.7.6

