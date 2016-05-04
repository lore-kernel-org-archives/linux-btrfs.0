Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51342 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbcEDIOM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 04:14:12 -0400
Subject: Re: [PATCH] btrfs: s_bdev is not null after missing replace
To: dsterba@suse.cz
References: <1460629450-2271-1-git-send-email-anand.jain@oracle.com>
 <20160503173148.GL29353@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, yauhen.kharuzhy@zavadatar.com
Message-ID: <5729AF53.3030702@oracle.com>
Date: Wed, 4 May 2016 16:14:11 +0800
MIME-Version: 1.0
In-Reply-To: <20160503173148.GL29353@twin.jikos.cz>
Content-Type: multipart/mixed;
 boundary="------------080406070303040509040406"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080406070303040509040406
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit




On 05/04/2016 01:31 AM, David Sterba wrote:
> On Thu, Apr 14, 2016 at 06:24:10PM +0800, Anand Jain wrote:
>> Yauhen reported in the ML that s_bdev is null at mount, and
>> s_bdev gets updated to some device when missing device is
>> replaced, as because bdev is null for missing device, things
>> gets matched up. Fix this by checking if s_bdev is set. I
>> didn't want to completely remove updating s_bdev because
>> the future multi device support at vfs layer may need it.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> Reported-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
>
> Do you have a testcase for that?

  For this particular bug/fix no. As I went through the vfs
  layer to understand the s_bdev usage. It appears that s_bdev
  is used for fsync.
  But btrfs kept s_bdev NULL, which will make vfs layer to fail
  safe in that context.
  We need to continue to keep s_bdev null, even after the
  replace missing. The bug is that it didn't. As shown below.

  mkfs.btrfs -f -draid1 -mraid1 /dev/sdc /dev/sdd /dev/sde
  modprobe -r btrfs && modprobe btrfs
  mount -o degraded,device=/dev/sdc /dev/sde /btrfs
-----
  cat /proc/fs/btrfs/fsinfo  [1]
  [fsid: 60ca666b-83e8-4a28-a0cb-9b7ddb0451e2]
	sb->s_bdev:		null
	latest_bdev:		sde
-----
  btrfs repl start 2 /dev/sdf /btrfs -f

-----
cat /proc/fs/btrfs/fsinfo
[fsid: 60ca666b-83e8-4a28-a0cb-9b7ddb0451e2]
	sb->s_bdev:		sdf
	latest_bdev:		sde
-----


> As there are more patches touching the
> device pointers I'd rather see some test coverage. Thanks.

  Hm, yes the btrfs-vm test coverage needs a review at xfstests.
  Let me try.

  For my quick verifications, I have been using..
    https://github.com/asj/exercise-btrfs-volume-mgt.git
  has around quick 30+ btrfs-vm related tests. But very raw.

  Omar added test case 027 to test replace missing. The for-next
  plus 3 patches[2] passes 027 as well.

  Do you have any particular test coverage idea in mind ?

Thanks, Anand


[1]
For /proc/fs/btrfs/fsinfo see attached which should be applied
on top of the patch.
[PATCH] btrfs: procfs: devlist: introduce /proc/fs/btrfs/devlist

[2]
86eb5d598d58 btrfs: cleanup assigning next active device with a check
7b09eb01d80c btrfs: s_bdev is not null after missing replace
6237a895bc31 btrfs: fix lock dep warning move scratch super outside of 
chunk_mutex

--------------080406070303040509040406
Content-Type: text/x-patch;
 name="0003-d-btrfs-procfs-fsinfo-introduce-proc-fs-btrfs-fsinfo-f.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-d-btrfs-procfs-fsinfo-introduce-proc-fs-btrfs-fsinfo-f.";
 filename*1="patch"

>From 0411476bdf720556945457f63032aca8b3f5390e Mon Sep 17 00:00:00 2001
From: Anand Jain <anand.jain@oracle.com>
Date: Thu, 14 Apr 2016 11:28:41 +0800
Subject: [PATCH 2/2] btrfs: procfs: fsinfo: introduce /proc/fs/btrfs/fsinfo
 for debugging

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/procfs.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 70 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/procfs.c b/fs/btrfs/procfs.c
index 99edcad8a825..337ae1212130 100644
--- a/fs/btrfs/procfs.c
+++ b/fs/btrfs/procfs.c
@@ -7,9 +7,48 @@
 
 #define BTRFS_PROC_PATH		"fs/btrfs"
 #define BTRFS_PROC_DEVLIST	"devlist"
