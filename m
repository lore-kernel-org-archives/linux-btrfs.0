From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: Phoronix article slaming BTRFS
Date: Thu, 25 Jun 2009 11:32:56 +1000
Message-ID: <20090625013256.GA6371@brong.net>
References: <loom.20090623T024010-331@post.gmane.org> <f058a9c30906230313v10d94a5eg8cf123cef30fb5b8@mail.gmail.com> <2d23818a0906231026g6e4567fdv8eda3d6c4828ef4d@mail.gmail.com> <2d23818a0906231028t43d97e64t901610ca18e749d0@mail.gmail.com> <loom.20090624T011230-219@post.gmane.org> <7a329d910906231920l49236acer404369643a2cf833@mail.gmail.com> <loom.20090624T022909-701@post.gmane.org> <1245835894.6366.1321909165@webmail.messagingengine.com> <loom.20090624T124800-384@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Mike Ramsey <MikeJRamsey@comcast.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20090624T124800-384@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 24, 2009 at 12:57:40PM +0000, Mike Ramsey wrote:
> Bron Gondwana <brong <at> fastmail.fm> writes:
> > Meaning that nobody can turn off the write cache in linux without deep kernel
> > hackery.
> 
> I would say this differently.  "Meaning that nobody can turn off the write cache
> in linux without applying the known fixes to libata."

Depending on the environment you're in, building a non-default kernel
can be tricky.

> > Sounds to me like they are benchmarking the real world rather than trying to
> favour btrfs by making changes
> > that are unlikely to be viable for anyone trying to run it in production. 
> I.e. they're benchmarking reality.
> 
> Real world is running kernel software that is compatible with the unit under
> test.  Benchmarking Butters with a broken kernel is not real world; it's unfair.

Well, yeah.  The world's full of unfair stuff.  I would find this valuable
information to have if I had a kernel of that vintage.
 
> > Sure there are ways that btrfs performance could be improved, but they're not
> realistically available to
> > mortals selecting "use btrfs for /home" in their Ubuntu "Bleeding-Edge Badger"
> release.
> 
> Butters is experimental. Currently, it should only be used under adult
> supervision.  I am looking forward to the day that Butters can be used by
> novices when they click http://www.ubuntu.com/products/GetUbuntu/download

Yeah, that would be nice.  I still use reiser3 in locations where I need a
good all-round filesystem.

Bron ( who probably should get a current kernel again - but the .30rcs were
       causing fun and games with my soundcard and I didn't have time to go
       debuggerising them )
