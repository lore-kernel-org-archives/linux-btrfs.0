Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89EA6C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 18:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B14621736
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 18:06:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="GeNECHLV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390915AbfBRSGk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 13:06:40 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:39948 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388802AbfBRSGk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 13:06:40 -0500
Received: by mail-lj1-f181.google.com with SMTP id w6so10364500ljd.7
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 10:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ERWMoMOs0k04b4emXyE8ZRXVZBJYYU2RYyeG2G9KQCc=;
        b=GeNECHLVhmDVfjlXrRWtEnjQ3Hf614T6gdWF2WhTSp9RIkCjEhGE/VXIFzUzdeljrI
         2tRbWwpCPzbJe7W5q+vOK7M6ruWeQ1CBQFzskhLPYeOcH+DMtl5b8ny9MPeyu5Jl5gZz
         +uaz1ghW1As8w1YWn2GLliThGgPy07y1xivKrMkDwe2vIN3PGN65tyKJOosEn3kbui8U
         9u5ACpVVVvqq0OMCTgssA/Q6l+Bb6gG7LZl2tyYCQbSUXAxyPnFrQxKR5T8f3cu45jIx
         bTU+kGossdbU78rx1HXZjR48y3jK4OwFRZW9lnO3vHdK2sDbxCf9q8fBSreT9JPslBk4
         SjKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ERWMoMOs0k04b4emXyE8ZRXVZBJYYU2RYyeG2G9KQCc=;
        b=gbhsHCmemenC0KrciQz1wZPYbWAFpGKar/PgWislA4iP8pV3KrDRl4hskD2bIpwVv9
         R0/o59RMsXnEbDG+NbdRIWYpCkGa/VkPh5AGCHUIE07zcMjeuq96MMcGYEWZe8cqiDaL
         CKyjxrFJ/ahEdQwKqOEOSFKCZ0irYl7b9GskglYlBykRW3zganH1Ta/BozvgZ2Gc2Bo5
         y6/27oaBT32AZqLynv/nZI0Hy+lhicjrWknoLA8SVnGDSk6e0jK8xyGP9RF2960ICHdE
         QcjpLpM/UeJq8IOkk26YywJMR/o/W1ID+103NW3omgfTsIbMOe9Dp2NemqaFcpV7DwwC
         dBYg==
X-Gm-Message-State: AHQUAuYsndZ7Pf8soxmGwda/qIlPfoAZ0St+Bg59VwM5rkEhx7VONY8+
        nHtR8uH4BKQBD2yUKVA3QP2RH6VJ4BkqrLx/2aZEAw==
X-Google-Smtp-Source: AHgI3IaY6RvgMjlcgOmO7toTZhz29HQEypB5I0rJDD1zlUW5gPGYjMY0uFOSalf8Jgaz37dQg+mCY7H+Q332E9j7WdY=
X-Received: by 2002:a2e:870c:: with SMTP id m12mr405379lji.24.1550513197460;
 Mon, 18 Feb 2019 10:06:37 -0800 (PST)
MIME-Version: 1.0
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com> <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
 <40efb627-911f-1cae-c3d2-f2353eaab99c@sheepa.org>
In-Reply-To: <40efb627-911f-1cae-c3d2-f2353eaab99c@sheepa.org>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 18 Feb 2019 11:06:25 -0700
Message-ID: <CAJCQCtSE++nn=mVEpKt3vgpnDXXnooD2zg6aUJ6DdkphVDHQkg@mail.gmail.com>
Subject: Re: Btrfs send with parent different size depending on source of files.
To:     =?UTF-8?Q?Andr=C3=A9_Malm?= <admin@sheepa.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 6:05 AM Andr=C3=A9 Malm <admin@sheepa.org> wrote:
>
> So the takeaway from this is that btrfs send doesn't work this way, I
> can't copy a file with reflink=3Dalways and expect it to be diffed
> correctly as in a parent-child situation or?

Sorry about the confusion, Andr=C3=A9. What you're doing isn't described or
explained in existing documentation: man page, wiki, or list archive,
it's only explained in this thread. So, all I can say is it's going to
take some testing on your part and possibly documentation and example
improvements, for this alternative usage.

At the moment, based on Andrei's explanation and example, what you're
trying to do is valid. He also explained why you're seeing different
results in send stream output in your dd vs wget example: it's the
files themselves not the application.

"The last extent is incomplete which causes btrfs to not attempt cloning."

--=20
Chris Murphy
