Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50634 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3JKLpZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 07:45:25 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/2] btrfs-progs: device scan use BTRFS_SCAN_LBLKID by default
Date: Fri, 11 Oct 2013 19:52:53 +0800
Message-Id: <1381492374-7227-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

with this patch, BTRFS_SCAN_LBLKID (which leverages lblkid
to look for btrfs disks) would be the default scan method
to look for the btrfs disks. And thus the output as seen
in the latest btrfs fi show and btrfs fi show -m for the
mounted disks will have the consistent disks path.
(it was inconsistent (across disks) because btrfs dev scan
provided a different path from the mount command eg. below)

    devid    1 size 1.98GiB used 435.00MiB path /dev/mapper/mpatha
    devid    2 size 2.00GiB used 415.00MiB path /dev/dm-1

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 7cfc347..1315918 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -189,7 +189,7 @@ static const char * const cmd_scan_dev_usage[] = {
 static int cmd_scan_dev(int argc, char **argv)
 {
 	int	i, fd, e;
-	int	where = BTRFS_SCAN_PROC;
+	int	where = BTRFS_SCAN_LBLKID;
 	int	devstart = 1;
 
 	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
-- 
1.7.1

