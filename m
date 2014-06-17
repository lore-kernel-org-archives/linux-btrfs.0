Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34054 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbaFQO76 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 10:59:58 -0400
Date: Tue, 17 Jun 2014 07:59:57 -0700
From: Marc MERLIN <marc@merlins.org>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: frustrations with handling of crash reports
Message-ID: <20140617145957.GH19071@merlins.org>
References: <20140519134915.GA27432@merlins.org> <539FE03F.5030306@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <539FE03F.5030306@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 17, 2014 at 03:29:19PM +0900, Satoru Takeuchi wrote:
> after that? Here try to reproduce with 3.16-rc1 is desirable.

As for 3.16-rc1, my problem, and this is not targetted at you, just a
general unfortunate observation of my last months of btrfs testing and
reorts.

I use btrfs on real systems. I have backups, but having crashes is both
inconvenient and time consuming since it's my real data and systems I need
and use, and where a crash at the wrong time can be quite inconvenient, as
well as cost me hours of time to recover.
I get to pick between staying 1 or 2 kernel versions back and being told
that all my reports are useless because the kernel is too old, and running
unstable kernels and unfortuantely still have at least 50% of my reports not
looked at.

I signed up for that when using btrfs, but at least 50% of the time, when I
went through this, and reported the problems (which took more time since
it's not a test system in a VM or with serial console), the reports were
ignored, or looked like they were.
The other half of the time, I was indeed told to use an even more
unstable/unproven version of btrfs, assuming the one I was running wasn't
already unstable/unproven enough.

There is no right answer here, I understand that in their limited time
developers are working on new code or maybe fixing existing code.
However, if they are interested in real users with real data brave
enough to run recent code, my wish would be for more support and timely
interest when severe hang problems are reported, or corruption.

Case in point: I just reported a FS last week that oopsed btrfs, and worse
that crashed 3.15 (the problem is still there, but the symptom is worse in
3.15), and got no answer from anyone carying about the filesystem.
I asked a 2nd time before deleting it, no one answered.

It took me 2h during my work day (which isn't supposed to be related to
testing btrfs) to even capture that, and now I regret even having bothered
because it looks like no one cared.
Next time it happens again, I likely won't waste my time to report it and
get back to work, potentially reverting the FS to something other than btrfs
:(

Similarly I've seen other posts from people reporting corruption, data loss,
and getting no answer or feedback at all.

I realize that the developers can't put hours of personal time chasing each
(sometimes incomplete) report sent to the list, but my point is that if user
reports or crashes and data loss seemingly get so little attention, this is
going to put off a lot of early users who will get burnt, remember the bad
experience, and not come back. I already know some who have, some of which
have even told me "why do you even still bother using btrfs for your data".

Btrfs is labelled as experimental, no one has a right to complain if data is
lost, but my suggestion is for developers to allocate a bit more time to
looking at user reports, especially if they spent time getting the crash
data and trying to give useful information.

It is also ok to answer "Any FS created or used before kernel 3.x can be
corrupted due to bugs we fixed in 3.y, thank you for your report but it's
not a good use of our time to investigate this"
(although newer kernels should not just crash with BUG(xxx) on unexpected
data, they should remount the FS read only).

Maybe it would make sense for some developers to clean those up, and do some
kind of unofficial rotation of list monitoring to gather important reports
from users and act on the ones that have useful data or at least get back to
users who reported a crash on code that is known to have corruption or
deadlock problems that were fixed in newer kernels.

Again, this was not targeted at your answer, I do thank you for trying to
help.
Thanks to all for reading.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
