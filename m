Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63295 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3GYONt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 10:13:49 -0400
Received: by mail-pa0-f45.google.com with SMTP id bg4so2038701pad.18
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 07:13:48 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH v2] btrfs-progs: fix segfault when listing column OTIME on big endian host
Date: Thu, 25 Jul 2013 22:12:01 +0800
Message-Id: <1374761521-17603-1-git-send-email-guaneryu@gmail.com>
In-Reply-To: <51F10A50.9010308@cn.fujitsu.com>
References: <51F10A50.9010308@cn.fujitsu.com>
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
v1->v2:
  use btrfs_stack_timespec_sec() instead of raw convert.
  Thanks Miao Xie <miaox@cn.fujitsu.com> for pointing this out.

 btrfs-list.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 4fab858..9deddd5 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1052,7 +1052,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
 				flags = btrfs_root_flags(ri);
 				if(sh.len >
 				   sizeof(struct btrfs_root_item_v0)) {
-					t = ri->otime.sec;
+					t = btrfs_stack_timespec_sec(&ri->otime);
 					ogen = btrfs_root_otransid(ri);
 					memcpy(uuid, ri->uuid, BTRFS_UUID_SIZE);
 					memcpy(puuid, ri->parent_uuid, BTRFS_UUID_SIZE);
-- 
1.8.3.1

