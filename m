Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41120 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab3GYJcv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 05:32:51 -0400
Received: by mail-pd0-f182.google.com with SMTP id r10so1476874pdi.41
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 02:32:51 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] btrfs-progs: fix segfault when listing column OTIME on big endian host
Date: Thu, 25 Jul 2013 17:32:29 +0800
Message-Id: <1374744749-12231-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The second btrfs command segfaults on big endian host(ppc64)

	btrfs subvolume snapshot /mnt/btrfs /mnt/btrfs/snap
	btrfs subvolume list -s /mnt/btrfs

And ltrace shows

	localtime(0x10029c482d0)                 = 0
	strftime( <no return ...>
	--- SIGSEGV (Segmentation fault) ---

The corresponding code

btrfs-list.c:
        case BTRFS_LIST_OTIME:
                if (subv->otime)
                        strftime(tstr, 256, "%Y-%m-%d %X",
                                 localtime(&subv->otime));
                else
                        strcpy(tstr, "-");
                printf("%s", tstr);
                break;

localtime() returned NULL then strftime() got SIGSEGV.

The reason is that ri->otime.sec is stored as little endian but
assigned to 't' without conversion.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 btrfs-list.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 4fab858..ca1bae8 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1052,7 +1052,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 				flags = btrfs_root_flags(ri);
 				if(sh.len >
 				   sizeof(struct btrfs_root_item_v0)) {
-					t = ri->otime.sec;
+					t = le64_to_cpu(ri->otime.sec);
 					ogen = btrfs_root_otransid(ri);
 					memcpy(uuid, ri->uuid, BTRFS_UUID_SIZE);
 					memcpy(puuid, ri->parent_uuid, BTRFS_UUID_SIZE);
-- 
1.8.3.1

