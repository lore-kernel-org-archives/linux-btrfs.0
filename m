Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:42858 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796Ab2JYH4l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 03:56:41 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9P7ueS1030205
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 07:56:41 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9P7ueLg027944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 07:56:40 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9P7udLB022668
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 02:56:39 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: dont print uuid unless -u option is given
Date: Thu, 25 Oct 2012 16:00:31 +0800
Message-Id: <1351152031-19010-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

unless it was intentional to include uuid when -s
option is (show snapshot only) given, we would need
this break statement.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ac39f7b..9e4a726 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -338,7 +338,7 @@ static int cmd_subvol_list(int argc, char **argv)
 						0);
 			btrfs_list_setup_print_column(BTRFS_LIST_OGENERATION);
 			btrfs_list_setup_print_column(BTRFS_LIST_OTIME);
-
+			break;
 		case 'u':
 			btrfs_list_setup_print_column(BTRFS_LIST_UUID);
 			break;
-- 
1.7.1

