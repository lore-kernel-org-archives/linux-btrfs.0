From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor read performance on high-end server
Date: Thu, 5 Aug 2010 10:51:38 -0400
Message-ID: <20100805145138.GJ29846@think>
References: <4C5AC52D.9030906@sara.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, axboe@kernel.dk
To: Freek Dijkstra <Freek.Dijkstra@sara.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C5AC52D.9030906@sara.nl>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 05, 2010 at 04:05:33PM +0200, Freek Dijkstra wrote:
> Hi,
> 
> We're interested in getting the highest possible read performance on a
> server. To that end, we have a high-end server with multiple solid state
> disks (SSDs). Since BtrFS outperformed other Linux filesystem, we choose
> that. Unfortunately, there seems to be an upper boundary in the
> performance of BtrFS of roughly 1 GiByte/s read speed. Compare the
> following results with either BTRFS on Ubuntu versus ZFS on FreeBSD:

Really cool, thanks for posting this.

> 
>              ZFS             BtrFS
> 1 SSD      256 MiByte/s     256 MiByte/s
> 2 SSDs     505 MiByte/s     504 MiByte/s
> 3 SSDs     736 MiByte/s     756 MiByte/s
> 4 SSDs     952 MiByte/s     916 MiByte/s
> 5 SSDs    1226 MiByte/s     986 MiByte/s
> 6 SSDs    1450 MiByte/s     978 MiByte/s
> 8 SSDs    1653 MiByte/s     932 MiByte/s
> 16 SSDs   2750 MiByte/s     919 MiByte/s
> 
> The results were originally measured on a Dell PowerEdge T610, but were
> repeated using a SuperMicro machine with 4 independent SAS+SATA
> controllers. We made sure that the PCI-e slots where not the bottleneck.
> The above results were for Ubuntu 10.04.1 server, with BtrFS v0.19,
> although earlier tests with Ubuntu 9.10 showed the same results.

Which kernels are those?

Basically we have two different things to tune.  First the block layer
and then btrfs.

Can I ask you to do a few experiments?  First grab fio:

http://brick.kernel.dk/snaps/fio-git-latest.tar.gz

And then we need to setup a fio job file that hammers on all the ssds at
once.  I'd have it use adio/dio and talk directly to the drives.  I'd do
something like this for the fio job file, but Jens Axboe is cc'd and he
might make another suggestion on the job file.  I'd do something like
this in a file named ssd.fio

[global]
size=32g
direct=1
iodepth=8
bs=20m
rw=read

[f1]
filename=/dev/sdd
[f2]
filename=/dev/sde
[f3]
filename=/dev/sdf

repeat for all the drives, then run fio ssd.fio

fio should be able to push these devices up to the line speed.  If it
doesn't I would suggest changing elevators (deadline, cfq, noop) and
bumping the max request size to the max supported by the device.

When we have a config that does so, we can tune the btrfs side of things
as well.  The btrfs job file would look something like this:

[global]
size=32g
direct=1
iodepth=8
bs=20m
rw=read

[btrfs]
directory=/btrfs_mount_point
# experiment with numjobs
numjobs=16


My first guess is just that your IOs are not large enough w/btrfs.  The
iozone command below is doing buffered reads, so our performance is
going to be limited by the kernel readahead buffer size.

If you use a much larger IO size (the fio job above reads in 20M chunks)
and aio/dio instead, you can have more control over how the IO goes down
to the device.

-chris
