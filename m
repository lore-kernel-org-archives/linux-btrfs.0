Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33415 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbdILQVp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 12:21:45 -0400
Received: by mail-io0-f195.google.com with SMTP id j26so1453303iod.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 09:21:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1505164356-13474-9-git-send-email-jbacik@fb.com>
References: <1505164356-13474-1-git-send-email-jbacik@fb.com> <1505164356-13474-9-git-send-email-jbacik@fb.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 12 Sep 2017 19:21:04 +0300
Message-ID: <CAGqmi77dYD90ni9H_HMiqD8Tp+y+hfgRRnoKZRGa+QH_+CdFxg@mail.gmail.com>
Subject: Re: [PATCH 08/10] btrfs: switch args for comp_*_refs
To: josef@toxicpanda.com
Cc: kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-12 0:12 GMT+03:00  <josef@toxicpanda.com>:
> From: Josef Bacik <jbacik@fb.com>
>
> Because seriously?  ref2 and then ref1?
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/delayed-ref.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 7374710..c5de6c7 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -40,8 +40,8 @@ struct kmem_cache *btrfs_delayed_extent_op_cachep;
>  /*
>   * compare two delayed tree backrefs with same bytenr and type
>   */
> -static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref2,
> -                         struct btrfs_delayed_tree_ref *ref1)
> +static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref1,
> +                         struct btrfs_delayed_tree_ref *ref2)
>  {
>         if (ref1->node.type == BTRFS_TREE_BLOCK_REF_KEY) {
>                 if (ref1->root < ref2->root)
> @@ -60,8 +60,8 @@ static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref2,
>  /*
>   * compare two delayed data backrefs with same bytenr and type
>   */
> -static int comp_data_refs(struct btrfs_delayed_data_ref *ref2,
> -                         struct btrfs_delayed_data_ref *ref1)
> +static int comp_data_refs(struct btrfs_delayed_data_ref *ref1,
> +                         struct btrfs_delayed_data_ref *ref2)
>  {
>         if (ref1->node.type == BTRFS_EXTENT_DATA_REF_KEY) {
>                 if (ref1->root < ref2->root)
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Result of that function does not used anywhere (i.e. only as bool),
may be let's rename that like:
  compr_tree_refs_eq()
and simplify to
  if (ref1->root != ref2->root)
       return 0;

(same for comp_data_refs())

This can made that more obvious and remove useless if. as that not
used in any "sorting" code

Thanks.

Reviewed-by: Timofey Titovets <nefelim4ag@gmail.com>

-- 
Have a nice day,
Timofey.
