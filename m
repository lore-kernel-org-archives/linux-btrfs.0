From: Mike Ramsey <MikeJRamsey@comcast.net>
Subject: Re: Phoronix article slaming BTRFS
Date: Wed, 24 Jun 2009 12:57:40 +0000 (UTC)
Message-ID: <loom.20090624T124800-384@post.gmane.org>
References: <loom.20090623T024010-331@post.gmane.org> <f058a9c30906230313v10d94a5eg8cf123cef30fb5b8@mail.gmail.com> <2d23818a0906231026g6e4567fdv8eda3d6c4828ef4d@mail.gmail.com> <2d23818a0906231028t43d97e64t901610ca18e749d0@mail.gmail.com> <loom.20090624T011230-219@post.gmane.org> <7a329d910906231920l49236acer404369643a2cf833@mail.gmail.com> <loom.20090624T022909-701@post.gmane.org> <1245835894.6366.1321909165@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Bron Gondwana <brong <at> fastmail.fm> writes:

> 
> 
> On Tue, 23 Jun 2009 22:47 +0000, "Mike Ramsey" <MikeJRamsey <at> comcast.net>
wrote:
> > Wil Reichert <wil.reichert <at> gmail.com> writes:
> > > My suggestion is either to show where their
> > > benchmarks are in err, 
> > 
> > I did this, didn't I?
> >  1. Vertex with write cache enabled; disabled would have seen a 
> >     2X improvement.
> >  2. Error in libata
> 
> Meaning that nobody can turn off the write cache in linux without deep kernel
hackery.

I would say this differently.  "Meaning that nobody can turn off the write cache
in linux without applying the known fixes to libata."

> 
> Sounds to me like they are benchmarking the real world rather than trying to
favour btrfs by making changes
> that are unlikely to be viable for anyone trying to run it in production. 
I.e. they're benchmarking reality.

Real world is running kernel software that is compatible with the unit under
test.  Benchmarking Butters with a broken kernel is not real world; it's unfair.

> 
> Sure there are ways that btrfs performance could be improved, but they're not
realistically available to
> mortals selecting "use btrfs for /home" in their Ubuntu "Bleeding-Edge Badger"
release.

Butters is experimental. Currently, it should only be used under adult
supervision.  I am looking forward to the day that Butters can be used by
novices when they click http://www.ubuntu.com/products/GetUbuntu/download

> 
> Bron.




