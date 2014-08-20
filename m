Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49055 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaHTIvd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 04:51:33 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7K8pW26028520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 08:51:33 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7K8pVEX008095
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 08:51:32 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s7K8pVjQ014193
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 08:51:31 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] Btrfs: fix crash on endio of reading corrupted block
Date: Wed, 20 Aug 2014 16:51:19 +0800
Message-Id: <1408524679-13583-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1408462393-3291-1-git-send-email-bo.li.liu@oracle.com>
References: <1408462393-3291-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The crash is

------------[ cut here ]------------
kernel BUG at fs/btrfs/extent_io.c:2124!
invalid opcode: 0000 [#1] SMP
...
CPU: 3 PID: 88 Comm: kworker/u8:7 Not tainted 3.17.0-0.rc1.git0.1.fc22.x86_64 #1
Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
Workqueue: btrfs-endio normal_work_helper [btrfs]
task: ffff8800d7152700 ti: ffff8800d729c000 task.ti: ffff8800d729c000
RIP: 0010:[<ffffffffa02d6055>]  [<ffffffffa02d6055>] end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
Call Trace:
  [<ffffffff810c3ef8>] ? __enqueue_entity+0x78/0x80
  [<ffffffff810ca969>] ? enqueue_entity+0x2e9/0x990
  [<ffffffff813464ab>] bio_endio+0x6b/0xa0
  [<ffffffff813464f2>] bio_endio_nodec+0x12/0x20
  [<ffffffffa02ab217>] end_workqueue_fn+0x37/0x40 [btrfs]
  [<ffffffffa02e4b5d>] normal_work_helper+0xbd/0x280 [btrfs]
  [<ffffffff810ac4fe>] process_one_work+0x17e/0x430
  [<ffffffff810ace8b>] worker_thread+0x6b/0x4a0
  [<ffffffff810ace20>] ? rescuer_thread+0x2a0/0x2a0
  [<ffffffff810b1fca>] kthread+0xea/0x100
  [<ffffffff810b1ee0>] ? kthread_create_on_node+0x1a0/0x1a0
  [<ffffffff8173dd7c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b1ee0>] ? kthread_create_on_node+0x1a0/0x1a0

This is in fact a regression.

It is because we forgot to increase @offset properly in reading corrupted block,
so that the @offset remains unchanged, and it leads to checksum errors while
reading left blocks queued up in the same bio, and then btrfs tries to
iterate copies for those blocks in order to get good data, and hits the
BUG_ON() which we set to avoid finding good copies for blocks without problems.

Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2:
   - Improve the commit log to be clear, suggested by Eric.

 fs/btrfs/extent_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3af4966..be41e4d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2602,6 +2602,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
 				if (err)
 					uptodate = 0;
+				offset += len;
 				continue;
 			}
 		}
-- 
1.8.1.4

