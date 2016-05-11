Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbcEKCwN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 22:52:13 -0400
Date: Tue, 10 May 2016 19:52:11 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About in-band dedupe for v4.7
Message-ID: <20160511025211.GF7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160510221119.GD7633@wotan.suse.de>
 <23ec14b4-deb3-4294-348c-1f0e4a7db169@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <23ec14b4-deb3-4294-348c-1f0e4a7db169@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 11, 2016 at 09:03:24AM +0800, Qu Wenruo wrote:
> 
> 
> Mark Fasheh wrote on 2016/05/10 15:11 -0700:
> >On Tue, May 10, 2016 at 03:19:52PM +0800, Qu Wenruo wrote:
> >>Hi, Chris, Josef and David,
> >>
> >>As merge window for v4.7 is coming, it would be good to hear your
> >>ideas about the inband dedupe.
> >>
> >>We are addressing the ENOSPC problem which Josef pointed out, and we
> >>believe the final fix patch would come out at the beginning of the
> >>merge window.(Next week)
> >
> >How about the fiemap performance problem you referenced before? My guess is
> >that it happens because you don't coalesce writes into anything larger than
> >a page so you're stuck deduping at some silly size like 4k. This in turn
> >fragments the files so much that fiemap has a hard time walking backrefs.
> Nope. Default dedupe size is 128K, and minimal dedupe size is
> limited to 64K maximum to 8M.
> Yes, it's going to cause fragements, but just check the test case I
> submitted, it doesn't ever need dedupe to trigger the bug.
> Clone range will also trigger it.

Yes, as you might see I've been looking through the patches now.


> >I have to check the patches to be sure but perhaps you can tell me whether
> >my hunch is correct or not.
> >
> >
> >In fact, I actually asked privately for time to review your dedupe patches,
> >but I've been literally so busy cleaning up after the mess you left in your
> >last qgroups rewrite I haven't had time.
> >
> >You literally broke qgroups in almost every spot that matters. In some cases
> >(drop_snapshot) you tore out working code and left in a /* TODO */ comment
> >for someone else to complete.  Snapshot create was so trivially and
> >completely broken by your changes that weeks later, I'm still hunting a
> >solution which doesn't involve adding an extra _commit_ to our commit.  This
> >is a MASSIVE regression from where we were before.
> 
> If you think my rework is a mess, then before that, qgroup is just
> rubbish, it can't even handle reflink between subvolume(btrfs/091),
> not to mention the hell of leaked reserved space(btrfs/099).

That's fine, I agree that the qgroups code was rubbish, but you replaced it
with something that was known to be broken. Just look at the /* TODO */ in
your original patch series. We were making incremental improvements before
and you threw that all out. Can you fault me for wondering what unsolved
problems await us in your dedupe patches?


> You were just overlooking the old qgroup things, thinking old one
> working and use the corner spot to express your disappointment.

No, I'm not happy about you leaving qgroups more broken than when you
started. There's fixing a bug, and there's trading one bug for several
others. You have done the latter.


> >IMHO, you should not be trusted with large features or rewrites until you
> >can demonstrate:
> >
> > - A willingness to *completely* solve the problem you are trying to 'fix',
> >   not do half the job which someone else will have to complete for you.
> 
> OK, just let the qgroup break forever?

You don't get credit for a partial solution!

Stepping back here for a second, I'm happy that you tried to fix a bug. I'm
extremely dissapointed in how you went about it - with a laser focus on
fixing that one bug at the expense of others. Fixing reflink between
subvolumes does us no good if you broke subvolume create and subvolume
deletion - the accounting is still wrong! The same goes for reservations.
Who cares if they don't work when the basic accounting is reporting
subvolumes with -121231247283946 bytes in them.


> Have you ever noticed the problem before the rework? What are you
> doing before that?
> Did you ever want to fix it before the rework?
> 
> Yes good corner spot and good whole accounting is perfect.
> 
> But it's super wired for you to think bad whole accounting with good
> corner case is even better than good whole accounting with bad
> corner case.
> 
> Any sane will fix the whole part thing first, and then the corner case.

Where are your corner case fixes then? This is what I'm talking about with
respect to half complete solutions!


> > - Actual testing. The snapshot bug I reference above exists purely because
> >   nobody created a snapshot inside of one and checked the qgroup numbers!
> 
> Just check the qgroup test cases.
> 
> Same word can also be said to yourself.
> 
> Why didn't you spot leaked reserve space and reflink problem and
> even the long failed test cases of qgroup test group?
> 
> It's always easier to complain others work than provide a good one.

Just so we're clear I wrote none of the original qgroup code, so those would
be questions for the author. I was aware of some of the bugs, and also was
aware enough of your patches to warn you and the devs that they were leaving
problems unfixed. Why it got merged anyway you have to ask Chris or Josef.

As far as testing I can easily show that you didn't test the most basic
cases of snapshot create or snapshot delete with your qgroup rewrite. This
understandbly gives me pause when you're asking for a large patch set to be
included in the next kernel.


Taking your history with qgroups out of this btw, my opinion does not
change.

With respect to in-memory only dedupe, it is my honest opinion that such a
limited feature is not worth the extra maintenance work. In particular
there's about 800 lines of code in the userspace patches which I'm sure
you'd want merged, because how could we test this then?

A couple examples sore points in my review so far:

- Internally you're using a mutex (instead of a spinlock) to lock out queries
 to the in-memory hash, which I can see becoming a performance problem in the
 write path.

- Also, we're doing SHA256 in the write path which I expect will
 slow it down even more dramatically. Given that all the work done gets
 thrown out every time we fill the hash (or remount), I just don't see much
 benefit to the user with this.

Users can get better dedupe via the ioctl today than with what
you propose go in as an experimental feature so I don't see many people
caring to test it. IMHO you would have to provide a more compelling reason
to include this code.

Solve the hard problems first (dedupe with a disk backend, make in-memory
perform), then come asking for inclusion of your feature. Again, this I
would say about the patches regardless of whose name is on them.
	--Mark

--
Mark Fasheh
