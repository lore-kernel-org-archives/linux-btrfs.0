Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8EFC282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 12:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34573222B2
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 12:37:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E5Yce1k6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbfBMMhq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 07:37:46 -0500
Received: from mail-vk1-f195.google.com ([209.85.221.195]:33204 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfBMMhp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 07:37:45 -0500
Received: by mail-vk1-f195.google.com with SMTP id d201so506360vka.0
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2019 04:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=BfoSVszTsv4qkgNuw6GoxrQJmvVmEkMcXkcRZWWSLVA=;
        b=E5Yce1k6MkpYhnuY9+3i/wNGzY181iUg8rcjIeh5TzIEVAyXJU74hSTvRGmKVPuDzh
         fIHmz/+VIg5Q4sS15mnOqSvd4HVFdhbw2w2YB7qkqJ4TvVaMSylRYPRM5/XNy8MMgVO2
         HKwA8kW/hJV8h4fegCAZLpB+DPLVZUpm1ziVvhx5HEgJaIdBGLXVuZ8ER2axnM8xsAUE
         6hkIykdHACDu2P/PcDA3hDM1hmjiAjj2pf2cbYQoCMA3mzRcAAu+s/KTGXMXHbOqVAbO
         ZaghgzumfXTxXw7llFy+bIYrz45VK+MEh7pUNvW9tpp5dXkdDwdV6JJ182IUzcttaSST
         k+Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=BfoSVszTsv4qkgNuw6GoxrQJmvVmEkMcXkcRZWWSLVA=;
        b=ONpTgqcQdaUIxza9ssSu/ArA0JfnDX4xOPFr1A563hcGgsi5XpSYy3FooBfxPI4Efo
         7hozW05F7EX1MZ+5yZFdiGK5PvlaEhEOsID4tN0vbF6fgScvtkLf5BvCtCm9CsdAwWNh
         pCho/HTA3tiFCOOriOl89boNihXdtETxpnnQ1axhF9dsp8x0zH4wtzCAHwE+EIqIbGMd
         whH8t5ZkZ99fitTLTL216xVKAx7wM/xBxTFvFuqMhn9dfrgW6+pCXUCgLIFan1yP5ng0
         xXxYflff6EAajeshis6stNTDMTfQwCiA0avZt5aWeOuicuxQIDJXDth2kXnW3hQjGmwO
         1RYg==
X-Gm-Message-State: AHQUAuZeoY+nPkrAhIradt/kWYgcRxQG6DOLbGZL1QEMavv/CejdLfyy
        XrdRVAXrhO8ZlbGkUO02LddxlJJWu/ehvpEYwIo=
X-Google-Smtp-Source: AHgI3Ibm53pIxhWc6X8JCQysaZISKn948kt8VwuJreXTeWa9iALGGDHtQiG75BkHUp9zVMvHhcruJlQOTQ51Wnq3lLM=
X-Received: by 2002:a1f:2542:: with SMTP id l63mr91581vkl.81.1550061463112;
 Wed, 13 Feb 2019 04:37:43 -0800 (PST)
MIME-Version: 1.0
References: <20190207165426.15866-1-josef@toxicpanda.com> <20190207165426.15866-2-josef@toxicpanda.com>
In-Reply-To: <20190207165426.15866-2-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 13 Feb 2019 12:37:32 +0000
Message-ID: <CAL3q7H4MxjY0U-uawtmg+1DhAtCgB=zXDELB4JtRXivC9r=Zzg@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: reserve space for inheriting properties
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 7, 2019 at 4:57 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> We've been seeing errors on our build servers related to failing to
> inherit inode properties.  This is because we do not pre-reserve space
> for them, instead trying to reserve space with NO_FLUSH at inheritance
> time.  NO_FLUSH can transiently fail, but we'll still complain.  It's
> just an extra credit, so simply add that to the places that call
> btrfs_new_inode and call it good enough.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Loogs good, thanks. Just one minor comment about using bitwise left
shift instead of direct multiplication by 2.

> ---
>  fs/btrfs/inode.c | 78 ++++++++++++++++++++++----------------------------=
------
>  fs/btrfs/ioctl.c | 27 ++++++++++++--------
>  2 files changed, 46 insertions(+), 59 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 6126de9b8b9c..0da4a9d6d9fe 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -59,6 +59,14 @@ struct btrfs_dio_data {
>         int overwrite;
>  };
>
> +/*
> + * 2 for inode item and ref
> + * 2 for dir items
> + * 1 for xattr if selinux is on
> + * 1 for inherited properties
> + */
> +#define BTRFS_NEW_INODE_ITEMS 6
> +
>  static const struct inode_operations btrfs_dir_inode_operations;
>  static const struct inode_operations btrfs_symlink_inode_operations;
>  static const struct inode_operations btrfs_dir_ro_inode_operations;
> @@ -6479,12 +6487,7 @@ static int btrfs_mknod(struct inode *dir, struct d=
entry *dentry,
>         u64 objectid;
>         u64 index =3D 0;
>
> -       /*
> -        * 2 for inode item and ref
> -        * 2 for dir items
> -        * 1 for xattr if selinux is on
> -        */
> -       trans =3D btrfs_start_transaction(root, 5);
> +       trans =3D btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS);
>         if (IS_ERR(trans))
>                 return PTR_ERR(trans);
>
> @@ -6543,12 +6546,7 @@ static int btrfs_create(struct inode *dir, struct =
dentry *dentry,
>         u64 objectid;
>         u64 index =3D 0;
>
> -       /*
> -        * 2 for inode item and ref
> -        * 2 for dir items
> -        * 1 for xattr if selinux is on
> -        */
> -       trans =3D btrfs_start_transaction(root, 5);
> +       trans =3D btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS);
>         if (IS_ERR(trans))
>                 return PTR_ERR(trans);
>
> @@ -6695,12 +6693,7 @@ static int btrfs_mkdir(struct inode *dir, struct d=
entry *dentry, umode_t mode)
>         u64 objectid =3D 0;
>         u64 index =3D 0;
>
> -       /*
> -        * 2 items for inode and ref
> -        * 2 items for dir items
> -        * 1 for xattr if selinux is on
> -        */
> -       trans =3D btrfs_start_transaction(root, 5);
> +       trans =3D btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS);
>         if (IS_ERR(trans))
>                 return PTR_ERR(trans);
>
> @@ -9428,14 +9421,11 @@ static int btrfs_rename_exchange(struct inode *ol=
d_dir,
>                 down_read(&fs_info->subvol_sem);
>
>         /*
> -        * We want to reserve the absolute worst case amount of items.  S=
o if
> -        * both inodes are subvols and we need to unlink them then that w=
ould
> -        * require 4 item modifications, but if they are both normal inod=
es it
> -        * would require 5 item modifications, so we'll assume their norm=
al
> -        * inodes.  So 5 * 2 is 10, plus 2 for the new links, so 12 total=
 items
> -        * should cover the worst case number of items we'll modify.
> +        * The same math from btrfs_rename applies here, except we need a=
n extra
> +        * 2 items for the new links.
>          */
> -       trans =3D btrfs_start_transaction(root, 12);
> +       trans =3D btrfs_start_transaction(root,
> +                                       (BTRFS_NEW_INODE_ITEMS << 1) + 2)=
;
>         if (IS_ERR(trans)) {
>                 ret =3D PTR_ERR(trans);
>                 goto out_notrans;
> @@ -9768,19 +9758,19 @@ static int btrfs_rename(struct inode *old_dir, st=
ruct dentry *old_dentry,
>         if (old_ino =3D=3D BTRFS_FIRST_FREE_OBJECTID)
>                 down_read(&fs_info->subvol_sem);
>         /*
> -        * We want to reserve the absolute worst case amount of items.  S=
o if
> -        * both inodes are subvols and we need to unlink them then that w=
ould
> -        * require 4 item modifications, but if they are both normal inod=
es it
> -        * would require 5 item modifications, so we'll assume they are n=
ormal
> -        * inodes.  So 5 * 2 is 10, plus 1 for the new link, so 11 total =
items
> -        * should cover the worst case number of items we'll modify.
> -        * If our rename has the whiteout flag, we need more 5 units for =
the
> -        * new inode (1 inode item, 1 inode ref, 2 dir items and 1 xattr =
item
> -        * when selinux is enabled).
> +        * We want to reserve the absolute worst case amount of items.  S=
ubvol
> +        * inodes don't have an inode item to worry about and don't have =
a
> +        * selinux attr, so we use the BTRFS_NEW_INODE_ITEMS counter for =
how
> +        * much it costs per inode to modify.  Worse case we'll have to m=
ess
> +        * with 2 inodes, so 2 x BTRFS_NEW_INODE_ITEMS, and then we need =
an
> +        * extra reservation for the new link.
> +        *
> +        * If our rename has the whiteout flag we need a full new inode w=
hich
> +        * means another set of BTRFS_NEW_INODE_ITEMS.
>          */
> -       trans_num_items =3D 11;
> +       trans_num_items =3D (BTRFS_NEW_INODE_ITEMS << 1) + 1;

Could be made more obvious by multiplying by 2 instead of bitwise left shif=
t.

>         if (flags & RENAME_WHITEOUT)
> -               trans_num_items +=3D 5;
> +               trans_num_items +=3D BTRFS_NEW_INODE_ITEMS;
>         trans =3D btrfs_start_transaction(root, trans_num_items);
>         if (IS_ERR(trans)) {
>                 ret =3D PTR_ERR(trans);
> @@ -10149,14 +10139,8 @@ static int btrfs_symlink(struct inode *dir, stru=
ct dentry *dentry,
>         if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info))
>                 return -ENAMETOOLONG;
>
> -       /*
> -        * 2 items for inode item and ref
> -        * 2 items for dir items
> -        * 1 item for updating parent inode item
> -        * 1 item for the inline extent item
> -        * 1 item for xattr if selinux is on
> -        */
> -       trans =3D btrfs_start_transaction(root, 7);
> +       /* 1 item for the inline extent item */
> +       trans =3D btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS + 1=
);
>         if (IS_ERR(trans))
>                 return PTR_ERR(trans);
>
> @@ -10427,10 +10411,8 @@ static int btrfs_tmpfile(struct inode *dir, stru=
ct dentry *dentry, umode_t mode)
>         u64 index;
>         int ret =3D 0;
>
> -       /*
> -        * 5 units required for adding orphan entry
> -        */
> -       trans =3D btrfs_start_transaction(root, 5);
> +       /* 1 unit required for adding orphan entry */
> +       trans =3D btrfs_start_transaction(root, BTRFS_NEW_INODE_ITEMS + 1=
);
>         if (IS_ERR(trans))
>                 return PTR_ERR(trans);
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index f38a659c918c..21f8ab2d8570 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -83,6 +83,17 @@ struct btrfs_ioctl_send_args_32 {
>                                struct btrfs_ioctl_send_args_32)
>  #endif
>
> +/*
> + * 1 - parent dir inode
> + * 2 - dir entries
> + * 1 - root item
> + * 2 - root ref/backref
> + * 1 - root of snapshot
> + * 1 - UUID item
> + * 1 - properties
> + */
> +#define BTRFS_NEW_ROOT_ITEMS 9
> +
>  static int btrfs_clone(struct inode *src, struct inode *inode,
>                        u64 off, u64 olen, u64 olen_aligned, u64 destoff,
>                        int no_time_update);
> @@ -596,7 +607,8 @@ static noinline int create_subvol(struct inode *dir,
>          * The same as the snapshot creation, please see the comment
>          * of create_snapshot().
>          */
> -       ret =3D btrfs_subvolume_reserve_metadata(root, &block_rsv, 8, fal=
se);
> +       ret =3D btrfs_subvolume_reserve_metadata(root, &block_rsv,
> +                                              BTRFS_NEW_ROOT_ITEMS, fals=
e);
>         if (ret)
>                 goto fail_free;
>
> @@ -804,17 +816,10 @@ static int create_snapshot(struct btrfs_root *root,=
 struct inode *dir,
>
>         btrfs_init_block_rsv(&pending_snapshot->block_rsv,
>                              BTRFS_BLOCK_RSV_TEMP);
> -       /*
> -        * 1 - parent dir inode
> -        * 2 - dir entries
> -        * 1 - root item
> -        * 2 - root ref/backref
> -        * 1 - root of snapshot
> -        * 1 - UUID item
> -        */
> +
>         ret =3D btrfs_subvolume_reserve_metadata(BTRFS_I(dir)->root,
> -                                       &pending_snapshot->block_rsv, 8,
> -                                       false);
> +                                       &pending_snapshot->block_rsv,
> +                                       BTRFS_NEW_ROOT_ITEMS, false);
>         if (ret)
>                 goto dec_and_free;
>
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
