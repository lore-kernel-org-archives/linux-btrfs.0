From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Atomic file data replace API
Date: Fri, 07 Jan 2011 14:29:54 -0500
Message-ID: <1294428310-sup-9846@think>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com> <AANLkTi=o4w9wDoh6f8iaJF=vPQ-Xs1XBnJMbym08cOa-@mail.gmail.com> <1294416073-sup-5254@think> <201101071726.02958.hka@qbs.com.pl>
Content-Type: text/plain; charset=UTF-8
Cc: Olaf van der Spek <olafvdspek@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <201101071726.02958.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Hubert Kario's message of 2011-01-07 11:26:02 -0500:
> On Friday, January 07, 2011 17:12:11 Chris Mason wrote:
> > Excerpts from Olaf van der Spek's message of 2011-01-07 10:17:31 -0500:
> > > On Fri, Jan 7, 2011 at 4:13 PM, Chris Mason <chris.mason@oracle.com> 
> wrote:
> > > >> That's not what I asked. ;)
> > > >> I asked to wait until the first write (or close). That way, you don't
> > > >> get unintentional empty files.
> > > >> One step further, you don't have to keep the data in memory, you're
> > > >> free to write them to disk. You just wouldn't update the meta-data
> > > >> (yet).
> > > > 
> > > > Sorry ;) Picture an application that truncates 1024 files without
> > > > closing any of them.  Basically any operation that includes the kernel
> > > > waiting for applications because they promise to do something soon is
> > > > a denial of service attack, or a really easy way to run out of memory
> > > > on the box.
> > > 
> > > I'm not sure why you would run out of memory in that case.
> > 
> > Well, lets make sure I've got a good handle on the proposed interface:
> > 
> > 1) fd = open(some_file, O_ATOMIC)
> > 2) truncate(fd, 0)
> > 3) write(fd, new data)
> > 
> > The semantics are that we promise not to let the truncate hit the disk
> > until the application does the write.
> > 
> > We have a few choices on how we do this:
> > 
> > 1) Leave the disk untouched, but keep something in memory that says this
> > inode is really truncated
> > 
> > 2) Record on disk that we've done our atomic truncate but it is still
> > pending.  We'd need some way to remove or invalidate this record after a
> > crash.
> > 
> > 3) Go ahead and do the operation but don't allow the transaction to
> > commit until the write is done.
> > 
> > option #1: keep something in memory.  Well, any time we have a
> > requirement to pin something in memory until userland decides to do a
> > write, we risk oom.
> 
> Userland has already a file descriptor allocated (which can fail anyway 
> because of OOM), I see no problem in increasing the size of kernel memory 
> usage by 4 bytes (if not less) just to note that the application wants to see 
> the file as truncated (1 bit) and the next write has to be atomic (2nd bit?).
> 

The exact amount of tracking is going to vary.  The reason why is that
actually doing the truncate is an O(size of the file) operation and so
you can't just flip a switch when the write or the close comes in.  You
have to run through all the metadata of the file and do something
temporary with each part that is only completed when the file IO is
actually done.

Honestly, there many different ways to solve this in the application.
Requiring high speed atomic replacement of individual file contents is a
recipe for frustration.

-chris
