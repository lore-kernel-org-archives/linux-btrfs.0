Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:58578 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbbAIUgQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jan 2015 15:36:16 -0500
Received: by mail-pd0-f175.google.com with SMTP id g10so19371023pdj.6
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jan 2015 12:36:16 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH RESEND v8 3/3] btrfs: fix suspicious RCU in BTRFS_IOC_DEV_INFO
Date: Fri,  9 Jan 2015 12:36:00 -0800
Message-Id: <0c10b4554b91ba49e4b7e2500a17a7961e7ee63e.1420834567.git.osandov@osandov.com>
In-Reply-To: <cover.1420834567.git.osandov@osandov.com>
References: <cover.1420834567.git.osandov@osandov.com>
In-Reply-To: <cover.1420834567.git.osandov@osandov.com>
References: <cover.1420834567.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A naked read of the value of an RCU pointer isn't safe. Put the whole
access in an RCU critical section, not just the pointer dereference.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7ca1cad..ee2528e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2706,6 +2706,7 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	int ret = 0;
 	char *s_uuid = NULL;
+	struct rcu_string *name;
 
 	di_args = memdup_user(arg, sizeof(*di_args));
 	if (IS_ERR(di_args))
@@ -2726,17 +2727,16 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 	di_args->bytes_used = btrfs_device_get_bytes_used(dev);
 	di_args->total_bytes = btrfs_device_get_total_bytes(dev);
 	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
-	if (dev->name) {
-		struct rcu_string *name;
 
-		rcu_read_lock();
-		name = rcu_dereference(dev->name);
+	rcu_read_lock();
+	name = rcu_dereference(dev->name);
+	if (name) {
 		strncpy(di_args->path, name->str, sizeof(di_args->path));
-		rcu_read_unlock();
 		di_args->path[sizeof(di_args->path) - 1] = 0;
 	} else {
 		di_args->path[0] = '\0';
 	}
+	rcu_read_unlock();
 
 out:
 	mutex_unlock(&fs_devices->device_list_mutex);
-- 
2.2.1

