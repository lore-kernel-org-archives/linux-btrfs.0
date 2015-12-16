Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20933 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbbLPOl5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 09:41:57 -0500
Date: Wed, 16 Dec 2015 09:41:32 -0500
From: Chris Mason <clm@fb.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
CC: Hugo Mills <hugo@carfax.org.uk>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: attacking btrfs filesystems via UUID collisions?
Message-ID: <20151216144132.GE6322@ret.masoncoding.com>
References: <5668A1CB.1020007@anonym.com>
 <CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
 <1449872498.31388.74.camel@fo>
 <CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
 <1450052868.30943.27.camel@scientia.net>
 <566EC2D7.3000101@gmail.com>
 <CAJCQCtTuETCh_n3dnhPbVBx6_0dcAmNgNWN_bpsTE8goH8byKg@mail.gmail.com>
 <56701B79.8030105@gmail.com>
 <20151215141813.GG26782@carfax.org.uk>
 <1450267418.6259.11.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <1450267418.6259.11.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 16, 2015 at 01:03:38PM +0100, Christoph Anton Mitterer wrote:
> On Tue, 2015-12-15 at 14:18 +0000, Hugo Mills wrote:
> >    That one's easy to answer. It deals with a major issue that
> > reiserfs had: if you have a filesystem with another filesystem image
> > stored on it, reiserfsck could end up deciding that both the metadata
> > blocks of the main filesystem *and* the metadata blocks of the image
> > were part of the same FS (because they're on the same block device),
> > and so would splice both filesystems into one, generally complaining
> > loudly along the way that there was a lot of corruption present that
> > it was trying to fix.
> Hmm that's a bit strange though, and to me it rather sounds like other
> bugs...
> You can have a ext4 on a file in an ext4, with or without the same
> UUIDs, and it will just work.

Hugo is right here.  reiserfs had tools that would scan and entire block
device for metadata blocks and try to reconstruct the filesystem based
on what it found.  Since there was no uuid, it was impossible to tell if
a block from the scan was really part of this filesystem or part of some
image file that happened to be sitting there.

Adding UUIDs doesn't make that whole class of problem go away (you could
have an image of the filesystem inside that filesystem), but it does
make it dramatically less likely.  

At the end of the day it's just a best practice mechanism to help
recovery and prevent admin mistakes.  It's also a building block of the
multi-device support.

We could change the multi-device support to allow duplicate uuids in
single device filesystems.  But I'd much rather see a variation on seed
devices enable transitioning from one uuid to another.

> If the filesystem takes contents from a normal file as possible
> metadata, than something else is severely screwed up... or in case of
> the fsck: it probably means it's a bit too liberal in searching places.
> 
> I'd be quite shocked if this is the case in btrfs, cause it would mean
> again, that we have a vulnerability against UUID collisions.

> Imagine some attacker finds out the UUID of a filesystem (which is
> probably rather easy)... next he uploads some file (e.g. it's a
> webserver with allows image uploads, a forum perhaps) that in reality
> contains what's looks like btrfs metadata and uses a matching UUID.
> 
> It would run into the same issues as what you describe for reiser,..
> the UUID would be no real help to solve that problem.
> 
> 
> Does anyone know whether btrfsck (or other userland) tools do such
> things? I.e. search more or less arbitrary blocks, where it cannot be
> sure it's *not* data, for what it would interpret as meta-data
> subsequently?

These are emergency tools, btrfs restore and find-roots can do some
scanning.  We don't do it the way reiserfs did because it would be very
difficult to reconstruct shared data and metadata from snapshots.

-chris
