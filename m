Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:50575 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbeBPToM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Feb 2018 14:44:12 -0500
Received: by mail-it0-f51.google.com with SMTP id y16so3041389itc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Feb 2018 11:44:12 -0800 (PST)
Subject: Re: Ongoing Btrfs stability issues
To: Alex Adriaanse <alex@oseberg.io>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
Date: Fri, 16 Feb 2018 14:44:07 -0500
MIME-Version: 1.0
In-Reply-To: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-02-15 11:18, Alex Adriaanse wrote:
> We've been using Btrfs in production on AWS EC2 with EBS devices for over 2 years. There is so much I love about Btrfs: CoW snapshots, compression, subvolumes, flexibility, the tools, etc. However, lack of stability has been a serious ongoing issue for us, and we're getting to the point that it's becoming hard to justify continuing to use it unless we make some changes that will get it stable. The instability manifests itself mostly in the form of the VM completely crashing, I/O operations freezing, or the filesystem going into readonly mode. We've spent an enormous amount of time trying to recover corrupted filesystems, and the time that servers were down as a result of Btrfs instability has accumulated to many days.
> 
> We've made many changes to try to improve Btrfs stability: upgrading to newer kernels, setting up nightly balances, setting up monitoring to ensure our filesystems stay under 70% utilization, etc. This has definitely helped quite a bit, but even with these things in place it's still unstable. Take https://bugzilla.kernel.org/show_bug.cgi?id=198787 for example, which I created yesterday: we've had 4 VMs (out of 20) go down over the past week alone because of Btrfs errors. Thankfully, no data was lost, but I did have to copy everything over to a new filesystem.
> 
> Many of our VMs that run Btrfs have a high rate of I/O (both read/write; I/O utilization is often pegged at 100%). The filesystems that get little I/O seem pretty stable, but the ones that undergo a lot of I/O activity are the ones that suffer from the most instability problems. We run the following balances on every filesystem every night:
> 
>      btrfs balance start -dusage=10 <fs>
>      btrfs balance start -dusage=20 <fs>
>      btrfs balance start -dusage=40,limit=100 <fs>
I would suggest changing this to eliminate the balance with '-dusage=10' 
(it's redundant with the '-dusage=20' one unless your filesystem is in 
pathologically bad shape), and adding equivalent filters for balancing 
metadata (which generally goes pretty fast).

Unless you've got a huge filesystem, you can also cut down on that limit 
filter.  100 data chunks that are 40% full is up to 40GB of data to move 
on a normally sized filesystem, or potentially up to 200GB if you've got 
a really big filesystem (I forget what point BTRFS starts scaling up 
chunk sizes at, but I'm pretty sure it's in the TB range).
> 
> We also use the following btrfs-snap cronjobs to implement rotating snapshots, with short-term snapshots taking place every 15 minutes and less frequent ones being retained for up to 3 days:
> 
>      0 1-23 * * * /opt/btrfs-snap/btrfs-snap -r <fs> 23
>      15,30,45 * * * * /opt/btrfs-snap/btrfs-snap -r <fs> 15m 3
>      0 0 * * * /opt/btrfs-snap/btrfs-snap -r <fs> daily 3
> 
> Our filesystems are mounted with the "compress=lzo" option.
> 
> Are we doing something wrong? Are there things we should change to improve stability? I wouldn't be surprised if eliminating snapshots would stabilize things, but if we do that we might as well be using a filesystem like XFS. Are there fixes queued up that will solve the problems listed in the Bugzilla ticket referenced above? Or is our I/O-intensive workload just not a good fit for Btrfs?

This will probably sound like an odd question, but does BTRFS think your 
storage devices are SSD's or not?  Based on what you're saying, it 
sounds like you're running into issues resulting from the 
over-aggressive SSD 'optimizations' that were done by BTRFS until very 
recently.

You can verify if this is what's causing your problems or not by either 
upgrading to a recent mainline kernel version (I know the changes are in 
4.15, I don't remember for certain if they're in 4.14 or not, but I 
think they are), or by adding 'nossd' to your mount options, and then 
seeing if you still have the problems or not (I suspect this is only 
part of it, and thus changing this will reduce the issues, but not 
completely eliminate them).  Make sure and run a full balance after 
changing either item, as the aforementioned 'optimizations' have an 
impact on how data is organized on-disk (which is ultimately what causes 
the issues), so they will have a lingering effect if you don't balance 
everything.

'autodefrag' is the other mount option that I would try toggling (turn 
it off if you've got it on, or on if you've got it off).  I doubt it 
will have much impact, but it does change how things end up on disk.

Additionally to all that, make sure your monitoring isn't just looking 
at the regular `df` command's output, it's woefully insufficient for 
monitoring space usage on BTRFS.  If you want to check things properly, 
you want to be looking at the data in /sys/fs/btrfs/<UUID>/allocation, 
more specifically checking the following percentages:

1. The sum of the values in /sys/fs/btrfs/<UUID/allocation/*/disk_total 
relative to the sum total of the size of the block devices for the 
filesystem.
2. The ratio of /sys/fs/btrfs/<UUID>/allocation/data/bytes_used to 
/sys/fs/btrfs/<UUID>/allocation/data/total_bytes.
3. The ratio of /sys/fs/btrfs/<UUID>/allocation/metadata/bytes_used to 
/sys/fs/btrfs/<UUID>/allocation/metadata/total_bytes.
4. The ratio of /sys/fs/btrfs/<UUID>/allocation/system/bytes_used to 
/sys/fs/btrfs/<UUID>/allocation/system/total_bytes.

Regular `df` effectively reports the total of items 2, 3, and 4, but 
those don't really matter unless item 1 is also close to 100%.

Of those, you ideally want the first percentage (which is how much space 
BTRFS has allocated at the upper level in it's two-level allocator) to 
be less than 80 or 90 percent (unless you have a very small filesystem, 
in which case you should try to keep about 2.5GB free, which is enough 
for two data allocations and two metadata allocations), and in most 
cases you want the other three to be as close to 100% as possible 
(higher values there mean less space wasted at the higher allocation 
level).  If that first percentage gets up to 100%, and one of the others 
hits 100%, you'll get -ENOSPC for certain system calls (which ones 
depends on which of the others is at 100%), but traditional `df` can 
still show much less than 100% utilization.
