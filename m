Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33282 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaLYJWB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Dec 2014 04:22:01 -0500
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 47DCD3EE16B
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 18:22:00 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 5A11EAC073F
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 18:21:59 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 0E976E08002
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 18:21:59 +0900 (JST)
Message-ID: <549BD725.8040603@jp.fujitsu.com>
Date: Thu, 25 Dec 2014 18:21:41 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
CC: Chris Murphy <chris@colorremedies.com>
Subject: [PATCH] btrfs: suppress a build warning on building 32bit kernel
References: <CAJCQCtQWS9j0g44c5VKp0Cv=PRC=GAJwpspF5eeRk0siibGXKg@mail.gmail.com>
In-Reply-To: <CAJCQCtQWS9j0g44c5VKp0Cv=PRC=GAJwpspF5eeRk0siibGXKg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Suppress the following warning displayed on building 32bit (i686) kernel.

===============================================================================
...
   CC [M]  fs/btrfs/extent_io.o
fs/btrfs/extent_io.c: In function ‘btrfs_free_io_failure_record’:
fs/btrfs/extent_io.c:2193:13: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
    failrec = (struct io_failure_record *)state->private;
...
===============================================================================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Reported-by: Chris Murphy <chris@colorremedies.com>

---
  fs/btrfs/extent_io.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ebabd2..790dbae 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2190,7 +2190,7 @@ void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end)
  
  		next = next_state(state);
  
-		failrec = (struct io_failure_record *)state->private;
+		failrec = (struct io_failure_record *)(unsigned long)state->private;
  		free_extent_state(state);
  		kfree(failrec);
  
-- 
1.8.3.1

