From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Suitability for "playing with"?
Date: Tue, 13 May 2008 11:03:11 -0400
Message-ID: <200805131103.11512.chris.mason@oracle.com>
References: <49232.66.155.201.114.1210687249.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: "Ken D'Ambrosio" <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49232.66.155.201.114.1210687249.squirrel@webmail.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 13 May 2008, Ken D'Ambrosio wrote:
> Hi, all.  While I'm anxious to try out btrfs on my
> (personal/non-production) systems, I'm not anxious to have to
> restore/reformat them on a regular basis.  Has btrfs reached a point where
> it doesn't, say, crash on disk full?

Unfortunately, disk full is still on the TODO list.  There is some very basic 
accounting to survive some disk full conditions, but it is still easy to 
crash if you hammer on a full drive.  My focus this month is on tree 
concurrency, so disk full won't be in the list for a little while.

> The development timeline in the wiki 
> has lots of neat milestones, but no mention about "suitability for
> end-user use in testing."  I understand all of this is wildly nebulous,
> but some idea of when it might go from "probably will break" to "might not
> break" would be appreciated by us lowly fans of what looks to be the
> neatest Linux-based FS on the block.

Everyone has their own ideas of when they are willing to try things out, so I 
didn't fill in an entry in the milestones page for it.

I started using stable btrfs releases for my own home directory a while ago, 
and have had very few problems.  But I also backup everything on a very 
regular basis, just in case.

So, I expect each of the stable releases to be in the 'probably won't break' 
category, but mistakes are always possible.  We're building up a larger QA 
setup that will help find problems before they hit our friendly alpha 
testers, but we aren't there yet.

-chris
