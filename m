Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:35893 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751912AbdFKXAP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Jun 2017 19:00:15 -0400
Received: by mail-wr0-f180.google.com with SMTP id v111so78860633wrc.3
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Jun 2017 16:00:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F505EB30-01E7-47EB-8850-EC5D6AA82D4E@dominion.thruhere.net>
References: <oherub$g5a$1@blaine.gmane.org> <20170609195718.GC30723@carfax.org.uk>
 <CAJCQCtRdinWhYvNB8dVXGREhnaspYaSu8vbbNRsN4DjyTJw6GA@mail.gmail.com>
 <6BE7B702-122D-406B-B8D5-9DFAB78BA587@dominion.thruhere.net> <F505EB30-01E7-47EB-8850-EC5D6AA82D4E@dominion.thruhere.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 11 Jun 2017 17:00:13 -0600
Message-ID: <CAJCQCtQj1-0Nxm9cp16gjjROq7yhU1-sThOEcTR4gwcWRRhLmA@mail.gmail.com>
Subject: Re: Filesystem won't mount (open_ctree failed) or repair (BUG_ON)
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 11, 2017 at 4:13 AM, Koen Kooi <koen@dominion.thruhere.net> wrote:
>
>> Op 11 jun. 2017, om 12:05 heeft Koen Kooi <koen@dominion.thruhere.net> het volgende geschreven:
>>
>>>
>>> Op 11 jun. 2017, om 06:20 heeft Chris Murphy <lists@colorremedies.com> het volgende geschreven:
>>>
>>> On Fri, Jun 9, 2017 at 1:57 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>
> [..]
>
>>> I'd say take a btrfs-image and put it up somewhere and also file a
>>> bug. The fsck should not crash.
>>
>> I’ll create a bugzilla account and file a bug for that.
>
> Done: https://bugzilla.kernel.org/show_bug.cgi?id=196031
>
> Btrfs-image is still running, will put it online when it has finished. It’s already 1.2G:
>
> koen@beast:~$ du -ms /data/backup/btrfs.img
> 1205    /data/backup/btrfs.img

Hopefully you're using -s -t4 -c9 but if not you can at least compress
it after the fact but that takes even longer.



-- 
Chris Murphy