+#define BTRFS_PROC_FSINFO	"fsinfo"
 
 struct proc_dir_entry	*btrfs_proc_root;
 
+void btrfs_print_fsinfo(struct seq_file *seq)
+{
+
+	/* Btrfs Procfs String Len */
+#define BPSL	256
+#define BTRFS_SEQ_PRINT2(plist, arg)\
+		snprintf(str, BPSL, plist, arg);\
+		seq_printf(seq, str)
+
+	char str[BPSL];
+	char b[BDEVNAME_SIZE];
+	struct list_head *cur_uuid;
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_fs_devices *fs_devices;
+	struct list_head *fs_uuids = btrfs_get_fs_uuids();
+
+	seq_printf(seq, "\n#Its Experimental, parameters may change without notice.\n\n");
+
+	mutex_lock(&uuid_mutex);
+	list_for_each(cur_uuid, fs_uuids) {
+		fs_devices  = list_entry(cur_uuid, struct btrfs_fs_devices, list);
+		fs_info = fs_devices->fs_info;
+		if (!fs_info)
+			continue;
+
+		BTRFS_SEQ_PRINT2("[fsid: %pU]\n", fs_devices->fsid);
+		BTRFS_SEQ_PRINT2("\tsb->s_bdev:\t\t%s\n",
+				fs_info->sb->s_bdev ?
+				bdevname(fs_info->sb->s_bdev, b):
+				"null");
+		BTRFS_SEQ_PRINT2("\tlatest_bdev:\t\t%s\n",
+				fs_devices->latest_bdev ?
+				bdevname(fs_devices->latest_bdev, b):
+				"null");
+	}
+	mutex_unlock(&uuid_mutex);
+}
+
 void btrfs_print_devlist(struct seq_file *seq)
 {
 
@@ -120,20 +159,40 @@ again_fs_devs:
 	}
 	mutex_unlock(&uuid_mutex);
 }
+
+static int btrfs_fsinfo_show(struct seq_file *seq, void *offset)
+{
+	btrfs_print_fsinfo(seq);
+	return 0;
+}
+
 static int btrfs_devlist_show(struct seq_file *seq, void *offset)
 {
 	btrfs_print_devlist(seq);
 	return 0;
 }
 
-static int btrfs_seq_open(struct inode *inode, struct file *file)
+static int btrfs_seq_fsinfo_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, btrfs_fsinfo_show, PDE_DATA(inode));
+}
+
+static int btrfs_seq_devlist_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, btrfs_devlist_show, PDE_DATA(inode));
 }
 
-static const struct file_operations btrfs_seq_fops = {
+static const struct file_operations btrfs_seq_devlist_fops = {
 	.owner   = THIS_MODULE,
-	.open    = btrfs_seq_open,
+	.open    = btrfs_seq_devlist_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+
+static const struct file_operations btrfs_seq_fsinfo_fops = {
+	.owner   = THIS_MODULE,
+	.open    = btrfs_seq_fsinfo_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
 	.release = single_release,
@@ -142,16 +201,21 @@ static const struct file_operations btrfs_seq_fops = {
 void btrfs_init_procfs(void)
 {
 	btrfs_proc_root = proc_mkdir(BTRFS_PROC_PATH, NULL);
-	if (btrfs_proc_root)
+	if (btrfs_proc_root) {
 		proc_create_data(BTRFS_PROC_DEVLIST, S_IRUGO, btrfs_proc_root,
-					&btrfs_seq_fops, NULL);
+					&btrfs_seq_devlist_fops, NULL);
+		proc_create_data(BTRFS_PROC_FSINFO, S_IRUGO, btrfs_proc_root,
+					&btrfs_seq_fsinfo_fops, NULL);
+	}
 	return;
 }
 
 void btrfs_exit_procfs(void)
 {
-	if (btrfs_proc_root)
+	if (btrfs_proc_root) {
 		remove_proc_entry(BTRFS_PROC_DEVLIST, btrfs_proc_root);
+		remove_proc_entry(BTRFS_PROC_FSINFO, btrfs_proc_root);
+	}
 	remove_proc_entry(BTRFS_PROC_PATH, NULL);
 }
 
-- 
2.7.0


--------------080406070303040509040406--
