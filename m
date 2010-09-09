From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: kernel BUG at fs/btrfs/inode.c:2642!
Date: Thu, 9 Sep 2010 22:33:31 +0900
Message-ID: <20100909223331.362dd906.kitayama@cl.bb4u.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,
The latest mmotm on a virtual machine boots, but when I log in I get:

[   82.276418] ------------[ cut here ]------------
[   82.277565] kernel BUG at fs/btrfs/inode.c:2643!
[   82.278692] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   82.280332] last sysfs file: /sys/devices/pci0000:00/0000:00:11.0/0000:02:00.0/usb2/devnum
[   82.282323] CPU 1 
[   82.282790] Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 uinput snd_ens1371 gameport snd_rawmidi snd_ac97_codec ac97_bus snd_seq snd_seq_device snd_pcm ppdev snd_timer microcode pcspkr snd soundcore parport_pc snd_page_alloc i2c_piix4 floppy parport e1000 shpchp i2c_core mptspi mptscsih mptbase scsi_transport_spi [last unloaded: speedstep_lib]
[   82.293369] 
[   82.293818] Pid: 5572, comm: gconfd-2 Not tainted 2.6.35-rc6-mm1+ #12 440BX Desktop Reference Platform/VMware Virtual Platform
[   82.296661] RIP: 0010:[<ffffffff811b0e65>]  [<ffffffff811b0e65>] btrfs_unlink_inode+0x1bb/0x25e
[   82.298629] RSP: 0018:ffff880069f9fc18  EFLAGS: 00010282
[   82.299810] RAX: 00000000fffffffe RBX: ffff88005985b250 RCX: ffff880002840006
[   82.301394] RDX: 0000000000000006 RSI: 0000000000000003 RDI: ffff880079b0b0d8
[   82.302973] RBP: ffff880069f9fc98 R08: 0000000000000046 R09: ffff880069f9fac8
[   82.303244] old_dentry database~ new_dentry database
[   82.303283] seq number to delete is 14
[   82.303331] seq number to delete is 13
[   82.304260] old_dentry database~ new_dentry database
[   82.304298] seq number to delete is 16
[   82.304344] seq number to delete is 15
[   82.310183] R10: ffff880069f9fae8 R11: ffff880069f9fae8 R12: 00000000fffffffe
[   82.311726] R13: ffff88005985b910 R14: ffff88007a232288 R15: ffff880079b0b0d8
[   82.313286] FS:  00007f27f4ea87c0(0000) GS:ffff880002840000(0000) knlGS:0000000000000000
[   82.315048] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   82.316305] CR2: 00007ff36b92fac0 CR3: 000000006a363000 CR4: 00000000000006e0
[   82.317912] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   82.319510] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   82.321171] Process gconfd-2 (pid: 5572, threadinfo ffff880069f9e000, task ffff88006a3e8000)
[   82.323026] Stack:
[   82.323485]  ffff88000000000b 00000000ffffffff 0000000000000e03 ffff880068a260d0
[   82.325245] <0> 0000000b69f9fc68 ffff880078f13088 000000000042ba39 0000000000000001
[   82.327290] <0>
[   82.327701] old_dentry .xsession-errors new_dentry .xsession-errors.old
[   82.329271]  ffff880079b0b300 000000000000042b ffff880069f9fc78 ffff88005986f4b8
[   82.331896] Call Trace:
[   82.332454]  [<ffffffff811b16cd>] btrfs_rename+0x33b/0x473
[   82.333662]  [<ffffffff8112cb1f>] vfs_rename+0x225/0x369
[   82.334835]  [<ffffffff81043bde>] ? get_parent_ip+0x11/0x41
[   82.336066]  [<ffffffff8112e3cf>] sys_renameat+0x193/0x20c
[   82.337274]  [<ffffffff810adbcf>] ? check_for_new_grace_period+0xde/0xfa
[   82.338738]  [<ffffffff810ae37e>] ? __call_rcu+0x138/0x14b
[   82.340262]  [<ffffffff810ae37e>] ? __call_rcu+0x138/0x14b
[   82.341541]  [<ffffffff810c6014>] ? time_hardirqs_off+0x1e/0x20
[   82.342907]  [<ffffffff8148acf9>] ? retint_swapgs+0x13/0x1b
[   82.344264]  [<ffffffff8148acf9>] ? retint_swapgs+0x13/0x1b
[   82.345554]  [<ffffffff8107ed21>] ? trace_hardirqs_on_caller+0x11d/0x141
[   82.347181]  [<ffffffff8112e463>] sys_rename+0x1b/0x1d
[   82.348391]  [<ffffffff81009d32>] system_call_fastpath+0x16/0x1b
[   82.349818] Code: 74 08 85 c0 74 04 0f 0b eb fe 4c 8b 4d c8 8b 4d a4 49 89 d8 48 8b 55 98 48 8b 7d a8 4c 89 fe e8 35 23 02 00 85 c0 41 89 c4 74 12 <0f> 0b eb fe 41 bc f4 ff ff ff eb 06 41 bc fe ff ff ff 4c 89 f7 
[   82.356109] RIP  [<ffffffff811b0e65>] btrfs_unlink_inode+0x1bb/0x25e
[   82.357522]  RSP <ffff880069f9fc18>
[   82.358414] ---[ end trace fe6f359e73694983 ]---

