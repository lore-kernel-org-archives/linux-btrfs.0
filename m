From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Interesting problem with write data.
Date: Thu, 18 Nov 2010 09:23:47 -0500
Message-ID: <1290090160-sup-1717@think>
References: <4CE51613.8060609@wpkg.org>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4CE51613.8060609@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tomasz Chmielewski's message of 2010-11-18 07:03:31 -0500:
> >   Recently, I made a btrfs to use. And I met slowness problem. Trying
> > to diag it. I found this:
> > 1. dd if=/dev/zero of=test count=1024 bs=1MB
> > This is fast, at about 25MB/s, and reasonable iowait.
> > 2. dd if=/dev/zero of=test count=1 bs=1GB
> > This is pretty slow, at about 1.5MB/s, and 90%+ iowait, constantly.
> >   May I know why it works like this? Thanks.
> 
> Reproducible here to some extent with 2.6.37-rc2.
> 
> Interesting is, it only happens for me when I mount the filesystem, dd a smaller file, then a bigger one, in that order.
> 
> Any subsequent dd / sync / rm usage doesn't seem to trigger it anymore (have to umount / mount again to trigger this).

I'm going to guess this is the flushing threads, could you please run
vmstat and see if there is a stream of reads?  sysrq-w during the second
dd would show it as well.

-chris
