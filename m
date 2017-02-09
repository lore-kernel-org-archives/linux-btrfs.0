Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:54822 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbdBILuE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Feb 2017 06:50:04 -0500
Date: Thu, 9 Feb 2017 12:49:04 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS and cyrus mail server
Message-ID: <20170209114904.dbr6irzbfxkr35xj@angband.pl>
References: <24389268.gAX5gEpECb@libor-nb>
 <e6da1740-cdb0-96ce-4f44-3b8fa32fd052@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e6da1740-cdb0-96ce-4f44-3b8fa32fd052@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 08, 2017 at 02:21:13PM -0500, Austin S. Hemmelgarn wrote:
> >  - maybe deduplication (cyrus does it by hardlinking of same content messages
> > now) later
> Deduplication beyond what Cyrus does is probably not worth it.  In most
> cases about 10% of an e-mail in text form is going to be duplicated if it's
> not a copy of an existing message, and that 10% is generally spread
> throughout the file (stuff like MIME headers and such), so you would
> probably see near zero space savings for doing anything beyond what Cyrus
> does while using an insanely larger amount of resources.

The problem is: users in a company tend to send mails to a group, so a bunch
of people have plenty of identical mails... then every delivered mail has
slightly different headers prepended, usually of different length to make
sure that 20MB mail has its contents shifted by a single byte so you can't
dedupe blocks after the first.

> >  - snapshots for history
> Make sure you use a sane exponential thinning system.  Once you get past
> about 300 snapshots, you'll start seeing some serious performance issues,
> and even double digits might hurt performance at the scale you're talking
> about.

It's not anywhere that bad in my experience.  As far as I know, regular
POSIX operations are not affected by the number of reflinks, only stuff like
balance (greatly), dedupe, and, to a lesser extent, deletion of snapshots.
You don't want to hit 100k snapshots like I once did, but even then the
filesystem keeps working in regular operation.

(Those snapshots were not deduped beyond natural reflinking from
snapshotting, every one having no more than a few hundreds links.  I now
realize that it'd probably explode had I tried coalescing identical
files between then.)

> >  - send/receive for offisite backup
> This is up to you, but I would probably not use send-receive for off-site
> backups.  Unless you're using reflinking, you can copy all the same
> attributes that send-receive does using almost any other backup tool, and
> other tools often have much better security built-in.  Send streams also
> don't compress very well in my experience, so using send-receive has a
> tendency to require more network resources.

I'd heartily recommend using _both_.  You use send-receive for that 3-hour
(or 1-hour!) backup, and rsync for dailies.  You do value your mails enough
to back them to two places, right?  Then you get to enjoy efficiency of
send-receive (statting everything takes ages!), while rsync helps with
paranoia about send-receive cloning potential filesystem errors.

> > Our Cyrus pool consist of ~520GB of data in ~2,5million files, ~2000
> > mailboxes.
> > We have message size limit of ~25MB, so emails are not bigger than that.
> > There are however bigger files, these are per mailbox caches/index files of
> > cyrus (some of them are around 300MB) - and these are also files which are
> > most modified.
> I would mark these files NOCOW for performance reasons (and because if
> they're just caches and indexes, they should be pretty simple to
> regenerate).

Using NOCOW with snapshots gets you the worst of both worlds: all the
downsides of CoW with no btrfs goodies.  NOCOW is useful only for "I wish I
had partitioned a traditional filesystem for this file, and I don't need to
snapshot it".


Meow!
-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11
