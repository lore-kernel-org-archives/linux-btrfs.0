From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor read performance on high-end server
Date: Fri, 6 Aug 2010 07:41:44 -0400
Message-ID: <20100806114144.GB29846@think>
References: <4C5AC52D.9030906@sara.nl>
 <20100805145138.GJ29846@think>
 <4C5B2B42.3030407@sara.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>
To: Freek Dijkstra <Freek.Dijkstra@sara.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C5B2B42.3030407@sara.nl>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 05, 2010 at 11:21:06PM +0200, Freek Dijkstra wrote:
> Chris Mason wrote:
> 
> > Basically we have two different things to tune.  First the block layer
> > and then btrfs.
> 
> 
> > And then we need to setup a fio job file that hammers on all the ssds at
> > once.  I'd have it use adio/dio and talk directly to the drives.
> 
> Thanks. First one disk:
> 
> > f1: (groupid=0, jobs=1): err= 0: pid=6273
> >   read : io=32780MB, bw=260964KB/s, iops=12, runt=128626msec
> >     clat (usec): min=74940, max=80721, avg=78449.61, stdev=923.24
> >     bw (KB/s) : min=240469, max=269981, per=100.10%, avg=261214.77, stdev=2765.91
> >   cpu          : usr=0.01%, sys=2.69%, ctx=1747, majf=0, minf=5153
> >   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >      issued r/w: total=1639/0, short=0/0
> > 
> >      lat (msec): 100=100.00%
> > 
> > Run status group 0 (all jobs):
> >    READ: io=32780MB, aggrb=260963KB/s, minb=267226KB/s, maxb=267226KB/s, mint=128626msec, maxt=128626msec
> > 
> > Disk stats (read/write):
> >   sdd: ios=261901/0, merge=0/0, ticks=10135270/0, in_queue=10136460, util=99.30%
> 
> So 255 MiByte/s.
> Out of curiousity, what is the distinction between the reported figures
> of 260964 kiB/s, 261214.77 kiB/s, 267226 kiB/s and 260963 kiB/s?

When there is only one job, they should all be the same.  aggr is the
total seen across all the jobs, min is the lowest, max is the highest.

> 
> 
> Now 16 disks (abbreviated):
> 
> > ~/fio# ./fio ssd.fio
> > Starting 16 processes
> > f1: (groupid=0, jobs=1): err= 0: pid=4756
> >   read : io=32780MB, bw=212987KB/s, iops=10, runt=157600msec
> >     clat (msec): min=75, max=138, avg=96.15, stdev= 4.47
> >      lat (msec): min=75, max=138, avg=96.15, stdev= 4.47
> >     bw (KB/s) : min=153121, max=268968, per=6.31%, avg=213181.15, stdev=9052.26
> >   cpu          : usr=0.00%, sys=1.71%, ctx=2737, majf=0, minf=5153
> >   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >      issued r/w: total=1639/0, short=0/0
> > 
> >      lat (msec): 100=97.99%, 250=2.01%
> > Run status group 0 (all jobs):
> >    READ: io=524480MB, aggrb=3301MB/s, minb=216323KB/s, maxb=219763KB/s, mint=156406msec, maxt=158893msec

> So, the maximum for these 16 disks is 3301 MiByte/s.
> 
> I also tried hardware RAID (2 sets of 8 disks), and got a similar result:
> 
> > Run status group 0 (all jobs):
> >    READ: io=65560MB, aggrb=3024MB/s, minb=1548MB/s, maxb=1550MB/s, mint=21650msec, maxt=21681msec

Great, so we know the drives are fast.

> 
> 
> 
> > fio should be able to push these devices up to the line speed.  If it
> > doesn't I would suggest changing elevators (deadline, cfq, noop) and
> > bumping the max request size to the max supported by the device.
> 
> 3301 MiByte/s seems like a reasonable number, given the theoretic
> maximum of 16 times the single disk performance of 16*256 MiByte/s =
> 4096 MiByte/s.
> 
> Based on this, I have not looked at tuning. Would you recommend that I do?
> 
> Our minimal goal is 2500 MiByte/s; that seems achievable as ZFS was able
> to reach 2750 MiByte/s without tuning.
> 
> > When we have a config that does so, we can tune the btrfs side of things
> > as well.
> 
> Some files are created in the root folder of the mount point, but I get
> errors instead of results:
> 

Someone else mentioned that btrfs only gained DIO reads in 2.6.35.  I
think you'll get the best results with that kernel if you can find an
update.

If not, you can change the fio job file to remove direct=1 and increase the
bs flag up to 20M.

I'd also suggest changing /sys/class/bdi/btrfs-1/read_ahead_kb to a
bigger number.  Try 20480

-chris
