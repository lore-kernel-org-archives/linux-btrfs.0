Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:54126 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbbDRPCq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Apr 2015 11:02:46 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Christoph Anton Mitterer <calestyo@scientia.net>
Subject: Re: how to clone a btrfs filesystem
Date: Sun, 19 Apr 2015 01:02:42 +1000
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
References: <1429312124.8371.62.camel@scientia.net> <201504180424.40385.russell@coker.com.au> <1429334269.8371.75.camel@scientia.net>
In-Reply-To: <1429334269.8371.75.camel@scientia.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201504190102.42660.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 18 Apr 2015, Christoph Anton Mitterer <calestyo@scientia.net> wrote:
> On Sat, 2015-04-18 at 04:24 +0000, Russell Coker wrote:
> > dd works.  ;)
> > 
> > There are patches to rsync that make it work on block devices.  Of course
> > that will copy space occupied by deleted files too.
> 
> I think both are not quite the solutions I was looking for.

I know, but I don't think what you want is possible at this time.

> Guess for dd this is obvious, but for rsync I'd also loose all btrfs
> features like checksum verifications,... and even if these patches you
> mention would make it work on block devices, I'd guess it would at least
> need to read everything, it would not longer be a merge into another
> filesystem (perhaps I shouldn't have written "clone")... and the target
> block device would need to have at least the size of the origin.

An rsync on block devices wouldn't lose BTRFS checksums, you could run a scrub 
on the target at any time to verify them.  For a dd or anything based on that 
the target needs to be at least as big as the source.  But typical use of 
BTRFS for backup devices tends to result in keeping as many snapshots as 
possible without running out of space which means that no matter how you were 
to copy it the target would need to be as big.

> Can't one do something like the following:
> 1) The source fs has several snapshots and subvols.
>    The target fs is empty (the first time).
> 
> 
> For the first time populating the target fs:
> 
> 2) Make ro snapshots of all non-ro snapshots and subvols on the
> source-fs.
> 
> 3) Send/receive the first of the ro snapshots to the target fs, with no
> parent and no clone-src.
> 
> 4) Send/receive all further ro snapshots to the target fs, with no
> parents, but each time specifying one further clone-src (i.e. all that
> have already been sent/received) so that they're used for reflinks and
> so on
> 
> 5) At the end somehow make rw-subvols from the snapshots/subvols that
> have been previously rw (how?).

Sure, for 5 I believe you can make a rw snapshot of a ro subvol.

> Does that sound as if it would somehow work like that? Especially would
> it preserve all the reflink statuses and everything else (sparse files,
> etc.)

Yes, but it would take a bit of scripting work.

> Some additional questions:
> a) Can btrfs send change anything(!) on the source fs?
> b) Can one abort (Ctrl-C) a send and/or receive... and make it continue
> at the same place were it was stopped?

A yes, B I don't know.

Also I'm not personally inclined to trust send/recv at this time.  I don't 
think it's had a lot of testing.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
