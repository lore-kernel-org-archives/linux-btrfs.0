From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: [PATCH] Backport for 2.6.27 and 2.6.26 on the experimental
	branch
Date: Mon, 23 Feb 2009 17:23:04 -0500
Message-ID: <20090223222304.GB13878@tux64-01>
References: <20090220174518.GA23955@tux64-01> <499EF58F.6020807@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lee Trager <lt73@cs.drexel.edu>, linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <499EF58F.6020807@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 20, 2009 at 01:25:19PM -0500, jim owens wrote:
> lee,
>
> A couple of thoughts about your .26 lockup:
>
> - I assume you are on the same hardware with 27.
I am.
>
> - Are you using a module or builtin btrfs (I build it in).
>
As a module
> - It looks like you are using vmware... when I'm doing kernel
>   stuff I want to be on the iron, not trusting virtual machine code.
>   (people who use vmware tell me they have to rebuild vmware stuff
>    even when they apply kernel patch distro updates)
I tried running the same code(on 27 and 26) on a physical machine running Debian Lenny and ran into the same problem. So I don't think its vmware.
>
> - Compare your .26 and .27 configs, changes to default io sched
>   or vm etc. can hurt or help you.
I used the standard Debian Lenny 2.6.26 kernel for testing. For 2.6.27 I
tested against the config for lenny found in the Debian svn. The only
differences seems to be the new features.
>
> jim

The more and more I look at this problem the more I tend to think that
the issue is because of some change in the way the VFS or something
interacts with the file system. Does anyone know of any big changes? Why
is the inode being marked dirty? Is there some kind of read error. I'm
completly lost in solving this problem.

Thanks for all your help,

Lee
