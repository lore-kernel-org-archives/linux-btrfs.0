From: Chris Mason <chris.mason@oracle.com>
Subject: Re: What do the arguments of btrfs filesystem defragment do?
Date: Wed, 15 Dec 2010 14:20:06 -0500
Message-ID: <1292440771-sup-9278@think>
References: <4D08E76B.40400@logtenberg.eu> <1292439708-sup-2951@think> <4D091387.9050905@logtenberg.eu>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Erik Logtenberg <erik@logtenberg.eu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D091387.9050905@logtenberg.eu>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Erik Logtenberg's message of 2010-12-15 14:14:15 -0500:
> Chris, thank you very much for your explanation. Indeed this clears
> things up a bit.
> 
> >>> Caveat: Defragmenting a file which has a COW copy (either a snapshot
> >>> copy or one made with bcp or cp --reflinks) will produce two unrelated
> >>> files. If you defragment a subvolume that has a snapshot, you will
> >>> roughly double the disk usage, as the snapshot files are no longer COW
> >>> images of the originals.
> >>
> >> [2] https://btrfs.wiki.kernel.org/index.php/Problem_FAQ
> >>
> >> >From what I've heard on IRC this is still the case in current versions,
> >> but the Btrfs(command) documentation contains no mention of this.
> > 
> > This is still true.
> 
> Is there a decent way to have btrfs compress already existing files
> (that were written before compression was enabled) without hurting any
> of the internal structures such as snapshots?

I'm afraid not yet.  There is code for this in the btrfs balance
routines, but we haven't yet adapted it to the defragment command.

-chris
