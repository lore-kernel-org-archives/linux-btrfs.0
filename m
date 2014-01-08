Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43268 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbaAHJp7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 04:45:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W0pi1-0004HS-Vl
	for linux-btrfs@vger.kernel.org; Wed, 08 Jan 2014 10:45:58 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jan 2014 10:45:57 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jan 2014 10:45:57 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Date: Wed, 8 Jan 2014 09:45:35 +0000 (UTC)
Message-ID: <pan$a60b1$5fc9199b$bfabd8f7$3adedec@cox.net>
References: <20140105134425.22063890@ws>
	<20140108032258.GT10936@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Tue, 07 Jan 2014 19:22:58 -0800 as excerpted:

> On Fri, Jan 03, 2014 at 09:34:10PM +0000, Duncan wrote:
>> IIRC someone also mentioned problems with autodefrag and an about 3/4
>> gig systemd journal.  My gut feeling (IOW, *NOT* benchmarked!) is that
>> double-digit MiB files should /normally/ be fine, but somewhere in the
>> lower triple digits, write-magnification could well become an issue,
>> depending of course on exactly how much active writing the app is doing
>> into the file.
>  
> When I defrag'ed my 83GB vm file with 156222 extents, it was not in use
> or being written to.

Note the scale... I said double-digit _MiB_ should be fine, but somewhere 
in the triple-digits write magnification likely becomes a problem (this 
based on my memory of someone mentioning an issue with a 3/4 gig systemd 
journal file).

You then say 83 _GB_, which may or may not be GiB, but either way, it's 
three orders of magnitude above the scale I said should be fine, and two 
orders of magnitude above the scale at which I said problems likely start 
appearing.

So problems at that size are a given.

> On Sun, Jan 05, 2014 at 10:09:38AM -0700, Chris Murphy wrote:

>> I've found, open to other suggestions though, is +C xattr on
> 
> So you're saying that defragmentation has known performance problems
> that can't get fixed for now, and that the solution is not to get
> fragmented or recreate the relevant files.
> If so, I'll go ahead, I just wanted to make sure I didn't have useful
> debug state before clearing my problem.

Basically, yes.  One of the devs said he's just starting to focus on it 
again now.  So it's a known issue that'll take some work to make better.  
However, since he's focusing on it again now, now's the time to report 
stuff like the sysrq+w trace mentioned.

> On Sun, Jan 05, 2014 at 01:44:25PM -0700, Duncan wrote:
>> [I normally try to reply directly to list but don't believe I've seen
>> this there yet, but got it direct-mailed so will reply-all in
>> response.]
>  
> I like direct Cc on replies, makes my filter and mutt coloring happier
> :)
> Dupes with the same message-id are what procmail and others were written
> for :)

Some of us think this sort of list works best as a public newsgroup... 
such distributed discussion is what they were designed for, after all... 
and that keeps it separate from actual email.  That's where gmane.org 
comes in with its list2news (as well as list2web) archiving service.  We 
subscribe to our lists as newsgroups there, use a news/nntp client for 
it, and save our email client for actually handling (more private) email.

If you watch, you'll see links to particular messages on the gmane web 
interface posted from time to time.  For those using gmane's list2news 
service (and obviously for those using its web interface as well) that's 
real easy, since gmane adds a header with the web link to messages it 
serves on the news interface as well.  I've been using gmane for perhaps 
a decade now, but apparently it's more popular for people on this list 
than I might have expected from other lists, since I see more of those 
gmane web links posted.

But I've also noticed that a lot more people on this list want CCed/
direct-mailed too, not just to read it on the list.  I generally do that 
when I see the explicit request, but /only/ when I see the explicit 
request.

>> I now believe the lockup must be due to processing the hundreds of
>> thousands of extents on all those snapshots, too
> 
> That's a good call. I do have this:
> gandalfthegreat:/mnt/btrfs_pool1# ls var var/                         
> var_hourly_20140105_16:00:01/ var_daily_20140102_00:01:01/ 
> var_hourly_20140105_17:00:26/ var_daily_20140103_00:59:28/ 
> var_weekly_20131208_00:02:02/ var_daily_20140104_00:01:01/ 
> var_weekly_20131215_00:02:01/ var_daily_20140105_00:33:14/ 
> var_weekly_20131229_00:02:02/ var_hourly_20140105_05:00:01/
> var_weekly_20140105_00:33:14/
> 
>> I don't actually make very extensive use of
>> snapshots here anyway, so I didn't think about that aspect originally,
>> but that's gotta be what's throwing the real spanner in the works,
>> turning a possibly long but workable normal defrag (O(1)) into a lockup
>> scenario (O(n)) where virtually no progress is made as currently coded.
> 
> That is indeed what I'm seeing, so it's very possible you're right.

That's where the evidence is pointing, ATM.  Hopefully the defrag work 
they're doing now will turn snapshotted defrag back into O(1), too.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

