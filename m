From: Simon Farnsworth <simon@farnz.org.uk>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 06 Jan 2011 13:30:30 +0000
Message-ID: <ig4g5m$67u$1@dough.gmane.org>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <4D24AD92.4070107@bobich.net> <ig4bur$mns$1@dough.gmane.org> <4D25B58E.2080208@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Gordan Bobic wrote:

> Simon Farnsworth wrote:
> 
>> The basic idea is to use fanotify/inotify (whichever of the notification
>> systems works for this) to track which inodes have been written to. It
>> can then mmap() the changed data (before it's been dropped from RAM) and
>> do the same process as an offline dedupe (hash, check for matches, call
>> dedupe extent ioctl). If you've got enough CPU (maybe running with
>> realtime privs), you should be able to do this before writes actually hit
>> the disk.
> 
> I'm not convinced that racing against the disk write is the way forward
> here.
> 
The point is that implementing a userspace online dedupe daemon that races 
against the disk write is something that can be done by anyone who cares as 
soon as Josef's patch is in place; if it's clear that the userspace daemon 
just does something simple enough to put in the kernel (e.g. a fixed block 
size dedupe), and that extra complexity doesn't gain enough to be 
worthwhile, the code can be ported into the kernel before it gets posted 
here.

Similarly, if you're convinced that it has to be in kernel (I'm not a dedupe 
or filesystems expert, so there may be good reasons I'm unaware of), you can 
reuse parts of Josef's code to write your patch that creates a kernel thread 
to do the work.

If it turns out that complex algorithms for online dedupe are worth the 
effort (like line-by-line e-mail dedupe), then you've got a starting point 
for writing something more complex, and determining just what the kernel 
needs to provide to make things nice - maybe it'll be clear that you need an 
interface that lets you hold up a write while you do the simple end of the 
dedupe work, maybe there will be some other kernel interface that's more 
generic than "dedupe fixed size blocks" that's needed for efficient work.

Either way, Josef's work is a good starting point for online dedupe; you can 
experiment *now* without going into kernel code (heck, maybe even not C - 
Python or Perl would be OK for algorithm exploration), and use the offline 
dedupe support to simplify a patch for online dedupe.

-- 
Simon Farnsworth

