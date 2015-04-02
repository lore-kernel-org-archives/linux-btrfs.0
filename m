Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37482 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbDBKFT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Apr 2015 06:05:19 -0400
Received: by igcxg11 with SMTP id xg11so69297822igc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Apr 2015 03:05:18 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1427947011-4978-2-git-send-email-dccitaliano@gmail.com>
References: <1427947011-4978-1-git-send-email-dccitaliano@gmail.com>
	<1427947011-4978-2-git-send-email-dccitaliano@gmail.com>
Date: Thu, 2 Apr 2015 11:05:18 +0100
Message-ID: <CAL3q7H5a9B40NNf+WpK917kg3nQ7EPqt2kBbiXEqyekfGJg3TA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: RENAME_EXCHANGE semantic for renameat2()
From: Filipe David Manana <fdmanana@gmail.com>
To: Davide Italiano <dccitaliano@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 2, 2015 at 4:56 AM, Davide Italiano <dccitaliano@gmail.com> wrote:
> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>

Hi, only skimmed through it, a few small comments below.
I haven't surely tested it as well (I assume you ran all xfstests from
the generic group).
Thanks.

> ---
>  fs/btrfs/inode.c | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 189 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d2e732d..49b0867 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8890,6 +8890,190 @@ static int btrfs_getattr(struct vfsmount *mnt,
>         return 0;
>  }
>
> +static int btrfs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
> +                             struct inode *new_dir, struct dentry *new_dentry)
> +{
> +       struct btrfs_trans_handle *trans;
> +       struct btrfs_root *root = BTRFS_I(old_dir)->root;
> +       struct btrfs_root *dest = BTRFS_I(new_dir)->root;
> +       struct inode *new_inode = new_dentry->d_inode;
> +       struct inode *old_inode = old_dentry->d_inode;
> +       struct timespec ctime = CURRENT_TIME;
> +       u64 old_ino = btrfs_ino(old_inode);
> +       u64 new_ino = btrfs_ino(new_inode);
> +       u64 old_idx = 0;
> +       u64 new_idx = 0;
> +       u64 root_objectid;
> +       int ret;
> +
> +       /* we only allow rename subvolume link between subvolumes */
> +       if (old_ino != BTRFS_FIRST_FREE_OBJECTID && root != dest)
> +               return -EXDEV;
> +
> +       /* close the racy window with snapshot create/destroy ioctl */
> +       if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
> +               down_read(&root->fs_info->subvol_sem);
> +       if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
> +               down_read(&dest->fs_info->subvol_sem);
> +
> +       /*
> +        * We want to reserve the absolute worst case amount of items.  So if
> +        * both inodes are subvols and we need to unlink them then that would
> +        * require 4 item modifications, but if they are both normal inodes it
> +        * would require 5 item modifications, so we'll assume their normal
> +        * inodes.  So 5 * 2 is 10, plus 2 for the new links, so 12 total items
> +        * should cover the worst case number of items we'll modify.
> +        */
> +       trans = btrfs_start_transaction(root, 12);
> +       if (IS_ERR(trans)) {
> +                ret = PTR_ERR(trans);
> +                goto out_notrans;
> +        }
> +
> +       /*
> +        * We need to find a free sequence number both in the source and
> +        * in the destination directory for the exchange.
> +        */
> +       ret = btrfs_set_inode_index(new_dir, &old_idx);
> +       if (ret)
> +               goto out_fail;
> +       ret = btrfs_set_inode_index(old_dir, &new_idx);
> +       if (ret)
> +               goto out_fail;
> +
> +       BTRFS_I(old_inode)->dir_index = 0ULL;
> +       BTRFS_I(new_inode)->dir_index = 0ULL;
> +
> +       /* Reference for the source. */
> +       if (unlikely(old_ino == BTRFS_FIRST_FREE_OBJECTID)) {
> +               /* force full log commit if subvolume involved. */
> +               btrfs_set_log_full_commit(root->fs_info, trans);
> +       } else {
> +               ret = btrfs_insert_inode_ref(trans, dest,
> +                                            new_dentry->d_name.name,
> +                                            new_dentry->d_name.len,
> +                                            old_ino,
> +                                            btrfs_ino(new_dir), old_idx);
> +               if (ret)
> +                       goto out_fail;
> +               btrfs_pin_log_trans(root);
> +       }
> +
> +       /* And now for the dest. */
> +       if (unlikely(new_ino == BTRFS_FIRST_FREE_OBJECTID)) {
> +               /* force full log commit if subvolume involved. */
> +               btrfs_set_log_full_commit(dest->fs_info, trans);
> +       } else {
> +               ret = btrfs_insert_inode_ref(trans, root,
> +                                            old_dentry->d_name.name,
> +                                            old_dentry->d_name.len,
> +                                            new_ino,
> +                                            btrfs_ino(old_dir), new_idx);
> +               if (ret)
> +                       goto out_fail;
> +               btrfs_pin_log_trans(dest);
> +       }
> +
> +       /*
> +        * Update i-node version and ctime/mtime.
> +        */
> +       inode_inc_iversion(old_dir);
> +       inode_inc_iversion(new_dir);
> +       inode_inc_iversion(old_inode);
> +       inode_inc_iversion(new_inode);
> +       old_dir->i_ctime = old_dir->i_mtime = ctime;
> +       new_dir->i_ctime = new_dir->i_mtime = ctime;
> +       old_inode->i_ctime = ctime;
> +       new_inode->i_ctime = ctime;
> +
> +       if (old_dentry->d_parent != new_dentry->d_parent) {
> +               btrfs_record_unlink_dir(trans, old_dir, old_inode, 1);
> +               btrfs_record_unlink_dir(trans, new_dir, new_inode, 1);
> +       }
> +
> +       /* src is a subvolume */
> +       if (unlikely(old_ino == BTRFS_FIRST_FREE_OBJECTID)) {
> +               root_objectid = BTRFS_I(old_inode)->root->root_key.objectid;
> +               ret = btrfs_unlink_subvol(trans, root, old_dir,
> +                                         root_objectid,
> +                                         old_dentry->d_name.name,
> +                                         old_dentry->d_name.len);
> +       } else { /* src is a inode */
> +               ret = __btrfs_unlink_inode(trans, root, old_dir,
> +                                          old_dentry->d_inode,
> +                                          old_dentry->d_name.name,
> +                                          old_dentry->d_name.len);
> +               if (!ret)
> +                       ret = btrfs_update_inode(trans, root, old_inode);
> +       }
> +       if (ret) {
> +               btrfs_abort_transaction(trans, root, ret);
> +               goto out_fail;
> +       }
> +
> +       /* dest is a subvolume */
> +       if (unlikely(new_ino == BTRFS_FIRST_FREE_OBJECTID)) {
> +               root_objectid = BTRFS_I(new_inode)->root->root_key.objectid;
> +               ret = btrfs_unlink_subvol(trans, dest, new_dir,
> +                                         root_objectid,
> +                                         new_dentry->d_name.name,
> +                                         new_dentry->d_name.len);
> +       } else { /* dest is an inode */
> +               ret = __btrfs_unlink_inode(trans, dest, new_dir,
> +                                          new_dentry->d_inode,
> +                                          new_dentry->d_name.name,
> +                                          new_dentry->d_name.len);
> +               if (!ret)
> +                       ret = btrfs_update_inode(trans, dest, new_inode);
> +       }
> +       if (ret) {
> +               btrfs_abort_transaction(trans, root, ret);
> +               goto out_fail;
> +       }
> +
> +       ret = btrfs_add_link(trans, new_dir, old_inode,
> +                            new_dentry->d_name.name,
> +                            new_dentry->d_name.len, 0, old_idx);
> +       if (ret) {
> +               btrfs_abort_transaction(trans, root, ret);
> +               goto out_fail;
> +       }
> +
> +       ret = btrfs_add_link(trans, old_dir, new_inode,
> +                            old_dentry->d_name.name,
> +                            old_dentry->d_name.len, 0, new_idx);
> +       if (ret) {
> +               btrfs_abort_transaction(trans, root, ret);
> +               goto out_fail;
> +       }
> +
> +       if (old_inode->i_nlink == 1)
> +               BTRFS_I(old_inode)->dir_index = old_idx;
> +       if (new_inode->i_nlink == 1)
> +               BTRFS_I(new_inode)->dir_index = new_idx;
> +
> +       if (old_ino != BTRFS_FIRST_FREE_OBJECTID) {
> +               struct dentry *parent = new_dentry->d_parent;
> +               btrfs_log_new_name(trans, old_inode, old_dir, parent);
> +               btrfs_end_log_trans(root);
> +       }
> +       if (new_ino != BTRFS_FIRST_FREE_OBJECTID) {
> +               struct dentry *parent = old_dentry->d_parent;
> +               btrfs_log_new_name(trans, new_inode, new_dir, parent);
> +               btrfs_end_log_trans(dest);
> +       }
> +
> +out_fail:
> +       btrfs_end_transaction(trans, root);

btrfs_end_transaction can return an error - for example it decided to
call btrfs_commit_transaction() or the transaction was aborted in the
meanwhile (I know several places in the codebase ignore its return
value, which is wrong).

> +out_notrans:
> +       /* Racy window with snapshot create/destroy ioctl */

Comment can go away, it's a bit confusing as it seems to suggest this
is racy - but above when doing the down_read() calls it is said those
are done to avoid races.

> +       if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
> +               up_read(&dest->fs_info->subvol_sem);
> +       if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
> +               up_read(&root->fs_info->subvol_sem);
> +       return 0;

return ret;

> +}
> +
>  static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>                            struct inode *new_dir, struct dentry *new_dentry)
>  {
> @@ -9074,9 +9258,13 @@ static int btrfs_rename2(struct inode *old_dir, struct dentry *old_dentry,
>                          struct inode *new_dir, struct dentry *new_dentry,
>                          unsigned int flags)
>  {
> -       if (flags & ~RENAME_NOREPLACE)
> +       if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
>                 return -EINVAL;
>
> +       if (flags & RENAME_EXCHANGE)
> +               return btrfs_cross_rename(old_dir, old_dentry, new_dir,
> +                                         new_dentry);

Nitpick, naming the function as btrfs_rename_exchange instead would
make it much more clear about what it does

> +
>         return btrfs_rename(old_dir, old_dentry, new_dir, new_dentry);
>  }
>
> --
> 2.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
