Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27666 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932136AbaKMJnG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 04:43:06 -0500
Message-ID: <54647C9C.3030000@cn.fujitsu.com>
Date: Thu, 13 Nov 2014 17:40:44 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Cyril Scetbon <cyril.scetbon@free.fr>, Duncan <1i5t5.duncan@cox.net>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Quota question
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr> <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr> <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net> <CCA13B0E-D1EE-44D8-A634-FD17C2B22C72@free.fr> <pan$648cb$e6ca8d21$192128f6$95e500d3@cox.net> <967D58C4-46E1-4508-A5A9-A0835C18E87D@free.fr> <EE8501C5-2A50-4E93-89F5-C08E28CE71DB@free.fr> <928A4C3A-2CE4-48E5-8831-BE6C1685ED8B@free.fr> <5464200D.1010600@cn.fujitsu.com>
In-Reply-To: <5464200D.1010600@cn.fujitsu.com>
Content-Type: multipart/mixed;
	boundary="------------080008050304020101020007"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------080008050304020101020007
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/2014 11:05 AM, Dongsheng Yang wrote:
> On 11/12/2014 10:04 PM, Cyril Scetbon wrote:
>> Anyone on this ? There is an issue with quotas depending on the write 
>> rate. The more we can write before a sync, the more we can exceed 
>> quotas limits
>
> Hi Cyril, I attempted to reproduce the problem you reported in 
> Linux.3.17, but failed.
> It seems that the issue in this thread was fixed already. Could you 
> test on Linux.3.17 or later version?

Hi Cyril, after some more investigation, there actually is a problem you 
described here.

*reason*
The logic in fallocate to update qgroup->excl here is:
1). btrfs_qgroup_reserve(). It reserves N_bytes.
2). btrfs_prealloc_file_range(). It record a qgroup ref into 
trans->qgroup_ref_list.
3). btrfs_qgroup_free(). It clear the N_bytes from reservation.
... ...
commit_transaction().

Similar logic in writing data.

Currently qgroup->excl is updated in qgroup_excl_accounting and it is 
called in commit_transation().
It means there probably is a *window* between btrfs_qgroup_free() and 
commit_transaction() where
the N_bytes is not accounted into qgroup. In this *window*, more data 
request will be accepted
even the total size of these requests exceeds the limit, and qgroup 
can't realize it.

There is a quick fix attached on this mail, it delays the reserve_free 
operation after updating qgroup->excl.

*NOTE*
It is just a quick fix for your problem here, could you help to test is 
on your box? Patch is based on
Linux 3.17 (bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9).

More work about btrfs quota is on the TODO list.

Thanx
>
> Below is my log:
> [root@atest-guest linux_btrfs]# uname -a
> Linux atest-guest 3.17.0+ #60 SMP Thu Nov 13 06:51:55 EST 2014 x86_64 
> x86_64 x86_64 GNU/Linux
> [root@atest-guest linux_btrfs]# btrfs qgroup show -e /mnt
> qgroupid rfer  excl  max_excl
> -------- ----  ----  --------
> 0/5      16384 16384 0
> [root@atest-guest linux_btrfs]# btrfs sub create /mnt/sub
> Create subvolume '/mnt/sub'
> [root@atest-guest linux_btrfs]# sync
> [root@atest-guest linux_btrfs]# btrfs qgroup show -e /mnt
> qgroupid rfer  excl  max_excl
> -------- ----  ----  --------
> 0/5      16384 16384 0
> 0/257    16384 16384 0
> [root@atest-guest linux_btrfs]# btrfs qgroup limit -e 300M /mnt/sub
> [root@atest-guest linux_btrfs]# btrfs qgroup show -e /mnt
> qgroupid rfer  excl  max_excl
> -------- ----  ----  --------
> 0/5      16384 16384 0
> 0/257    16384 16384 314572800
> [root@atest-guest linux_btrfs]# for((i=0;i<10;i++));do dd if=/dev/zero 
> of=/mnt/sub/data$i bs=6M count=10; done
> 10+0 records in
> 10+0 records out
> 62914560 bytes (63 MB) copied, 0.0401096 s, 1.6 GB/s
> 10+0 records in
> 10+0 records out
> 62914560 bytes (63 MB) copied, 0.0431105 s, 1.5 GB/s
> 10+0 records in
> 10+0 records out
> 62914560 bytes (63 MB) copied, 0.0407304 s, 1.5 GB/s
> 10+0 records in
> 10+0 records out
> 62914560 bytes (63 MB) copied, 0.041441 s, 1.5 GB/s
> dd: error writing \u2018/mnt/sub/data4\u2019: Disk quota exceeded
> 10+0 records in
> 9+0 records out
> 60817408 bytes (61 MB) copied, 0.0398122 s, 1.5 GB/s
> dd: error writing \u2018/mnt/sub/data5\u2019: Disk quota exceeded
> 1+0 records in
> 0+0 records out
> 1703936 bytes (1.7 MB) copied, 0.00318793 s, 534 MB/s
> dd: error writing \u2018/mnt/sub/data6\u2019: Disk quota exceeded
> 1+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.00239674 s, 0.0 kB/s
> dd: error writing \u2018/mnt/sub/data7\u2019: Disk quota exceeded
> 1+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.002271 s, 0.0 kB/s
> dd: error writing \u2018/mnt/sub/data8\u2019: Disk quota exceeded
> 1+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.00232063 s, 0.0 kB/s
> dd: error writing \u2018/mnt/sub/data9\u2019: Disk quota exceeded
> 1+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.00185336 s, 0.0 kB/s
> [root@atest-guest linux_btrfs]# sync
> [root@atest-guest linux_btrfs]# btrfs qgroup show -e /mnt
> qgroupid rfer      excl      max_excl
> -------- ----      ----      --------
> 0/5      16384     16384     0
> 0/257    314195968 314195968 314572800
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
>


