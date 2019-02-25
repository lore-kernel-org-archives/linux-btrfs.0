Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970E9C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 17:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5691F20643
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 17:46:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cpV6P2G0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfBYRqE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 12:46:04 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:34731 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfBYRqE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 12:46:04 -0500
Received: by mail-ua1-f67.google.com with SMTP id a42so9200854uad.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 09:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=VyWNk/2eF63siHECXLSPtK0/z7QCGT190RJUeUfxWT0=;
        b=cpV6P2G0MSwRrpLWIbYzrnPV64QpfEWjNM+Yvhs33j0mX17/aJaZusNlXPZO19masO
         LD20rVEZxd0zqZVVE+j4jYWU/4gnXBUcr88thqczvv8M/XRNf6yuaLIcQaZvkc6AAPNX
         ko6VFfCzXEJAXzML2/6E9mC2EH9iy+uG+AjpFyp9NK42J0D5l3YgQGZwKwgv2f2GSVSk
         M1TGG+OyqhKYNs/12dY6vvip7MMDoV9hTEML6ObXR/bRWe02rx3H1QSuMzYPzTzE000P
         MT2hFLa+fLHzBaEm6tUH1FBdr54k1/4y2b5iS3WC/jMmhfL8RXxygOsB31t9P5YHeEBG
         7AGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=VyWNk/2eF63siHECXLSPtK0/z7QCGT190RJUeUfxWT0=;
        b=eSntUZeq0z84ofJhuj7eVWwV9AFBOGyW6zB7H8jgse0bjY0YoFDVIbakoy7JQfdupp
         V36zqOEoaW1sXgi9+Ap7rCx5Nfn+RW80b3a/kkU1sQq/fzQYKgx2OmulYtriCxLrzteZ
         Sbc0A1a+Zfjh+TQVFHDfrEnX144PaLBEkZHIoj9OApUs3QQcNyWnGaujp7j00ub1UzW6
         TxVwkqSzL1NfOBr/z1ReMMjf16MxTPVf4IKdE7rWzYeKwEFZCmqtelu5pQD+dNU5pwV1
         NmifURHJeO8MbJXZdQujSU714GturLS+8g551Yv1QScDgrPyitBDigKI9RHg8410ZwS2
         MBIQ==
X-Gm-Message-State: AHQUAuYd8hMfzGs9qi6c6kaMbF15FWuOOMWb1M5lMHgmymoMBTIpTmfl
        bH0pfeCQc6QayIUp1IDRb2rsHCwcX3D+qHJpakU=
X-Google-Smtp-Source: AHgI3IYYYxLLvj51bJJHal3id4vXP4FzPoCzWNSCwYzukbN/tJ2UrwWyEzcPXC7SQfBfCwVETrB+VxFcT2oZVbAO35Y=
X-Received: by 2002:a67:e28e:: with SMTP id g14mr9723530vsf.95.1551116762578;
 Mon, 25 Feb 2019 09:46:02 -0800 (PST)
