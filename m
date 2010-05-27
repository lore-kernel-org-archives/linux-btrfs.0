From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] Btrfs updates
Date: Thu, 27 May 2010 10:47:22 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.1005271036400.3689@i5.linux-foundation.org>
References: <20100527151515.GA3835@think> <alpine.LFD.2.00.1005271014570.3689@i5.linux-foundation.org> <20100527173220.GG3835@think>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100527173220.GG3835@think>
List-ID: <linux-btrfs.vger.kernel.org>



On Thu, 27 May 2010, Chris Mason wrote:
> 
> # git diff v2.6.34 HEAD | diffstat

That still has the potential to be wrong (but got the numbers I expected 
this time). It will be wrong in several cases:

 - "diffstat" has some random common prefix removal logic that I've never 
   figured out the exact rules for.

   You don't happen to see it, because you actually had changes outside of 
   fs/btrfs (so there was no common prefix to worry about), but if 
   everything had been inside fs/btrfs, then at least some versions of 
   diffstat will just remove that whole thing as common, and talk about 
   changes to 'ioctl.c' rather than 'fs/btrfs/ioctl.c'

   (And no, I'm not entirely sure what triggers it. It might only happen 
   for certain patterns and/or certain versions of diffstat, but it's a 
   reason to avoid diffstat in general, or at least use "-p1" to make it 
   reliable)

 - it will do the wrong thing for renames and copies.

 - it doesn't give the summary that pull-request does, which talks about 
   new, deleted and file-mode-changed files.

So just do

	git diff --stat --summary -M v2.6.34..HEAD

instead, which gets all the above cases right. Also, you don't even need 
to remember where you started - you might as well use git to do that too, 
and write it as (assuming you have an 'origin' branch that points to the 
upstream tree):

	git diff --stat --summary -M origin...HEAD

(note the *three* dots: that says that you should diff against the common 
ancestor, so git will just figure out where you started on its own).

		Linus
