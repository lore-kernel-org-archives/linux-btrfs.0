From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 16:58:15 -0400
Message-ID: <1240952295.15136.73.camel@think.oraclecorp.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de>
	 <200904281945.10274.hjclaes@web.de>
	 <20090428201619.GK7217@cip.informatik.uni-erlangen.de>
	 <200904282236.07428.hjclaes@web.de>
	 <20090428205242.GA13112@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Heinz-Josef Claes <hjclaes@web.de>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090428205242.GA13112@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-04-28 at 22:52 +0200, Thomas Glanzmann wrote:
> Hello Heinz,
> 
> > I wrote a backup tool which uses dedup, so I know a little bit about
> > the problem and the performance impact if the checksums are not in
> > memory (optionally in that tool).
> > http://savannah.gnu.org/projects/storebackup
> 
> > Dedup really helps a lot - I think more than I could imagine before I
> > was engaged in this kind of backup. You will not beleve how many
> > identical files are in a filesystem to give a simple example.
> 
> I saw it with my own yes (see my previous e-mail).
> 
> > EMC has very big boxes for this with lots of RAM in it.  I think the
> > first problem which has to be solved is the memory problem.  Perhaps
> > something asynchronous to find identical blocks and storing the
> > checksums on disk?
> 
> I think we already have a very nice solution in order to solve that
> issue:
> 
>         - Implement a system call that reports all checksums and unique
>           block identifiers for all stored blocks.
> 

This would require storing the larger checksums in the filesystem.  It
is much better done in the dedup program.

>         - Implement another system call that reports all checksums and
>           unique identifiers for all stored blocks since the last
>           report. This can be easily implemented:

This is racey because there's no way to prevent new changes.

> 
>           Use a block bitmap for every block on the filesystem use one
>           bit. If the block is modified set the bit to one, when a
>           bitmap is retrieved simply zero it out:

>         Assuming a 4 kbyte block size that would mean for a 1 Tbyte
>         filesystem:
> 
>         1Tbyte / 4096 / 8 = 32 Mbyte of memory (this should of course
>         be saved to disk from time to time and be restored on startup).
> 

Sorry, a 1TB drive is teeny, I don't think a bitmap is practical across
the whole FS.  Btrfs has metadata that can quickly and easily tell you
which files and which blocks in which files have changed since a given
transaction id.  This is how you want to find new things.

But, the ioctl to actually do the dedup needs to be able to verify a
given block has the contents you expect it to.  The only place you can
lock down the pages in the file and prevent new changes is inside the
kernel.

-chris


