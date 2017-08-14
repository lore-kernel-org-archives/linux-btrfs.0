Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:36660 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbdHNVLA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 17:11:00 -0400
Received: by mail-vk0-f50.google.com with SMTP id u133so35487695vke.3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 14:11:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <23b09099-7cb5-82fe-c941-4701136f952e@inwind.it>
References: <5d703b4c-e8ac-21dc-e327-ff1d8e232ee9@inwind.it>
 <CAJCQCtToFj4BowawgYPT-GiUnZPAXsjtuZO2=imcoyOZmaQzug@mail.gmail.com>
 <e4506812-53a8-7a95-61e6-279af20c8303@inwind.it> <CAJCQCtTTgdyfMzZKGqMo+LyA2dW+Csq+xp6TqoGyqEmsQ-j8eQ@mail.gmail.com>
 <23b09099-7cb5-82fe-c941-4701136f952e@inwind.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 14 Aug 2017 15:10:59 -0600
Message-ID: <CAJCQCtR_pEg_dGitVRzaq-GfhzYj4-UCbNxNv-sQ2K_gpAfmSA@mail.gmail.com>
Subject: Re: [RFC] Checksum of the parity
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 14, 2017 at 2:18 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:

>> Anyway, I do wish I read the code better, so I knew exactly where, if
>> at all, the RMW code was happening on disk rather than just in memory.
>> There very clearly is RMW in memory code as a performanc optimizer,
>> before a stripe gets written out it's possible to RMW it to add in
>> more changes or new files, that way raid56 isn't dog slow CoW'ing
>> literally a handful of 16KiB leaves each time, that then translate
>> into a minimum of 384K of writes.
>
> In case of a fully stripe write, there is no RMW cycle, so no "write hole".

That is conflating disk writes and in-memory RMW. They have to be
separated. For sure there's in-memory RMW + CoW of the entire stripe
to disk, for a tiny (1 byte) change to a file because I've seen it.
What I don't know, and can't tell from the code, is if there's ever
such a thing as partial stripe RMW (and over write of just a data
strip and a corresponding over write for parity). Any overwrite is
where the write hole comes into play.

But inferring from the work Liu is apparently working on for a
journal, it must be true that there is such a thing as a overwrites
with Btrfs raid56.



>
> Just of curiosity, what is "minimum of 384k" ? In a 3 disks raid5 case, the minimum data is 64k * 2 (+ 64kb of parity).....

Bad addition on my part.


-- 
Chris Murphy
