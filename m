Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB153C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 19:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC86E2084B
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 19:21:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ky+HNa3U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbfDBTVv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 15:21:51 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:41025 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfDBTVv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 15:21:51 -0400
Received: by mail-vs1-f65.google.com with SMTP id g187so8480385vsc.8
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2019 12:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=zsLCWiLo7DyVP7lByMPoycSd0u8HfEOg+TaNtBae36M=;
        b=ky+HNa3UnQCwAbDnS/u2IDgf7pOUUpPqi6w4LY2vISOcAy1huJA+q8QWf620JI+2DV
         laezQgkmbnHWkmdVqDDnK/u7FtnQDaM4RCwRdVoDWsGa50jT6zdZ1PPaLh99zluQ9g7o
         6C2N5xhzQD9Ui9BQhxgo9or0sUuMZMQo4GQgUlqGPYl+4F/lP8ZRweKFQB/NgCxl1vi3
         BraAjUWgFoOzucfyf1zOEMVbkYYPMVm339YsTEIBMnSehDCjlPMO4MLbb6PGDW/jlhAd
         T5Y48jb5SFAMcPsDPMj5MKcwa+V+1KdV2MpIRn+l+xGh7PeYURzYCcuFmyOAulnxGms4
         8X9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=zsLCWiLo7DyVP7lByMPoycSd0u8HfEOg+TaNtBae36M=;
        b=TfkAei0mq6oYIHRD4lh8r5LmsJM48dq4e5CPIRCIKgcVDmLjq2FdEriKXF6qeXfkZJ
         LJggKQM+ZfDH5j+ZNrsldjK85Ab0mJ1PMECjJDUHm74eQS0DCB/PJ3U7zEDk8niJEc0k
         yeB9ofMMsoct53FdG7dcHn65ay/790UNu8v0osLPvV6Q8ec7aolhMmmBK5C692lKLcr5
         Q5rm5hODPpKQyhHAt+zancWPYKHVNHYj8bjHgaGP7oYVGu9hg6oP4SHu21O/Stfe+7VU
         fbK1mzW1cCViERFLvKXXun+6bCd8Wp0MxSYEoOG9VWYp+OPlFbl7YWqFPMtmQRThox7Q
         NseA==
X-Gm-Message-State: APjAAAVw8MHqvzoj6qQcQOa1EVbJKrklIzNTYiB9zsXX/D0dL2cuBY2X
        lEk/1yf+8erFlIJ41l3x1qCcDb1ZSo3n1huEcFF5yw==
X-Google-Smtp-Source: APXvYqwaDg5RJIa/+7hg3GZH8wEw+b92SRiVU4yUVnfpnAlF86iM4gYTWnDSDYod4HylTrO63wwxAvnEPO/tiEM5jJI=
X-Received: by 2002:a67:e258:: with SMTP id w24mr30338343vse.20.1554232910294;
 Tue, 02 Apr 2019 12:21:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190402180956.28893-1-jeffm@suse.com> <20190402180956.28893-2-jeffm@suse.com>
In-Reply-To: <20190402180956.28893-2-jeffm@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 2 Apr 2019 19:21:39 +0000
Message-ID: <CAL3q7H5hbLM_x2uUqViQr1q6uce5q8GYxmYed6Y+w--GbjKL0w@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs-progs: check: fixup_extent_flags needs to deal
 with non-skinny metadata
To:     Jeff Mahoney <jeffm@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 2, 2019 at 7:31 PM <jeffm@suse.com> wrote:
>
> From: Jeff Mahoney <jeffm@suse.com>
>
> When repairing a file system created by a very old kernel, I ran into
> issues fixing up the extent flags since fixup_extent_flags assumed
> that a METADATA_ITEM would be present if the record was for metadata.
>
> Since METADATA_ITEMs don't exist without skinny metadata, we need to
> fall back to EXTENT_ITEMs.  This also falls back to EXTENT_ITEMs even
> with skinny metadata enabled as other parts of the tools do.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good.

> ---
>  check/main.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/check/main.c b/check/main.c
> index 7547209c..4a27a443 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -7540,9 +7540,13 @@ static int fixup_extent_flags(struct btrfs_fs_info=
 *fs_info,
>         struct btrfs_key key;
>         u64 flags;
>         int ret =3D 0;
> +       bool metadata_item =3D rec->metadata;
>
> +       if (!btrfs_fs_incompat(root->fs_info, SKINNY_METADATA))
> +               metadata_item =3D false;
> +retry:
>         key.objectid =3D rec->start;
> -       if (rec->metadata) {
> +       if (metadata_item) {
>                 key.type =3D BTRFS_METADATA_ITEM_KEY;
>                 key.offset =3D rec->info_level;
>         } else {
> @@ -7561,6 +7565,10 @@ static int fixup_extent_flags(struct btrfs_fs_info=
 *fs_info,
>                 btrfs_commit_transaction(trans, root);
>                 return ret;
>         } else if (ret) {
> +               if (key.type =3D=3D BTRFS_METADATA_ITEM_KEY) {
> +                       metadata_item =3D false;
> +                       goto retry;
> +               }
>                 fprintf(stderr, "Didn't find extent for %llu\n",
>                         (unsigned long long)rec->start);
>                 btrfs_release_path(&path);
> --
> 2.16.4
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
