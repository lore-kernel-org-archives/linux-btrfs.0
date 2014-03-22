Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49122 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaCVVMA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 17:12:00 -0400
Date: Sat, 22 Mar 2014 14:11:59 -0700
From: Marc MERLIN <marc@merlins.org>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Send/Receive howto and script for others to use (was Re: Is anyone using btrfs send/receive)
Message-ID: <20140322211159.GM28005@merlins.org>
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk> <20131228180758.GF19863@merlins.org> <20140107104951.GL10936@merlins.org> <20140107105329.GE15634@carfax.org.uk> <20140108080206.GV10936@merlins.org> <20140321172904.GE28005@merlins.org> <532DE805.7040407@swiftspirit.co.za> <20140322200057.GJ28005@merlins.org> <532DFA60.3030106@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <532DFA60.3030106@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please consider adding a blank line between quotes, it makes them just a bit
more readable :)

On Sat, Mar 22, 2014 at 11:02:24PM +0200, Brendan Hide wrote:
> >- it doesn't create writeable snapshots on the destination in case you want
> >to use the copy as a live filesystem
> One of the issues with doing writeable snapshots by default is that the 
> backup is (ever so slightly) less safe from "fat-finger syndrome". If I 
> want a writeable snapshot, I'll make it from the read-only snapshot, 
> thereby reducing the chances of accidentally "tainting" or deleting data 
> in the backup. I actually *did* accidentally delete my entire filesystem 
> (hence the paranoid umounts). But, of course, my script *first* created 
> read-only snapshots from which recovery took only a few minutes. ;)

The writeable snapshot I create is on top of the read only one used by btrfs
receive. So, I can play with it, but it won't upset/break anything for
the backup.

The historical snapshots I keep give me cheap backups to go back to do get a
file I may have deleted 3 days ago and want back now even though my btrfs
send/receive runs hourly.

> >Things I noticed:
> >- I don't use ionice, maybe I should. Did you find that it actually made a
> >difference with send/receive?
> 
> This is just a habit I've developed over time in all my scripts. I 
> figure that if I'm using the machine at the time and the snapshot has a 
> large churn, I'd prefer the ionice. That said, the main test system is a 
> desktop which is likely to have much less churn than a server. In the 
> last two weeks the longest daily incremental backup took about 5 minutes 
> to complete, while it typically takes about 30 seconds only.

I'll consider that if I see too much load without ionice, thanks.

> >- Your comments say shlock isn't safe and that's documented. I don't see
> >that in the man page
> >http://manpages.ubuntu.com/manpages/trusty/man1/shlock.1.html
> That man page looks newer than the one I last looked at - specifically 
> the part saying "improved by Berend Reitsma to solve a race condition." 
> The previous documentation on shlock indicated it was safe for hourly 
> crons - but not in the case where a cron might be executed twice 
> simultaneously. Shlock was recommended by a colleague until I realised 
> this potential issue, thus my template doesn't use it. I should update 
> the comment with some updated information.

It's not super important, it was more my curiosity.
If a simple lock program in C isn't atomic, what's the point of it?
I never looked at the source code, but maybe I should...

> >I'd love to have details on this if I shouldn't be using it
> >- Is set -o noclobber; echo $$ > $lockfile really atomic and safer than
> >shlock? If so, great, although I would then wonder why shlock even exists 
> >:)
> The part that brings about an atomic lock is "noclobber", which sets it 
> so that we are not allowed to "clobber"/"overwrite" an existing file. 
> Thus, if the file exists, the command fails. If it successfully creates 
> the new file, the command returns true.
 
I understand how it's supposed to work, I just wondered if it was really
atomic as it should be since there would be no reason for shlock to even
exist with that line of code you wrote.

> I'd consider changing this mostly for the fact that depending on INN is 
> a very big dependency. There are other options as well, though I don't 
> think they're as portable as noclobber.

I totally agree, bringing INN to get shlock sucks a bit. I have shlock
stashed in /usr/local/bin so that I don't have to :)

Thanks for the info
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
