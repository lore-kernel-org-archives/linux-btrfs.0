Return-Path: <SRS0=8r0n=QU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD19C282CE
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 12:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA1B1222B5
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Feb 2019 12:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BiDHXu3q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404089AbfBMMbX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 13 Feb 2019 07:31:23 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:33046 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404083AbfBMMbX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Feb 2019 07:31:23 -0500
Received: by mail-vk1-f193.google.com with SMTP id d201so502364vka.0;
        Wed, 13 Feb 2019 04:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=QV2tUAgyrDeYmy94x/RDFgL9dLUAuPKh4gAaDhnSKeU=;
        b=BiDHXu3q44Hl2+rPRbVP7tkbgMnnXmkd0HwA4AknfkexB/FxWYofYvaihxI4CMAo6X
         NwtBAMSKWIRMTFeR5Im+jHw0P+z2qtZUWUN6mdjjAxGfI9K3qay5fu5VsVJxBQ/dvGUb
         hrcQ5k6+iPXMCxJgaMfm4SAUahY/LcwjNsdxPcT+HUBmzdQzGJBDqP/9qFpRsq/7OLJD
         4aTRXw06d8bbmZkh8WfvNwHmy8krys5A7HfBuZO7rYoch2pVnyG3NV1DvAHJtMZm/5Ml
         vVNQtiKjzbaNbKZy+K3Rd/yNnBiEBu0ZmtL7aKEor1ZBTPbdstWqff13nI8kMQMqGWOP
         /37A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=QV2tUAgyrDeYmy94x/RDFgL9dLUAuPKh4gAaDhnSKeU=;
        b=OrUnIq1wKOlk920X+LX21dkgtUmMCtQ+++UidL6yKjduEye84pjNfLAa+9HYOHtc3I
         7vfLJj5izzpVLuKCBn1ZXnkcc+ZLfUlf993VBd1OPvYU6oXKcgfxXkNdI2iDUVJ2H1bo
         eBWlUTLTKnCEpm0uLB8iO2spKbbjLDIjgufX7HtYAUR+vOycWNfkchZdJxbMJaUoGLqL
         o0eDVyEYuHSSMnlu/TMMxYSSihj4dxuFV4bAeRGsd9MZaySuu1CNSs3LaxvTaIfqmf1J
         IPU5jod/gcWUiUju9r3GpORtSjArJ5yf26qMfMcyiQCv1i5EVxtjCwCzARAbr9BIE7qJ
         eiqw==
X-Gm-Message-State: AHQUAuZ4wYU3ESZTKQ8c+bmd+uR9QZXmXA3DHFTjOH6bPhOeeKl25Sja
        53DB65sB5AFTfTgxN67+Vk+nmo5WUtCvqN/B1jYLkg==
X-Google-Smtp-Source: AHgI3IbtgAYujksfyM0/fhTN7uln/ttWzQZhcRYevqxn/Z4NZ7mDwOx0g/O3rESoNNUD7Rmqh4sNGF4AagUvcBlz1wc=
X-Received: by 2002:a1f:d005:: with SMTP id h5mr106477vkg.4.1550061079052;
 Wed, 13 Feb 2019 04:31:19 -0800 (PST)
MIME-Version: 1.0
References: <20190213062704.25121-1-wqu@suse.com>
In-Reply-To: <20190213062704.25121-1-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 13 Feb 2019 12:31:07 +0000
Message-ID: <CAL3q7H78vZiG+miY7Eb+Jh1_CyOYTkVuWzzK6_JW-Wqv19q-Uw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: honor path->skip_locking in backref code
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org,
        David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 13, 2019 at 11:33 AM Qu Wenruo <wqu@suse.com> wrote:
