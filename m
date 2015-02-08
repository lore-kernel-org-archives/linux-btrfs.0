Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40880 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbbBIHti (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:49:38 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: [PATCH 1/1] export symbol kobject_move()
Date: Mon,  9 Feb 2015 07:48:35 +0800
Message-Id: <1423439315-4543-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

drivers/cpufreq/cpufreq.c is already using this function. And now btrfs
needs it as well. export symbol kobject_move().
---
 lib/kobject.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/kobject.c b/lib/kobject.c
index 58751bb..e055c06 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -548,6 +548,7 @@ out:
 	kfree(devpath);
 	return error;
 }
+EXPORT_SYMBOL_GPL(kobject_move);
 
 /**
  * kobject_del - unlink kobject from hierarchy.
-- 
2.0.0.153.g79dcccc

