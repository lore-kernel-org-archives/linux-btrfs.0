Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:51402 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2GWPRx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jul 2012 11:17:53 -0400
Received: by qadb17 with SMTP id b17so1167148qad.19
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2012 08:17:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341409108-13567-8-git-send-email-ablock84@googlemail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
	<1341409108-13567-8-git-send-email-ablock84@googlemail.com>
Date: Mon, 23 Jul 2012 18:17:52 +0300
Message-ID: <CAHf9xvay-hCgrG_Aabu9y17C=9FGa1PmPLF25Qe9442gSN6MMw@mail.gmail.com>
Subject: Re: [RFC PATCH 7/7] Btrfs: introduce BTRFS_IOC_SEND for btrfs
 send/receive (part 2)
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Alexander Block <ablock84@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alexander,
I did some testing of the case where same inode, but with a different
generation, exists both in send_root and in parent_root.
I know that this can happen primarily when "inode_cache" option is
enabled. So first I just tested some differential sends, where parent
and root are unrelated subvolumes. Here are some issues:

1) The top subvolume inode (ino=BTRFS_FIRST_FREE_OBJECTID) is treated
also as deleted + recreated. So the code goes into process_all_refs()
path and does several strange things, such as trying to orphanize the
top inode. Also get_cur_path() always returns "" for the top subvolume
(without checking whether it is an orphan).  Another complication for
the top inode is that its parent dir is itself.
I made the following fix:
@@ -3782,7 +3972,13 @@ static int changed_inode(struct send_ctx *sctx,

                right_gen = btrfs_inode_generation(sctx->right_path->nodes[0],
                                right_ii);
-               if (left_gen != right_gen)
+               if (left_gen != right_gen && sctx->cur_ino !=
BTRFS_FIRST_FREE_OBJECTID)
                        sctx->cur_inode_new_gen = 1;

So basically, don't try to delete and re-create it, but treat it like
a change. Since the top subvolume inode is S_IFDIR, and dir can have
only one hardlink (and hopefully it is always ".."), we will never
need to change anything for this INODE_REF. I also added:

@@ -2526,6 +2615,14 @@ static int process_recorded_refs(struct send_ctx *sctx)
        int did_overwrite = 0;
        int is_orphan = 0;

+       BUG_ON(sctx->cur_ino <= BTRFS_FIRST_FREE_OBJECTID);

2) After I fixed this, I hit another issue, where inodes under the top
subvolume dir, attempt to rmdir() the top dir, while iterating over
check_dirs in process_recorded_refs(), because (top_dir_ino,
top_dir_gen) indicate that it was deleted. So I added:

@@ -2714,10 +2857,19 @@ verbose_printk("btrfs: process_recorded_refs
%llu\n", sctx->cur_ino);
         */
        ULIST_ITER_INIT(&uit);
        while ((un = ulist_next(check_dirs, &uit))) {
+               /* Do not attempt to rmdir it the top subvolume dir */
+               if (un->val == BTRFS_FIRST_FREE_OBJECTID)
+                       continue;
+
                if (un->val > sctx->cur_ino)
                        continue;

3) process_recorded_refs() always increments the send_progress:
	/*
	 * Current inode is now at it's new position, so we must increase
	 * send_progress
	 */
	sctx->send_progress = sctx->cur_ino + 1;

However, in the changed_inode() path I am testing, process_all_refs()
is called twice with the same inode (once for deleted inode, once for
the recreated inode), so after the first call, send_progress is
incremented and doesn't match the inode anymore. I don't think I hit
any issues because of this, just that it's confusing.

4)

> +/*
> + * Record and process all refs at once. Needed when an inode changes the
> + * generation number, which means that it was deleted and recreated.
> + */
> +static int process_all_refs(struct send_ctx *sctx,
> +                           enum btrfs_compare_tree_result cmd)
> +{
> +       int ret;
> +       struct btrfs_root *root;
> +       struct btrfs_path *path;
> +       struct btrfs_key key;
> +       struct btrfs_key found_key;
> +       struct extent_buffer *eb;
> +       int slot;
> +       iterate_inode_ref_t cb;
> +
> +       path = alloc_path_for_send();
> +       if (!path)
> +               return -ENOMEM;
> +
> +       if (cmd == BTRFS_COMPARE_TREE_NEW) {
> +               root = sctx->send_root;
> +               cb = __record_new_ref;
> +       } else if (cmd == BTRFS_COMPARE_TREE_DELETED) {
> +               root = sctx->parent_root;
> +               cb = __record_deleted_ref;
> +       } else {
> +               BUG();
> +       }
> +
> +       key.objectid = sctx->cmp_key->objectid;
> +       key.type = BTRFS_INODE_REF_KEY;
> +       key.offset = 0;
> +       while (1) {
> +               ret = btrfs_search_slot_for_read(root, &key, path, 1, 0);
> +               if (ret < 0) {
> +                       btrfs_release_path(path);
> +                       goto out;
> +               }
> +               if (ret) {
> +                       btrfs_release_path(path);
> +                       break;
> +               }
> +
> +               eb = path->nodes[0];
> +               slot = path->slots[0];
> +               btrfs_item_key_to_cpu(eb, &found_key, slot);
> +
> +               if (found_key.objectid != key.objectid ||
> +                   found_key.type != key.type) {
> +                       btrfs_release_path(path);
> +                       break;
> +               }
> +
> +               ret = iterate_inode_ref(sctx, sctx->parent_root, path,
> +                               &found_key, 0, cb, sctx);

Shouldn't it be the root that you calculated eariler and not
sctx->parent_root? I guess in this case it doesn't matter, because
"resolve" is 0, and the passed root is only used for resolve. But
still confusing.

5) When I started testing with "inode_cache" enabled, I hit another
issue. When this mount option is enabled, then FREE_INO and FREE_SPACE
items now appear in the file tree. As a result, the code tries to
create the FREE_INO item with an orphan name, then tries to find its
INODE_REF, but fails because it has no INODE_REFs. So

@@ -3923,6 +4127,13 @@ static int changed_cb(struct btrfs_root *left_root,
        int ret = 0;
        struct send_ctx *sctx = ctx;

+       /* Ignore non-FS objects */
+       if (key->objectid == BTRFS_FREE_INO_OBJECTID ||
+               key->objectid == BTRFS_FREE_SPACE_OBJECTID)
+               return 0;

makes sense?

Thanks,
Alex.
