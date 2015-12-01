Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58139 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932098AbbLATA2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Dec 2015 14:00:28 -0500
Date: Tue, 1 Dec 2015 14:00:18 -0500
From: Chris Mason <clm@fb.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Bug/regression: Read-only mount not read-only
Message-ID: <20151201190018.GD8918@ret.masoncoding.com>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151130164801.GD2162@ret.masoncoding.com>
 <20151130170600.GC8775@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20151130170600.GC8775@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 30, 2015 at 05:06:00PM +0000, Hugo Mills wrote:
> On Mon, Nov 30, 2015 at 11:48:01AM -0500, Chris Mason wrote:
> > On Sat, Nov 28, 2015 at 01:46:34PM +0000, Hugo Mills wrote:
> > >    We've just had someone on IRC with a problem mounting their FS. The
> > > main problem is that they've got a corrupt log tree. That isn't the
> > > subject of this email, though.
> > > 
> > >    The issue I'd like to raise is that even with -oro as a point
> > > option, the FS is trying to replay the log tree. The dmesg output from
> > > mount -oro is at the end of the email.
> > > 
> > >    Now, my memory, experience and understanding is that the FS
> > > doesn't, and shouldn't replay the log tree on a RO mount, because the
> > > FS should still be consistent even without the reply, and
> > > RO-means-actually-RO is possible and desirable. (Compared to a
> > > journalling FS, where journal replay is required for a consistent,
> > > usable FS).
> > > 
> > >    So, this looks to me like a regression that's come in somewhere.
> > > 
> > >    (Just for completeness, the system in question usually runs 4.2.5,
> > > but the live CD the OP is using is 4.2.3).
> > 
> > We do need to replay the log tree, even on readonly mounts.  Otherwise
> > files created and fsunk before crashing may not even exist.
> 
>    I'm actually happy with that, as long as the log tree is retained
> until it _can_ be played back. I think it's much more important that
> read-only actually means read-only *as much as is possible* (if for no
> other reason than being able to test the status of the log tree).
> Obviously, for journalling FSes, a journal reply is required by the
> design of the FS, but with a CoW FS, the FS should be consistent if
> possibly outdated with a RO mount.

Normally I'd agree, but we have a long tradition of mounting root
readonly at first for no good reason at all.  This is why reiserfs/ext
(and I think xfs) all replay logs on readonly mounts.  It's not an
admin initiated action but an early stage of boot.

> 
>    Maybe there should be a "replay-log" mount option to modify the
> "ro" option to allow the log to be replayed but no further
> modifications? (i.e. keep the plain "ro" case to be the safest option
> that makes the fewest changes to the FS structure -- none).
> 

I'd do it the other way around, have a mount option that is emergency
readonly.

> > We'll bail out of the log replay on readonly media, but otherwise the
> > replay always happens.
> 
>    OK, so what was happening in the cases where a filesystem was
> mountable RO, but not RW, and then btrfs-zero-log allowed the FS to be
> mounted? I've handled any number of people with exactly those
> symptoms, and it's been like that for a while. What I saw on IRC a
> couple of days ago seems to be new behaviour.

Something else was being skipped, probably btrfs_cleanup_fs_roots()

-chris
