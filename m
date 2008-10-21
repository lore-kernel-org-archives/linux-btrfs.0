From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 09:59:40 -0400
Message-ID: <1224597580.27474.93.camel@think.oraclecorp.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081021132322.271ad728.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-10-21 at 13:23 +0200, Stephan von Krawczynski wrote:
> Hello all,
> 
> reading the list for a while it looks like all kinds of implementational
> topics are covered but no basic user requests or talks are going on. Since I
> have found no other list on vger covering these issues I choose this one,
> forgive my ignorance if it is the wrong place.
> Like many people on the planet we try to handle quite some amounts of data
> (TBs) and try to solve this with several linux-based fileservers.
> Years of (mostly bad) experience led us to the following minimum requirements
> for a new fs on our servers:
> 

Thanks for this input and for taking the time to post it.

> 1. filesystem-check
> 1.1 it should not
>     - delay boot process (we have to wait for hours currently)
>     - prevent mount in case of errors
>     - be a part of the mount process at all
>     - always check the whole fs

For this, you have to define filesystem-check very carefully.  In
reality, corruptions can prevent mounting.  We can try very very hard to
limit the class of corruptions that prevent mounting, and use
duplication and replication to create configurations that address the
remaining cases.

In general, we'll be able to make things much better than they are
today.

> 1.2 it should be able 
>     - to always be started interactively by user
>     - to check parts/subtrees of the fs
>     - to run purely informational (reporting, non-modifying)
>     - to run on a mounted fs

Started interactively?  I'm not entirely sure what that means, but in
general when you ask the user a question about if/how to fix a
corruption, they will have no idea what the correct answer is.

> 2. general requirements
>     - fs errors without file/dir names are useless
>     - errors in parts of the fs are no reason for a fs to go offline as a whole

These two are in progress.  Btrfs won't always be able to give a file
and directory name, but it will be able to give something that can be
turned into a file or directory name.  You don't want important
diagnostic messages delayed by name lookup.

>     - mounting must not delay the system startup significantly

Mounts are fast

>     - resizing during runtime (up and down)

Resize is done

>     - parallel mounts (very important!)
>       (two or more hosts mount the same fs concurrently for reading and
>       writing)

As Jim and Andi have said, parallel mounts are not in the feature list
for Btrfs.  Network filesystems will provide these features.

>     - journaling

Btrfs doesn't journal.  The tree logging code is close, it provides
optimized fsync and O_SYNC operations.  The same basic structures could
be used for remote replication.

>     - versioning (file and dir)

>From a data structure point of view, version control is fairly easy.
>From a user interface and policy point of view, it gets difficult very
quickly.  Aside from snapshotting, version control is outside the scope
of btrfs.

There are lots of good version control systems available, I'd suggest
you use them instead.

>     - undelete (file and dir)

Undelete is easy but I think best done at a layer above the FS.

>     - snapshots

Done

>     - run into hd errors more than once for the same file (as an option)

Sorry, I'm not sure what you mean here.

>     - map out dead blocks
>       (and of course display of the currently mapped out list)

I agree with Jim on this one.  Drives remap dead sectors, and when they
stop remapping them, the drive should be replaced.

>     - no size limitations (more or less)
>     - performant handling of large numbers of files inside single dirs
>       (to check that use > 100.000 files in a dir, understand that it is
>       no good idea to spread inode-blocks over the whole hd because of seek
>       times)

Everyone has different ideas on "large" numbers of files inside a single
dir.  The directory indexing done by btrfs can easily handle 100,000

>     - power loss at any time must not corrupt the fs (atomic fs modification)
>       (new-data loss is acceptable)

Done.  Btrfs already uses barriers as required for sata drives.

> 
> Remember, this is not meant to be a request for features, it is a list that
> built up over 10 years of handling data and the failures we experienced. To
> our knowledge no fs meets this list, but hey, is that a reason for not talking
> about it? Our goal is pretty simple: maximize fs uptime.
> How does btrfs match?

-chris


