Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42832 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S967882AbdDSRXn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 13:23:43 -0400
Date: Wed, 19 Apr 2017 19:23:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Evan Danaher <github@edanaher.net>
Cc: Noah Massey <noah.massey@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: send-dump: always print a space after path
Message-ID: <20170419172338.GF22319@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170411000904.GF2455@edanaher.net>
 <CADfjVrg793+_eb21OpX0ps5Fat6a=2SxED87meuMabXQjSyT=A@mail.gmail.com>
 <20170411134902.GG2455@edanaher.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170411134902.GG2455@edanaher.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 11, 2017 at 09:49:02AM -0400, Evan Danaher wrote:
> Thanks for catching that!  I overthought this and managed to convince
> myself that it was correct as it stood.
> 
> Should I re-send the whole patch with that change?  This is my first
> attempt at contributing to a project managed in the Linux kernel style,
> so I'm not sure about the process; documentation that I've found around
> responding to feedback seems to be more about social issues than the
> mechanics of what to actually do...

Here's some howto
https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ

Depends on what you take from the 'linux kernel style'. We stick to good
changelogs, signed-off-by lines and patches that do one thing at a time.
The interactions experience differs across the subsystems, the btrfs
community is friendly.

Patches from strangers are apprecated as they usually do the extra step
and also try to fix the problem they encounter. The patch does not need
to be perfect, small things I fix myself. If it's not obvious it's
better to do another iteration, eg. when the change needs to be
retested.

> On Tue, Apr 11, 2017 at 09:24:56AM -0400, Noah Massey wrote:
> > On Mon, Apr 10, 2017 at 8:09 PM, Evan Danaher <github@edanaher.net> wrote:
> > > I was shocked to discover that 'btrfs receive --dump' doesn't print a
> > > space after long filenames, so it runs together into the metadata; for
> > > example:
> > >
> > > truncate        ./20-00-03/this-name-is-32-characters-longsize=0
> > >
> > > This is a trivial patch to add a single space unconditionally, so the
> > > result is the following:
> > >
> > > truncate        ./20-00-03/this-name-is-32-characters-long size=0
> > >
> > > I suppose this is technically a breaking change, but it seems unlikely
> > > to me that anyone would depend on the existing behavior given how
> > > unfriendly it is.

Agreed, the output needs to be fixed, backward compatibility is not an
issue here.
