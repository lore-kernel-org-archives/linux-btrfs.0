Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B08C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 11:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAACD20659
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 11:09:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A+TC8GrE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbfANLJU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 06:09:20 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:40923 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfANLJU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 06:09:20 -0500
Received: by mail-vs1-f68.google.com with SMTP id z3so13349191vsf.7
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2019 03:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=d7vjiavBwZXBJ0njaZun8EqArIl/ePbVQdL+zQR9H3s=;
        b=A+TC8GrEwL73otjQX0vBd4hMNQgWPUFxHERhD4J424EG/ven5ZgX6IFmTT1YUtlgkO
         QD7Pgjv4CVT4xXbcekBqt/WoEvsdsJmHzmZpY8uEimcfRJs5AUvrU8Dd+Aj+zZKvexnq
         x/bGaEcIjYOqatfPXo0Sj5citEMH2dfYD6WjIWCrdtRxhN0YLY4cgRzQYGNOWUYrzulA
         Qn7N50vT/TYEAxH2KQoZ76Keret5IArTV6xMmkpMN9rHOor/4C04eBfb2KeeBVZSo8My
         JQuWsMxO/2vdAkr/xnAd5QeMN+LKTGEFlh18k5P8iwpzMl7RRpMjDU3SGtHo0ayS2KHr
         JACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=d7vjiavBwZXBJ0njaZun8EqArIl/ePbVQdL+zQR9H3s=;
        b=nLABUwtER0j8nO9X1mtK0AlthvECOl9mpRBI7R9M6JOu7aPcxgBkU7K0CyXAB8JYWj
         SL/2MHKswsvOt9TdyTrGN/z+IIVxf8v6zTk8m08sy8+qNwT4ThgSQvulH9K1aJvzMiA7
         V1Qk9h7OZd3kBA6imGZPtE5DBflHvm58dn82ATQHvXqHBjgRRLMdXuscS3bU50tJSTpG
         c5RPjTp6xsj06V+igV6UUKDYJHSu3veBqTWRYlABcKgCstAgp5Oeo2WLv6FHf5/FJ/PN
         jLloZeCXEY+yYDfIwg1Ap/UJ1m/KEqZSwUhPY3WyRMo6ms/Uj18Tug0nGwKDMDe0kuBV
         MM2g==
X-Gm-Message-State: AJcUukeF/oV/7960W2z2TNd1vPiR9/rmUBlmF2bRgRzq1tjCMAFtAf18
        ixBUmx3ltQsxJYOiwnBlKuqb1HngbGPsM5T1IZw=
X-Google-Smtp-Source: ALg8bN6RYBEB9PmkddjY01K0JbySozlkKafKe05sxkIQSwjkhgUGtMtwW1Ijn2Frqe8RFKJjl4gv3UL97OMmSzpp2nc=
X-Received: by 2002:a67:c806:: with SMTP id u6mr10082529vsk.206.1547464158546;
 Mon, 14 Jan 2019 03:09:18 -0800 (PST)
MIME-Version: 1.0
References: <20180801023721.32143-1-wqu@suse.com> <20180801023721.32143-5-wqu@suse.com>
In-Reply-To: <20180801023721.32143-5-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 14 Jan 2019 11:09:07 +0000
Message-ID: <CAL3q7H6cdn4G7ZDEQM-B9A8O5h=8QV3U2NsjTKs59FFMqPCC+g@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] btrfs: Introduce mount time chunk <-> dev extent
 mapping check
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 1, 2018 at 3:39 AM Qu Wenruo <wqu@suse.com> wrote:
>
> This patch will introduce chunk <-> dev extent mapping check, to protect
> us against invalid dev extents or chunks.
>
> Since chunk mapping is the fundamental infrastructure of btrfs, extra
> check at mount time could prevent a lot of unexpected behavior (BUG_ON).
>
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D200403
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D200407
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Btw, this makes at least one test case from btrfs-progs fail:

root 17:12:02 /home/fdmanana/git/hub/btrfs-progs/tests ((v4.19.1))>
TEST=3D021\* ./misc-tests.sh
    [TEST/misc]   021-image-multi-devices
failed: mount /dev/loop2 /home/fdmanana/git/hub/btrfs-progs/tests//mnt
test failed for case 021-image-multi-devices

dmesg/syslog has:

[432229.206699] BTRFS error (device loop0): dev extent physical offset
22020096 devid 1 has no corresponding chunk
[432229.207497] BTRFS error (device loop0): failed to find devid 1
[432229.208281] BTRFS error (device loop0): failed to verify dev
extents against chunks: -117
[432229.246286] BTRFS error (device loop0): open_ctree failed

