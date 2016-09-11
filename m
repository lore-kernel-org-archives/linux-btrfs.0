Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50997 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756268AbcIKTvl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 15:51:41 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Small fs
Date: Sun, 11 Sep 2016 21:51:38 +0200
Message-ID: <34273168.IdA9o4YR3V@merkaba>
In-Reply-To: <20160911194632.GF7138@carfax.org.uk>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com> <14309857.N6fGUh6qoJ@merkaba> <20160911194632.GF7138@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 11. September 2016, 19:46:32 CEST schrieb Hugo Mills:
> On Sun, Sep 11, 2016 at 09:13:28PM +0200, Martin Steigerwald wrote:
> > Am Sonntag, 11. September 2016, 16:44:23 CEST schrieb Duncan:
> > > * Metadata, and thus mixed-bg, defaults to DUP mode on a single-device
> > > filesystem (except on ssd where I actually still use it myself, and
> > > recommend it except for ssds that do firmware dedupe).  In mixed-mode
> > > this means two copies of data as well, which halves the usable space.
> > > 
> > > IOW, when using mixed-mode, which is recommended under a gig, and dup
> > > replication which is then the single-device default, effective usable
> > > space is **HALVED**, so 256 MiB btrfs size becomes 128 MiB usable. (!!)
> > 
> > I don´t get this part. That is just *metadata* being duplicated, not the
> > actual *data* inside the files. Or am I missing something here?
> 
>    In mixed mode, there's no distinction: Data and metadata both use
> the same chunks. If those chunks are DUP, then both data and metadata
> are duplicated, and you get half the space available.

In german I´d say "autsch", in english according to pda.leo.org "ouch", to 
this.

Okay, I just erased using mixed mode as an idea from my mind altogether :).

Just like I think I will never use a BTRFS below 5 GiB. Well, with one 
exception, maybe on the eMMC flash of the new Omnia Turris router that I hope 
will arrive soon at my place.

-- 
Martin
