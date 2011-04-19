From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: [PATCH] Btrfs: fix easily get into ENOSPC in mixed case
Date: Wed, 20 Apr 2011 00:55:31 +0300
Message-ID: <20110420005531.6d395333@sf>
References: <20110402121946.6bf27f80@sf.home>
	<4D96EE76.5040208@cn.fujitsu.com>
	<20110402134132.0391f4fd@sf.home>
	<4D9708E0.6030206@cn.fujitsu.com>
	<20110402155545.2159043a@sf.home>
	<4D9ECAF5.50108@cn.fujitsu.com>
	<20110409000932.6154c7b5@sf>
	<20110409001920.089c4409@sf>
	<20110409005555.4b136f25@sf>
	<4DA29FC1.9050900@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P6QPyp6=CCq/57g3LJySzcn"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
	Arne Jansen <sensille@gmx.net>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DA29FC1.9050900@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/P6QPyp6=CCq/57g3LJySzcn
Content-Type: multipart/mixed; boundary="MP_/I0nncx7YYYEBq=eN2q==3p2"

--MP_/I0nncx7YYYEBq=eN2q==3p2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mon, 11 Apr 2011 14:29:21 +0800
liubo <liubo2009@cn.fujitsu.com> wrote:

> On 04/09/2011 05:55 AM, Sergei Trofimovich wrote:
> > [  100.500011] Call Trace:
> > [  100.500011]  [<ffffffff810ed3a0>] vfs_unlink+0x80/0xf0
> > [  100.500011]  [<ffffffff810ef6f3>] do_unlinkat+0x173/0x1b0
> > [  100.500011]  [<ffffffff8111727b>] ? fsnotify_find_inode_mark+0x3b/0x=
50
> > [  100.500011]  [<ffffffff810dff91>] ? filp_close+0x61/0x90
> > [  100.500011]  [<ffffffff810f0c0d>] sys_unlinkat+0x1d/0x40
> > [  100.500011]  [<ffffffff81574c3b>] system_call_fastpath+0x16/0x1b
> > [  100.500011] Code: 4c 8b 65 e0 48 8b 5d d8 4c 8b 6d e8 4c 8b 75 f0 4c=
 8b 7d f8 c9 c3 0f 1f 40 00 4c 89 fe 4c 89 ef e8 05 d0 ff ff 85 c0 74 bb 0f=
 0b <0f> 0b 89 c3 eb cd 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57=20
> > [  100.500011] RIP  [<ffffffffa024a011>] btrfs_unlink+0xd1/0xe0 [btrfs]
> > [  100.500011]  RSP <ffff880070b55e28>
> > [  100.525672] ---[ end trace 7e63b9144b7307fe ]---
> >=20
> > Looks like I won't be able to test your patch until this thing will go =
away first.
>=20
> Thanks a lot for testing, though.
>=20
> I guess something messed up your btrfs metadata, cause when btrfs_unlink(=
) wanted to remove A,
> it found that A was just missing...

Hello again!

I've decided to explore OOps myself a bit. The result is a debugging patch =
I've attached.
I've applied it and you patch
    [PATCH] Btrfs: fix easily get into ENOSPC in mixed case
on top of vanilla 2.6.39-rc4

The result you can see in attached 'fault.log'. There you can see -ENOSPC p=
ropagation.
No idea why it converted to -ENOENT in the end. The result is very similar =
with vanilla 2.6.39-rc4.
I can run the debugging patch on it as well if you like.


