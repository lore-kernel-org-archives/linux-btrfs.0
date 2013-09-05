Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35030 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab3IEGxq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Sep 2013 02:53:46 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 28AC13EE0BB
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:53:45 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 1743145DE50
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:53:45 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 0022F45DE4F
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:53:45 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id E909F1DB8040
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:53:44 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id A11CC1DB803B
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:53:44 +0900 (JST)
Message-ID: <52282A6E.1020902@jp.fujitsu.com>
Date: Thu, 05 Sep 2013 15:53:34 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: chris.mason@fusionio.com, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH v2 1/3] btrfs-progs: error if device for mkfs is too small
References: <522829F5.5050405@jp.fujitsu.com>
In-Reply-To: <522829F5.5050405@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Eric pointed out that mkfs abort if specified volume is too small:

  # truncate --size=2m testfile
  # ./mkfs.btrfs testfile
   :
  SMALL VOLUME: forcing mixed metadata/data groups
  mkfs.btrfs: volumes.c:852: btrfs_alloc_chunk: Assertion `!(ret)' failed.
  Aborted (core dumped)

As the first step to fix problems around there, let mkfs to report
error if the size of target volume is less than the size of the first
system block group, BTRFS_MKFS_SYSTEM_GROUP_SIZE (= 4MB).

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 mkfs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index b412b7e..a98fe54 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1422,6 +1422,12 @@ int main(int ac, char **av)
 		}
 	}
 
+	/* To create the first block group and chunk 0 in make_btrfs */
+	if (dev_block_count < BTRFS_MKFS_SYSTEM_GROUP_SIZE) {
+		fprintf(stderr, "device is too small to make filesystem\n");
+		exit(1);
+	}
+
 	blocks[0] = BTRFS_SUPER_INFO_OFFSET;
 	for (i = 1; i < 7; i++) {
 		blocks[i] = BTRFS_SUPER_INFO_OFFSET + 1024 * 1024 +
-- 
1.7.1


