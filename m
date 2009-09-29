From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Clone range ioctl
Date: Tue, 29 Sep 2009 12:51:22 -0400
Message-ID: <20090929165122.GB2650@think>
References: <20090926194617.GW7592@blitiri.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alberto Bertogli <albertito@blitiri.com.ar>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090926194617.GW7592@blitiri.com.ar>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 26, 2009 at 04:46:20PM -0300, Alberto Bertogli wrote:
> 
> Hi!
> 
> Out of curiosity for btrfs, I'm modifying a project of mine
> (http://blitiri.com.ar/p/libjio) to use the clone range ioctl, and I've got a
> couple of questions. I thought this would be the place to ask them, I hope you
> don't mind:
> 
> - Once the ioctl() returns successfully, is data supposed to be on the disk,
>   or should I sync it manually (fdatasync()/sync_file_range())? From a quick
>   peek at the code it seems the former, but it'd be nice to get confirmation.

Yes, when the ioctl is done the file is on disk.  This is more of an
accident of the implementation than a requirement, but it isn't going to
change.

> - I've hit a couple of bugs (2.6.31's fs/btrfs/file.c:528, for example);
>   should I take a look and report them, or this code is not expected to work
>   yet?

I think this one was fixed by Sage, if you pull from the btrfs-unstable
git tree's master branch it should be resolved.

> - Are there any special considerations an application should take when using
>   it?

Since cloning reuses existing blocks, it may cause more seeking on reads
than a pure copy.

> - Since I need to use block-aligned offsets, how can I find out the
>   appropriate block size for a given file without being root? I've hardcoded
>   it to 4k for the time being, but I couldn't find out how to ask the
>   filesystem except for the BLKGETBSZ, which requires being root. I'm
>   obviously ok with a btrfs-only solution.

For btrfs you'll be safe using the page size.

> 
> If anyone could answer any of these (or point me to the relevant code), I'd
> really appreciate it.

Thanks for giving things a try.

-chris

