Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35178 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbbCWRgM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 13:36:12 -0400
From: Tom Van Braeckel <tomvanbraeckel@gmail.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tom Van Braeckel <tomvanbraeckel@gmail.com>,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] btrfs: explicitly set control file's private_data
Date: Mon, 23 Mar 2015 18:34:13 +0100
Message-Id: <1427132053-410-1-git-send-email-tomvanbraeckel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The private_data member of the Btrfs control device file
(/dev/btrfs-control) is used to hold the current transaction and needs
to be initialized to NULL to signify that no transaction is in progress.

We explicitly set the control file's private_data to NULL to be
independent of whatever value the misc subsystem initializes it to.

Backstory:
----------

The misc subsystem (which is used by /dev/btrfs-control) initializes
a file's private_data to point to the misc device when a driver has
registered a custom open file operation and initializes it to NULL
when a custom open file operation has *not* been provided.

This subtle quirk is confusing, to the point where kernel code registers
*empty* file open operations to have private_data point to the misc
device structure.

And it leads to bugs, where the addition or removal of a custom open
file operation surprisingly changes the initial contents of a file's
private_data structure.

To simplify things in the misc subsystem, a patch [1] has been proposed
to *always* set private_data to point to the misc device instead of
only doing this when a custom open file operation has been registered.

But before we can fix this in the misc subsystem itself, we need to
modify the (few) drivers that rely on this very subtle behavior.

[1] https://lkml.org/lkml/2014/12/4/939

Signed-off-by: Martin Kepplinger <martink@posteo.de>
Signed-off-by: Tom Van Braeckel <tomvanbraeckel@gmail.com>
---
 fs/btrfs/super.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 05fef19..3cfb5ee 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1908,6 +1908,16 @@ static struct file_system_type btrfs_fs_type = {
 };
 MODULE_ALIAS_FS("btrfs");
 
+static int btrfs_control_open(struct inode *inode, struct file *file)
+{
+	/* The control file's private_data is used to hold the
+	 * transaction when it is started and is used to keep
+	 * track of whether a transaction is already in progress.
+	 */
+	file->private_data = NULL;
+	return 0;
+}
+
 /*
  * used by btrfsctl to scan devices when no FS is mounted
  */
@@ -2009,6 +2019,7 @@ static const struct super_operations btrfs_super_ops = {
 };
 
 static const struct file_operations btrfs_ctl_fops = {
+	.open = btrfs_control_open,
 	.unlocked_ioctl	 = btrfs_control_ioctl,
 	.compat_ioctl = btrfs_control_ioctl,
 	.owner	 = THIS_MODULE,
-- 
2.1.0

