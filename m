From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Interesting problem with write data.
Date: Thu, 18 Nov 2010 10:07:11 -0500
Message-ID: <1290092740-sup-9020@think>
References: <4CE51613.8060609@wpkg.org> <1290090160-sup-1717@think> <4CE53EDE.0@wpkg.org>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4CE53EDE.0@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tomasz Chmielewski's message of 2010-11-18 09:57:34 -0500:
> On 18.11.2010 15:23, Chris Mason wrote:
> > Excerpts from Tomasz Chmielewski's message of 2010-11-18 07:03:31 -0500:
> >>>    Recently, I made a btrfs to use. And I met slowness problem. Trying
> >>> to diag it. I found this:
> >>> 1. dd if=/dev/zero of=test count=1024 bs=1MB
> >>> This is fast, at about 25MB/s, and reasonable iowait.
> >>> 2. dd if=/dev/zero of=test count=1 bs=1GB
> >>> This is pretty slow, at about 1.5MB/s, and 90%+ iowait, constantly.
> >>>    May I know why it works like this? Thanks.
> >>
> >> Reproducible here to some extent with 2.6.37-rc2.
> >>
> >> Interesting is, it only happens for me when I mount the filesystem, dd a smaller file, then a bigger one, in that order.
> >>
> >> Any subsequent dd / sync / rm usage doesn't seem to trigger it anymore (have to umount / mount again to trigger this).
> > 
> > I'm going to guess this is the flushing threads, could you please run
> > vmstat and see if there is a stream of reads?
> 
> I guess you meant this during the second dd run:
> 
> [27821.906513] btrfs-cache-8 D ffff88050c5fde98     0  8089      2 0x00000000
> [27821.906517]  ffff88051c3a9b60 0000000000000046 ffff88051c3a9b00 ffff88051c3a9fd8
> [27821.906522]  00000000000139c0 00000000000139c0 ffff88051c3a9fd8 ffff88051c3a9fd8
> [27821.906526]  00000000000139c0 ffff88050c5fde98 ffff88050c5fdea0 ffff88050c5fdb00
> [27821.906530] Call Trace:
> [27821.906534]  [<ffffffff8159fc4e>] io_schedule+0x5e/0xa0
> [27821.906538]  [<ffffffff81109f15>] sync_page+0x45/0x60

So, you're caching block groups.  What you want to do is use Josef's new
block group caching code.

mount -o space_cache /dev/xxx

Do the test and let the caching threads finish, then unmount and then
your next run should be fast.

-chris
