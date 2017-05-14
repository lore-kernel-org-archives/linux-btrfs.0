Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:39566 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754032AbdENUr1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 16:47:27 -0400
Subject: Re: Btrfs/SSD (my -o ssd "summary")
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
 <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
 <20170512202756.16bd785f@jupiter.sol.kaishome.de>
 <pan$3384$13ad2b1f$3febf76a$c09fcbd7@cox.net>
 <CAJCQCtQnM21-JPs+6+YeykTj-s1J43E8rNCkHHyk+AjvzZEddg@mail.gmail.com>
 <250FCE39-0DAE-4AF2-B378-E56BE044F2E7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <55e9bcf4-40e8-5961-d3db-606534e468f7@mendix.com>
Date: Sun, 14 May 2017 22:47:23 +0200
MIME-Version: 1.0
In-Reply-To: <250FCE39-0DAE-4AF2-B378-E56BE044F2E7@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/14/2017 08:01 PM, Tomasz Kusmierz wrote:
> All stuff that Chris wrote holds true, I just wanted to add flash
> specific information (from my experience of writing low level code
> for operating flash)

Thanks!

> [... erase ...]

> In terms of over provisioning of SSD it’s a give and take
> relationship … on good drive there is enough over provisioning to
> allow a normal operation on systems without TRIM … now if you would
> use a 1TB drive daily without TRIM and have only 30GB stored on it
> you will have fantastic performance but if you will want to store
> 500GB at roughly 200GB you will hit a brick wall and you writes will
> slow dow to megabytes / s … this is symptom of drive running out of
> over provisioning space … if you would run OS that issues trim, this
> problem would not exist since drive would know that whole 970GB of
> space is free and it would be pre-emptively erased days before.

== ssd_spread ==

The worst case behaviour is the btrfs ssd_spread mount option in
combination with not having discard enabled. It has a side effect of
minimizing the reuse of free space previously written in.

== ssd ==

[And, since I didn't write a "summary post" about this issue yet, here
is my version of it:]

The default mount options you get for an ssd ('ssd' mode enabled,
'discard' not enabled), in combination with writing and deleting many
files that are not too big also causes this pattern, ending up with the
physical address space fully allocated and written to.

My favourite videos about this: *)

ssd (write pattern is small increments in /var/log/mail.log, a mail
spool on /var/spool/postfix (lots of file adds and deletes), and mailman
archives with a lot of little files):

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-01-19-noautodefrag-ichiban.mp4

*) The picture uses Hilbert Curve ordering (see link below) and shows
the four last created DATA block groups appended together. (so a new
chunk allocation pushes the others back in the picture).
https://github.com/knorrie/btrfs-heatmap/blob/master/doc/curves.md

 * What the ssd mode does, is simply setting a lower boundary to the
size of free space fragments that are reused.
 * In combination with always trying to walk forward inside a block
group, not looking back at freed up space, it fills up with a shotgun
blast pattern when you do writes and deletes all the time.
 * When a write comes in that is bigger than any free space part left
behind, a new chunk gets allocated, and the bad pattern continues in there.
 * Because it keeps allocating more and more new chunks, and keeps
circling around in the latest one, until a big write is done, it leaves
mostly empty ones behind.
 * Without 'discard', the SSD will never learn that all the free space
left behind is actually free.
 * Eventually all raw disk space is allocated, and users run into
problems with ENOSPC and balance etc.

So, enabling this ssd mode actually means it starts choking itself to
death here.

When users see this effect, they start scheduling balance operations, to
compact free space to bring the amount of allocated but unused space
down a bit.
 * But, doing that is causing just more and more writes to the ssd.
 * Also, since balance takes a "usage" argument and not a "how badly
fragmented" argument, it's causing lots of unnecessary rewriting of data.
 * And, with a decent amount (like a few thousand) subvolumes, all
having a few snapshots of their own, the ratio data:metadata written
during balance is skyrocketing, causing not only the data to be
rewritten, but also causing pushing out lots of metadata to the ssd.
(example: on my backup server rewriting 1GiB of data causes writing of
>40GiB of metadata, where probably 99.99% of those writes are some kind
of intermediary writes which are immediately invalidated during the next
btrfs transaction that is done).

All in all, this reminds me of the series "breaking bad", where every
step taken to try fix things, only made things worse. At every bullet
point above, this is also happening.

== nossd ==

nossd mode (even still without discard) allows a pattern of overwriting
much more previously used space, causing many more implicit discards to
happen because of the overwrite information the ssd gets.

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-ichiban-walk-nossd.mp4

> And last part - hard drive is not aware of filesystem and partitions
> … so you could have 400GB on this 1TB drive left unpartitioned and
> still you would be cooked. Technically speaking using as much as
> possible space on a SSD to a FS and OS that supports trim will give
> you best performance because drive will be notified of as much as
> possible disk space that is actually free …..
> 
> So, to summaries:

> - don’t try to outsmart built in mechanics of SSD (people that
> suggest that are just morons that want to have 5 minutes of fame).

This is exactly what the btrfs ssd options are trying to do.

Still, I don't think it's very nice to call Chris Mason "just a moron". ;-]

However, from the information we found out, and from the various
discussions and real-life behavioural measurements (for me, the ones
above), I think it's pretty clear now that the assumptions done 10 years
ago are not valid, or not valid any more, if they ever were.

I think the ssd options are actually worse for ssds. D:

-- 
Hans van Kranenburg
