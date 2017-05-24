Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32435 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936017AbdEXIQD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 04:16:03 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, quwenruo@cn.fujitsu.com
Subject: [PATCH v2] vfs: add mount umount logs
Date: Wed, 24 May 2017 16:19:01 +0800
Message-Id: <20170524081901.24185-1-anand.jain@oracle.com>
In-Reply-To: <20170518100804.25538-1-anand.jain@oracle.com>
References: <20170518100804.25538-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By looking at the logs we should be able to know when was the FS
mounted and unmounted and the options used, so to help forensic
investigations.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2:
. Colin pointed out that when docker runs, this patch will create
messages which can be called as too chatty. In v2 I have fixed
that by logging only for FS of type FS_REQUIRES_DEV. So only
bind/new/re mount of FS of type FS_REQUIRES_DEV are reported now.
So logs during boot is also reduced from 25 as in v1 to 2 in v2
on the same config.
. Darrick pointed out that 256 bytes to hold logs is too big
space on the stack. So I am limiting log length to be 80. And
when it exceed 80 it would end with '..'. This applies to only
umount logs.
. Per Ted mount refcount will be useful, have added sb->s_active.
s_active value is after mount and before umount so it may be
little confusing though. I am open to suggestion if there a
better way to handle this and or a better parameter to track.
. Removed RFC tag. Thanks.

Sample log:
mount
[  490.845592] mount  btrfs dev:sdd s_active:3 flags:0 opt:(null) dir:mnt

umount
[  518.953193] umount btrfs dev:sdd s_active:2 dir:mnt

systemctl start docker && docker run.. && systemctl stop docker
[  343.936988] bind   ext4 dev:sda1 s_active:4 flags:0 opt:(null) dir:overlay2
::
[  371.033595] bind   ext4 dev:sda1 s_active:10 flags:0 opt:(null) dir:resolv.conf
[  371.039106] bind   ext4 dev:sda1 s_active:11 flags:0 opt:(null) dir:hostname
[  371.043738] bind   ext4 dev:sda1 s_active:12 flags:0 opt:(null) dir:hosts
::
[  371.322860] umount ext4 dev:sda1 s_active:12 dir:/
::
[  643.832795] umount ext4 dev:sda1 s_active:4 dir:overlay2

v1: RFC
You may want to know that, during boot and shutdown this
adds roughly 25 lines more logs depending on the config, and it
logs even for non block device FS, such as proc, sysfs ..etc.
And blockdev FS only check will eliminate overlay as well, which
is kind of defeats the purpose.
Further, just to highlight if your test script involves mount and
umount, which probably all of fstests does, it will add logs when
FS is mounted and umounted.
Still IMO, these logs are useful for the end purpose as mentioned
above. Its for your feedback. Thanks.

 fs/namespace.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 8bd3e4d448b9..2917f33a834d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1672,6 +1672,47 @@ static inline bool may_mandlock(void)
 	return capable(CAP_SYS_ADMIN);
 }
 
+static void mount_log(char *prefix, struct mount *mnt, int flags, char *data,
+			char *umntlog)
+{
+	struct super_block *sb = mnt->mnt.mnt_sb;
+
+	/*
+	 * Avoid logs from non dev based FS, mostly the FS_USERNS_MOUNT fs, so
+	 * that it will be less chatty when sandboxed ns is created.
+	 */
+	if (!(sb->s_type->fs_flags & FS_REQUIRES_DEV))
+		return;
+
+	if (umntlog) {
+		int ret;
+		/*
+		 * If mnt dir is more than we can hold in 80 bytes, we
+		 * show only as much as we could, so pls keep the dir:%pd
+		 * to the end.
+		 */
+		ret = snprintf(umntlog, 80, "%s %s dev:%s s_active:%d dir:%pd",
+				prefix, sb->s_type->name, sb->s_id,
+				atomic_read(&sb->s_active),mnt->mnt_mountpoint);
+		/* If there is truncation just add '..' to the end*/
+		if (ret)
+			strcpy(umntlog+77, "..");
+		return;
+	}
+
+	if (!strcmp(prefix, "bind ")) {
+		printk(KERN_NOTICE "%s %s dev:%s s_active:%d dir:%pd\n",
+			prefix, sb->s_type->name, sb->s_id,
+			atomic_read(&sb->s_active), mnt->mnt_mountpoint);
+		return;
+	}
+
+	/* for remount and new mount */
+	printk(KERN_NOTICE "%s %s dev:%s s_active:%d flags:%d opt:%s dir:%pd\n",
+		prefix, sb->s_type->name, sb->s_id, atomic_read(&sb->s_active),
+		flags, data, mnt->mnt_mountpoint);
+}
+
 /*
  * Now umount can handle mount points as well as block devices.
  * This is important for filesystems which use unnamed block devices.
@@ -1686,6 +1727,7 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
 	struct mount *mnt;
 	int retval;
 	int lookup_flags = 0;
+	char umntlog[80] = {0};
 
 	if (flags & ~(MNT_FORCE | MNT_DETACH | MNT_EXPIRE | UMOUNT_NOFOLLOW))
 		return -EINVAL;
@@ -1711,7 +1753,13 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
 	if (flags & MNT_FORCE && !capable(CAP_SYS_ADMIN))
 		goto dput_and_out;
 
+	mount_log("umount", mnt, 0, NULL, umntlog);
+
 	retval = do_umount(mnt, flags);
+
+	if (!retval && strlen(umntlog))
+		printk(KERN_NOTICE "%s\n", umntlog);
+
 dput_and_out:
 	/* we mustn't call path_put() as that would clear mnt_expiry_mark */
 	dput(path.dentry);
@@ -2250,6 +2298,8 @@ static int do_loopback(struct path *path, const char *old_name,
 		lock_mount_hash();
 		umount_tree(mnt, UMOUNT_SYNC);
 		unlock_mount_hash();
+	} else {
+		mount_log("bind  ", mnt, 0, NULL, NULL);
 	}
 out2:
 	unlock_mount(mp);
@@ -2339,6 +2389,10 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 		unlock_mount_hash();
 	}
 	up_write(&sb->s_umount);
+
+	if (!err)
+		mount_log("rmount", mnt, flags, (char *)data, NULL);
+
 	return err;
 }
 
@@ -2526,6 +2580,9 @@ static int do_new_mount(struct path *path, const char *fstype, int flags,
 	err = do_add_mount(real_mount(mnt), path, mnt_flags);
 	if (err)
 		mntput(mnt);
+	else
+		mount_log("mount ", real_mount(mnt), flags, (char *)data, NULL);
+
 	return err;
 }
 
-- 
2.10.0

