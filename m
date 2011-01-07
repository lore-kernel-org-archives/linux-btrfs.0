From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Atomic file data replace API
Date: Fri, 07 Jan 2011 09:58:31 -0500
Message-ID: <1294412141-sup-1734@think>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Olaf van der Spek's message of 2011-01-06 15:01:15 -0500:
> Hi,
> 
> Does btrfs support atomic file data replaces? Basically, the atomic
> variant of this:
> // old stage
> open(O_TRUNC)
> write() // 0+ times
> close()
> // new state

Yes and no.  We have a best effort mechanism where we try to guess that
since you've done this truncate and the write that you want the writes
to show up quickly.  But its a guess.

The problem is the write() // 0+ times.  The kernel has no idea what
new result you want the file to contain because the application isn't
telling us.

What btrfs can do (but we haven't yet implemented) is make sure that the
results of a single write file are on disk atomically, even if they are
replacing existing bytes in the file.

Because we cow and because we don't update metadata pointers until the
IO is complete, we can wait until all the IO for a given write call is
on disk before we update any of the metadata.

This isn't hard, it's on my TODO list.

-chris
