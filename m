Return-Path: <SRS0=C3Cz=O7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C772C43387
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Dec 2018 18:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCD332075B
	for <linux-btrfs@archiver.kernel.org>; Sat, 22 Dec 2018 18:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h0zzZuqD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390581AbeLVSMZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 22 Dec 2018 13:12:25 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:42547 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390291AbeLVSMZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Dec 2018 13:12:25 -0500
Received: by mail-oi1-f170.google.com with SMTP id w13so7349202oiw.9
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Dec 2018 10:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=IchfyUpO+R+9HxVDvhtNgfWA0xhhyzas4YQdCsQF7Ss=;
        b=h0zzZuqD2oFI6CtXLoJ7QfW7Wq2Nx5WcfCveyr2KqLEtsK46E/1DzilcWrzM0J134+
         QHL1FrIdZvojs9T6OsfoGNcx28XOBrSFmKcd/Y30TsqsEjbkxHmKncVNGV+mkHW6DQtg
         oba6fxAJ/DVnfl98iZI/FjNosRcQB3PLK+yc3D+B7fq8x0RIzNBEnGdkEwThF/dBR7nI
         F2xymXzn0Pq0HAIvIwO+GNNEws2K60PTU2NPmKJND8o0ZS/sssf/9A/vTXci+hHyoSJT
         nokZoXtl8ZnDP8gB9pNcwhaap7Oalo2R6tchwx9oj/vdA0DmexpEQrXp3W/1ugYz/m6p
         PS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=IchfyUpO+R+9HxVDvhtNgfWA0xhhyzas4YQdCsQF7Ss=;
        b=tgkZlvVDWAP57VFjWCM/hYrObopRvpUD7UX+Uqf4D7LcZpoaoljfPT0JsVdSMehuDi
         m002hd1EyLzrRciXF5IVNdYuI/bY+lmbkrQ1eSYyKS934WjjhXfwVzXpiRZS1FWCKJIP
         ObZa1jd7MMPi+aX1XOdliQ3KjG7ksmcvWy0pD9F4EfPZshwJbXIgUluS03wgTcq5aaie
         pt1ANcsmF1SQ6O0OVPfuTCuSM1rdSH4cqyhX/AkeS/9m5JIy9uu/5wsZWu1wWWULfk89
         dZEwiVSQFh8AzdSU3bjEl1Ok0MweY3VY0Oi+hMqWjVQFTfZ6ZI4HVGjEnNlZ2TNJb/n1
         4mvQ==
X-Gm-Message-State: AJcUukfa+WSN3OZQu4DpRE5NbZlqBnZ/20LQAzPv0xPCQcqnBceZXETC
        fsH14+h87si2VOJyzoJ1bNo1MZ5th/t0GV/NbsSU1Q==
X-Google-Smtp-Source: AFSGD/XJgY41W7AeRDRTHSqDDwSNIkK9HCkKXZIchHTWLPBKIc5B/Z2u/OLzbxNSjO7fEL3b2AmtY9bpfvMpBB7Q8tY=
X-Received: by 2002:aca:5406:: with SMTP id i6mr4541059oib.344.1545502343327;
 Sat, 22 Dec 2018 10:12:23 -0800 (PST)
MIME-Version: 1.0
References: <CAGDaZ_o0NYy4HXmE67u8HvH7Y7RwT6=GvPDrPtRbRdPzEEDHGA@mail.gmail.com>
 <20181222180438.GG30713@carfax.org.uk>
In-Reply-To: <20181222180438.GG30713@carfax.org.uk>
From:   Raymond Jennings <shentino@gmail.com>
Date:   Sat, 22 Dec 2018 10:11:47 -0800
Message-ID: <CAGDaZ_ozFr+2nz8oqaRAhVmyoan5uVocFqCS=rT778C8kTByJg@mail.gmail.com>
Subject: Re: Specifying block group size
To:     Hugo Mills <hugo@carfax.org.uk>,
        Raymond Jennings <shentino@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If the filesystem is later resized, does the (default?) chunk size
adjust accordingly?

On Sat, Dec 22, 2018 at 10:04 AM Hugo Mills <hugo@carfax.org.uk> wrote:
>
> On Fri, Dec 21, 2018 at 10:18:40PM -0800, Raymond Jennings wrote:
> > How do I specify the size of a block group at mkfs?
>
>    You don't -- there's no explicit control over it. The FS will
> decide based on the overall size of the filesystem in question.
>
>    Typically, data groups are made of 1 GiB chunks, and metadata
> groups are made of 256 MiB chunks (where the RAID level will determine
> the number of chunks in a group and the amount of usable space of the
> group).
>
>    Hugo.
>
> >
> > Like, for example, saying that data groups will be 1GiB, but metadata
> > groups will be 1MiB?
> >
> > I noticed that they had different default sizes based on the profile
> > (dup vs single vs raid)
>
> --
> Hugo Mills             | Beware geeks bearing GIFs
> hugo@... carfax.org.uk |
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |
