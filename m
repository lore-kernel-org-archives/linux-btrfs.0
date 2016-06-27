Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbcF0CVf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 22:21:35 -0400
Subject: Re: [PATCH 03/31] btrfs: btrfs_test_opt and friends should take a
 btrfs_fs_info
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
 <1466806524-27508-4-git-send-email-jeffm@suse.com>
 <159d78d4-f83e-faa8-e114-01153d22479f@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <57708DA2.3080303@suse.com>
Date: Sun, 26 Jun 2016 22:21:22 -0400
MIME-Version: 1.0
In-Reply-To: <159d78d4-f83e-faa8-e114-01153d22479f@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="X48R6GEmGVMIXcWOaMqHKOVTLQ1hfxKbm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X48R6GEmGVMIXcWOaMqHKOVTLQ1hfxKbm
Content-Type: multipart/mixed; boundary="v5tFFfkv4WGMO0rR7gTwRMH4rhfakpMni"
From: Jeff Mahoney <jeffm@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <57708DA2.3080303@suse.com>
Subject: Re: [PATCH 03/31] btrfs: btrfs_test_opt and friends should take a
 btrfs_fs_info
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
 <1466806524-27508-4-git-send-email-jeffm@suse.com>
 <159d78d4-f83e-faa8-e114-01153d22479f@cn.fujitsu.com>
In-Reply-To: <159d78d4-f83e-faa8-e114-01153d22479f@cn.fujitsu.com>

