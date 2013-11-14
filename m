Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:34912 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab3KNTvl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 14:51:41 -0500
Received: by mail-vc0-f173.google.com with SMTP id lh4so1066584vcb.18
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 11:51:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131114152559.GK18494@twin.jikos.cz>
References: <1384302173-32075-1-git-send-email-fholton@gmail.com>
	<1384302173-32075-2-git-send-email-fholton@gmail.com>
	<20131114152559.GK18494@twin.jikos.cz>
Date: Thu, 14 Nov 2013 14:51:40 -0500
Message-ID: <CAC4gV=77twRAhDaFphtE4w8ML3aTxL4U-CvEoSdx2P6BUdGNNg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Btrfs: convert printk and pr_ to btrfs_* and fix
 btrfs: prefix
From: Frank Holton <fholton@gmail.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thanks for your comments, I've got a few comments/questions that I've
written below.

On Thu, Nov 14, 2013 at 10:25 AM, David Sterba <dsterba@suse.cz> wrote:
> Hi,
>
> I've found a few types of issues that appear throughout the patch,
> commented the at the first occurance. It will be some work to fix them
> all, but the transition to btrfs_wrr/... (and fixing the typos) is
> desired and number of patches doing that should be minimal.
>
> On Tue, Nov 12, 2013 at 07:22:52PM -0500, Frank Holton wrote:
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -316,8 +316,8 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
>>
>>       path->lowest_level = level;
>>       ret = btrfs_search_old_slot(root, &ref->key_for_search, path, time_seq);
>> -     pr_debug("search slot in root %llu (level %d, ref count %d) returned "
>> -              "%d for key (%llu %u %llu)\n",
>> +     btrfs_debug(fs_info, "search slot in root %llu (level %d, ref count %d) "
>> +              "returned %d for key (%llu %u %llu)",
>
> pr_debug is special, first it's only a debugging print, not meant for
> normal use.
>
> pr_debug can be enabled/disabled dynamically trhough sysfs, but
> btrfs_debug is printk(KERN_DEBUG...) which is not equivalent to pr_debug
> in the end.
>
> I suggest to keep them untouched.

Yeah I noticed the special handling of pr_debug as soon as I loaded
the updated module.
The other patch submitted with this set handled some of that
difference. It would not take much to
handle the dynamically enabled version of pr_debug. How do you feel
about another function like btrfs_debug_printk
that calls pr_debug and allows us to use all of the debug information
that btrfs_printk would normally print out.
btrfs_debug would then be dependent on CONFIG_DYNAMIC_DEBUG and DEBUG
being defined same as pr_debug.

So it would be
CONFIG_DYNAMIC_DEBUG => #define btrfs_debug btrfs_debug_printk
CONFIG_DEBUG => #define btrfs_debug btrfs_printk
ELSE => #define btrfs_debug /*does nothing */

It seems weird having btrfs_debug if it behaves so different than pr_debug.

>
>> --- a/fs/btrfs/compression.c
>> +++ b/fs/btrfs/compression.c
>> @@ -128,10 +128,10 @@ static int check_compressed_csum(struct inode *inode,
>>               kunmap_atomic(kaddr);
>>
>>               if (csum != *cb_sum) {
>> -                     printk(KERN_INFO "btrfs csum failed ino %llu "
>> -                            "extent %llu csum %u "
>> -                            "wanted %u mirror %d\n",
>> -                            btrfs_ino(inode), disk_start, csum, *cb_sum,
>> +                     btrfs_info(BTRFS_I(inode)->root->fs_info, "csum failed "
>> +                                "ino %llu extent %llu csum %u "
>> +                                "wanted %u mirror %d",
>> +                                btrfs_ino(inode), disk_start, csum, *cb_sum,
>
> An example of the right conversion, but then I'd also want to see the
> printed string on one line, because it will be grepped for when
> resolving problems. In case the string exceeds 80 columns, it could be
> shifted to the left.

Clarification needed, keep the existing line breaks? Like this
 btrfs_info(BTRFS_I(inode)->root->fs_info,
          "btrfs csum failed ino %llu "
          "wanted %u mirror %d\n",

>
>> --- a/fs/btrfs/delayed-inode.c
>> +++ b/fs/btrfs/delayed-inode.c
>> @@ -1472,9 +1472,9 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
>>       mutex_lock(&delayed_node->mutex);
>>       ret = __btrfs_add_delayed_insertion_item(delayed_node, delayed_item);
>>       if (unlikely(ret)) {
>> -             printk(KERN_ERR "err add delayed dir index item(name: %.*s) "
>> +             btrfs_err(root->fs_info, "err add delayed dir index item(name: %.*s) "
>>                               "into the insertion tree of the delayed node"
>> -                             "(root id: %llu, inode id: %llu, errno: %d)\n",
>> +                             "(root id: %llu, inode id: %llu, errno: %d)",
>
> This is a long string, the original split could work, and it's followed
> by a BUG, so locating it in the sources is easy. Although it's an
> exception to the string-on-one-line recommendation, it follows a common
> sense.
>
>>                               name_len, name, delayed_node->root->objectid,
>>                               delayed_node->inode_id, ret);
>>               BUG();
>
>> -             pr_info("btrfs: suspending dev_replace for unmount\n");
>> +             btrfs_info(fs_info, "suspending dev_replace for unmount");
>>               break;
>>       }
>>
>> @@ -728,8 +732,8 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
>>               break;
>>       }
>>       if (!dev_replace->tgtdev || !dev_replace->tgtdev->bdev) {
>> -             pr_info("btrfs: cannot continue dev_replace, tgtdev is missing\n"
>> -                     "btrfs: you may cancel the operation after 'mount -o degraded'\n");
>> +             btrfs_info(fs_info, "cannot continue dev_replace, tgtdev is missing"
>
> In the original code, there's a newline between the strings, missing in
> the new code. This looks like it should be split to two btrfs_info calls
> instead.
>
>> +                     "btrfs: you may cancel the operation after 'mount -o degraded'");
>>               btrfs_dev_replace_unlock(dev_replace);
>>               return 0;
>>       }
>
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -500,8 +500,8 @@ static int check_tree_block_fsid(struct btrfs_root *root,
>>  }
>>
>>  #define CORRUPT(reason, eb, root, slot)                              \
>> -     printk(KERN_CRIT "btrfs: corrupt leaf, %s: block=%llu," \
>> -            "root=%llu, slot=%d\n", reason,                  \
>> +     btrfs_crit(root->fs_info, "btrfs: corrupt leaf, %s: block=%llu,"        \
>
> Extra "btrfs: "
>
>> +                "root=%llu, slot=%d", reason,                        \
>>              btrfs_header_bytenr(eb), root->objectid, slot)
>>
>>  static noinline int check_leaf(struct btrfs_root *root,
>> @@ -600,21 +600,21 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>>
>>       found_start = btrfs_header_bytenr(eb);
>>       if (found_start != eb->start) {
>> -             printk_ratelimited(KERN_INFO "btrfs bad tree block start "
>> +             printk_ratelimited(KERN_INFO "btrfs: bad tree block start "
>
> The _ratelimited variants could make sense for the btrfs_* variants, but
> it's for a separate patch. The fix you do here is ok for now I think.
>
>>                              "%llu %llu\n",
>>                              found_start, eb->start);
>>               ret = -EIO;
>>               goto err;
>>       }
>> @@ -1010,8 +1010,9 @@ static void btree_invalidatepage(struct page *page, unsigned int offset,
>>       extent_invalidatepage(tree, page, offset);
>>       btree_releasepage(page, GFP_NOFS);
>>       if (PagePrivate(page)) {
>> -             printk(KERN_WARNING "btrfs warning page private not zero "
>> -                    "on page %llu\n", (unsigned long long)page_offset(page));
>> +             btrfs_warn(BTRFS_I(page->mapping->host)->root->fs_info, "btrfs warning"
>
> "btrfs warning" can be dropped here
>
>> +                        " page private not zero "
>> +                        "on page %llu", (unsigned long long)page_offset(page));
>>               ClearPagePrivate(page);
>>               set_page_private(page, 0);
>>               page_cache_release(page);
>> @@ -2391,7 +2392,7 @@ int open_ctree(struct super_block *sb,
>>       features = btrfs_super_incompat_flags(disk_super) &
>>               ~BTRFS_FEATURE_INCOMPAT_SUPP;
>>       if (features) {
>> -             printk(KERN_ERR "BTRFS: couldn't mount because of "
>> +             printk(KERN_ERR "btrfs: couldn't mount because of "
>
> I think the preferred spelling in the longterm is BTRFS, other
> filesystems use upper case as well.

Since the point of this patch set is to try and get the syslog output to
be as consistent as possible would you suggest changing it to BTRFS
throughout the rest of the code and would that have a colon after it ie BTRFS:

This is how ext4 is printed
EXT4-fs (sde1):
Btrfs currently
BTRFS: [error_level] (device sda):

>
>>                      "unsupported optional features (%Lx).\n",
>>                      features);
>>               err = -EINVAL;
>>
>> @@ -3000,7 +3001,7 @@ static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
>>               struct btrfs_device *device = (struct btrfs_device *)
>>                       bh->b_private;
>>
>> -             printk_ratelimited_in_rcu(KERN_WARNING "lost page write due to "
>> +             printk_ratelimited_in_rcu(KERN_WARNING "btrfs: lost page write due to "
>
> Hm another variant for btrfs_*, now it starts to look heavy. I'm ok with
> adding the prefix.
>
>>                                         "I/O error on %s\n",
>>                                         rcu_str_deref(device->name));
>>               /* note, we dont' set_buffer_write_io_error because we have
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -5840,8 +5840,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
>>
>>       refs = btrfs_extent_refs(leaf, ei);
>>       if (refs < refs_to_drop) {
>> -             btrfs_err(info, "trying to drop %d refs but we only have %Lu "
>> -                       "for bytenr %Lu\n", refs_to_drop, refs, bytenr);
>> +             btrfs_err(info, "trying to drop %d refs but we only have %llu "
>> +                       "for bytenr %llu", refs_to_drop, refs, bytenr);
>
> %Lu is a valid format, no need to change that

Sorry about that check_patch was complaining about it will revert.

>
>>               ret = -EINVAL;
>>               btrfs_abort_transaction(trans, extent_root, ret);
>>               goto out;
>>                     btrfs_ino(dip->inode), bio->bi_rw,
>>                     (unsigned long long)bio->bi_sector, bio->bi_size, err);
>>               dip->errors = 1;
>> @@ -8070,9 +8070,9 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>>        */
>>       trans = btrfs_start_transaction(root, 11);
>>       if (IS_ERR(trans)) {
>> -                ret = PTR_ERR(trans);
>> -                goto out_notrans;
>> -        }
>> +                             ret = PTR_ERR(trans);
>> +                             goto out_notrans;
>> +             }
>
> Wrong indentation
>
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -4219,7 +4219,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
>>               goto out;
>>       }
>>
>> -     printk(KERN_INFO "btrfs: relocating block group %llu flags %llu\n",
>> +     btrfs_debug(extent_root->fs_info, "relocating block group %llu flags %llu",
>
> Message level changed?
>
>>              rc->block_group->key.objectid, rc->block_group->flags);
>>
>>       ret = btrfs_start_delalloc_roots(fs_info, 0);
>> @@ -4241,7 +4241,7
>> --- a/fs/btrfs/root-tree.c
>> +++ b/fs/btrfs/root-tree.c
>> @@ -35,7 +35,6 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
>>       uuid_le uuid;
>>       int len;
>>       int need_reset = 0;
>> -
>
> Unrelated change
>
>>       len = btrfs_item_size_nr(eb, slot);
>>       read_extent_buffer(eb, item, btrfs_item_ptr_offset(eb, slot),
>>                       min_t(int, len, (int)sizeof(*item)));
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -141,7 +141,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
>>        * under MS_RDONLY, then it is safe here.
>>        */
>>       if (errno == -EROFS && (sb->s_flags & MS_RDONLY))
>> -             return;
>> +             return;
>
> Unrelated change
>
>>
>>       errstr = btrfs_decode_error(errno);
>>       if (fmt) {
>> @@ -1779,7 +1774,7 @@ static void btrfs_interface_exit(void)
>>
>>  static void btrfs_print_info(void)
>>  {
>> -     printk(KERN_INFO "Btrfs loaded"
>> +     printk(KERN_INFO "btrfs: loaded"
>
> This is a message that the module has been loaded, different from the
> other messages, I'd keep this one untouched.

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
