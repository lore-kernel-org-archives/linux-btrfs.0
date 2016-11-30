Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36375 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752395AbcK3QfD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 11:35:03 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Wilson Meier <wilson.meier@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Convert from RAID 5 to 10
Date: Wed, 30 Nov 2016 17:35:00 +0100
Message-ID: <3704790.nMdNB9Lobq@merkaba>
In-Reply-To: <e9a4cba5-53b7-b6f0-af83-467f5f95f5b8@googlemail.com>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de> <19671a71-5d1c-c42e-db3d-c870ec08b2ff@gmail.com> <e9a4cba5-53b7-b6f0-af83-467f5f95f5b8@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 30. November 2016, 16:49:59 CET schrieb Wilson Meier:
> Am 30/11/16 um 15:37 schrieb Austin S. Hemmelgarn:
> > On 2016-11-30 08:12, Wilson Meier wrote:
> >> Am 30/11/16 um 11:41 schrieb Duncan:
> >>> Wilson Meier posted on Wed, 30 Nov 2016 09:35:36 +0100 as excerpted:
> >>>> Am 30/11/16 um 09:06 schrieb Martin Steigerwald:
> >>>>> Am Mittwoch, 30. November 2016, 10:38:08 CET schrieb Roman Mamedov:
[…]
> >> It is really disappointing to not have this information in the wiki
> >> itself. This would have saved me, and i'm quite sure others too, a lot
> >> of time.
> >> Sorry for being a bit frustrated.
> 
> I'm not angry or something like that :) .
> I just would like to have the possibility to read such information about
> the storage i put my personal data (> 3 TB) on its official wiki.

Anyone can get an account on the wiki and add notes there, so feel free.

You can even use footnotes or something like that. Maybe it would be good to 
add a paragraph there that features are related to one another, so while BTRFS 
RAID 1 for example might be quite okay, it depends on features that are still 
flaky.

I for myself rely quite much on BTRFS RAID 1 with lzo compression and it seems 
to work okay for me.

-- 
Martin
