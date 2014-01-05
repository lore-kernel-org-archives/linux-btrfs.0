Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo103.cox.net ([68.230.241.215]:52863 "EHLO
	eastrmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaAEVW7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jan 2014 16:22:59 -0500
Received: from eastrmimpo305 ([68.230.241.237]) by eastrmfepo103.cox.net
          (InterMail vM.8.01.05.09 201-2260-151-124-20120717) with ESMTP
          id <20140105204457.ELJH3894.eastrmfepo103.cox.net@eastrmimpo305>
          for <linux-btrfs@vger.kernel.org>; Sun, 5 Jan 2014 15:44:57 -0500
Date: Sun, 5 Jan 2014 13:44:25 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: Jim Salter <jim@jrs-s.net>
Cc: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Message-ID: <20140105134425.22063890@ws>
In-Reply-To: <ADin1n00P0VAdqd01DioM9>
References: <ADin1n00P0VAdqd01DioM9>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 05 Jan 2014 08:42:46 -0500
Jim Salter <jim@jrs-s.net> wrote:

> On Jan 5, 2014 1:39 AM, Marc MERLIN <marc@merlins.org> wrote:
> >
> > On Fri, Jan 03, 2014 at 09:34:10PM +0000, Duncan wrote: 
> > Yes, I got that. That why I ran btrfs defrag on the files after that
> 
> Why are you trying to defrag an SSD? There's no seek penalty for
> moving between fragmented blocks, so defrag isn't really desirable in
> the first place.

[I normally try to reply directly to list but don't believe I've seen
this there yet, but got it direct-mailed so will reply-all in response.]

There's no seek penalty so the overall problem is dramatically lessened
as that's the significant part of it on spinning rust, correct, but...

SSDs do remain IOPS-bound, and tens or hundreds of thousands of extents
do exact an IOPS (as well as general extent bookkeeping) toll, too.

That's why I ended up enabling autodefrag here when I was first setting
up, even tho I'm on SSD.  (Only after asking the list basically the same
question, what good it is autodefrag on SSD, tho.)

Luckily I don't happen to deal with any of the
internal-write-in-huge-files scenarios, however, and I enabled
autodefrag to cover the internal-write-in-small-file scenarios BEFORE I
started putting any data on the filesystems at all,  so I'm basically
covered, here, without actually having to do chattr +C on anything.

> That doesn't change the fact that the described lockup sounds like a
> bug not a feature of course, but I think the answer to your personal
> issue on that particular machine is "don't defrag a solid state
> drive".

I now believe the lockup must be due to processing the hundreds of
thousands of extents on all those snapshots, too, in addition to doing
it on the main volume.  I don't actually make very extensive use of
snapshots here anyway, so I didn't think about that aspect originally,
but that's gotta be what's throwing the real spanner in the works,
turning a possibly long but workable normal defrag (O(1)) into a lockup
scenario (O(n)) where virtually no progress is made as currently
coded.

-- 
Duncan - No HTML messages please, as they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
