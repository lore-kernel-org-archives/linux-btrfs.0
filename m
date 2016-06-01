Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62909 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752864AbcFACQK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 22:16:10 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix uninit variables in btrfs-image
Date: Wed, 1 Jun 2016 10:15:47 +0800
Message-ID: <1464747347-16979-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-image.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-image.c b/btrfs-image.c
index d121951..7c2fa94 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1757,6 +1757,7 @@ static void *restore_worker(void *data)
 		if (!mdres->fixup_offset) {
 			while (size) {
 				u64 chunk_size = size;
+				physical_dup = 0;
 				if (!mdres->multi_devices && !mdres->old_restore)
 					bytenr = logical_to_physical(mdres,
 						     async->start + offset,
-- 
2.5.5



