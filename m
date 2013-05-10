Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41171 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab3EJLAL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 07:00:11 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4AB09mq029066
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 11:00:10 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4AB09W4026738
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 11:00:09 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4AB093k026724
	for <linux-btrfs@vger.kernel.org>; Fri, 10 May 2013 11:00:09 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] filesystem show need to read from the kernel
Date: Fri, 10 May 2013 19:02:42 +0800
Message-Id: <1368183764-7865-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(This is a review patch to seek comments and review, not yet
ready for the integration).

The motivation to write this patch is that 'btrfs fi show' 
shows the stale information after the dev del.

So this adds two ioctls to read fsinfo and devinfo from the
kernel and report to the user.

This is done by providing option -k (which reports only
mounted fs and disks) and -K (which reports both mounted/
unmounted-stale fs) from the kernel as shown below.

------
usage: btrfs filesystem show [-k|K] [--all-devices] [<uuid>|<label>]

    Show the structure of a filesystem

    	If no argument is given, structure of all present filesystems is shown
	-K list both mounted and unmounted/stale btrfs as per kernel
	-k list mounted btrfs as known to the kernel.
-----


Anand Jain (1):
  btrfs: add framework to read fs info and dev info from the kernel

 fs/btrfs/super.c           | 87 ++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/volumes.c         | 86 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h         |  2 ++
 include/uapi/linux/btrfs.h | 58 ++++++++++++++++++++++++++++++-
 4 files changed, 225 insertions(+), 8 deletions(-)

Anand Jain (1):
  btrfs-progs: add framework to read fs info and dev info from the
    kernel

 cmds-filesystem.c |  92 ++++++++++++++++++++++++++++++--
 ioctl.h           |  60 ++++++++++++++++++++-
 utils.c           | 153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h           |   2 +
 4 files changed, 303 insertions(+), 4 deletions(-)

-- 
1.8.1.227.g44fe835

