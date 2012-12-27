Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49711 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab2L0JDz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 04:03:55 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBR93rur008507
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:03:54 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBR93rWI009268
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:03:53 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBR93rEE019842
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 03:03:53 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/8] Btrfs: save us a read_lock
Date: Thu, 27 Dec 2012 17:01:22 +0800
Message-Id: <1356598884-22952-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
References: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This does not change the logic of code, but can save us a read_lock.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/locking.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 2a1762c..e95df43 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -113,11 +113,10 @@ again:
 		read_unlock(&eb->lock);
 		return;
 	}
-	read_unlock(&eb->lock);
-	wait_event(eb->write_lock_wq, atomic_read(&eb->blocking_writers) == 0);
-	read_lock(&eb->lock);
 	if (atomic_read(&eb->blocking_writers)) {
 		read_unlock(&eb->lock);
+		wait_event(eb->write_lock_wq,
+			   atomic_read(&eb->blocking_writers) == 0);
 		goto again;
 	}
 	atomic_inc(&eb->read_locks);
-- 
1.7.7.6

