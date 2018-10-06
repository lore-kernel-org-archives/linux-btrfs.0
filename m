Return-Path: <SRS0=jasM=MS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4F1C677E8
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 17:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04A9721473
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Oct 2018 17:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bJ/c8sa1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04A9721473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbeJGASK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Oct 2018 20:18:10 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33090 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbeJGASK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2018 20:18:10 -0400
Received: by mail-oi1-f193.google.com with SMTP id a203-v6so12869322oib.0
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Oct 2018 10:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=BgAvHGQNVSZbL75TR+1dT0vKJbIPEjdKbE/UZLFCZ0w=;
        b=bJ/c8sa1kAS0measM0FfhkmM/nwgYiG7U3LRmUmwnDD48KtvM85D8OdjcbBBZjxlCV
         /B7iAgPWL9/dtv0iTsMR2JMdNkRSDYuU8MCA9561udg9rZuJb5KTBAN/8PLxtDz/tiNR
         6ItSiP8CZJd4kbAYmwOrSPPTDzZlVqoEBkt5wr9vtFJR3FyXglY5kAGLz0wLPw2RU8ge
         3btk/AR73gsL6Ubk/Kfcbqd4dQMHpjOED1FOZFMMyb2BiSOCOWSjN2jGVeRpJ8Nvn/Rz
         9V1dfNhgMVw0VkB4L0AwnP6NpUj5sxvRualyHfGZlXnZkTfRL3w+yzUAdi6/BybKKMaf
         wRZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=BgAvHGQNVSZbL75TR+1dT0vKJbIPEjdKbE/UZLFCZ0w=;
        b=SrAl4DkyQxAiTDmlyZa3gT1BDYxPcP9YT9uUXGVSTkVstOKAUBAdnSLFL0IftHzMgp
         BpJXnBCRrYfV2oIvRh3bkbdNW3rpnJY8FIU2i6s/1epgM6Nya3rmrzMfvTGdUr/wCJ8J
         5J4oVssJZl05WLB2M2v1BBuNIxL/3D4fGDJiu1b6d9f9/2YCIK6q3YA43BPYn2r8LYwA
         QFEjCULUsw03RHRf2ILg+SvhiXmLyTD7iDHmGFQH200bys0yvgq4yGKcCTOSKfngbHK9
         JwGbmLZN00NBtGwLp0BnsLQSQ8XS5Im7mL9gE+v8ktPYEjQPOhq8bHDpTzpPTtukBKiN
         pl0w==
X-Gm-Message-State: ABuFfoj+T4oR5HD+HD0w08xVi65jxA4d808bBu+bjJtYkgh2jfaYW1tz
        WnKXZEiMf2D4HwnsX2nbgBUmQ6x5+WP5HbmzuHH06A==
X-Google-Smtp-Source: ACcGV62M/V8N2RGvU3kVkg6x0zx72HDddO+9W96IRlRM7iAgfSON4p9DdestvUmtd/OyyhRxXMogNu2Cr4veL83hgwM=
X-Received: by 2002:aca:3585:: with SMTP id c127-v6mr1933491oia.63.1538846040846;
 Sat, 06 Oct 2018 10:14:00 -0700 (PDT)
MIME-Version: 1.0
References: <20180918100913.31285-1-timofey.titovets@synesis.ru>
In-Reply-To: <20180918100913.31285-1-timofey.titovets@synesis.ru>
From:   Timofey Titovets <nefelim4ag@gmail.com>
Date:   Sat, 6 Oct 2018 20:13:24 +0300
Message-ID: <CAGqmi74uiEi0Gn9xTrTv_xK17_Z8DJscT3yu1zGhB79Nc=Ce_w@mail.gmail.com>
Subject: Re: [PATCH RESEND] Btrfs: make should_defrag_range() understood
 compressed extents
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

=D0=B2=D1=82, 18 =D1=81=D0=B5=D0=BD=D1=82. 2018 =D0=B3. =D0=B2 13:09, Timof=
ey Titovets <timofey.titovets@synesis.ru>:
>
> From: Timofey Titovets <nefelim4ag@gmail.com>
>
>  Both, defrag ioctl and autodefrag - call btrfs_defrag_file()
>  for file defragmentation.
>
>  Kernel default target extent size - 256KiB.
>  Btrfs progs default - 32MiB.
>
>  Both bigger then maximum size of compressed extent - 128KiB.
>  That lead to rewrite all compressed data on disk.
>
>  Fix that by check compression extents with different logic.
>
>  As addition, make should_defrag_range() understood compressed extent typ=
e,
>  if requested target compression are same as current extent compression t=
ype.
>  Just don't recompress/rewrite extents.
>  To avoid useless recompression of compressed extents.
>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/ioctl.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a990a9045139..0a5ea1ccc89d 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1142,7 +1142,7 @@ static bool defrag_check_next_extent(struct inode *=
inode, struct extent_map *em)
>
>  static int should_defrag_range(struct inode *inode, u64 start, u32 thres=
h,
>                                u64 *last_len, u64 *skip, u64 *defrag_end,
> -                              int compress)
> +                              int compress, int compress_type)
>  {
>         struct extent_map *em;
>         int ret =3D 1;
> @@ -1177,8 +1177,29 @@ static int should_defrag_range(struct inode *inode=
, u64 start, u32 thresh,
>          * real extent, don't bother defragging it
>          */
>         if (!compress && (*last_len =3D=3D 0 || *last_len >=3D thresh) &&
> -           (em->len >=3D thresh || (!next_mergeable && !prev_mergeable))=
)
> +           (em->len >=3D thresh || (!next_mergeable && !prev_mergeable))=
) {
>                 ret =3D 0;
> +               goto out;
> +       }
> +
> +
> +       /*
> +        * Try not recompress compressed extents
> +        * thresh >=3D BTRFS_MAX_UNCOMPRESSED will lead to
> +        * recompress all compressed extents
> +        */
> +       if (em->compress_type !=3D 0 && thresh >=3D BTRFS_MAX_UNCOMPRESSE=
D) {
> +               if (!compress) {
> +                       if (em->len =3D=3D BTRFS_MAX_UNCOMPRESSED)
> +                               ret =3D 0;
> +               } else {
> +                       if (em->compress_type !=3D compress_type)
> +                               goto out;
> +                       if (em->len =3D=3D BTRFS_MAX_UNCOMPRESSED)
> +                               ret =3D 0;
> +               }
> +       }
> +
>  out:
>         /*
>          * last_len ends up being a counter of how many bytes we've defra=
gged.
> @@ -1477,7 +1498,8 @@ int btrfs_defrag_file(struct inode *inode, struct f=
ile *file,
>
>                 if (!should_defrag_range(inode, (u64)i << PAGE_SHIFT,
>                                          extent_thresh, &last_len, &skip,
> -                                        &defrag_end, do_compress)){
> +                                        &defrag_end, do_compress,
> +                                        compress_type)){
>                         unsigned long next;
>                         /*
>                          * the should_defrag function tells us how much t=
o skip
> --
> 2.19.0

Ok, If no one like that patch,
may be at least fix autodefarag on compressed files?
By change default extent target size 256K -> 128K?

--=20
Have a nice day,
Timofey.
