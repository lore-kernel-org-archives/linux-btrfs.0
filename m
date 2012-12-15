Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21836 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab2LOLqb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Dec 2012 06:46:31 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBFBkUsZ020482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 11:46:31 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBFBkU4F016555
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 11:46:30 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBFBkTne002655
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Dec 2012 05:46:29 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] Btrfs-progs: maintain similar case in heading prefix
Date: Sat, 15 Dec 2012 19:52:05 +0800
Message-Id: <1355572328-32281-3-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1355572328-32281-1-git-send-email-Anand.Jain@oracle.com>
References: <1355572328-32281-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

A trivial fix
before this patch
  btrfs su list -qu /btrfs
  ID 256 gen 35 top level 5 parent UUID - uuid 60e54c4a-8136-3c43-a107-ea42052c6240 path sv1
  ID 257 gen 35 top level 5 parent UUID 60e54c4a-8136-3c43-a107-ea42052c6240 uuid fdefa4a9-5b67-4f4c-8a11-c43acec51d43 path ss1

after this path
  btrfs su list -qu /btrfs
  ID 256 gen 35 top level 5 parent_uuid - uuid 60e54c4a-8136-3c43-a107-ea42052c6240 path sv1
  ID 257 gen 35 top level 5 parent_uuid 60e54c4a-8136-3c43-a107-ea42052c6240 uuid fdefa4a9-5b67-4f4c-8a11-c43acec51d43 path ss1

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 5314ced..3db5f14 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -129,7 +129,7 @@ struct {
 		.need_print	= 0,
 	},
 	{
-		.name		= "parent UUID",
+		.name		= "parent_uuid",
 		.column_name	= "Parent UUID",
 		.need_print	= 0,
 	},
-- 
1.7.1

