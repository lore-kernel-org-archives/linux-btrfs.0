Return-Path: <SRS0=kwY/=SZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 901EBC10F03
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 19:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57C5D217D9
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Apr 2019 19:21:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="igQbEbvz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfDWTVW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Apr 2019 15:21:22 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35507 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfDWTVW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Apr 2019 15:21:22 -0400
Received: by mail-oi1-f194.google.com with SMTP id j132so12267899oib.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Apr 2019 12:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=foM6lnWkBU89oJoyX26AaLtm2HFIFFNZelrRGFmV1PM=;
        b=igQbEbvzK6IeBwdS7ZDjatmUiEUNovOPnnYDdTFA0vmp60+RRE8J0F15Mc8wmKbqyo
         0cBkIOVo9wWjX21wmz8OI2vnIAh7wezXINgtz0s2C5c6dsnSBeFos6aAM16pIgrozK6/
         LcCzD2jGhEri59+Z/7b+MhkMmhnMf+gP28BqdcUMBey7Zk1ojvxv6wphNI8o69aKbK4M
         qWpEgW6YbUTsqkozYCCXiadXCwr7DlGFnVz5bSC/CpAHM7sEUp6Dy+vlPWVjTxCrQXtc
         IJOlRPXDWGGG+zQ5BykEHpYu7xs2DP1JNhV53YP5pfZ02Ul7P9ic2gW6OnQNiSiqsCx/
         1lUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=foM6lnWkBU89oJoyX26AaLtm2HFIFFNZelrRGFmV1PM=;
        b=IutWJC5pXrxoA2cOrPG47vXJz5TGS7CHjdbygeM9aQ2nYz6SCMjpkoJ3Hp5jlgffqA
         9UBar18jsiphvQlLOfSWokKntGuUNF3K9MX30dYMcwCYn3jziV+ZOBHD2D/SR64IYQ4C
         ONOgGIgkr3Y95S4ZN0tlNAkKhM7yFz4+MwNje9IvkSx+PFOrnr4RHXI2O4JoLwzrlIzm
         xKRJ7JGsXU1wWUZ+ZMdQiPN3fdv98/FU5NpLa0nW4idNhJ8alpu19LQU2+/9EnIEnAUu
         Bn2KPSAWc/t7l/SCGM1uB9oWL9Fu5a/fGcbYkr3SvO7XNjk/5kvRAfb8OmEf8a9MgB5R
         yBYQ==
X-Gm-Message-State: APjAAAUTgGzPF9xp9RFzGTJaM5yb9iYm0PMirKAEl9yJ9HR7OAVA2t5r
        l0I9o3IlBLMSofRhaqZ8v0STth59vRekKc2FPig=
X-Google-Smtp-Source: APXvYqwjKr7RbSSm679tWnbO6tbJSDukXFxAHtsPgsBu9hSdslbdeo+XWnTeubEH0FYMwgPsiPMa3QoSGKuu7R/NDtg=
X-Received: by 2002:aca:fdd6:: with SMTP id b205mr2962590oii.131.1556047281015;
 Tue, 23 Apr 2019 12:21:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com> <20190423113302.GS20156@twin.jikos.cz>
 <a82d7cdb-206e-d141-e53b-4836b4b150de@gmx.com> <CAL3q7H7dzVQFRcTzBNNhCU69i5Yi4xStT14XjRw_vivH6QWnRw@mail.gmail.com>
In-Reply-To: <CAL3q7H7dzVQFRcTzBNNhCU69i5Yi4xStT14XjRw_vivH6QWnRw@mail.gmail.com>
From:   Jakob Unterwurzacher <jakobunt@gmail.com>
Date:   Tue, 23 Apr 2019 21:21:09 +0200
Message-ID: <CAPv9ZmkZM5E=ZyQ=dsovkrmuAYxLZ=80AjimV4cXyR1RCNqbpw@mail.gmail.com>
Subject: Re: fallocate does not prevent ENOSPC on write
To:     fdmanana@gmail.com
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> Trying the reproducer, at least on a 5.0 kernel, does never fail on a
> pwrite for me, but always on fallocate:
[...]
> So either that was tested on a rather old kernel or:
>
> 1) we had snapshotting happening between a fallocate and a pwrite (or
> at the same time as the pwrite)
> 2) before the pwrite (or during) the unwritten/prealloc extent was
> reflinked (cp --reflink, clone or dedupe ioctls)

I am at Linux 5.0.4-200.fc29.x86_64, the user in the github ticket is
at Linux 5.0.7-arch1-1-ARCH, so pretty recent.
There should be no snapshot or reflink or really any other activity on
the test filesystem.

Maybe the difference is that I am testing on a file and you on a raw
block device?
This is how things look at 4GB size:

$ dd if=/dev/zero of=img bs=1M count=5000
$ mkfs.btrfs -f -b $((4 * 1024 * 1024 * 1024)) img
$ mkdir mnt
$ sudo mount img mnt
$ sudo chmod 777 mnt
$ cd mnt
$ ../fallocate_write/fallocate_write
reading from /dev/urandom
writing to ./blob.qEaSZl
writing blocks of 132096 bytes each
total    125 MiB, 162.06 MiB/s
total    251 MiB, 162.92 MiB/s
pwrite failed: No space left on device

Is your /dev/sdi an SSD? I noticed that mkfs.btrfs does NOT think that
the disk image file is an SSD,
despite the file residing on an SSD.

Thanks,
Jakob
