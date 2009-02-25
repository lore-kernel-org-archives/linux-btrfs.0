From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs: warn_slowpath in clean_tree_block and others
Date: Wed, 25 Feb 2009 13:36:26 -0500
Message-ID: <1235586986.32346.48.camel@think.oraclecorp.com>
References: <20090224230249.GA6859@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090224230249.GA6859@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-02-24 at 23:02 +0000, Hugo Mills wrote:
> This is essentially a repost of a mail I made last week, to which I
> didn't get a reply.
> 

Sorry I missed replying to this one last week, thanks for resending.

>    I'm getting huge numbers of kernel warnings whilst using
> btrfs. They're all "warn_slowpath", and all seem to be in
> fs/btrfs/disk-io.c. I've included one typical example at the end of
> this mail.
> 
>    Kernel versions are 2.6.29-rc2, -rc4 and -rc6.
> 

The warnings look like i386, exactly what hardware is this?  Is your
kernel compiled for SMP or UP?

The warning you're getting is that clean_tree_block expects this block
to be locked, and giving out a warning because it is showing up as
unlocked.

So, hopefully you're on a UP kernel and my test for a locked spinlock is
broken in that config.

-chris


