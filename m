Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:46708 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2HCJvo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2012 05:51:44 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q739phk5026485
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Aug 2012 09:51:44 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q739ph3C001257
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Aug 2012 09:51:43 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q739pgpZ002423
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Aug 2012 04:51:42 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 9/9] Btrfs-progs: fix the btrfs subvol list path last char
Date: Fri,  3 Aug 2012 17:48:58 +0800
Message-Id: <1343987338-10612-11-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
References: <1343822481-26707-1-git-send-email-Anand.Jain@oracle.com>
 <1343987338-10612-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>


Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-list.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index e0cb782..6e83b31 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -205,7 +205,7 @@ static int add_root(struct root_lookup *root_lookup,
 	if (name)
 		strncpy(ri->name, name, name_len);
 	if (name_len > 0)
-		ri->name[name_len-1] = 0;
+		ri->name[name_len] = '\0';
 	if (gen)
 		ri->gen = *gen;
 	ri->otime = ot;
-- 
1.7.1

