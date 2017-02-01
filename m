Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51358 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751030AbdBAWtQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Feb 2017 17:49:16 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cZ3i6-0001zJ-CE
        for linux-btrfs@vger.kernel.org; Wed, 01 Feb 2017 23:49:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
Date: Wed, 1 Feb 2017 22:48:58 +0000 (UTC)
Message-ID: <pan$27de1$6045e2b1$7cc1684e$e9aac1ad@cox.net>
References: <54678ac94c95687e00485d41fa5b5bc9@server1.deragon.biz>
        <W75Sc6PDCBok7W75TcCgc7@videotron.ca>
        <51114ea93a0f76a5ff6621e4d8983944@server1.deragon.biz>
        <fab34ac1-03c0-76ea-eac2-ef4a210a48de@gmail.com>
        <07bba687-64c3-6713-6f6a-c8da183cbd3d@gmail.com>
        <YAvBcoM9EImXYYAvCcegSf@videotron.ca>
        <a5262907-06f2-2c6f-d23a-2703b10429b7@deragon.biz>
        <pan$be2e$8a233bb0$f63eb0cb$d3413db@cox.net>
        <20170201115530.l2ce5afcqld2kzi4@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Borowski posted on Wed, 01 Feb 2017 12:55:30 +0100 as excerpted:

> On Wed, Feb 01, 2017 at 05:23:16AM +0000, Duncan wrote:
>> Hans Deragon posted on Tue, 31 Jan 2017 21:51:22 -0500 as excerpted:
>> > But the current scenario makes it difficult for me to put redundancy
>> > back into service!  How much time did I waited until I find the
>> > mailing list, subscribe to it, post my email and get an answer?
>> > Wouldn't it be better if the user could actually add the disk at
>> > anytime, mostly ASAP?
>> > 
>> > And to fix this, I have to learn how to patch and compile the kernel.
>> > I have not done this since the beginning of the century.  More
>> > delays,
>> > more risk added to the system (what if I compile the kernel with the
>> > wrong parameters?).
>> 
>> The patch fixing the problem and making return from degraded not the
>> one-
>> shot thing it tends to be now will eventually be merged
> 
> Not anything like the one I posted to this thread -- this one merely
> removes a check that can't handle this particular (common) case of an
> otherwise healthy RAID that lost one device then was mounted degraded
> twice.  We need instead a better check, one that sees whether every
> block group is present.
> 
> This can be done quite easily, as as far as I know, the list of block
> group is at that moment fully present in memory, but someone actually
> has to code that, and I for one don't know btrfs internals (yet?).

I didn't mention it because you spared me the trouble with your hack-
patch that did the current job, but FWIW, there's actually a patch that 
does per-chunk testing as you indicate, but it got merged into a longer 
running feature-add project (hot-spares, IIRC), and thus isn't likely to 
be mainline-merged until that project is merged.  

But who knows when that might be?  Could be years before it is considered 
ready.

Meanwhile, perhaps it's simply because I'm not a dev and am not 
appreciating the complexities of some detail or other, but as 
demonstrated by the people who have local-merged that patch to get out of 
just this sort of jam, as well as the continuing saga of more and more 
people appearing here with the same problem, it could be an arguably high 
priority fix on its own, and should have been reviewed and ultimately 
mainline-merged on its own merits, instead of being stuck in someone's 
feature-add project queue for potentially years, while more and more 
people who could have definitely used it have to either suffer without it 
or go and find and local-merge it themselves.  Even if this feature is 
critical to the longer term feature, merge of this little one now would 
make the final patch set for the longer term feature that much smaller.

But that's a btrfs-using sysadmin's viewpoint, not a developer viewpoint, 
and it's the developer's doing the work, so they get to define when and 
how it gets merged, and us non-devs must either simply live with it, or 
if the circumstances allow, fund some dev to have our specific interests 
as their priority and take care of it for us.

Meanwhile, perhaps I should have bookmarked that patch at least as it 
appeared on-list, but I didn't, so while I know it exists, I too would 
have to go looking to actually find it, should I end up needing it.  In 
my defense, I /thought/ the immediate benefit was obvious enough that it 
would be mainline-merged by now, not hoovered-up into some long-term 
project with no real hint as to /when/ it might be merged.  Oh, well...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

