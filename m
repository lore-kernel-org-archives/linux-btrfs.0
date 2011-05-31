From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: strange btrfs sub list output
Date: Tue, 31 May 2011 11:00:14 +0100
Message-ID: <20110531100014.GA12396@yahoo.fr>
References: <20110526212203.GA4611@yahoo.fr>
 <chaz20110527080157.GA27537@seebyte.com>
 <4DDF5EEF.6060706@gmail.com>
 <chaz20110527084733.GC27537@seebyte.com>
 <20110527091224.GA15627@carfax.org.uk>
 <chaz20110527093029.GA30613@seebyte.com>
 <20110527094523.GA12089@carfax.org.uk>
 <chaz20110527113010.GA12775@seebyte.com>
 <4DDF8FE0.9040107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hugo Mills <hugo@carfax.org.uk>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDF8FE0.9040107@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-05-27 13:49:52 +0200, Andreas Philipp:
[...]
> > Thanks, I can understand that. What I don't get is how one creates
> > a subvol with a top-level other than 5. I might be missing the
> > obvious, though.
> >
> > If I do:
> >
> > btrfs sub create A btrfs sub create A/B btrfs sub snap A A/B/C
> >
> > A, A/B, A/B/C have their top-level being 5. How would I get a new
> > snapshot to be a child of A/B for instance?
> >
> > In my case, 285, was not appearing in the btrfs sub list output,
> > 287 was a child of 285 with path "data" while all I did was create
> > a snapshot of 284 (path u6:10022/vm+xfs@u8/xvda1/g8/v3/data in vol
> > 5) in u6:10022/vm+xfs@u8/xvda1/g8/v3/snapshots/2011-03-30
> >
> > So I did manage to get a volume with a parent other than 5, but I
> > did not ask for it.
[...]
> Reconsidering the explanations on btrfs subvolume list in this thread
> I get the impression that a line in the output of btrfs subvolume list
> with top level other than 5 indicates that the backrefs from one
> subvolume to its parent are broken.
> 
> What's your opinion on this?
[...]

Given that I don't really get what the parent-child relationship
means in that context, I can't really comment.

In effect, the snapshot had been created and was attached to the
right directory (but didn't appear in the sub list), and there
was an additional "data" volume that I had not asked for nor
created that had the snapshot above as parent and that did
appear in the sub list.

It pretty much looks like a bug to me, I'd like to understand
more so that I can maybe try and avoid running into it again.

-- 
Stephane
