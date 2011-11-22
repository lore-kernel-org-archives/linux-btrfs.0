From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: Re: btrfs-delalloc - threaded?
Date: Tue, 22 Nov 2011 14:30:07 +0000 (UTC)
Message-ID: <slrnjcncff.cqt.stephane.chazelas@spam.is.invalid>
References: <CALjZLS5iA1TVJCVWSpE+Xg5hG_E1c+LVrFz2EJK2b=Xc7MQw_Q@mail.gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-09-6, 11:21(-05), Andrew Carlson:
> I was doing some testing with writing out data to a BTFS filesystem
> with the compress-force option.  With 1 program running, I saw
> btfs-delalloc taking about 1 CPU worth of time, much as could be
> expected.  I then started up 2 programs at the same time, writing data
> to the BTRFS volume.  btrfs-delalloc still only used 1 CPU worth of
> time.  Is btrfs-delalloc threaded, to where it can use more than 1 CPU
> worth of time?  Is there a threshold where it would start using more
> CPU?
[...]

Hiya,

I observe the same here. The bottleneck when writing data
sequencially seems to be that btrfs-delalloc using 100% of the
time of one CPU.

If I do several writes in parallel, a few more btrfs-delalloc's
appear (3 when filling up 5 files concurrently), but
btrfs-delalloc is still the bottleneck. Interestingly, if I
write to 10 files simultanously, I see only two btrfs-delalloc
and the throughput is lower.

That's on ubuntu 11.10 3.0.0-13 amd64, 12 core, 16GB DDR3
1333MHz RAM. raid10 on 6 drives.

Note that zfsonlinux does perform a lot better in that regard
(on a raidz (ZFS raid5) on those same 6 drives): 50% CPU
utilisation and max out the disk bandwidth.

-- 
Stephane

