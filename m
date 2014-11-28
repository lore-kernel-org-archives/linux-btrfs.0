Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:54095 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaK1HKl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Nov 2014 02:10:41 -0500
Received: by mail-yk0-f173.google.com with SMTP id 19so2733637ykq.32
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Nov 2014 23:10:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$7d8df$684921c0$5b1accb1$bf431820@cox.net>
References: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com>
	<20141121042814.GR17395@hungrycats.org>
	<5470C92E.1070607@inwind.it>
	<20141123001927.GO17380@hungrycats.org>
	<5474AF87.6090702@inwind.it>
	<20141125202948.GP17380@hungrycats.org>
	<5474FBD9.5070709@inwind.it>
	<pan$8a1fe$cae59052$c5e19c35$9858d5fc@cox.net>
	<54764F4E.80405@pobox.com>
	<pan$7d8df$684921c0$5b1accb1$bf431820@cox.net>
Date: Fri, 28 Nov 2014 00:10:40 -0700
Message-ID: <CAJCQCtSGT_CCYZ5WBo_xqw5xWgFbovoWca0-yBEk5WiR7PYQwg@mail.gmail.com>
Subject: Re: BTRFS messes up snapshot LV with origin
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 27, 2014 at 2:08 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> So, umm... kinda late now, but read that "copy" as if it had a footnote
> attached, saying "Yes, I know it's not actual copy, it's two views of the
> same thing using COW, but my point is, from the btrfs perspective it's a
> copy, the "universally UNIQUE ID" no longer looks "unique" and thus no
> longer can be properly called a UUID at all."

The copy is sort of a misnomer anyway because up until the computer
age the copy was a derivative, a facsimile, like a photocopy. But a
copy of a digital file is actually another original. Therein lies the
problem with the LVM snapshot in this context, we don't want another
original. We want a copy, as in we want something we know has been
derived from something else, and therefore can be discriminated.

And that's the same problem with subvolume UUIDs being "reused" when
creating new Btrfs volumes, which have new volume UUIDs, from a Btrfs
seed device. There are now multiple originals of those subvolumes,
there's no distinguishing them by their UUID alone.


> But... I'd still say LVM is "at fault" to the extent that anyone is, as
> it /knows/ it's dealing with UUIDs because after all that's part of
> what's /on/ what it's snapshotting, and it doesn't make any effort to
> deal with the situation, despite the at least theoretical (and now in
> fact) confusion that may occur when former UUIDs are no longer unique and
> thus no longer UUIDs.

Well RFC 4122 I don't think would say it's not a UUID, the uniqueness
is only guaranteed at the time of UUID creation. And duplication isn't
creation so it's not going to say these things are no longer UUIDs,
they're just UUIDs that have been recycled. That RFC doesn't specify
workflow, but if it did, I think it'd basically say "oh crap, why'd
you go and do that?" After all a major point of UUIDs is that they are
effectively unlimited in quantity, therefore a.) we don't need central
registry to avoid (unintended) collisions because they're so uncommon,
b.) we're encouraged to not be attached to specific UUIDs when in
doubt just create another one.

A very good example of WTF reusage of a UUID that irks me to no end is
GNU parted devs decided to recycle the Microsoft Windows Basic Data
partition type GUID for Linux partitions. It's like watching someone
get run over by a zamboni with 50 feet of advance notice...



-- 
Chris Murphy
