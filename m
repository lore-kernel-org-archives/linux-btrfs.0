From: Chris Mason <chris.mason@oracle.com>
Subject: Re: parity data
Date: Mon, 08 Sep 2008 10:47:51 -0400
Message-ID: <1220885271.8537.31.camel@think.oraclecorp.com>
References: <1220766185.20018.7.camel@telesto>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Eric Anopolsky <erpo41@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1220766185.20018.7.camel@telesto>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2008-09-06 at 23:43 -0600, Eric Anopolsky wrote:
> Hi,
> 
> A couple of questions.
> 
> 1. Does btrfs currently have anything like raid 5 or 6?
> 

Not yet, it might one day.

> 2. One guy on my LUG's mailing list is really excited about the
> potential for setting redundancy on a per-file basis.
> I.e. /home/eric/criticalfile gets mirrored across all of the drives in
> the filesystem but /home/eric/temporaryfile gets striped. I'm skeptical.
> Is it a good idea to allow people/programs to do this?

In general, yes.  Some files or directories are crucial, and some (swap
for example) don't need to survive a crash.

But, I think the flexibility should go a little further.  The goal is to
be able to define drive groups and tie files or directory trees to the
drive groups.  That way you can say these files go to the fastest drives
and these files go to some other drive type, etc etc.

-chris


