Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:64513 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3C1Les (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 07:34:48 -0400
Received: by mail-pb0-f52.google.com with SMTP id ma3so5762237pbc.25
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 04:34:48 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, wangsl-fnst@cn.fujitsu.com, wangshilong1991@gmail.com
Subject: [PATCH] Btrfs: fix a warning when disabling quota
Date: Thu, 28 Mar 2013 19:34:41 +0800
Message-Id: <1364470481-1952-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Steps to reproduce:
	mkfs.btrfs <disk>
	mount <disk> <mnt>
	btrfs quota enable <mnt>
	btrfs sub create <mnt>/subv

	i=1
	while [ $i -le 10000 ]
	do
		dd if=/dev/zero of=<mnt>/subv/data_$i bs=1K count=1
		i=$(($i+1))
		if [ $i -eq 500 ]
		then
			btrfs quota disable $mnt
		fi
	done
	dmesg
Obviously, this warn_on() is unnecessary, and it will be easily triggered.
Just remove it.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 14fca77..0d37b1f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -423,8 +423,6 @@ void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info)
 		qgroup = rb_entry(n, struct btrfs_qgroup, node);
 		rb_erase(n, &fs_info->qgroup_tree);
 
-		WARN_ON(!list_empty(&qgroup->dirty));
-
 		while (!list_empty(&qgroup->groups)) {
 			list = list_first_entry(&qgroup->groups,
 						struct btrfs_qgroup_list,
-- 
1.7.7.6

