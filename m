From: Simon Farnsworth <simon@farnz.org.uk>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 06 Jan 2011 12:18:34 +0000
Message-ID: <ig4bur$mns$1@dough.gmane.org>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <4D24AD92.4070107@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Gordan Bobic wrote:

> Josef Bacik wrote:
> 
>> Basically I think online dedup is huge waste of time and completely
>> useless.
> 
> I couldn't disagree more. First, let's consider what is the
> general-purpose use-case of data deduplication. What are the resource
> requirements to perform it? How do these resource requirements differ
> between online and offline?
<snip>

> As an aside, zfs and lessfs both do online deduping, presumably for a
> good reason.
> 
> Then again, for a lot of use-cases there are perhaps better ways to
> achieve the targed goal than deduping on FS level, e.g. snapshotting or
> something like fl-cow:
> http://www.xmailserver.org/flcow.html
> 
Just a small point; Josef's work provides a building block for a userspace 
notify-based online dedupe daemon.

The basic idea is to use fanotify/inotify (whichever of the notification 
systems works for this) to track which inodes have been written to. It can 
then mmap() the changed data (before it's been dropped from RAM) and do the 
same process as an offline dedupe (hash, check for matches, call dedupe 
extent ioctl). If you've got enough CPU (maybe running with realtime privs), 
you should be able to do this before writes actually hit the disk.

Further, a userspace daemon can do more sophisticated online dedupe than is 
reasonable in the kernel - e.g. queue the dedupe extent ioctl phase for idle 
time, only dedupe inodes that have been left unwritten for x minutes, 
different policies for different bits of the filesystem (dedupe crontabs 
immediately on write, dedupe outgoing mail spool only when the mail sticks 
around for a while, dedupe all incoming mail immediately, dedupe logfiles 
after rotation only, whatever is appropriate).

It can also do more intelligent trickery than is reasonable in-kernel - e.g. 
if you know that you're deduping e-mail (line-based), you can search line-
by-line for dedupe blocks, rather than byte-by-byte.

Having said all that, you may well find that having implemented a userspace 
online dedupe daemon, there are things the kernel can do to help; you may 
even find that you do need to move it entirely into the kernel. Just don't 
think that this ioctl rules out online dedupe - in fact, it enables it.

-- 
Simon Farnsworth

