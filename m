From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs slowdown
Date: Mon, 25 Jul 2011 15:52:50 -0400
Message-ID: <1311623446-sup-8105@shiny>
References: <CAO47_-9BLKWUGDEuzaLqHSq9tZkAUaO8FMQEy1pPk9A2Hb+5AQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	ceph-devel <ceph-devel@vger.kernel.org>
To: Christian Brunner <chb@muc.de>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-reply-to: <CAO47_-9BLKWUGDEuzaLqHSq9tZkAUaO8FMQEy1pPk9A2Hb+5AQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Christian Brunner's message of 2011-07-25 03:54:47 -0400:
> Hi,
> 
> we are running a ceph cluster with btrfs as it's base filesystem
> (kernel 3.0). At the beginning everything worked very well, but after
> a few days (2-3) things are getting very slow.
> 
> When I look at the object store servers I see heavy disk-i/o on the
> btrfs filesystems (disk utilization is between 60% and 100%). I also
> did some tracing on the Cepp-Object-Store-Daemon, but I'm quite
> certain, that the majority of the disk I/O is not caused by ceph or
> any other userland process.
> 
> When reboot the system(s) the problems go away for another 2-3 days,
> but after that, it starts again. I'm not sure if the problem is
> related to the kernel warning I've reported last week. At least there
> is no temporal relationship between the warning and the slowdown.
> 
> Any hints on how to trace this would be welcome.

The easiest way to trace this is with latencytop.

Apply this patch:

http://oss.oracle.com/~mason/latencytop.patch

And then use latencytop -c for a few minutes while the system is slow.
Send the output here and hopefully we'll be able to figure it out.

-chris
