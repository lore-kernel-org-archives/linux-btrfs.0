From: Chris Mason <chris.mason@oracle.com>
Subject: Re: What do the arguments of btrfs filesystem defragment do?
Date: Wed, 15 Dec 2010 14:08:32 -0500
Message-ID: <1292439708-sup-2951@think>
References: <4D08E76B.40400@logtenberg.eu>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Erik Logtenberg <erik@logtenberg.eu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D08E76B.40400@logtenberg.eu>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Erik Logtenberg's message of 2010-12-15 11:06:03 -0500:
> Hi,
> 
> I would like to know that the arguments of "btrfs filesystem defragment"
> do. According to the built-in help page, the invocation is as follows:
> 
> >         btrfs filesystem defragment [-vcf] [-s start] [-l len] [-t
> >                 size] <file>|<dir> [<file>|<dir>...]
> >                 Defragment a file or a directory.
> 
> Unfortunately I can't find any documentation on the meaning of these
> arguments. The man page doesn't list these arguments:

-v is verbose.  It just prints the file name as it defrags
-c forces compression, even if you are mounted without compression on

-s is the starting byte you want to defrag in the file.  This is useful
for very large files that are only compressed in a particular spot

-l is the number of bytes you want to compress, would be paired with -s

-t is a threshold.  If the extent is bigger than this threshold, we
consider it defragged already.

-f starts the IO right away.

> 
> >       filesystem defragment <file>|<dir> [<file>|<dir>...]
> >              Defragment files and/or directories.
> 
> Also the online documentation [1] is identical to the man page.
> 
> [1] https://btrfs.wiki.kernel.org/index.php/Btrfs(command)
> 
> On a somewhat related note I did find another page on the wiki [2] that
> explains a bit on the defragmenting subject, more specifically it
> mentions this rather important caveat:
> 
> > Caveat: Defragmenting a file which has a COW copy (either a snapshot
> > copy or one made with bcp or cp --reflinks) will produce two unrelated
> > files. If you defragment a subvolume that has a snapshot, you will
> > roughly double the disk usage, as the snapshot files are no longer COW
> > images of the originals.
> 
> [2] https://btrfs.wiki.kernel.org/index.php/Problem_FAQ
> 
> >From what I've heard on IRC this is still the case in current versions,
> but the Btrfs(command) documentation contains no mention of this.

This is still true.

> 
> I hope someone can shed some light on these subjects.
> 

Hope this makes sense ;)

-chris
