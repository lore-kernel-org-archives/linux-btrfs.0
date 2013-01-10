Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51576 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab3AJLfH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 06:35:07 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r0ABZ6aQ022156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 11:35:07 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r0ABZ5ct001672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 11:35:06 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r0ABZ5WS022448
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 05:35:05 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/11] Btrfs-progs: maintain similar case in heading prefix
Date: Thu, 10 Jan 2013 19:41:21 +0800
Message-Id: <1357818083-15531-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>

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
index efce966..8581762 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -82,7 +82,7 @@ struct {
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

