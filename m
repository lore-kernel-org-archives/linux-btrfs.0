Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47873 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaEZJ12 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 05:27:28 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: [PATCH 0/4] update sysfs per btrfs device operations
Date: Mon, 26 May 2014 17:30:22 +0800
Message-Id: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch set fixes the bugs which Jeff patch is fixing,
which is to update sysfs when device is added and removed.

Further, this patch set also address the following.
  - Update sysfs path when device is replaced
  - Update sysfs path when sprout is created

Also mainly this patch makes the code more modular
which will support the enhancement like in the RFC
sent before.
   [PATCH RFC] btrfs: revamp /sys/fs/btrfs/<fsid>/devices

Thanks.


Anand Jain (4):
  btrfs: dev delete should remove sysfs entry
  btrfs: dev add should add its sysfs entry
  btrfs: dev replace should replace the sysfs entry
  btrfs: create sprout should rename fsid on the sysfs as well

 fs/btrfs/dev-replace.c |    5 +++++
 fs/btrfs/sysfs.c       |   32 +++++++++++++++++++++++++++++---
 fs/btrfs/sysfs.h       |    4 ++++
 fs/btrfs/volumes.c     |   17 +++++++++++++++++
 4 files changed, 55 insertions(+), 3 deletions(-)

