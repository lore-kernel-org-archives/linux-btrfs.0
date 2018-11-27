Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31B4C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7171620663
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 19:09:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GYaedzzb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7171620663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbeK1GIB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 01:08:01 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:33500 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbeK1GIB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 01:08:01 -0500
Received: by mail-io1-f67.google.com with SMTP id t24so12154768ioi.0
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 11:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YWSXmQY18H1D+iG8FlIdpXVQgFa8DnCQmg7f8T0wE2w=;
        b=GYaedzzbXVzCF2JH1iufWiYfgVHmVc9qxaeN0lORm6de+rkO2dYjCZdTWs0ewL4y6Z
         DzJ57kyt81SZ8/5aZw++65HJ3VOoHIWNayhM7EZpHjfruQK7/3wT5/DrsJTZFjpoQidN
         g2RZT2z3B9GW7WH6XfyvC3GO5batj25jEbUhlg+Li6B5LrH9Xp47NawDYldSM9NHUUSm
         uXweOuBKV1YujvYeR2akr/eprb6Az97pz4D7BG5YmO9dVPcoVVlkgV8ZyodZvyTdLZ9J
         4ueO7xKvI6K66sAomihOc9K4IjzWyGOEd1oJ5CbO6BFIwLMj0AS9WF83smklopsC49TC
         HQCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YWSXmQY18H1D+iG8FlIdpXVQgFa8DnCQmg7f8T0wE2w=;
        b=P4tOy0eGxDMUJIDEfUcdc2LolWqP1c9jxwaVoij1SC03ICynNgxaoWzhxZ4Hpfgm6R
         9FOp2VN9Z4FAmtYYi7lKgI0bFxpp64s8ZP4mzx15gM2or3FOyNYXUU5TROeutVyUxBtQ
         iU7875f3W8aeiW8tL4vi2HIioOu1+PRJGO6CKmQJcHpzafaErCIzK1lF2VAyfeEsSATS
         dpRDeV0i7g5xHHT/6N2GoIWEuhEjk0SivNLG4ND4TJSgkthx4aUDnRMKVSrTpl5ocjqz
         ul5Mv+lr7psWPWN5qvHiS7Ag0+mdUSQX4y3jTzSyM1cAGUHLa3h9vVzdKITbjqPpAozy
         WI2A==
X-Gm-Message-State: AA+aEWaFJ+UFbfwsL/MNLAKgr/chsdXrbtWjGytCxhUj41uGjs5uo3Zq
        some1shaa/dUS8OOgaKKX7nRLpoDRScaFvaAsX8=
X-Google-Smtp-Source: AFSGD/Wk9aSu3GzvuMPrFx6RZYdvwcvwYKrgX74LATzlUDNsAHlIwmrZO7T5UJ8XAfveSSmL43SThHr6imNlvabbj5s=
X-Received: by 2002:a6b:5d01:: with SMTP id r1mr24740419iob.170.1543345748691;
 Tue, 27 Nov 2018 11:09:08 -0800 (PST)
MIME-Version: 1.0
References: <20181127160010.18123-1-jthumshirn@suse.de> <20181127160010.18123-4-jthumshirn@suse.de>
 <9cc979bd-167f-fd92-1308-ebb1ca85bc99@suse.com>
In-Reply-To: <9cc979bd-167f-fd92-1308-ebb1ca85bc99@suse.com>
From:   Noah Massey <noah.massey@gmail.com>
Date:   Tue, 27 Nov 2018 14:08:32 -0500
Message-ID: <CADfjVrgC+hd1c_FO_oT5os9H4nacdtq9+a3gXqRmw00sMTmGjQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] btrfs: document extent mapping assumptions in checksum
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     jthumshirn@suse.de, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 11:43 AM Nikolay Borisov <nborisov@suse.com> wrote:
>
> On 27.11.18 =D0=B3. 18:00 =D1=87., Johannes Thumshirn wrote:
> > Document why map_private_extent_buffer() cannot return '1' (i.e. the ma=
p
> > spans two pages) for the csum_tree_block() case.
> >
> > The current algorithm for detecting a page boundary crossing in
> > map_private_extent_buffer() will return a '1' *IFF* the product of the
>
> I think the word product must be replaced with 'sum', since product
> implies multiplication :)
>

doesn't 'sum' imply addition? How about 'output'?

> > extent buffer's offset in the page + the offset passed in by
> > csum_tree_block() and the minimal length passed in by csum_tree_block()=
 - 1
> > are bigger than PAGE_SIZE.
> >
> > We always pass BTRFS_CSUM_SIZE (32) as offset and a minimal length of 3=
2
> > and the current extent buffer allocator always guarantees page aligned
> > extends, so the above condition can't be true.
> >
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>
> With that wording changed:
>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>
> > ---
> >  fs/btrfs/disk-io.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 4bc270ef29b4..14d355d0cb7a 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -279,6 +279,12 @@ static int csum_tree_block(struct btrfs_fs_info *f=
s_info,
> >
> >       len =3D buf->len - offset;
> >       while (len > 0) {
> > +             /*
> > +              * Note: we don't need to check for the err =3D=3D 1 case=
 here, as
> > +              * with the given combination of 'start =3D BTRFS_CSUM_SI=
ZE (32)'
> > +              * and 'min_len =3D 32' and the currently implemented map=
ping
> > +              * algorithm we cannot cross a page boundary.
> > +              */
> >               err =3D map_private_extent_buffer(buf, offset, 32,
> >                                       &kaddr, &map_start, &map_len);
> >               if (err)
> >
