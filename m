Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:43657 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727026AbeGUGwt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Jul 2018 02:52:49 -0400
Date: Sat, 21 Jul 2018 14:01:13 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Anand Jain <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] btrfs: fix missing superblock update in the
 device delete commit transaction
Message-ID: <20180721060113.GC575@fnst.localdomain>
References: <20180703090724.22023-1-anand.jain@oracle.com>
 <20180703090724.22023-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180703090724.22023-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 05:07:24PM +0800, Anand Jain wrote:
>When a device is deleted, the btrfs_super_block::number_devices is
>reduced by 1, but we do that after the commit transaction, so this
>change did not made it to the disk and waits for the next commit
>transaction whenever it happens.
>
>This can be easily demonstrated using the following test case where I
>use the btrfs device ready cli to read the disk and report.
>
>  mkfs.btrfs -fq -dsingle -msingle $dev1 $dev2
>  mount $dev1 /btrfs
>  btrfs dev del $dev2 /btrfs
>  btrfs dev ready $dev1; echo RESULT=$? <-- 1
>   Without this patch RESULT returns 1, indicating not ready!
>
>  Testing with a seed device:
>
>  mkfs.btrfs -fq $dev1
>  btrfstune -S1 $dev1
>  mount $dev1 /btrfs
>  btrfs dev add -f $dev2 /btrfs
>  umount /btrfs
>  mount $dev2 /btrfs
>  btrfs dev del $dev1 /btrfs
>  btrfs dev ready $dev2; echo RESULT=$? <-- 1
>
>  Fix this by bringing in the num_devices update with in the
>  current commit transaction.
>  Also align the local variable declarations in the function
>  btrfs_rm_dev_item()
>  Delete a todo comment about transient inconsistent state

Hi, Anand

The btrfs/164 failed when I run xfstests with kdave/misc-next. And the
result of git bisect shows this patch may be the cause. Please see the
following log and dmesg.

xfstests log:
# sudo ./check btrfs/164
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 larch 4.18.0-rc5+
MKFS_OPTIONS  -- /dev/vdb2
MOUNT_OPTIONS -- /dev/vdb2 /mnt/scratch

btrfs/164 14s ... [failed, exit status 1]

