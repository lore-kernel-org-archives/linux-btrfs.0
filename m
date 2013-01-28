Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:57906 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3A1FUm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 00:20:42 -0500
Received: by mail-ob0-f179.google.com with SMTP id un3so2376993obb.38
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Jan 2013 21:20:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130127124154.GA16722@liubo>
References: <1358339768-2314-1-git-send-email-bo.li.liu@oracle.com>
	<CAKcLGm8QDNEs3nF=VDGtRWVV9MNg9SZr0ZBH1fiqTRgJyJgOvg@mail.gmail.com>
	<CAKcLGm9RXjS1yCK7oXKHVbVoH-bMXPM1PPpHTrwMh+Ubnx8gkA@mail.gmail.com>
	<20130123075155.GE17162@liubo.jp.oracle.com>
	<CAKcLGm97CSThaz9u0sj8BE=bMGObc6rqCsmzf0AneWfhxfZFDw@mail.gmail.com>
	<20130124005221.GA28406@liubo>
	<CAKcLGm_Casj44A3OL3hpsYAL9szb3-F+8C2fsLow9Trk_y=7dg@mail.gmail.com>
	<20130125154236.GA3997@liubo>
	<CAKcLGm_fyGU3rXKvBfcjQtJDx+1JrbxiDAw1w0EpnPcc2xiHvA@mail.gmail.com>
	<20130127124154.GA16722@liubo>
Date: Sun, 27 Jan 2013 23:20:41 -0600
Message-ID: <CAKcLGm_mzYgsC92Gf18zsA0WsC6wR06mSr06mrGZ+2dAfkfaRA@mail.gmail.com>
Subject: Re: [PATCH V5] Btrfs: snapshot-aware defrag
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, JBacik@fusionio.com,
        dave@jikos.cz, kitayama@cl.bb4u.ne.jp, miaox@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 27, 2013 at 6:41 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>
> Hi Mitch,
>
> Many thanks for testing it!
>
> Well, after some debugging, I finally figure out the whys:
>
> (1) btrfs_ioctl_snap_destroy() will free the inode of snapshot and set
> root's refs to zero(btrfs_set_root_refs()), if this inode happens to
> be the only one in the rbtree of the snapshot's root at this moment,
> we add this root to the dead_root list.
>
> (2) Unfortunately, after (1), our snapshot-aware defrag work may read
> another inode in this snapshot into memory during 'relink' stage, and
> later after we finish relink work and iput() will force us to add the
> snapshot's root to the dead_root list again.
>
> So that's why we get double list_add and list_del corruption.
>
> And IMO, it can also take place without snapshot-aware defrag, but it's a
> rare case.

I'm seeing a smattering of reports that resemble list corruption on
the M/L, so that is possible.

>
> So could you please try this?
>
> thanks,
> liubo
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index f154946..d4ee66b 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -885,7 +885,15 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
>  int btrfs_add_dead_root(struct btrfs_root *root)
>  {
>         spin_lock(&root->fs_info->trans_lock);
> +       if (!list_empty(&root->root_list)) {
> +               struct btrfs_root *tmp;
> +               list_for_each_entry(tmp, &root->fs_info->dead_roots, root_list)
> +                       if (tmp == root)
> +                               goto unlock;
> +       }
> +
>         list_add(&root->root_list, &root->fs_info->dead_roots);
> +unlock:
>         spin_unlock(&root->fs_info->trans_lock);
>         return 0;
>  }
>

It feels like we're correcting the problem after-the-fact with this
method, instead of addressing the root problem.  But I was able to
successfully run with this patch.

