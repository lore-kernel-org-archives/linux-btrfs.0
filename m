Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:44405 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752254AbdLDFLi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 00:11:38 -0500
Received: by mail-oi0-f48.google.com with SMTP id l6so382690oih.11
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Dec 2017 21:11:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171203104630.2brvt2a3lkf5m3ag@angband.pl>
References: <20171201161555.GA11892@polanet.pl> <20171201213614.GE29898@carfax.org.uk>
 <20171202005338.GA20205@polanet.pl> <20171202162812.GA5324@polanet.pl>
 <20171202171819.GA4629@polanet.pl> <pan$4b81d$3ba1cf57$e9dd4e05$8cf6db12@cox.net>
 <20171203104630.2brvt2a3lkf5m3ag@angband.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 3 Dec 2017 22:11:36 -0700
Message-ID: <CAJCQCtQCeOW_HvuEO_v6AcBZ+9AqMWmkMbfNr8p7ZkCHsRjhaQ@mail.gmail.com>
Subject: Re: exclusive subvolume space missing
To: Adam Borowski <kilobyte@angband.pl>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 3, 2017 at 3:47 AM, Adam Borowski <kilobyte@angband.pl> wrote:

> I'd say that the only good use for nocow is "I wish I have placed this file
> on a non-btrfs, but it'd be too much hassle to repartition".
>
> If you snapshot nocow at all, you get the worst of both worlds.

I think it's better to have the option than not have it, but for
regular Joe user I think it's a problem. And that's why I'm not such a
big fan of systemd-journald using chattr +C on journals when on Btrfs,
by default. I wouldn't mind it if systemd also made /var/log/journal/
a subvolume, just like it automatically creates /var/lib/machines as
as subvolume. That way by default /var/log/journal would be immune to
snapshots.

Or alternatively a rework of how journals are written to be more COW friendly.


-- 
Chris Murphy
