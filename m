From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs: block rsv returned -28
Date: Sat, 25 Feb 2012 04:55:45 +0000 (UTC)
Message-ID: <pan.2012.02.25.04.55.45@cox.net>
References: <4F4846E1.50307@polymtl.ca>
	<CAE5mzvhzsHDU=HU9_MTcp8ptA25tcn7HkxqOE1SNqznvRk9eMQ@mail.gmail.com>
	<4F484BB8.2090601@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Christian Robert posted on Fri, 24 Feb 2012 21:47:20 -0500 as excerpted:

> wrong, I tryed to wait until "Load average" got near to zero (couple of
> minutes)
> before unmounting and it changed nothing. None of thoses subvolumes have
> any data inside so deleting should be trivial and quick.
> 
> Got the kernel backtrace "while" doing the deletes. Not after.

Please don't top post.  It makes replying in context nearly impossible.  
Here, I quote your reply, but the context in which it was made gets lost 
because you top-posted instead of replying inline, at the appropriate 
place based on context, or bottom-posting if it's not /too/ long (it 
isn't, bottom posting would have been fine, in this case) and you can't 
be bothered to trim to context appropriately.

cwillu is correct.  The subvolume deletes do happen in the background and 
it can delay unmounting, in cases like this 10K subvolumes scenario, 
significantly.  There was some discussion of that recently on another 
thread, along with a patch so the unmounting is allowed (for shutdown, 
etc) and the cleanup picked up again after remounting,  But it was recent 
enough the patch will have only just made it into 3.3-prerelease kernel 
mainline (probably with Chris's pull request to Linus from less than 12 
hours ago, as CCed to this list, I'm not sure Linus has actually pulled 
it yet), or may be delayed until the 3.4 commit window.

Never-the-less, you have a point about the backtraces happening while 
doing the deletes.  That's a problem that the allow unmount and finish 
cleanup later patch wouldn't have addressed by itself, but it's possible 
other recent patches address it (especially since the pull includes a lot 
of fixes based on Oracle's current intensive btrfs internal QA testing), 
so I'd suggest doing a git pull in a few hours, checking that Linus has 
applied Chris's pull request (this assumes you're running mainline 
kernel, of course), and after that's applied and you're running the new 
kernel with it, rerunning your test.  If it still backtraces at that 
point then yeah, it's worth further investigation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