I slightly modified your patch as follows by introducing a WARN_ON in
order to get a back trace, and also to give me a positive confirmation
that I was triggering the problem.

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d6b17fa..0c1066e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -885,7 +885,18 @@ static noinline int commit_cowonly_roots(struct
btrfs_trans_handle *trans,
 int btrfs_add_dead_root(struct btrfs_root *root)
 {
 	spin_lock(&root->fs_info->trans_lock);
+	if (!list_empty(&root->root_list)) {
+		struct btrfs_root *tmp;
+		list_for_each_entry(tmp, &root->fs_info->dead_roots, root_list)
+			if (tmp == root) {
+				printk(KERN_ERR "btrfs: Duplicate dead root entry.\n");
+				WARN_ON(1);
+				goto unlock;
+			}
+	}
+
 	list_add(&root->root_list, &root->fs_info->dead_roots);
+unlock:
 	spin_unlock(&root->fs_info->trans_lock);
 	return 0;
 }
-- 

I was able to trigger the problem several times (16 separate times
according to dmesg) without killing the cleaner process, and
everything appears to have continued successfully after encountering a
duplicate list entry.  My test partition passes btrfsck afterwards.

13 out of the 16 backtraces seem support your hypothesis as passing
through the iput in your patch:

[ 4367.314806] btrfs: Duplicate dead root entry.
[ 4367.314809] ------------[ cut here ]------------
[ 4367.314834] WARNING: at fs/btrfs/transaction.c:893
btrfs_add_dead_root+0x73/0xbc [btrfs]()
[ 4367.314836] Hardware name: OptiPlex 745
[ 4367.314841] Modules linked in: ipv6 snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm tg3 snd_page_alloc
snd_timer snd iTCO_wdt iTCO_vendor_support ppdev parport_pc microcode
i2c_i801 floppy parport sr_mod lpc_ich serio_raw pcspkr ablk_helper
cryptd lrw xts gf128mul aes_x86_64 sha256_generic fuse xfs nfs lockd
sunrpc reiserfs btrfs zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache
sl811_hcd hid_generic xhci_hcd ohci_hcd uhci_hcd ehci_hcd
[ 4367.314887] Pid: 4463, comm: btrfs-endio-wri Tainted: G        W
3.7.4-sad-v2+ #1
[ 4367.314889] Call Trace:
[ 4367.314895]  [<ffffffff81030586>] warn_slowpath_common+0x83/0x9b
[ 4367.314899]  [<ffffffff810305b8>] warn_slowpath_null+0x1a/0x1c
[ 4367.314915]  [<ffffffffa0179e0b>] btrfs_add_dead_root+0x73/0xbc [btrfs]
[ 4367.314931]  [<ffffffffa0187bef>] btrfs_destroy_inode+0x227/0x25b [btrfs]
[ 4367.314936]  [<ffffffff8111393a>] destroy_inode+0x3b/0x54
[ 4367.314940]  [<ffffffff81113a9c>] evict+0x149/0x151
[ 4367.314944]  [<ffffffff81114322>] iput+0x12c/0x135
[ 4367.314959]  [<ffffffffa01845e7>] relink_extent_backref+0x669/0x6af [btrfs]
[ 4367.314964]  [<ffffffff815e9849>] ? __slab_free+0x17c/0x21b
[ 4367.314980]  [<ffffffffa0184d9d>] ?
btrfs_finish_ordered_io+0x770/0x827 [btrfs]
[ 4367.314995]  [<ffffffffa0184d6d>] btrfs_finish_ordered_io+0x740/0x827 [btrfs]
[ 4367.315011]  [<ffffffffa0184e69>] finish_ordered_fn+0x15/0x17 [btrfs]
[ 4367.315034]  [<ffffffffa019e7a1>] worker_loop+0x14c/0x493 [btrfs]
[ 4367.315051]  [<ffffffffa019e655>] ? btrfs_queue_worker+0x258/0x258 [btrfs]
[ 4367.315055]  [<ffffffff8104c750>] kthread+0xba/0xc2
[ 4367.315059]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
[ 4367.315062]  [<ffffffff815f301c>] ret_from_fork+0x7c/0xb0
[ 4367.315066]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
[ 4367.315069] ---[ end trace b71b586e95cb7ba0 ]---

gdb resolves the (relink_extent_backref+0x669) reference back to just
after the iput.

(gdb) l *(relink_extent_backref+0x669)
0x335e7 is in relink_extent_backref (fs/btrfs/inode.c:2342).
2337	out_unlock:
2338		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lock_start, lock_end,
2339				     &cached, GFP_NOFS);
2340		iput(inode);
2341		return ret;
2342	}
2343	
2344	static void relink_file_extents(struct new_sa_defrag_extent *new)
2345	{
2346		struct btrfs_path *path;

The other 3 backtraces came down a different path:

[14857.072378] btrfs: Duplicate dead root entry.
[14857.072385] ------------[ cut here ]------------
[14857.072423] WARNING: at fs/btrfs/transaction.c:893
btrfs_add_dead_root+0x73/0xbc [btrfs]()
[14857.072427] Hardware name: OptiPlex 745
[14857.072430] Modules linked in: ipv6 snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm tg3 snd_page_alloc
snd_timer snd iTCO_wdt iTCO_vendor_support ppdev parport_pc microcode
i2c_i801 floppy parport sr_mod lpc_ich serio_raw pcspkr ablk_helper
cryptd lrw xts gf128mul aes_x86_64 sha256_generic fuse xfs nfs lockd
sunrpc reiserfs btrfs zlib_deflate ext4 jbd2 ext3 jbd ext2 mbcache
sl811_hcd hid_generic xhci_hcd ohci_hcd uhci_hcd ehci_hcd
[14857.072496] Pid: 4301, comm: btrfs-cleaner Tainted: G        W
3.7.4-sad-v2+ #1
[14857.072499] Call Trace:
[14857.072512]  [<ffffffff81030586>] warn_slowpath_common+0x83/0x9b
[14857.072518]  [<ffffffff810305b8>] warn_slowpath_null+0x1a/0x1c
[14857.072540]  [<ffffffffa0179e0b>] btrfs_add_dead_root+0x73/0xbc [btrfs]
[14857.072564]  [<ffffffffa0187bef>] btrfs_destroy_inode+0x227/0x25b [btrfs]
[14857.072573]  [<ffffffff8111393a>] destroy_inode+0x3b/0x54
[14857.072578]  [<ffffffff81113a9c>] evict+0x149/0x151
[14857.072585]  [<ffffffff81114322>] iput+0x12c/0x135
[14857.072607]  [<ffffffffa01a21c8>] ? btrfs_defrag_file+0xa5b/0xaa1 [btrfs]
[14857.072630]  [<ffffffffa0189433>] btrfs_run_defrag_inodes+0x256/0x2c0 [btrfs]
[14857.072651]  [<ffffffffa0173da0>] cleaner_kthread+0x79/0xe6 [btrfs]
[14857.072671]  [<ffffffffa0173d27>] ? transaction_kthread+0x1a0/0x1a0 [btrfs]
[14857.072678]  [<ffffffff8104c750>] kthread+0xba/0xc2
[14857.072684]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
[14857.072691]  [<ffffffff815f301c>] ret_from_fork+0x7c/0xb0
[14857.072696]  [<ffffffff8104c696>] ? kthread_freezable_should_stop+0x52/0x52
[14857.072701] ---[ end trace b71b586e95cb7bac ]---

The (btrfs_run_defrag_inodes+0x256) resolves back to the iput in
__btrfs_run_defrag_inode()

(gdb) l *(btrfs_run_defrag_inodes+0x256)
0x38433 is in btrfs_run_defrag_inodes (fs/btrfs/file.c:347).
342			btrfs_requeue_inode_defrag(inode, defrag);
343		} else {
344			kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
345		}
346	
347		iput(inode);
348		return 0;
349	}
350	
351	/*
