Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:52328 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754173AbeFTIex (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 04:34:53 -0400
Received: by mail-it0-f52.google.com with SMTP id m194-v6so4293567itg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 01:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAJH6TXhoL+HLEp8ioMMt06fvykEjM3Usq7OMAk9VwpcsfTBHpA@mail.gmail.com>
 <2a4b8e37-60c2-bb67-a646-fe61dfe1410f@dirtcellar.net>
In-Reply-To: <2a4b8e37-60c2-bb67-a646-fe61dfe1410f@dirtcellar.net>
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Wed, 20 Jun 2018 09:34:55 +0200
Message-ID: <CAJH6TXgmbvfimGU_bX-T4-0Yomz0YsJR3xsc_dFT5H5OZ6A4GA@mail.gmail.com>
Subject: Re: RAID56
To: waxhead@dirtcellar.net
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Il giorno mer 20 giu 2018 alle ore 02:06 waxhead
<waxhead@dirtcellar.net> ha scritto:
> First of all: I am not a BTRFS developer, but I follow the mailing list
> closely and I too have a particular interest in the "RAID"5/6 feature
> which realistically is probably about 3-4 years (if not more) in the future.

Ok.

[cut]

> Now keep in mind that this is just a humble users analysis of the
> situation based on whatever I have picked up from the mailing list which
> may or may not be entirely accurate so take it for what it is!

I wasn't aware of all of these "restrictions".
If this is true, now I understand why redhat lost interest in BTRFS.
3-4 years more for a "working" RAID56 is absolutely too much, in this case,
ZFS support for RAID-Z expansion/reduction (actively being worked on)
will be released
much earlier (probably, a test working-version later this year and a
stable version next year)

RAID-Z single disk espansion/removal is probably the real missing feature in ZFS
allowing it to be considered a general-purpose FS.

Device removal was added some months ago and now is possible (so, if
you add a single disk to a mirrored vdev,
you don't have to destroy the whole pool to remove the accidentally-added disk)

In 3-4 years, maybe oracle release ZFS as GPL-compatible (solaris is
dying, latest release is 3 years ago,
so there is no need to keep a FS opensource compatible only with a died OS)

Keep in mind that i'm not a ZFS-fan (honestly, I don't like it) but
with these 2 features added and tons of restriction in BTRFS,
there is no other choise.
