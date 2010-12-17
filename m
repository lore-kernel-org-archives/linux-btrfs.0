From: Chris Mason <chris.mason@oracle.com>
Subject: Re: A rescue tool for btrfs
Date: Thu, 16 Dec 2010 19:39:42 -0500
Message-ID: <1292546177-sup-2921@think>
References: <20101217001849.1b5f4c28@simplux>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Michael Niederle <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20101217001849.1b5f4c28@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Michael Niederle's message of 2010-12-16 18:18:49 -0500:
> Hi!
> 
> Last week I crashed a btrfs file system. I didn't lose a lot of data because I
> had current backups of most data and a full backup from a month ago.
> 
> But I thought it would be a nice idea to have a rescue tool! Currently I have a
> first release of this tool (surely buggy and runnning on little endian
> architectures only).
> 
> The tool is written in C using the header files from the btrfs userland tools.
> I use a wrapper (written in a script language) to restore whole directories.
> Such a wrapper could also detect hard links and handle them correctly.
> 
> btrfs_rescue implements all disk accesses itself and tries to access only the
> absolute minimum of necessary data structures to avoid the pitfalls that lurk
> somewhere in the destroyed file system. So you can rescue parts of a destroyed
> file system even if the file system driver cannot mount it anymore.
> 
> The source code is available under
> 
> http://simplux.org/downloads/btrfs_rescue.c

A very good idea, its the same direction I'm going with the btrfsck code
right now.  The basic idea is that it is much more reliable (and faster
to implement) to pull data off the disk than it is to try and fix it in
place.  I'm growing some in place fixes as well for the really common
errors (especially power crashes w/o barriers)

If you're interested in doing more on this, I'll have my code up
shortly.

-chris