Thanks.

> ---
>  fs/btrfs/disk-io.c |   7 ++
>  fs/btrfs/volumes.c | 183 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.h |   2 +
>  3 files changed, 192 insertions(+)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 205092dc9390..068ca7498e94 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3075,6 +3075,13 @@ int open_ctree(struct super_block *sb,
>         fs_info->generation =3D generation;
>         fs_info->last_trans_committed =3D generation;
>
> +       ret =3D btrfs_verify_dev_extents(fs_info);
> +       if (ret) {
> +               btrfs_err(fs_info,
> +                         "failed to verify dev extents against chunks: %=
d",
> +                         ret);
> +               goto fail_block_groups;
> +       }
>         ret =3D btrfs_recover_balance(fs_info);
>         if (ret) {
>                 btrfs_err(fs_info, "failed to recover balance: %d", ret);
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e6a8e4aabc66..467a589854fa 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6440,6 +6440,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_=
info, struct btrfs_key *key,
>         map->stripe_len =3D btrfs_chunk_stripe_len(leaf, chunk);
>         map->type =3D btrfs_chunk_type(leaf, chunk);
>         map->sub_stripes =3D btrfs_chunk_sub_stripes(leaf, chunk);
> +       map->verified_stripes =3D 0;
>         for (i =3D 0; i < num_stripes; i++) {
>                 map->stripes[i].physical =3D
>                         btrfs_stripe_offset_nr(leaf, chunk, i);
> @@ -7295,3 +7296,185 @@ void btrfs_reset_fs_info_ptr(struct btrfs_fs_info=
 *fs_info)
>                 fs_devices =3D fs_devices->seed;
>         }
>  }
> +
> +static u64 calc_stripe_length(u64 type, u64 chunk_len, int num_stripes)
> +{
> +       int index =3D btrfs_bg_flags_to_raid_index(type);
> +       int ncopies =3D btrfs_raid_array[index].ncopies;
> +       int data_stripes;
> +
> +       switch (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
> +       case BTRFS_BLOCK_GROUP_RAID5:
> +               data_stripes =3D num_stripes - 1;
> +               break;
> +       case BTRFS_BLOCK_GROUP_RAID6:
> +               data_stripes =3D num_stripes - 2;
> +               break;
> +       default:
> +               data_stripes =3D num_stripes / ncopies;
> +               break;
> +       }
> +       return div_u64(chunk_len, data_stripes);
> +}
> +static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
> +                                u64 chunk_offset, u64 devid,
> +                                u64 physical_offset, u64 physical_len)
> +{
> +       struct extent_map_tree *em_tree =3D &fs_info->mapping_tree.map_tr=
ee;
> +       struct extent_map *em;
> +       struct map_lookup *map;
> +       u64 stripe_len;
> +       bool found =3D false;
> +       int ret =3D 0;
> +       int i;
> +
> +       read_lock(&em_tree->lock);
> +       em =3D lookup_extent_mapping(em_tree, chunk_offset, 1);
> +       read_unlock(&em_tree->lock);
> +
> +       if (!em) {
> +               ret =3D -EUCLEAN;
> +               btrfs_err(fs_info,
> +               "dev extent (%llu, %llu) doesn't have corresponding chunk=
",
> +                         devid, physical_offset);
> +               goto out;
> +       }
> +
> +       map =3D em->map_lookup;
> +       stripe_len =3D calc_stripe_length(map->type, em->len, map->num_st=
ripes);
> +       if (physical_len !=3D stripe_len) {
> +               btrfs_err(fs_info,
> +"dev extent (%llu, %llu) length doesn't match with chunk %llu, have %llu=
 expect %llu",
> +                         devid, physical_offset, em->start, physical_len=
,
> +                         stripe_len);
> +               ret =3D -EUCLEAN;
> +               goto out;
> +       }
> +
> +       for (i =3D 0; i < map->num_stripes; i++) {
> +               if (map->stripes[i].dev->devid =3D=3D devid &&
> +                   map->stripes[i].physical =3D=3D physical_offset) {
> +                       found =3D true;
> +                       if (map->verified_stripes >=3D map->num_stripes) =
{
> +                               btrfs_err(fs_info,
> +                       "too many dev extent for chunk %llu is detected",
> +                                         em->start);
> +                               ret =3D -EUCLEAN;
> +                               goto out;
> +                       }
> +                       map->verified_stripes++;
> +                       break;
> +               }
> +       }
> +       if (!found) {
> +               ret =3D -EUCLEAN;
> +               btrfs_err(fs_info,
> +                       "dev extent (%llu, %llu) has no corresponding chu=
nk",
> +                       devid, physical_offset);
> +       }
> +out:
> +       free_extent_map(em);
> +       return ret;
> +}
> +
> +static int verify_chunk_dev_extent_mapping(struct btrfs_fs_info *fs_info=
)
> +{
> +       struct extent_map_tree *em_tree =3D &fs_info->mapping_tree.map_tr=
ee;
> +       struct extent_map *em;
> +       struct rb_node *node;
> +       int ret =3D 0;
> +
> +       read_lock(&em_tree->lock);
> +       for (node =3D rb_first(&em_tree->map); node; node =3D rb_next(nod=
e)) {
> +               em =3D rb_entry(node, struct extent_map, rb_node);
> +               if (em->map_lookup->num_stripes !=3D
> +                   em->map_lookup->verified_stripes) {
> +                       btrfs_err(fs_info,
> +                       "chunk %llu has missing dev extent, have %d expec=
t %d",
> +                                 em->start, em->map_lookup->verified_str=
ipes,
> +                                 em->map_lookup->num_stripes);
> +                       ret =3D -EUCLEAN;
> +                       goto out;
> +               }
> +       }
> +out:
> +       read_unlock(&em_tree->lock);
> +       return ret;
> +}
> +
> +/*
> + * Ensure all dev extents are mapped to correct chunk.
> + * Or later chunk allocation/free would cause unexpected behavior.
> + *
> + * NOTE: This will iterate through the whole device tree, which should b=
e
> + * at the same size level of chunk tree.
> + * This would increase mount time by a tiny fraction.
> + */
> +int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
> +{
> +       struct btrfs_path *path;
> +       struct btrfs_root *root =3D fs_info->dev_root;
> +       struct btrfs_key key;
> +       int ret =3D 0;
> +
> +       key.objectid =3D 1;
> +       key.type =3D BTRFS_DEV_EXTENT_KEY;
> +       key.offset =3D 0;
> +
> +       path =3D btrfs_alloc_path();
> +       if (!path)
> +               return -ENOMEM;
> +
> +       path->reada =3D READA_FORWARD;
> +       ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +       if (ret < 0)
> +               goto out;
> +
> +       if (path->slots[0] >=3D btrfs_header_nritems(path->nodes[0])) {
> +               ret =3D btrfs_next_item(root, path);
> +               if (ret < 0)
> +                       goto out;
> +               /* No dev extents at all? Not good */
> +               if (ret > 0) {
> +                       ret =3D -EUCLEAN;
> +                       goto out;
> +               }
> +       }
> +       while (1) {
> +               struct extent_buffer *leaf =3D path->nodes[0];
> +               struct btrfs_dev_extent *dext;
> +               int slot =3D path->slots[0];
> +               u64 chunk_offset;
> +               u64 physical_offset;
> +               u64 physical_len;
> +               u64 devid;
> +
> +               btrfs_item_key_to_cpu(leaf, &key, slot);
> +               if (key.type !=3D BTRFS_DEV_EXTENT_KEY)
> +                       break;
> +               devid =3D key.objectid;
> +               physical_offset =3D key.offset;
> +
> +               dext =3D btrfs_item_ptr(leaf, slot, struct btrfs_dev_exte=
nt);
> +               chunk_offset =3D btrfs_dev_extent_chunk_offset(leaf, dext=
);
> +               physical_len =3D btrfs_dev_extent_length(leaf, dext);
> +
> +               ret =3D verify_one_dev_extent(fs_info, chunk_offset, devi=
d,
> +                                           physical_offset, physical_len=
);
> +               if (ret < 0)
> +                       goto out;
> +               ret =3D btrfs_next_item(root, path);
> +               if (ret < 0)
> +                       goto out;
> +               if (ret > 0) {
> +                       ret =3D 0;
> +                       break;
> +               }
> +       }
> +
> +       /* Ensure all chunks have corresponding dev extents */
> +       ret =3D verify_chunk_dev_extent_mapping(fs_info);
> +out:
> +       btrfs_free_path(path);
> +       return ret;
> +}
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 6d4f38ad9f5c..4301bf2d0534 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -345,6 +345,7 @@ struct map_lookup {
>         u64 stripe_len;
>         int num_stripes;
>         int sub_stripes;
> +       int verified_stripes; /* For mount time dev extent verification *=
/
>         struct btrfs_bio_stripe stripes[];
>  };
>
> @@ -559,5 +560,6 @@ void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_i=
nfo);
>  void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
>  bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
>                                         struct btrfs_device *failing_dev)=
;
> +int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
>
>  #endif
> --
> 2.18.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
