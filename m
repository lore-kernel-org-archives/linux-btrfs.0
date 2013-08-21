Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:54850 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3HUNo4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Aug 2013 09:44:56 -0400
Received: by mail-oa0-f42.google.com with SMTP id i18so818108oag.29
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Aug 2013 06:44:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKcLGm_c=qimNQiByVA5ko-7K4ojL2mf5yoxLyiVCwKgaLcAZA@mail.gmail.com>
References: <CAKcLGm_DXiwJrAMYG66ZiEmXtSKe0z0LUPfxat0Repb0jfDnNA@mail.gmail.com>
	<20130813141542.GF2150@localhost.localdomain>
	<CAKcLGm99PdyuurtmA6_ZW1PQOaH4piQSK-VYQMT-0PJkgDf-Yw@mail.gmail.com>
	<CAKcLGm_c=qimNQiByVA5ko-7K4ojL2mf5yoxLyiVCwKgaLcAZA@mail.gmail.com>
Date: Wed, 21 Aug 2013 08:44:55 -0500
Message-ID: <CAKcLGm_jFa_2FaaaudRZF8JRymh1t3ASMFN1tFGbs0PGt1vNaQ@mail.gmail.com>
Subject: Re: Kernel BUG on Snapshot Deletion (3.11.0-rc5)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Josef Bacik <jbacik@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 15, 2013 at 12:29 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> I'm running into a curious problem.
>
> In the process of making my script portable, I am breaking the ability
> to replicate the error.
>
> I'm trying to isolate the aspect of my local script that is triggering
> the error.  No firm insights yet.
>
>
> On Tue, Aug 13, 2013 at 11:03 AM, Mitch Harder
> <mitch.harder@sabayonlinux.org> wrote:
>> Let me work on making that script more portable, and hopefully quicker
>> to reproduce.
>>
>> On Tue, Aug 13, 2013 at 9:15 AM, Josef Bacik <jbacik@fusionio.com> wrote:
>>> On Mon, Aug 12, 2013 at 11:06:27PM -0500, Mitch Harder wrote:
>>>> I'm hitting a btrfs Kernel BUG running a snapshot stress script with
>>>> linux-3.11.0-rc5.
>>>>
>>>
>>> I can haz script?  Thanks,
>>>

I've had a hard time assembling a portable reproducer for this issue.

I discovered that my reproducer was highly dependent on a local
archive of out-of-date git kernel sources.  My efforts to reproduce
the error with a portable set of scripts with publicly available
kernel git sources weren't successful.

It seems like this issue is related to a corner-case workload that is
difficult to reproduce.

So I've bisected the error I was seeing with my local script, and
identified the following commit as triggering my issue:

commit:    3c64a1aba7cfcb04f79e76f859b3d66660275d59
Btrfs: cleanup: don't check the same thing twice
https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/fs/btrfs?h=for-linus&id=3c64a1aba7cfcb04

I tested a kernel which reverted this change, and also added WARN_ON
lines to provide a back trace.

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 4b86916..336d628 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -82,6 +82,12 @@ static struct dentry *btrfs_get_dentry(struct
super_block *sb, u64 objectid,
         goto fail;
     }

+    if (btrfs_root_refs(&root->root_item) == 0) {
+        WARN_ON(1);
+        err = -ENOENT;
+        goto fail;
+    }
+
     key.objectid = objectid;
     btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
     key.offset = 0;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 94413af..4010257 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -310,6 +310,12 @@ static int __btrfs_run_defrag_inode(struct
btrfs_fs_info *fs_info,
         goto cleanup;
     }

+    if (btrfs_root_refs(&inode_root->root_item) == 0) {
+        WARN_ON(1);
+        ret = -ENOENT;
+        goto cleanup;
+    }
+
     key.objectid = defrag->ino;
     btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
     key.offset = 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cd46e2c..a1091f7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2302,6 +2302,12 @@ static noinline int
