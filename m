Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33109 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751410AbdILQIw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 12:08:52 -0400
Received: by mail-io0-f196.google.com with SMTP id j26so1411256iod.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 09:08:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1505164356-13474-8-git-send-email-jbacik@fb.com>
References: <1505164356-13474-1-git-send-email-jbacik@fb.com> <1505164356-13474-8-git-send-email-jbacik@fb.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 12 Sep 2017 19:08:11 +0300
Message-ID: <CAGqmi77R5nrt_C7R93+t_u6+t88OiU8=6Ka2L_1ptaj0gd9D=g@mail.gmail.com>
Subject: Re: [PATCH 07/10] btrfs: remove type argument from comp_tree_refs
To: josef@toxicpanda.com
Cc: kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-12 0:12 GMT+03:00  <josef@toxicpanda.com>:
> From: Josef Bacik <jbacik@fb.com>
>
> We can get this from the ref we've passed in.
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/delayed-ref.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 7cb1172..7374710 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -41,9 +41,9 @@ struct kmem_cache *btrfs_delayed_extent_op_cachep;
>   * compare two delayed tree backrefs with same bytenr and type
>   */
>  static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref2,
> -                         struct btrfs_delayed_tree_ref *ref1, int type)
> +                         struct btrfs_delayed_tree_ref *ref1)
>  {
> -       if (type == BTRFS_TREE_BLOCK_REF_KEY) {
> +       if (ref1->node.type == BTRFS_TREE_BLOCK_REF_KEY) {
>                 if (ref1->root < ref2->root)
>                         return -1;
>                 if (ref1->root > ref2->root)
> @@ -223,8 +223,7 @@ static bool merge_ref(struct btrfs_trans_handle *trans,
>                 if ((ref->type == BTRFS_TREE_BLOCK_REF_KEY ||
>                      ref->type == BTRFS_SHARED_BLOCK_REF_KEY) &&
>                     comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref),
> -                                  btrfs_delayed_node_to_tree_ref(next),
> -                                  ref->type))
> +                                  btrfs_delayed_node_to_tree_ref(next)))
>                         goto next;
>                 if ((ref->type == BTRFS_EXTENT_DATA_REF_KEY ||
>                      ref->type == BTRFS_SHARED_DATA_REF_KEY) &&
> @@ -409,8 +408,7 @@ add_delayed_ref_tail_merge(struct btrfs_trans_handle *trans,
>         if ((exist->type == BTRFS_TREE_BLOCK_REF_KEY ||
>              exist->type == BTRFS_SHARED_BLOCK_REF_KEY) &&
>             comp_tree_refs(btrfs_delayed_node_to_tree_ref(exist),
> -                          btrfs_delayed_node_to_tree_ref(ref),
> -                          ref->type))
> +                          btrfs_delayed_node_to_tree_ref(ref)))
>                 goto add_tail;
>         if ((exist->type == BTRFS_EXTENT_DATA_REF_KEY ||
>              exist->type == BTRFS_SHARED_DATA_REF_KEY) &&
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Timofey Titovets <nefelim4ag@gmail.com>

-- 
Have a nice day,
Timofey.
