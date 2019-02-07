Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C022BC282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 12:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8190221902
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 12:07:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sIKD6/R7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfBGMHf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 07:07:35 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:33681 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfBGMHf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 07:07:35 -0500
Received: by mail-vk1-f196.google.com with SMTP id d201so2439251vka.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2019 04:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=x6rZ+AM9Z0h+hYn0EVTKvuZhW20nPQcLk485PwiN8mo=;
        b=sIKD6/R7nUPqDdCe2nmHmKyjCduPpLtj+jODP2qp/mK2BchaR3sXAgYEz62zT36mFA
         WoqsfOOURe/6BMTdGHVlvBoWuJ/oFs1sXJkWdIf9Uu5An5FOcvLj8PV4ElhHZjfjOYaT
         i4BCUy/l2pDs6D2tFINZ9pATzo8Z+nOO110c5FJRkjJMWAfOKILVN9XwmSpuijpoaTM8
         w4On4GD9mpbwu+DgiXvKpi/ynAkqMYXYf1ribaaDtsZ6DIXC9O+PERRAzPdT5GMCbE6K
         LcAv5UJFz0Xrk7hG2RhvVqCJwbQkTIIqlncmq02ciyEPN5JX79Dfk94tu8GgWZbAINza
         PcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=x6rZ+AM9Z0h+hYn0EVTKvuZhW20nPQcLk485PwiN8mo=;
        b=lFdqUr54yD2pdOA8wIeHF4JKC4Z5SwtOZJdqP/FuhTSjcXP+nPd9TIInZ4nnsg+fuD
         wd3HsHrOAAM1ks1oKNLFAmOfAEjOlY7lfsVIGxCFV0pbnLPp/pc8YYbei6ic0AJIQvuf
         daNXA2vBIJVOhCiDy+YpL8zN7yoH5+S5hxjpE+IZMm9FE2xygZovSOdlsxmRghxVKrSd
         MNO/b1+9XJTXbRtaEEhCJCnET+J/mEu42+frBa3FSSjJETXOCBWmUg1quCHkPUjRL72n
         NAhhFa8U0Kjg1qjnBdYj8SiviZvL7OviDpEtEVF9CAaO1qTgXu09K/A95jnoC4HXM6Vx
         yldw==
X-Gm-Message-State: AHQUAubBpfVqjS3guk1CImxX2XwpaOamjlJwvGvXea7Pc8dMc2lsG4vK
        PXeWzAVufJHHudoFAGqZ1K69NxttYIT9I9bGh+0wxOxh5cQ=
X-Google-Smtp-Source: AHgI3IadyXWHtr8AWN92SpeTvdV/MOPaFfzhqeTVddZ4/ddAOtrJBF5ijulviemE+04lDt7nHGpnVP9LGItdQLIKRms=
X-Received: by 2002:a1f:4982:: with SMTP id w124mr6249041vka.4.1549541253687;
 Thu, 07 Feb 2019 04:07:33 -0800 (PST)
