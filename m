Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35504 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbcEIRNz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 13:13:55 -0400
Received: by mail-wm0-f46.google.com with SMTP id e201so146259910wme.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 May 2016 10:13:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160507134010.08e50734@jupiter.sol.kaishome.de>
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
	<CAD=QJKiQb0Ryedw+52pfZ-Tp0W9O0jPqxgGqxhY7b=U+2eP3wg@mail.gmail.com>
	<20160503084814.3e355f56@jupiter.sol.kaishome.de>
	<20160505083537.0811b46f@jupiter.sol.kaishome.de>
	<20160507134010.08e50734@jupiter.sol.kaishome.de>
Date: Mon, 9 May 2016 13:13:53 -0400
Message-ID: <CAD=QJKjfmpb9_b3s6kh6CaAOKLRLZkD5pRryxC3R7iiuA8rvAQ@mail.gmail.com>
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On May 7, 2016 7:43 AM, "Kai Krakow" <hurikhan77@gmail.com> wrote:
>
> Am Thu, 5 May 2016 08:35:37 +0200
> schrieb Kai Krakow <hurikhan77@gmail.com>:
>
> > Am Tue, 3 May 2016 08:48:14 +0200
> > schrieb Kai Krakow <hurikhan77@gmail.com>:
> >
> > > Am Sun, 1 May 2016 20:39:31 -0400
> > > schrieb Nicholas D Steeves <nsteeves@gmail.com>:
> > >
> > > > On 1 May 2016 at 03:00, Kai Krakow <hurikhan77@gmail.com>
> > > > wrote:
> >  [...]
> > > >
> > > > Out of curiosity, does this occur if you don't create or delete
> > > > snapshots, or if your backup script doesn't create or delete
> > > > snapshots?  And when it occurs, are you able to go to another
> > > > terminal and run a command that you don't use often, that
> > > > definitely had to be read from disk, but that doesn't query any
> > > > filesystem properties (eg: whois)?
> > >
> > > I only create snapshots in the destination device, not on the
> > > source. I could try disabling the snapshotting and see if it
> > > changes things.
> > >
> > > It seems from my observation, that only programs querying disk free
> > > or disk usage status hang, especially all of the btrfs subcommands
> > > doing it hang, in addition to traditional programs like du and df.
> > > I think also "btrfs sub delete" and friends hang. So your guess may
> > > very well go into the right direction. Let me try. Coming back
> > > later...
> >
> > With the snapshot and sync related bits disabled in my script, I no
> > longer experience freezing df/du/... commands.
>
> Ah well, I still do - it just triggers much less often.
>
> But I can track it down to the automounter now: As soon as I stop the
> automounter of my backup device, du/df/etc no longer hang. Still I'm
> not sure if the problem is originating from btrfs or autofs itself.
>

Hi Kai,

If it's anything like what I've encountered it can be worked around
with careful use of sleep, sync, btrfs sub sync and/or btrfs fi sync.
Also, if it's a similar issue to my own then from what I've read on
this list it's a timing or race issue (or maybe a locking issue).
There's a Debian bug where someone is testing out different
values/strategies.  The values/strategy I use can be found in
btrfs-borg on github.  If I'm correct, you'll probably also need to
script in delays to things time to settle with your automounter.

Of course, ideally someone will one day spend the time debugging
what's actually going on.

Cheers,
Nick
