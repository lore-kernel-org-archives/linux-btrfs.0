Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7E6C43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 16:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF2DF2089F
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 16:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kisAHxwI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbfAGQ1z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 11:27:55 -0500
Received: from mail-vk1-f195.google.com ([209.85.221.195]:34867 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730399AbfAGQ1y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2019 11:27:54 -0500
Received: by mail-vk1-f195.google.com with SMTP id b18so215991vke.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jan 2019 08:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=ItOe6+jVfR5qHSrMXUtCGUBjUAsUCiKOpQJwmTWjw6c=;
        b=kisAHxwI2V/sp5i6Rr7+jyRh1LSppbkw7rH7X1PpMD4X9iqoxFsvQbN4ZmnyM/zC6M
         EhS+eGy6p4X/mX+16ZXVfnEYqlzVAetGE5K1jJ+VctjBGFdZYajgM/m9tzN2Tl/eWKRs
         qxwIiAQbqKXa0xEMTPgz//VNeTozpwR5gGaZKbvTNjoEyhipG30ihG+EBjiGUStJs0uG
         kB1tH6gMM7ZQUTV4fAU69AY4gpIVJA4IwpBvdywuCjmftxWpmY2ZR3/z2el3YQObSrOl
         FqZ3Wz8RDY5PFLgdjBA3J+DslmsOS/sYJsX4mcxzxRdG3OQ+VulIPGIW3nvWEsmc6hPu
         SR4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=ItOe6+jVfR5qHSrMXUtCGUBjUAsUCiKOpQJwmTWjw6c=;
        b=ShpkXYiwEFsvM5ZvdsBQvcj/fSHe2NEiPTtptgR+978dHN+gKxtKcNVPO5UHaaI4DN
         9EUf2Tot0hgrPwjdnVALa6mBN8R69XKq2w4S06XaStqQcHbJVZD3KPw3ASme2xXcBh95
         wvh0BnTB+bsekr2OVdP7R+ZrZkKDAhGdwp+XNNvg8di0lzPVtdT5N2b7+4iO2djtCwXx
         NZGx/tPFlPLRnzSKYjaiqGmGQgmX0anQRqHGjfPA3Jds+XoLOIxyiQKt4oip/gkg+Cli
         8ldduK5r8BeFeaUmwqXdMfTsj4NYwg/6RV2VqDMp/QHw703diTkuqz+1FRUFaJn8mmi7
         A7XQ==
X-Gm-Message-State: AJcUukee12xxvwzlJAs39OLPgcF44zQZqEcHtHQMfl8Hx7NeomuEMVdW
        FzaAqCAcUTW421KEGF5paaykkNxkyV5eT0SMlFrAGdvv
X-Google-Smtp-Source: ALg8bN76DTMUUZQyJ3FcxEH9rYY/8FfGlf/AM6Gukv9/RP+cNxKeYbGSRnSZ3Xu9GVPQarVzabhr36YysKMY8Pd7o60=
X-Received: by 2002:a1f:80d3:: with SMTP id b202mr22097703vkd.23.1546878473308;
 Mon, 07 Jan 2019 08:27:53 -0800 (PST)
MIME-Version: 1.0
References: <20181005094555.31177-1-wqu@suse.com> <20181005094555.31177-3-wqu@suse.com>
In-Reply-To: <20181005094555.31177-3-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 7 Jan 2019 16:27:41 +0000
Message-ID: <CAL3q7H4-YsT4n663XNTzFa9hUnmRWUPzgvovP-GcYnkA6cKHWw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] btrfs: volumes: Make sure no dev extent is beyond
 device boundary
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 5, 2018 at 10:46 AM Qu Wenruo <wqu@suse.com> wrote:
>
> Add extra dev extent end check against device boundary.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/volumes.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index bf0b2c16847a..bc3ac4715694 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -7371,6 +7371,7 @@ static int verify_one_dev_extent(struct btrfs_fs_in=
fo *fs_info,
>         struct extent_map_tree *em_tree =3D &fs_info->mapping_tree.map_tr=
ee;
>         struct extent_map *em;
>         struct map_lookup *map;
> +       struct btrfs_device *dev;
>         u64 stripe_len;
>         bool found =3D false;
>         int ret =3D 0;
> @@ -7420,6 +7421,22 @@ static int verify_one_dev_extent(struct btrfs_fs_i=
nfo *fs_info,
>                         physical_offset, devid);
>                 ret =3D -EUCLEAN;
>         }
> +
> +       /* Make sure no dev extent is beyond device bondary */
> +       dev =3D btrfs_find_device(fs_info, devid, NULL, NULL);

Qu,

This breaks use cases including seed devices. In those cases we need
to find a device by ID and FSID (not not return the first device we
find with a specific ID, ignoring the FSID).
Fstest btrfs/163 now fails in 5.0-rc1 because of this change.

Thanks.

> +       if (!dev) {
> +               btrfs_err(fs_info, "failed to find devid %llu", devid);
> +               ret =3D -EUCLEAN;
> +               goto out;
> +       }
> +       if (physical_offset + physical_len > dev->disk_total_bytes) {
> +               btrfs_err(fs_info,
> +"dev extent devid %llu physical offset %llu len %llu is beyond device bo=
undary %llu",
> +                         devid, physical_offset, physical_len,
> +                         dev->disk_total_bytes);
> +               ret =3D -EUCLEAN;
> +               goto out;
> +       }
>  out:
>         free_extent_map(em);
>         return ret;
> --
> 2.19.0
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