--------------080008050304020101020007
Content-Type: text/x-patch;
	name="0001-btrfs-free-quota-reserved-in-delay_ref-handler.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-btrfs-free-quota-reserved-in-delay_ref-handler.patch"

>From 8d203d87385fa56753832864ff462ad8b61b7c8f Mon Sep 17 00:00:00 2001
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Date: Thu, 13 Nov 2014 12:56:06 -0500
Subject: [PATCH] btrfs: free quota reserved in delay_ref handler

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/file.c        |  2 +-
 fs/btrfs/qgroup.c      | 23 +++++++++++++++++++++--
 fs/btrfs/qgroup.h      |  1 +
 4 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3efe1c3..7b27ff6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5300,7 +5300,7 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 	trace_btrfs_space_reservation(root->fs_info, "delalloc",
 				      btrfs_ino(inode), to_free, 0);
 	if (root->fs_info->quota_enabled) {
-		btrfs_qgroup_free(root, num_bytes +
+		btrfs_qgroup_delayed_free(root, num_bytes +
 					dropped * root->leafsize);
 	}
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ff1cc03..58b5237 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2609,7 +2609,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 out:
 	mutex_unlock(&inode->i_mutex);
 	if (root->fs_info->quota_enabled)
-		btrfs_qgroup_free(root, alloc_end - alloc_start);
+		btrfs_qgroup_delayed_free(root, alloc_end - alloc_start);
 out_reserve_fail:
 	/* Let go of our reservation. */
 	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index ded5c60..1329500 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -73,6 +73,7 @@ struct btrfs_qgroup {
 	 * reservation tracking
 	 */
 	u64 reserved;
+	u64 delayed_release;
 
 	/*
 	 * lists
@@ -1409,6 +1410,11 @@ static int qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	qgroup->excl += sign * oper->num_bytes;
 	qgroup->excl_cmpr += sign * oper->num_bytes;
 
+	if (qgroup->delayed_release) {
+		qgroup->reserved -= qgroup->delayed_release;
+		qgroup->delayed_release = 0;
+	}
+
 	qgroup_dirty(fs_info, qgroup);
 
 	/* Get all of the parent groups that contain this qgroup */
@@ -2440,7 +2446,7 @@ out:
 	return ret;
 }
 
-void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
+static void qgroup_free(struct btrfs_root *root, u64 num_bytes, int delay)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
@@ -2478,7 +2484,10 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 
 		qg = u64_to_ptr(unode->aux);
 
-		qg->reserved -= num_bytes;
+		if (delay)
+			qg->delayed_release += num_bytes;
+		else
+			qg->reserved -= num_bytes;
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
@@ -2493,6 +2502,16 @@ out:
 	spin_unlock(&fs_info->qgroup_lock);
 }
 
+void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
+{
+	return qgroup_free(root, num_bytes, 0);
+}
+
+void btrfs_qgroup_delayed_free(struct btrfs_root *root, u64 num_bytes)
+{
+	return qgroup_free(root, num_bytes, 1);
+}
+
 void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
 {
 	if (list_empty(&trans->qgroup_ref_list) && !trans->delayed_ref_elem.seq)
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 18cc68c..1c50238 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -97,6 +97,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_qgroup_inherit *inherit);
 int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes);
 void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes);
+void btrfs_qgroup_delayed_free(struct btrfs_root *root, u64 num_bytes);
 
 void assert_qgroups_uptodate(struct btrfs_trans_handle *trans);
 
-- 
1.8.3.1


--------------080008050304020101020007--