>
> From: Josef Bacik <josef@toxicpanda.com>
>
> Qgroups will do the old roots lookup at delayed ref time, which could be
> while walking down the extent root while running a delayed ref.  This
> should be fine, except we specifically lock eb's in the backref walking
> code irrespective of path->skip_locking, which deadlocks the system.
> Fix up the backref code to honor path->skip_locking, nobody will be
> modifying the commit_root when we're searching so it's completely safe
> to do.
>
> This happens Since fb235dc06fac ("btrfs: qgroup: Move half of the qgroup
> accounting time out of commit trans"), kernel may lockup with quota
> enabled.
>
> There is one backref trace triggered by snapshot dropping along with
> write operation in the source subvolume.  The example can be reliably
> reproduced:
>
>   btrfs-cleaner   D    0  4062      2 0x80000000
>   Call Trace:
>    schedule+0x32/0x90
>    btrfs_tree_read_lock+0x93/0x130 [btrfs]
>    find_parent_nodes+0x29b/0x1170 [btrfs]
>    btrfs_find_all_roots_safe+0xa8/0x120 [btrfs]
>    btrfs_find_all_roots+0x57/0x70 [btrfs]
>    btrfs_qgroup_trace_extent_post+0x37/0x70 [btrfs]
>    btrfs_qgroup_trace_leaf_items+0x10b/0x140 [btrfs]
>    btrfs_qgroup_trace_subtree+0xc8/0xe0 [btrfs]
>    do_walk_down+0x541/0x5e3 [btrfs]
>    walk_down_tree+0xab/0xe7 [btrfs]
>    btrfs_drop_snapshot+0x356/0x71a [btrfs]
>    btrfs_clean_one_deleted_snapshot+0xb8/0xf0 [btrfs]
>    cleaner_kthread+0x12b/0x160 [btrfs]
>    kthread+0x112/0x130
>    ret_from_fork+0x27/0x50
>
> When dropping snapshots with qgroup enabled, we will trigger backref
> walk.
>
> However such backref walk at that timing is pretty dangerous, as if one
> of the parent nodes get WRITE locked by other thread, we could cause a
> dead lock.
>
> For example:
>
>            FS 260     FS 261 (Dropped)
>             node A        node B
>            /      \      /      \
>        node C      node D      node E
>       /   \         /  \        /     \
>   leaf F|leaf G|leaf H|leaf I|leaf J|leaf K
>
> The lock sequence would be:
>
>       Thread A (cleaner)             |       Thread B (other writer)
> -----------------------------------------------------------------------
> write_lock(B)                        |
> write_lock(D)                        |
> ^^^ called by walk_down_tree()       |
>                                      |       write_lock(A)
>                                      |       write_lock(D) << Stall
> read_lock(H) << for backref walk     |
> read_lock(D) << lock owner is        |
>                 the same thread A    |
>                 so read lock is OK   |
> read_lock(A) << Stall                |
>
> So thread A hold write lock D, and needs read lock A to unlock.
> While thread B holds write lock A, while needs lock D to unlock.
>
> This will cause a deadlock.
>
> This is not only limited to snapshot dropping case.
> As the backref walk, even only happens on commit trees, is breaking the
> normal top-down locking order, makes it deadlock prone.
>
> Fixes: fb235dc06fac ("btrfs: qgroup: Move half of the qgroup accounting t=
ime out of commit trans")
> CC: stable@vger.kernel.org # 4.19+
> Reported-and-tested-by: David Sterba <dsterba@suse.com>
> Reported-by: Filipe Manana <fdmanana@suse.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ copy logs and deadlock analysis from Qu's patch ]
> [ rebase to latest branch and fix lock assert bug ]
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good.

> ---
> changelog:
> v2:
> - Rebased to latest misc-next branch.
> - Fix a lock assert by moving btrfs_set_lock_blocking_read() into the
>   same branch of btrfs_tree_read_lock().
> ---
>  fs/btrfs/backref.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 136454dbb4af..6e647520b65a 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -712,7 +712,7 @@ static int resolve_indirect_refs(struct btrfs_fs_info=
 *fs_info,
>   * read tree blocks and add keys where required.
>   */
>  static int add_missing_keys(struct btrfs_fs_info *fs_info,
> -                           struct preftrees *preftrees)
> +                           struct preftrees *preftrees, bool lock)
>  {
>         struct prelim_ref *ref;
>         struct extent_buffer *eb;
> @@ -737,12 +737,14 @@ static int add_missing_keys(struct btrfs_fs_info *f=
s_info,
>                         free_extent_buffer(eb);
>                         return -EIO;
>                 }
> -               btrfs_tree_read_lock(eb);
> +               if (lock)
> +                       btrfs_tree_read_lock(eb);
>                 if (btrfs_header_level(eb) =3D=3D 0)
>                         btrfs_item_key_to_cpu(eb, &ref->key_for_search, 0=
);
>                 else
>                         btrfs_node_key_to_cpu(eb, &ref->key_for_search, 0=
);
> -               btrfs_tree_read_unlock(eb);
> +               if (lock)
> +                       btrfs_tree_read_unlock(eb);
>                 free_extent_buffer(eb);
>                 prelim_ref_insert(fs_info, &preftrees->indirect, ref, NUL=
L);
>                 cond_resched();
> @@ -1227,7 +1229,7 @@ static int find_parent_nodes(struct btrfs_trans_han=
dle *trans,
>
>         btrfs_release_path(path);
>
> -       ret =3D add_missing_keys(fs_info, &preftrees);
> +       ret =3D add_missing_keys(fs_info, &preftrees, path->skip_locking =
=3D=3D 0);
>         if (ret)
>                 goto out;
>
> @@ -1288,11 +1290,14 @@ static int find_parent_nodes(struct btrfs_trans_h=
andle *trans,
>                                         ret =3D -EIO;
>                                         goto out;
>                                 }
> -                               btrfs_tree_read_lock(eb);
> -                               btrfs_set_lock_blocking_read(eb);
> +                               if (!path->skip_locking) {
> +                                       btrfs_tree_read_lock(eb);
> +                                       btrfs_set_lock_blocking_read(eb);
> +                               }
>                                 ret =3D find_extent_in_eb(eb, bytenr,
>                                                         *extent_item_pos,=
 &eie, ignore_offset);
> -                               btrfs_tree_read_unlock_blocking(eb);
> +                               if (!path->skip_locking)
> +                                       btrfs_tree_read_unlock_blocking(e=
b);
>                                 free_extent_buffer(eb);
>                                 if (ret < 0)
>                                         goto out;
> --
> 2.18.0
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
