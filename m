Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:41306 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751917AbdGESTD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Jul 2017 14:19:03 -0400
Date: Wed, 5 Jul 2017 20:18:54 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>, "dsterba@suse.cz" <dsterba@suse.cz>,
        E V <eliventer@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
Message-ID: <20170705181854.a4d35h2dgp4t3hlt@angband.pl>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
 <CAJtFHUQvmnf7Ggawb4UDfoU8MK37q3rxiWdUmYJE8h1huQZfFQ@mail.gmail.com>
 <20170630142133.GU2866@twin.jikos.cz>
 <e66729e8-0256-745f-53d0-e89241ab524c@gmail.com>
 <15B9D85B-F8AF-44B3-B644-7E4F13A3764C@fb.com>
 <0cf10bfd-8631-7542-be31-7cc04379b0a9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <0cf10bfd-8631-7542-be31-7cc04379b0a9@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 05, 2017 at 07:43:27AM -0400, Austin S. Hemmelgarn wrote:
> On 2017-06-30 19:01, Nick Terrell wrote:
> > > There is also the fact of deciding what to use for the default when
> > > specified without a level.  This is easy for lzo and zlib, where we can
> > > just use the existing level, but for zstd we would need to decide how to
> > > handle a user just specifying 'zstd' without a level.  I agree with E V
> > > that level 3 appears to be the turnover point, and would suggest using
> > > that for the default.
> > 
> > I chose level 1 because I thought if we had to choose one speed/compression
> > trade off, faster would be better. However, with a configerable compression
> > level, level 3 is a great default, and is the default of the zstd CLI.
> Actually, even if it's not configurable, I would prefer 3, as that still
> performs better in both respects (speed and compression ratio) than zlib
> while being sufficiently different from lzo performance to make it easy to
> decide on one or the other.  As far as configurable levels for regular usage
> on a filesystem, there are only three levels you benchmarked that I would be
> interested in, namely level 1 (highly active data on slow storage with a
> fast CPU), 3 (stuff I would use zlib for today), and 15 (stuff I would use
> out-of-band compression for today (for example, archival storage)).

If you guys are going to argue between 1 and 3, just go the cracovian deal
and settle at 2. :þ

But more seriously: zstd looks so much better than lzo and zlib than I'd
suggest making it the default compression in cases where there's no way to
choose, such as chattr +c.  But then, changing the default before the
previous LTS kernel can mount it would be irresponsible -- thus, if you can
get it into 4.14, we're looking at 4.19 at soonest (or later if we consider
distro kernels).

Which means the timing is quite tight: if, per DSterba's request, /lib/
parts are going via a non-btrfs tree, there'll be not enough adequate
testing in -next.  Thus, would it be possible to have /lib/ patches in
btrfs-next but not in for-linus?  That would allow testing so you can catch
the LTS train.

> > > > So, I don't see any problem making the level configurable.
> > > I would actually love to see this, I regularly make use of varying
> > > compression both on BTRFS (with separate filesystems) and on the
> > > ZFS-based NAS systems we have at work (where it can be set per-dataset)
> > > to allow better compression on less frequently accessed data.
> > 
> > I would love to see configurable compression level as well. Would you want
> > me to add it to my patch set, or should I adapt my patch set to work on top
> > of it when it is ready?

Note that as zstd is new, there's no backwards compat to care of, thus you
are free to use whatever -o/prop syntax you'd like.  If zstd ends up being
configurable while zlib is not -- oh well, there's no reason to use zlib
anymore other than for mounting with old kernels, in which case we can't use
configurable props anyway.  Unlike zlib, lzo is not strictly worse than
configurable zstd, but it has only one level so there's nothing to configure
as well.

Thus, I'd suggest skipping the issue and implement levels for zstd only.


As for testing: I assume you guys are doing stress testing on amd64 already,
right?  I got two crappy arm64 machines but won't be able to test there
before 4.13 (Icenowy has been lazy and didn't push any near-mainline patch
set recently; every single Pine64/Pinebook kernel pushed by anyone but her
didn't work for me so I don't even bother trying anymore).  On the other
hand, the armhf box I'm running Debian rebuilds on is a gem among cheap
SoCs.  After Nick fixed the flickering workspaces bug, there were no further
hiccups; on monday I switched to 4.12.0 + btrfs-for-4.13 + zstd (thus
luckily avoiding that nowait aio bug), also no explosions yet.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
