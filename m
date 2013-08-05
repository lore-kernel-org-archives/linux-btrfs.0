Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:38563 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3HEPoI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Aug 2013 11:44:08 -0400
Received: by mail-we0-f180.google.com with SMTP id p61so2656888wes.11
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Aug 2013 08:44:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ha33da-ecm.ln1@hurikhan77.spdns.de>
References: <pan$b7e2c$bf7f3666$af6e4a6$909b9d97@cox.net>
	<ha33da-ecm.ln1@hurikhan77.spdns.de>
Date: Mon, 5 Aug 2013 11:44:07 -0400
Message-ID: <CAPs0BihKckyqzX--bSaNs1JrzrvyEH33Ms_+1LRsSm=aB=4AoQ@mail.gmail.com>
Subject: Re: Recovery advice
From: Sandy McArthur <sandymac@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FYI: I ended up wipefs'ing the drive and adding it back in. I also has
to abort the residual balance process to get the filesystem back to a
state where I could add disk. I didn't realize this until after wiping
the drive. Maybe if I'd known to look for that I could have recovered
the drive before the wipe. Anyway, all seems fine now and I'm not mix
and matching connection types.

More History:
The filesystem came to a failed state during a balance just after
adding the problem disk. This disk also had been installed inside the
case on SATA instead of inside an external multi-drive enclosure. My
thoughts at the time (now known to be semi-faulty) were it would be
faster to push data into the disk that way. When the machine
hardlocked this one drive was different enough from the other 3 I
simply could not get btrfs to work with all four disks at once.


On Sun, Aug 4, 2013 at 7:05 PM, Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:
> Duncan <1i5t5.duncan@cox.net> schrieb:
>
>>> It is a RAID-1 so why bother with the faulty drive? Just wipe it, put it
>>> back in, then run a btrfs balance... There should be no data loss
>>> because all data is stored twice (two-way mirroring).
>>
>> The caveat would be if it didn't start as btrfs raid1, and there's still
>> some data (or possibly metadata if it was the single drive at one point
>> or they're ssds, as btrfs defaults to metadata single in ssd mode) that
>> hasn't been duped elsewhere.
>
> Oh... That's actually a pitfall... :-\
>
> Note to myself: Ensure balance has been run successfully and completely.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Sandy McArthur

"He who dares not offend cannot be honest."
- Thomas Paine
