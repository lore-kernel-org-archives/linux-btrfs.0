Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56562 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752119AbdFLGfc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 02:35:32 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dKIwe-0004or-UP
        for linux-btrfs@vger.kernel.org; Mon, 12 Jun 2017 08:35:24 +0200
To: linux-btrfs@vger.kernel.org
From: Koen Kooi <koen@dominion.thruhere.net>
Subject: Re: Filesystem won't mount (open_ctree failed) or repair (BUG_ON)
Date: Mon, 12 Jun 2017 08:35:23 +0200
Message-ID: <ohlcn5$gm5$1@blaine.gmane.org>
References: <oherub$g5a$1@blaine.gmane.org>
 <20170609195718.GC30723@carfax.org.uk>
 <CAJCQCtRdinWhYvNB8dVXGREhnaspYaSu8vbbNRsN4DjyTJw6GA@mail.gmail.com>
 <6BE7B702-122D-406B-B8D5-9DFAB78BA587@dominion.thruhere.net>
 <F505EB30-01E7-47EB-8850-EC5D6AA82D4E@dominion.thruhere.net>
 <CAJCQCtQj1-0Nxm9cp16gjjROq7yhU1-sThOEcTR4gwcWRRhLmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtQj1-0Nxm9cp16gjjROq7yhU1-sThOEcTR4gwcWRRhLmA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Op 12-06-17 om 01:00 schreef Chris Murphy:
> On Sun, Jun 11, 2017 at 4:13 AM, Koen Kooi <koen@dominion.thruhere.net> wrote:
>>
>>> Op 11 jun. 2017, om 12:05 heeft Koen Kooi <koen@dominion.thruhere.net> het volgende geschreven:
>>>
>>>>
>>>> Op 11 jun. 2017, om 06:20 heeft Chris Murphy <lists@colorremedies.com> het volgende geschreven:
>>>>
>>>> On Fri, Jun 9, 2017 at 1:57 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>
>> [..]
>>
>>>> I'd say take a btrfs-image and put it up somewhere and also file a
>>>> bug. The fsck should not crash.
>>>
>>> I’ll create a bugzilla account and file a bug for that.
>>
>> Done: https://bugzilla.kernel.org/show_bug.cgi?id=196031
>>
>> Btrfs-image is still running, will put it online when it has finished. It’s already 1.2G:
>>
>> koen@beast:~$ du -ms /data/backup/btrfs.img
>> 1205    /data/backup/btrfs.img
> 
> Hopefully you're using -s -t4 -c9 but if not you can at least compress
> it after the fact but that takes even longer.

I wasn't using '-s', after I did it and ran it again it shrunk from 14GiB to 733MiB:

	https://dominion.thruhere.net/btrfs.img

xz -9 -e wouldn't only compressed that 14GiB file to 13.99GiB, so I wonder why '-s' seems to make such a difference.

regards,

Koen


