Return-Path: <SRS0=5Bfi=RA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53605C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 09:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C6DA20842
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Feb 2019 09:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U3opNa/V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfBYJ5Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Feb 2019 04:57:25 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:44494 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfBYJ5Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Feb 2019 04:57:25 -0500
Received: by mail-ua1-f66.google.com with SMTP id r21so606129uan.11
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2019 01:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=QmGboR81EdV4LG4hs9XsU8UJG55P+qzOut5VzyR7GN4=;
        b=U3opNa/VwNjNywKq/HlFkLPGAaRzjB6YCnVx1JtoGjAyIKhPKJ7pvKf4Wt/+QYkeXJ
         4ubtkobSd6BVy8rDYrinCep2Zp+cCgGtHErt1mOEa5vXQ0nBdvbFG08ewQU+CRIgtnlI
         q+1llJsOdUBWn7FXMlX+/olM3rSh21AXepPlbtUckvzSkY0ftF85Dv2l5CodtPLfq1aM
         3oqm7TCZpD3pmkKDarxOoNlXo7URBAeyK/TxqKlXPpxRoSvLvSLUapdDFM3cs/ydSyXa
         kaY3/w8x31T+jMZ1moHJCqeTbuz/HAaXZJBv2sa0ikJfjtyIMqQeiDc1Flg+1U0P1knR
         x5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=QmGboR81EdV4LG4hs9XsU8UJG55P+qzOut5VzyR7GN4=;
        b=Ufn6SEpQzhE5iIp/6TsIAr6zYO+g0mNVUTz5YtbEWbP8u+wxtJSK1mQ7LFuaTj5pKV
         qyQCirEQocgTLIF8aaXFI0UeryXSsIHoGMJ+1feYCrI/DVzJEECu5IraS1Bmn7AFXk3H
         BR17Y+iGAq6NVsavTQ2f27AuxWC9AO+Fnu8Ni4SjDMopv6/9xk7aIVMOj2zKkUr3nzi6
         pXhoe7/cd1h+LIgjjbfBIZi1epXo1Okz5vcSLdDu1xAffWKwp7kDJSHsjyHJ/1reMgqD
         Vpf54CseFwovpB1CV/o7jLi9xtmMj9QchVPVJ10u9vqCL1Qiedjhjo33VJaCL11BxLkb
         t7Ew==
X-Gm-Message-State: AHQUAuZzqPhDWmTMiRxLhF6Ia2KHXgViz7W+gNEfXjXg/OLee6o47hva
        +E5zJ1YgT74/GB0oHqfIcYVtPJoyFvcnEK6JWQE=
X-Google-Smtp-Source: AHgI3IbsRwmLleNCCZVgBmuSee5qmXuFxWA/8BptBvAV7UF8MPF2M1QeOIdarWF6Q5zZWVxSTIzzf7IFSHe9LwUkIps=
X-Received: by 2002:a67:ecc6:: with SMTP id i6mr8516669vsp.14.1551088643782;
 Mon, 25 Feb 2019 01:57:23 -0800 (PST)
MIME-Version: 1.0
References: <20190225051106.22091-1-wqu@suse.com>
In-Reply-To: <20190225051106.22091-1-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 25 Feb 2019 09:57:12 +0000
Message-ID: <CAL3q7H5cmpdeJ8o10ZHvShriSwNpCAxo1dbLbZHTEUXrZafsGQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Don't panic when we can't find a root key
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 5:12 AM Qu Wenruo <wqu@suse.com> wrote:
>
> When we failed to find a root key in btrfs_update_root(), we just panic.
>
> That's definitely not cool, fix it by aborting current transaction and
> return an error value.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Looks good.
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/root-tree.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 65bda0682928..c48a3e18866d 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -137,11 +137,15 @@ int btrfs_update_root(struct btrfs_trans_handle *tr=
ans, struct btrfs_root
>                 goto out;
>         }
>
> -       if (ret !=3D 0) {
> +       if (ret > 0) {
>                 btrfs_print_leaf(path->nodes[0]);
> -               btrfs_crit(fs_info, "unable to update root key %llu %u %l=
lu",
> -                          key->objectid, key->type, key->offset);
> -               BUG_ON(1);
> +               btrfs_crit(fs_info,
> +                       "unable to find root key (%llu %u %llu) in tree %=
llu",
> +                          key->objectid, key->type, key->offset,
> +                          root->root_key.objectid);
> +               ret =3D -ENOENT;
> +               btrfs_abort_transaction(trans, ret);
> +               goto out;
>         }
>
>         l =3D path->nodes[0];
> --
> 2.20.1
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
