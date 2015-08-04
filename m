Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31795 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920AbbHDOoo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Aug 2015 10:44:44 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t74EihpV018559
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Aug 2015 14:44:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t74Eihmj027161
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Aug 2015 14:44:43 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t74EiCkV019492
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Aug 2015 14:44:42 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 0/3] introduce function to handle device offline
Date: Tue,  4 Aug 2015 22:43:50 +0800
Message-Id: <1438699433-1581-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here the patch 3/3 below adds a function to handle device offline,
also in this patch the device offline is triggred by the external
sysfs interface.
Patch 1/3 makes it possible to mount a or continue to be rw mounted
(if -o degraded option is set or if tolerated failure is more than
missing) when one of the device goes offline in midest of the mounted
FS.
Patch 2/3 fixes a bug. 

Anand Jain (3):
  Btrfs: allow -o rw,degraded for single group profile
  Btrfs: fix null pointer dereference when extent buffer is already
    freed
  Btrfs: introduce function to handle device offline

 fs/btrfs/disk-io.c |   6 ++-
 fs/btrfs/super.c   |   3 +-
 fs/btrfs/sysfs.c   |  20 +++++++++-
 fs/btrfs/volumes.c | 113 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |   7 ++++
 5 files changed, 145 insertions(+), 4 deletions(-)

-- 
2.4.1