I think interesting the parts are (they were found by Arne before):
[    0.040000] new update_space_info:=20
[    0.040000] space_info has 0 free, is not full
[    0.040000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D0, ma=
y_use=3D0, readonly=3D0
[    0.040000] new update_space_info:=20
[    0.040000] space_info has 0 free, is not full
[    0.040000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D0, ma=
y_use=3D0, readonly=3D0
[    0.040000] new update_space_info:=20
[    0.040000] space_info has 0 free, is not full
[    0.040000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D0, ma=
y_use=3D0, readonly=3D0

and:
[    0.290000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.300000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.310000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.320000] reserve_metadata_bytes: shrink_delalloc(num_bytes=3D983040) =
-> 0
[    0.320000] reserve_metadata_bytes:=20
[    0.320000] space_info has 18446744073708568576 free, is not full
[    0.320000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D98304=
0, may_use=3D0, readonly=3D0

Here I see 2 problems:
1 (major) free space is busted (as the whole space_info).
2 (minor) the original loop of shrink_delalloc busy waited 30 seconds, so I=
 had to trim it;
   and it seemed to know that additional IO won't reclaim any pages ('yet 0=
 bytes' string AFAIU);
   but it's likely a result of busted space_info: it has reserved=3D983040 =
more, than total=3D0.

If I'll revert c59021f846881a957ac5afe456d0f59d6a517b61 from vanilla 2.6.39=
-rc4 I'll be able to delete
the files from filesystem.

I perform tests in usermode linux,  and run 'rm -rf' on the same faulty par=
tition snapshot.
I've backed it up, so it's easy to reproduce and debug. I can provide more =
info if you need.
It's a 'readable' (read-only btrfs mount behaves fine) 5GB image.

--=20

  Sergei

--MP_/I0nncx7YYYEBq=eN2q==3p2
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=0002-btrfs-my-nice-debug.patch

=46rom 56668c999cae1b5ca00e94c63dc1c38eba68e3e1 Mon Sep 17 00:00:00 2001
From: Sergei Trofimovich <slyfox@gentoo.org>
Date: Wed, 20 Apr 2011 00:11:40 +0300
Subject: [PATCH 2/2] btrfs: my nice debug

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 fs/btrfs/ctree.c       |    7 +++++++
 fs/btrfs/dir-item.c    |    6 ++++++
 fs/btrfs/extent-tree.c |   25 ++++++++++++++++++++++++-
 fs/btrfs/inode.c       |    5 +++++
 4 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 84d7ca1..41f8581 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -421,7 +421,10 @@ static noinline int __btrfs_cow_block(struct btrfs_tra=
ns_handle *trans,
 				     root->root_key.objectid, &disk_key,
 				     level, search_start, empty_size);
 	if (IS_ERR(cow))
+	{
+		printk(KERN_INFO "__btrfs_cow_block: btrfs_alloc_free_block ret=3D%d\n",=
 (int)PTR_ERR(cow));
 		return PTR_ERR(cow);
+	}
=20
 	/* cow is set to blocking by btrfs_init_new_buffer */
=20
@@ -1648,6 +1651,7 @@ again:
 					      p->slots[level + 1], &b);
 			if (err) {
 				ret =3D err;
+				printk(KERN_INFO "1. btrfs_search_slot ret=3D%d\n", ret);
 				goto done;
 			}
 		}
@@ -1692,6 +1696,7 @@ cow_done:
 				goto again;
 			if (err) {
 				ret =3D err;
+				printk(KERN_INFO "2. btrfs_search_slot ret=3D%d\n", ret);
 				goto done;
 			}
 			b =3D p->nodes[level];
@@ -1711,6 +1716,7 @@ cow_done:
 				goto again;
 			if (err) {
 				ret =3D err;
+				printk(KERN_INFO "3. btrfs_search_slot ret=3D%d\n", ret);
 				goto done;
 			}
=20
@@ -1736,6 +1742,7 @@ cow_done:
 				BUG_ON(err > 0);
 				if (err) {
 					ret =3D err;
+					printk(KERN_INFO "4. btrfs_search_slot ret=3D%d\n", ret);
 					goto done;
 				}
 			}
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index dec9348..228a706 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -228,7 +228,10 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct bt=
rfs_trans_handle *trans,
=20
 	ret =3D btrfs_search_slot(trans, root, &key, path, ins_len, cow);
 	if (ret < 0)
+	{
+		printk (KERN_INFO "btrfs_lookup_dir_item: search slot failed: %d\n", ret=
);
 		return ERR_PTR(ret);
+	}
 	if (ret > 0) {
 		if (path->slots[0] =3D=3D 0)
 			return NULL;
@@ -243,6 +246,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btr=
fs_trans_handle *trans,
 	    found_key.offset !=3D key.offset)
 		return NULL;
=20
+	printk (KERN_INFO "btrfs_lookup_dir_item -> btrfs_match_dir_item_name\n");
 	return btrfs_match_dir_item_name(root, path, name, name_len);
 }
