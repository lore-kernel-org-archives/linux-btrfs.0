Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C077C282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 11:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48BF320870
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 11:25:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YltqinzV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfAWLZR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 06:25:17 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:39454 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbfAWLZR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 06:25:17 -0500
Received: by mail-oi1-f180.google.com with SMTP id i6so1486175oia.6
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 03:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j5IaJq2I1thEgUV1P7nh3qeR7I8uKr9Cz+NVtkUf29s=;
        b=YltqinzVG+nLon+DHyTGSL4mfSvZgcPJitN4XRG0mYE2qC1LL/uHNcA6hqG942OZSr
         T7aGlGGQIAzQDo1Tjsu+4S/8tTkFI85jKrEGTA+0Yyg2kl5oxr91O8wO82QENl3cGaMK
         0cFTE28ItUVaEZKXv/MEh+pflcNAHskzkJxhoK6TgbfzsOV83Tr4X3XQSQwbdE8eGtaf
         mC6AJcrV5bU2Rc3hBbFSlzZeifMjAFj5tnu8e+KR5Q+B2xGf4GSrPa/S9xuUjI92Vt89
         cMBvd3CvI8AaTwoOPikhGUhlukYJla5OZIzH3cNkDxUUIYV5SuLx8Jv7ta+Vp9uyB83/
         IXLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j5IaJq2I1thEgUV1P7nh3qeR7I8uKr9Cz+NVtkUf29s=;
        b=l/2Va/SzrtofcMLpYh3JOr8w5euQEwukP8yKleHY4p1xQ2w8q2XLYffd7stxQ6Bdii
         4zBM/3hLuP061QRKPnouxxuKaQHl9n88nv8Uh6E3VISar1khPFRIobLYn5lk4LBTcS1d
         c/bzGplTFWlywf+XoG3+tNtQmrAhSdQ1kfblfBX81pJ30Qh2F0wjYBKO2AdeWgs1y5Ym
         e8Xw60EUC6f8GvN+/DBYBK5UyRQzhw3EMj738u/Rsjp35BHB9Ntg1RyEHRHShgeNWiXv
         Muo6nwDTLO7M+suoUQ6jAcQq+hHt2n9lDQGUlu7IUbY71gA9cZxw4c6kpR/4LHZV3VIj
         +fUw==
X-Gm-Message-State: AJcUukdi4wYsnNJ1x8eAPuEsOBuqKtPF+dUuJuHsS6FjhD3aM04dRR4m
        2rcTw49Cpxnsjwt4DgWBqKeWGfoD1dKGTLSp+1DslyRf
X-Google-Smtp-Source: ALg8bN4JliMa94TuVLY8VbpnEdqam2pqPSKrFtB5pHD3g56jwj9Izr3qm/zEnkDepq3SoW8Q7HYFm8cIlzfkDgxpcKU=
X-Received: by 2002:aca:dd57:: with SMTP id u84mr1195729oig.216.1548242716364;
 Wed, 23 Jan 2019 03:25:16 -0800 (PST)
MIME-Version: 1.0
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com> <3cfb98e1-92d4-150c-445c-9357cec9adca@netspace.net.au>
In-Reply-To: <3cfb98e1-92d4-150c-445c-9357cec9adca@netspace.net.au>
From:   Andrei Borzenkov <arvidjaar@gmail.com>
Date:   Wed, 23 Jan 2019 14:25:03 +0300
Message-ID: <CAA91j0VSd=uC7ROT2+JsRszzAXWz+ti-Kf3hyw+aVS03sdn95g@mail.gmail.com>
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Dennis Katsonis <dennisk@netspace.net.au>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 23, 2019 at 1:45 PM Dennis Katsonis <dennisk@netspace.net.au> wrote:
> I think my previous e-mail did not go through.  Basically, if it is
> assumed that a btrfs-receive operation will result in a subvolume which
> matches the source file for file, then this assumption or expectation
> won't be met if one deletes files from the subvolume at the receiving
> end which is going to be referred to as the parent.
>

This is oxymoron. btrfs send/receive apply to read-only subvolumes.
You are not able to modify them. As soon as you remove read-only bit,
you are fully responsible for consequences.

> This can happen inadvertently,

It cannot. You do not inadvertently make subvolume read-write. And if
you do, you are expected to know what you are doing.

That said, better if btrfs did not allow flipping read-only bit in the
first place.

> or even through filesystem corruption
> (which I experienced).
>

And if corruption happened after applying changes? End result in the
same. Of course it would be perfect if btrfs could notice and warn
you, I just do not see how it can realistically be implemented.