dmesg:
[  212.009967] general protection fault: 0000 [#1] SMP PTI
[  212.015834] CPU: 1 PID: 5665 Comm: btrfs Tainted: G           O      4.18.0-rc5+ #2
[  212.021985] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  212.031137] RIP: 0010:btrfs_update_commit_device_size+0x74/0xd0 [btrfs]
[  212.036659] Code: ef e8 60 cc 72 e1 49 8b 96 08 01 00 00 48 8b 0a 48 8d 82 d8 fe ff ff 48 8d b1 d8 fe ff ff 49 39 d4 74 47 48 8b b8 30 01 00 00 <48> 89 79 08 48 89 0f 48 89 90 28 01 00 00 48 89 90 30 01 00 00 48
[  212.052862] RSP: 0018:ffffc90000c3bbc0 EFLAGS: 00010202
[  212.057537] RAX: ffff88004d45ea88 RBX: ffff88005f246820 RCX: 6b6b6b6b6b6b6b6b
[  212.066491] RDX: ffff88004d45ebb0 RSI: 6b6b6b6b6b6b6a43 RDI: 6b6b6b6b6b6b6b6b
[  212.072735] RBP: ffffc90000c3bbe0 R08: 0000000000000000 R09: 0000000000000001
[  212.078961] R10: ffffc90000c3bbb0 R11: ffffffff82ea2800 R12: ffff88005f2468d0
[  212.084967] R13: ffff880066e4c910 R14: ffff88005f2467c8 R15: ffff880066e4d138
[  212.093457] FS:  00007fca3f6e08c0(0000) GS:ffff88007f800000(0000) knlGS:0000000000000000
[  212.099305] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  212.103643] CR2: 00007fdd21385f88 CR3: 0000000075c4e000 CR4: 00000000000006e0
[  212.108514] Call Trace:
[  212.110829]  btrfs_commit_transaction+0x525/0x980 [btrfs]
[  212.114745]  btrfs_rm_device+0x527/0x560 [btrfs]
[  212.118082]  btrfs_ioctl+0x2e99/0x31e0 [btrfs]
[  212.123417]  ? __lock_acquire+0x396/0x1910
[  212.126360]  ? __might_fault+0x3e/0x90
[  212.128924]  ? __might_fault+0x85/0x90
[  212.131398]  ? _copy_to_user+0x65/0x80
[  212.133870]  ? cp_new_stat+0x120/0x150
[  212.136354]  ? native_sched_clock+0x3e/0xa0
[  212.138825]  do_vfs_ioctl+0xa9/0x6c0
[  212.141175]  ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
[  212.144476]  ? do_vfs_ioctl+0xa9/0x6c0
[  212.146889]  ? trace_hardirqs_on+0xd/0x10
[  212.149210]  ksys_ioctl+0x67/0x90
[  212.151499]  __x64_sys_ioctl+0x1a/0x20
[  212.154064]  do_syscall_64+0x6d/0x690
[  212.156146]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[  212.158720]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  212.161363] RIP: 0033:0x7fca3e4c1667
[  212.163437] Code: 00 00 90 48 8b 05 e9 67 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b9 67 2c 00 f7 d8 64 89 01 48
[  212.172921] RSP: 002b:00007ffffaf1ba08 EFLAGS: 00000202 ORIG_RAX: 0000000000000010
[  212.176599] RAX: ffffffffffffffda RBX: 00007ffffaf1dbd0 RCX: 00007fca3e4c1667
[  212.179912] RDX: 00007ffffaf1ca30 RSI: 000000005000943a RDI: 0000000000000003
[  212.184742] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  212.188250] R10: fffffffffffff807 R11: 0000000000000202 R12: 00007ffffaf1dbd0
[  212.191810] R13: 0000000000000000 R14: 0000000000000003 R15: 00007ffffaf1dbd8
[  212.195309] Modules linked in: btrfs(O) xor zstd_decompress zstd_compress xxhash raid6_pq efivarfs xfs virtio_scsi [last unloaded: xor]
[  212.201294] ---[ end trace d9007c0cfa00d04e ]---
[  212.203760] RIP: 0010:btrfs_update_commit_device_size+0x74/0xd0 [btrfs]
[  212.207008] Code: ef e8 60 cc 72 e1 49 8b 96 08 01 00 00 48 8b 0a 48 8d 82 d8 fe ff ff 48 8d b1 d8 fe ff ff 49 39 d4 74 47 48 8b b8 30 01 00 00 <48> 89 79 08 48 89 0f 48 89 90 28 01 00 00 48 89 90 30 01 00 00 48
[  212.221356] RSP: 0018:ffffc90000c3bbc0 EFLAGS: 00010202
[  212.224982] RAX: ffff88004d45ea88 RBX: ffff88005f246820 RCX: 6b6b6b6b6b6b6b6b
[  212.229116] RDX: ffff88004d45ebb0 RSI: 6b6b6b6b6b6b6a43 RDI: 6b6b6b6b6b6b6b6b
[  212.233170] RBP: ffffc90000c3bbe0 R08: 0000000000000000 R09: 0000000000000001
[  212.237057] R10: ffffc90000c3bbb0 R11: ffffffff82ea2800 R12: ffff88005f2468d0
[  212.240578] R13: ffff880066e4c910 R14: ffff88005f2467c8 R15: ffff880066e4d138
[  212.244531] FS:  00007fca3f6e08c0(0000) GS:ffff88007f800000(0000) knlGS:0000000000000000
[  212.249183] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  212.252270] CR2: 00007fdd21385f88 CR3: 0000000075c4e000 CR4: 00000000000006e0
[  513.015417] kworker/dying (7) used greatest stack depth: 10056 bytes left

