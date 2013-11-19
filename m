Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:62632 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3KSQGQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 11:06:16 -0500
Received: by mail-bk0-f54.google.com with SMTP id v16so1310088bkz.13
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Nov 2013 08:06:15 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <5283CC06.4050703@libero.it>
References: <1384263757-25627-1-git-send-email-fdmanana@gmail.com>
	<1384305698-22710-1-git-send-email-fdmanana@gmail.com>
	<5283CC06.4050703@libero.it>
Date: Tue, 19 Nov 2013 16:06:14 +0000
Message-ID: <CAL3q7H6x5_Bh=5yuH0msg3tdomBKQ0RmWmjHcPdSS0yRJChr5Q@mail.gmail.com>
Subject: Re: [PATCH V2] Btrfs: add support for inode properties
From: Filipe David Manana <fdmanana@gmail.com>
To: kreijack@inwind.it
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 13, 2013 at 6:59 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> Hi Filipe,
>
> my comments below
> On 2013-11-13 02:21, Filipe David Borba Manana wrote:
>> This change adds infrastructure to allow for generic properties for
>> inodes. Properties are name/value pairs that can be associated with
>> inodes for different purposes. They're stored as xattrs with the
>> prefix "btrfs."
>>
>> Properties can be inherited - this means when a directory inode has
>> inheritable properties set, these are added to new inodes created
>> under that directory.
>>
>> This change also adds one specific property implementation, named
>> "compression", whose values can be "lzo" or "zlib" and it's an
>> inheritable property.
>>
>> The corresponding changes to btrfs-progs were also implemented.
>> A patch with xfstests for this feature will follow once there's
>> agreement on this change/feature.
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> ---
>>
>> V2: Simplified the interface to user space. Got rid of the ioctls and
>>     using now the regular path for setting and getting xattrs. Like
>>     this properties can be set via regular getxattr and setxattr
>>     system calls.
>>
>>  fs/btrfs/Makefile          |    2 +-
>>  fs/btrfs/btrfs_inode.h     |    1 +
>>  fs/btrfs/inode.c           |   27 +++-
>>  fs/btrfs/props.c           |  350 ++++++++++++++++++++++++++++++++++++++++++++
>>  fs/btrfs/props.h           |   36 +++++
>>  fs/btrfs/xattr.c           |   12 +-
>>  include/uapi/linux/xattr.h |    3 +
>>  7 files changed, 425 insertions(+), 6 deletions(-)
>>  create mode 100644 fs/btrfs/props.c
>>  create mode 100644 fs/btrfs/props.h
>>
>
> [...]
>
>> +static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
>> +                         struct inode *inode,
>> +                         const char *name,
>> +                         const char *value,
>> +                         size_t value_len,
>> +                         int flags)
>> +{
>> +     const struct prop_handler *handler;
>> +     int ret;
>> +
>> +     handler = find_prop_handler(name);
>> +     if (!handler)
>> +             return -EINVAL;
>> +
>> +     if (value_len == 0) {
>> +             ret = __btrfs_setxattr(trans, inode, handler->xattr_name,
>> +                                    NULL, 0, flags);
>> +             if (ret)
>> +                     return ret;
>> +
>> +             ret = handler->apply(inode, NULL, 0);
>> +             ASSERT(ret == 0);
>> +
>> +             return ret;
>> +     }
>> +
>> +     ret = handler->validate(value, value_len);
>> +     if (ret)
>> +             return ret;
>> +
>> +     ret = __btrfs_setxattr(trans, inode, handler->xattr_name,
>> +                            value, value_len, flags);
>> +     if (ret)
>> +             return ret;
>> +
>> +     ret = handler->apply(inode, value, value_len);
>> +     if (!ret)
>> +             set_bit(BTRFS_INODE_HAS_PROPS, &BTRFS_I(inode)->runtime_flags);
>
> Does the line above also apply even if value_len== 0 ?

Nop.

>
> Moreover I have a doubt about the opportunity to store the information
> like the compression both in inode and in the xattr: what happens if the
> user does an "chattr -c" ? The xattr will be not updated.

Right, there was no interaction the compression attr/flag.
The next patch version adds such interaction.

> I suggest to update/create a real xattr only if there is no space for
> the new information in the inode. In the other case the xattr should be
> a fake xattr to get/set the property stored in the inode (or whichever
> is involved).
>
> Of course also the function btrfs_listxattr() should be updated to show
> the "fake" xattr which doesn't have a real xattr stored on the disk. The
> same is true for the getxattr() function...

Adding such fake on the fly stuff seems too complex imho. Just
adding/removing the xattr compression properties on chattr +c/-c seems
simpler and more intuitive.

>
>> +
>> +     return ret;
>> +}
>> +
>
> [...]
>
>> +int btrfs_load_inode_props(struct inode *inode)
>> +{
>> +     struct btrfs_root *root = BTRFS_I(inode)->root;
>> +     struct btrfs_key key;
>> +     struct btrfs_path *path;
>> +     u64 ino = btrfs_ino(inode);
>> +     char *name_buf = NULL;
>> +     char *value_buf = NULL;
>> +     int name_buf_len = 0;
>> +     int value_buf_len = 0;
>> +     int ret;
>> +
>> +     path = btrfs_alloc_path();
>> +     if (!path)
>> +             return -ENOMEM;
>> +
>> +     key.objectid = ino;
>> +     key.type = BTRFS_XATTR_ITEM_KEY;
>> +     key.offset = 0;
>> +
>> +     ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +     if (ret < 0)
>> +             goto out;
>> +
>> +     while (1) {
>> +             struct btrfs_dir_item *di;
>> +             struct extent_buffer *leaf;
>> +             u32 total_len, cur, this_len;
>> +             int slot;
>> +
>> +             slot = path->slots[0];
>> +             leaf = path->nodes[0];
>> +
>> +             if (slot >= btrfs_header_nritems(leaf)) {
>> +                     ret = btrfs_next_leaf(root, path);
>> +                     if (ret < 0)
>> +                             goto out;
>> +                     else if (ret > 0)
>> +                             break;
>> +                     continue;
>> +             }
>> +
>> +             btrfs_item_key_to_cpu(leaf, &key, slot);
>> +             if (key.objectid != ino || key.type != BTRFS_XATTR_ITEM_KEY)
>> +                     break;
>> +
>> +             di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
>> +             cur = 0;
>> +             total_len = btrfs_item_size_nr(leaf, slot);
>> +
>> +             while (cur < total_len) {
>> +                     u32 name_len = btrfs_dir_name_len(leaf, di);
>> +                     u32 data_len = btrfs_dir_data_len(leaf, di);
>> +                     unsigned long name_ptr, data_ptr;
>> +                     const struct prop_handler *handler;
>> +
>> +                     this_len = sizeof(*di) + name_len + data_len;
>> +                     name_ptr = (unsigned long)(di + 1);
>> +                     data_ptr = name_ptr + name_len;
>> +
>> +                     if (name_len <= 6 ||
>> +                         memcmp_extent_buffer(leaf, "btrfs.", name_ptr, 6))
>
> You should replace '"btrfs."' with XATTR_BTRFS_PREFIX and '6' with
> XATTR_BTRFS_PREFIX_LEN.

Right, forgot about that on the 2nd patch.

>
>> +                             goto next;
>> +
>> +                     if (name_len >= name_buf_len) {
>> +                             kfree(name_buf);
>> +                             name_buf_len = name_len + 1;
>> +                             name_buf = kmalloc(name_buf_len, GFP_NOFS);
>> +                             if (!name_buf) {
>> +                                     ret = -ENOMEM;
>> +                                     goto out;
>> +                             }
>> +                     }
>> +                     read_extent_buffer(leaf, name_buf, name_ptr, name_len);
>> +                     name_buf[name_len] = '\0';
>> +
>> +                     if (data_len > value_buf_len) {
>> +                             kfree(value_buf);
>> +                             value_buf_len = data_len;
>> +                             value_buf = kmalloc(data_len, GFP_NOFS);
>> +                             if (!value_buf) {
>> +                                     ret = -ENOMEM;
>> +                                     goto out;
>> +                             }
>> +                     }
>> +                     read_extent_buffer(leaf, value_buf, data_ptr, data_len);
>> +
>> +                     handler = find_prop_handler(name_buf);
>> +                     if (!handler) {
>> +                             pr_warn("btrfs: handler for prop %s, ino %llu (root %llu), not found",
>> +                                     name_buf, ino, root->root_key.objectid);
>> +                             goto next;
>> +                     }
>> +
>> +                     ret = handler->apply(inode, value_buf, data_len);
>> +                     if (ret)
>> +                             pr_warn("btrfs: error applying prop %s to ino %llu (root %llu): %d",
>> +                                     name_buf, ino,
>> +                                     root->root_key.objectid, ret);
>> +                     else
>> +                             set_bit(BTRFS_INODE_HAS_PROPS,
>> +                                     &BTRFS_I(inode)->runtime_flags);
>> +next:
>> +                     cur += this_len;
>> +                     di = (struct btrfs_dir_item *)((char *) di + this_len);
>> +             }
>> +
>> +             path->slots[0]++;
>> +     }
>> +
>> +     ret = 0;
>> +out:
>> +     btrfs_free_path(path);
>> +     kfree(name_buf);
>> +     kfree(value_buf);
>> +
>> +     return ret;
>> +}
>
> [...]
>
>> +static int prop_compression_apply(struct inode *inode,
>> +                               const char *value,
>> +                               size_t len)
>> +{
>> +     int type;
>> +
>> +     if (len == 0) {
>> +             BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
>> +             BTRFS_I(inode)->flags &= ~BTRFS_INODE_COMPRESS;
>> +             BTRFS_I(inode)->force_compress = BTRFS_COMPRESS_NONE;
>> +
>> +             return 0;
>> +     }
>> +
>> +     if (!strncmp("lzo", value, len))
>> +             type = BTRFS_COMPRESS_LZO;
>> +     else if (!strncmp("zlib", value, len))
>> +             type = BTRFS_COMPRESS_ZLIB;
>> +     else
>> +             return -EINVAL;
>> +
>> +     BTRFS_I(inode)->flags &= ~BTRFS_INODE_NOCOMPRESS;
>> +     BTRFS_I(inode)->flags |= BTRFS_INODE_COMPRESS;
>> +     BTRFS_I(inode)->force_compress = type;
>> +
>> +     return 0;
>
> Other than setting the flag, should the inode be marked "dirty" in order
> to flush the new information on the disk ? I noticed that in the
> function btrfs_ioctl_setflags(), after updating the flags there are the
> following calls:

Right, it was intended to do it via the existing setxattr call, which
updates the on disk inode.
Even if those flags aren't set in the ondisk inode item, it would
still work as intended, since when the inode is loaded all its
properties are applied.

thanks Goffredo

>
>         btrfs_update_iflags(inode);
>         inode_inc_iversion(inode);
>         inode->i_ctime = CURRENT_TIME;
>         ret = btrfs_update_inode(trans, root, inode);
>
>         btrfs_end_transaction(trans, root);
>
>
>
>
>> +}
>
>
> [...]
>
> GB
> --
> gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
