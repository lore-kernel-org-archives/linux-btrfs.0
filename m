Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34108 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbcDNWVT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 18:21:19 -0400
Received: by mail-pa0-f65.google.com with SMTP id hb4so7782228pac.1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 15:21:19 -0700 (PDT)
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: linux-btrfs@vger.kernel.org
Cc: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
Subject: [PATCH] btrfs-progs: Check if the FSID was seen by comparing full UUID
Date: Thu, 14 Apr 2016 15:21:11 -0700
Message-Id: <1460672471-12433-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

is_seen_fsid() uses simple hash to check if FS was seen before at
walking on FS list in 'filesystem show' command: hash key is first byte
of the UUID. This function doesn't check full UUID then, so, if there
are two FS with same first byte in UUIDs exist, only one will be shown:

root@test:~# btrfs fi show
Label: 'System'  uuid: 688cb918-7bac-4c8e-9b11-8d047eb14cf4
        Total devices 2 FS bytes used 1.76GiB
        devid    1 size 3.46TiB used 4.01GiB path /dev/sda2
        devid    2 size 6.91TiB used 4.01GiB path /dev/sdb2

Global spare

root@test:~# grep btrfs /proc/mounts
/dev/sda2 / btrfs rw,relatime,space_cache,subvolid=256,subvol=/root 0 0
/dev/sdc /media/688cb918-7bac-4c8e-9b11-8d047eb14cf4 btrfs rw,relatime,space_cache,subvolid=5,subvol=/ 0 0

root@test:~# btrfs fi show --all-devices
Label: 'System'  uuid: 688cb918-7bac-4c8e-9b11-8d047eb14cf4
        Total devices 2 FS bytes used 1.76GiB
        devid    1 size 3.46TiB used 4.03GiB path /dev/sda2
        devid    2 size 6.91TiB used 4.01GiB path /dev/sdb2

Label: 'test'  uuid: 683b1a80-ca7f-4c4d-b87b-7155401a4d18
        Total devices 7 FS bytes used 2.06MiB
        devid    1 size 7.28TiB used 1.57GiB path /dev/sdc
        devid    2 size 7.28TiB used 1.57GiB path /dev/sdd
        devid    3 size 7.28TiB used 1.57GiB path /dev/sde
        devid    4 size 7.28TiB used 1.57GiB path /dev/sdf
        devid    5 size 7.28TiB used 1.57GiB path /dev/sdg
        devid    6 size 7.28TiB used 1.57GiB path /dev/sdh
        devid    7 size 7.28TiB used 1.57GiB path /dev/sdi

To resolve this collision, search for full FSID in the list of seen
filesystems.

Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
---
 cmds-filesystem.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f8fc764..97b2645 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -58,7 +58,14 @@ static int is_seen_fsid(u8 *fsid)
 	int slot = hash % SEEN_FSID_HASH_SIZE;
 	struct seen_fsid *seen = seen_fsid_hash[slot];
 
-	return seen ? 1 : 0;
+	while (seen) {
+		if (memcmp(seen->fsid, fsid, BTRFS_FSID_SIZE) == 0)
+			return 1;
+
+		seen = seen->next;
+	}
+
+	return 0;
 }
 
 static int add_seen_fsid(u8 *fsid)
-- 
2.5.0

