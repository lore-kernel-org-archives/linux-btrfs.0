Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:54683 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaDHTlU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 15:41:20 -0400
Received: by mail-ve0-f174.google.com with SMTP id oz11so1215327veb.33
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 12:41:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$73f63$4e264a95$61f7c205$43e12487@cox.net>
References: <CAFvQSYSSt_FneFeFUXYK65toiS6MSVGy_pmXd3RUuy=vam-Xsg@mail.gmail.com>
	<pan$73f63$4e264a95$61f7c205$43e12487@cox.net>
Date: Tue, 8 Apr 2014 21:41:19 +0200
Message-ID: <CAFvQSYSZe5JMe7D3OXbwPW=aJrz5yV_ndNUHDsXg9-iK3KE8Tg@mail.gmail.com>
Subject: Re: Is there any way to determine fragmentation for compressed btrfs volumes?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Ducan,

> You mention trying scrub and defragging the entire volume, but you don't
> mention balance.  Balance by default rewrites all chunks (tho you can add
> filters to rewrite only say data chunks, not metadata, if you like), so
> that's what I'd say to try, as it should defrag in the process.
>
> Tho we've seen a few reports from people saying a full balance actually
> made for instance boot times longer instead of shorter, too.  I haven't
> seen and don't have an explanation for that. <shrug>

Ah sorry, I confused scrub with balance.
I didn't do a scrub but actually I tried to balance the device as I
was told basically all data has to go through the allocator again
which most likely will improve on-disk layout. Unfourtunatly in my
case it made the situation a lot worse, when running this Linux system
in virtualbox (where disk access has a lot more overhead) it is now
even with the SSD super slow.


> Meanwhile, have you tried a trim/discard (fstrim command), and/or do you
> run with the discard (or is it trim) mount option?
I have tried with discard on and off - however this isn't a SSD issue.

It is slow even for read-only workload, and windows on the same SSD
works as expected (with CrystalDiskMark showing the dirve meets the
specs (~350mb/s seq. write, 500b/s sequential read, good 4k random
values).
So I doubt this is an SSD issue.


> One more thing to consider.  The btrfs of a year and a half ago was a
> rather less mature btrfs than we have today.  I recently booted to backup
> here, and did a brand new mkfs.btrfs on my working filesystems to take
> advantage of several of the newer features

I had hopes I could avoid that.
Having a FS in such a degraded state with the only option to re-create
it isn't that compelling ;)

Thanks & regards, Clemens
