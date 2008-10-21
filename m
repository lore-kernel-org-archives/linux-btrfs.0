From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 16:22:49 +0200
Message-ID: <20081021162249.30a25bcb.skraw@ithnet.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
	<87vdvmdu36.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87vdvmdu36.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 21 Oct 2008 14:13:33 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Stephan von Krawczynski <skraw@ithnet.com> writes:
> 
> > reading the list for a while it looks like all kinds of implementational
> > topics are covered but no basic user requests or talks are going on. Since I
> > have found no other list on vger covering these issues I choose this one,
> > forgive my ignorance if it is the wrong place.
> > Like many people on the planet we try to handle quite some amounts of data
> > (TBs) and try to solve this with several linux-based fileservers.
> > Years of (mostly bad) experience led us to the following minimum requirements
> > for a new fs on our servers:
> 
> If that are the minimum requirements, what are the maximum ones?
> 
> Also you realize that some of the requirements (like parallel read/write
> aka a full cluster file system) are extremly hard?
> 
> Perhaps it would make more sense if you extracted the top 10 items
> and ranked them by importance and posted again.

Hello Andi,

thanks for your feedback. Understand "minimum requirement" as "minimum
requirement to drop the current installation and migrate the data to a
new fs platform".
Of course you are right, dealing with multiple/parallel mounts can be quite a
nasty job if the fs was not originally planned with this feature in mind.
On the other hand I cannot really imagine how to deal with TBs of data in the
future without such a feature.
If you look at the big picture the things I mentioned allow you to have
redundant front-ends for the fileservice doing the same or completely
different applications. You can use one mount (host) for tape backup purposes
only without heavy loss in standard file service. You can even mount for
filesystem check purposes, a box that does nothing else but check the
structure and keep you informed what is really going on with your data - and
your data is still in production in the meantime.
Whatever happens you have a real chance of keeping your file service up, even
if parts of your fs go nuts because some underlying hd got partially damaged.
Keeping it up and running is the most important part, performance is only
second on the list.
If you take a close look there are not really 10 different items on my list,
depending on the level of abstraction you prefer, nevertheless:

1) parallel mounts
2) mounting must not delay the system startup significantly
3) errors in parts of the fs are no reason for a fs to go offline as a whole
4) power loss at any time must not corrupt the fs
5) fsck on a mounted fs, interactively, not part of the mount (all fsck
features)
6) journaling
7) undelete (file and dir)
8) resizing during runtime (up and down)
9) snapshots
10) performant handling of large numbers of files inside single dirs


-- 
Regards,
Stephan

