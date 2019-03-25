Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55555C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 11:14:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2025D207DD
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 11:14:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KOqq+aH2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbfCYLOj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 07:14:39 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:33884 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730472AbfCYLOi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 07:14:38 -0400
Received: by mail-vs1-f65.google.com with SMTP id t78so5119908vsc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 04:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=fG9oJsqPctVCbJSBOuwdVd4Dt9o8SH9P01PjdnOOz7A=;
        b=KOqq+aH2Cp9+ZyyCz427NTYhbv9GeXzHCedzSX7Ea2NUnQAEn+9aA5JXwPj8cVAeDQ
         OhaiucI1hGMp2+LbNsL52lc/RI+dRTwU0FxtlLIn13DydQ3wYOtit/jyGiRW/opCsco5
         9y6SoSvF2IRQto3Y8PLsI0MiWwQJI0UgRnaiuM/BjHx3Sl4104MqeDjJrVusOF9F2Ifa
         7VXx23WuuG8Wqhn+EJwc61B0n91fp+jBEnG0cXAClAXXmdGPLhUYylqGbchRC33/Vtgt
         h8v7af/320bQnXcoQUA9RtkysvDJdHaK3V8nMks4jF+2bfYcMoX3LJCtak5m/U8BwSF3
         oWbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=fG9oJsqPctVCbJSBOuwdVd4Dt9o8SH9P01PjdnOOz7A=;
        b=bt6XJmeYz1AU6IUGbgiUAMeGHIaLnUINXpIuzJGA2vEBFLrH00Ms3uNml4bbTf6UfO
         Jc4Fo/LOFsu714RXQC95odyJzh3fZFlpQRDANnRKTHchv+vuWsT7nvDUHDNxyFKpU7xK
         BgQU992F/zntg7xt1Ys0Lozxq0es71sgDUNnUULM52huLzEe6c6WJdNQOW6e5CQr46oh
         qCc/TCCYmOIWlIOCFCVo6yLXbXYfhVa4zHfGAlBI4Ee0KglZ5eFGOyYzepIAAF17wgAI
         5nJZrHTRyNETCVw9ANwixJTrapH7/SjMWr2UAksFb07CpqQl2DHy9qmzfTNqwUw6JszF
         afWA==
X-Gm-Message-State: APjAAAW43+yFsz+YFbLzhNRIg5CGaGEgG2FHAN/iO61/Bbbd4lOtKtCy
        YyggyoDjDS4+pMT8IJFwFqCPlzZ9UUCqyAekXwLld7EM
X-Google-Smtp-Source: APXvYqylh7uCdV6cCIu4Z/jqfVTOlkKgrYE/d/Nfb9qEbu1kNq4yFuPZS5egxRyN5RVFJVKBnChiN4BxKJI6XQEmSAk=
X-Received: by 2002:a67:f3c3:: with SMTP id j3mr5932475vsn.206.1553512477710;
 Mon, 25 Mar 2019 04:14:37 -0700 (PDT)
MIME-Version: 1.0
References: <1547435747-20013-1-git-send-email-robbieko@synology.com>
In-Reply-To: <1547435747-20013-1-git-send-email-robbieko@synology.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 25 Mar 2019 11:14:26 +0000
Message-ID: <CAL3q7H7ootLePYme21_yg4bGUVZ+_LgK8-UyRNUWkb05Y=KT+g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix data bytes_may_use underflow with fallocate
 due to failed quota reserve
To:     robbieko <robbieko@synology.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 14, 2019 at 3:26 AM robbieko <robbieko@synology.com> wrote:
>
> From: Robbie Ko <robbieko@synology.com>
>
> When doing fallocate, we first add the range to the reserve_list
> and then reserve the qutoa.

qutoa -> quota

> If quota reservation fails, we'll release all reserved parts of
> reserve_list.
> However, cur_offset doen't update to indicate that this range is

"doen't update" -> is not updated to indicate ...

> already been inserted into the list.
> Therefore, the same range is freed twice.
> One at list_for_each_entry loop, and the other at the end of the

One -> once
and the other at -> and once at

> function.
> This will result in WARN_ON on bytes_may_use when we free the
> remaining space.
>
> Fixes: ("btrfs: update btrfs_space_info's bytes_may_use timely")

Missing commit id.

> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/file.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index d38dc8c..43c6c8a 100644
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

This will fix the problem if there's only one range, or we happen to
be very lucky and cur_offset
matches exactly the middle of the entire range passed to fallocate()
(in case the range covers
a sparse region of the file, a region with holes and extents).

At the end, under the 'out' label we have a call to:

   btrfs_free_reserved_data_space(inode, data_reserved, alloc_start,
alloc_end - cur_offset);

That doesn't fell right - the start offset, third argument, should be
cur_offset. Everything from
alloc_start to cur_offset was freed by the list_for_each_entry_safe_loop.





>                                 free_extent_map(em);
>                                 break;
>                         }
> --
> 1.9.1
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
