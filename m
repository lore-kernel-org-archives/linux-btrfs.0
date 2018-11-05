Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3BDC0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 21:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C14E20825
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 21:43:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZcjRKNR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C14E20825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387974AbeKFHEt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 02:04:49 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46911 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387580AbeKFHEs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 02:04:48 -0500
Received: by mail-oi1-f195.google.com with SMTP id k64-v6so8866483oia.13
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Nov 2018 13:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j92I/m4I+PiGhzFF9G+wMGnHy/Ep0nH5k2gUNrU1Rkw=;
        b=CZcjRKNRmE/ArPyGO6UvU2bEE65aT+zeeAJLZqf8A+VQx05TvQK1K38C37oPEPbzjB
         mErdQcZWbd8LjBQDsNbod0br7b2MhUpd06LDUcz0HOUr1F/OseehePL8O5PyeaOE9jJa
         TJserfUFshB2z7Vd4Vq5S8DbjpZe9UMav0DM8ISuo3XQPXlmKCE/Ijk2NFCbraRxQlSe
         IEGogdtQ84Ypqbvt4ohf4NLP/FpG0kgo7XODckST3p+1aZB3BGrPaktks9qGG/fcCQMX
         yF0LXwMzR7r3EDk+3d4+eKEp7N5MhEYt6G9Ur5ap03FBwkkCH2u2FPD1gdKyLJU2f3qW
         qelQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j92I/m4I+PiGhzFF9G+wMGnHy/Ep0nH5k2gUNrU1Rkw=;
        b=Mtl/I5IRY1i21mWhBoj/e4wRdg7EQUTIB7euYTfjMaTGh+HMQ/t+GprQIfz39OCeRr
         Mx3SzaNPapb0lpuR84QVvbiJTyGvew0DCQY0Z5qO/hQZfl78ADNGboDtjuoR5EN5Ecl0
         zAaWHACnXvT8vbVA6ErG0FrW709zfvQSr63APEWwNvFWyfUOVMeir6r1/9ykM/7KTn4G
         VYZRCeW1K/SgwnhfXw8kb5MEgTdMjT9r4m0BO5a9iUyNjEPYTwwra9LJuNe04YNmVqE9
         w68445/DugexJRq0bwp82XOjLFyaEZhZb0yWhso1di8RQmsvzckvyP8oVtC5ehmJ5oCS
         xZow==
X-Gm-Message-State: AGRZ1gLahkRznMcBVTMHIHEpWMlDEfIzV3OBBQnCPSojb7fRMk/ht48X
        9qmNcd7nuSz4f6ZML5RUidnSqXXHhhGy/T9zHwOBdknU
X-Google-Smtp-Source: AJdET5fu7Bw/eODhl6ITnirxjTWnbHhCr3EdRHcijy9reo+jGCvFKJcMxr9njIaqL+hKBApBjesXUoyi31wIOZoXRr4=
X-Received: by 2002:aca:2414:: with SMTP id n20-v6mr12932853oic.40.1541454184526;
 Mon, 05 Nov 2018 13:43:04 -0800 (PST)
MIME-Version: 1.0
References: <20181105190643.13578-1-rosenp@gmail.com> <6b70f54e-23f2-ed16-ba49-f93c39eb98a2@suse.com>
In-Reply-To: <6b70f54e-23f2-ed16-ba49-f93c39eb98a2@suse.com>
From:   Rosen Penev <rosenp@gmail.com>
Date:   Mon, 5 Nov 2018 13:42:53 -0800
Message-ID: <CAKxU2N-Q=bGypr+1soXBXTeJuytGnmWmRn8589B822xyiH=hJw@mail.gmail.com>
Subject: Re: [PATCH 1/3] bitops: Fix big endian compilation
To:     nborisov@suse.com
Cc:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 5, 2018 at 1:31 PM Nikolay Borisov <nborisov@suse.com> wrote:
>
>
>
> On 5.11.18 =D0=B3. 21:06 =D1=87., Rosen Penev wrote:
> > Replaced bswap with _ variants. While it's a glibc extension, all of th=
e
> > popular libc implementations (glibc, uClibc, musl, BIONIC) seem to supp=
ort
> > it.
> >
> > Added static inline to two functions to match little endian variants. T=
his
> > fixes a linking error experienced when compiling.
>
> On what platform did you experience the linking error?
MIPS 24kc. OpenWrt specifically. Here's a link with the compile log
(near the end):
https://circleci.com/gh/openwrt/packages/77?utm_campaign=3Dworkflow-failed&=
utm_medium=3Demail&utm_source=3Dnotification

The LTO errors I believe are due to GCC 7.3.0 being broken (fixed in 7.3.1)=
.

This patch fixes both issues. I'm still unsure why bswap32 is not
being included but the _ variant works.
>
> >
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  kernel-lib/bitops.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel-lib/bitops.h b/kernel-lib/bitops.h
> > index b1fd6f5..2c51a26 100644
> > --- a/kernel-lib/bitops.h
> > +++ b/kernel-lib/bitops.h
> > @@ -178,9 +178,9 @@ static inline unsigned long find_next_zero_bit(cons=
t unsigned long *addr,
> >  static inline unsigned long ext2_swab(const unsigned long y)
> >  {
> >  #if BITS_PER_LONG =3D=3D 64
> > -     return (unsigned long) bswap64((u64) y);
> > +     return (unsigned long) bswap_64((u64) y);
> >  #elif BITS_PER_LONG =3D=3D 32
> > -     return (unsigned long) bswap32((u32) y);
> > +     return (unsigned long) bswap_32((u32) y);
> >  #else
> >  #error BITS_PER_LONG not defined
> >  #endif
> > @@ -218,14 +218,14 @@ static inline unsigned long _find_next_bit_le(con=
st unsigned long *addr1,
> >       return min(start + __ffs(ext2_swab(tmp)), nbits);
> >  }
> >
> > -unsigned long find_next_zero_bit_le(const void *addr, unsigned long si=
ze,
> > +static inline unsigned long find_next_zero_bit_le(const void *addr, un=
signed long size,
> >               unsigned long offset)
> >  {
> >       return _find_next_bit_le(addr, NULL, size, offset, ~0UL);
> >  }
> >
> >
> > -unsigned long find_next_bit_le(const void *addr, unsigned long size,
> > +static inline unsigned long find_next_bit_le(const void *addr, unsigne=
d long size,
> >               unsigned long offset)
> >  {
> >       return _find_next_bit_le(addr, NULL, size, offset, 0UL);
> >