When looking into the log tree, btrfs_lookup_dir_item finds the dir item, but
btrfs_lookup_dir_index_item fails.

If I revert the following patch, I don't encounter the above problem.
But I am not certain if I really should revert it as it looks mostly fine.

commit 018db35864fd8d307066485a2753866240c3dace
Author: Andi Kleen <andi@firstfloor.org>
Date:   Wed Jul 21 00:29:24 2010 +0200

    These are all the cases where a variable is set, but not
    read which are really bugs.
    
    - Couple of incorrect error handling fixed.
    - One incorrect use of a allocation policy
    - Some other things
    
    Still needs more review.
    
    Found by gcc 4.6's new warnings.
    
    [akpm@linux-foundation.org: fix build.  Might have been bitrot]
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Cc: Chris Mason <chris.mason@oracle.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index e9103b3..f0cad5a 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -427,5 +427,5 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 		ret = btrfs_truncate_item(trans, root, path,
 					  item_len - sub_item_len, 1);
 	}
-	return 0;
+	return ret;
 }
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 32d0940..fb7effa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3337,8 +3337,7 @@ struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root)
 	btrfs_init_block_rsv(block_rsv);
 
 	alloc_target = btrfs_get_alloc_profile(root, 0);
-	block_rsv->space_info = __find_space_info(fs_info,
-						  BTRFS_BLOCK_GROUP_METADATA);
+	block_rsv->space_info = __find_space_info(fs_info, alloc_target);
 
 	return block_rsv;
 }
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d74e6af..609d67a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2823,6 +2823,8 @@ int extent_prepare_write(struct extent_io_tree *tree,
 					 NULL, 1,
 					 end_bio_extent_preparewrite, 0,
 					 0, 0);
+			if (ret && !err)
+				err = ret;
 			iocount++;
 			block_start = block_start + iosize;
 		} else {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c038644..1dc5b96 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1372,7 +1372,7 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 
 	if (map_length < length + size)
 		return 1;
-	return 0;
+	return ret;
 }
 
 /*
@@ -2672,8 +2672,8 @@ static int check_path_shared(struct btrfs_root *root,
 {
 	struct extent_buffer *eb;
 	int level;
-	int ret;
 	u64 refs = 1;
+	int uninitialized_var(ret);
 
 	for (level = 0; level < BTRFS_MAX_LEVEL; level++) {
 		if (!path->nodes[level])
@@ -2686,7 +2686,7 @@ static int check_path_shared(struct btrfs_root *root,
 		if (refs > 1)
 			return 1;
 	}
-	return 0;
+	return ret; /* XXX callers? */
 }
 
 /*
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b37d723..5f225fe 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3099,6 +3099,8 @@ static int add_tree_block(struct reloc_control *rc,
 		BUG_ON(item_size != sizeof(struct btrfs_extent_item_v0));
 		ret = get_ref_objectid_v0(rc, path, extent_key,
 					  &ref_owner, NULL);
+		if (ret < 0)
+			return ret;
 		BUG_ON(ref_owner >= BTRFS_MAX_LEVEL);
 		level = (int)ref_owner;
 		/* FIXME: get real generation */
@@ -4143,7 +4145,7 @@ int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len)
 		btrfs_add_ordered_sum(inode, ordered, sums);
 	}
 	btrfs_put_ordered_extent(ordered);
-	return 0;
+	return ret;
 }
 
 void btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index fb102a9..224fb5b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2273,7 +2273,7 @@ fail:
 	}
 	btrfs_end_log_trans(root);
 
-	return 0;
+	return err;
 }
 
 /* see comments for btrfs_del_dir_entries_in_log */

   

-- 
Itaru Kitayama <kitayama@cl.bb4.ne.jp>
