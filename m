From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [BUG 3.0-rc1] oops during file removal, severe lock contention
Date: Thu, 02 Jun 2011 18:21:22 -0400
Message-ID: <1307053107-sup-492@shiny>
References: <20110602011139.GP561@dastard>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110602011139.GP561@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Dave Chinner's message of 2011-06-01 21:11:39 -0400:
> Hi Folks,
> 
> Running on 3.0-rc1 on an 8p/4G RAM VM with a 16TB filesystem (12
> disk DM stripe) a 50 million inode 8-way fsmark creation workload
> via:
> 
> $ /usr/bin/time ./fs_mark -D 10000 -S0 -n 100000 -s 0 -L 63 \
> > -d /mnt/scratch/0 -d /mnt/scratch/1 \
> > -d /mnt/scratch/2 -d /mnt/scratch/3 \
> > -d /mnt/scratch/4 -d /mnt/scratch/5 \
> > -d /mnt/scratch/6 -d /mnt/scratch/7
> 
> followed by an 8-way rm -rf on the result via:
> 
> $ for i in /mnt/scratch/*; do /usr/bin/time rm -rf $i 2>&1 & done
> 
> resulted in this oops:

Josef is looking at this one, we have a theory.

> 
> Also, there is massive lock contention while running these workloads.
> perf top shows this for the create after about 5m inodes have been
> created:

For the fs_mark workload, the lock contention mostly goes away if you
do:

btrfs subvol create /mnt/scratch/0
btrfs subvol create /mnt/scratch/1
btrfs subvol create /mnt/scratch/2
...
btrfs subvol create /mnt/scratch/8

(etc)

This switches one btree root for 8 btree roots.

I'm working on really fixing that as well.

-chris
