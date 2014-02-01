Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:53231 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbaBACCc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 21:02:32 -0500
Received: by mail-we0-f178.google.com with SMTP id q59so284502wes.9
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jan 2014 18:02:31 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: more send support for parent/child dir relationship inversion
Date: Sat,  1 Feb 2014 02:02:16 +0000
Message-Id: <1391220136-22034-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The commit titled "Btrfs: fix infinite path build loops in incremental send"
didn't cover a particular case where the parent-child relationship inversion
of directories doesn't imply a rename of the new parent directory. This was
due to a simple logic mistake, a logical and instead of a logical or.

Steps to reproduce:

  $ mkfs.btrfs -f /dev/sdb3
  $ mount /dev/sdb3 /mnt/btrfs
  $ mkdir -p /mnt/btrfs/a/b/bar1/bar2/bar3/bar4
  $ btrfs subvol snapshot -r /mnt/btrfs /mnt/btrfs/snap1
  $ mv /mnt/btrfs/a/b/bar1/bar2/bar3/bar4 /mnt/btrfs/a/b/k44
  $ mv /mnt/btrfs/a/b/bar1/bar2/bar3 /mnt/btrfs/a/b/k44
  $ mv /mnt/btrfs/a/b/bar1/bar2 /mnt/btrfs/a/b/k44/bar3
  $ mv /mnt/btrfs/a/b/bar1 /mnt/btrfs/a/b/k44/bar3/bar2/k11
  $ btrfs subvol snapshot -r /mnt/btrfs /mnt/btrfs/snap2
  $ btrfs send -p /mnt/btrfs/snap1 /mnt/btrfs/snap2 > /tmp/incremental.send

A patch to update the test btrfs/030 from xfstests, so that it covers
this case, will be submitted soon.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e0b49f6..c47fcef 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3041,8 +3041,8 @@ static int wait_for_parent_move(struct send_ctx *sctx,
 
 	len1 = fs_path_len(path_before);
 	len2 = fs_path_len(path_after);
-	if ((parent_ino_before != parent_ino_after) && (len1 != len2 ||
-	     memcmp(path_before->start, path_after->start, len1))) {
+	if (parent_ino_before != parent_ino_after || len1 != len2 ||
+	     memcmp(path_before->start, path_after->start, len1)) {
 		ret = 1;
 		goto out;
 	}
-- 
1.7.9.5

