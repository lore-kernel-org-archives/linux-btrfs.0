Return-Path: <SRS0=pm4w=3Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AE5C2D0DB
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jan 2020 13:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34A04214DB
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jan 2020 13:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IlmSYXOH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgA0NpD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Jan 2020 08:45:03 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:37493 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0NpD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Jan 2020 08:45:03 -0500
Received: by mail-vs1-f67.google.com with SMTP id x18so5636841vsq.4
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2020 05:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=b+tylgSdoGjsQgA5ebgXK596y6IwRE9XNkGXComfGsE=;
        b=IlmSYXOHry5f5NGzHdpvwZuCsrMinnTnHNXzubLx9OjpOl22OsLxjfII/dW15Pjcsn
         XTmdvsE+aeOVjAmMTvZJ2cyedEVTvxLuzUN1a7IJwI8JVprUiFYZf2oPjVtSjpiKgr0V
         gXZz0LaDObroZjIFYPl0Su5ifAL6WiaZoLC9Ux0dYnAsuIQ7J0elGbDlp1cV+ox06v/x
         5uzhJ9vGq1jFC+sPC+7P5fsPWueIXvD9jBBbtsQmtHENsUo5D6AbFweLd6APRajZsqWx
         VgZBLGm/jnsG6/pVBGdJ3utybJf0e7MB/+SUdU0P2cHtAYJFm/wQMM/0KogsxDodpH/A
         NJ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=b+tylgSdoGjsQgA5ebgXK596y6IwRE9XNkGXComfGsE=;
        b=cNgC/1KhZpZmDEFKddVhx0Qm3+BtnGX+UOoiL96BMgwk14qm5J7BXNnEBE2ZY57JVA
         RTgxqkIZuUvVYyTCTL/iLJJoZ4EjL+wdZkx39L4gYanmxBCPCSH2Wzfx6lykw2HCb2qZ
         slNakzQ6nL75oTFwiHgul5eu+r4YfsX3f3lZs6qNhX9DiCJ4idlbmpFSXwsAhEj9rRdz
         lfFxM4Fpuudcp+WfEi21a/klN5fDVdVbRh8X3IXR0GVQMs4IL87fhsUHAkdYkMVbUXyA
         G0xBV2ADU7O95Zz0WkDt6kALdE9B1RAdpaRVhyE40OEqrfF14Nt15YN6Qfr28Fnzt5Vy
         laHg==
X-Gm-Message-State: APjAAAWW8w340QrAY7hp9yf/vu8e/UiBl9wzD8QzYCekU6UOej/NywhO
        UznJyswObPlAhDP6drGPhJXi7eJpCFNU4LPrUa1UBFGr
X-Google-Smtp-Source: APXvYqxtwCtG0n4k8eNbgYoPqAgU+AmS79S2wa2wktUp0Wbn0XyyPwPabmWRnGPp/HRg57YS45bDy+nJbfAq9nFx1YU=
X-Received: by 2002:a67:af11:: with SMTP id v17mr8678728vsl.99.1580132702117;
 Mon, 27 Jan 2020 05:45:02 -0800 (PST)
MIME-Version: 1.0
References: <5ba0716449eb4f838699fc0b1fb5b024@integralblue.com>
 <20200113133741.GU3929@twin.jikos.cz> <7e7e4f63a89b6bb8a270d4c4ec676835@integralblue.com>
 <8254df450ca61dd4cbc455f19ee28c01@lesimple.fr>
In-Reply-To: <8254df450ca61dd4cbc455f19ee28c01@lesimple.fr>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 27 Jan 2020 13:44:50 +0000
Message-ID: <CAL3q7H4-3Mg2GUf2JMMFem77sSQR5opN9dxdvHz2kk1Qd=RD=A@mail.gmail.com>
Subject: Re: Regression in Linux 5.5.0-rc[1-5]: btrfs send/receive out of memory
To:     =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs2@lesimple.fr>
Cc:     Craig Andrews <candrews@integralblue.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Jan 25, 2020 at 11:18 AM St=C3=A9phane Lesimple
<stephane_btrfs2@lesimple.fr> wrote:
>
> > ERROR: failed to clone extents to var/amavis/db/__db.001: Invalid argum=
ent
>
> If I may add another data point here, I'm also encountering this issue on=
 a 5.5.0-rc6, with the btrfs-rc7 patches applied to it (so as far as btrfs =
is concerned, this is an rc7).
>
> On the first time, it happened after sending ~90 Gb worth of data, and ab=
orted (as I didn't specify the -E option to btrfs send). Then, I retried wi=
th btrfs send -E 0, and it encountered the exact same error on the same fil=
e.
>
> # btrfs send -v /tank/backups/.snaps/incoming/sendme/ | pv 2>/dev/pts/23 =
| btrfs rec -E 0 /newfs/
> At subvol /tank/backups/.snaps/incoming/sendme/
> At subvol sendme
> ERROR: failed to clone extents to retroarch/x86_64/cores/mednafen_saturn_=
libretro.dll: Invalid argument
> ERROR: failed to clone extents to retroarch/x86_64/cores/mednafen_saturn_=
libretro.dll: Invalid argument

This is probably the same case for which I sent a fix last week:

https://patchwork.kernel.org/patch/11350129/

Thanks.

>
> The send/receive is still going on for now, currently around the ~200 Gb =
mark.
>
> Bees is running on this FS (but I stopped it before doing the send/receiv=
e).
>
> I can test patches if needed.
>
> --
> St=C3=A9phane.



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