-- 
Thanks,
Lu

>
>Signed-off-by: Anand Jain <anand.jain@oracle.com>
>---
>v1->v2:
> Delete a todo comment
> Refactor btrfs_rm_dev_item to use trans->fs_info and drop fs_info in
>the argument
> 
> fs/btrfs/volumes.c | 46 +++++++++++++++++++---------------------------
> 1 file changed, 19 insertions(+), 27 deletions(-)
>
>diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>index b5a60ab37a1c..1bdfd5e05bb5 100644
>--- a/fs/btrfs/volumes.c
>+++ b/fs/btrfs/volumes.c
>@@ -1822,47 +1822,32 @@ static void update_dev_time(const char *path_name)
> 	filp_close(filp, NULL);
> }
> 
>-static int btrfs_rm_dev_item(struct btrfs_fs_info *fs_info,
>+static int btrfs_rm_dev_item(struct btrfs_trans_handle *trans,
> 			     struct btrfs_device *device)
> {
>-	struct btrfs_root *root = fs_info->chunk_root;
>-	int ret;
>+	struct btrfs_root *root = trans->fs_info->chunk_root;
> 	struct btrfs_path *path;
> 	struct btrfs_key key;
>-	struct btrfs_trans_handle *trans;
>+	int ret;
> 
> 	path = btrfs_alloc_path();
> 	if (!path)
> 		return -ENOMEM;
> 
>-	trans = btrfs_start_transaction(root, 0);
>-	if (IS_ERR(trans)) {
>-		btrfs_free_path(path);
>-		return PTR_ERR(trans);
>-	}
> 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
> 	key.type = BTRFS_DEV_ITEM_KEY;
> 	key.offset = device->devid;
> 
> 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
>-	if (ret) {
>-		if (ret > 0)
>-			ret = -ENOENT;
>-		btrfs_abort_transaction(trans, ret);
>-		btrfs_end_transaction(trans);
>+	if (ret > 0) {
>+		ret = -ENOENT;
> 		goto out;
> 	}
> 
> 	ret = btrfs_del_item(trans, root, path);
>-	if (ret) {
>-		btrfs_abort_transaction(trans, ret);
>-		btrfs_end_transaction(trans);
>-	}
> 
> out:
> 	btrfs_free_path(path);
>-	if (!ret)
>-		ret = btrfs_commit_transaction(trans);
> 	return ret;
> }
> 
>@@ -1946,7 +1931,9 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
> 		u64 devid)
> {
> 	struct btrfs_device *device;
>+	struct btrfs_trans_handle *trans;
> 	struct btrfs_fs_devices *cur_devices;
>+	struct btrfs_root *root = fs_info->dev_root;
> 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> 	u64 num_devices;
> 	int ret = 0;
>@@ -1994,14 +1981,18 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
> 	if (ret)
> 		goto error_undo;
> 
>-	/*
>-	 * TODO: the superblock still includes this device in its num_devices
>-	 * counter although write_all_supers() is not locked out. This
>-	 * could give a filesystem state which requires a degraded mount.
>-	 */
>-	ret = btrfs_rm_dev_item(fs_info, device);
>-	if (ret)
>+	trans = btrfs_start_transaction(root, 0);
>+	if (IS_ERR(trans)) {
>+		ret = PTR_ERR(trans);
> 		goto error_undo;
>+	}
>+
>+	ret = btrfs_rm_dev_item(trans, device);
>+	if (ret) {
>+		btrfs_abort_transaction(trans, ret);
>+		btrfs_end_transaction(trans);
>+		goto error_undo;
>+	}
> 
> 	clear_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
> 	btrfs_scrub_cancel_dev(fs_info, device);
>@@ -2070,6 +2061,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
> 		free_fs_devices(cur_devices);
> 	}
> 
>+	ret = btrfs_commit_transaction(trans);
> out:
> 	mutex_unlock(&uuid_mutex);
> 	return ret;
>-- 
>2.7.0
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


