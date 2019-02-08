Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B3DC169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 17:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3C5C20855
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 17:26:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="LBH8hQgm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfBHR0y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 12:26:54 -0500
Received: from mail-lj1-f170.google.com ([209.85.208.170]:44957 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfBHR0y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2019 12:26:54 -0500
Received: by mail-lj1-f170.google.com with SMTP id k19-v6so3625529lji.11
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2019 09:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dMeuiYm947p/Kn1knYKkyOIMkvcAYbaHTFo+m+HUdI8=;
        b=LBH8hQgmNmP+PvyrjQLCeeS1Fc/Z2UkVWHMBcQ057ssH0xlwr+c86IRU0866hRrwFx
         iQg4wSkkd/awkIoMVJpWOHAksaxD5XK/kVuvkSXDsRlCnqPYbYD7JwO4dXpneWHsNVz4
         5dMPqLs44dXTwJuCjF0L7UTer7EWZRTllX/wzG9hDIf7dbIabVvosoUzBGZXXnaUomN2
         2ejaddh/YsxMY3TWz2sL2RcHBg/OHPN1Vvgp3B22ez8ACjZyqrcpjXhubvWfc1a7KhkZ
         2TymCcf0mxEr/y8U6z8C57NZeuUXKze6CLRaSht+FacGM+k6GYhqn0+jNN03UjdDhjPn
         JGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=dMeuiYm947p/Kn1knYKkyOIMkvcAYbaHTFo+m+HUdI8=;
        b=m8lUuIImJRstwDz5OmhihQxgTJlfTRksnuOMXYhjh0BpxQb5tOUxJU3izh/FrTuzc+
         PSk1CgRT0oJwe7hdZcOUd1wDJ/ayGmT8/p0G6pdBVZeQ/YnsE3Oo2pHD0Q1IWIyFBSTH
         LgM0BF2S3ZQQ9nvMopZMAnqc6Q0V+WLce7v8HfEg2xIiQHH/KL4IK1FHD3F1dMMq5Bwi
         OUhWciATrQTbuWSnq/WtbiHG0/dQGA3wIz1WnyC6tggXeBDu/Q+K7imTKX4KhSmvt9IJ
         UqTwNfVM1Qg/ktFeJm+TXdO4DQ0PocIQHfPaXlAOUomxnc8tU2PDUafnnYm7DkdYvFp9
         isPQ==
X-Gm-Message-State: AHQUAuaUN3baVvgNx71Wqh8qtXS/RQeZ/VTlq57fbB9+MTO/GxMEDrVA
        lJX8rzoSEwFVHzzM7i+H8tCYpQJtiIllctHIIt1gv3vj
X-Google-Smtp-Source: AHgI3IYmxZZTzTLHJB5ZRXFCFPjEwd7SEmTDwNmIg1U/X7V6ZAVtHWY0F6CP0Ua9x/zUmRAtglkVLmu2GjimOjZ8a9A=
X-Received: by 2002:a2e:8719:: with SMTP id m25-v6mr15226072lji.121.1549646811469;
 Fri, 08 Feb 2019 09:26:51 -0800 (PST)
MIME-Version: 1.0
References: <33679024.u47WPbL97D@t460-skr> <2840929.O1qc6pvfHa@merkaba>
 <CAJCQCtR0RzjMPnTLP8V1mmKWGv2A+uYhe+FE4vmUB2odZki+OA@mail.gmail.com> <2369797.IGv3eFWPI5@t460-skr>
In-Reply-To: <2369797.IGv3eFWPI5@t460-skr>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 8 Feb 2019 10:26:39 -0700
Message-ID: <CAJCQCtSZGkyALMAyxHv=HB8yS_p7heDTFGWY-VGuU+0vX5WEiA@mail.gmail.com>
Subject: Re: btrfs as / filesystem in RAID1
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 8, 2019 at 12:33 AM Stefan K <shadow_7@gmx.net> wrote:
>
> > However the raid1 term only describes replication. It doesn't describe
> > any policy.
> yep you're right, but the most sysadmin expect some 'policies'.

A sysadmin expecting policies is fine, but assuming they exist makes
them a questionable sysadmin.

>> If I use RAID1 I expect that if one drive failed, I can still  boot _wit=
hout_ boot issues, just some warnings etc, because I use raid1 to have simp=
le 1device tolerance if one fails (which can happen).

OK and we've already explained that btrfs doesn't work that way yet,
which is why it has the defaults it has, but then you go on to assert
that Btrfs should have the defaults YOU want based on YOUR
assumptions. It's absurd.


>I can check/monitor the BTRFS RAID status by 'btrfs fi sh' or '(or by 'btr=
fs dev stat'). I also expect that if a device came back it will sync automa=
tically and if I replace a device it will automatically rebalance the raid1=
 (which btrfs does, so far). I think a lot of sysadmins feel the same way.

OK what you just wrote there is sufficiently incomplete that it's
wrong. I and others have already described part of this behavior so if
you were really comprehending what people are saying, you wouldn't
have just written the above paragraph.

If a missing device reappears, it is not synced automatically.

If you have a two device raid1 with a missing device, and mounted
degraded, data is highly likely to get written to the single remaining
drive as single profile chunks; which means when you do either 'btrfs
replace' or 'btrfs device add' followed by 'btrfs device remove' the
data in those single chunks will *not* be replicated automatically to
the replacement drive. You will have to do a manual balance and
explicitly convert single chunks to raid1. If it's 3+ drives, a device
replacement (of either method) should cause data to be replicated.

I see a lot of sysadmins make the wrong assumptions on the linux-raid
list and on LVM list, and I often read about data loss when they do
that. What matters is how things actually work. When you make
assumptions about how they work, you're unwittingly begging for user
induced data loss, and all the complaining about missing features
won't help get the data back. Over and over again telling people, you
didn't understand how it worked, you didn't understand what you were
doing, and yeah sorry the data is just gone. It's your responsibility
to understand how things really work and fail. It isn't possible for
the code to understand your expectations and act accordingly.

At least you're discovering the limitations before you end up in
trouble. The job of a sysadmin is to find out the difference between
expectations and actual feature set, because maybe the technology
being evaluated isn't a good match for the use case.


--=20
Chris Murphy
