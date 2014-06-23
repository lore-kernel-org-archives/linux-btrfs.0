Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52489 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaFWLBa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 07:01:30 -0400
Received: by mail-wi0-f171.google.com with SMTP id n15so3990585wiw.10
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 04:01:27 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 5/6 v5] Btrfs: add missing cleanup on sysfs init failure
Date: Mon, 23 Jun 2014 13:01:11 +0100
Message-Id: <1403524871-2131-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1398002808-11080-1-git-send-email-fdmanana@gmail.com>
References: <1398002808-11080-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we failed during initialization of sysfs, we weren't unregistering the
top level btrfs sysfs entry nor the debugfs stuff.
Not unregistering the top level sysfs entry makes future attempts to reload
the btrfs module impossible and the following is reported in dmesg:

[ 2246.451296] WARNING: CPU: 3 PID: 10999 at fs/sysfs/dir.c:486 sysfs_warn_dup+0x91/0xb0()
[ 2246.451298] sysfs: cannot create duplicate filename '/fs/btrfs'
[ 2246.451298] Modules linked in: btrfs(+) raid6_pq xor bnep rfcomm bluetooth binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc parport_pc parport psmouse serio_raw pcspkr evbug i2c_piix4 e1000 floppy [last unloaded: btrfs]
[ 2246.451310] CPU: 3 PID: 10999 Comm: modprobe Tainted: G        W    3.13.0-fdm-btrfs-next-24+ #7
[ 2246.451311] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 2246.451312]  0000000000000009 ffff8800d353fa08 ffffffff816f1da6 0000000000000410
[ 2246.451314]  ffff8800d353fa58 ffff8800d353fa48 ffffffff8104a32c ffff88020821a290
[ 2246.451316]  ffff88020821a290 ffff88020821a290 ffff8802148f0000 ffff8800d353fb80
[ 2246.451318] Call Trace:
[ 2246.451322]  [<ffffffff816f1da6>] dump_stack+0x4e/0x68
[ 2246.451324]  [<ffffffff8104a32c>] warn_slowpath_common+0x8c/0xc0
[ 2246.451325]  [<ffffffff8104a416>] warn_slowpath_fmt+0x46/0x50
[ 2246.451328]  [<ffffffff81367dc5>] ? strlcat+0x65/0x90
(....)

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V1..V4: There's no v1, v2, v3 and v4. Bumped directly to v5 to make all patches
    in the series have the same version.
V5: Rebased against latest chris/integration branch.

 fs/btrfs/sysfs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index df39458..06ad529 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -710,10 +710,18 @@ int btrfs_init_sysfs(void)
 
 	ret = btrfs_init_debugfs();
 	if (ret)
-		return ret;
+		goto out1;
 
 	init_feature_attrs();
 	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
+	if (ret)
+		goto out2;
+
+	return 0;
+out2:
+	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
+out1:
+	kset_unregister(btrfs_kset);
 
 	return ret;
 }
-- 
1.9.1

