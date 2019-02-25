Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A52C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 10:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D06820842
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 10:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hT0WGgMq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfBYKAg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 05:00:36 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:40728 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfBYKAg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 05:00:36 -0500
Received: by mail-vk1-f196.google.com with SMTP id 89so1960971vkq.7
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 02:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=GM9lFLtNCK+Q+b2ce875wVM5btQI3Z1U3QizlOuPOhU=;
        b=hT0WGgMqsvx30cpT3UIGDQJcV1BC70PmWj5SEc1YKQCNNUqD3l/RhjiIWVvePDWZSN
         eM7oJunWcVQBsV8h3oL3nt7JOnOwOx4y1NuooqA/9xkMJcqxx7lE+8UMGgeYyvJdXn4x
         /IYiZ3yobjd4Azz0T9vUrKRrD0plPGmumRT5KYnKy32MmAR+d8tryuxYAO0zubW4JphU
         kMs7QzoLdyOci5DErq1ya3f76z/iObNG/HbE9vy4ntUawxD/KgyWD5JkaGZzLeRCoxb9
         Q/N1kWqxPHBobCyZRZ0qUJvRxrtdbvjoJIOKNxR5J8n95yMxj8QWZNKjTevWiYoh1xz1
         QqFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=GM9lFLtNCK+Q+b2ce875wVM5btQI3Z1U3QizlOuPOhU=;
        b=JG6nm/sMSp94kPZGvhQqK7C6bSBqSxVLCWKy4UrOsBCP2IA9zhgh+89CUtdstsSuuD
         APt1ZKEqIlNidQhUwMaAjsy7taCpAGhp60WGYIHAf6mmHwMl0Ys/ts5gkTXpSOFVjBIn
         6cJew0rthqFPBzhG6BKdnrVWwTyu+u2fxuhzODnPursc3qP2/TwBftleaLFCSnt1VSYI
         kZ7lJTnPK1jMHdznevI3hfF4t/XmIEQsbhl0NoEgfE1TRz1no7b1r5Lg2Q+WnFDX0TZ6
         WqNVLrNtSioHCWdA4iiDGBubtXjVnCczytupOdHf2woqiRZtJ+coHpN7X3vdN3DzCmQe
         eO0Q==
X-Gm-Message-State: AHQUAuZ41r6Y2kEnSswVpiJRB7L1DSd5GgkHAUuH/wJYUibbOB9BsA3M
        hma7WBXs9HdlpUVmbkyZbitbYPNiD9FOpZKFrcY=
X-Google-Smtp-Source: AHgI3Ib3GnlUx921KvECqN7915H6s3kCDYcaC9boqAvJCRTblUZr1usFchv20Wb1cOcJjiV1GAVkVydtYrBSAiRv2bQ=
X-Received: by 2002:a1f:7f10:: with SMTP id o16mr8787808vki.31.1551088834946;
 Mon, 25 Feb 2019 02:00:34 -0800 (PST)
MIME-Version: 1.0
References: <20190225055043.1621-1-wqu@suse.com>
In-Reply-To: <20190225055043.1621-1-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 25 Feb 2019 10:00:23 +0000
Message-ID: <CAL3q7H5MBdbdeXmkXf-dTM0tJXxN7s-XuavK1MKn0FedWV=qnQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Use struct inode* to replace extent_io_tree::private_data
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 5:53 AM Qu Wenruo <wqu@suse.com> wrote:
>
> All users of extent_io_tree::private_data are expecting struct inode*.
> So just use struct inode* to replace extent_io_tree::private_data, and
> this should provide better type check.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good.