MIME-Version: 1.0
References: <20190225161445.2025-1-josef@toxicpanda.com>
In-Reply-To: <20190225161445.2025-1-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 25 Feb 2019 17:45:51 +0000
Message-ID: <CAL3q7H6qPTDXrHRE0wngm5gX5syTmWFW862E6raYco5V_e3h2Q@mail.gmail.com>
Subject: Re: [PATCH][RFC] btrfs: fix relocation panic
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 4:16 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> We've been seeing the following sporadically throughout our fleet
>
> panic: kernel BUG at fs/btrfs/relocation.c:4584!
> netversion: 5.0-0
> Backtrace:
>  #0 [ffffc90003adb880] machine_kexec at ffffffff81041da8
>  #1 [ffffc90003adb8c8] __crash_kexec at ffffffff8110396c
>  #2 [ffffc90003adb988] crash_kexec at ffffffff811048ad
>  #3 [ffffc90003adb9a0] oops_end at ffffffff8101c19a
>  #4 [ffffc90003adb9c0] do_trap at ffffffff81019114
>  #5 [ffffc90003adba00] do_error_trap at ffffffff810195d0
>  #6 [ffffc90003adbab0] invalid_op at ffffffff81a00a9b
>     [exception RIP: btrfs_reloc_cow_block+692]
>     RIP: ffffffff8143b614  RSP: ffffc90003adbb68  RFLAGS: 00010246
>     RAX: fffffffffffffff7  RBX: ffff8806b9c32000  RCX: ffff8806aad00690
>     RDX: ffff880850b295e0  RSI: ffff8806b9c32000  RDI: ffff88084f205bd0
>     RBP: ffff880849415000   R8: ffffc90003adbbe0   R9: ffff88085ac90000
>     R10: ffff8805f7369140  R11: 0000000000000000  R12: ffff880850b295e0
>     R13: ffff88084f205bd0  R14: 0000000000000000  R15: 0000000000000000
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #7 [ffffc90003adbbb0] __btrfs_cow_block at ffffffff813bf1cd
>  #8 [ffffc90003adbc28] btrfs_cow_block at ffffffff813bf4b3
>  #9 [ffffc90003adbc78] btrfs_search_slot at ffffffff813c2e6c
>
> The way relocation moves data extents is by creating a reloc inode and
> preallocating extents in this inode and then copying the data into these
> preallocated extents.  Once we've done this for all of our extents,
> we'll write out these dirty pages, which marks the extent written, and
> goes into btrfs_reloc_cow_block().  From here we get our current
> reloc_control, which _should_ match the reloc_control for the current
> block group we're relocating.
>
> However if we get an ENOSPC in this path at some point we'll bail out,
> never initiating writeback on this inode.  Not a huge deal, unless we
> happen to be doing relocation on a different block group, and this block
> group is now rc->stage =3D=3D UPDATE_DATA_PTRS.  This trips the BUG_ON() =
in
> btrfs_reloc_cow_block(), because we expect to be done modifying the data
> inode.  We are in fact done modifying the metadata for the data inode
> we're currently using, but not the one from the failed block group, and
> thus we BUG_ON().
>
> Fix this by writing out the reloc data inode always, and then breaking
> out of the loop after that point to keep from tripping this BUG_ON()
> later.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Perhaps it's worth noting that this happens when writeback finishes
for extents from the previous group, when we are
at btrfs_finish_ordered_io() which updates the data reloc tree (inode
item, drops/adds extent items, etc).

Anyway, looks good to me as it is.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
>
> This is tricky to reproduce, it only happens on ~50 boxes a day here, and=
 is
> completely timing dependant.  I'm heading to Boston for a few days, but t=
his is
> kind of important and I need everybody to look at this and tell me if it =
makes
> sense.  I'm trying to force the problem to happen locally, but I'm not go=
ing to
> be able to put much more time into it until Thursday.
>
>  fs/btrfs/relocation.c | 31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index ddf028509931..00c3dd92f088 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4330,27 +4330,36 @@ int btrfs_relocate_block_group(struct btrfs_fs_in=
fo *fs_info, u64 group_start)
>                 mutex_lock(&fs_info->cleaner_mutex);
>                 ret =3D relocate_block_group(rc);
>                 mutex_unlock(&fs_info->cleaner_mutex);
> -               if (ret < 0) {
> +               if (ret < 0)
>                         err =3D ret;
> -                       goto out;
> -               }
> -
> -               if (rc->extents_found =3D=3D 0)
> -                       break;
> -
> -               btrfs_info(fs_info, "found %llu extents", rc->extents_fou=
nd);
>
> +               /*
> +                * We may have gotten ENOSPC after we already dirtied som=
e
> +                * extents.  If writeout happens while we're relocating a
> +                * different block group we could end up hitting the
> +                * BUG_ON(rc->stage =3D=3D UPDATE_DATA_PTRS) in
> +                * btrfs_reloc_cow_block.  Make sure we write everything =
out
> +                * properly so we don't trip over this problem, and then =
break
> +                * out of the loop if we hit an error.
> +                */
>                 if (rc->stage =3D=3D MOVE_DATA_EXTENTS && rc->found_file_=
extent) {
>                         ret =3D btrfs_wait_ordered_range(rc->data_inode, =
0,
>                                                        (u64)-1);
> -                       if (ret) {
> +                       if (ret)
>                                 err =3D ret;
> -                               goto out;
> -                       }
>                         invalidate_mapping_pages(rc->data_inode->i_mappin=
g,
>                                                  0, -1);
>                         rc->stage =3D UPDATE_DATA_PTRS;
>                 }
> +
> +               if (err < 0)
> +                       goto out;
> +
> +               if (rc->extents_found =3D=3D 0)
> +                       break;
> +
> +               btrfs_info(fs_info, "found %llu extents", rc->extents_fou=
nd);
> +
>         }
>
>         WARN_ON(rc->block_group->pinned > 0);
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
