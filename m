Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51025 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932717AbdJREoh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 00:44:37 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e4gDT-00084p-0J
        for linux-btrfs@vger.kernel.org; Wed, 18 Oct 2017 06:44:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
Date: Wed, 18 Oct 2017 04:44:11 +0000 (UTC)
Message-ID: <pan$32fc7$9a452de8$e1e1b163$51c88dc@cox.net>
References: <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
        <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
        <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
        <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com>
        <20171017011443.bupcsskm7joc73wb@angband.pl>
        <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
        <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
        <81e1136a-a846-9531-b1bf-9ad2aabb785d@gmail.com>
        <20171017170626.amfrohfyqlujdueu@angband.pl>
        <1d5e9875-1c1e-f67e-1f5b-0741555d9517@gmail.com>
        <20171017202135.xdop4eko6utircmz@angband.pl>
        <CAGtRCvdj6LXO8ou40u7B6KCKin6Wzh5FbayMX0-a9Y2fK_w8wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zoltán Ivánfi posted on Tue, 17 Oct 2017 23:56:56 +0200 as excerpted:

> I understand that due to the lack of a write intent bitmap, btrfs does
> not know what needs to be resynced exactly, therefore syncing the two
> copies of a raid1 can not happen as fast in btrfs as in md. However, I
> don't understand why converting from raid1 to single is so slow. After
> all, btrfs would just have to discard one copy of each chunk. Still, in
> practice, converting from raid1 to single is just as slow as converting
> from single to raid1.

Remember, each chunk "knows" its own type, and btrfs is COW, so changing 
the type of the remaining chunk requires rewriting it.  Thus, conversion 
from raid1 to single requires rewriting all chunks of the source type.  
Simply discarding the "extra" raid1 chunk won't cut it, because it'd 
still be raid1, not single.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