--v5tFFfkv4WGMO0rR7gTwRMH4rhfakpMni
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/26/16 10:14 PM, Qu Wenruo wrote:
>=20
>=20
> At 06/25/2016 06:14 AM, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> btrfs_test_opt and friends only use the root pointer to access
>> the fs_info.  Let's pass the fs_info directly in preparation to
>> eliminate similar patterns all over btrfs.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> ---
>>  fs/btrfs/ctree.h            |  22 ++++----
>>  fs/btrfs/delayed-inode.c    |   2 +-
>>  fs/btrfs/dev-replace.c      |   4 +-
>>  fs/btrfs/disk-io.c          |  22 ++++----
>>  fs/btrfs/extent-tree.c      |  32 +++++------
>>  fs/btrfs/file.c             |   2 +-
>>  fs/btrfs/free-space-cache.c |   6 +-
>>  fs/btrfs/inode-map.c        |  12 ++--
>>  fs/btrfs/inode.c            |  12 ++--
>>  fs/btrfs/ioctl.c            |   2 +-
>>  fs/btrfs/super.c            | 132
>> +++++++++++++++++++++++---------------------
>>  fs/btrfs/transaction.c      |   6 +-
>>  fs/btrfs/tree-log.c         |   4 +-
>>  fs/btrfs/volumes.c          |  11 ++--
>>  14 files changed, 137 insertions(+), 132 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 101c3cf..100d2ea 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1297,21 +1297,21 @@ struct btrfs_root {
>>  #define btrfs_clear_opt(o, opt)        ((o) &=3D ~BTRFS_MOUNT_##opt)
>>  #define btrfs_set_opt(o, opt)        ((o) |=3D BTRFS_MOUNT_##opt)
>>  #define btrfs_raw_test_opt(o, opt)    ((o) & BTRFS_MOUNT_##opt)
>> -#define btrfs_test_opt(root, opt)    ((root)->fs_info->mount_opt & \
>> +#define btrfs_test_opt(fs_info, opt)    ((fs_info)->mount_opt & \
>>                       BTRFS_MOUNT_##opt)
>>
>> -#define btrfs_set_and_info(root, opt, fmt, args...)            \
>> +#define btrfs_set_and_info(fs_info, opt, fmt, args...)            \
>>  {                                    \
>> -    if (!btrfs_test_opt(root, opt))                    \
>> -        btrfs_info(root->fs_info, fmt, ##args);            \
>> -    btrfs_set_opt(root->fs_info->mount_opt, opt);            \
>> +    if (!btrfs_test_opt(fs_info, opt))                \
>> +        btrfs_info(fs_info, fmt, ##args);            \
>> +    btrfs_set_opt(fs_info->mount_opt, opt);                \
>>  }
>>
>> -#define btrfs_clear_and_info(root, opt, fmt, args...)            \
>> +#define btrfs_clear_and_info(fs_info, opt, fmt, args...)        \
>>  {                                    \
>> -    if (btrfs_test_opt(root, opt))                    \
>> -        btrfs_info(root->fs_info, fmt, ##args);            \
>> -    btrfs_clear_opt(root->fs_info->mount_opt, opt);            \
>> +    if (btrfs_test_opt(fs_info, opt))                \
>> +        btrfs_info(fs_info, fmt, ##args);            \
>> +    btrfs_clear_opt(fs_info->mount_opt, opt);            \
>>  }
>>
>>  #ifdef CONFIG_BTRFS_DEBUG
>> @@ -1319,9 +1319,9 @@ static inline int
>>  btrfs_should_fragment_free_space(struct btrfs_root *root,
>>                   struct btrfs_block_group_cache *block_group)
>>  {
>> -    return (btrfs_test_opt(root, FRAGMENT_METADATA) &&
>> +    return (btrfs_test_opt(root->fs_info, FRAGMENT_METADATA) &&
>>          block_group->flags & BTRFS_BLOCK_GROUP_METADATA) ||
>> -           (btrfs_test_opt(root, FRAGMENT_DATA) &&
>> +           (btrfs_test_opt(root->fs_info, FRAGMENT_DATA) &&
>>          block_group->flags &  BTRFS_BLOCK_GROUP_DATA);
>>  }
>>  #endif
>> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
>> index 61561c2..ed67717 100644
>> --- a/fs/btrfs/delayed-inode.c
>> +++ b/fs/btrfs/delayed-inode.c
>> @@ -653,7 +653,7 @@ static int btrfs_delayed_inode_reserve_metadata(
>>          if (!ret)
>>              goto out;
>>
>> -        if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
>> +        if (btrfs_test_opt(root->fs_info, ENOSPC_DEBUG)) {
>>              btrfs_debug(root->fs_info,
>>                      "block rsv migrate returned %d", ret);
>>              WARN_ON(1);
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index 63ef9cd..e9bbff3 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -142,7 +142,7 @@ no_valid_dev_replace_entry_found:
>>           * missing
>>           */
>>          if (!dev_replace->srcdev &&
>> -            !btrfs_test_opt(dev_root, DEGRADED)) {
>> +            !btrfs_test_opt(dev_root->fs_info, DEGRADED)) {
> Just fs_info, as following btrfs_warn() is using fs_info.
>=20
>>              ret =3D -EIO;
>>              btrfs_warn(fs_info,
>>                 "cannot mount because device replace operation is
>> ongoing and");
>> @@ -151,7 +151,7 @@ no_valid_dev_replace_entry_found:
>>                 src_devid);
>>          }
>>          if (!dev_replace->tgtdev &&
>> -            !btrfs_test_opt(dev_root, DEGRADED)) {
>> +            !btrfs_test_opt(dev_root->fs_info, DEGRADED)) {
>=20
> Same here.
>=20
>>              ret =3D -EIO;
>>              btrfs_warn(fs_info,
>>                 "cannot mount because device replace operation is
>> ongoing and");
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 685c81a..8f27127 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3025,8 +3025,8 @@ retry_root_backup:
>>      if (IS_ERR(fs_info->transaction_kthread))
>>          goto fail_cleaner;
>>
>> -    if (!btrfs_test_opt(tree_root, SSD) &&
>> -        !btrfs_test_opt(tree_root, NOSSD) &&
>> +    if (!btrfs_test_opt(tree_root->fs_info, SSD) &&
>> +        !btrfs_test_opt(tree_root->fs_info, NOSSD) &&
>=20
> Same fs_info here.
>=20
>>          !fs_info->fs_devices->rotating) {
>>          btrfs_info(fs_info, "detected SSD devices, enabling SSD mode"=
);
>>          btrfs_set_opt(fs_info->mount_opt, SSD);
>> @@ -3039,9 +3039,9 @@ retry_root_backup:
>>      btrfs_apply_pending_changes(fs_info);
>>
>>  #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>> -    if (btrfs_test_opt(tree_root, CHECK_INTEGRITY)) {
>> +    if (btrfs_test_opt(tree_root->fs_info, CHECK_INTEGRITY)) {
>>          ret =3D btrfsic_mount(tree_root, fs_devices,
>> -                    btrfs_test_opt(tree_root,
>> +                    btrfs_test_opt(tree_root->fs_info,
>=20
> Same here.
>=20
>>                      CHECK_INTEGRITY_INCLUDING_EXTENT_DATA) ?
>>                      1 : 0,
>>                      fs_info->check_integrity_print_mask);
>> @@ -3057,7 +3057,7 @@ retry_root_backup:
>>
>>      /* do not make disk changes in broken FS or nologreplay is given =
*/
>>      if (btrfs_super_log_root(disk_super) !=3D 0 &&
>> -        !btrfs_test_opt(tree_root, NOLOGREPLAY)) {
>> +        !btrfs_test_opt(tree_root->fs_info, NOLOGREPLAY)) {
> Same here.
>>          ret =3D btrfs_replay_log(fs_info, fs_devices);
>>          if (ret) {
>>              err =3D ret;
>> @@ -3098,7 +3098,7 @@ retry_root_backup:
>>      if (sb->s_flags & MS_RDONLY)
>>          return 0;
>>
>> -    if (btrfs_test_opt(tree_root, FREE_SPACE_TREE) &&
>> +    if (btrfs_test_opt(tree_root->fs_info, FREE_SPACE_TREE) &&
> Same here.
>>          !btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
>>          btrfs_info(fs_info, "creating free space tree");
>>          ret =3D btrfs_create_free_space_tree(fs_info);
>> @@ -3135,7 +3135,7 @@ retry_root_backup:
>>
>>      btrfs_qgroup_rescan_resume(fs_info);
>>
>> -    if (btrfs_test_opt(tree_root, CLEAR_CACHE) &&
>> +    if (btrfs_test_opt(tree_root->fs_info, CLEAR_CACHE) &&
>=20
> Same here.
>=20
>>          btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
>>          btrfs_info(fs_info, "clearing free space tree");
>>          ret =3D btrfs_clear_free_space_tree(fs_info);
>> @@ -3156,7 +3156,7 @@ retry_root_backup:
>>              close_ctree(tree_root);
>>              return ret;
>>          }
>> -    } else if (btrfs_test_opt(tree_root, RESCAN_UUID_TREE) ||
>> +    } else if (btrfs_test_opt(tree_root->fs_info, RESCAN_UUID_TREE) |=
|
> Same here
>>             fs_info->generation !=3D
>>                  btrfs_super_uuid_tree_generation(disk_super)) {
>>          btrfs_info(fs_info, "checking UUID tree");
>> @@ -3233,7 +3233,7 @@ fail:
>>      return err;
>>
>>  recovery_tree_root:
>> -    if (!btrfs_test_opt(tree_root, USEBACKUPROOT))
>> +    if (!btrfs_test_opt(tree_root->fs_info, USEBACKUPROOT))
> Same here, any fs_info user inside open_ctree() can directly use fs_inf=
o.
>>          goto fail_tree_roots;
>>
>>      free_root_pointers(fs_info, 0);
>> @@ -3648,7 +3648,7 @@ static int write_all_supers(struct btrfs_root
>> *root, int max_mirrors)
>>      int total_errors =3D 0;
>>      u64 flags;
>>
>> -    do_barriers =3D !btrfs_test_opt(root, NOBARRIER);
>> +    do_barriers =3D !btrfs_test_opt(root->fs_info, NOBARRIER);
>>      backup_super_roots(root->fs_info);
>>
>>      sb =3D root->fs_info->super_for_commit;
>> @@ -3932,7 +3932,7 @@ void close_ctree(struct btrfs_root *root)
>>      iput(fs_info->btree_inode);
>>
>>  #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>> -    if (btrfs_test_opt(root, CHECK_INTEGRITY))
>> +    if (btrfs_test_opt(root->fs_info, CHECK_INTEGRITY))
> Same here.
>=20
> Get fs_info at the beginning of close_ctree().
>=20
>>          btrfsic_unmount(root, fs_info->fs_devices);
>>  #endif
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 39308a8..efb5459 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -3427,7 +3427,7 @@ again:
>>
>>      spin_lock(&block_group->lock);
>>      if (block_group->cached !=3D BTRFS_CACHE_FINISHED ||
>> -        !btrfs_test_opt(root, SPACE_CACHE)) {
>> +        !btrfs_test_opt(root->fs_info, SPACE_CACHE)) {
>=20
>>          /*
>>           * don't bother trying to write stuff out _if_
>>           * a) we're not cached,
>> @@ -3504,7 +3504,7 @@ int btrfs_setup_space_cache(struct
>> btrfs_trans_handle *trans,
>>      struct btrfs_path *path;
>>
>>      if (list_empty(&cur_trans->dirty_bgs) ||
>> -        !btrfs_test_opt(root, SPACE_CACHE))
>> +        !btrfs_test_opt(root->fs_info, SPACE_CACHE))
>>          return 0;
>>
>>      path =3D btrfs_alloc_path();
>> @@ -4417,7 +4417,7 @@ void check_system_chunk(struct
>> btrfs_trans_handle *trans,
>>      thresh =3D btrfs_calc_trunc_metadata_size(root, num_devs) +
>>          btrfs_calc_trans_metadata_size(root, 1);
>>
>> -    if (left < thresh && btrfs_test_opt(root, ENOSPC_DEBUG)) {
>> +    if (left < thresh && btrfs_test_opt(root->fs_info, ENOSPC_DEBUG))=
 {
>>          btrfs_info(root->fs_info, "left=3D%llu, need=3D%llu, flags=3D=
%llu",
>>              left, thresh, type);
>>          dump_space_info(info, 0, 0);
>> @@ -6009,7 +6009,7 @@ static int update_block_group(struct
>> btrfs_trans_handle *trans,
>>          spin_lock(&cache->space_info->lock);
>>          spin_lock(&cache->lock);
>>
>> -        if (btrfs_test_opt(root, SPACE_CACHE) &&
>> +        if (btrfs_test_opt(root->fs_info, SPACE_CACHE) &&
>=20
> Same here.
> Fs_info is extracted at the beginning of update_block_group().
>=20
>>              cache->disk_cache_state < BTRFS_DC_CLEAR)
>>              cache->disk_cache_state =3D BTRFS_DC_CLEAR;
>>
>> @@ -6388,7 +6388,7 @@ fetch_cluster_info(struct btrfs_root *root,
>> struct btrfs_space_info *space_info,
>>             u64 *empty_cluster)
>>  {
>>      struct btrfs_free_cluster *ret =3D NULL;
>> -    bool ssd =3D btrfs_test_opt(root, SSD);
>> +    bool ssd =3D btrfs_test_opt(root->fs_info, SSD);
>>
>>      *empty_cluster =3D 0;
>>      if (btrfs_mixed_space_info(space_info))
>> @@ -6518,7 +6518,7 @@ int btrfs_finish_extent_commit(struct
>> btrfs_trans_handle *trans,
>>              break;
>>          }
>>
>> -        if (btrfs_test_opt(root, DISCARD))
>> +        if (btrfs_test_opt(root->fs_info, DISCARD))
>=20
> Same here.
>=20
>>              ret =3D btrfs_discard_extent(root, start,
>>                             end + 1 - start, NULL);
>>
>> @@ -7737,7 +7737,7 @@ again:
>>              if (num_bytes =3D=3D min_alloc_size)
>>                  final_tried =3D true;
>>              goto again;
>> -        } else if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
>> +        } else if (btrfs_test_opt(root->fs_info, ENOSPC_DEBUG)) {
>>              struct btrfs_space_info *sinfo;
>>
>>              sinfo =3D __find_space_info(root->fs_info, flags);
>> @@ -7768,7 +7768,7 @@ static int __btrfs_free_reserved_extent(struct
>> btrfs_root *root,
>>      if (pin)
>>          pin_down_extent(root, cache, start, len, 1);
>>      else {
>> -        if (btrfs_test_opt(root, DISCARD))
>> +        if (btrfs_test_opt(root->fs_info, DISCARD))
>>              ret =3D btrfs_discard_extent(root, start, len, NULL);
>>          btrfs_add_free_space(cache, start, len);
>>          btrfs_update_reserved_bytes(cache, len, RESERVE_FREE, delallo=
c);
>> @@ -8078,7 +8078,7 @@ again:
>>          goto again;
>>      }
>>
>> -    if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
>> +    if (btrfs_test_opt(root->fs_info, ENOSPC_DEBUG)) {
>>          static DEFINE_RATELIMIT_STATE(_rs,
>>                  DEFAULT_RATELIMIT_INTERVAL * 10,
>>                  /*DEFAULT_RATELIMIT_BURST*/ 1);
>> @@ -9510,7 +9510,7 @@ int btrfs_can_relocate(struct btrfs_root *root,
>> u64 bytenr)
>>      int full =3D 0;
>>      int ret =3D 0;
>>
>> -    debug =3D btrfs_test_opt(root, ENOSPC_DEBUG);
>> +    debug =3D btrfs_test_opt(root->fs_info, ENOSPC_DEBUG);
>>
>>      block_group =3D btrfs_lookup_block_group(root->fs_info, bytenr);
>>
>> @@ -9782,7 +9782,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info=

>> *info)
>>          space_info =3D list_entry(info->space_info.next,
>>                      struct btrfs_space_info,
>>                      list);
>> -        if (btrfs_test_opt(info->tree_root, ENOSPC_DEBUG)) {
>> +        if (btrfs_test_opt(info, ENOSPC_DEBUG)) {
>>              if (WARN_ON(space_info->bytes_pinned > 0 ||
>>                  space_info->bytes_reserved > 0 ||
>>                  space_info->bytes_may_use > 0)) {
>> @@ -9906,10 +9906,10 @@ int btrfs_read_block_groups(struct btrfs_root
>> *root)
>>      path->reada =3D READA_FORWARD;
>>
>>      cache_gen =3D btrfs_super_cache_generation(root->fs_info->super_c=
opy);
>> -    if (btrfs_test_opt(root, SPACE_CACHE) &&
>> +    if (btrfs_test_opt(root->fs_info, SPACE_CACHE) &&
> Same here.
> btrfs_read_block_groups() has fs_info extracted as info.
>=20
>>          btrfs_super_generation(root->fs_info->super_copy) !=3D cache_=
gen)
>>          need_clear =3D 1;
>> -    if (btrfs_test_opt(root, CLEAR_CACHE))
>> +    if (btrfs_test_opt(root->fs_info, CLEAR_CACHE))
> Same here
>>          need_clear =3D 1;
>>
>>      while (1) {
>> @@ -9940,7 +9940,7 @@ int btrfs_read_block_groups(struct btrfs_root
>> *root)
>>               * b) Setting 'dirty flag' makes sure that we flush
>>               *    the new space cache info onto disk.
>>               */
>> -            if (btrfs_test_opt(root, SPACE_CACHE))
>> +            if (btrfs_test_opt(root->fs_info, SPACE_CACHE))
> Same here
>>                  cache->disk_cache_state =3D BTRFS_DC_CLEAR;
>>          }
>>
>> @@ -10406,7 +10406,7 @@ int btrfs_remove_block_group(struct
>> btrfs_trans_handle *trans,
>>      spin_lock(&block_group->space_info->lock);
>>      list_del_init(&block_group->ro_list);
>>
>> -    if (btrfs_test_opt(root, ENOSPC_DEBUG)) {
>> +    if (btrfs_test_opt(root->fs_info, ENOSPC_DEBUG)) {
>>          WARN_ON(block_group->space_info->total_bytes
>>              < block_group->key.offset);
>>          WARN_ON(block_group->space_info->bytes_readonly
>> @@ -10674,7 +10674,7 @@ void btrfs_delete_unused_bgs(struct
>> btrfs_fs_info *fs_info)
>>          spin_unlock(&space_info->lock);
>>
>>          /* DISCARD can flip during remount */
>> -        trimming =3D btrfs_test_opt(root, DISCARD);
>> +        trimming =3D btrfs_test_opt(root->fs_info, DISCARD);
>>
>>          /* Implicit trim during transaction commit. */
>>          if (trimming)
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index e0c9bd3..ffd9001 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -132,7 +132,7 @@ static int __btrfs_add_inode_defrag(struct inode
>> *inode,
>>
>>  static inline int __need_auto_defrag(struct btrfs_root *root)
>>  {
>> -    if (!btrfs_test_opt(root, AUTO_DEFRAG))
>> +    if (!btrfs_test_opt(root->fs_info, AUTO_DEFRAG))
>>          return 0;
>>
>>      if (btrfs_fs_closing(root->fs_info))
>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c=

>> index 69d270f..cee2049 100644
>> --- a/fs/btrfs/free-space-cache.c
>> +++ b/fs/btrfs/free-space-cache.c
>> @@ -3026,7 +3026,7 @@ int btrfs_find_space_cluster(struct btrfs_root
>> *root,
>>       * For metadata, allow allocates with smaller extents.  For
>>       * data, keep it dense.
>>       */
>> -    if (btrfs_test_opt(root, SSD_SPREAD)) {
>> +    if (btrfs_test_opt(root->fs_info, SSD_SPREAD)) {
>>          cont1_bytes =3D min_bytes =3D bytes + empty_size;
>>      } else if (block_group->flags & BTRFS_BLOCK_GROUP_METADATA) {
>>          cont1_bytes =3D bytes;
>> @@ -3470,7 +3470,7 @@ int load_free_ino_cache(struct btrfs_fs_info
>> *fs_info, struct btrfs_root *root)
>>      int ret =3D 0;
>>      u64 root_gen =3D btrfs_root_generation(&root->root_item);
>>
>> -    if (!btrfs_test_opt(root, INODE_MAP_CACHE))
>> +    if (!btrfs_test_opt(root->fs_info, INODE_MAP_CACHE))
>>          return 0;
>>
>>      /*
>> @@ -3514,7 +3514,7 @@ int btrfs_write_out_ino_cache(struct btrfs_root
>> *root,
>>      struct btrfs_io_ctl io_ctl;
>>      bool release_metadata =3D true;
>>
>> -    if (!btrfs_test_opt(root, INODE_MAP_CACHE))
>> +    if (!btrfs_test_opt(root->fs_info, INODE_MAP_CACHE))
>>          return 0;
>>
>>      memset(&io_ctl, 0, sizeof(io_ctl));
>> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
>> index 70107f7..e3ad8c1 100644
>> --- a/fs/btrfs/inode-map.c
>> +++ b/fs/btrfs/inode-map.c
>> @@ -38,7 +38,7 @@ static int caching_kthread(void *data)
>>      int slot;
>>      int ret;
>>
>> -    if (!btrfs_test_opt(root, INODE_MAP_CACHE))
>> +    if (!btrfs_test_opt(root->fs_info, INODE_MAP_CACHE))
> Caching_kthread() has fs_info extracted.
> So same here.
>=20
> Although such modification won't do anything real to the generated
> binary, but never a bad idea to make code a little clearer.

Thanks, but this is intentional to keep the patches obvious.  Patch 27
adds and/or uses a local fs_info in every function that uses
root->fs_info more than once.  Unfortunately, the list seems to have
dropped it.

https://git.kernel.org/cgit/linux/kernel/git/jeffm/linux-btrfs.git/commit=
/?h=3Dbtrfs-testing/root-fsinfo-cleanup-squashed&id=3Db7bccd6c7a2ac810eca=
8109adcdb3647a776e7de

It also dropped the patch that converts everything taking a root but not
using it for anything other than an fs_info to fs_info.

https://git.kernel.org/cgit/linux/kernel/git/jeffm/linux-btrfs.git/commit=
/?h=3Dbtrfs-testing/root-fsinfo-cleanup-squashed&id=3D9cd5ae906bbb2296209=
1aaaaa7ff4e85b03ee26d

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--v5tFFfkv4WGMO0rR7gTwRMH4rhfakpMni--

--X48R6GEmGVMIXcWOaMqHKOVTLQ1hfxKbm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIcBAEBCAAGBQJXcI2pAAoJEB57S2MheeWyS1kP/jy9X6U1dLpEsHBhouDkDezW
Ljua298xtY5niOJ2GZ4cxaaNFhzgHTcwk4wZDKE+dbyVCfnd8Y9ovivqHZMjlDyu
dPgLPM40/PLpqSCVmxNiM5WBK6TkytSuORwhJ26yhhYpireqHGt+ql9YHx57W9CQ
O2sSrTcxN2fs33aJiS9/CMwTemAm7g8GAJnr2Y8EMttXGwjqKoQFWeGVrrfhLfa3
s8/Lm4F58lbUwxbFyJU1QweTmGOVfLrP3MgAh6OqtrPYKqCI6Gx9+N7O0tSN0aUc
F2gqm7dq2yVk41xS3jgN3xCh46E4KIzQ/1qIa+e/CCu9SQfOPKIxDFx7BrS3yidf
2W92H116YUhktlolZKVJPbeNAAYZ21Ymytc2JxR+xXS6FGDhAo/gDj7O+wcyitii
FMQQvC7VA46waJPaCLpawKVyszJ+LfzVfjmX6EsWsgNsXbWa3CfB4E8P4HnOIcMB
OebyB+qCXFLV+zKCDIr0t8v7k9RkO7Kfaw3wzRcJvborjg+WAZPQddKdPT9GAtNQ
6I5a1Ym8iTgAFx7bcZJ641ZMFrp82FlYGyb9U4RDOXVMfCSiumyizaQUSVEcVFD6
qF0CV/pyB8jkGi54ZzHBpG8h2mIpa1NA8LCchK4GuIULSKWeMGbMn2tQC0He14cn
g5UhX3++EWpXZ16ol6PQ
=o/U/
-----END PGP SIGNATURE-----

--X48R6GEmGVMIXcWOaMqHKOVTLQ1hfxKbm--
