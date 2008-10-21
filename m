From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 18:27:10 +0200
Message-ID: <20081021182710.a12f4914.skraw@ithnet.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
	<1224597580.27474.93.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224597580.27474.93.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris, 

let me clarify some things a bit, see ...

On Tue, 21 Oct 2008 09:59:40 -0400
Chris Mason <chris.mason@oracle.com> wrote:

> Thanks for this input and for taking the time to post it.
> 
> > 1. filesystem-check
> > 1.1 it should not
> >     - delay boot process (we have to wait for hours currently)
> >     - prevent mount in case of errors
> >     - be a part of the mount process at all
> >     - always check the whole fs
> 
> For this, you have to define filesystem-check very carefully.  In
> reality, corruptions can prevent mounting.  We can try very very hard to
> limit the class of corruptions that prevent mounting, and use
> duplication and replication to create configurations that address the
> remaining cases.

What we would like to have is a possibility to check an already mounted and
active fs for corruption, that's the reporting part.
If some corruption is found we should be able to correct the
data/metadata/whatever on the _still active_ fs, lets say by starting fsck in
modify mode. It is often preferred not to do a run over the complete fs but
only over certain (already known-to-be-corrupted) parts/subtrees.
It is obvious that the fs should not go offline then even if something very
ugly happens.
You can imagine:
Run fsck via cron every night. Then look at the logs in the morning an if bad
news arrived try to correct the broken subtree or exclude it from further
usage.

> In general, we'll be able to make things much better than they are
> today.

I am pretty sure about that ;-)

> > 1.2 it should be able 
> >     - to always be started interactively by user
> >     - to check parts/subtrees of the fs
> >     - to run purely informational (reporting, non-modifying)
> >     - to run on a mounted fs
> 
> Started interactively?  I'm not entirely sure what that means, but in
> general when you ask the user a question about if/how to fix a
> corruption, they will have no idea what the correct answer is.

see above explanation. We don't expect the classical y/n-questions during
fsck. Honestly there are only 3 types of modification modes in fsck:
- try correction in place
- exclude (i.e. delete) whole problem subtree
- duplicate to another subtree whatever can be rescued from the original place
  (and leave problem subtree as-is)

> > 2. general requirements
> >     - fs errors without file/dir names are useless
> >     - errors in parts of the fs are no reason for a fs to go offline as a whole
> 
> These two are in progress.  Btrfs won't always be able to give a file
> and directory name, but it will be able to give something that can be
> turned into a file or directory name.  You don't want important
> diagnostic messages delayed by name lookup.

That's a point I really never understood. Why is it non-trivial for a fs to
know what file or dir (name) it is currently working on?
It really sounds strange to me that a layer that is managing files on some
device does not know at any time during runtime what file or dir it is
actually handling. If _it_ does not know, how should the _user_ probably hours
later reading the logs know based on inode numbers or whatever cryptic logs
are thrown out? I mean filenames are nothing more than a human-readable
describing data structure mostly type char. Its only reason of existance is
readability, why not in logs?

> 
> >     - mounting must not delay the system startup significantly
> 
> Mounts are fast
> 
> >     - resizing during runtime (up and down)
> 
> Resize is done
> 
> >     - parallel mounts (very important!)
> >       (two or more hosts mount the same fs concurrently for reading and
> >       writing)
> 
> As Jim and Andi have said, parallel mounts are not in the feature list
> for Btrfs.  Network filesystems will provide these features.

Can you explain what "network filesystems" stands for in this statement,
please name two or three examples.

> >     - journaling
> 
> Btrfs doesn't journal.  The tree logging code is close, it provides
> optimized fsync and O_SYNC operations.  The same basic structures could
> be used for remote replication.
> 
> >     - versioning (file and dir)
> 
> >From a data structure point of view, version control is fairly easy.
> >From a user interface and policy point of view, it gets difficult very
> quickly.  Aside from snapshotting, version control is outside the scope
> of btrfs.
> 
> There are lots of good version control systems available, I'd suggest
> you use them instead.

To me versioning sounds like a not-so-easy-to-implement feature. Nevertheless
I trust your experience. If a basic implementation is possible and not too
complex, why deny a feature? 

> >     - undelete (file and dir)
> 
> Undelete is easy

Yes, we hear and say that all the time, name one linux fs doing it, please.

> but I think best done at a layer above the FS.

Before we got into the linux community we used n.vell netware. Undelete has
been there since about the first day. More then ten years later (nowadays) it
is still missing in linux. I really do suggest to provide _some_ solution and
_then_ lets talk about the _better_ solution.

> >     - snapshots
> 
> Done
> 
> >     - run into hd errors more than once for the same file (as an option)
> 
> Sorry, I'm not sure what you mean here.

If your hd is going dead you often find out that touching broken files takes
ages. If the fs finds out a file is corrupt because the device has errors it
could just flag the file as broken and not re-read the same error a thousand
times more. Obviously you want that as an option, because there can be good
reasons for re-reading dead files...

> >     - map out dead blocks
> >       (and of course display of the currently mapped out list)
> 
> I agree with Jim on this one.  Drives remap dead sectors, and when they
> stop remapping them, the drive should be replaced.

If your life depends on it, would you use one rope or two to secure yourself?

> 
> >     - no size limitations (more or less)
> >     - performant handling of large numbers of files inside single dirs
> >       (to check that use > 100.000 files in a dir, understand that it is
> >       no good idea to spread inode-blocks over the whole hd because of seek
> >       times)
> 
> Everyone has different ideas on "large" numbers of files inside a single
> dir.  The directory indexing done by btrfs can easily handle 100,000

The story is not really about if it can but how fast it can. You know that
most time is spent in seeks these days. If you have 100000 blocks to read
right across the whole disk for scanning through a dir (fstat every file) you
will see quite a difference to a situation where the relevant data can be read
within few (or zero) seeks. Its a question of fs layout on the disk.

> >     - power loss at any time must not corrupt the fs (atomic fs modification)
> >       (new-data loss is acceptable)
> 
> Done.  Btrfs already uses barriers as required for sata drives.
> [...]
> -chris

-- 
Regards,
Stephan

