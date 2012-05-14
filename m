From: David Sterba <dave@jikos.cz>
Subject: Re: Subdirectory creation on snapshot
Date: Mon, 14 May 2012 14:08:52 +0200
Message-ID: <20120514120852.GH25501@twin.jikos.cz>
References: <821DC50D-8451-4AD1-8CCA-DE1238D4788B@gmail.com>
 <20120509165802.GN19331@twin.jikos.cz>
 <F39B4ABB-65D7-467D-BB57-FD9EBB70F1FB@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: Brendan Smithyman <smithyman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <F39B4ABB-65D7-467D-BB57-FD9EBB70F1FB@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 09, 2012 at 10:38:30AM -0700, Brendan Smithyman wrote:
> If I understand you correctly, this would be the case with nested
> subvolumes; i.e., if subvolume A is exists within the directory tree
> subvolume B, and B is snapshotted.  I expected this, and it sounds
> totally consistent with my understanding of how btrfs subvolumes work.
> However, the behaviour I'm seeing seems to be a different thing, so I
> just want to double-check:

I've read again your first post and indeed it's not the empty subvol
issue.

> In my case I am executing the "btrfs subvolume snapshot @working
> newsnapshot" command (or something like it).  The "@working" subvolume
> exists in the filesystem root, and does not contain any other
> subvolumes within its own subdirectory tree.  In the new subvolume,
> "newsnapshot", there is an entry called "@working" that is identified
> as inode number 2 as you say.  But this isn't due to a subvolume in
> the directory tree of the original "@working", since it still happens,
> e.g., if it is the only subvolume on the system (apart from the root,
> of course).

So I followed the steps to reproduce it with a 3.4 kernel, but I don't
see the duplicated @working anywhere.

# btrfs subvol create @working
# ls @working
src/
# btrfs subvol snap @working 2012-05-14
# btrfs subvol snap @working test
# ls test/
src/

# btrfs subvol list .
ID 258 top level 5 path @working
ID 259 top level 5 path 2012-05-14
ID 260 top level 5 path test


> The naive assumption is that (excepting nested subvolumes), the
> snapshot should be indistinguishable from the original.  Additionally,
> I'm a bit perplexed by the behaviour on some of my volumes and not
> others.

Not a consistent behaviour then, so there's another factor.

Please run stat on the test/@working directory, if it's the ino == 2
(empty subvol) or not.

Do you do lot's of snapshots on the fs, or are there lots of data plus
the filesystem is ~80% full? I have a theory, that this can somehow
interact with background subvolume deletion: if a subvolume is deleted
from directory hierarchy, but just scheduled for deletion, reusing it's
name could be incorrectly taken as part of the dir hierarchy to snapshot
and thus the extra '@working' is created.

In your environment this would mean that there was a subvolume 'test',
then deleted, still in the queue for actual deletion. Slow snapshot
deletion may come from large number of them and this is even slower when
the filesystem is fragmented or near full.

> It's not a big deal, and I'm happy to take your word for it
> (or look at the code, if you'd be willing to point me in the right
> direction; I'm not averse to learning).  I just wanted to double-check
> that we're talking about the same thing.

Seems more like a bug, let's narrow down the conditions before we look
into the code.


thanks,
david
