Return-Path: <SRS0=CP9i=S5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018FEC43219
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Apr 2019 11:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C23902087C
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Apr 2019 11:25:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DynwJvfp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfD0LZo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 27 Apr 2019 07:25:44 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:33549 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfD0LZo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Apr 2019 07:25:44 -0400
Received: by mail-ot1-f45.google.com with SMTP id s11so542458otp.0
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Apr 2019 04:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9U1vsWUiNo6MeOMYbXPJijU0G6YBnuONBkHdxrmrtf8=;
        b=DynwJvfpCvtXsz8J1+BiN0cZp00DbKO/Mza/5dHN2QrS7LVQSriH9X9tJZRiHPwGGz
         UJorW7qlpbvSVNBrA9Ztet7G7r+XKB6vrgnZQ+OEqdhuuzQa4P2dKALXBmmYSU6nmdd1
         Ym9Cag5NXr0gD22MOU5eLa9quIM/aK/iSVgS61LmLGjVNVTaZBBYqti/+dJXfEnnZtSB
         F2n6vcrvtRM37XW4JVvebejkKmYcPhtPJWzn4yrJT0pCZXYPPyvqRAQpC7XM2k/sHthU
         bTAaAxXOqy0QhzaDdbFRUzV8ZRlOLEVbquOEUjZTcyJYKcXJCLbGjjFC1SDnz4IHX8gb
         1Ynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9U1vsWUiNo6MeOMYbXPJijU0G6YBnuONBkHdxrmrtf8=;
        b=cc0oKTJLxg6lYHpdUxDkZSfpr5u4meaYahJ5Ja2KAEpVnnnw0Dwet2YNM/+VOLDS1P
         RjeVt/8Nu//E/yvKPQFAQqATUqiIfWRhLxGquKbJvuor/otF0cmlo/XyB5V2Z1BOLS/y
         v8hrydDpiKUsV/9hX7Xr9LD0/d5o21XfvHaIHgc73USCgIgjUyAxMuPAICXLAfFxFBGz
         e5ifJ3SvTY7OAPLPFjogfN3DzHEeeJSZIYahLnsgdrFBgVvCKdSUi5HxA/64cDp0OECP
         /IdFf9S86rm7FgyGbgpUkKOGmktJ1z31oj028tqrjJia70YjLo8td2v4vvM6iPT/t0Ji
         WjUQ==
X-Gm-Message-State: APjAAAUnVIWxAeJ4gBlex4Sn40ZgGVaC+2iVYqwQxuveZiMFMCxkIfII
        C4m0b0LPnn80i05ZT7nIp+zLiqJQkcXkjuFHQT0=
X-Google-Smtp-Source: APXvYqzoLYp/IY5zLCxQf5WNbtD2SG/cYgcFA/cWaRMwKMBVodghyXcaxo3UTBejgZFr4M2qOvVUr9n0ctKvOgQTewk=
X-Received: by 2002:a9d:19cd:: with SMTP id k71mr30380706otk.267.1556364343716;
 Sat, 27 Apr 2019 04:25:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com> <20190423113302.GS20156@twin.jikos.cz>
 <a82d7cdb-206e-d141-e53b-4836b4b150de@gmx.com> <CAL3q7H7dzVQFRcTzBNNhCU69i5Yi4xStT14XjRw_vivH6QWnRw@mail.gmail.com>
 <CAPv9ZmkZM5E=ZyQ=dsovkrmuAYxLZ=80AjimV4cXyR1RCNqbpw@mail.gmail.com> <20190423235621.GC11530@hungrycats.org>
In-Reply-To: <20190423235621.GC11530@hungrycats.org>
From:   Jakob Unterwurzacher <jakobunt@gmail.com>
Date:   Sat, 27 Apr 2019 13:25:32 +0200
Message-ID: <CAPv9Zm=48nKaYmGdte-v8802x+p82Gat6h2R3DKa1g3vFcSBxg@mail.gmail.com>
Subject: Re: fallocate does not prevent ENOSPC on write
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     fdmanana@gmail.com, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 24, 2019 at 1:56 AM Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
>
> 132096 is 129 * 1024, which is not a multiple of 4K.  There will be a CoW
> operation in cases where one 4K block from each pwrite is written twice
> in separate transactions (or with fsync between).

Yes, the writes have odd sizes. This is unfortunate, but it's due to
gocryptfs' encryption overhead.

> fallocate is only going to behave the way posix_fallocate specifies on
> files with datacow turned off.

I see. Thank you!
Jakob