relink_extent_backref(struct btrfs_path *path,
             return 0;
         return PTR_ERR(root);
     }
+    if (btrfs_root_refs(&root->root_item) == 0) {
+        srcu_read_unlock(&fs_info->subvol_srcu, index);
+        /* parse ENOENT to 0 */
+        WARN_ON(1);
+        return 0;
+    }

     /* step 2: get inode */
     key.objectid = backref->inum;
@@ -4703,6 +4709,12 @@ static int fixup_tree_root_location(struct
btrfs_root *root,
         goto out;
     }

+    if (btrfs_root_refs(&new_root->root_item) == 0) {
+        WARN_ON(1);
+        err = -ENOENT;
+        goto out;
+    }
+
     *sub_root = new_root;
     location->objectid = btrfs_root_dirid(&new_root->root_item);
     location->type = BTRFS_INODE_ITEM_KEY;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0e17a30..0f74235 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2969,6 +2969,12 @@ static long btrfs_ioctl_default_subvol(struct
file *file, void __user *argp)
         goto out;
     }

+    if (btrfs_root_refs(&new_root->root_item) == 0) {
+        WARN_ON(1);
+        ret = -ENOENT;
+        goto out;
+    }
+
     path = btrfs_alloc_path();
     if (!path) {
         ret = -ENOMEM;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b267c3c..3cf4716 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -793,6 +793,11 @@ find_root:
     if (IS_ERR(new_root))
         return ERR_CAST(new_root);

+    if (btrfs_root_refs(&new_root->root_item) == 0) {
+        WARN_ON(1);
+        return ERR_PTR(-ENOENT);
+    }
+
     dir_id = btrfs_root_dirid(&new_root->root_item);
 setup_root:
     location.objectid = dir_id;
-- 

With this change, I can process my testing workload without crashing,
but I am receiving some WARN_ON back traces from this change:

[  220.437420] device fsid 32da6e58-d08e-48e9-a598-4224401c5881 devid
1 transid 4 /dev/sda7
[  220.560183] device fsid 32da6e58-d08e-48e9-a598-4224401c5881 devid
1 transid 4 /dev/sda7
[  220.561719] device fsid 32da6e58-d08e-48e9-a598-4224401c5881 devid
1 transid 4 /dev/sda7
[  220.562761] btrfs: setting 8 feature flag
[  220.562769] btrfs: force lzo compression
[  220.562775] btrfs: enabling auto defrag
[  220.562778] btrfs: disk space caching is enabled
[  220.562781] btrfs flagging fs with big metadata feature
[  220.562784] btrfs: lzo incompat flag set.
[ 1616.886868] ------------[ cut here ]------------
[ 1616.886912] WARNING: at fs/btrfs/inode.c:2308
relink_extent_backref+0x103/0x721 [btrfs]()
[ 1616.886931] Modules linked in: ipv6 iTCO_wdt iTCO_vendor_support
snd_hda_codec_analog ppdev snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm tg3 serio_raw ptp pcspkr sr_mod microcode i2c_i801
snd_page_alloc pps_core parport_pc snd_timer lpc_ich snd floppy
parport xts ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64
sha256_generic fuse xfs nfs lockd sunrpc reiserfs btrfs zlib_deflate
ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd hid_generic xhci_hcd
ohci_hcd uhci_hcd ehci_pci ehci_hcd
[ 1616.887019] CPU: 0 PID: 4556 Comm: btrfs-endio-wri Not tainted
3.10.6-git-local-v2 #2
[ 1616.887024] Hardware name: Dell Inc.                 OptiPlex 745
              /0WF810, BIOS 2.6.4  03/01/2010
[ 1616.887029]  ffffffffa01f7ac5 ffff88007c36dbc8 ffffffff8161a34a
ffff88007c36dc08
[ 1616.887036]  ffffffff8103035a ffff88007c36dc18 0000000000000000
ffff880010c47e40
[ 1616.887043]  ffff88007647a698 ffff8800792d7900 ffff880010c47f60
ffff88007c36dc18
[ 1616.887050] Call Trace:
[ 1616.887064]  [<ffffffff8161a34a>] dump_stack+0x19/0x1b
[ 1616.887071]  [<ffffffff8103035a>] warn_slowpath_common+0x67/0x80
[ 1616.887077]  [<ffffffff8103038d>] warn_slowpath_null+0x1a/0x1c
[ 1616.887100]  [<ffffffffa019ea82>] relink_extent_backref+0x103/0x721 [btrfs]
[ 1616.887123]  [<ffffffffa0196f55>] ? record_extent_backrefs+0xa7/0xa7 [btrfs]
[ 1616.887145]  [<ffffffffa01959a1>] ?
__btrfs_end_transaction+0x2a6/0x2ca [btrfs]
[ 1616.887167]  [<ffffffffa0196f31>] ? record_extent_backrefs+0x83/0xa7 [btrfs]
[ 1616.887205]  [<ffffffffa019f7e2>] btrfs_finish_ordered_io+0x742/0x829 [btrfs]
[ 1616.887212]  [<ffffffff810c2fb7>] ? mempool_free_slab+0x17/0x19
[ 1616.887235]  [<ffffffffa019f8de>] finish_ordered_fn+0x15/0x17 [btrfs]
[ 1616.887258]  [<ffffffffa01baa84>] worker_loop+0x14c/0x480 [btrfs]
[ 1616.887280]  [<ffffffffa01ba938>] ? btrfs_queue_worker+0x258/0x258 [btrfs]
[ 1616.887287]  [<ffffffff8104dc04>] kthread+0xba/0xc2
[ 1616.887294]  [<ffffffff8104db4a>] ? kthread_freezable_should_stop+0x52/0x52
[ 1616.887300]  [<ffffffff8162149c>] ret_from_fork+0x7c/0xb0
[ 1616.887306]  [<ffffffff8104db4a>] ? kthread_freezable_should_stop+0x52/0x52
[ 1616.887310] ---[ end trace c70e9072a5cea5f7 ]---
[ 1616.888856] ------------[ cut here ]------------
[ 1616.888884] WARNING: at fs/btrfs/inode.c:2308
relink_extent_backref+0x103/0x721 [btrfs]()
[ 1616.888888] Modules linked in: ipv6 iTCO_wdt iTCO_vendor_support
snd_hda_codec_analog ppdev snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm tg3 serio_raw ptp pcspkr sr_mod microcode i2c_i801
snd_page_alloc pps_core parport_pc snd_timer lpc_ich snd floppy
parport xts ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64
sha256_generic fuse xfs nfs lockd sunrpc reiserfs btrfs zlib_deflate
ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd hid_generic xhci_hcd
ohci_hcd uhci_hcd ehci_pci ehci_hcd
[ 1616.888959] CPU: 0 PID: 4536 Comm: btrfs-endio-wri Tainted: G
 W    3.10.6-git-local-v2 #2
[ 1616.888963] Hardware name: Dell Inc.                 OptiPlex 745
              /0WF810, BIOS 2.6.4  03/01/2010
[ 1616.888966]  ffffffffa01f7ac5 ffff880037463bc8 ffffffff8161a34a
ffff880037463c08
[ 1616.888973]  ffffffff8103035a ffff880037463c18 0000000000000000
ffff880010c47000
[ 1616.888980]  ffff88007647a698 ffff8800792d7f30 ffff880010c47420
ffff880037463c18
[ 1616.888987] Call Trace:
[ 1616.888996]  [<ffffffff8161a34a>] dump_stack+0x19/0x1b
[ 1616.889021]  [<ffffffff8103035a>] warn_slowpath_common+0x67/0x80
[ 1616.889028]  [<ffffffff8103038d>] warn_slowpath_null+0x1a/0x1c
[ 1616.889052]  [<ffffffffa019ea82>] relink_extent_backref+0x103/0x721 [btrfs]
[ 1616.889075]  [<ffffffffa0196f55>] ? record_extent_backrefs+0xa7/0xa7 [btrfs]
[ 1616.889097]  [<ffffffffa01dfd06>] ?
iterate_inodes_from_logical+0x89/0x98 [btrfs]
[ 1616.889119]  [<ffffffffa01959a1>] ?
__btrfs_end_transaction+0x2a6/0x2ca [btrfs]
[ 1616.889141]  [<ffffffffa0196f31>] ? record_extent_backrefs+0x83/0xa7 [btrfs]
[ 1616.889164]  [<ffffffffa019f7e2>] btrfs_finish_ordered_io+0x742/0x829 [btrfs]
[ 1616.889171]  [<ffffffff8103d672>] ? try_to_del_timer_sync+0x4b/0x57
[ 1616.889177]  [<ffffffff8103cdfd>] ? __internal_add_timer+0xbe/0xbe
[ 1616.889199]  [<ffffffffa019f8de>] finish_ordered_fn+0x15/0x17 [btrfs]
[ 1616.889221]  [<ffffffffa01baa84>] worker_loop+0x14c/0x480 [btrfs]
[ 1616.889243]  [<ffffffffa01ba938>] ? btrfs_queue_worker+0x258/0x258 [btrfs]
[ 1616.889250]  [<ffffffff8104dc04>] kthread+0xba/0xc2
[ 1616.889256]  [<ffffffff8104db4a>] ? kthread_freezable_should_stop+0x52/0x52
[ 1616.889262]  [<ffffffff8162149c>] ret_from_fork+0x7c/0xb0
[ 1616.889268]  [<ffffffff8104db4a>] ? kthread_freezable_should_stop+0x52/0x52
[ 1616.889272] ---[ end trace c70e9072a5cea5f8 ]---
[ 1831.572042] ------------[ cut here ]------------
[ 1831.572078] WARNING: at fs/btrfs/file.c:314
btrfs_run_defrag_inodes+0x18c/0x339 [btrfs]()
[ 1831.572081] Modules linked in: ipv6 iTCO_wdt iTCO_vendor_support
snd_hda_codec_analog ppdev snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm tg3 serio_raw ptp pcspkr sr_mod microcode i2c_i801
snd_page_alloc pps_core parport_pc snd_timer lpc_ich snd floppy
parport xts ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64
sha256_generic fuse xfs nfs lockd sunrpc reiserfs btrfs zlib_deflate
ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd hid_generic xhci_hcd
ohci_hcd uhci_hcd ehci_pci ehci_hcd
[ 1831.572133] CPU: 0 PID: 4543 Comm: btrfs-cleaner Tainted: G
W    3.10.6-git-local-v2 #2
[ 1831.572136] Hardware name: Dell Inc.                 OptiPlex 745
              /0WF810, BIOS 2.6.4  03/01/2010
[ 1831.572139]  ffffffffa01f7e4b ffff88000dc0bd48 ffffffff8161a34a
ffff88000dc0bd88
[ 1831.572144]  ffffffff8103035a ffff88000dc0bd98 0000000000000000
ffff880004d48700
[ 1831.572149]  ffff88007647a000 ffff880004d48700 0000000000000166
ffff88000dc0bd98
[ 1831.572154] Call Trace:
[ 1831.572165]  [<ffffffff8161a34a>] dump_stack+0x19/0x1b
[ 1831.572171]  [<ffffffff8103035a>] warn_slowpath_common+0x67/0x80
[ 1831.572176]  [<ffffffff8103038d>] warn_slowpath_null+0x1a/0x1c
[ 1831.572193]  [<ffffffffa01a4790>] btrfs_run_defrag_inodes+0x18c/0x339 [btrfs]
[ 1831.572209]  [<ffffffffa018ed0a>] cleaner_kthread+0x152/0x157 [btrfs]
[ 1831.572224]  [<ffffffffa018ebb8>] ? transaction_kthread+0x1a0/0x1a0 [btrfs]
[ 1831.572229]  [<ffffffff8104dc04>] kthread+0xba/0xc2
[ 1831.572234]  [<ffffffff8104db4a>] ? kthread_freezable_should_stop+0x52/0x52
[ 1831.572239]  [<ffffffff8162149c>] ret_from_fork+0x7c/0xb0
[ 1831.572243]  [<ffffffff8104db4a>] ? kthread_freezable_should_stop+0x52/0x52
[ 1831.572247] ---[ end trace c70e9072a5cea5f9 ]---
[ 1925.675015] ------------[ cut here ]------------
[ 1925.675051] WARNING: at fs/btrfs/inode.c:2308
relink_extent_backref+0x103/0x721 [btrfs]()
[ 1925.675054] Modules linked in: ipv6 iTCO_wdt iTCO_vendor_support
snd_hda_codec_analog ppdev snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm tg3 serio_raw ptp pcspkr sr_mod microcode i2c_i801
snd_page_alloc pps_core parport_pc snd_timer lpc_ich snd floppy
parport xts ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64
sha256_generic fuse xfs nfs lockd sunrpc reiserfs btrfs zlib_deflate
ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd hid_generic xhci_hcd
ohci_hcd uhci_hcd ehci_pci ehci_hcd
[ 1925.675106] CPU: 0 PID: 4536 Comm: btrfs-endio-wri Tainted: G
 W    3.10.6-git-local-v2 #2
[ 1925.675109] Hardware name: Dell Inc.                 OptiPlex 745
              /0WF810, BIOS 2.6.4  03/01/2010
[ 1925.675113]  ffffffffa01f7ac5 ffff880037463bc8 ffffffff8161a34a
ffff880037463c08
[ 1925.675118]  ffffffff8103035a ffff880037463c18 0000000000000000
ffff880065f9dba0
[ 1925.675123]  ffff88007647a698 ffff8800792d7a20 ffff88007769fa20
ffff880037463c18
[ 1925.675128] Call Trace:
[ 1925.675139]  [<ffffffff8161a34a>] dump_stack+0x19/0x1b
[ 1925.675145]  [<ffffffff8103035a>] warn_slowpath_common+0x67/0x80
[ 1925.675150]  [<ffffffff8103038d>] warn_slowpath_null+0x1a/0x1c
[ 1925.675166]  [<ffffffffa019ea82>] relink_extent_backref+0x103/0x721 [btrfs]
[ 1925.675171]  [<ffffffff816193d0>] ? __slab_free+0x181/0x228
[ 1925.675187]  [<ffffffffa0196f55>] ? record_extent_backrefs+0xa7/0xa7 [btrfs]
[ 1925.675204]  [<ffffffffa019f812>] ?
btrfs_finish_ordered_io+0x772/0x829 [btrfs]
[ 1925.675220]  [<ffffffffa019f7e2>] btrfs_finish_ordered_io+0x742/0x829 [btrfs]
[ 1925.675226]  [<ffffffff8103d672>] ? try_to_del_timer_sync+0x4b/0x57
[ 1925.675242]  [<ffffffffa019f8de>] finish_ordered_fn+0x15/0x17 [btrfs]
[ 1925.675258]  [<ffffffffa01baa84>] worker_loop+0x14c/0x480 [btrfs]
[ 1925.675274]  [<ffffffffa01ba938>] ? btrfs_queue_worker+0x258/0x258 [btrfs]
[ 1925.675280]  [<ffffffff8104dc04>] kthread+0xba/0xc2
[ 1925.675285]  [<ffffffff8104db4a>] ? kthread_freezable_should_stop+0x52/0x52
[ 1925.675289]  [<ffffffff8162149c>] ret_from_fork+0x7c/0xb0
[ 1925.675294]  [<ffffffff8104db4a>] ? kthread_freezable_should_stop+0x52/0x52
[ 1925.675297] ---[ end trace c70e9072a5cea5fa ]---
[ 2221.172704] ------------[ cut here ]------------
[ 2221.172734] WARNING: at fs/btrfs/inode.c:2308
relink_extent_backref+0x103/0x721 [btrfs]()
[ 2221.172737] Modules linked in: ipv6 iTCO_wdt iTCO_vendor_support
snd_hda_codec_analog ppdev snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm tg3 serio_raw ptp pcspkr sr_mod microcode i2c_i801
snd_page_alloc pps_core parport_pc snd_timer lpc_ich snd floppy
parport xts ablk_helper cryptd lrw gf128mul glue_helper aes_x86_64
sha256_generic fuse xfs nfs lockd sunrpc reiserfs btrfs zlib_deflate
ext4 jbd2 ext3 jbd ext2 mbcache sl811_hcd hid_generic xhci_hcd
ohci_hcd uhci_hcd ehci_pci ehci_hcd
[ 2221.172807] CPU: 0 PID: 4557 Comm: btrfs-endio-wri Tainted: G
 W    3.10.6-git-local-v2 #2
[ 2221.172811] Hardware name: Dell Inc.                 OptiPlex 745
              /0WF810, BIOS 2.6.4  03/01/2010
[ 2221.172814]  ffffffffa01f7ac5 ffff88002ae91bc8 ffffffff8161a34a
ffff88002ae91c08
[ 2221.172821]  ffffffff8103035a ffff88002ae91c18 0000000000000000
ffff880017f28d20
[ 2221.172828]  ffff88007647a698 ffff8800792d76c0 ffff880017f28a20
ffff88002ae91c18
[ 2221.172834] Call Trace:
[ 2221.172845]  [<ffffffff8161a34a>] dump_stack+0x19/0x1b
[ 2221.172852]  [<ffffffff8103035a>] warn_slowpath_common+0x67/0x80
[ 2221.172857]  [<ffffffff8103038d>] warn_slowpath_null+0x1a/0x1c
[ 2221.172880]  [<ffffffffa019ea82>] relink_extent_backref+0x103/0x721 [btrfs]
[ 2221.172886]  [<ffffffff816193d0>] ? __slab_free+0x181/0x228
[ 2221.172909]  [<ffffffffa0196f55>] ? record_extent_backrefs+0xa7/0xa7 [btrfs]
[ 2221.172932]  [<ffffffffa019f812>] ?
btrfs_finish_ordered_io+0x772/0x829 [btrfs]
[ 2221.172956]  [<ffffffffa019f7e2>] btrfs_finish_ordered_io+0x742/0x829 [btrfs]
[ 2221.172962]  [<ffffffff810c2fb7>] ? mempool_free_slab+0x17/0x19
[ 2221.172985]  [<ffffffffa019f8de>] finish_ordered_fn+0x15/0x17 [btrfs]
[ 2221.173005]  [<ffffffffa01baa84>] worker_loop+0x14c/0x480 [btrfs]
[ 2221.173056]  [<ffffffffa01ba938>] ? btrfs_queue_worker+0x258/0x258 [btrfs]
[ 2221.173064]  [<ffffffff8104dc04>] kthread+0xba/0xc2
[ 2221.173071]  [<ffffffff8104db4a>] ? kthread_freezable_should_stop+0x52/0x52
[ 2221.173076]  [<ffffffff8162149c>] ret_from_fork+0x7c/0xb0
[ 2221.173082]  [<ffffffff8104db4a>] ? kthread_freezable_should_stop+0x52/0x52
[ 2221.173086] ---[ end trace c70e9072a5cea5fc ]---