MIME-Version: 1.0
References: <20190206204615.5862-1-josef@toxicpanda.com> <20190206204615.5862-3-josef@toxicpanda.com>
In-Reply-To: <20190206204615.5862-3-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 7 Feb 2019 12:07:22 +0000
Message-ID: <CAL3q7H5+EDeaG7rhE_FQaCkhzwW0dBZD991Zyn1Y3Gov_OFRyg@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: save drop_progress if we drop refs at all
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 6, 2019 at 8:47 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> Previously we only updated the drop_progress key if we were in the
> DROP_REFERENCE stage of snapshot deletion.  This is because the
> UPDATE_BACKREF stage checks the flags of the blocks it's converting to
> FULL_BACKREF, so if we go over a block we processed before it doesn't
> matter, we just don't do anything.
>
> The problem is in do_walk_down() we will go ahead and drop the roots
> reference to any blocks that we know we won't need to walk into.
>
> Given subvolume A and snapshot B.  The root of B points to all of the
> nodes that belong to A, so all of those nodes have a refcnt > 1.  If B
> did not modify those blocks it'll hit this condition in do_walk_down
>
> if (!wc->update_ref ||
>     generation <=3D root->root_key.offset)
>         goto skip;
>
> and in "goto skip" we simply do a btrfs_free_extent() for that bytenr
> that we point at.
>
> Now assume we modified some data in B, and then took a snapshot of B and
> call it C.  C points to all the nodes in B, making every node the root
> of B points to have a refcnt > 1.  This assumes the root level is 2 or
> higher.
>
> We delete snapshot B, which does the above work in do_walk_down,
> free'ing our ref for nodes we share with A that we didn't modify.  Now
> we hit a node we _did_ modify, thus we own.  We need to walk down into
> this node and we set wc->stage =3D=3D UPDATE_BACKREF.  We walk down to le=
vel
> 0 which we also own because we modified data.  We can't walk any further
> down and thus now need to walk up and start the next part of the
> deletion.  Now walk_up_proc is supposed to put us back into
> DROP_REFERENCE, but there's an exception to this
>
> if (level < wc->shared_level)
>         goto out;
>
> we are at level =3D=3D 0, and our shared_level =3D=3D 1.  We skip out of =
this
> one and go up to level 1.  Since path->slots[1] < nritems we
> path->slots[1]++ and break out of walk_up_tree to stop our transaction
> and loop back around.  Now in btrfs_drop_snapshot we have this snippet
>
> if (wc->stage =3D=3D DROP_REFERENCE) {
>         level =3D wc->level;
>         btrfs_node_key(path->nodes[level],
>                        &root_item->drop_progress,
>                        path->slots[level]);
>         root_item->drop_level =3D level;
> }
>
> our stage =3D=3D UPDATE_BACKREF still, so we don't update the drop_progre=
ss
> key.  This is a problem because we would have done btrfs_free_extent()
> for the nodes leading up to our current position.  If we crash or
> unmount here and go to remount we'll start over where we were before and
> try to free our ref for blocks we've already freed, and thus abort()
> out.
>
> Fix this by keeping track of the last place we dropped a reference for
> our block in do_walk_down.  Then if wc->stage =3D=3D UPDATE_BACKREF we kn=
ow
> we'll start over from a place we meant to, and otherwise things continue
> to work as they did before.
>
> I have a complicated reproducer for this problem, without this patch
> we'll fail to fsck the fs when replaying the log writes log.  With this
> patch we can replay the whole log without any fsck or mount failures.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, great catch!

> ---
>  fs/btrfs/extent-tree.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f40d6086c947..53fd4626660c 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8765,6 +8765,8 @@ struct walk_control {
>         u64 refs[BTRFS_MAX_LEVEL];
>         u64 flags[BTRFS_MAX_LEVEL];
>         struct btrfs_key update_progress;
> +       struct btrfs_key drop_progress;
> +       int drop_level;
>         int stage;
>         int level;
>         int shared_level;
> @@ -9148,6 +9150,16 @@ static noinline int do_walk_down(struct btrfs_tran=
s_handle *trans,
>                                              ret);
>                         }
>                 }
> +
> +               /*
> +                * We need to update the next key in our walk control so =
we can
> +                * update the drop_progress key accordingly.  We don't ca=
re if
> +                * find_next_key doesn't find a key because that means we=
're at
> +                * the end and are going to clean up now.
> +                */
> +               wc->drop_level =3D level;
> +               find_next_key(path, level, &wc->drop_progress);
> +
>                 ret =3D btrfs_free_extent(trans, root, bytenr, fs_info->n=
odesize,
>                                         parent, root->root_key.objectid,
>                                         level - 1, 0);
> @@ -9499,12 +9511,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>                 }
>
>                 if (wc->stage =3D=3D DROP_REFERENCE) {
> -                       level =3D wc->level;
> -                       btrfs_node_key(path->nodes[level],
> -                                      &root_item->drop_progress,
> -                                      path->slots[level]);
> -                       root_item->drop_level =3D level;
> -               }
> +                       wc->drop_level =3D wc->level;
> +                       btrfs_node_key_to_cpu(path->nodes[wc->drop_level]=
,
> +                                             &wc->drop_progress,
> +                                             path->slots[wc->drop_level]=
);
> +               }
> +               btrfs_cpu_key_to_disk(&root_item->drop_progress,
> +                                     &wc->drop_progress);
> +               root_item->drop_level =3D wc->drop_level;
>
>                 BUG_ON(wc->level =3D=3D 0);
>                 if (btrfs_should_end_transaction(trans) ||
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
