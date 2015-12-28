Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36236 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbbL1VuY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 16:50:24 -0500
Received: by mail-ig0-f181.google.com with SMTP id ph11so152787063igc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 13:50:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5681A6FD.2020808@online.no>
References: <567FEEB6.3080701@online.no>
	<CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
	<56806F06.50309@online.no>
	<pan$c7935$46be3379$4afc60bd$677c85c5@cox.net>
	<568098B1.2040908@online.no>
	<pan$2108f$416fcf23$11933405$72f48ca8@cox.net>
	<5681A6FD.2020808@online.no>
Date: Mon, 28 Dec 2015 14:50:23 -0700
Message-ID: <CAJCQCtQJRgnkbSq3MG9yM70MxXnpBdbs2GMPSS1_1yohrTuDBA@mail.gmail.com>
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
From: Chris Murphy <lists@colorremedies.com>
To: Waxhead <waxhead@online.no>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 28, 2015 at 2:17 PM, Waxhead <waxhead@online.no> wrote:



> What if my use of dd accidentally trashed some important part of the new
> filesystem and btrfs therefore thinks a older version of the filesystem is
> the current one? If UUID's are in every metadatablock I find that pretty
> hard to believe.

Each leaf has the fsuuid in it. I'm not sure if it also has the
devi_item.uuid or if that's only in the supers. But in any case the
fsid is strewn throughout metadata expressly to make sure it doesn't
get confused if it runs across stale metadata from a previous system.
XFS v5 metadata does this also, although I have no idea how it's
implemented compared to Btrfs.

>What if the UUID==0 ? is this accounted for?

Yes, this is a nil uuid.


>> Of course if you weren't experimenting with btrfs on these devices back
>> at the end of March and there's absolutely no way they could have gotten
>> btrfs on them until say October or whenever, then we're back to the date
>> somehow being wrong for that scrub, and having to look elsewhere for why
>> scrub is crashing.
>>
> No, by all means - I tried a lot of weird stuff on those usb sticks way
> before march so they defiantly had a (multi disk) btrfs filesystem on them
> before.

It shouldn't be a problem. But...  These are USB flash drives? Aren't
they described as not containing your data at all, but rather a
probabilistic representation of your data? Ha. So while it ordinarily
returns your data, sometimes it won't.

You might check if any of them are counterfeit which will increase the
chances of getting crap back from the drive. Check this blog entry and
see if either F3 or gnome-multi-writer-probe can help you determine
this. Note there's a chance the drives aren't useful after using this
tool, so, be ready to be done with this Btrfs volume before
proceeding.
https://blogs.gnome.org/hughsie/2015/01/28/detecting-fake-flash/

Even if that comes up clean, I'd run badblocks on everyone of those
sticks overnight and see if you get any errors. Btrfs *probably* ought
to deal with a handful of errors. But if you were to get really
unlucky and have a couple of errors at the same time as your induced
corruption error, that's effectively three missing devices (for that
read stripe). For badblocks, something like  -vsw looks good; note
that this is destructive and it will take a while (multiple passes,
multiple patterns, writes then reads for each for the entire drive).


-- 
Chris Murphy