=20
@@ -377,6 +381,8 @@ struct btrfs_dir_item *btrfs_match_dir_item_name(struct=
 btrfs_root *root,
 	u32 this_len;
 	struct extent_buffer *leaf;
=20
+	printk(KERN_INFO "btrfs_match_dir_item_name (name=3D'%s')\n", name);
+
 	leaf =3D path->nodes[0];
 	dir_item =3D btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
 	if (verify_dir_item(root, leaf, dir_item))
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 31f33ba..e51adfa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3016,6 +3016,7 @@ static int update_space_info(struct btrfs_fs_info *in=
fo, u64 flags,
 		found->full =3D 0;
 		spin_unlock(&found->lock);
 		*space_info =3D found;
+		printk (KERN_INFO "found %s: ", __func__); dump_space_info (*space_info,=
 0, 0);
 		return 0;
 	}
 	found =3D kzalloc(sizeof(*found), GFP_NOFS);
@@ -3043,6 +3044,7 @@ static int update_space_info(struct btrfs_fs_info *in=
fo, u64 flags,
 	*space_info =3D found;
 	list_add_rcu(&found->list, &info->space_info);
 	atomic_set(&found->caching_threads, 0);
+	printk (KERN_INFO "new %s: ", __func__); dump_space_info (*space_info, 0,=
 0);
 	return 0;
 }
=20
@@ -3418,6 +3420,8 @@ static int shrink_delalloc(struct btrfs_trans_handle =
*trans,
 	block_rsv =3D &root->fs_info->delalloc_block_rsv;
 	space_info =3D block_rsv->space_info;
=20
+	printk(KERN_INFO "shrink_delalloc: "); dump_space_info (space_info, 0, 0);
+
 	smp_mb();
 	reserved =3D space_info->bytes_reserved;
 	progress =3D space_info->reservation_progress;
@@ -3427,11 +3431,13 @@ static int shrink_delalloc(struct btrfs_trans_handl=
e *trans,
=20
 	max_reclaim =3D min(reserved, to_reclaim);
=20
-	while (loops < 1024) {
+	while (loops < 10) {
 		/* have the flusher threads jump in and do some IO */
 		smp_mb();
 		nr_pages =3D min_t(unsigned long, nr_pages,
 		       root->fs_info->delalloc_bytes >> PAGE_CACHE_SHIFT);
+		printk(KERN_INFO "shrink_delalloc: kick writeback_inodes_sb_nr_if_idle t=
o free %d pages (yet %llu bytes to wb).\n"
+		      , nr_pages, (long long unsigned)root->fs_info->delalloc_bytes);
 		writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages);
=20
 		spin_lock(&space_info->lock);
@@ -3446,7 +3452,10 @@ static int shrink_delalloc(struct btrfs_trans_handle=
 *trans,
 			break;
=20
 		if (trans && trans->transaction->blocked)
+		{
+		printk(KERN_INFO "shrink_delalloc: ret -EAGAIN\n");
 			return -EAGAIN;
+		}
=20
 		time_left =3D schedule_timeout_interruptible(1);
=20
@@ -3499,11 +3508,15 @@ again:
 	if (reserved)
 		num_bytes =3D 0;
=20
+	printk(KERN_INFO "reserve_metadata_bytes: "); dump_space_info (space_info=
, 0, 0);
+
 	spin_lock(&space_info->lock);
 	unused =3D space_info->bytes_used + space_info->bytes_reserved +
 		 space_info->bytes_pinned + space_info->bytes_readonly +
 		 space_info->bytes_may_use;
=20
+	printk(KERN_INFO "reserve_metadata_bytes: consider unused=3D%llu\n", (lon=
g long unsigned)unused);
+
 	/*
 	 * The idea here is that we've not already over-reserved the block group
 	 * then we can go ahead and save our reservation first and then start
@@ -3558,6 +3571,8 @@ again:
 	 * metadata until after the IO is completed.
 	 */
 	ret =3D shrink_delalloc(trans, root, num_bytes, 1);
+	printk(KERN_INFO "reserve_metadata_bytes: shrink_delalloc(num_bytes=3D%ll=
u) -> %d\n"
+	      , (long long unsigned)num_bytes, ret);
 	if (ret > 0)
 		return 0;
 	else if (ret < 0)
@@ -5773,11 +5788,14 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 		 * the global reserve.
 		 */
 		if (ret && block_rsv !=3D global_rsv) {
+			printk(KERN_INFO "use_block_rsv (nonglobal metadata rsv) ret=3D%d. retr=
y global\n", ret);
 			ret =3D block_rsv_use_bytes(global_rsv, blocksize);
 			if (!ret)
 				return global_rsv;
+			printk(KERN_INFO "use_block_rsv (retry global metadata rsv) ret=3D%d\n"=
, ret);
 			return ERR_PTR(ret);
 		} else if (ret) {
+			printk(KERN_INFO "use_block_rsv (global metadata rsv) ret=3D%d\n", ret);
 			return ERR_PTR(ret);
 		}
 		return block_rsv;
@@ -5802,6 +5820,7 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 		}
 	}
=20
+	printk(KERN_INFO "the very end of use_block_rsv. -ENOSPC\n");
 	return ERR_PTR(-ENOSPC);
 }
=20
@@ -5833,12 +5852,16 @@ struct extent_buffer *btrfs_alloc_free_block(struct=
 btrfs_trans_handle *trans,
=20
 	block_rsv =3D use_block_rsv(trans, root, blocksize);
 	if (IS_ERR(block_rsv))
+	{
+		printk(KERN_INFO "btrfs_alloc_free_block: use_block_rsv error=3D%d\n", (=
int)PTR_ERR(block_rsv));
 		return ERR_CAST(block_rsv);
+	}
=20
 	ret =3D btrfs_reserve_extent(trans, root, blocksize, blocksize,
 				   empty_size, hint, (u64)-1, &ins, 0);
 	if (ret) {
 		unuse_block_rsv(block_rsv, blocksize);
+		printk(KERN_INFO "btrfs_alloc_free_block: reserve_extent=3D%d\n", ret);
 		return ERR_PTR(ret);
 	}
=20
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fcd66b6..037afe2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2699,6 +2699,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_ha=
ndle *trans,
 	di =3D btrfs_lookup_dir_item(trans, root, path, dir->i_ino,
 				    name, name_len, -1);
 	if (IS_ERR(di)) {
+		printk(KERN_INFO "btrfs_lookup_dir_item: IS_ERR(di) =3D %d\n", (int)PTR_=
ERR(di));
 		ret =3D PTR_ERR(di);
 		goto err;
 	}
@@ -2710,7 +2711,9 @@ static int __btrfs_unlink_inode(struct btrfs_trans_ha=
ndle *trans,
 	btrfs_dir_item_key_to_cpu(leaf, di, &key);
 	ret =3D btrfs_delete_one_dir_name(trans, root, path, di);
 	if (ret)
+	{
 		goto err;
+	}
 	btrfs_release_path(root, path);
=20
 	ret =3D btrfs_del_inode_ref(trans, root, name, name_len,
@@ -2762,8 +2765,10 @@ int btrfs_unlink_inode(struct btrfs_trans_handle *tr=
ans,
 		       const char *name, int name_len)
 {
 	int ret;
+	printk (KERN_INFO"__unlinking '%s'\n", name);
 	ret =3D __btrfs_unlink_inode(trans, root, dir, inode, name, name_len);
 	if (!ret) {
+		printk (KERN_INFO"unlinking '%s'\n", name);
 		btrfs_drop_nlink(inode);
 		ret =3D btrfs_update_inode(trans, root, inode);
 	}
--=20
1.7.3.4


--MP_/I0nncx7YYYEBq=eN2q==3p2
Content-Type: text/x-log
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=fault.log

Checking that ptrace can change system call numbers...Core dump limits :
	soft - 0
	hard - NONE
OK
Checking syscall emulation patch for ptrace...Core dump limits :
	soft - 0
	hard - NONE
OK
Checking advanced syscall emulation patch for ptrace...Core dump limits :
	soft - 0
	hard - NONE
OK
Core dump limits :
	soft - 0
	hard - NONE
Checking for tmpfs mount on /dev/shm...OK
Checking PROT_EXEC mmap in /dev/shm/...OK
Checking for the skas3 patch in the host:
  - /proc/mm...not found: No such file or directory
  - PTRACE_FAULTINFO...not found
OK
  - PTRACE_LDT...not found
OK
OK
UML running in SKAS0 mode
Adding 18935808 bytes to physical memory to account for exec-shield gap
[    0.000000] Linux version 2.6.39-rc4+ (st@st) (gcc version 4.5.2 (Gentoo=
 Hardened 4.5.2 p1.0, pie-0.4.5) ) #68 Wed Apr 20 00:24:54 EEST 2011
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 133574
[    0.000000] Kernel command line: ubd0=3D/home/st/linux-2.6-um-fs/chewed-=
portage.img root=3D/dev/root rootflags=3D/home/st/linux-2.6-um-fs/root rw r=
ootfstype=3Dhostfs mem=3D512M init=3D/init
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 b=
ytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 byte=
s)
[    0.000000] Memory: 502504k available
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] NR_IRQS:15
[    0.000000] ODEBUG: selftest passed
[    0.000000] Calibrating delay loop... 1036.28 BogoMIPS (lpj=3D5181440)
[    0.040000] pid_max: default: 32768 minimum: 301
[    0.040000] Mount-cache hash table entries: 256
[    0.040000] Checking that host ptys support output SIGIO...Yes
[    0.040000] Checking that host ptys support SIGIO on close...No, enablin=
g workaround
[    0.040000] Using 2.6 host AIO
[    0.040000] atomic64 test passed
[    0.040000] NET: Registered protocol family 16
[    0.040000] bio: create slab <bio-0> at 0
[    0.040000] Switching to clocksource itimer
[    0.040000] NET: Registered protocol family 2
[    0.040000] IP route cache hash table entries: 8192 (order: 4, 65536 byt=
es)
[    0.040000] IPv4 FIB: Using LC-trie version 0.409
[    0.040000] TCP established hash table entries: 32768 (order: 7, 524288 =
bytes)
[    0.040000] TCP bind hash table entries: 32768 (order: 6, 262144 bytes)
[    0.040000] TCP: Hash tables configured (established 32768 bind 32768)
[    0.040000] TCP reno registered
[    0.040000] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.040000] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.040000] NET: Registered protocol family 1
[    0.040000] mconsole (version 2) initialized on /home/st/.uml/FBNd0K/mco=
nsole
[    0.040000] Checking host MADV_REMOVE support...OK
[    0.040000] ubd: Synchronous mode
[    0.040000] Btrfs loaded
[    0.040000] msgmni has been set to 981
[    0.040000] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[    0.040000] io scheduler noop registered (default)
[    0.040000] loop: module loaded
[    0.040000] TCP cubic registered
[    0.040000] NET: Registered protocol family 17
[    0.040000] Initialized stdio console driver
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 1 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 2 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 3 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 4 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 5 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 6 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 7 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 8 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 9 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 10 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 11 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 12 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 13 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 14 : Configuration failed
[    0.040000] Using a channel type which is configured out of UML
[    0.040000] parse_chan_pair failed for device 15 : Configuration failed
[    0.040000] Console initialized on /dev/tty0
[    0.040000] console [tty0] enabled
[    0.040000] console [mc-1] enabled
[    0.040000]  ubda: unknown partition table
[    0.040000] VFS: Mounted root (hostfs filesystem) on device 0:11.
mount /mnt/btr/; rm -rf /mnt/btr/var_tmp/paludis/dev-lang-jhc-9999/
[    0.040000] device label PORTAGE devid 1 transid 17409 /dev/ubda
[    0.040000] btrfs: use lzo compression
[    0.040000] new update_space_info:=20
[    0.040000] space_info has 0 free, is not full
[    0.040000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D0, ma=
y_use=3D0, readonly=3D0
[    0.040000] new update_space_info:=20
[    0.040000] space_info has 0 free, is not full
[    0.040000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D0, ma=
y_use=3D0, readonly=3D0
[    0.040000] new update_space_info:=20
[    0.040000] space_info has 0 free, is not full
[    0.040000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D0, ma=
y_use=3D0, readonly=3D0
[    0.040000] found update_space_info:=20
[    0.040000] space_info has 4190208 free, is not full
[    0.040000] space_info total=3D4194304, used=3D4096, pinned=3D0, reserve=
d=3D0, may_use=3D0, readonly=3D0
[    0.040000] found update_space_info:=20
[    0.040000] space_info has 2662400 free, is not full
[    0.040000] space_info total=3D8388608, used=3D5726208, pinned=3D0, rese=
rved=3D0, may_use=3D0, readonly=3D0
[    0.040000] found update_space_info:=20
[    0.040000] space_info has 4165632 free, is not full
[    0.040000] space_info total=3D16777216, used=3D12611584, pinned=3D0, re=
served=3D0, may_use=3D0, readonly=3D0
[    0.040000] found update_space_info:=20
[    0.040000] space_info has 230006784 free, is not full
[    0.040000] space_info total=3D516816896, used=3D286810112, pinned=3D0, =
reserved=3D0, may_use=3D0, readonly=3D0
[    0.040000] found update_space_info:=20
[    0.040000] space_info has 274923520 free, is not full
[    0.040000] space_info total=3D1016856576, used=3D741867520, pinned=3D0,=
 reserved=3D0, may_use=3D0, readonly=3D65536
[    0.040000] found update_space_info:=20
[    0.040000] space_info has 509603840 free, is not full
[    0.040000] space_info total=3D1516896256, used=3D1007226880, pinned=3D0=
, reserved=3D0, may_use=3D0, readonly=3D65536
[    0.040000] found update_space_info:=20
[    0.040000] space_info has 960970752 free, is not full
[    0.040000] space_info total=3D2016935936, used=3D1055899648, pinned=3D0=
, reserved=3D0, may_use=3D0, readonly=3D65536
[    0.040000] found update_space_info:=20
[    0.040000] space_info has 1266278400 free, is not full
[    0.040000] space_info total=3D2516975616, used=3D1250631680, pinned=3D0=
, reserved=3D0, may_use=3D0, readonly=3D65536
[    0.040000] found update_space_info:=20
[    0.040000] space_info has 1431748608 free, is not full
[    0.040000] space_info total=3D3017015296, used=3D1585201152, pinned=3D0=
, reserved=3D0, may_use=3D0, readonly=3D65536
[    0.040000] found update_space_info:=20
[    0.040000] space_info has 1931784192 free, is not full
[    0.040000] space_info total=3D3517054976, used=3D1585205248, pinned=3D0=
, reserved=3D0, may_use=3D0, readonly=3D65536
[    0.040000] found update_space_info:=20
[    0.040000] space_info has 2431819776 free, is not full
[    0.040000] space_info total=3D4017094656, used=3D1585209344, pinned=3D0=
, reserved=3D0, may_use=3D0, readonly=3D65536
[    0.040000] found update_space_info:=20
[    0.040000] space_info has 2884710400 free, is not full
[    0.040000] space_info total=3D4517134336, used=3D1632358400, pinned=3D0=
, reserved=3D0, may_use=3D0, readonly=3D65536
[    0.040000] found update_space_info:=20
[    0.040000] space_info has 3364249600 free, is not full
[    0.040000] space_info total=3D4996726784, used=3D1632411648, pinned=3D0=
, reserved=3D0, may_use=3D0, readonly=3D65536
[    0.040000] btrfs_lookup_dir_item -> btrfs_match_dir_item_name
[    0.040000] btrfs_match_dir_item_name (name=3D'default')
[    0.040000] btrfs_lookup_dir_item -> btrfs_match_dir_item_name
[    0.040000] btrfs_match_dir_item_name (name=3D'var_tmp')
[    0.040000] btrfs_lookup_dir_item -> btrfs_match_dir_item_name
[    0.040000] btrfs_match_dir_item_name (name=3D'paludis')
[    0.040000] btrfs_lookup_dir_item -> btrfs_match_dir_item_name
[    0.040000] btrfs_match_dir_item_name (name=3D'dev-lang-jhc-9999')
[    0.040000] btrfs_lookup_dir_item -> btrfs_match_dir_item_name
[    0.040000] btrfs_match_dir_item_name (name=3D'work')
[    0.040000] btrfs_lookup_dir_item -> btrfs_match_dir_item_name
[    0.040000] btrfs_match_dir_item_name (name=3D'jhc-9999')
[    0.040000] btrfs_lookup_dir_item -> btrfs_match_dir_item_name
[    0.040000] btrfs_match_dir_item_name (name=3D'ac-macros')
[    0.040000] btrfs_lookup_dir_item -> btrfs_match_dir_item_name
[    0.040000] btrfs_match_dir_item_name (name=3D'ac_define_dir.m4')
[    0.040000] reserve_metadata_bytes:=20
[    0.040000] space_info has 0 free, is not full
[    0.040000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D0, ma=
y_use=3D0, readonly=3D0
[    0.040000] reserve_metadata_bytes: consider unused=3D0
[    0.040000] shrink_delalloc:=20
[    0.040000] space_info has 18446744073708568576 free, is not full
[    0.040000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D98304=
0, may_use=3D0, readonly=3D0
[    0.040000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.050000] Switched to NOHz mode on CPU #0
[    0.050000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.240000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.250000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.260000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.270000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.280000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.290000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.300000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.310000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.320000] reserve_metadata_bytes: shrink_delalloc(num_bytes=3D983040) =
-> 0
[    0.320000] reserve_metadata_bytes:=20
[    0.320000] space_info has 18446744073708568576 free, is not full
[    0.320000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D98304=
0, may_use=3D0, readonly=3D0
[    0.320000] reserve_metadata_bytes: consider unused=3D983040
[    0.320000] shrink_delalloc:=20
[    0.320000] space_info has 18446744073708568576 free, is not full
[    0.320000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D98304=
0, may_use=3D0, readonly=3D0
[    0.320000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.330000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.340000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.350000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.360000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.370000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.380000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.390000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.400000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.410000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.420000] reserve_metadata_bytes: shrink_delalloc(num_bytes=3D2949120)=
 -> 0
[    0.420000] reserve_metadata_bytes:=20
[    0.420000] space_info has 18446744073708568576 free, is not full
[    0.420000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D98304=
0, may_use=3D0, readonly=3D0
[    0.420000] reserve_metadata_bytes: consider unused=3D983040
[    0.420000] shrink_delalloc:=20
[    0.420000] space_info has 18446744073708568576 free, is not full
[    0.420000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D98304=
0, may_use=3D0, readonly=3D0
[    0.420000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.430000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.440000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.450000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.460000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.470000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.480000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.490000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.500000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.510000] shrink_delalloc: kick writeback_inodes_sb_nr_if_idle to free=
 0 pages (yet 0 bytes to wb).
[    0.520000] reserve_metadata_bytes: shrink_delalloc(num_bytes=3D3932160)=
 -> 0
[    0.520000] btrfs_lookup_dir_item -> btrfs_match_dir_item_name
[    0.520000] btrfs_match_dir_item_name (name=3D'ac_define_dir.m4')
[    0.520000] btrfs_match_dir_item_name (name=3D'ac_define_dir.m4')
[    0.520000] __unlinking 'ac_define_dir.m4'
[    0.520000] reserve_metadata_bytes:=20
[    0.520000] space_info has 0 free, is not full
[    0.520000] space_info total=3D0, used=3D0, pinned=3D0, reserved=3D0, ma=
y_use=3D0, readonly=3D0
[    0.520000] reserve_metadata_bytes: consider unused=3D0
[    0.520000] use_block_rsv (global metadata rsv) ret=3D-28
[    0.520000] btrfs_alloc_free_block: use_block_rsv error=3D-28
[    0.520000] __btrfs_cow_block: btrfs_alloc_free_block ret=3D-28
[    0.520000] 1. btrfs_search_slot ret=3D-28
[    0.520000] btrfs_lookup_dir_item: search slot failed: -28
[    0.520000] btrfs_lookup_dir_item: IS_ERR(di) =3D -28
[    0.520000] BUG: failure at /mnt/archive/src/linux-2.6/fs/btrfs/inode.c:=
2982/btrfs_unlink()!
[    0.520000] Kernel panic - not syncing: BUG!
[    0.520000] Call Trace:=20
[    0.520000] 80fb7c78:  [<601ae895>] panic+0xea/0x1dc
[    0.520000] 80fb7c98:  [<601aea27>] printk+0xa0/0xa9
[    0.520000] 80fb7cf8:  [<600b91de>] btrfs_free_path+0x2a/0x2f
[    0.520000] 80fb7d38:  [<600dc01a>] btrfs_unlink_inode+0x4b/0x7c
[    0.520000] 80fb7d78:  [<600dc10f>] btrfs_unlink+0xc4/0xee
[    0.520000] 80fb7db8:  [<6007fccb>] vfs_unlink+0x55/0x8e
[    0.520000] 80fb7de8:  [<6007fdcc>] do_unlinkat+0xc8/0x156
[    0.520000] 80fb7e48:  [<6007818e>] sys_newlstat+0x29/0x34
[    0.520000] 80fb7ec8:  [<6007fe91>] sys_unlink+0x11/0x13
[    0.520000] 80fb7ed8:  [<600171f0>] handle_syscall+0x50/0x70
[    0.520000] 80fb7ef8:  [<60021af5>] userspace+0x30f/0x3c9
[    0.520000] 80fb7fc8:  [<600148c9>] fork_handler+0x62/0x69
[    0.520000]=20
[    0.520000]=20
[    0.520000] Pid: 160, comm: kill Not tainted 2.6.39-rc4+
[    0.520000] RIP: 0033:[<00000000005443a7>]
[    0.520000] RSP: 0000007fbf931cf8  EFLAGS: 00000246
[    0.520000] RAX: ffffffffffffffda RBX: 000000000086a010 RCX: fffffffffff=
fffff
[    0.520000] RDX: 0000007fbf931d00 RSI: 0000007fbf931d00 RDI: 00000000008=
6a010
[    0.520000] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000=
00000
[    0.520000] R10: 7263616d2d63612f R11: 0000000000000246 R12: 00000000000=
00000
[    0.520000] R13: 0000000040001010 R14: 000000000086a010 R15: 00000000fff=
fffff
[    0.520000] Call Trace:=20
[    0.520000] 80fb7bf8:  [<60016cf1>] panic_exit+0x2f/0x45
[    0.520000] 80fb7c18:  [<60043621>] notifier_call_chain+0x5f/0x96
[    0.520000] 80fb7c68:  [<600436f7>] atomic_notifier_call_chain+0xf/0x11
[    0.520000] 80fb7c78:  [<601ae8b0>] panic+0x105/0x1dc
[    0.520000] 80fb7c98:  [<601aea27>] printk+0xa0/0xa9
[    0.520000] 80fb7cf8:  [<600b91de>] btrfs_free_path+0x2a/0x2f
[    0.520000] 80fb7d38:  [<600dc01a>] btrfs_unlink_inode+0x4b/0x7c
[    0.520000] 80fb7d78:  [<600dc10f>] btrfs_unlink+0xc4/0xee
[    0.520000] 80fb7db8:  [<6007fccb>] vfs_unlink+0x55/0x8e
[    0.520000] 80fb7de8:  [<6007fdcc>] do_unlinkat+0xc8/0x156
[    0.520000] 80fb7e48:  [<6007818e>] sys_newlstat+0x29/0x34
[    0.520000] 80fb7ec8:  [<6007fe91>] sys_unlink+0x11/0x13
[    0.520000] 80fb7ed8:  [<600171f0>] handle_syscall+0x50/0x70
[    0.520000] 80fb7ef8:  [<60021af5>] userspace+0x30f/0x3c9
[    0.520000] 80fb7fc8:  [<600148c9>] fork_handler+0x62/0x69
[    0.520000]=20

--MP_/I0nncx7YYYEBq=eN2q==3p2--

--Sig_/P6QPyp6=CCq/57g3LJySzcn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2uBNsACgkQcaHudmEf86qQIwCfQ09DvW7V1Ltv2kk3aiVXbl2p
e1oAn23k58omctjN6VzK25KecS9pDcdj
=rk62
-----END PGP SIGNATURE-----

--Sig_/P6QPyp6=CCq/57g3LJySzcn--
