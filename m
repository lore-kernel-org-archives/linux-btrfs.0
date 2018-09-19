Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr30069.outbound.protection.outlook.com ([40.107.3.69]:52499
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726925AbeISXh2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 19:37:28 -0400
Subject: Re: very poor performance / a lot of writes to disk with space_cache
 (but not with space_cache=v2)
To: Tomasz Chmielewski <tch@virtall.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e0f21dace16885d1bd615dd723235d57@virtall.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <e712843a-d902-97c1-7270-84dfe56c83e1@mendix.com>
Date: Wed, 19 Sep 2018 19:58:18 +0200
MIME-Version: 1.0
In-Reply-To: <e0f21dace16885d1bd615dd723235d57@virtall.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 09/19/2018 10:43 AM, Tomasz Chmielewski wrote:
> I have a mysql slave which writes to a RAID-1 btrfs filesystem (with
> 4.17.14 kernel) on 3 x ~1.9 TB SSD disks; filesystem is around 40% full.
> 
> The slave receives around 0.5-1 MB/s of data from the master over the
> network, which is then saved to MySQL's relay log and executed. In ideal
> conditions (i.e. no filesystem overhead) we should expect some 1-3 MB/s
> of data written to disk.
> 
> MySQL directory and files in it are chattr +C (since the directory was
> created, so all files are really +C); there are no snapshots.
> 
> 
> Now, an interesting thing.
> 
> When the filesystem is mounted with these options in fstab:
> 
> defaults,noatime,discard
> 
> We can see a *constant* write of 25-100 MB/s to each disk. The system is
> generally unresponsive and it sometimes takes long seconds for a simple
> command executed in bash to return.

Did you already test the difference with/without 'discard'? Also, I
think that depending on the tooling that you use to view disk IO,
discards will also show up as disk write statistics.

> However, as soon as we remount the filesystem with space_cache=v2 -
> writes drop to just around 3-10 MB/s to each disk. If we remount to
> space_cache - lots of writes, system unresponsive. Again remount to
> space_cache=v2 - low writes, system responsive.
> 
> That's a huuge, 10x overhead! Is it expected? Especially that
> space_cache=v1 is still the default mount option?

Yes, that does not surprise me.

https://events.static.linuxfound.org/sites/events/files/slides/vault2016_0.pdf

Free space cache v1 is the default because of issues with btrfs-progs,
not because it's unwise to use the kernel code. I can totally recommend
using it. The linked presentation above gives some good background
information.

Another thing that's interesting is finding out what kind of things
btrfs is writing if it's writing that much MB/s to disk. Doing this is
not very trivial.

I've been spending quite some time researching these kind of issues.

Here's what I found out:
https://www.spinics.net/lists/linux-btrfs/msg70624.html (oh wow, that's
almost a year ago already)

There are a bunch of tracepoints in the kernel code that could help
debugging all of this more, but I've not yet gotten around to writing
something to conveniently to use them to live show what's happening.

I'm still using the "Thanks to a bug, solved in [2]" in the above
mailing list post way of combining extent allocators in btrfs now to
keep things workable on the larger filesystem.

-- 
Hans van Kranenburg