> ---
>  fs/btrfs/extent_io.c | 36 +++++++++++++++++-------------------
>  fs/btrfs/extent_io.h |  4 ++--
>  fs/btrfs/inode.c     |  2 +-
>  3 files changed, 20 insertions(+), 22 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index e0a96f74e81e..2fd78b10830b 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -89,7 +89,7 @@ void btrfs_leak_debug_check(void)
>  static inline void __btrfs_debug_check_extent_io_range(const char *calle=
r,
>                 struct extent_io_tree *tree, u64 start, u64 end)
>  {
> -       struct inode *inode =3D tree->private_data;
> +       struct inode *inode =3D tree->inode;
>         u64 isize;
>
>         if (!inode || !is_data_inode(inode))
> @@ -201,13 +201,13 @@ void __cold extent_io_exit(void)
>  }
>
>  void extent_io_tree_init(struct extent_io_tree *tree,
> -                        void *private_data)
> +                        struct inode *inode)
>  {
>         tree->state =3D RB_ROOT;
>         tree->ops =3D NULL;
>         tree->dirty_bytes =3D 0;
>         spin_lock_init(&tree->lock);
> -       tree->private_data =3D private_data;
> +       tree->inode =3D inode;
>  }
>
>  static struct extent_state *alloc_extent_state(gfp_t mask)
> @@ -376,9 +376,8 @@ static void merge_state(struct extent_io_tree *tree,
>                 other =3D rb_entry(other_node, struct extent_state, rb_no=
de);
>                 if (other->end =3D=3D state->start - 1 &&
>                     other->state =3D=3D state->state) {
> -                       if (tree->private_data &&
> -                           is_data_inode(tree->private_data))
> -                               btrfs_merge_delalloc_extent(tree->private=
_data,
> +                       if (tree->inode && is_data_inode(tree->inode))
> +                               btrfs_merge_delalloc_extent(tree->inode,
>                                                             state, other)=
;
>                         state->start =3D other->start;
>                         rb_erase(&other->rb_node, &tree->state);
> @@ -391,9 +390,8 @@ static void merge_state(struct extent_io_tree *tree,
>                 other =3D rb_entry(other_node, struct extent_state, rb_no=
de);
>                 if (other->start =3D=3D state->end + 1 &&
>                     other->state =3D=3D state->state) {
> -                       if (tree->private_data &&
> -                           is_data_inode(tree->private_data))
> -                               btrfs_merge_delalloc_extent(tree->private=
_data,
> +                       if (tree->inode && is_data_inode(tree->inode))
> +                               btrfs_merge_delalloc_extent(tree->inode,
>                                                             state, other)=
;
>                         state->end =3D other->end;
>                         rb_erase(&other->rb_node, &tree->state);
> @@ -464,8 +462,8 @@ static int split_state(struct extent_io_tree *tree, s=
truct extent_state *orig,
>  {
>         struct rb_node *node;
>
> -       if (tree->private_data && is_data_inode(tree->private_data))
> -               btrfs_split_delalloc_extent(tree->private_data, orig, spl=
it);
> +       if (tree->inode && is_data_inode(tree->inode))
> +               btrfs_split_delalloc_extent(tree->inode, orig, split);
>
>         prealloc->start =3D orig->start;
>         prealloc->end =3D split - 1;
> @@ -512,8 +510,8 @@ static struct extent_state *clear_state_bit(struct ex=
tent_io_tree *tree,
>                 tree->dirty_bytes -=3D range;
>         }
>
> -       if (tree->private_data && is_data_inode(tree->private_data))
> -               btrfs_clear_delalloc_extent(tree->private_data, state, bi=
ts);
> +       if (tree->inode && is_data_inode(tree->inode))
> +               btrfs_clear_delalloc_extent(tree->inode, state, bits);
>
>         ret =3D add_extent_changeset(state, bits_to_clear, changeset, 0);
>         BUG_ON(ret < 0);
> @@ -547,7 +545,7 @@ alloc_extent_state_atomic(struct extent_state *preall=
oc)
>
>  static void extent_io_tree_panic(struct extent_io_tree *tree, int err)
>  {
> -       struct inode *inode =3D tree->private_data;
> +       struct inode *inode =3D tree->inode;
>
>         btrfs_panic(btrfs_sb(inode->i_sb), err,
>         "locking error: extent tree was modified by another thread while =
locked");
> @@ -791,8 +789,8 @@ static void set_state_bits(struct extent_io_tree *tre=
e,
>         unsigned bits_to_set =3D *bits & ~EXTENT_CTLBITS;
>         int ret;
>
> -       if (tree->private_data && is_data_inode(tree->private_data))
> -               btrfs_set_delalloc_extent(tree->private_data, state, bits=
);
> +       if (tree->inode && is_data_inode(tree->inode))
> +               btrfs_set_delalloc_extent(tree->inode, state, bits);
>
>         if ((bits_to_set & EXTENT_DIRTY) && !(state->state & EXTENT_DIRTY=
)) {
>                 u64 range =3D state->end - state->start + 1;
> @@ -2378,8 +2376,8 @@ static int bio_readpage_error(struct bio *failed_bi=
o, u64 phy_offset,
>                 "Repair Read Error: submitting new read[%#x] to this_mirr=
or=3D%d, in_validation=3D%d",
>                 read_mode, failrec->this_mirror, failrec->in_validation);
>
> -       status =3D tree->ops->submit_bio_hook(tree->private_data, bio, fa=
ilrec->this_mirror,
> -                                        failrec->bio_flags, 0);
> +       status =3D tree->ops->submit_bio_hook(tree->inode, bio,
> +                               failrec->this_mirror, failrec->bio_flags,=
 0);
>         if (status) {
>                 free_io_failure(failure_tree, tree, failrec);
>                 bio_put(bio);
> @@ -2706,7 +2704,7 @@ static int __must_check submit_one_bio(struct bio *=
bio, int mirror_num,
>         bio->bi_private =3D NULL;
>
>         if (tree->ops)
> -               ret =3D tree->ops->submit_bio_hook(tree->private_data, bi=
o,
> +               ret =3D tree->ops->submit_bio_hook(tree->inode, bio,
>                                            mirror_num, bio_flags, start);
>         else
>                 btrfsic_submit_bio(bio);
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 9673be3f3d1f..b656d65bca83 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -109,7 +109,7 @@ struct extent_io_ops {
>
>  struct extent_io_tree {
>         struct rb_root state;
> -       void *private_data;
> +       struct inode *inode;
>         u64 dirty_bytes;
>         int track_uptodate;
>         spinlock_t lock;
> @@ -240,7 +240,7 @@ typedef struct extent_map *(get_extent_t)(struct btrf=
s_inode *inode,
>                                           u64 start, u64 len,
>                                           int create);
>
> -void extent_io_tree_init(struct extent_io_tree *tree, void *private_data=
);
> +void extent_io_tree_init(struct extent_io_tree *tree, struct inode *inod=
e);
>  int try_release_extent_mapping(struct page *page, gfp_t mask);
>  int try_release_extent_buffer(struct page *page);
>  int lock_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 5c349667c761..4fc82f582fa5 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -10403,7 +10403,7 @@ static int btrfs_tmpfile(struct inode *dir, struc=
t dentry *dentry, umode_t mode)
>
>  void btrfs_set_range_writeback(struct extent_io_tree *tree, u64 start, u=
64 end)
>  {
> -       struct inode *inode =3D tree->private_data;
> +       struct inode *inode =3D tree->inode;
>         unsigned long index =3D start >> PAGE_SHIFT;
>         unsigned long end_index =3D end >> PAGE_SHIFT;
>         struct page *page;
> --
> 2.20.1
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
