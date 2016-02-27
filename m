Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20833 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbcB0Bp6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 20:45:58 -0500
Date: Fri, 26 Feb 2016 17:48:17 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Daryl Styrk <darylstyrk@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs/nfsd kernel panic
Message-ID: <20160227014817.GA11954@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAKchYzb7svOV3oyYZm9CCojQ04yBZUyVSC=-mm=YUi0Wyg2M4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAKchYzb7svOV3oyYZm9CCojQ04yBZUyVSC=-mm=YUi0Wyg2M4A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Daryl,

On Thu, Feb 25, 2016 at 10:25:24PM -0600, Daryl Styrk wrote:
> I attempted to deploy a nfs/brtrfs server Monday. However, it KP’s
> every 1-3 hours with this:

This is very similar to an old bug about btrfs_next_leaf I fixed,
but I'm pretty sure that bug has been fixed.

So this stack info shows a key disorder or u64 overflow.

In order to get more information, can you give this debug patch a shot (has passed build on my box)?

Thanks,

-liubo

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 769e0ff..c05da72 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3150,6 +3150,7 @@ static void fixup_low_keys(struct btrfs_fs_info *fs_info,
 	}
 }
 
+
 /*
  * update item key.
  *
@@ -3182,6 +3183,63 @@ void btrfs_set_item_key_safe(struct btrfs_fs_info *fs_info,
 		fixup_low_keys(fs_info, path, &disk_key, 1);
 }
 
+noinline void btrfs_set_item_key_debug(struct btrfs_fs_info *fs_info,
+			     struct btrfs_path *path,
+			     struct btrfs_key *new_key)
+{
+	struct btrfs_disk_key disk_key;
+	struct btrfs_key key;
+	struct extent_buffer *eb;
+	u64 extent_end;
+	u64 extent_offset = 0;
+	u64 num_bytes;
+	u64 disk_bytenr;
+	struct btrfs_file_extent_item *fi;
+	int extent_type;
+	int slot;
+
+	eb = path->nodes[0];
+	slot = path->slots[0];
+
+	btrfs_item_key_to_cpu(eb, &key, path->slots[0]);
+
+	fi = btrfs_item_ptr(eb, path->slots[0],
+			    struct btrfs_file_extent_item);
+	extent_type = btrfs_file_extent_type(eb, fi);
+
+	BUG_ON(extent_type == BTRFS_FILE_EXTENT_INLINE);
+
+	disk_bytenr = btrfs_file_extent_disk_bytenr(eb, fi);
+	num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
+	extent_offset = btrfs_file_extent_offset(eb, fi);
+	extent_end = key.offset + btrfs_file_extent_num_bytes(eb, fi);
+
+	if (slot > 0) {
+		btrfs_item_key(eb, &disk_key, slot - 1);
+		if (comp_keys(&disk_key, new_key) >= 0) {
+			struct btrfs_key tmp;
+			btrfs_item_key_to_cpu(eb, &tmp, slot - 1);
+			pr_info("(slot - 1) is bigger: key.offset=%llu new_key.offset=%llu extent_end=%llu num_bytes=%llu disk_bytenr=%llu
extent_offset=%llu\n",
+				tmp.offset, new_key->offset, extent_end, num_bytes, disk_bytenr, extent_offset);
+			BUG_ON(1);
+		}
+	}
+	if (slot < btrfs_header_nritems(eb) - 1) {
+		btrfs_item_key(eb, &disk_key, slot + 1);
+
+		if (comp_keys(&disk_key, new_key) <= 0) {
+			struct btrfs_key tmp;
+			btrfs_item_key_to_cpu(eb, &tmp, slot + 1);
+			pr_info("(slot + 1) is smaller: key.offset=%llu new_key.offset=%llu extent_end=%llu num_bytes=%llu disk_bytenr=%llu
extent_offset=%llu\n",
+				tmp.offset, new_key->offset, extent_end, num_bytes, disk_bytenr, extent_offset);
+			BUG_ON(1);
+		}
+	}
+
+	btrfs_set_item_key_safe(fs_info, path, new_key);
+}
+
+
 /*
  * try to push data from one node into the next node left in the
  * tree.
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bfe4a33..84e68c5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3660,6 +3660,9 @@ int btrfs_previous_extent_item(struct btrfs_root *root,
 void btrfs_set_item_key_safe(struct btrfs_fs_info *fs_info,
 			     struct btrfs_path *path,
 			     struct btrfs_key *new_key);
+void btrfs_set_item_key_debug(struct btrfs_fs_info *fs_info,
+			     struct btrfs_path *path,
+			     struct btrfs_key *new_key);
 struct extent_buffer *btrfs_root_node(struct btrfs_root *root);
 struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
 int btrfs_find_next_key(struct btrfs_root *root, struct btrfs_path *path,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 098bb8f..6f2c00b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -678,6 +678,7 @@ next:
 		free_extent_map(split2);
 }
 
+
 /*
  * this is very complex, but the basic idea is to drop all extents
  * in the range start - end.  hint_block is filled in with a block number
@@ -871,7 +872,7 @@ next_slot:
 
 			memcpy(&new_key, &key, sizeof(new_key));
 			new_key.offset = end;
-			btrfs_set_item_key_safe(root->fs_info, path, &new_key);
+			btrfs_set_item_key_debug(root->fs_info, path, &new_key);
 
 			extent_offset += end - key.offset;
 			btrfs_set_file_extent_offset(leaf, fi, extent_offset);


> 
> 
> 
> 4.3.0 kernel:
> 
> 
> 
> 6569688.065748] CPU: 18 PID: 62680 Comm: nfsd Not tainted 4.3.0 #1
> 
> [6569688.067559] Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS
> 1.3.6 06/03/2015
> 
> [6569688.069386] task: ffff8807fa175200 ti: ffff8805cc350000 task.ti:
> ffff8805cc350000
> 
> [6569688.071209] RIP: 0010:[<ffffffff812b8d68>]  [<ffffffff812b8d68>]
> btrfs_set_item_key_safe+0x168/0x170
> 
> [6569688.073084] RSP: 0018:ffff8805cc353828  EFLAGS: 00010246
> 
> [6569688.074933] RAX: 0000000000000000 RBX: ffff88065e2deda0 RCX:
> 0000000000002000
> 
> [6569688.076774] RDX: 0000000000000000 RSI: ffff8805cc35392e RDI:
> ffff8805cc35383f
> 
> [6569688.078581] RBP: ffff8805cc35382e R08: ffff880194fd52e0 R09:
> ffff880000000000
> 
> [6569688.080387] R10: 0000160000000000 R11: 0000000000001000 R12:
> ffff880c5fe56000
> 
> [6569688.082195] R13: 000000000000000a R14: ffff880194fd5240 R15:
> ffff8805cc35392e
> 
> [6569688.083996] FS:  0000000000000000(0000) GS:ffff880666e40000(0000)
> knlGS:0000000000000000
> 
> [6569688.085815] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 
> [6569688.087641] CR2: 00007f561d67d000 CR3: 0000000001c0d000 CR4:
> 00000000001406e0
> 
> [6569688.089479] Stack:
> 
> [6569688.091298]  dfd9000000000000 006c000000000186 d900000000000020
> 6c000000000186df
> 
> [6569688.093164]  0000000000002000 ffff880194fd5240 ffff88065e2deda0
> 0000000000001000
> 
> [6569688.095001]  0000000000002000 0000000000003000 0000000000000000
> ffffffff812f2723
> 
> [6569688.096805] Call Trace:
> 
> [6569688.098557]  [<ffffffff812f2723>] ? __btrfs_drop_extents+0xb93/0xd90
> 
> [6569688.100300]  [<ffffffff813f4447>] ? merge+0x47/0x80
> 
> [6569688.101998]  [<ffffffff81353500>] ? btrfs_log_changed_extents+0x249/0x511
> 
> [6569688.103670]  [<ffffffff812f6fae>] ? btrfs_set_token_64+0x5e/0x110
> 
> [6569688.105303]  [<ffffffff81352717>] ? fill_inode_item.isra.17+0x247/0x254
> 
> [6569688.106904]  [<ffffffff812bc871>] ? btrfs_insert_empty_items+0x71/0xc0
> 
> [6569688.108467]  [<ffffffff8135466d>] ? btrfs_log_inode+0x98f/0xb09
> 
> [6569688.109989]  [<ffffffff8166048f>] ? __mutex_lock_slowpath+0x2f/0x100
> 
> [6569688.111476]  [<ffffffff8131bfc3>] ? btrfs_log_inode_parent+0x223/0xd50
> 
> [6569688.112929]  [<ffffffff812ffcc7>] ? extent_writepages+0x57/0x60
> 
> [6569688.114388]  [<ffffffff8114be41>] ? __filemap_fdatawrite_range+0xb1/0xe0
> 
> [6569688.115866]  [<ffffffff812dde1d>] ? wait_current_trans.isra.21+0x1d/0xf0
> 
> [6569688.117349]  [<ffffffff8131daeb>] ? btrfs_log_dentry_safe+0x5b/0x80
> 
> [6569688.118840]  [<ffffffff812f44ca>] ? btrfs_sync_file+0x22a/0x340
> 
> [6569688.120336]  [<ffffffffa04d05ca>] ? nfsd_vfs_write+0x14a/0x360 [nfsd]
> 
> [6569688.121821]  [<ffffffffa04d2af8>] ? nfsd_write+0xd8/0xf0 [nfsd]
> 
> [6569688.123287]  [<ffffffffa04d8278>] ? nfsd3_proc_write+0xa8/0x130 [nfsd]
> 
> [6569688.124766]  [<ffffffffa04cbd9d>] ? nfsd_dispatch+0xad/0x1f0 [nfsd]
> 
> [6569688.126251]  [<ffffffffa04496cb>] ? svc_process_common+0x3cb/0x620 [sunrpc]
> 
> [6569688.127721]  [<ffffffffa0449a1d>] ? svc_process+0xfd/0x180 [sunrpc]
> 
> [6569688.129161]  [<ffffffffa04cb809>] ? nfsd+0xe9/0x160 [nfsd]
> 
> [6569688.130595]  [<ffffffffa04cb720>] ? nfsd_destroy+0x60/0x60 [nfsd]
> 
> [6569688.131996]  [<ffffffff81089f1f>] ? kthread+0xcf/0xf0
> 
> [6569688.133354]  [<ffffffff81089e50>] ? kthread_park+0x50/0x50
> 
> [6569688.134668]  [<ffffffff8166270f>] ? ret_from_fork+0x3f/0x70
> 
> [6569688.135942]  [<ffffffff81089e50>] ? kthread_park+0x50/0x50
> 
> [6569688.137174] Code: 7c 24 17 4c 89 fe 48 89 44 24 20 0f b6 44 24 0e
> 88 44 24 1f 48 8b 44 24 06 48 89 44 24 17 e8 90 f3 ff ff 85 c0 0f 8f
> 4a ff ff ff <0f> 0b 0f 0b 0f 1f 40 00 0f 1f 44 00 00 41 55 48 b8 00 00
> 00 00
> 
> [6569688.139760] RIP  [<ffffffff812b8d68>] btrfs_set_item_key_safe+0x168/0x170
> 
> [6569688.140972]  RSP <ffff8805cc353828>
> 
> [6569688.147623] ---[ end trace 20549aa1584762bd ]---
> 
> 
> 
> 4.4.2 kernel:
> 
> 
> 
> [ 2275.607912] CPU: 1 PID: 3323 Comm: mount Not tainted 4.4.2 #1
> 
> [ 2275.607914] Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS
> 1.3.6 06/03/2015
> 
> [ 2275.607916]  ffffffff8197ab20 ffffffff813ef8b3 0000000000000000
> ffffffff8106edb1
> 
> [ 2275.607921]  0000000000003000 ffff880c16575980 ffff880c5ec1d000
> ffff880c16578bc8
> 
> [ 2275.607924]  ffff880c16578d58 ffffffff812fb245 0000000000001fff
> ffff880c391c3000
> 
> [ 2275.607928] Call Trace:
> 
> [ 2275.607937]  [<ffffffff813ef8b3>] ? dump_stack+0x40/0x5d
> 
> [ 2275.607947]  [<ffffffff8106edb1>] ? warn_slowpath_common+0x81/0xb0
> 
> [ 2275.607950]  [<ffffffff812fb245>] ? btrfs_drop_extent_cache+0x415/0x420
> 
> [ 2275.607955]  [<ffffffff812bf21a>] ? btrfs_set_path_blocking+0x3a/0x70
> 
> [ 2275.607958]  [<ffffffff812fb9ad>] ? __btrfs_drop_extents+0x40d/0xdd0
> 
> [ 2275.607961]  [<ffffffff812bf21a>] ? btrfs_set_path_blocking+0x3a/0x70
> 
> [ 2275.607968]  [<ffffffff811a3c0e>] ? kmem_cache_alloc+0x21e/0x460
> 
> [ 2275.607972]  [<ffffffff812c4017>] ? btrfs_search_slot+0x497/0xa00
> 
> [ 2275.607975]  [<ffffffff812fd386>] ? btrfs_drop_extents+0x76/0xa0
> 
> [ 2275.607983]  [<ffffffff81325564>] ? replay_one_extent+0x1a4/0x640
> 
> [ 2275.607988]  [<ffffffff81324db9>] ? add_inode_ref+0x399/0x9a0
> 
> [ 2275.607993]  [<ffffffff81325f7d>] ? replay_one_buffer+0x57d/0x7c0
> 
> [ 2275.608000]  [<ffffffff8115d9c9>] ? activate_page+0x69/0x80
> 
> [ 2275.608004]  [<ffffffff8115da19>] ? mark_page_accessed+0x39/0x90
> 
> [ 2275.608008]  [<ffffffff8130a20b>] ? find_extent_buffer+0x4b/0x80
> 
> [ 2275.608013]  [<ffffffff81300a6e>] ? btrfs_get_token_64+0xee/0x110
> 
> [ 2275.608017]  [<ffffffff8132240f>] ? walk_down_log_tree+0x1bf/0x3e0
> 
> [ 2275.608021]  [<ffffffff81322919>] ? walk_log_tree+0xb9/0x1a0
> 
> [ 2275.608025]  [<ffffffff8132812e>] ? btrfs_recover_log_trees+0x1ae/0x410
> 
> [ 2275.608030]  [<ffffffff812df2a0>] ? free_root_pointers+0x60/0x60
> 
> [ 2275.608034]  [<ffffffff81325a00>] ? replay_one_extent+0x640/0x640
> 
> [ 2275.608038]  [<ffffffff812e5819>] ? open_ctree+0x1999/0x2400
> 
> [ 2275.608045]  [<ffffffff812bc5cd>] ? btrfs_mount+0x87d/0x990
> 
> [ 2275.608049]  [<ffffffff8116e93c>] ? pcpu_alloc_area+0x2ac/0x3d0
> 
> [ 2275.608052]  [<ffffffff8116f5a3>] ? pcpu_alloc+0x333/0x650
> 
> [ 2275.608058]  [<ffffffff811c0e36>] ? mount_fs+0x36/0x170
> 
> [ 2275.608064]  [<ffffffff811dacb2>] ? vfs_kern_mount+0x62/0x100
> 
> [ 2275.608069]  [<ffffffff812bbf09>] ? btrfs_mount+0x1b9/0x990
> 
> [ 2275.608071]  [<ffffffff8116e93c>] ? pcpu_alloc_area+0x2ac/0x3d0
> 
> [ 2275.608074]  [<ffffffff8116f5a3>] ? pcpu_alloc+0x333/0x650
> 
> [ 2275.608078]  [<ffffffff811c0e36>] ? mount_fs+0x36/0x170
> 
> [ 2275.608081]  [<ffffffff811dacb2>] ? vfs_kern_mount+0x62/0x100
> 
> [ 2275.608087]  [<ffffffff811dd1d9>] ? do_mount+0x1f9/0xcc0
> 
> [ 2275.608091]  [<ffffffff811d2f4a>] ? dput+0x9a/0x1f0
> 
> [ 2275.608096]  [<ffffffff8116a6ed>] ? memdup_user+0x3d/0x70
> 
> [ 2275.608100]  [<ffffffff811ddf95>] ? SyS_mount+0x85/0xc0
> 
> [ 2275.608108]  [<ffffffff81672d36>] ? entry_SYSCALL_64_fastpath+0x16/0x75
> 
> [ 2275.608110] ---[ end trace ecaa307aa5e018c2 ]---
> 
> 
> 
> Any hints on where to go from here? It’s a pretty busy system with
> perhaps 50 users mounting via autofs from 200-300 machines and we’re
> forcing NFSv3. On our end I can't seem to find one user or task
> causing it. It just happens if it's being used.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
