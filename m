Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63680C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 10:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32F492084B
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 10:54:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rp81FlN3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbfCZKyy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 06:54:54 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:45557 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbfCZKyy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 06:54:54 -0400
Received: by mail-vs1-f66.google.com with SMTP id n14so7296743vsp.12
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2019 03:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=fz3z5345EI818tO3SbQ6gpAHoN0vsYE8MAaJdT1csiQ=;
        b=rp81FlN35NiqgCT9AVTpwP/GeDmR5BzO0UTNTvaA1FjiEO3Rr5KcwJw6sYnxDW8f4t
         t7DchlO1OkkWC1yizDYMy6QaVcqDGnXFph/uuq26A7PPde/pGPNYxtSW5E0LJ7VnaP4D
         FpJ5QRWuhxXrbXJT3170FIDBMx2P34zjSiXTtU2Vs/WbTOVObqVLsIMmFDxrB3w6otjS
         Ls5Ss5D/4drbH31Yop7vxKdPKdLwdVQpURXnxUYxIROEABnFx7yaowTOFo2wyJCaEiQZ
         jw9D6SCWdoq4jR5m6Y1WNQoCQHnhOYhlSUFBP6HOyCi1evzZ+yxl5lcYpln+gGqbvH1y
         kf/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=fz3z5345EI818tO3SbQ6gpAHoN0vsYE8MAaJdT1csiQ=;
        b=s82M/+ZiOQ2wDwyWOiZ5O/f/h+0vrTdGDmmPDODKbPJqfh1zmCg4XZBpeUOaBPZrjH
         ETPlNsxZ9PYWAf7hwxXVeutpJ3nVcQpZ8GUbGFNEmpGRsxqBmigabnNqVA2yqBQGzjKr
         NwQJQse+BWCy0pDgQfPYmhVPTrYyTeR7vMRXL7+LRuKivk/k2I+wTpG8s1t93pIBIMUb
         v0DYXf39Uil2lvF+INPieSxOmXXPEPnrQTonS90jkpmI6lNYQNdrV9jA8dsUb7os3Q7W
         XIHX57i9JhmjK55qkcxJYkL98V/xC4HODXNd8KhM7Xd2I2akItJ0XyVAya42F3d0IERK
         dK2w==
X-Gm-Message-State: APjAAAXnmxhHdXxNbehazTmFcDZiD9oluiHSWGmCI/E5AppeOqu8gH9b
        weY47LN4iWXt85MwNzAhFhuQIPsnmjCXyEJOEhmBgg==
X-Google-Smtp-Source: APXvYqySficPpPogHtdZ6ZZMbvqmsZkmchvvUKlv8IHoRm1ynEGSFbkVjA1J7Pg+AKo7O1EiOkC51xD43UouYzG9gkw=
X-Received: by 2002:a67:d098:: with SMTP id s24mr17493303vsi.95.1553597692177;
 Tue, 26 Mar 2019 03:54:52 -0700 (PDT)
MIME-Version: 1.0
References: <1553572571-15614-1-git-send-email-robbieko@synology.com>
In-Reply-To: <1553572571-15614-1-git-send-email-robbieko@synology.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 26 Mar 2019 10:54:41 +0000
Message-ID: <CAL3q7H7yywL9oXev17F0HX3JaNVfiYAnvSNVPWpJvSftWThP3w@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix data bytes_may_use underflow with fallocate
 due to failed quota reserve
To:     robbieko <robbieko@synology.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 3:57 AM robbieko <robbieko@synology.com> wrote:
>
> From: Robbie Ko <robbieko@synology.com>
>
> When doing fallocate, we first add the range to the reserve_list
> and then reserve the quota.
> If quota reservation fails, we'll release all reserved parts of
> reserve_list.
> However, cur_offset is not updated to indicate that this
> range is already been inserted into the list.
> Therefore, the same range is freed twice.
> Once at list_for_each_entry loop, and once at the end of the
> function.
> This will result in WARN_ON on bytes_may_use when we free the
> remaining space.
>
> At the end, under the 'out' label we have a call to:
>    btrfs_free_reserved_data_space(inode, data_reserved, alloc_start,
> alloc_end - cur_offset);
> The start offset, third argument, should be cur_offset.
> Everything from alloc_start to cur_offset was freed by the
> list_for_each_entry_safe_loop.
>
> Fixes: 18513091af94 ("btrfs: update btrfs_space_info's bytes_may_use time=
ly")
> Signed-off-by: Robbie Ko <robbieko@synology.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Now it looks good, thanks.

> ---
>  fs/btrfs/file.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 34fe8a5..0832449 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -3132,6 +3132,7 @@ static long btrfs_fallocate(struct file *file, int =
mode,
>                         ret =3D btrfs_qgroup_reserve_data(inode, &data_re=
served,
>                                         cur_offset, last_byte - cur_offse=
t);
>                         if (ret < 0) {
> +                               cur_offset =3D last_byte;
>                                 free_extent_map(em);
>                                 break;
>                         }
> @@ -3181,7 +3182,7 @@ static long btrfs_fallocate(struct file *file, int =
mode,
>         /* Let go of our reservation. */
>         if (ret !=3D 0 && !(mode & FALLOC_FL_ZERO_RANGE))
>                 btrfs_free_reserved_data_space(inode, data_reserved,
> -                               alloc_start, alloc_end - cur_offset);
> +                               cur_offset, alloc_end - cur_offset);
>         extent_changeset_free(data_reserved);
>         return ret;
>  }
> --
> 1.9.1
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
