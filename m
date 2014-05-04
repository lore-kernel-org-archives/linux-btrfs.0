Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepi208.cox.net ([68.230.241.212]:35149 "EHLO
	eastrmfepi208.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaEDSrz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 14:47:55 -0400
Received: from eastrmimpo305 ([68.230.241.237]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20140504181239.TNUF31475.eastrmfepo201.cox.net@eastrmimpo305>
          for <linux-btrfs@vger.kernel.org>; Sun, 4 May 2014 14:12:39 -0400
Date: Sun, 4 May 2014 11:12:38 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        Russell Coker <russell@coker.com.au>
Subject: Re: copies= option
Message-ID: <20140504111238.197768d6@ws>
In-Reply-To: <xjTK1n01B308YdQ01jTMAf>
References: <201405041216.54348.russell@coker.com.au>
	<pan$9bead$d5bbe620$2c7141f7$fab07860@cox.net>
	<xjTK1n01B308YdQ01jTMAf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 04 May 2014 09:27:10 +0200
Brendan Hide <brendan@swiftspirit.co.za> wrote:

> On 2014/05/04 05:27 AM, Duncan wrote:
> > Russell Coker posted on Sun, 04 May 2014 12:16:54 +1000 as
> > excerpted:
> >
> >> Are there any plans for a feature like the ZFS copies= option?
> >>
> >> I'd like to be able to set copies= separately for data and
> >> metadata.  In most cases RAID-1 provides adequate data protection
> >> but I'd like to have RAID-1 and copies=2 for metadata so that if
> >> one disk dies and another has some bad sectors during recovery I'm
> >> unlikely to lose metadata.
> > Hugo's the guy with the better info on this one, but until he
> > answers...
> >
> > The zfs license issues mean it's not an option for me and I'm thus
> > not familiar with its options in any detail, but if I understand
> > the question correctly, yes.
> >
> > And of course since btrfs treats data and metadata separately, it's
> > extremely unlikely that any sort of copies= option wouldn't be
> > separately configurable for each.
> >
> > There was a discussion of a very nice multi-way-configuration
> > schema that I deliberately stayed out of as both a bit above my
> > head and far enough in the future that I didn't want to get my
> > hopes up too high about it yet.  I already want N-way-mirroring so
> > bad I can taste it, and this was that and way more... if/when it
> > ever actually gets coded and committed to the mainline kernel
> > btrfs.  As I said, Hugo should have more on it, as he was active in
> > that discussion as it seemed to line up perfectly with his area of
> > interest.
> >
> The simple answer is yes, this is planned. As Duncan implied,
> however, it is not on the immediate roadmap. Internally we appear to
> be referring to this feature as "N-way redundancy" or "N-way
> mirroring".
> 
> My understanding is that the biggest hurdle before the primary devs
> will look into N-way redundancy is to finish the Raid5/6
> implementation to include self-healing/scrubbing support - a critical
> issue before it can be adopted further.

Well, there's N-way-mirroring, which /is/ on the roadmap for fairly
soon (after raid56 completion), and which is the feature I've been
heavily anticipating ever since I first looked into btrfs and realized
that raid1 didn't include it already, but what I was referring to above
was something much nicer than that.

As I said I don't understand the full details, Hugo's the one that can
properly answer there, but the general idea (I think) is the ability to
three-way specify N-copies, M-parity, S-stripe, possibly with
near/far-layout specification like md/raid's raid10, as well.  But Hugo
refers to it with three different letters, cps copies/parity/stripes,
perhaps?  That doesn't look quite correct...

But that at least has the potential to be /so/ nice, and possibly
also /so/ complicated, that I'm deliberately avoiding looking too much
at the details as it's far enough out and may in fact never get fully
implemented that I don't want to spoil my enjoyment of
(relatively, compared to that) simple N-way-mirroring when it comes.

And more particularly, I really /really/ hope they don't put off a
reasonably simple and (hopefully) fast implementation of
N-way-mirroring as soon as possible after raid56 completion, because I
really /really/ want N-way-mirroring, and this other thing would
certainly be extremely nice, but I'm quite fearful that it could also be
the perfect being the enemy of the good-enough, and btrfs already has a
long history of features repeatedly taking far longer to implement than
originally predicted, which with something that potentially complex,
I'm very afraid could mean a 2-5 year wait before it's actually usable.

And given how long I've been waiting for the simple-compared-to-that
N-way-mirroring thing and how much I anticipate it, I just don't know
what I'd do if I were to find out that they were going to work on this
"perfect" thing instead, with N-way-mirroring being one possible option
with it, but that as a result, given the btrfs history to date, it'd
very likely be a good five years before I could get the comparatively
simple N-way-mirroring (or even, for me, just a specific
3-way-mirroring to compliment the specific 2-way-mirroring that's
already there) that's all I'm really asking for.

So I guess you can see why I don't want to get into the details of the
more fancy solution too much, both as a means of protecting my own
sanity, and to hopefully avoid throwing the 3-way-mirroring that's my
own personal focal point off the track.  So Hugo's the one with the
details, to the extent they've been discussed at least, there.

-- 
Duncan - No HTML messages please, as they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
