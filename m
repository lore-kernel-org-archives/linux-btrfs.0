Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:41742 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbaLKWAZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 17:00:25 -0500
Message-ID: <548A13F7.30904@pobox.com>
Date: Thu, 11 Dec 2014 14:00:23 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Patrik Lundquist <patrik.lundquist@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: A note on spotting "bugs" [Was: ENOSPC after conversion]
References: <CAA7pwKNhYxeQjfTyd4WQrsQ7MuapKgRfjwF3kHY+VWDnVk+cTA@mail.gmail.com>
In-Reply-To: <CAA7pwKNhYxeQjfTyd4WQrsQ7MuapKgRfjwF3kHY+VWDnVk+cTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/11/2014 12:18 AM, Patrik Lundquist wrote:
> * Full balance, that ended with "98 enospc errors during balance."

Assuming that quote is an actual quote from the output of the balance...

We can strongly infer that this sort of occurrence is expected since 
there is code to keep track of it and report the total times it happened.

"Bugs" are unexpected things that cause failures and/or damage.

Expected but non-optimal things that print summaries of their 
occurrences tend to be "expected unpleasantness that has been explored 
by the programmer, causes no harm, and is not worth fixing", which is 
different thing than a bug. It's a "No Useful Options".

Cant Fix and Wont Fix events lie somewhere above that on the programmers 
scale that goes from perfect execution to absolute train-wreck bug.

Were I the programmer I might have written this as "98 extents skipped 
due to space constraints (ENOSPC)".

I won't be offering a patch to that effect, however, as there may be 
other kinds of expected ENOSPC events contributing to that counter, so 
re-writing the summary text could be making untrue statements.

I've been have been chasing this with you because your statement that 
"-dusage=99 works, but not -dusage=100". But the message above tells me 
that your characterization as "not working" is somewhat overstating 
things. It _worked_ with -dusage=100 in that it didn't abort, crash, 
trash data, or hang. It just had to skip some elements due to well 
understood (by the implementor) and fully reported conditions.

So lets explore what the system "could have done" instead of just 
skipping those extents...

It could have tried to break the extent into smaller pieces. But to do 
that it would have to dissect the contents of the extent and go looking 
for ways to repack them into two or more smaller extents. Those 
candidate extents would have to be allocated based on guesses before the 
attempt because other writers might steal the space if you don't 
preallocate. This could involve repeated retries and result in taking 
one big extent and exploding it into any number of tiny extents. 
Performing this task could take unbounded time. In computer science it's 
an NP-complete function of arbitrary complexity sometimes called "the 
floppy problem" (a name that is impossible to google usefully, it seems, 
because the word floppy is search poison 8-) ).

The Floppy Problem :: so called because one of the original formulations 
was "how many floppy disks do I need to optimally pack these files 
without having to cut up the files themselves?" Indeed multi-floppy 
"Zip" programs were invented to skip that whole painful mess so people 
could just ship their software. 8-)

If you start reading here 
http://en.wikipedia.org/wiki/Cutting_stock_problem and work your way 
back through the knapsack problem you'll get a glimpse how ugly this 
sort of corner case can get.

In our case the "roll" being "cut" is the donor extent and the possible 
widths/sizes are the discernible gaps in the raw extent map and the 
constraint is that we can't break cut any of the internally allocated 
regions within the extent (we can only relocate them not break them up 
because that could lead to needing to allocate more metadata space in 
the extent tree which could invalidate our planned cuts etc till the end 
of time.)

So it is a problem that _can_ be solved programatically, but it's not a 
problem that is worth the time to solve either in programmer hours or in 
disk write hours.

So yea... It's big, It's valid, and you've got no single place to copy 
it to that is equally big, so it gets skipped.

Not a bug.

