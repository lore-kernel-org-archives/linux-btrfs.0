Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36369 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbcITIgB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 04:36:01 -0400
Date: Tue, 20 Sep 2016 10:34:02 +0200
From: David Sterba <dsterba@suse.cz>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: stability matrix (was: Is stability a joke?)
Message-ID: <20160920083402.GW16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
 <20160912165107.GG16983@twin.jikos.cz>
 <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
 <20160915010759.GD32452@DigitalMercury.dynalias.net>
 <5dec6544a78a0301a8e0cd9086179f99@crc.id.au>
 <1473905644.8603.44.camel@scientia.net>
 <20160919152753.GG933@twin.jikos.cz>
 <1474314346.10189.19.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1474314346.10189.19.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 19, 2016 at 09:45:46PM +0200, Christoph Anton Mitterer wrote:
> +1 for all your changes with the following comments in addition...
> 
> 
> On Mon, 2016-09-19 at 17:27 +0200, David Sterba wrote:
> > That's more like a usecase, thats out of the scope of the tabular
> > overview. But we have an existing page UseCases that I'd like to
> > transform to a more structured and complete overview of usceases of
> > various features, so the UUID collisions would build on top of that
> > with
> > "and this could hapen if ...".
> Well I don't agree here and see it basically like Austin.

So we'd have to make that two separate topics so the "what if" has
better visibility, and possibly marked "with security implications".

> It's not that these UUID collisions can only happen in special
> circumstances but plain normal situations that always used to work with
> probably literally each and every fs. (So much for the accidental
> corruptions).
> 
> And an attack is probably never "usecase dependant"... it always
> depends on the attacker.
> And since that seems to be a pretty real attack vector, I'd also say
> it's mandatory to quite clearly warn about that deficiency...
> 
> TBH, I'm rather surprised that this situation seems to be kinda
> "accepted".
> 
> I had a chat with CM recently and he implied things might be solved
> with encryption.
> While this is probably the case for at least some of the described
> problems, it rather seems like a workaround:
> - why making btrfs-encryption mandatory for devices who have partially
>   secured access (e.g. where a systemdisk with btrfs is not physically
>   accessible but a USB port is)
> - what about users that rather want to use block device encryption
>   instead of fs-level-encryption?
> 
> 
> > > - in-band dedupe
> > >   deduped are IIRC not bitwise compared by the kernel before de-
> > > duping,
> > >   as it's the case with offline dedupe.
> > >   Even if this is considered safe by the community... I think users
> > >   should be told.
> > Only features merged are reflected. And the out-of-band dedupe does
> > full
> > memcpy. See btrfs_cmp_data() called from btrfs_extent_same().
> Ah,... I kinda thought it was already merged ... possibly got confused
> by the countless patch iterations of it ;)
> 
> 
> > > - btrfs check --repair (and others?)
> > >   Telling people that this may often cause more harm than good.
> > I think userspace tools do not belong to the overview.
> Well... I wouldn't mind if there was a btrfs-progs status page... (and
> both link each other).
> OTOH,... the user probably wants one central point where all relevant
> info can be found... and not again having to dig through n websites.

The Status page should give enough overview about all main topics, so
the progs can be one section there. Any details should go to separate
pages and be linked from there.

> > > - even mounting a fs ro, may cause it to be changed
> > 
> > This would go to the UseCases
> Fine for me.
> 
> 
> > 
> > > 
> > > - DB/VM-image like IO patterns + nodatacow + (!)checksumming
> > >   + (auto)defrag + snapshots
> > >   a)
> > >   People typically may have the impression:
> > >   btrfs = checksummed => als is guaranteed to be "valid" (or at
> > > least
> > >   noticed)
> > >   However this isn't the case for nodatacow'ed files, which in turn
> > > is
> > >   kinda "mandatory" for DB/VM-image like IO patterns, cause
> > > otherwise
> > >   these would fragment to heavily (see (b).
> > >   Unless claimed by some people, none of the major DBs or VM-image
> > >   formats do general checksumming on their own, most even don't
> > > support
> > >   it, some that do wouldn't do it without app-support and few
> > > "just"
> > >   don't do it per default.
> > >   Thus one should bump people to this situation and that they may
> > > not
> > >   get this "correctness" guarantee here.
> > >   b)
> > >   IIRC, it doesn't even help to simply not use nodatacow on such
> > > files
> > >   and using auto-defrag instead to countermeasure the fragmenting,
> > > as
> > >   that one doesn't perform too well on large files.
> > 
> > Same.
> Fine for me either... you already said above you would mention the
> nodatacow=>no-checksumming=>no-verification-and-no-raid-repair in the
> general section... this is enough for that place.
> 
> 
> > > For specific features:
> > > - Autodefrag
> > >   - didn't that also cause reflinks to be broken up?
> > 
> > No and never had.
> 
> Absolutely sure? One year ago, I was told that at first too so I
> started using it, but later on some (IIRC) developer said auto-defrag
> would also suffer from it.

Reading the subthread, I have to change the statement. Autodefrag can
read surrounding blocks up to 64k and write it to a new location, on
that write the links will get broken. I'll update the page.

> 
> > > - RAID*
> > >   No userland tools for monitoring/etc.
> > 
> > That's a usability bug.
> 
> Well it is and it will probably go away sooner or later... but the
> unaware user may not really realise that he actually has to take care
> on this by himself for now.
> So I though it would be helpful to have it added.

I agree and I'm not dismissing it, we need a section for such topic
(like system support tools for automatic snapshotting, monitoring etc).
